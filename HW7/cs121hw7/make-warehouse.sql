-- [Problem 3]
DROP TABLE IF EXISTS resource_fact;
DROP TABLE IF EXISTS visitor_fact;
DROP TABLE IF EXISTS datetime_dim;
DROP TABLE IF EXISTS visitor_dim;
DROP TABLE IF EXISTS resource_dim;


CREATE TABLE resource_dim (
  resource_id INTEGER AUTO_INCREMENT,
  resource VARCHAR(200),
  method VARCHAR(15),
  protocol VARCHAR(200),
  response INTEGER NOT NULL,

  PRIMARY KEY (resource_id),
  UNIQUE (resource, method, protocol, response)
);

CREATE TABLE visitor_dim (
  visitor_id INTEGER AUTO_INCREMENT,
  ip_addr VARCHAR(200) NOT NULL,
  visit_val INTEGER NOT NULL,

  PRIMARY KEY (visitor_id),
  UNIQUE (visit_val)
);

CREATE TABLE datetime_dim (
  date_id INTEGER AUTO_INCREMENT,
  date_val DATE NOT NULL,
  hour_val INTEGER NOT NULL,
  weekend BOOLEAN NOT NULL,
  holiday VARCHAR(20),

  PRIMARY KEY (date_id),
  UNIQUE (date_val, hour_val)
);

CREATE TABLE visitor_fact (
  date_id INTEGER NOT NULL REFERENCES datetime_dim (date_id),
  visitor_id INTEGER NOT NULL REFERENCES visitor_dim (visitor_id),
  num_requests INTEGER NOT NULL,
  total_bytes BIGINT,

  PRIMARY KEY (date_id, visitor_id)
);

CREATE TABLE resource_fact (
  date_id INTEGER NOT NULL REFERENCES datetime_dim (date_id),
  resource_id INTEGER NOT NULL REFERENCES resource_dim (resource_id),
  num_requests INTEGER NOT NULL,
  total_bytes BIGINT,

  PRIMARY KEY (date_id, resource_id)
);

