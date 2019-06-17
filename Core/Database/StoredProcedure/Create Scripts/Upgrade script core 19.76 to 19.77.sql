----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 19.76)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 19.76 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
-------------------------------------------------------------

------ STEP 3 ------------

----Added columns in DocumentCodes  Table

IF OBJECT_ID('DocumentCodes') IS NOT NULL
BEGIN
		IF COL_LENGTH('DocumentCodes','EditableAfterSignature')IS NULL
		BEGIN
		 ALTER TABLE DocumentCodes  ADD  EditableAfterSignature type_YOrN	NULL  DEFAULT('Y')
								    CHECK (EditableAfterSignature in	('Y','N'))		
								    
	EXEC sys.sp_addextendedproperty 'DocumentCodes_Description'
	 ,'IF EditableAfterSignature value is ''Y'' enable the Edit button after sign. IF EditableAfterSignature  value is ''N'' disable the edit button after sign'
	 ,'schema'
	 ,'dbo'
	 ,'table'
	 ,'DocumentCodes'
	 ,'column'
	 ,'EditableAfterSignature' 					  
	
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

IF ((select DataModelVersion FROM SystemConfigurations)  = 19.76)
BEGIN
Update SystemConfigurations set DataModelVersion=19.77
PRINT 'STEP 7 COMPLETED'
END
Go
