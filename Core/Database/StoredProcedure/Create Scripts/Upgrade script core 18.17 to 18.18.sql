----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.17)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.17 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of Step 2 -------
------ STEP 3 ------------

-----End of Step 3 -------


IF OBJECT_ID('ReallocatedClaimLines') IS NOT NULL
BEGIN

	IF EXISTS( select 1 from INFORMATION_SCHEMA.COLUMNS IC where TABLE_NAME = 'ReallocatedClaimLines' and COLUMN_NAME = 'ClaimLineId'  and DATA_TYPE='bigint')
	BEGIN
		ALTER TABLE ReallocatedClaimLines ALTER COLUMN ClaimLineId INT NULL
	END
	

	IF COL_LENGTH('ReallocatedClaimLines','ClaimLineId')IS NOT NULL
	 BEGIN
			IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[ClaimLines_ReallocatedClaimLines_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReallocatedClaimLines]'))
			BEGIN
				ALTER TABLE ReallocatedClaimLines ADD CONSTRAINT ClaimLines_ReallocatedClaimLines_FK
				FOREIGN KEY (ClaimLineId)
				REFERENCES ClaimLines(ClaimLineId) 
			END
	  END
	  
	 
	  IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ReallocatedClaimLines') AND name='XIE1_ReallocatedClaimLines')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_ReallocatedClaimLines] ON [dbo].[ReallocatedClaimLines] 
		(
		ClaimLineId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ReallocatedClaimLines') AND name='XIE1_ReallocatedClaimLines')
		PRINT '<<< CREATED INDEX ReallocatedClaimLines.XIE1_ReallocatedClaimLines >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ReallocatedClaimLines.XIE1_ReallocatedClaimLines >>>', 16, 1)		
		END	 
	
	PRINT 'STEP 3 COMPLETED'	
END


------ STEP 4 ---------------

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 18.17)
BEGIN
Update SystemConfigurations set DataModelVersion=18.18
PRINT 'STEP 7 COMPLETED'
END
Go

