----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.40)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.40 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
-------------------------------------------------------------

------ STEP 3 ------------

IF OBJECT_ID('DocumentCodes') IS NOT NULL
BEGIN

	IF COL_LENGTH('DocumentCodes','ClientOrder')IS   NULL
	BEGIN
		ALTER TABLE DocumentCodes   ADD   ClientOrder  type_YOrN   NULL
                                    CHECK (ClientOrder in ('Y','N'))
        EXEC sys.sp_addextendedproperty 'DocumentCodes_Description'
		,'ClientOrder Column To Identify the Document is using Client Order Control'
		,'schema'
		,'dbo'
		,'table'
		,'DocumentCodes'
		,'column'
		,'ClientOrder' 
		
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
IF ((select DataModelVersion FROM SystemConfigurations)  = 18.40)
BEGIN
Update SystemConfigurations set DataModelVersion=18.41
PRINT 'STEP 7 COMPLETED'
END
Go
