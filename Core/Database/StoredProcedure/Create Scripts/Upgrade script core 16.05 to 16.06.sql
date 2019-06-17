----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 16.05)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 16.05 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 -----------
--Part1 Begin

-----End of Step 2 -------

------ STEP 3 ------------

/* Added Column to PHQ9ADocuments table */

IF OBJECT_ID('PHQ9ADocuments')  IS NOT NULL
BEGIN
	IF COL_LENGTH('PHQ9ADocuments','Comments') IS NULL
	BEGIN
		 ALTER TABLE PHQ9ADocuments ADD Comments  type_Comment2  NULL
	END
		
	PRINT 'STEP 3 COMPLETED'
END

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 16.05)
BEGIN
Update SystemConfigurations set DataModelVersion=16.06
PRINT 'STEP 7 COMPLETED'
END
Go


