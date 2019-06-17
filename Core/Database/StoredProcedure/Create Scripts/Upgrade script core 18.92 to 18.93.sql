----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.92)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.92 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
-------------------------------------------------------------

------ STEP 3 ------------

--ClientCCDs

IF OBJECT_ID('ImageRecords') IS NOT NULL
BEGIN

	IF COL_LENGTH('ImageRecords','InsurerId') IS NULL
	BEGIN
		 ALTER TABLE ImageRecords ADD InsurerId INT  NULL
	END
	
	IF COL_LENGTH('ImageRecords','InsurerId')IS NOT NULL
	BEGIN
		IF  NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Insurers_ImageRecords_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[ImageRecords]'))
		BEGIN	 
			ALTER TABLE ImageRecords ADD CONSTRAINT Insurers_ImageRecords_FK
			FOREIGN KEY (InsurerId)
			REFERENCES Insurers(InsurerId) 
		END
	END
	
	 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ImageRecords') AND name='XIE13_ImageRecords')
			BEGIN
				CREATE NONCLUSTERED INDEX [XIE13_ImageRecords] ON [dbo].[ImageRecords] 
				(
				InsurerId ASC
				)
				WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
				IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ImageRecords') AND name='XIE13_ImageRecords')
				PRINT '<<< CREATED INDEX ImageRecords.XIE13_ImageRecords >>>'
				ELSE
				RAISERROR('<<< FAILED CREATING INDEX ImageRecords.XIE13_ImageRecords >>>', 16, 1)		
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
IF ((select DataModelVersion FROM SystemConfigurations)  = 18.92)
BEGIN
Update SystemConfigurations set DataModelVersion=18.93
PRINT 'STEP 7 COMPLETED'
END
Go
