# Bash Shell Script Database Management System (DBMS)

## Project Overview

This project is a Bash Shell Script-based Database Management System (DBMS) designed to provide basic database functionality through a command-line interface (CLI). The system enables users to create, manage, and manipulate databases and tables directly from the terminal. The databases are stored as directories, and tables as files within those directories, providing a simple and intuitive way to handle data.

## Features

### Main Menu
- **Create Database:** Allows the user to create a new database, which will be stored as a directory.
- **List Databases:** Displays a list of all databases (directories) stored in the current script directory.
- **Connect to Database:** Enables the user to connect to a specific database. Once connected, the user can manage tables within that database.
- **Drop Database:** Deletes a specified database and all its contents (the entire directory is removed).

### Database Menu (Upon Connecting to a Database)
- **Create Table:** 
  - Prompts the user to define the table name, columns, and their data types.
  - The table is stored as a file within the connected database directory.
  - The user is asked to specify a primary key, which will be enforced during data entry.
- **List Tables:** Displays a list of all tables (files) within the connected database.
- **Drop Table:** Deletes a specified table (file) from the connected database.
- **Insert into Table:**
  - Prompts the user to enter data for each column in the table.
  - Ensures that data types match the specified column types and that the primary key is unique.
- **Select From Table:**
  - Allows the user to retrieve and display data from a table.
  - The data is displayed in a neatly formatted manner within the terminal.
- **Delete From Table:** Removes specific rows from a table based on user-defined conditions.
- **Update Table:** 
  - Enables the user to modify existing data within a table.
  - Checks that updates comply with the column data types and do not violate primary key constraints.

## How It Works

### Directory and File Structure
- **Databases:** Each database is represented as a directory in the current working directory of the script.
- **Tables:** Each table within a database is represented as a text file within the corresponding database directory.
- **Data Storage:** Data is stored in plain text within these files, with rows and columns managed through simple text parsing.

### Data Integrity
- **Data Types:** During the table creation process, the user specifies the data type for each column (e.g., integer, string). The system enforces these types during data insertion and updates.
- **Primary Key:** The primary key is a unique identifier for each row in the table. The system ensures that the primary key is unique and not duplicated during data entry.

## Installation and Setup

### Prerequisites
- A Unix-like operating system (Linux, macOS) or Windows with a Bash shell environment (e.g., Git Bash, WSL).
- Basic knowledge of Bash scripting and command-line interface operations.

### Installation
1. Clone the repository to your local machine:
   ```bash
   git@github.com:AbramBorma/BashDB-Project-ITI.git
