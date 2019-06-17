----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.12)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.12 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of Step 2 -------
------ STEP 3 ------------

-----End of Step 3 -------

------ STEP 4 ---------------

IF OBJECT_ID('HealthDataTemplates') IS NOT NULL
BEGIN

	IF COL_LENGTH('HealthDataTemplates','DefaultDateRange')IS  NULL
	BEGIN
		ALTER TABLE HealthDataTemplates   ADD  DefaultDateRange  type_GlobalCode NULL	
	END
	
	PRINT 'STEP 3 COMPLETED'
END
----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 18.12)
BEGIN
Update SystemConfigurations set DataModelVersion=18.13
PRINT 'STEP 7 COMPLETED'
END
Go

