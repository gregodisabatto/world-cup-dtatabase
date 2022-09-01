#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

CLEAN_TABLES=$($PSQL "TRUNCATE TABLE teams, games;")

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do

  if [[ $WINNER != 'winner' ]]
  then
    WINNER_NAME=$($PSQL "SELECT name FROM teams WHERE name = '$WINNER';")

    if [[ -z $WINNER_NAME ]]
    then
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")
      if [[ $INSERT_WINNER_RESULT == 'INSERT 0 1' ]] 
      then
        echo "Inserted '$WINNER'"
      fi
    fi
  fi

  if [[ $OPPONENT != 'opponent' ]]
  then
  OPPONENT_NAME=$($PSQL "SELECT name FROM teams WHERE name = '$OPPONENT';")

    if [[ -z $OPPONENT_NAME ]]
    then
      INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")
      if [[ $INSERT_OPPONENT_RESULT == 'INSERT 0 1' ]] 
      then
        echo "Inserted '$OPPONENT'"
      fi
    fi

  fi

  if [[ $YEAR != 'year' ]]
  then
    #get winner id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER';")
    #get opponent id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT';")
    #insert row
    INSERT_ROW_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);")
    if [[ $INSERT_ROW_RESULT == 'INSERT 0 1' ]]
    then
      echo "Inserted '$ROUND', $YEAR"
    fi
  fi
done