#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")

# Loop through the csv file and pipe into script
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do

  # If YEAR != year
  if [[ $YEAR != year ]]
    then
      # INSERT INTO TEAMS FIRST
      # ADD ENTRY
      # Get teams id
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      # If WINNER_ID is null
      if [[ -z $WINNER_ID ]]
        then
          # insert into teams
          INSERT_WINNER_ID_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
          # check result
          if [[ $INSERT_WINNER_ID_RESULT == "INSERT 0 1" ]]
            then
              echo Inserted into teams, $WINNER
          fi
          # get new id
          WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      fi
      # If OPPONENT_ID is null
      if [[ -z $OPPONENT_ID ]]
        then
          # insert into teams
          INSERT_OPPONENT_ID_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
          # check result
          if [[ $INSERT_OPPONENT_ID_RESULT == "INSERT 0 1" ]]
            then
              echo Inserted into teams, $OPPONENT
          fi
          # get new id
          OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      fi
    
    # INSERT INTO GAMES (LONG)
    INSERT_INTO_GAMES=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)")
    # check result
    if [[ $INSERT_WINNER_ID_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into games
    fi
  fi
done
