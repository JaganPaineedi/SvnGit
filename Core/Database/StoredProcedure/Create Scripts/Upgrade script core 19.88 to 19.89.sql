----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 19.88)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 19.88 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
-----
------ STEP 2 ----------

-----End of Step 2 -------

------ STEP 3 ------------
	
----Add New Column in NoteEMCodeOptions Table 	
IF OBJECT_ID('NoteEMCodeOptions') IS NOT NULL
BEGIN
		IF COL_LENGTH('NoteEMCodeOptions','OverrideProcedureCodeId')IS NULL
		BEGIN
		 ALTER TABLE NoteEMCodeOptions ADD  OverrideProcedureCodeId  int	NULL
		END
		 	
	IF COL_LENGTH('NoteEMCodeOptions','OverrideProcedureCodeId')IS NOT NULL
		BEGIN
			IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[ProcedureCodes_NoteEMCodeOptions_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[NoteEMCodeOptions]'))
			BEGIN
		
				ALTER TABLE NoteEMCodeOptions ADD CONSTRAINT ProcedureCodes_NoteEMCodeOptions_FK
				FOREIGN KEY (OverrideProcedureCodeId)
				REFERENCES ProcedureCodes(ProcedureCodeId) 
			END
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
IF ((select DataModelVersion FROM SystemConfigurations)  = 19.88)
BEGIN
Update SystemConfigurations set DataModelVersion=19.89
PRINT 'STEP 7 COMPLETED'
END

Go
