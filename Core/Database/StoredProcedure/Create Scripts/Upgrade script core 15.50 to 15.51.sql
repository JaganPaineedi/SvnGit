----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.50)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.50 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins

--Part2 Ends	

-----End of Step 2 -------

------ STEP 3 ------------
-----END Of STEP 3--------------------

IF OBJECT_ID('ListPageSCCopyGroupServiceDocuments') IS NOT NULL
BEGIN
IF COL_LENGTH('ListPageSCCopyGroupServiceDocuments','ProcedureCode') IS  NOT NULL
	BEGIN
	 ALTER TABLE ListPageSCCopyGroupServiceDocuments ALTER COLUMN  ProcedureCode VARCHAR(250)															 
	END
PRINT 'STEP 3 COMPLETED'
END
------ STEP 4 ------------

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.50)
BEGIN
Update SystemConfigurations set DataModelVersion=15.51
PRINT 'STEP 7 COMPLETED'
END
Go