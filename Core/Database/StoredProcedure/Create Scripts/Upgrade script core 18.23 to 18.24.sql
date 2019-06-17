----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.23)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.23 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of Step 2 -------

------ STEP 3 ------------

IF OBJECT_ID('ContractRates') IS NOT NULL
BEGIN

	IF COL_LENGTH('ContractRates','CoveragePlanGroupName')IS  NULL
	BEGIN
		ALTER TABLE ContractRates  ADD  CoveragePlanGroupName  VARCHAR(250) NULL
	END
	PRINT 'STEP 3 COMPLETED'
END
------ END Of STEP 3 ------------

------ STEP 4 ---------------
 ----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 18.23)
BEGIN
Update SystemConfigurations set DataModelVersion=18.24
PRINT 'STEP 7 COMPLETED'
END
Go

