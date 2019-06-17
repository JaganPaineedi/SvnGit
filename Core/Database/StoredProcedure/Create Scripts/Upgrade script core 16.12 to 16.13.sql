----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 16.12)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 16.12 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 -----------

-----End of Step 2 -------

------ STEP 3 ------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='ERClaimLineItemCharges')
BEGIN  
/* 
 * TABLE: ERClaimLineItemCharges 
 */
 CREATE TABLE ERClaimLineItemCharges(
    ERClaimLineItemChargeId		INT IDENTITY(1,1)		NOT NULL,
    CreatedBy					type_CurrentUser		NOT NULL,
    CreatedDate					type_CurrentDatetime	NOT NULL,
    ModifiedBy					type_CurrentUser		NOT NULL,
    ModifiedDate				type_CurrentDatetime	NOT NULL,
    RecordDeleted				type_YOrN				NULL
								CHECK (RecordDeleted in ('Y','N')),
	DeletedBy					type_UserId				NULL,
    DeletedDate					DATETIME				NULL,
	ERClaimLineItemId			INT						NOT NULL,
	ChargeId					INT						NOT NULL,
    CONSTRAINT ERClaimLineItemCharges_PK PRIMARY KEY CLUSTERED (ERClaimLineItemChargeId)
    )  
IF OBJECT_ID('ERClaimLineItemCharges') IS NOT NULL
    PRINT '<<< CREATED TABLE ERClaimLineItemCharges >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE ERClaimLineItemCharges >>>', 16, 1)

	IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ERClaimLineItemCharges') AND name='XIE1_ERClaimLineItemCharges')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_ERClaimLineItemCharges] ON [dbo].[ERClaimLineItemCharges] 
		(
		ERClaimLineItemId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ERClaimLineItemCharges') AND name='XIE1_ERClaimLineItemCharges')
		PRINT '<<< CREATED INDEX ERClaimLineItemCharges.XIE1_ERClaimLineItemCharges >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX  ERClaimLineItemCharges.XIE1_ERClaimLineItemCharges >>>', 16, 1)		
		END
		
	IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ERClaimLineItemCharges') AND name='XIE2_ERClaimLineItemCharges')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_ERClaimLineItemCharges] ON [dbo].[ERClaimLineItemCharges] 
		(
		ChargeId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ERClaimLineItemCharges') AND name='XIE2_ERClaimLineItemCharges')
		PRINT '<<< CREATED INDEX ERClaimLineItemCharges.XIE2_ERClaimLineItemCharges >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX  ERClaimLineItemCharges.XIE2_ERClaimLineItemCharges >>>', 16, 1)		
		END
/* 
 * TABLE: ERClaimLineItemCharges 
 */ 
 
		ALTER TABLE dbo.ERClaimLineItemCharges ADD CONSTRAINT Charges_ERClaimLineItemCharges_FK 
			FOREIGN KEY (ChargeId)
			REFERENCES dbo.Charges(ChargeId)

		ALTER TABLE dbo.ERClaimLineItemCharges ADD CONSTRAINT ERClaimLineItems_ERClaimLineItemCharges_FK 
			FOREIGN KEY (ERClaimLineItemId)
			REFERENCES dbo.ERClaimLineItems(ERClaimLineItemId)
 
	 PRINT 'STEP 4 COMPLETED'
 
			EXEC sys.sp_bindefault N'[dbo].[def_CurrentUser]', N'[dbo].[ERClaimLineItemCharges].[CreatedBy]' 
	 
			EXEC sys.sp_bindefault N'[dbo].[def_CurrentDatetime]', N'[dbo].[ERClaimLineItemCharges].[CreatedDate]' 
	 
			EXEC sys.sp_bindefault N'[dbo].[def_CurrentUser]', N'[dbo].[ERClaimLineItemCharges].[ModifiedBy]' 
	 
			EXEC sys.sp_bindefault N'[dbo].[def_CurrentDatetime]', N'[dbo].[ERClaimLineItemCharges].[ModifiedDate]'  	
END

-- added column ERProcessingTemplateId in CoveragePlans
IF OBJECT_ID('CoveragePlans')IS NOT NULL
BEGIN
IF COL_LENGTH('CoveragePlans','ERProcessingTemplateId') IS NULL
BEGIN
	ALTER TABLE CoveragePlans ADD  ERProcessingTemplateId INT NULL
END

IF COL_LENGTH('CoveragePlans','ERProcessingTemplateId')IS  NOT NULL
		BEGIN
			IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[ERProcessingTemplates_CoveragePlans_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[CoveragePlans]'))	
			BEGIN
				ALTER TABLE dbo.CoveragePlans ADD CONSTRAINT ERProcessingTemplates_CoveragePlans_FK 
				FOREIGN KEY (ERProcessingTemplateId)
				REFERENCES dbo.ERProcessingTemplates(ERProcessingTemplateId) 
			END 
		END
		
	IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('CoveragePlans') AND name='XIE1_CoveragePlans')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_CoveragePlans] ON [dbo].[CoveragePlans] 
		(
		ERProcessingTemplateId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CoveragePlans') AND name='XIE1_CoveragePlans')
		PRINT '<<< CREATED INDEX CoveragePlans.XIE1_CoveragePlans >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX  CoveragePlans.XIE1_CoveragePlans >>>', 16, 1)		
		END	
		
END    

-----END Of STEP 3---------

------ STEP 4 ------------

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 16.12)
BEGIN
Update SystemConfigurations set DataModelVersion=16.13
PRINT 'STEP 7 COMPLETED'
END
Go


