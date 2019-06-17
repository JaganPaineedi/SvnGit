----- STEP 1 ----------
IF ((SELECT value FROM SystemConfigurationKeys WHERE [key] = 'CDM_Admission')  < 1.0 ) or
NOT EXISTS(SELECT 1 FROM SystemConfigurationKeys WHERE [key] = 'CDM_Admission')
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 1.0 for CDM_Admission update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
-------- STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins

--Part2 Ends	

-----End of Step 2 -------

------ STEP 3 ------------ 

 IF OBJECT_ID('CustomClients') IS NOT NULL
 BEGIN
 
	IF COL_LENGTH('CustomClients','InterpreterNeeded')IS NULL
	BEGIN 
		ALTER TABLE CustomClients ADD InterpreterNeeded type_GlobalCode NULL										
	END
	
	IF COL_LENGTH('CustomClients','Race')IS NULL
	BEGIN 
		ALTER TABLE CustomClients ADD Race varchar(30) NULL										
	END
	
	IF COL_LENGTH('CustomClients','Ethnicity')IS NULL
	BEGIN 
		ALTER TABLE CustomClients ADD Ethnicity varchar(30) NULL										
	END
	
	IF COL_LENGTH('CustomClients','MaritalStatus')IS NULL
	BEGIN 
		ALTER TABLE CustomClients ADD MaritalStatus varchar(30) NULL										
	END
	
	IF COL_LENGTH('CustomClients','EmploymentStatus')IS NULL
	BEGIN 
		ALTER TABLE CustomClients ADD EmploymentStatus varchar(30) NULL										
	END
	
	IF COL_LENGTH('CustomClients','EmploymentStartDate')IS NULL
	BEGIN 
		ALTER TABLE CustomClients ADD EmploymentStartDate date NULL										
	END
	
	IF COL_LENGTH('CustomClients','EmploymentEndDate')IS NULL
	BEGIN 
		ALTER TABLE CustomClients ADD EmploymentEndDate date NULL										
	END
	
	IF COL_LENGTH('CustomClients','WellVisitLast12Months')IS NULL
	BEGIN 
		ALTER TABLE CustomClients ADD WellVisitLast12Months type_YOrN NULL	
								   CHECK (WellVisitLast12Months in ('Y','N'))											
	END
	
	IF COL_LENGTH('CustomClients','WellVisitLastDate')IS NULL
	BEGIN 
		ALTER TABLE CustomClients ADD WellVisitLastDate datetime NULL										
	END
	
	IF COL_LENGTH('CustomClients','WellVisitReferralDate')IS NULL
	BEGIN 
		ALTER TABLE CustomClients ADD WellVisitReferralDate datetime NULL										
	END

PRINT 'STEP 3 COMPLETED'
END
-----END Of STEP 3--------------------
------ STEP 4 ------------
----END Of STEP 4------------
------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------
------ STEP 7 -----------

IF ((SELECT cast(value as decimal(10,2)) FROM SystemConfigurationKeys WHERE [key] = 'CDM_Admission')  = 1.0 )
BEGIN
	UPDATE SystemConfigurationKeys SET value ='1.1' WHERE [key] = 'CDM_Admission'
	PRINT 'STEP 7 COMPLETED'
END
GO