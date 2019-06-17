----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 16.26)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 16.26 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ------------

-----End of Step 2 -------

------ STEP 3 ------------

--Changed  Column AdditionalInformation DataType from varchar(250) to type_Comment2 in FosterHistoryReferrals Table.

IF OBJECT_ID('FosterHistoryReferrals') IS NOT NULL
BEGIN
	IF EXISTS( select 1 from INFORMATION_SCHEMA.COLUMNS IC where TABLE_NAME = 'FosterHistoryReferrals' and COLUMN_NAME = 'AdditionalInformation'  and DATA_TYPE='varchar')
	BEGIN
		ALTER TABLE FosterHistoryReferrals ALTER COLUMN  AdditionalInformation type_Comment2  NULL	
	END
	
PRINT 'STEP 3 COMPLETED'
END	
-----END Of STEP 3--------

------ STEP 4 ---------------

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 16.26)
BEGIN
Update SystemConfigurations set DataModelVersion=16.27
PRINT 'STEP 7 COMPLETED'
END
Go



