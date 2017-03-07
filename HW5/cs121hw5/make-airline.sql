-- [Problem 5]

-- DROP TABLE commands:
DROP TABLE IF EXISTS seat_info;
DROP TABLE IF EXISTS flights;
DROP TABLE IF EXISTS airplanes;
DROP TABLE IF EXISTS purchasers;
DROP TABLE IF EXISTS purchase;
DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS traveler;

-- CREATE TABLE commands:
CREATE TABLE airplanes(
  type_code              CHAR(3) NOT NULL,
  manufacturer           VARCHAR(40) NOT NULL,
  model                  VARCHAR(40) NOT NULL,
  PRIMARY KEY (type_code));


CREATE TABLE flights(
  flight_number          VARCHAR(10) NOT NULL,
  flight_date            DATE NOT NULL,
  flight_time            TIME NOT NULL,
  source_port            CHAR(3) NOT NULL,
  dest_port              CHAR(3) NOT NULL,
  flight_domesticality   BOOL NOT NULL,
  type_code              CHAR(3) NOT NULL,
  
  FOREIGN KEY (type_code) REFERENCES airplanes(type_code)
    ON DELETE CASCADE,
  PRIMARY KEY (flight_number, flight_date));

CREATE TABLE seat_info(
  flight_number          VARCHAR(10) NOT NULL,
  flight_date            DATE NOT NULL,
  seat_number            VARCHAR(3) NOT NULL,
  seat_class             CHAR(10) NOT NULL,
  seat_type              CHAR(10) NOT NULL,
  exit_check             BOOL NOT NULL,
  
  FOREIGN KEY (flight_number, flight_date) REFERENCES 
    flights(flight_number, flight_date) ON DELETE CASCADE,
  PRIMARY KEY (flight_number, flight_date, seat_number));
  
CREATE TABLE purchasers(
  id                     VARCHAR(10) NOT NULL,
  email_address          VARCHAR(40) NOT NULL,
  first_name             VARCHAR(20) NOT NULL,
  last_name              VARCHAR(30) NOT NULL,
  phone_numbers          VARCHAR(10) NOT NULL,
  cc_num                 VARCHAR(20),
  exp_date               NUMERIC(2,2),
  verification_code      VARCHAR(4),
  
  PRIMARY KEY (email_address));
  
CREATE TABLE purchase(
  purchase_id            INT NOT NULL AUTO_INCREMENT,
  purchase_time          TIMESTAMP NOT NULL,
  email_address          VARCHAR(40) NOT NULL,
  confirmation_num       VARCHAR(10) NOT NULL,
  
  FOREIGN KEY (email_address) REFERENCES
    purchasers(email_address) ON DELETE CASCADE,
  PRIMARY KEY (purchase_id));
  
CREATE TABLE tickets(
  ticket_id              VARCHAR(10) NOT NULL,
  flight_number          VARCHAR(10) NOT NULL,
  flight_date            DATE NOT NULL,
  cost                   NUMERIC(4,2) NOT NULL,
  seat_number            VARCHAR(3) NOT NULL,
  purchase_id            INT NOT NULL,
  
  FOREIGN KEY (flight_number, flight_date) REFERENCES
    flights(flight_number, flight_date) ON DELETE CASCADE,
  FOREIGN KEY (seat_number) REFERENCES
    seat_info(seat_number) ON DELETE CASCADE,
  FOREIGN KEY (purchase_id) REFERENCES
    purchase(purchase_id) ON DELETE CASCADE,
  PRIMARY KEY (ticket_id));

CREATE TABLE traveler(
	traveler_id		      INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    first_name            VARCHAR(20) NOT NULL,
    last_name             VARCHAR(20) NOT NULL, 
    email_address         VARCHAR(30) NOT NULL,
    phone_number          VARCHAR(10) NOT NULL,
    passport_num          VARCHAR(40) DEFAULT NULL,
    country               VARCHAR(30) DEFAULT NULL,
    ec_name               VARCHAR(20) DEFAULT NULL,
    ec_number             VARCHAR(10) DEFAULT NULL,
    ff_number             VARCHAR(7),
    ticket_id             INT NOT NULL,

    FOREIGN KEY (ticket_id) REFERENCES
      ticket(ticket_id) ON DELETE CASCADE,
	UNIQUE KEY (ticket_id));
  