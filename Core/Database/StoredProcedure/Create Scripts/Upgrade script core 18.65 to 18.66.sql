----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.65)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.65 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
-------------------------------------------------------------

------ STEP 3 ------------
IF OBJECT_ID('Orders') IS NOT NULL
BEGIN

	IF COL_LENGTH('Orders','EMNoteOrder')IS   NULL
	BEGIN
		ALTER TABLE Orders   ADD   EMNoteOrder   type_YOrN		NULL
							 CHECK (EMNoteOrder in ('Y','N'))
							 
		
	  EXEC sys.sp_addextendedproperty 'ClientDisclosures_Description'
	,'EMNoteOrder determine the E&M Note Orders'
	,'schema'
	,'dbo'
	,'table'
	,'Orders'
	,'column'
	,'EMNoteOrder'
		
	END
	
	PRINT 'STEP 3 COMPLETED'

END
	
--END Of STEP 3------------
------ STEP 4 ----------

------END Of STEP 4---------------

------ STEP 5 ----------------

-------END STEP 5-------------
------ STEP 6  ----------

----END Of STEP 6 ------------

------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 18.65)
BEGIN
Update SystemConfigurations set DataModelVersion=18.66
PRINT 'STEP 7 COMPLETED'
END
Go
