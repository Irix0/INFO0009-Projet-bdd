SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";

START TRANSACTION;
SET time_zone = "+00:00";

/* --------------------------- USERS --------------------------- */
/* USER */
CREATE TABLE `groupXX`.`users` (
  `Login` varchar(20) NOT NULL,
  `Pass` varchar(20) NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

LOAD DATA INFILE '/docker-entrypoint-initdb.d/data/users.csv' INTO TABLE `users` FIELDS TERMINATED BY ',' ENCLOSED BY '"' IGNORE 1 ROWS;


/* --------------------------- CLIENTS --------------------------- */
/* CLIENT */
CREATE TABLE `groupXX`.`client` (
    `CLIENT_NUMBER` INT NOT NULL ,
    `FIRST_NAME` VARCHAR(30) NOT NULL ,
    `LAST_NAME` VARCHAR(30) NOT NULL ,
    `EMAIL_ADDRESS` VARCHAR(40) NULL ,
    `PHONE_NUMBER` VARCHAR(15) NULL COMMENT 'size of 15 following E.164 format' ,
    PRIMARY KEY (`CLIENT_NUMBER`)
) ENGINE = InnoDB;

LOAD DATA INFILE '/docker-entrypoint-initdb.d/data/Client.csv' INTO TABLE `client` FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;

/** --------------------------- EMPLOYEES --------------------------- */
/* EMPLOYEE */
CREATE TABLE `groupXX`.`employee` (
    `ID` INT NOT NULL AUTO_INCREMENT ,
    `FIRSTNAME` VARCHAR(30) NOT NULL ,
    `LASTNAME` VARCHAR(30) NOT NULL ,
    PRIMARY KEY (`ID`)
) ENGINE = InnoDB; 

LOAD DATA INFILE '/docker-entrypoint-initdb.d/data/Employee.csv' INTO TABLE `employee` FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;

/* DJ */
CREATE TABLE `groupXX`.`dj` (
    `ID` INT NOT NULL,
    PRIMARY KEY (`ID`),
    FOREIGN KEY (`ID`) REFERENCES employee (`ID`)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE = InnoDB;

LOAD DATA INFILE '/docker-entrypoint-initdb.d/data/DJ.csv' INTO TABLE `dj` FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;

/* EVENT PLANNER */
CREATE TABLE `groupXX`.`event_planner` (
    `ID` INT NOT NULL,
    PRIMARY KEY (`ID`),
    FOREIGN KEY (`ID`) REFERENCES employee (`ID`)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE = InnoDB;

LOAD DATA INFILE '/docker-entrypoint-initdb.d/data/EventPlanner.csv' INTO TABLE `event_planner` FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;


/* MANAGER */
CREATE TABLE `groupXX`.`manager` (
    `ID` INT NOT NULL,
    PRIMARY KEY (`ID`),
    FOREIGN KEY (`ID`) REFERENCES employee (`ID`)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE = InnoDB;

LOAD DATA INFILE '/docker-entrypoint-initdb.d/data/Manager.csv' INTO TABLE `manager` FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;

CREATE TABLE `groupXX`.`supervision` (
    `SUPERVISOR_ID` INT NOT NULL ,
    `EMPLOYEE_ID` INT NOT NULL ,
    PRIMARY KEY (`EMPLOYEE_ID`),
    FOREIGN KEY (`EMPLOYEE_ID`) REFERENCES employee (`ID`)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (`SUPERVISOR_ID`) REFERENCES manager (`ID`)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE = InnoDB; 

LOAD DATA INFILE '/docker-entrypoint-initdb.d/data/Supervision.csv' INTO TABLE `supervision` FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;

/* --------------------------- MUSIC --------------------------- */

/* CD */
CREATE TABLE `groupXX`.`cd` (
    `CD_NUMBER` INT NOT NULL AUTO_INCREMENT,
    `TITLE` VARCHAR(20) NULL,
    `PRODUCER` VARCHAR(20) NULL,
    `YEAR` YEAR NULL,
    `COPIES` INT NOT NULL,
    PRIMARY KEY (`CD_NUMBER`),
    UNIQUE(`TITLE`)
) ENGINE = InnoDB;

LOAD DATA INFILE '/docker-entrypoint-initdb.d/data/CD.csv' INTO TABLE `cd` FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;

/* GENRE */
CREATE TABLE `groupXX`.`genre` (
    `NAME` VARCHAR(30) NOT NULL,
    PRIMARY KEY (`NAME`),
    UNIQUE(`NAME`)
) ENGINE = InnoDB; 

LOAD DATA INFILE '/docker-entrypoint-initdb.d/data/Genre.csv' INTO TABLE `genre` FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;

/* SPECIALIZES */
CREATE TABLE `groupXX`.`specializes` (
    `SUBGENRE` VARCHAR(30) NOT NULL, 
    `GENRE` VARCHAR(30) NOT NULL,
    PRIMARY KEY (`SUBGENRE`, `GENRE`),
    FOREIGN KEY (`GENRE`) REFERENCES genre (`NAME`)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (`SUBGENRE`) REFERENCES genre (`NAME`)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE = InnoDB; 

LOAD DATA INFILE '/docker-entrypoint-initdb.d/data/Specializes.csv' INTO TABLE `specializes` FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;

/* PLAYLIST */
CREATE TABLE `groupXX`.`playlist` (
    `NAME` VARCHAR(20) NOT NULL, 
    PRIMARY KEY (`NAME`)
) ENGINE = InnoDB;

LOAD DATA INFILE '/docker-entrypoint-initdb.d/data/Playlist.csv' INTO TABLE `playlist` FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;

/* SONG */
CREATE TABLE `groupXX`.`song` (
    `CD_NUMBER` INT NOT NULL,
    `TRACK_NUMBER` INT NOT NULL, 
    `TITLE` VARCHAR(20) NOT NULL, 
    `ARTIST` VARCHAR(20) NOT NULL, 
    `DURATION` TIME NOT NULL, 
    `GENRE` VARCHAR(30) NULL, 
    PRIMARY KEY (`TRACK_NUMBER`, `CD_NUMBER`),
    FOREIGN KEY (`GENRE`) REFERENCES genre (`NAME`)
        ON UPDATE SET NULL
        ON DELETE SET NULL,
    FOREIGN KEY (`CD_NUMBER`) REFERENCES cd (`CD_NUMBER`)
        ON UPDATE CASCADE
        ON DELETE CASCADE
    
) ENGINE = InnoDB; 

LOAD DATA INFILE '/docker-entrypoint-initdb.d/data/Song.csv' INTO TABLE `song` FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;

/* CONTAINS */
CREATE TABLE `groupXX`.`contains` (
    `PLAYLIST` VARCHAR(20) NOT NULL ,
    `TRACK_NUMBER` INT NOT NULL ,
    `CD_NUMBER` INT NOT NULL,
    FOREIGN KEY (`PLAYLIST`) REFERENCES playlist (NAME)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (`CD_NUMBER`) REFERENCES cd (`CD_NUMBER`)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (`TRACK_NUMBER`) REFERENCES song (`TRACK_NUMBER`)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE = InnoDB;

LOAD DATA INFILE '/docker-entrypoint-initdb.d/data/Contains.csv' INTO TABLE `contains` FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;

/* SPECIALIZATION */
CREATE TABLE `groupXX`.`specialization` (
    `ID` INT NOT NULL ,
    `GENRE` VARCHAR(30) NOT NULL ,
    PRIMARY KEY (`ID`, `GENRE`),
    FOREIGN KEY (`ID`) REFERENCES dj (`ID`)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (`GENRE`) REFERENCES genre (`NAME`)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE = InnoDB;

LOAD DATA INFILE '/docker-entrypoint-initdb.d/data/Specialization.csv' INTO TABLE `specialization` FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;

/* --------------------------- EVENTS --------------------------- */

/* THEME */
CREATE TABLE `groupXX`.`theme` (
    `NAME` VARCHAR(20) NOT NULL,
    PRIMARY KEY (`NAME`)
) ENGINE = InnoDB; 

LOAD DATA INFILE '/docker-entrypoint-initdb.d/data/Theme.csv' INTO TABLE `theme` FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;

/* SUITABLEFOR */
CREATE TABLE `groupXX`.`suitablefor` (
    `THEME` VARCHAR(20) NOT NULL, 
    `PLAYLIST` VARCHAR(20) NOT NULL,
    PRIMARY KEY (`THEME`, `PLAYLIST`),
    FOREIGN KEY (`PLAYLIST`) REFERENCES playlist (`NAME`)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (`THEME`) REFERENCES theme (`NAME`)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE = InnoDB;

LOAD DATA INFILE '/docker-entrypoint-initdb.d/data/Suitablefor.csv' INTO TABLE `suitablefor` FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;

/* LOCATION */
CREATE TABLE `groupXX`.`location` (
    `ID` INT NOT NULL AUTO_INCREMENT , 
    `STREET` VARCHAR(30) NOT NULL , 
    `CITY` VARCHAR(30) NOT NULL , 
    `POSTAL_CODE` VARCHAR(6) NOT NULL , 
    `COUNTRY` VARCHAR(20) NOT NULL , 
    `COMMENT` VARCHAR(50) NULL , 
    PRIMARY KEY (`ID`)
) ENGINE = InnoDB;

LOAD DATA INFILE '/docker-entrypoint-initdb.d/data/Location.csv' INTO TABLE `location` FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;

/* EVENT */
CREATE TABLE `groupXX`.`event`(
    `ID` INT NOT NULL AUTO_INCREMENT ,
    `NAME` VARCHAR(30) NOT NULL ,
    `DATE` DATE NULL ,
    `DESCRIPTION` TEXT NULL ,
    `CLIENT` INT NOT NULL COMMENT 'ID' ,
    `MANAGER` INT NOT NULL COMMENT 'ID' ,
    `EVENT_PLANNER` INT NOT NULL COMMENT 'ID' ,
    `DJ` INT NOT NULL COMMENT 'ID' ,
    `THEME` VARCHAR(20) NULL ,
    `TYPE` VARCHAR(20) NULL ,
    `LOCATION` INT NULL COMMENT 'ID' ,
    `RENTAL_FEE` INT NULL ,
    `PLAYLIST` VARCHAR(20) NULL ,
    PRIMARY KEY (`ID`),
    FOREIGN KEY (`CLIENT`) REFERENCES client (`CLIENT_NUMBER`)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (`MANAGER`) REFERENCES manager (`ID`)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (`EVENT_PLANNER`) REFERENCES event_planner (`ID`)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (`DJ`) REFERENCES dj (`ID`)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (`THEME`) REFERENCES theme (`NAME`)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (`LOCATION`) REFERENCES location (`ID`)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (`PLAYLIST`) REFERENCES playlist (`NAME`)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE = InnoDB;

LOAD DATA INFILE '/docker-entrypoint-initdb.d/data/Event.csv' INTO TABLE `event` FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;