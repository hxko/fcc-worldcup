# World Cup Database Project

This project involves automating the insertion of data from a CSV file (`games.csv`) into a PostgreSQL database (`worldcup` or `worldcuptest`).  
The project utilizes two main components: `script.sh` and `queries.sh`.

## script.sh

The `script.sh` file is a Bash script designed to read data from `games.csv` and insert it into the `games` table of a PostgreSQL database. Here's an overview of what the script does:

1. **Database Selection**: Depending on the command-line argument (`test`), it selects either the `worldcup` or `worldcuptest` database using the appropriate PostgreSQL credentials.

2. **Data Insertion**:
   - Reads each line from `games.csv`.
   - Extracts and assigns values to variables (`YEAR`, `ROUND`, `WINNER`, `OPPONENT`, `WINNER_GOALS`, `OPPONENT_GOALS`) based on comma separation.
   - Checks if the year is not a header line (`year`).
   - Queries the database to find or insert the `WINNER` and `OPPONENT` teams into the `teams` table if they do not already exist.
   - Inserts a new row into the `games` table with the extracted data.

3. **Error Handling**: 
   - Verifies if required values are empty and skips the insertion if so.
   - Prints messages indicating successful or failed insertions.

## queries.sh

The `queries.sh` file contains SQL queries used by `script.sh` to interact with the PostgreSQL database. It includes queries to:
- Insert new teams (`WINNER` and `OPPONENT`) into the `teams` table if they do not exist.
- Insert new game records into the `games` table, linking teams via their IDs retrieved from the `teams` table.

## Running the Script

To run the script:
- Ensure PostgreSQL is installed and running.
- Place the `games.csv` file in the same directory as `script.sh`.
- Open a terminal and navigate to the directory containing `script.sh`.
- Execute the script using the command: `./script.sh test` (for testing) or `./script.sh` (for production).




