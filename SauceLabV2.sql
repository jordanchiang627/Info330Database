CREATE DATABASE INFO_330B_Proj_SAUCELAB_V2

USE INFO_330B_Proj_SAUCELAB_V2
 
CREATE TABLE tblUNHOUSED_INDIVIDUAL (
   IndividualID INT IDENTITY (1, 1) PRIMARY KEY,
   IndividualFname VARCHAR (100),
   IndividualLname VARCHAR (100),
   BirthDate DATE,
   ContactEmail VARCHAR(50),
   ContactPhone VARCHAR(50),
   RaceID INT,
   EthnicityID INT,
   Gender VARCHAR(50)
)

CREATE TABLE tblRACE (
   RaceID INT IDENTITY (1, 1) PRIMARY KEY,
   RaceName VARCHAR (50)
)
 
CREATE TABLE tblETHNICITY (
   EthnicityID INT IDENTITY (1, 1) PRIMARY KEY,
   EthnicityName VARCHAR (50)
)
 
ALTER TABLE tblUNHOUSED_INDIVIDUAL
ADD CONSTRAINT FK_RaceID
FOREIGN KEY (RaceID) REFERENCES tblRACE(RaceID)
ALTER TABLE tblUNHOUSED_INDIVIDUAL
ADD CONSTRAINT FK_EthnicityID
FOREIGN KEY (EthnicityID) REFERENCES tblETHNICITY(EthnicityID)


CREATE TABLE tblSHELTER (
   ShelterID INT IDENTITY (1, 1) PRIMARY KEY,
   ShelterName VARCHAR (100),
   ShelterAddress VARCHAR (75),
   ShelterCity VARCHAR (50),
   ShelterState VARCHAR (25),
   ShelterZip INT,
   MaxResidents INT,
   CommunityType VARCHAR (50),
   BedCount INT
)
 
SELECT *
FROM tblSHELTER
 
 
CREATE TABLE tblWORKER (
   WorkerID INT IDENTITY (1, 1) PRIMARY KEY,
   WorkerFname VARCHAR (50),
   WorkerLname VARCHAR (50),
   WorkerAddress VARCHAR (50),
   WorkerCity VARCHAR (50),
   WorkerState VARCHAR (25),
   WorkerZip INT,
   WorkerEmail VARCHAR (50),
   WorkerPhone VARCHAR (50),
   WorkerBirth DATE,
)
 
CREATE TABLE tblSHELTER_WORKER (
   ShelterID INT REFERENCES tblSHELTER(ShelterID),
   WorkerID INT REFERENCES tblWORKER(WorkerID),
   BeginDate DATE,
   EndDate DATE,
   WorkerType VARCHAR (25),
   MonthlyPayment INT
)
 
SELECT *
FROM tblSHELTER_WORKER
 
CREATE TABLE tblSHELTER_HOURS (
   ShelterID INT REFERENCES tblSHELTER(ShelterID),
   DayID INT IDENTITY (1, 1) PRIMARY KEY,
   DayName VARCHAR (50),
   OpenTime TIME,
   CloseTime TIME
)
 
CREATE TABLE tblEMPLOYMENT (
   EmploymentID INT IDENTITY (1, 1) PRIMARY KEY,
   EmploymentType VARCHAR (50),
   BeginDate DATE,
   EndDate DATE
)
 
CREATE TABLE tblINDIVIDUAL_EMPLOYMENT (
   IndividualID INT REFERENCES tblUNHOUSED_INDIVIDUAL(IndividualID),
   EmploymentID INT REFERENCES tblEMPLOYMENT(EmploymentID)
)


 
CREATE TABLE tblSHELTER_INDIVIDUAL (
   ShelterID INT REFERENCES tblSHELTER(ShelterID),
   IndividualID INT REFERENCES tblUNHOUSED_INDIVIDUAL(IndividualID),
   PRIMARY KEY(ShelterID, IndividualID)
)
 


 
-- Stored Procedure to get IndividualID, ShelterID, RaceID, EthnicityID (Pooja and Jordan)
GO
CREATE OR ALTER PROCEDURE get_ind_id
@fname VARCHAR (100),
@lname VARCHAR (100),
@birth DATE,
@id INT OUTPUT
AS
SET @id = (SELECT IndividualID FROM tblUNHOUSED_INDIVIDUAL
          WHERE IndividualFname = @fname
          AND IndividualLname = @lname
          AND BirthDate = @birth)
GO
 
GO
CREATE OR ALTER PROCEDURE get_shelter_id
@sheltername VARCHAR (100),
@shelteraddress VARCHAR (100),
@shelterid INT OUTPUT
AS
SET @shelterid = (SELECT ShelterID FROM tblSHELTER
                 WHERE ShelterName = @sheltername
                 AND ShelterAddress = @shelteraddress)
GO

GO
CREATE OR ALTER PROCEDURE get_race_id
@racename VARCHAR (50),
@raceid INT OUTPUT
AS
SET @raceid = (SELECT RaceID FROM tblRACE
                WHERE RaceName = @racename)
GO
 
GO
CREATE OR ALTER PROCEDURE get_ethnicity_id
@ethnicityname VARCHAR (50),
@ethnicityid INT OUTPUT
AS
SET @ethnicityid = (SELECT EthnicityID FROM tblETHNICITY
                WHERE EthnicityName = @ethnicityname )
GO




-- Stored Procedure for tblUNHOUSED_INDIVIDUAL(POOJA)

GO
CREATE OR ALTER PROCEDURE insert_unhoused_individual
@i_fname VARCHAR(100),
@i_lname VARCHAR(100),
@i_birth DATE,
@contactemail VARCHAR(50),
@contactphone VARCHAR(50),
@i_racename VARCHAR(50),
@i_ethnicityname VARCHAR(50),
@gender VARCHAR(50),
@i_sheltername VARCHAR (100),
@i_shelteraddress VARCHAR (100)
AS
DECLARE @i_id INT, @i_shelterid INT, @i_raceid INT, @i_ethnicityid INT

BEGIN TRANSACTION

INSERT INTO tblRACE
VALUES (@i_racename)
INSERT INTO tblETHNICITY
VALUES (@i_ethnicityname)

EXEC get_race_id
@racename = @i_racename,
@raceid = @i_raceid OUTPUT
EXEC get_ethnicity_id
@ethnicityname = @i_ethnicityname,
@ethnicityid = @i_ethnicityid OUTPUT

INSERT INTO tblUNHOUSED_INDIVIDUAL
VALUES (@i_fname, @i_lname, @i_birth,
       @contactemail, @contactphone, @i_raceid, @i_ethnicityid, @gender)

EXEC get_ind_id
@fname = @i_fname,
@lname = @i_lname,
@birth = @i_birth,
@id = @i_id OUTPUT
EXEC get_shelter_id
@sheltername = @i_sheltername,
@shelteraddress = @i_shelteraddress,
@shelterid = @i_shelterid OUTPUT

INSERT INTO tblSHELTER_INDIVIDUAL
VALUES (@i_shelterid, @i_id)
COMMIT TRANSACTION
 
EXECUTE insert_unhoused_individual
@i_fname = 'Brett',
@i_lname = 'Summit',
@i_birth = '1990-10-30',
@contactemail ='wynonarhetta@gmail.com',
@contactphone = '4253242824',
@i_racename = 'White',
@i_ethnicityname = 'America',
@gender = 'Woman' ,
@i_sheltername = 'Bliss',
@i_shelteraddress = '123 Fake Street'
 
SELECT * FROM tblUNHOUSED_INDIVIDUAL
SELECT * FROM tblSHELTER_INDIVIDUAL
DELETE FROM tblINDIVIDUAL_EMPLOYMENT
DELETE FROM tblUNHOUSED_INDIVIDUAL
 
EXECUTE insert_unhoused_individual
@i_fname = 'Bob',
@i_lname = 'Robert',
@i_birth = '1982-04-05',
@contactemail ='bobrobert@gmail.com',
@contactphone = '4254234234',
@racename = 'White',
@ethnicityname = 'American',
@gender ='Male',
@i_sheltername = 'Comfort',
@i_shelteraddress = '456 West Way'

 
 
SELECT *
FROM tblUNHOUSED_INDIVIDUAL









 
-- Stored Procedure to populate tblSHELTER (Jordan)
 
GO
CREATE OR ALTER PROCEDURE register_shelter
@sheltername VARCHAR (100),
@shelteraddress VARCHAR (75),
@sheltercity VARCHAR (50),
@shelterstate VARCHAR (25),
@shelterzip INT,
@maxresidents INT,
@communitytype VARCHAR (50),
@bedcount INT
AS
INSERT INTO tblSHELTER
VALUES (@sheltername, @shelteraddress, @sheltercity, @shelterstate, @shelterzip, @maxresidents, @communitytype, @bedcount)


 
EXEC register_shelter
@sheltername = 'Bliss',
@shelteraddress = '123 Fake Street',
@sheltercity = 'Seattle',
@shelterstate = 'Washington, WA',
@shelterzip = 98105,
@maxresidents = 100,
@communitytype = 'Urban',
@bedcount = 100
 
EXEC register_shelter
@sheltername = 'Comfort',
@shelteraddress = '456 West Way',
@sheltercity = 'Belmont',
@shelterstate = 'California, CA',
@shelterzip = 94002,
@maxresidents = 250,
@communitytype = 'Suburban',
@bedcount = 250
UPDATE tblSHELTER
SET ShelterCity = 'Federal Way', ShelterState = 'Washington, WA', ShelterZip = 98001
WHERE ShelterCity = 'Belmont'

EXEC register_shelter
@sheltername = 'NewHome',
@shelteraddress = '789 Random Aveune',
@sheltercity = 'Wichita',
@shelterstate = 'Kansas, KS',
@shelterzip = 67052,
@maxresidents = 100,
@communitytype = 'Rural',
@bedcount = 100
UPDATE tblSHELTER
SET ShelterCity = 'Spokane', ShelterState = 'Washington, WA', ShelterZip = 99201, BedCount = 5
WHERE ShelterCity = 'Wichita'
 
EXEC register_shelter
@sheltername = 'HelpingHands',
@shelteraddress = '555 Some Place',
@sheltercity = 'New York City',
@shelterstate = 'New York, NY',
@shelterzip = 10001,
@maxresidents = 300,
@communitytype = 'Urban',
@bedcount = 300
UPDATE tblSHELTER
SET ShelterCity = 'Bellingham', ShelterState = 'Washington, WA', ShelterZip = 98229
WHERE ShelterCity = 'New York City'
 





 

 
--Stored procedure for tblSHELTER_HOURS (Daria)

GO
CREATE OR ALTER PROCEDURE register_shelter_time
@i_sheltername VARCHAR(100),
@i_shelteraddress VARCHAR (75),
@i_dayname VARCHAR(50),
@i_opentime TIME,
@i_closetime TIME
AS
DECLARE @i_shelterid INT
 
EXEC get_shelter_id
@shelterid = @i_shelterid OUTPUT,
@sheltername = @i_sheltername,
@shelteraddress = @i_shelteraddress
 
BEGIN TRANSACTION T1
INSERT INTO tblSHELTER_HOURS
VALUES (@i_shelterid, @i_dayname, @i_opentime, @i_closetime)
COMMIT TRANSACTION T1
 
GO
EXEC register_shelter_time
@i_sheltername = 'Bliss',
@i_shelteraddress = '123 Fake Street',
@i_dayname = 'Monday',
@i_opentime = '8:30AM',
@i_closetime = '5:00PM'
 
GO
EXEC register_shelter_time
@i_sheltername = 'Bliss',
@i_shelteraddress = '123 Fake Street',
@i_dayname = 'Tuesday',
@i_opentime = '8:30AM',
@i_closetime = '5:00PM'
 
GO
EXEC register_shelter_time
@i_sheltername = 'Bliss',
@i_shelteraddress = '123 Fake Street',
@i_dayname = 'Wednesday',
@i_opentime = '8:30AM',
@i_closetime = '5:00PM'
 
GO
EXEC register_shelter_time
@i_sheltername = 'Bliss',
@i_shelteraddress = '123 Fake Street',
@i_dayname = 'Thursday',
@i_opentime = '8:30AM',
@i_closetime = '5:00PM'

GO
EXEC register_shelter_time
@i_sheltername = 'Bliss',
@i_shelteraddress = '123 Fake Street',
@i_dayname = 'Friday',
@i_opentime = '8:30AM',
@i_closetime = '5:00PM'

GO
EXEC register_shelter_time
@i_sheltername = 'Bliss',
@i_shelteraddress = '123 Fake Street',
@i_dayname = 'Saturday',
@i_opentime = '12:00AM',
@i_closetime = '11:59PM'

GO
EXEC register_shelter_time
@i_sheltername = 'Bliss',
@i_shelteraddress = '123 Fake Street',
@i_dayname = 'Sunday',
@i_opentime = '12:00AM',
@i_closetime = '11:59PM'

GO
EXEC register_shelter_time
@i_sheltername = 'Comfort',
@i_shelteraddress = '456 West Way',
@i_dayname = 'Monday',
@i_opentime = '6:00PM',
@i_closetime = '8:00AM'

 
GO
EXEC register_shelter_time
@i_sheltername = 'Comfort',
@i_shelteraddress = '456 West Way',
@i_dayname = 'Tuesday',
@i_opentime = '6:00PM',
@i_closetime = '8:00AM'
 
GO
EXEC register_shelter_time
@i_sheltername = 'Comfort',
@i_shelteraddress = '456 West Way',
@i_dayname = 'Wednesday',
@i_opentime = '6:00PM',
@i_closetime = '8:00AM'

GO
EXEC register_shelter_time
@i_sheltername = 'Comfort',
@i_shelteraddress = '456 West Way',
@i_dayname = 'Thursday',
@i_opentime = '6:00PM',
@i_closetime = '8:00AM'
 
GO
EXEC register_shelter_time
@i_sheltername = 'Comfort',
@i_shelteraddress = '456 West Way',
@i_dayname = 'Friday',
@i_opentime = '6:00PM',
@i_closetime = '8:00AM'

GO
EXEC register_shelter_time
@i_sheltername = 'Comfort',
@i_shelteraddress = '456 West Way',
@i_dayname = 'Saturday',
@i_opentime = '12:00AM',
@i_closetime = '11:59PM'

GO
EXEC register_shelter_time
@i_sheltername = 'Comfort',
@i_shelteraddress = '456 West Way',
@i_dayname = 'Sunday',
@i_opentime = '12:00AM',
@i_closetime = '11:59PM'

GO
EXEC register_shelter_time
@i_sheltername = 'NewHome',
@i_shelteraddress = '789 Random Aveune',
@i_dayname = 'Monday',
@i_opentime = '8:00AM',
@i_closetime = '7:00PM'
 
GO
EXEC register_shelter_time
@i_sheltername = 'NewHome',
@i_shelteraddress = '789 Random Aveune',
@i_dayname = 'Tuesday',
@i_opentime = '8:00AM',
@i_closetime = '7:00PM'
 
GO
EXEC register_shelter_time
@i_sheltername = 'NewHome',
@i_shelteraddress = '789 Random Aveune',
@i_dayname = 'Wednesday',
@i_opentime = '8:00AM',
@i_closetime = '7:00PM'
 
GO
EXEC register_shelter_time
@i_sheltername = 'NewHome',
@i_shelteraddress = '789 Random Aveune',
@i_dayname = 'Thursday',
@i_opentime = '8:00AM',
@i_closetime = '7:00PM'

GO
EXEC register_shelter_time
@i_sheltername = 'NewHome',
@i_shelteraddress = '789 Random Aveune',
@i_dayname = 'Friday',
@i_opentime = '8:00AM',
@i_closetime = '7:00PM'

GO
EXEC register_shelter_time
@i_sheltername = 'NewHome',
@i_shelteraddress = '789 Random Aveune',
@i_dayname = 'Saturday',
@i_opentime = '10:00AM',
@i_closetime = '10:00PM'

GO
EXEC register_shelter_time
@i_sheltername = 'NewHome',
@i_shelteraddress = '789 Random Aveune',
@i_dayname = 'Sunday',
@i_opentime = '10:00AM',
@i_closetime = '10:00PM'

GO
EXEC register_shelter_time
@i_sheltername = 'HelpingHands',
@i_shelteraddress = '555 Some Place',
@i_dayname = 'Monday',
@i_opentime = '8:00AM',
@i_closetime = '7:00PM'
 
GO
EXEC register_shelter_time
@i_sheltername = 'HelpingHands',
@i_shelteraddress = '555 Some Place',
@i_dayname = 'Tuesday',
@i_opentime = '8:00AM',
@i_closetime = '7:00PM'
 
GO
EXEC register_shelter_time
@i_sheltername = 'HelpingHands',
@i_shelteraddress = '555 Some Place',
@i_dayname = 'Wednesday',
@i_opentime = '8:00AM',
@i_closetime = '7:00PM'

GO
EXEC register_shelter_time
@i_sheltername = 'HelpingHands',
@i_shelteraddress = '555 Some Place',
@i_dayname = 'Thursday',
@i_opentime = '8:00AM',
@i_closetime = '7:00PM'

GO
EXEC register_shelter_time
@i_sheltername = 'HelpingHands',
@i_shelteraddress = '555 Some Place',
@i_dayname = 'Friday',
@i_opentime = '8:00AM',
@i_closetime = '7:00PM'

GO
EXEC register_shelter_time
@i_sheltername = 'HelpingHands',
@i_shelteraddress = '555 Some Place',
@i_dayname = 'Saturday',
@i_opentime = '6:00AM',
@i_closetime = '11:00PM'

GO
EXEC register_shelter_time
@i_sheltername = 'HelpingHands',
@i_shelteraddress = '555 Some Place',
@i_dayname = 'Sunday',
@i_opentime = '6:00AM',
@i_closetime = '11:00PM'









 
--Stored procedure for tblWORKER (DARIA)
GO 
CREATE OR ALTER PROCEDURE get_worker_id 
@workerid INT OUTPUT,
@workerfname VARCHAR(50),
@workerlname VARCHAR(50),
@workerbirth DATE
AS 
SET @workerid = (SELECT WorkerID FROM tblWORKER 
WHERE WorkerFname = @workerfname 
AND WorkerBirth = @workerbirth
AND WorkerLname = @workerlname) 

GO 
CREATE OR ALTER PROCEDURE get_shelter_id 
@shelterid INT OUTPUT,
@sheltername VARCHAR(100),
@shelteraddress VARCHAR(75)
AS 
SET @shelterid = (SELECT ShelterID FROM tblSHELTER 
WHERE ShelterName = @sheltername
AND ShelterAddress = @shelteraddress)


GO 
CREATE OR ALTER PROCEDURE insert_worker 
@i_workerfname VARCHAR (50),
@i_workerlname VARCHAR (50),
@WorkerAddress VARCHAR (50),
@WorkerCity VARCHAR (50),
@WorkerState VARCHAR (50),
@WorkerZip INT,
@WorkerEmail VARCHAR (50),
@WorkerPhone VARCHAR (50),
@i_workerbirth DATE,
@i_sheltername VARCHAR (50),
@i_shelteraddress VARCHAR (50),
@begindate DATE,
@enddate DATE,
@workertype VARCHAR (50),
@monthlypayment INT
AS 
DECLARE @i_W_ID INT, @i_S_ID INT
BEGIN TRANSACTION
INSERT INTO tblWORKER
VALUES (@i_workerfname,
@i_workerlname,
@WorkerAddress,
@WorkerCity,
@WorkerState,
@WorkerZip,
@WorkerEmail,
@WorkerPhone,
@i_workerbirth)
EXEC get_worker_id
@workerfname = @i_workerfname,
@workerlname = @i_workerlname,
@workerbirth = @i_workerbirth,
@workerid = @i_W_ID OUTPUT
EXEC get_shelter_id
@sheltername = @i_sheltername,
@shelteraddress = @i_shelteraddress,
@shelterid = @i_S_ID OUTPUT 
INSERT INTO tblSHELTER_WORKER 
VALUES (@i_S_ID, @i_W_ID, @begindate, @enddate, @workertype, @monthlypayment)
COMMIT TRANSACTION

GO
EXEC insert_worker
@i_workerfname = 'Borys',
@i_workerlname = 'Johnson',
@WorkerAddress = '7865 E John St',
@WorkerCity = 'Fremont',
@WorkerState = 'Washington, WA',
@WorkerZip = 98055,
@WorkerPhone = '206-785-3019',
@WorkerEmail = 'bjohnson@aol.com',
@i_workerbirth = '1987-06-27',
@i_sheltername = 'Bliss',
@i_shelteraddress = '123 Fake Street',
@begindate = '2020-09-19',
@enddate = NULL,
@workertype = 'Employee',
@monthlypayment = 800
 
GO
EXEC insert_worker
@i_workerfname = 'Sam',
@i_workerlname = 'John',
@WorkerAddress = '6789 N Falway Ln',
@WorkerCity = 'Tacoma',
@WorkerState = 'Washington, WA',
@WorkerZip = 98102,
@WorkerPhone = '809-367-5489',
@WorkerEmail = 'samjohn@hotmail.com',
@i_workerbirth = '1997-09-18',
@i_sheltername = 'Bliss',
@i_shelteraddress = '123 Fake Street',
@begindate = '2021-03-04',
@enddate = NULL,
@workertype = 'Volunteer',
@monthlypayment = 0

GO
EXEC insert_worker
@i_workerfname = 'Woody',
@i_workerlname = 'Cox',
@WorkerAddress = '678 E Drive Ln',
@WorkerCity = 'Kirkland',
@WorkerState = 'Washington, WA',
@WorkerZip = 98775,
@WorkerPhone = '206-754-1098',
@WorkerEmail = 'woodycox123@gmail.com',
@i_workerbirth = '1989-09-16',
@i_sheltername = 'Bliss',
@i_shelteraddress = '123 Fake Street',
@begindate = '2022-09-11',
@enddate = NULL,
@workertype = 'Employee',
@monthlypayment = 1000
 
GO
EXEC insert_worker
@i_workerfname = 'Summer',
@i_workerlname = 'Jacobson',
@WorkerAddress = '789 30th St',
@WorkerCity = 'Northgate',
@WorkerState = 'Washington, WA',
@WorkerZip = 99204,
@WorkerPhone = '206-785-4793',
@WorkerEmail = 'summerjac@aol.com',
@i_workerbirth = '2001-09-17',
@i_sheltername = 'Comfort',
@i_shelteraddress = '456 West Way',
@begindate = '2022-01-05',
@enddate = NULL,
@workertype = 'Employee',
@monthlypayment = 1500
 
GO
EXEC insert_worker
@i_workerfname = 'Lily',
@i_workerlname = 'Harrill',
@WorkerAddress = '4877 17th Ave NE',
@WorkerCity = 'Capitol Hill',
@WorkerState = 'Washington, WA',
@WorkerZip = 97689,
@WorkerPhone = '678-456-7345',
@WorkerEmail = 'llilyh@hotmail.com',
@i_workerbirth = '2000-09-17',
@i_sheltername = 'Comfort',
@i_shelteraddress = '456 West Way',
@begindate = '2020-10-18',
@enddate = '2021-03-14',
@workertype = 'Volunteer',
@monthlypayment = 0

GO
EXEC insert_worker
@i_workerfname = 'Adrian',
@i_workerlname = 'Bowton',
@WorkerAddress = '563 E 189th Ave',
@WorkerCity = 'Seattle',
@WorkerState = 'Washington, WA',
@WorkerZip = 99205,
@WorkerPhone = '890-674-1256',
@WorkerEmail = 'adrianb@gmail.com',
@i_workerbirth = '1989-05-26',
@i_sheltername = 'NewHome',
@i_shelteraddress = '789 Random Aveune',
@begindate = '2021-02-24',
@enddate = NULL,
@workertype = 'Volunteer',
@monthlypayment = 0

GO
EXEC insert_worker
@i_workerfname = 'Ally',
@i_workerlname = 'Fleming',
@WorkerAddress = '6789 N Conklin St',
@WorkerCity = 'Kirkland',
@WorkerState = 'Washington, WA',
@WorkerZip = 98443,
@WorkerPhone = '765-345-8945',
@WorkerEmail = 'allyfleming@aol.com',
@i_workerbirth = '1978-07-15',
@i_sheltername = 'NewHome',
@i_shelteraddress = '789 Random Aveune',
@begindate = '2022-03-14',
@enddate = NULL,
@workertype = 'Employee',
@monthlypayment = 10000

GO
EXEC insert_worker
@i_workerfname = 'Bob',
@i_workerlname = 'Weir',
@WorkerAddress = '7866 S Magnolia St',
@WorkerCity = 'Ballard',
@WorkerState = 'Washington, WA',
@WorkerZip = 96754,
@WorkerPhone = '509-989-7654',
@WorkerEmail = 'bobbobw@aol.com',
@i_workerbirth = '1988-07-05',
@i_sheltername = 'HelpingHands',
@i_shelteraddress = '555 Some Place',
@begindate = '2018-03-29',
@enddate = '2020-10-31',
@workertype = 'Employee',
@monthlypayment = 8000

GO
EXEC insert_worker
@i_workerfname = 'Madi',
@i_workerlname = 'Lang',
@WorkerAddress = '7898 45th Ave NE',
@WorkerCity = 'Seattle',
@WorkerState = 'Washington, WA',
@WorkerZip = 96223,
@WorkerPhone = '609-879-2356',
@WorkerEmail = 'madiii@gmail.com',
@i_workerbirth = '1998-06-25',
@i_sheltername = 'HelpingHands',
@i_shelteraddress = '555 Some Place',
@begindate = '2017-12-10',
@enddate = NULL,
@workertype = 'Employee',
@monthlypayment = 8750
 
GO
EXEC insert_worker
@i_workerfname = 'George',
@i_workerlname = 'Clooney',
@WorkerAddress = '4556 21st Ave NE',
@WorkerCity = 'Spokane',
@WorkerState = 'Washington, WA',
@WorkerZip = 99842,
@WorkerPhone = '206-678-9032',
@WorkerEmail = 'georgec@hotmail.com',
@i_workerbirth = '2002-10-15',
@i_sheltername = 'HelpingHands',
@i_shelteraddress = '555 Some Place',
@begindate = '2021-11-25',
@enddate = NULL,
@workertype = 'Volunteer',
@monthlypayment = 0


-- Stored Procedure to populate tblEMPLOYMENT and tblINDIVIDUAL_EMPLOYMENT (Jordan)
 
GO
CREATE OR ALTER PROCEDURE get_employmentid
@employmenttype VARCHAR (50),
@begindate DATE,
@empid INT OUTPUT
AS
SET @empid = (SELECT EmploymentID FROM tblEMPLOYMENT
             WHERE EmploymentType = @employmenttype
             AND BeginDate = @begindate)
GO
 
GO
CREATE OR ALTER PROCEDURE insert_employment
@i_employmenttype VARCHAR (50),
@i_begindate DATE,
@enddate DATE,
@i_fname VARCHAR(100),
@i_lname VARCHAR(100),
@i_birth DATE
AS
DECLARE @i_empid INT, @i_id INT
BEGIN TRANSACTION
INSERT INTO tblEMPLOYMENT
VALUES (@i_employmenttype, @i_begindate, @enddate)
EXEC get_employmentid
@employmenttype = @i_employmenttype,
@begindate = @i_begindate,
@empid = @i_empid OUTPUT
EXEC get_ind_id
@fname = @i_fname,
@lname = @i_lname,
@birth = @i_birth,
@id = @i_id OUTPUT
INSERT INTO tblINDIVIDUAL_EMPLOYMENT
VALUES (@i_id, @i_empid)
COMMIT TRANSACTION
 
EXEC insert_employment
@i_employmenttype = 'McDonalds Worker',
@i_begindate = '1990-02-24',
@enddate = '1995-08-29',
@i_fname = 'Brett',
@i_lname = 'Summit',
@i_birth = '1990-10-30'
 
 
SELECT * FROM tblINDIVIDUAL_EMPLOYMENT
SELECT * FROM tblEMPLOYMENT
SELECT * FROM tblUNHOUSED_INDIVIDUAL

/* Pooja: SQL that enforces the rule: "No Unhoused Individual under 18 is allowed to be in the homeless shelters. " This should be unforced because youth that are under 18 should put
in contact with CPS so they can be situated with a living situation that is not in the shelters since they are not adults yet. */
GO 
CREATE OR ALTER FUNCTION check_if_ind_is_a_minor()
RETURNS INT
AS 
BEGIN
DECLARE @ret INT = 0
IF EXISTS(SELECT IndividualID
            FROM tblUNHOUSED_INDIVIDUAL
            WHERE Birthdate > DATEADD(YEAR, -18, getdate())
)
SET @ret = 1
RETURN @ret
END
GO

ALTER TABLE tblUNHOUSED_INDIVIDUAL WITH NOCHECK
ADD CONSTRAINT ch_check_if_ind_is_a_minor
CHECK(dbo.check_if_ind_is_a_minor() = 0)

/* Pooja: SQL that enforces the rule that the Shelter is in Washington so that unhoused individuals in the State of Washington have a specific database to look at to find
shelters if need by. Makes for more accesssibily and specific for a population */
GO 
CREATE OR ALTER FUNCTION check_if_shelter_in_WA()
RETURNS INT
AS 
BEGIN
DECLARE @ret INT = 0
IF EXISTS(SELECT ShelterID
            FROM tblSHELTER
            WHERE ShelterState = 'Washington'
)
SET @ret = 1
RETURN @ret
END
GO

ALTER TABLE tblSHELTER WITH NOCHECK
ADD CONSTRAINT ch_check_if_shelter_in_WA
CHECK(dbo.check_if_shelter_in_WA() = 0)

--Enforces the following business rule: "No worker should be under 18." This is important because working in a 
--homeless shelter can have more associated risk than other jobs. Therefore it is important that workers
--can be legal adults and make the decision for themselves if they want to work in a shelter. (Daria)
GO 
CREATE OR ALTER FUNCTION fn_constrant_drm2() 
RETURNS INT 
AS 
BEGIN 
DECLARE @ret INT = 0 
IF EXISTS (SELECT * FROM tblWORKER w
            JOIN tblSHELTER_WORKER sw ON w.WorkerID = sw.WorkerID
            WHERE DATEDIFF(year, w.WorkerBirth, getdate()) < 18
            AND sw.WorkerType = 'Employee') 
SET @ret = 1 
RETURN @ret 
END 

GO 
ALTER TABLE tblWORKER WITH NOCHECK 
ADD CONSTRAINT chk_worker_volunteer_18_year_drm 
CHECK(dbo.fn_constrant_drm2() = 0) 

--Enforces the following business rule: "No shelter that can house more than 200 residents
--should be closed on Monday's." Many homeless shelters are closed on the weekend and therefore there becomes 
--an elevated amount of unhousedindviduals looking for shelter on Monday's. 
--Therefore, large shelters should be open on Monday's to accomadate this increased capacity. (Daria)
GO 
CREATE OR ALTER FUNCTION fn_constrant_drm3() 
RETURNS INT 
AS 
BEGIN 
DECLARE @ret INT = 0 
IF EXISTS (SELECT * FROM tblSHELTER_HOURS sh
            JOIN tblSHELTER s ON sh.ShelterID = s.ShelterID
            WHERE sh.DayName = 'Monday'
            AND sh.OpenTime IS NULL 
            AND sh.CloseTime IS NULL
            AND s.MaxResidents > 200) 
SET @ret = 1 
RETURN @ret 
END 

GO 
ALTER TABLE tblSHELTER_HOURS WITH NOCHECK 
ADD CONSTRAINT chk_shelter_hours_drm 
CHECK(dbo.fn_constrant_drm3() = 0) 

-- Jordan: Enforces the business rule: "A worker cannot be registered if they are a voluneteer and have a monthly payment above 0."
-- This seems like a no brainer, but a worker cannot be a volunteer if they are getting paid. This keeps the data integrity as someone
-- may accidentally fill out the form wrong.

GO
CREATE OR ALTER FUNCTION fn_reject_fake_volunteer ()
RETURNS INT
AS
BEGIN
DECLARE @ret INT = 0
IF EXISTS (SELECT * FROM tblWORKER w
           JOIN tblSHELTER_WORKER sw ON w.WorkerID = sw.WorkerID
           WHERE sw.WorkerType = 'Volunteer'
           AND sw.MonthlyPayment > 0)
SET @ret = 1 
RETURN @ret
END

GO
ALTER TABLE tblSHELTER_WORKER WITH NOCHECK
ADD CONSTRAINT chk_paid_volunteers
CHECK(dbo.fn_reject_fake_volunteer() = 0)

EXEC insert_worker
@i_workerfname = 'Jordan',
@i_workerlname = 'Chiang',
@WorkerAddress = '4703 21st Ave NE',
@WorkerCity = 'Seattle',
@WorkerState = 'Washington, WA',
@WorkerZip = 98105,
@WorkerEmail = 'jchian@uw.edu',
@WorkerPhone = '650-576-1262',
@i_workerbirth = '2002-06-27',
@i_sheltername = 'Bliss',
@i_shelteraddress = '123 Fake Street',
@begindate = '2022-12-02',
@enddate = NULL,
@workertype = 'Volunteer',
@monthlypayment = 100000000

-- Jordan: Enforces the following business rule: "An individual cannot reigster into a shelter if the bed count is at capacity". This
-- is important because if the beds are maxed out, the individual does not have a bed to sleep in.

GO
CREATE OR ALTER FUNCTION fn_reject_register_bliss ()
RETURNS INT
AS 
BEGIN 
DECLARE @ret INT = 0
IF EXISTS (SELECT ui.IndividualFname, ui.IndividualLname, s.BedCount 
           FROM tblUNHOUSED_INDIVIDUAL ui
           JOIN tblSHELTER_INDIVIDUAL si ON ui.IndividualID = si.IndividualID
           JOIN tblSHELTER s ON si.ShelterID = s.ShelterID
           WHERE s.ShelterName = 'Bliss'
           GROUP BY ui.IndividualFname, ui.IndividualLname, s.BedCount
           HAVING COUNT(si.IndividualID) > s.BedCount)
SET @ret = 1
RETURN @ret
END

GO
ALTER TABLE tblUNHOUSED_INDIVIDUAL WITH NOCHECK
ADD CONSTRAINT chk_bliss_overflow
CHECK(dbo.fn_reject_register_bliss() = 0)

GO
CREATE OR ALTER FUNCTION fn_reject_register_comfort ()
RETURNS INT
AS 
BEGIN 
DECLARE @ret INT = 0
IF EXISTS (SELECT ui.IndividualFname, ui.IndividualLname, s.BedCount 
           FROM tblUNHOUSED_INDIVIDUAL ui
           JOIN tblSHELTER_INDIVIDUAL si ON ui.IndividualID = si.IndividualID
           JOIN tblSHELTER s ON si.ShelterID = s.ShelterID
           WHERE s.ShelterName = 'Comfort'
           GROUP BY ui.IndividualFname, ui.IndividualLname, s.BedCount
           HAVING COUNT(si.IndividualID) > s.BedCount)
SET @ret = 1
RETURN @ret
END

GO
ALTER TABLE tblUNHOUSED_INDIVIDUAL WITH NOCHECK
ADD CONSTRAINT chk_comfort_overflow
CHECK(dbo.fn_reject_register_comfort() = 0)

GO
CREATE OR ALTER FUNCTION fn_reject_register_newhome ()
RETURNS INT
AS 
BEGIN 
DECLARE @ret INT = 0
IF EXISTS (SELECT ui.IndividualFname, ui.IndividualLname, s.BedCount 
           FROM tblUNHOUSED_INDIVIDUAL ui
           JOIN tblSHELTER_INDIVIDUAL si ON ui.IndividualID = si.IndividualID
           JOIN tblSHELTER s ON si.ShelterID = s.ShelterID
           WHERE s.ShelterName = 'NewHome'
           GROUP BY ui.IndividualFname, ui.IndividualLname, s.BedCount
           HAVING COUNT(si.IndividualID) > s.BedCount)
SET @ret = 1
RETURN @ret
END

GO
ALTER TABLE tblUNHOUSED_INDIVIDUAL WITH NOCHECK
ADD CONSTRAINT chk_newhome_overflow
CHECK(dbo.fn_reject_register_newhome() = 0)
           
GO
CREATE OR ALTER FUNCTION fn_reject_register_helpinghands ()
RETURNS INT
AS 
BEGIN 
DECLARE @ret INT = 0
IF EXISTS (SELECT ui.IndividualFname, ui.IndividualLname, s.BedCount 
           FROM tblUNHOUSED_INDIVIDUAL ui
           JOIN tblSHELTER_INDIVIDUAL si ON ui.IndividualID = si.IndividualID
           JOIN tblSHELTER s ON si.ShelterID = s.ShelterID
           WHERE s.ShelterName = 'HelpingHands'
           GROUP BY ui.IndividualFname, ui.IndividualLname, s.BedCount
           HAVING COUNT(si.IndividualID) > s.BedCount)
SET @ret = 1
RETURN @ret
END

GO
ALTER TABLE tblUNHOUSED_INDIVIDUAL WITH NOCHECK
ADD CONSTRAINT chk_helpinghands_overflow
CHECK(dbo.fn_reject_register_helpinghands() = 0)



--Returns a list of shelters that are open on Fridays, have max residents over 100, and have a volunter (Daria)
SELECT s.ShelterName
FROM tblSHELTER s 
JOIN tblSHELTER_HOURS sh ON s.ShelterID = sh.ShelterID 
JOIN tblSHELTER_WORKER sw ON s.ShelterID = sw.ShelterID 
JOIN tblWORKER w ON sw.WorkerID = w.WorkerID 
WHERE sh.DayName = 'Friday'
AND sh.OpenTime IS NOT NULL 
AND sh.CloseTime IS NOT NULL
AND s.MaxResidents > 100
AND sw.WorkerType = 'Volunteer'
GROUP BY s.ShelterName

--Returns a list of workers or volunteers that have a zip code starting with '98’ (Daria)
SELECT w.WorkerFname, w.WorkerLname, s.ShelterName, sw.WorkerType, w.WorkerZip
FROM tblWORKER w 
JOIN tblSHELTER_WORKER sw ON w.WorkerID = sw.WorkerID 
JOIN tblSHELTER s ON sw.ShelterID = s.ShelterID 
WHERE (sw.WorkerType = 'Employee' OR sw.WorkerType = 'Volunteer')
AND w.WorkerZip LIKE '98%'

/* Write the SQL to determine which individuals have been employed at least 2 years before 2020 and
who were also born in 1995. Return the individual first and last name. */ 

SELECT tblUNHOUSED_INDIVIDUAL.IndividualFname, tblUNHOUSED_INDIVIDUAL.IndividualLname
FROM tblUNHOUSED_INDIVIDUAL 
JOIN tblINDIVIDUAL_EMPLOYMENT ON tblUNHOUSED_INDIVIDUAL.IndividualID = tblINDIVIDUAL_EMPLOYMENT.IndividualID
JOIN tblEMPLOYMENT ON tblINDIVIDUAL_EMPLOYMENT.EmploymentID =  tblEMPLOYMENT.EmploymentID 
WHERE (DATEDIFF(YEAR, tblEMPLOYMENT.BeginDate, tblEMPLOYMENT.EndDate)) > 2
AND tblUNHOUSED_INDIVIDUAL.Birthdate LIKE '1995%'

/* Write the SQL code to return the shelters with more than 50 bed counts in the State of Washington 
where the shelters are open on the weekends ordered from the shelters with the most bed counts to least */

SELECT tblSHELTER.ShelterName, SUM(tblShelter.BedCount) AS TotalBedCount
FROM tblSHELTER
JOIN tblSHELTER_HOURS ON tblSHELTER.ShelterID = tblSHELTER_HOURS.ShelterID
WHERE tblSHELTER.ShelterState = 'Washington'
AND (tblSHELTER.DayName = 'Saturday' OR tblSHELTER.DayName = 'Sunday')
GROUP BY tblSHELTER.ShelterName
HAVING SUM(tblSHELTER.ShelterName) => 50
ORDER BY TotalBedCount DESC

-- Jordan: Returns the names, payment amount, and which shelter a worker works at with the condition 
-- that they must make over $5,000 per month

SELECT w.WorkerFname, w.WorkerLname, sw.MonthlyPayment, s.ShelterName
FROM tblWorker w
JOIN tblSHELTER_WORKER sw ON w.WorkerID = sw.WorkerID
JOIN tblSHELTER s ON sw.ShelterID = s.ShelterID
WHERE sw.MonthlyPayment > 5000

-- Jordan: Ranks the shelters by who has the most employed unhoused individuals 

SELECT s.ShelterName, COUNT(e.BeginDate) AS NumEmployed
FROM tblUNHOUSED_INDIVIDUAL ui 
JOIN tblINDIVIDUAL_EMPLOYMENT ie ON ui.IndividualID = ie.IndividualID
JOIN tblEMPLOYMENT e ON e.EmploymentID = ie.EmploymentID
JOIN tblSHELTER_INDIVIDUAL si ON ui.IndividualID = si.IndividualID
JOIN tblSHELTER s ON si.ShelterID = s.ShelterID
GROUP BY s.ShelterName
ORDER BY NumEmployed DESC
