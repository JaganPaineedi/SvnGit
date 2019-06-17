----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.94)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.94 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 -----------

-----End of Step 2 -------

------ STEP 3 ------------

-- Changed Column AdditionalInformation datatype from varchar(250) to type_Comment2 in FosterReferrals Table

IF OBJECT_ID('FosterReferrals')IS NOT NULL
BEGIN
	IF COL_LENGTH('FosterReferrals','AdditionalInformation')IS NOT NULL
	BEGIN
		ALTER TABLE FosterReferrals ALTER COLUMN AdditionalInformation type_Comment2  NULL
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

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.94)
BEGIN
Update SystemConfigurations set DataModelVersion=15.95
PRINT 'STEP 7 COMPLETED'
END
Go


