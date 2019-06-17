----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.08)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.08 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
-----End of Step 2 -------
------ STEP 3 ------------

-----End of Step 3 -------

------ STEP 4 ---------------
IF OBJECT_ID('ERClaimLineItemImportStaging') IS NOT NULL
BEGIN	
	IF COL_LENGTH('ERClaimLineItemImportStaging','PaidUnits') IS NULL
	BEGIN
		 ALTER TABLE ERClaimLineItemImportStaging ADD PaidUnits decimal(10,2) NULL
	END
	
	IF COL_LENGTH('ERClaimLineItemImportStaging','SortOrder') IS NULL
	BEGIN
		 ALTER TABLE ERClaimLineItemImportStaging ADD SortOrder int NULL
	END
	
	IF COL_LENGTH('ERClaimLineItemImportStaging','ERClaimLineItemId') IS NULL
	BEGIN
		 ALTER TABLE ERClaimLineItemImportStaging ADD ERClaimLineItemId int NULL
	END
	
	IF COL_LENGTH('ERClaimLineItemImportStaging','ClaimedAmount') IS NULL
	BEGIN
		 ALTER TABLE ERClaimLineItemImportStaging ADD ClaimedAmount decimal(10,2) NULL
	END
	
	IF COL_LENGTH('ERClaimLineItemImportStaging','BalanceAmount') IS NULL
	BEGIN
		 ALTER TABLE ERClaimLineItemImportStaging ADD BalanceAmount decimal(10,2) NULL
	END
	
	IF COL_LENGTH('ERClaimLineItemImportStaging','ProcessingAction') IS NULL
	BEGIN
		 ALTER TABLE ERClaimLineItemImportStaging ADD ProcessingAction int NULL
	END
	
	IF COL_LENGTH('ERClaimLineItemImportStaging','IsNotPrimary') IS NULL
	BEGIN
		 ALTER TABLE ERClaimLineItemImportStaging ADD IsNotPrimary int NULL
	END
	
	IF COL_LENGTH('ERClaimLineItemImportStaging','NextBillablePayer') IS NULL
	BEGIN
		 ALTER TABLE ERClaimLineItemImportStaging ADD NextBillablePayer int NULL
	END
	
	IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ERClaimLineItemImportStaging') AND name='XIE8_ERClaimLineItemImportStaging')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE8_ERClaimLineItemImportStaging] ON [dbo].[ERClaimLineItemImportStaging] 
		(
		ERClaimLineItemId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ERClaimLineItemImportStaging') AND name='XIE8_ERClaimLineItemImportStaging')
		PRINT '<<< CREATED INDEX ERClaimLineItemImportStaging.XIE8_ERClaimLineItemImportStaging >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ERClaimLineItemImportStaging.XIE8_ERClaimLineItemImportStaging >>>', 16, 1)		
		END	 
	
	 IF COL_LENGTH('ERClaimLineItemImportStaging','ERClaimLineItemId')IS NOT NULL
	 BEGIN
			IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[ERClaimLineItems_ERClaimLineItemImportStaging_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[ERClaimLineItemImportStaging]'))
			BEGIN
				ALTER TABLE ERClaimLineItemImportStaging ADD CONSTRAINT ERClaimLineItems_ERClaimLineItemImportStaging_FK
				FOREIGN KEY (ERClaimLineItemId)
				REFERENCES ERClaimLineItems(ERClaimLineItemId) 
			END
	  END
	
	PRINT 'STEP 3 COMPLETED'
END
----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 18.08)
BEGIN
Update SystemConfigurations set DataModelVersion=18.09
PRINT 'STEP 7 COMPLETED'
END
Go

