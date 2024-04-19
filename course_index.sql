--CREATE TABLE

--WITHOUT CONSTRAINTS
CREATE TABLE person(
    id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender VARCHAR(7),
    date_of_birth DATE
);

--WITH CONSTRAINTS
CREATE TABLE person(
    id BIGSERIAL PRIMARY KEY, --BIGSERIAL is an autoincrement integer
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(150),
    gender VARCHAR(7) NOT NULL,
    date_of_birth DATE NOT NULL,
    country_of_birth VARCHAR(50) NOT NULL
);

-- ------------------------------------------------------------

--INSERTING DATA
INSERT INTO person (first_name, last_name, gender, date_of_birth)
VALUES ('Amador', 'Sabido', 'Male', date '1995-10-07');

INSERT INTO person (first_name, last_name, gender, date_of_birth, email)
VALUES ('Sandra', 'García', 'Female', date '2001-08-26', 'sandra@gmail.com');

-- person_data.sql script

-- ------------------------------------------------------------

--RETRIEVING DATA
SELECT * FROM person;
SELECT first_name FROM person;
SELECT first_name, last_name FROM person;
SELECT first_name, email FROM person;

-- ------------------------------------------------------------

--ORDERING DATA
SELECT * FROM person ORDER BY first_name; --ASC by default
SELECT * FROM person ORDER BY first_name, last_name DESC;

-- ------------------------------------------------------------

--DISTINCT KEYWORD
SELECT DISTINCT country_of_birth FROM person ORDER BY country_of_birth; --not showing duplicate data
SELECT COUNT(DISTINCT(country_of_birth)) AS "countries" FROM person;

-- ------------------------------------------------------------

--FILTERING DATA: WHERE CLAUSE
SELECT * FROM person WHERE gender = 'Female';
SELECT * FROM person WHERE gender = 'Male';
SELECT * FROM person WHERE gender = 'Male' AND country_of_birth = 'Spain';
SELECT * FROM person WHERE gender = 'Male' AND (country_of_birth = 'Spain' OR country_of_birth = 'France');

-- ------------------------------------------------------------

-- COMPARISON OPERATORS
= --equal
< --less than
<= --less or equal than
> --greater than
>= --greater or equal than
<> --not equal

-- ------------------------------------------------------------

--LIMIT, OFFSET, FETCH
SELECT * FROM person LIMIT 10; --shows the first 10 rows
SELECT * FROM person OFFSET 5 LIMIT 10; --shows 10 rows starting in row 6
--use FETCH (sql standard) instead of using LIMIT 
SELECT * FROM person OFFSET 5 FETCH FIRST 5 ROW ONLY; --row 6 to 10
SELECT * FROM person OFFSET 5 FETCH FIRST 1 ROW ONLY; --row 6

-- ------------------------------------------------------------

--IN KEYWORD
SELECT * FROM person WHERE country_of_birth = 'Spain' OR country_of_birth = 'France' OR
country_of_birth = 'Brazil';

-- Better approach
SELECT * FROM person WHERE country_of_birth IN ('Spain', 'France', 'Brazil');

-- ------------------------------------------------------------

--BETWEEN KEYWORD
SELECT * FROM person WHERE date_of_birth BETWEEN DATE '2000-01-01' AND '2015-01-01'
ORDER BY date_of_birth;

-- ------------------------------------------------------------

--LIKE/ILIKE OPERATOR
SELECT * FROM person WHERE email LIKE '%.com'; --%: means whatever characters 
SELECT * FROM person WHERE email LIKE '%.net'; 
SELECT COUNT(email) AS "emails ended with .net" FROM person WHERE email LIKE '%.net';
SELECT * FROM person WHERE email LIKE '_____@%'; --_: means one character (i.e: xxxxx@whatever)

--ILIKE: ignore the case (case insensitive)
SELECT * FROM person WHERE country_of_birth LIKE 'p%'; --0 rows
SELECT * FROM person WHERE country_of_birth ILIKE 'p%';

-- ------------------------------------------------------------

--GROUP BY
SELECT country_of_birth, COUNT(*) FROM person
GROUP BY country_of_birth
ORDER BY country_of_birth;

-- ------------------------------------------------------------

-- HAVING 
SELECT country_of_birth, COUNT(*) FROM person
GROUP BY country_of_birth
HAVING COUNT(*) > 5 -- shows countries that have more than 5 people living in them
ORDER BY country_of_birth;

-- ------------------------------------------------------------
-- car_data.sql script

-- ------------------------------------------------------------
--AGGREGATE FUNCTIONS: MAX(), MIN(), AVG(), SUM()
SELECT MAX(price) FROM car;
SELECT MIN(price) FROM car;
SELECT AVG(price) FROM car;
SELECT ROUND(AVG(price), 2) || ' euros' AS "average price" FROM car;

SELECT * FROM car ORDER BY make;
--min model price of each make
SELECT make, model, MIN(price) FROM car GROUP BY make, model ORDER BY make;
--max model price of each make
SELECT make, model, MAX(price) FROM car GROUP BY make, model ORDER BY make;
--average price of each make
SELECT make, ROUND(AVG(price), 2) AS "average price" FROM car GROUP BY make ORDER BY make;
--number of models of each make
SELECT make, COUNT(model) AS "number of models" FROM car GROUP BY make ORDER BY make;
--sum the total value of each make
SELECT make, SUM(price) FROM car GROUP BY make ORDER BY make;
--sum the total value of each model of each brand
SELECT make, model, SUM(price) FROM car GROUP BY make, model ORDER BY make;
-- ------------------------------------------------------------

-- ARITHMETIC OPERATIONS ON TABLES
--Apply a 10% off in every make
SELECT make, model, price, ROUND(price * .1, 2) AS "10% discount", ROUND(price * .9, 2) AS "price after discount"
FROM car ORDER BY make;

-- ------------------------------------------------------------
-- COALESCE 
--Set a default value where the actual data is not present
SELECT first_name, COALESCE(email, 'EMAIL NOT PROVIDED') FROM person;

-- ------------------------------------------------------------
--DIVISION BY ZERO
SELECT NULLIF(0,0) -- returns NULL if both arguments are the same; otherwise it returns the first argument
SELECT COALESCE(10 / NULLIF(0,0), 0); --default value if divided by 0 instead of throws an error

-- ------------------------------------------------------------
-- TIMESTAMPS AND DATES

SELECT NOW(); --timestamp
SELECT NOW()::DATE;
SELECT NOW()::TIME;

--INTERVAL
SELECT NOW() - INTERVAL '1 YEAR';
SELECT NOW() + INTERVAL '10 DAYS';
SELECT (NOW() + INTERVAL '3 MONTHS')::DATE;

--EXTRACT
SELECT EXTRACT(YEAR FROM NOW());
SELECT EXTRACT(MONTH FROM NOW());
SELECT EXTRACT(DAY FROM NOW());
SELECT EXTRACT(DOW FROM NOW()); --day of week (Sunday: 0, Monday: 1, ...)
SELECT EXTRACT(DOW FROM (NOW() - INTERVAL '3 DAYS')::DATE);


-- AGE FUNCTION
SELECT *, EXTRACT(YEARS FROM AGE(NOW(), date_of_birth)) || ' years' AS age FROM person;

-- ------------------------------------------------------------

-- CONSTRAINTS

--PRIMARY KEY
ALTER TABLE person DROP CONSTRAINT person_pkey;
--now we can add another person with the exact same data
INSERT INTO person (id, first_name, last_name, email, gender, date_of_birth, country_of_birth) 
VALUES (1, 'Matthaeus', 'Hritzko', 'mhritzko0@surveymonkey.com', 'Male', '1995-09-25', 'Russia');

SELECT * FROM person WHERE id = 1; --2 rows (not desirable)

DELETE FROM person WHERE id = 1;
ALTER TABLE person ADD PRIMARY KEY (id);

-- UNIQUE
ALTER TABLE person ADD CONSTRAINT unique_mail_address UNIQUE(email);
ALTER TABLE person ADD UNIQUE(email); --postgres decides the name

-- CHECK CONSTRAINTS
ALTER TABLE person ADD CONSTRAINT gender_constraint CHECK(gender = 'Male' OR gender = 'Female');

-- ------------------------------------------------------------

--MODIFYING DATA

-- DELETING RECORDS
DELETE FROM person WHERE id = 2;
DELETE FROM person WHERE EXTRACT(YEARS FROM AGE(NOW(), date_of_birth)) < 18; --delete people under 18 years old

--UPDATE RECORDS
UPDATE person
SET first_name = 'updated record'
WHERE id = 2;

-- ON CONFLICT DO NOTHING
-- can not be inserted because email restriction; throws an error
INSERT INTO person (first_name, last_name, email, gender, date_of_birth, country_of_birth) 
VALUES ('Matthaeus', 'Hritzko', 'mhritzko0@surveymonkey.com', 'Male', '1995-09-25', 'Russia'); 

-- to avoid the error
INSERT INTO person (first_name, last_name, email, gender, date_of_birth, country_of_birth) 
VALUES ('Matthaeus', 'Hritzko', 'mhritzko0@surveymonkey.com', 'Male', '1995-09-25', 'Russia')
ON CONFLICT DO NOTHING;

-- ON CONFLICT DO UPDATE
--in case of conflict, update the columns marked with the EXCLUDED keyword
INSERT INTO person (first_name, last_name, email, gender, date_of_birth, country_of_birth) 
VALUES ('Matteo', 'Matteo', 'mhritzko0@surveymonkey.com', 'Male', '1995-09-25', 'Russia')
ON CONFLICT(email) DO UPDATE SET first_name = EXCLUDED.first_name, last_name = EXCLUDED.last_name;

-- ------------------------------------------------------------

-- RELATIONSHIPS
-- person_car_relationship.sql

-- ------------------------------------------------------------

-- SEQUENCES
SELECT * FROM person_id_seq; --show information about the sequence
SELECT nextval('person_id_seq'::regclass); --call the function and increments the value by one

--Restart the sequence
ALTER SEQUENCE person_id_seq RESTART WITH 3;

-- EXTENSIONS
SELECT * FROM pg_available_extensions;

-- UUID
-- To use UUID function the extension has to be installed:
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
SELECT uuid_generate_v4(); --generates a random UUID

-- ------------------------------------------------------------
-- person_car_relationship_uuid.sql


