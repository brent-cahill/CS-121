-- [Problem 3]
-- This drops the tables created below if the already exist
DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS album_media;
DROP TABLE IF EXISTS videos;
DROP TABLE IF EXISTS photos;
DROP TABLE IF EXISTS media;
DROP TABLE IF EXISTS album;
DROP TABLE IF EXISTS user;


-- This creates a table of the website users, including their username,
-- which is unique, and a secure method of containing their passwords.
CREATE TABLE user (
  username       VARCHAR(50) NOT NULL,
  email_address  VARCHAR(50) NOT NULL,
  pw_salt        VARCHAR(10) NOT NULL,
  pw_hash        VARCHAR(36) NOT NULL,
  PRIMARY KEY (username)
);


-- This creates a table of all the users' albums.
CREATE TABLE album (
  album_id        INT AUTO_INCREMENT,
  album_title     VARCHAR(200) NOT NULL,
  album_descrip   VARCHAR(500) NOT NULL,
  username        VARCHAR(50) NOT NULL,
  PRIMARY KEY (album_id),
  FOREIGN KEY (username) REFERENCES user (username) ON DELETE CASCADE
);

-- This table contains all of the similar attributes of both
-- photos and videos.
CREATE TABLE media (
  media_id        INT AUTO_INCREMENT,
  title           VARCHAR(200) NOT NULL,
  description     VARCHAR(500),
  upload_time     TIMESTAMP NOT NULL,
  views           INT DEFAULT 0,
  username        VARCHAR(50) NOT NULL,
  PRIMARY KEY (media_id),
  FOREIGN KEY (username) REFERENCES user (username) ON DELETE CASCADE
);

-- This table contains all of the attributes relating only to photos,this is a
-- sublass of 'media'
CREATE TABLE photos (
  media_id        INT,
  filename        VARCHAR(100) NOT NULL,
  photo_data      BLOB NOT NULL,
  PRIMARY KEY (media_id),
  FOREIGN KEY (media_id) REFERENCES media (media_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- This table contains all of the attributes relating only to videos,this is a
-- sublass of 'media'
CREATE TABLE videos (
  media_id        INT,
  length          INT NOT NULL,
  path            VARCHAR(4000) NOT NULL,
  PRIMARY KEY (media_id),
  FOREIGN KEY (media_id) REFERENCES media (media_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- This table contains all of the attributes for the media contained
-- within an album
CREATE TABLE album_media (
  album_id        INT NOT NULL,
  media_id        INT NOT NULL,
  summary_photo   BOOL,
  PRIMARY KEY (album_id, media_id),
  FOREIGN KEY (album_id) REFERENCES album (album_id) ON DELETE CASCADE,
  FOREIGN KEY (media_id) REFERENCES media (media_id) ON DELETE CASCADE
);

-- This table contains all of the information for comments
-- posted on the website
CREATE TABLE comments (
  comment_id     INT AUTO_INCREMENT,
  username       VARCHAR(50) NOT NULL,
  comment_time   TIMESTAMP NOT NULL,
  body           VARCHAR(1000) NOT NULL,
  media_id       INT,
  PRIMARY KEY (comment_id),
  FOREIGN KEY (username) REFERENCES user (username) ON DELETE CASCADE,
  FOREIGN KEY (media_id) REFERENCES media (media_id) ON DELETE CASCADE
);
