----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 16.60)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 16.60 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of Step 2 -------

------ STEP 3 ------------
IF OBJECT_ID('ProcedureCodes') IS NOT NULL
BEGIN
IF COL_LENGTH('ProcedureCodes','MobileAssociatedNoteId') IS NULL
	BEGIN
		 ALTER TABLE ProcedureCodes ADD MobileAssociatedNoteId int NULL
	END
	
	IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ProcedureCodes') AND name='XIE1_ProcedureCodes')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_ProcedureCodes] ON [dbo].[ProcedureCodes] 
		(
		MobileAssociatedNoteId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ProcedureCodes') AND name='XIE1_ProcedureCodes')
		PRINT '<<< CREATED INDEX ProcedureCodes.XIE1_ProcedureCodes >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ProcedureCodes.XIE1_ProcedureCodes >>>', 16, 1)		
		END	 
	
	 IF COL_LENGTH('ProcedureCodes','MobileAssociatedNoteId')IS NOT NULL
	 BEGIN
			IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[DocumentCodes_ProcedureCodes_FK2]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProcedureCodes]'))
			BEGIN
				ALTER TABLE ProcedureCodes ADD CONSTRAINT DocumentCodes_ProcedureCodes_FK2
				FOREIGN KEY (MobileAssociatedNoteId)
				REFERENCES DocumentCodes(DocumentCodeId) 
			END
	  END
	  
	  PRINT 'STEP 3 COMPLETED'

END
------ End of STEP 3 ------------
------ STEP 4 ---------------

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 16.60)
BEGIN
Update SystemConfigurations set DataModelVersion=16.61
PRINT 'STEP 7 COMPLETED'
END
Go

