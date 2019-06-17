----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.78)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.78 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of STEP 2 -------

------ STEP 3 ------------

--  column Datatype ExternalCode changed from varchar(25) to varchar(1000) in ExternalMappings table

IF OBJECT_ID('ExternalMappings')IS NOT NULL
BEGIN
	IF COL_LENGTH('ExternalMappings','ExternalCode')IS NOT NULL
	BEGIN 
		ALTER TABLE ExternalMappings ALTER COLUMN ExternalCode VARCHAR(1000)  NULL								
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

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.78)
BEGIN
Update SystemConfigurations set DataModelVersion=15.79
PRINT 'STEP 7 COMPLETED'
END
Go



