-- create and select the database
-- create the tables for the database
CREATE TABLE semesters(
  semesterID        INT            NOT NULL,
  semesterName      VARCHAR(60)    NOT NULL,

  PRIMARY KEY (semesterID)
);

CREATE TABLE subjects (
  subjectID         INT            NOT NULL,
  subjectName       VARCHAR(60)    NOT NULL,
  
  
  PRIMARY KEY (subjectID)
);

CREATE TABLE courses (
  courseID          CHAR(60)       NOT NULL,
  subjectName       CHAR(60)       NOT NULL,
  courseName        CHAR(60)       NOT NULL,
  credits           INT            NOT NULL,
  courseDescription CHAR(255)      NOT NULL,
  
  PRIMARY KEY (courseID)

);

CREATE TABLE CRN (
  semesterID        INT            NOT NULL,
  courseID          INT            NOT NULL,
  crnCode           INT            NOT NULL,
  section           INT            NOT NULL,
  day               CHAR(10)       NOT NULL,
  time              CHAR(60)       NOT NULL,
  location          CHAR(60)       NOT NULL,
  instructorID      INT            NOT NULL,

  
  PRIMARY KEY(courseID)

);

CREATE TABLE instructors(
  instructorID      INT            NOT NULL,
  fName             CHAR(60)       NOT NULL,
  lName             CHAR(60)       NOT NULL,
  
  
  PRIMARY KEY(instructorID)

);



INSERT INTO semesters (semesterID, semesterName) VALUES
(1, 'Spring'),
(2, 'Summer'),
(3, 'Fall');


INSERT INTO courses(courseID, subjectName, courseName, credits, courseDescription) VALUES
(1, 'Math','Intro to math',3,'placeholder description'),
(2, 'Math','Intermediate math',3,'placeholder description'),
(3, 'Math','Advanced math',4,'placeholder description'),
(4, 'English','Intro to english',4,'placeholder description'),
(5, 'English','Intermediate english',4,'placeholder description'),
(6, 'English','Advanced english',3,'placeholder description'),
(7, 'History','Intro to history',4,'placeholder description'),
(8, 'History','Intermediate history',3,'placeholder description'),
(9, 'History','Advanced history',3,'placeholder description');

INSERT INTO CRN(semesterID, courseID, crnCode, section, day, time, location, instructorID) VALUES
(1, 1, 11111, 1, 'M,W,F', '1:00 - 2:00 PM', 'stanley 225', 1),
(1, 2, 11112, 2, 'T,TH', '3:00 - 4:00 PM', 'stanley 226', 1),
(1, 3, 21111, 1, 'M,W,F', '4:00 - 5:00 PM', 'stanley 225', 1),
(2, 4, 21112, 2, 'T,TH', '5:00 - 6:00 PM', 'cct 425', 2),
(2, 5, 31111, 1, 'M,W,F', '6:00 - 7:00 PM', 'cct 425', 2),
(2, 6, 31112, 2, 'T,TH', '7:00 - 8:00 PM', 'lenoir 215', 2),
(3, 7, 41111, 1, 'M,W,F', '8:00 - 9:00 PM', 'lenoir 215', 3),
(3, 8, 41112, 2, 'T,TH', '8:00 - 9:00 AM', 'stanley 125', 3),
(3, 9, 51111, 1, 'M,W,F', '7:00 - 8:00 AM', 'stanley 220', 3);


INSERT INTO instructors(instructorID, fName, lName) VALUES
(1,'Arnold','Schwartzeneger'),
(2,'Julius','Caesar'),
(3,'Beetle','Juice');

