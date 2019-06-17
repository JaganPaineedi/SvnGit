----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 20.05)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 20.05 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END

------ STEP 2 ----------

-----End of Step 2 -------

------ STEP 3 ------------

----Add New Column in IISLogFiles Table 	
IF OBJECT_ID('IISLogFiles') IS NOT NULL
BEGIN
		IF COL_LENGTH('IISLogFiles','MachineName')IS NULL
		BEGIN
		 ALTER TABLE IISLogFiles ADD  MachineName varchar(16)	NULL
		END																					 
END

----Increase datatype size Existing Column in IISLog Table 

IF OBJECT_ID('IISLog') IS NOT NULL
BEGIN
	IF COL_LENGTH('IISLog','ReportingIP')IS NOT NULL
	BEGIN
		ALTER TABLE IISLog  ALTER COLUMN ReportingIP varchar(39) NULL 
	END
	
	IF COL_LENGTH('IISLog','ServerIP')IS NOT NULL
	BEGIN
		ALTER TABLE IISLog  ALTER COLUMN  ServerIP varchar(39) NULL
	END
	
	IF COL_LENGTH('IISLog','ClientIP')IS NOT NULL
	BEGIN
		ALTER TABLE IISLog  ALTER COLUMN  ClientIP varchar(39) NULL
	END
	
	IF COL_LENGTH('IISLog','FileBeingRequested')IS NOT NULL
	BEGIN
		ALTER TABLE IISLog  ALTER COLUMN FileBeingRequested varchar(260) NULL
	END
	
	IF COL_LENGTH('IISLog','QueryBeingPerformedTheClient')IS NOT NULL
	BEGIN
		ALTER TABLE IISLog  ALTER COLUMN QueryBeingPerformedTheClient varchar(max) NULL
	END
	
	IF COL_LENGTH('IISLog','PreviousSiteVisitedByTheUser')IS NOT NULL
	BEGIN
		ALTER TABLE IISLog  ALTER COLUMN PreviousSiteVisitedByTheUser varchar(max) NULL
	END
	
END
	PRINT 'STEP 3 COMPLETED'

------ END Of STEP 3 ------------

------ STEP 4 ---------------

 ----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 20.05)
BEGIN
Update SystemConfigurations set DataModelVersion=20.06
PRINT 'STEP 7 COMPLETED'
END

Go
