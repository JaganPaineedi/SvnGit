----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.59)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.59 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
-------------------------------------------------------------

------ STEP 3 ------------
IF OBJECT_ID('Forms') IS NOT NULL
BEGIN

	IF COL_LENGTH('Forms','FormType')IS   NULL
	BEGIN
		ALTER TABLE Forms   ADD   FormType type_GlobalCode	NULL
	END
	
	IF COL_LENGTH('Forms','DetailScreenId')IS   NULL
	BEGIN
		ALTER TABLE Forms   ADD  DetailScreenId int	NULL
	END
	
	IF COL_LENGTH('Forms','DetailScreenId')IS NOT NULL
	 BEGIN
			IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Screens_Forms_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[Forms]'))
			BEGIN
				ALTER TABLE Forms ADD CONSTRAINT Screens_Forms_FK
				FOREIGN KEY (DetailScreenId)
				REFERENCES Screens(ScreenId) 
			END
	  END
	  
	 
	  IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('Forms') AND name='XIE1_Forms')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_Forms] ON [dbo].[Forms] 
		(
		DetailScreenId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('Forms') AND name='XIE1_Forms')
		PRINT '<<< CREATED INDEX Forms.XIE1_Forms >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX Forms.XIE1_Forms >>>', 16, 1)		
		END	 
	

END

IF OBJECT_ID('FormItems') IS NOT NULL
BEGIN

	IF COL_LENGTH('FormItems','Filter')IS   NULL
	BEGIN
		ALTER TABLE FormItems   ADD   Filter type_YOrN	NULL
								CHECK(Filter in('Y','N'))
	END
	
	IF COL_LENGTH('FormItems','FilterName')IS   NULL
	BEGIN
		ALTER TABLE FormItems   ADD  FilterName  varchar(200)	NULL
	END
		
END

PRINT 'STEP 3 COMPLETED'

--END Of STEP 3------------
------ STEP 4 ----------

------END Of STEP 4---------------

------ STEP 5 ----------------

-------END STEP 5-------------
------ STEP 6  ----------

----END Of STEP 6 ------------

------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 18.59)
BEGIN
Update SystemConfigurations set DataModelVersion=18.60
PRINT 'STEP 7 COMPLETED'
END
Go
