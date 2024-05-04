#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# INSERT unique TEAMS into table teams column name
# Read each line from the CSV file , divide by COMMAS and assign each value to VARIABLES
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # Skip the header line
  if [[ $YEAR != "year" ]]
  then
    # Get the team_id of the winner
    TEAM_ID_WINNER=$($PSQL "select team_id from teams where name='$WINNER'")
    # Check if the winner_id is not found in the teams table to prevent duplicates
    if [[ -z $TEAM_ID_WINNER ]]
    then
      # Insert the winner into the teams table
      INSERT_WINNER_RESULT=$($PSQL "insert into teams(name) values('$WINNER')")

      # Check if the insertion was successful
      if [[ $? -eq 0 ]]
      then
        # Print a message if the winner is successfully inserted
        echo Inserted $WINNER into teams
      else
        echo Failed to insert $WINNER into teams
        exit 1
      fi
    fi

    # Check if the opponent_id is not found in the teams table to prevent duplicates
    TEAM_ID_OPPONENT=$($PSQL "select team_id from teams where name='$OPPONENT'")
    if [[ -z $TEAM_ID_OPPONENT ]]
    then
      # Insert the opponent into the teams table
      INSERT_OPPONENT_RESULT=$($PSQL "insert into teams(name) values('$OPPONENT')")

      # Check if the insertion was successful
      if [[ $? -eq 0 ]]
      then
        # Print a message if the opponent is successfully inserted
        echo Inserted $OPPONENT into teams
      else
        echo Failed to insert $OPPONENT into teams
        exit 1
      fi
    fi

    # Check if any required value is empty
    if [[ -z $YEAR || -z $ROUND || -z $WINNER_GOALS || -z $OPPONENT_GOALS || -z $TEAM_ID_WINNER || -z $TEAM_ID_OPPONENT ]]
    then
      echo "Some required values are empty. Skipping insert for line: $YEAR, $ROUND, $WINNER, $OPPONENT, $WINNER_GOALS, $OPPONENT_GOALS"
    else
      # insert a row for each line in the games.csv
      $PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $TEAM_ID_WINNER, $TEAM_ID_OPPONENT, $WINNER_GOALS, $OPPONENT_GOALS)"
    fi
  fi
done
