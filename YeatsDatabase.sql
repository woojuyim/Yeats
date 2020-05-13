DROP DATABASE if exists Yeats;
CREATE DATABASE Yeats;
USE Yeats;

CREATE TABLE ACCOUNTS(
  ID INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
  Username VARCHAR(45) NOT NULL,
  PW VARCHAR(45) NOT NULL,
  Email VARCHAR(45) NOT NULL
);


CREATE TABLE FAVORITES(
	ID INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	UID INT NOT NULL,
    YELP_ID VARCHAR(45) NOT NULL,
    FOREIGN KEY(UID) REFERENCES ACCOUNTS(ID)
);
  