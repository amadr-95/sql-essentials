
# [SQL ESSENTIALS](https://www.amigoscode.com/courses/sql)


## Connect to PostgreSQL server on Windows
```bash
psql -U user_name
```

## Connect to a database through the terminal
```bash
psql -U user_name -d db_name 
```

## List databases
```bash
\l  
```

## Connect to a database
```bash
\c db_name 
```

## Describe tables
```bash
\d (show all tables)
\d db_name (describe the specified table) 
```

## Import .sql script
```bash
\i script/path/.sql 
```

## List of functions
```bash
\df
```

## Export query to CSV file
```bash
\copy (query) TO 'path/file_name.csv' DELIMITER ',' CSV HEADER; 
```

## PostgreSQL extensions
```sql
SELECT * FROM pg_available_extensions;
```
### Install extension
```sql
CREATE EXTENSION IF NOT EXISTS "extension_name";
```

##  CREATE TABLE
```sql
CREATE TABLE table_name (
    column name + data type + constraints if any
);
```
## DROP TABLE
```sql
DROP TABLE table_name;
```
## ADDING AND DROPPING CONSTRAINTS
### PRIMARY KEY
```sql
ALTER TABLE table_name ADD PRIMARY KEY (table_column);
```

### UNIQUE
```sql
ALTER TABLE table_name ADD CONSTRAINT constraint_name UNIQUE(table_column);
--OR
ALTER TABLE table_name UNIQUE(table_column);
```

### CHECKS
```sql
ALTER TABLE table_name ADD CONSTRAINT constraint_name CHECK(column_condition/s);
```

### DROP CONSTRAINTS
```sql
ALTER TABLE table_name DROP CONSTRAINT constraint_name; 
```
## MODIFYING DATA
### INSERTING RECORDS
```sql
INSERT INTO table_name(colum1, column2, ...)
VALUES (value1, value2, ...);
```

### DELETING RECORDS
```sql
DELETE FROM table_name WHERE conditions;
```

### UPDATING RECORDS
```sql
UPDATE table_name SET column = new_data WHERE conditions;
```

## SQL COMMANDS ORDER
```sql
SELECT 
FROM
WHERE
GROUP BY
HAVING
ORDER BY
FETCH/LIMIT
OFFSET
```
