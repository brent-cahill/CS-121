-- [Problem 1]

-- Drop all tables if they exist
-- tables must be dropped in this exact order due to tabular references

DROP TABLE IF EXISTS owns;
DROP TABLE IF EXISTS participated;
DROP TABLE IF EXISTS person;
DROP TABLE IF EXISTS car;
DROP TABLE IF EXISTS accident;

CREATE TABLE person(
-- An ID will be used as the primary key, since this will be unique,
-- as opposed to a name. Length is 10, as requested
  driver_id CHAR(10) NOT NULL,
  name VARCHAR(40) NOT NULL,
  address VARCHAR(150) NOT NULL,
  PRIMARY KEY(driver_id));
  
CREATE TABLE car(
-- primary key will be the license plate number, which can be
-- made of letters, spaces and numbers
  license VARCHAR(7) NOT NULL,
-- Model of the car, which can be long
  model VARCHAR(40),
  year INT,
  PRIMARY KEY(license));
  
CREATE TABLE accident(
-- report number is an automatically incrementing integer, as requested
  report_number INT NOT NULL AUTO_INCREMENT,
-- TIMESTAMP is a type that will store the date and time at which the accident
-- occurred
  date_occurred TIMESTAMP NOT NULL,
  location VARCHAR(250),
-- descriptions of accidents can be very long and include mutiple viepoints.
  description VARCHAR(5000),
  PRIMARY KEY (report_number));

-- supports cascaded deletes and cascaded updates
CREATE TABLE owns(
-- primary key 1 is the driver's ID, which is already desccribed in person
-- therefore, we will reference it
  driver_id CHAR(10) REFERENCES person (driver_id) ON DELETE CASCADE
    ON UPDATE CASCADE,
-- second primary key is the license, which is referenced from car
  license VARCHAR(7) REFERENCES car (license) ON DELETE CASCADE
  ON UPDATE CASCADE,
  PRIMARY KEY (driver_id, license));

-- supports cascaded updates ONLY
CREATE TABLE participated(
-- most are referenced from other tables
  driver_id CHAR(10) REFERENCES person (driver_id) ON UPDATE CASCADE,
  license VARCHAR(7) REFERENCES car (license) ON UPDATE CASCADE,
  report_number INT REFERENCES accident (report_number)
    ON UPDATE CASCADE,
-- supports damage up to $1 billion with support for cents
  damage_amount NUMERIC (9, 2)
  PRIMARY KEY (driver_id, license, report_number));
  
  
  