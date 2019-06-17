----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.68)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.68 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of STEP 2 -------

------ STEP 3 ------------

-- Added column WorkGroup in ClientNotes table

IF OBJECT_ID('ClientNotes')IS NOT NULL
BEGIN
	IF COL_LENGTH('ClientNotes','WorkGroup')IS NULL
	BEGIN 
		ALTER TABLE ClientNotes ADD WorkGroup  type_GlobalCode  NULL								
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

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.68)
BEGIN
Update SystemConfigurations set DataModelVersion=15.69
PRINT 'STEP 7 COMPLETED'
END
Go



