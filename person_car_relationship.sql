-- 1:1 Relationship
-- One person can only have one car; and one car can only belong to one person

DROP TABLE person;
DROP TABLE car;

CREATE TABLE car (
	id BIGSERIAL PRIMARY KEY,
	make VARCHAR(100) NOT NULL,
	model VARCHAR(100) NOT NULL,
	price NUMERIC(8,2) NOT NULL
);

CREATE TABLE person (
    id BIGSERIAL PRIMARY KEY,
    --id BIGSERIAL CONSTRAINT custom_name PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender VARCHAR(7) NOT NULL,
    email VARCHAR(150),
    date_of_birth DATE NOT NULL,
    country_of_birth VARCHAR(50) NOT NULL,
    car_id BIGINT REFERENCES car(id)
    --car_id BIGINT CONSTRAINT custom_name REFERENCES car(id)
    --car_id BIGINT
);

-- Adding constraints
ALTER TABLE person ADD CONSTRAINT email_unique 
UNIQUE(email);

ALTER TABLE person ADD CONSTRAINT gender_check 
CHECK(gender = 'Male' OR gender = 'Female');

ALTER TABLE person ADD CONSTRAINT car_id_unique
UNIQUE(car_id);

--ALTER TABLE person ADD FOREIGN KEY(car_id) REFERENCES car(id);
--ALTER TABLE person ADD CONSTRAINT custom_name FOREIGN KEY(car_id) REFERENCES car(id);

ALTER TABLE car ADD CONSTRAINT price_greater_than_zero CHECK(price > 0);

--person values
INSERT INTO person (first_name, last_name, gender, email, date_of_birth, country_of_birth)
VALUES ('Fernanda', 'Beardon', 'Female', 'fernandab@is.gd', '1953-10-28', 'Comoros');

INSERT INTO person (first_name, last_name, gender, email, date_of_birth, country_of_birth)
VALUES ('Omar', 'Colmore', 'Male', null, '1921-04-03', 'Finland');

INSERT INTO person (first_name, last_name, gender, email, date_of_birth, country_of_birth)
VALUES ('John', 'Matuschek', 'Male', 'john@feedburner.com', '1965-02-28', 'England');

--car values
INSERT INTO car (make, model, price) VALUES ('Land Rover', 'Sterling', '87665.38');
INSERT INTO car (make, model, price) VALUES ('GMC', 'Acadia', '17662.69');

-- UPDATING car_id FOREIGN KEY COLUMN IN PERSON TABLE
--Assign car with id = 1 to person with id = 1
UPDATE person
SET car_id = 1 WHERE id = 1;

--Assign car with id = 2 to person with id = 3
UPDATE person
SET car_id = 2 WHERE id = 3;

--Trying to assign the same car id to another person throws an error because of the car_id unique constraint
UPDATE person
SET car_id = 1 WHERE id = 2;

-- -------------------------------------------

-- JOIN TABLES

-- INNER JOIN 
-- People without car does not appear in the result 
SELECT * FROM person
JOIN car ON person.car_id = car.id;

SELECT person.first_name, person.last_name, car.make, car.model, car.price 
FROM person JOIN car ON person.car_id = car.id;

-- LEFT JOIN
-- Every person appears in the result, whether they have a car or not
SELECT person.first_name, person.last_name, car.make, car.model, car.price
FROM person LEFT JOIN car ON person.car_id = car.id;

-- count the people who don't have a car
SELECT COUNT(*) FROM person
LEFT JOIN car ON person.car_id = car.id
WHERE person.car_id IS NULL;

--DELETING RECORDS WITH FOREIGN CONSTRAINTS
-- Remove foreign keys first where they are referenced by deleting the entire
-- record or setting that colum to NULL
UPDATE person SET car_id = NULL WHERE id = 1; --remove car (id = 1) from person with id = 1
DELETE FROM car WHERE id = 1;