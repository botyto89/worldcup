#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
$PSQL "TRUNCATE TABLE games, teams"

ADD_TEAM_NAME() {
#if [[ $1 != "winner" && $1 != "opponent" ]]
#hen
TEAM_EXIST=$($PSQL "SELECT name FROM teams WHERE name='$1'")
if [[ -z $TEAM_EXIST ]]
then
  TEAM_ADDED=$($PSQL "INSERT INTO teams(name) VALUES ('$1')")
  echo -e "\nTeam name added $1"
fi
#fi
}

# Function to add each game info to the gams
ADD_GAME_INFO() {
  # $1 YEAR, $2 ROUND, $3 WINNER ID
  # $4 OPPONENT ID, $5 WINNER GOALS
  # $6 OPPONENT GOALS
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$3'")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$4'")
  ADDED_ROW=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES ($1,'$2',$WINNER_ID,$OPPONENT_ID,$5,$6)")
}

# Reset id index to make it looks better
ALTER SEQUENCE teams_team_id_seq
ALTER SEQUENCE games_game_id_seq

LINE_COUNT=1
cat games.csv | while IFS=, read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if (( LINE_COUNT!=1 ))
then
  # Add team to the teams table
  ADD_TEAM_NAME "$WINNER"
  ADD_TEAM_NAME "$OPPONENT"
  # Add game info to the gamse table
fi
LINE_COUNT=$((LINE_COUNT+1))
done

# Reset id index to make it looks better
ALTER SEQUENCE games_game_id_seq
LINE_COUNT=1
cat games.csv | while IFS=, read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if (( LINE_COUNT!=1 ))
then
  # Add game info to the gamse table
  echo "Function working $LINE_COUNT"
  ADD_GAME_INFO $YEAR "$ROUND" "$WINNER" "$OPPONENT" $WINNER_GOALS $OPPONENT_GOALS
fi
LINE_COUNT=$((LINE_COUNT+1))
done