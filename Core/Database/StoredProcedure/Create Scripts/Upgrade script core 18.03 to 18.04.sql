----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.03)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.03 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of Step 2 -------
------ STEP 3 ------------

-----End of Step 3 -------

------ STEP 4 ---------------

IF OBJECT_ID('CarePlanDomains') IS NOT NULL
BEGIN
	IF COL_LENGTH('CarePlanDomains','DomainCategory')IS  NULL
	BEGIN
		ALTER TABLE CarePlanDomains   ADD  DomainCategory  type_GlobalCode NULL	
	END
	
	PRINT 'STEP 3 COMPLETED'
END
----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 18.03)
BEGIN
Update SystemConfigurations set DataModelVersion=18.04
PRINT 'STEP 7 COMPLETED'
END
Go

