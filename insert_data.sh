#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals; do
  if [[ $winner != winner ]]; then
    WINNER_TEAM_ID=$($PSQL "select team_id from teams where name = '$winner'")

    if [[ -z $WINNER_TEAM_ID ]]; then
      WINNER_TEAM_RESULT=$($PSQL "insert into teams (name) values ('$winner')")
      WINNER_TEAM_ID=$($PSQL "select team_id from teams where name = '$winner'")
    fi

    OPPONENT_TEAM_ID=$($PSQL "select team_id from teams where name = '$opponent'")
    if [[ -z $OPPONENT_TEAM_ID ]]; then
      OPPONENT_TEAM_RESULT=$($PSQL "insert into teams (name) values ('$opponent')")
      OPPONENT_TEAM_ID=$($PSQL "select team_id from teams where name = '$opponent'")
    fi
    echo $(echo $WINNER_TEAM_ID | sed 's/"INSERT 0 "//') $(echo $OPPONENT_TEAM_ID | sed 's/"INSERT 0 "//')
    GAME_ID_RESULT=$($PSQL "insert into games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) values ($year, '$round', $WINNER_TEAM_ID, $OPPONENT_TEAM_ID, $winner_goals, $opponent_goals)")
  fi
done
