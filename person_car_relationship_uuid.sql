DROP TABLE person;
DROP TABLE car;

CREATE TABLE car (
	car_uuid UUID PRIMARY KEY,
	make VARCHAR(100) NOT NULL,
	model VARCHAR(100) NOT NULL,
	price NUMERIC(8,2) NOT NULL
);

CREATE TABLE person (
    person_uuid UUID PRIMARY KEY,
    --id UUID CONSTRAINT custom_name PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender VARCHAR(7) NOT NULL,
    email VARCHAR(150),
    date_of_birth DATE NOT NULL,
    country_of_birth VARCHAR(50) NOT NULL,
    car_uuid UUID REFERENCES car(car_uuid)
    --car_uuid UUID CONSTRAINT custom_name REFERENCES car(car_uuid)
    --car_uuid UUID
);

-- Adding constraints
ALTER TABLE person ADD CONSTRAINT email_unique 
UNIQUE(email);

ALTER TABLE person ADD CONSTRAINT gender_check 
CHECK(gender = 'Male' OR gender = 'Female');

ALTER TABLE person ADD CONSTRAINT car_uuid_unique
UNIQUE(car_uuid);

--ALTER TABLE person ADD FOREIGN KEY(car_uuid) REFERENCES car(car_uuid);
--ALTER TABLE person ADD CONSTRAINT custom_name FOREIGN KEY(car_uuid) REFERENCES car(car_uuid);

ALTER TABLE car ADD CONSTRAINT price_greater_than_zero CHECK(price > 0);


-- person values
INSERT INTO person (person_uuid, first_name, last_name, gender, email, date_of_birth, country_of_birth)
VALUES (uuid_generate_v4(), 'Fernanda', 'Beardon', 'Female', 'fernandab@is.gd', '1953-10-28', 'Comoros');

INSERT INTO person (person_uuid, first_name, last_name, gender, email, date_of_birth, country_of_birth)
VALUES (uuid_generate_v4(), 'Omar', 'Colmore', 'Male', null, '1921-04-03', 'Finland');

INSERT INTO person (person_uuid, first_name, last_name, gender, email, date_of_birth, country_of_birth)
VALUES (uuid_generate_v4(), 'John', 'Matuschek', 'Male', 'john@feedburner.com', '1965-02-28', 'England');

--car values
INSERT INTO car (car_uuid, make, model, price) VALUES (uuid_generate_v4(), 'Land Rover', 'Sterling', '87665.38');
INSERT INTO car (car_uuid, make, model, price) VALUES (uuid_generate_v4(), 'GMC', 'Acadia', '17662.69');

-- UPDATING car_uuid FOREIGN KEY COLUMN IN person TABLE
UPDATE person
SET car_uuid = '0259a50b-6442-4686-9081-d1caca9db636' 
WHERE person_uuid = '17d78421-8534-438d-b5f7-0b20ffdb3223';

--JOIN
SELECT person.first_name, person.last_name, car.make, car.model, car.price 
FROM person JOIN car ON person.car_uuid = car.car_uuid;

--Like primary key and foreign key have the same name (car_uuid), the query can be written in this way too:
SELECT person.first_name, person.last_name, car.make, car.model, car.price 
FROM person JOIN car USING (car_uuid);

SELECT person.first_name, person.last_name, car.make, car.model, car.price 
FROM person LEFT JOIN car USING (car_uuid);