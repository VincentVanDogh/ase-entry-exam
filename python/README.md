# ASE Entry Exam Overview

## Basic SQL commands
```postgresql
CREATE DATABASE ase;
DROP DATABASE ase;
```

```postgresql
CREATE TABLE table_name (
    column_name + data_type + constraints
);
```
e.g.
```postgresql
CREATE TABLE table_name (
    id int,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender VARCHAR(5),
    date_of_birth TIMESTAMP
);
```

Connect to a table: ``\c``

List all databases: ``\l``

List all tables: ``\d``

List a specific table: ``\d table_name``

```postgresql
SELECT * FROM employee;
```