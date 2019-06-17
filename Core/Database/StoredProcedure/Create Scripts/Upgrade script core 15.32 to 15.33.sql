----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.32)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.32 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END

------ STEP 2 ----------
--Part1 Begin


--Part1 Ends

--Part2 Begins

--Part2 Ends	

-----End of Step 2 -------

------ STEP 3 ------------

IF OBJECT_ID('BedAvailabilityHistory') IS NOT NULL
BEGIN

IF EXISTS( select 1 from INFORMATION_SCHEMA.COLUMNS IC where TABLE_NAME = 'BedAvailabilityHistory' and COLUMN_NAME = 'StartDate'  and DATA_TYPE='date')
 BEGIN
	ALTER TABLE BedAvailabilityHistory ALTER COLUMN  StartDate datetime NULL
 END
 
IF EXISTS( select 1 from INFORMATION_SCHEMA.COLUMNS IC where TABLE_NAME = 'BedAvailabilityHistory' and COLUMN_NAME = 'EndDate'  and DATA_TYPE='date')
 BEGIN
	ALTER TABLE BedAvailabilityHistory ALTER COLUMN  EndDate datetime NULL
 END
 
	PRINT 'STEP 3 COMPLETED'
END
GO

-----END Of STEP 3--------------------

------ STEP 4 ------------
----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.32)
BEGIN
Update SystemConfigurations set DataModelVersion=15.33
PRINT 'STEP 7 COMPLETED'
END
Go