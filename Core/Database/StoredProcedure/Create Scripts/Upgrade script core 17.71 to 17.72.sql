----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 17.71)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 17.71 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of Step 2 -------

------ STEP 3 ------------

------ End of STEP 3 ------------
------ STEP 4 ---------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='ERClaimLineItemImportStaging')
BEGIN
/*  
 * TABLE: ERClaimLineItemImportStaging 
 */
 CREATE TABLE ERClaimLineItemImportStaging( 
			ERClaimLineItemImportStagingId 			int	identity(1,1)		NOT NULL,
			CreatedBy								type_CurrentUser		NOT NULL,
			CreatedDate								type_CurrentDatetime	NOT NULL,
			ModifiedBy								type_CurrentUser		NOT NULL,
			ModifiedDate							type_CurrentDatetime	NOT NULL,
			RecordDeleted							type_YOrN				NULL
													CHECK (RecordDeleted in ('Y','N')),
			DeletedBy								type_UserId				NULL,
			DeletedDate								datetime				NULL,
			ERBatchId								INT						NULL,               --FK to ERBatches.ERBatchId
		    PaymentId								INT						NULL,               --FK to Payments.PaymentId
		    ClaimLineItemId							INT						NULL,				--FK to ClaimLineItems.ClaimLineItemId
		    ChargeId								INT						NULL,				--FK to Charges.ChargeId
		    ClientId								INT						NULL,				--FK to Clients.ClientId
		    CoveragePlanId							INT						NULL,				--FK to CoveragePlans.CoveragePlanId
		    ClientCoveragePlanId					INT						NULL,				--FK to ClientCoveragePlans.ClientCoveragePlanId
		    PayerClaimNumber						VARCHAR(50)				NULL,
		    PaidAmount								DECIMAL(10,3)			NULL,
		    AdjustmentAmount						DECIMAL(10,3)			NULL,
		    TransferAmount							DECIMAL(10,3)			NULL,
		    ReferenceNumber							VARCHAR(30)				NULL,
		    AdjustmentGlobalCode					type_GlobalCode			NULL,
		    AdjustmentGroupCode						VARCHAR(50)				NULL,
		    AdjustmentReasonCode					VARCHAR(50)				NULL,
		    BackoutAdjustments						type_YOrN				NULL
													CHECK (BackoutAdjustments in ('Y','N')),
			CONSTRAINT ERClaimLineItemImportStaging_PK PRIMARY KEY CLUSTERED (ERClaimLineItemImportStagingId)

 )
  IF OBJECT_ID('ERClaimLineItemImportStaging') IS NOT NULL
    PRINT '<<< CREATED TABLE ERClaimLineItemImportStaging >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE ERClaimLineItemImportStaging >>>', 16, 1)
    
  IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ERClaimLineItemImportStaging') AND name='XIE1_ERClaimLineItemImportStaging')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_ERClaimLineItemImportStaging] ON [dbo].[ERClaimLineItemImportStaging] 
		(
		ClaimLineItemId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ERClaimLineItemImportStaging') AND name='XIE1_ERClaimLineItemImportStaging')
		PRINT '<<< CREATED INDEX ERClaimLineItemImportStaging.XIE1_ERClaimLineItemImportStaging >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ERClaimLineItemImportStaging.XIE1_ERClaimLineItemImportStaging >>>', 16, 1)		
		END	 
		
 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ERClaimLineItemImportStaging') AND name='XIE2_ERClaimLineItemImportStaging')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_ERClaimLineItemImportStaging] ON [dbo].[ERClaimLineItemImportStaging] 
		(
		CoveragePlanId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ERClaimLineItemImportStaging') AND name='XIE2_ERClaimLineItemImportStaging')
		PRINT '<<< CREATED INDEX ERClaimLineItemImportStaging.XIE2_ERClaimLineItemImportStaging >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ERClaimLineItemImportStaging.XIE2_ERClaimLineItemImportStaging >>>', 16, 1)		
		END	 
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ERClaimLineItemImportStaging') AND name='XIE3_ERClaimLineItemImportStaging')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE3_ERClaimLineItemImportStaging] ON [dbo].[ERClaimLineItemImportStaging] 
		(
		ClientCoveragePlanId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ERClaimLineItemImportStaging') AND name='XIE3_ERClaimLineItemImportStaging')
		PRINT '<<< CREATED INDEX ERClaimLineItemImportStaging.XIE3_ERClaimLineItemImportStaging >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ERClaimLineItemImportStaging.XIE3_ERClaimLineItemImportStaging >>>', 16, 1)		
		END	 
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ERClaimLineItemImportStaging') AND name='XIE4_ERClaimLineItemImportStaging')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE4_ERClaimLineItemImportStaging] ON [dbo].[ERClaimLineItemImportStaging] 
		(
		ClientId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ERClaimLineItemImportStaging') AND name='XIE4_ERClaimLineItemImportStaging')
		PRINT '<<< CREATED INDEX ERClaimLineItemImportStaging.XIE4_ERClaimLineItemImportStaging >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ERClaimLineItemImportStaging.XIE4_ERClaimLineItemImportStaging >>>', 16, 1)		
		END
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ERClaimLineItemImportStaging') AND name='XIE5_ERClaimLineItemImportStaging')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE5_ERClaimLineItemImportStaging] ON [dbo].[ERClaimLineItemImportStaging] 
		(
		ChargeId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ERClaimLineItemImportStaging') AND name='XIE5_ERClaimLineItemImportStaging')
		PRINT '<<< CREATED INDEX ERClaimLineItemImportStaging.XIE5_ERClaimLineItemImportStaging >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ERClaimLineItemImportStaging.XIE5_ERClaimLineItemImportStaging >>>', 16, 1)		
		END
		
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ERClaimLineItemImportStaging') AND name='XIE6_ERClaimLineItemImportStaging')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE6_ERClaimLineItemImportStaging] ON [dbo].[ERClaimLineItemImportStaging] 
		(
		ERBatchId  ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ERClaimLineItemImportStaging') AND name='XIE6_ERClaimLineItemImportStaging')
		PRINT '<<< CREATED INDEX ERClaimLineItemImportStaging.XIE6_ERClaimLineItemImportStaging >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ERClaimLineItemImportStaging.XIE6_ERClaimLineItemImportStaging >>>', 16, 1)		
		END
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ERClaimLineItemImportStaging') AND name='XIE7_ERClaimLineItemImportStaging')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE7_ERClaimLineItemImportStaging] ON [dbo].[ERClaimLineItemImportStaging] 
		(
		PaymentId  ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ERClaimLineItemImportStaging') AND name='XIE7_ERClaimLineItemImportStaging')
		PRINT '<<< CREATED INDEX ERClaimLineItemImportStaging.XIE7_ERClaimLineItemImportStaging >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ERClaimLineItemImportStaging.XIE7_ERClaimLineItemImportStaging >>>', 16, 1)		
		END
		
		
ALTER TABLE ERClaimLineItemImportStaging ADD CONSTRAINT ERBatches_ERClaimLineItemImportStaging_FK 
    FOREIGN KEY (ERBatchId)
    REFERENCES ERBatches(ERBatchId)	
    
ALTER TABLE ERClaimLineItemImportStaging ADD CONSTRAINT Payments_ERClaimLineItemImportStaging_FK 
    FOREIGN KEY (PaymentId)
    REFERENCES Payments(PaymentId)
    
ALTER TABLE ERClaimLineItemImportStaging ADD CONSTRAINT ClaimLineItems_ERClaimLineItemImportStaging_FK 
    FOREIGN KEY (ClaimLineItemId)
    REFERENCES ClaimLineItems(ClaimLineItemId)	
    
ALTER TABLE ERClaimLineItemImportStaging ADD CONSTRAINT Charges_ERClaimLineItemImportStaging_FK 
    FOREIGN KEY (ChargeId)
    REFERENCES Charges(ChargeId)	
    
ALTER TABLE ERClaimLineItemImportStaging ADD CONSTRAINT Clients_ERClaimLineItemImportStaging_FK 
    FOREIGN KEY (ClientId)
    REFERENCES Clients(ClientId)	
		
    
ALTER TABLE ERClaimLineItemImportStaging ADD CONSTRAINT CoveragePlans_ERClaimLineItemImportStaging_FK 
    FOREIGN KEY (CoveragePlanId)
    REFERENCES CoveragePlans(CoveragePlanId)	

ALTER TABLE ERClaimLineItemImportStaging ADD CONSTRAINT ClientCoveragePlans_ERClaimLineItemImportStaging_FK 
    FOREIGN KEY (ClientCoveragePlanId)
    REFERENCES ClientCoveragePlans(ClientCoveragePlanId)	
   			   			
   			     
/* 
 * TABLE: ERClaimLineItemImportStaging 
 */ 
      
    PRINT 'STEP 4(A) COMPLETED'
END


-- Insert script for SystemConfigurationKeys AllowERProcessRefunds  Engineering Improvement Initiatives 357 
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'AllowERProcessRefunds'
		)
BEGIN
	INSERT INTO SystemConfigurationKeys (
		CreatedBy
		,CreateDate
		,ModifiedBy
		,ModifiedDate
		,[Key]
		,Value
		,AcceptedValues
		,[Description]
		,AllowEdit
		,Modules
		,Comments
		)
	VALUES (
		SYSTEM_USER
		,CURRENT_TIMESTAMP
		,SYSTEM_USER
		,CURRENT_TIMESTAMP
		,'AllowERProcessRefunds'
		,'Y'
		,'Y,N'
		,'This key controls whether or not the 835 process should process refund. The default value is Yes'
		,'Y'
		,'835'
		,'Default Existing Customer Value N'
		)
END


-- Insert script for SystemConfigurationKeys SetLocationForERPayment  Engineering Improvement Initiatives 357 
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'SetLocationForERPayment'
		)
BEGIN
	INSERT INTO SystemConfigurationKeys (
		CreatedBy
		,CreateDate
		,ModifiedBy
		,ModifiedDate
		,[Key]
		,Value
		,AcceptedValues
		,[Description]
		,AllowEdit
		,Modules
		,Comments
		)
	VALUES (
		SYSTEM_USER
		,CURRENT_TIMESTAMP
		,SYSTEM_USER
		,CURRENT_TIMESTAMP
		,'SetLocationForERPayment'
		,NULL
		,'GlobalCodes in category FINANCIALLOCATION'
		,'This key determines the location that the 835 process will use when creating payments.'
		,'Y'
		,'835'
		,'Will vary by customer, will need to be set before custom goes live with new process.'
		)
END


-- Insert script for SystemConfigurationKeys SetSourceForERPayment  Engineering Improvement Initiatives 357 
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'SetSourceForERPayment'
		)
BEGIN
	INSERT INTO SystemConfigurationKeys (
		CreatedBy
		,CreateDate
		,ModifiedBy
		,ModifiedDate
		,[Key]
		,Value
		,AcceptedValues
		,[Description]
		,AllowEdit
		,Modules
		,Comments
		)
	VALUES (
		SYSTEM_USER
		,CURRENT_TIMESTAMP
		,SYSTEM_USER
		,CURRENT_TIMESTAMP
		,'SetSourceForERPayment'
		,10193
		,'GlobalCodes in category PAYMENTSOURCE ,10193 (Category: PAYMENTSOURCE - CodeName: System )'
		,'This key determines the source that the 835 process will use when creating payments.'
		,'Y'
		,'835'
		,'Will vary by customer, will need to be set before custom goes live with new process.'
		)
END

-- Insert script for SystemConfigurationKeys SetMethodForERPayment  Engineering Improvement Initiatives 357 
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'SetMethodForERPayment'
		)
BEGIN
	INSERT INTO SystemConfigurationKeys (
		CreatedBy
		,CreateDate
		,ModifiedBy
		,ModifiedDate
		,[Key]
		,Value
		,AcceptedValues
		,[Description]
		,AllowEdit
		,Modules
		,Comments
		)
	VALUES (
		SYSTEM_USER
		,CURRENT_TIMESTAMP
		,SYSTEM_USER
		,CURRENT_TIMESTAMP
		,'SetMethodForERPayment'
		,4364				-- new GlobalCodeId for EFT category PAYMENTMETHOD
		,'GlobalCodes in category PAYMENTMETHOD  4364( Category: PAYMENTMETHOD - CodeName: EFT )'
		,'This key determines the method of payment that the 835 process will use when creating payments.'
		,'Y'
		,'835'
		,'Will vary by customer, will need to be set before custom goes live with new process.'
		)
END


-- Insert script for SystemConfigurationKeys AllowERAutomaticTransferForSecondary  Engineering Improvement Initiatives 357 
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'AllowERAutomaticTransferForSecondary'
		)
BEGIN
	INSERT INTO SystemConfigurationKeys (
		CreatedBy
		,CreateDate
		,ModifiedBy
		,ModifiedDate
		,[Key]
		,Value
		,AcceptedValues
		,AllowEdit
		,Modules
		,Comments
		)
	VALUES (
		SYSTEM_USER
		,CURRENT_TIMESTAMP
		,SYSTEM_USER
		,CURRENT_TIMESTAMP
		,'AllowERAutomaticTransferForSecondary'
		,'N'
		,'Y,N'
		,'Y'
		,'835'
		,'Default Existing Customer Value N'
		)
END


-- Insert script for SystemConfigurationKeys SetERAutomaticTransferForSecondaryAdjustmentCode  Engineering Improvement Initiatives 357 
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'SetERAutomaticTransferForSecondaryAdjustmentCode'
		)
BEGIN
	INSERT INTO SystemConfigurationKeys (
		CreatedBy
		,CreateDate
		,ModifiedBy
		,ModifiedDate
		,[Key]
		,Value
		,AcceptedValues
		,AllowEdit
		,Modules
		)
	VALUES (
		SYSTEM_USER
		,CURRENT_TIMESTAMP
		,SYSTEM_USER
		,CURRENT_TIMESTAMP
		,'SetERAutomaticTransferForSecondaryAdjustmentCode'
		,NULL
		,'GlobalCodes in category "AdjustmentCode"'
		,'Y'
		,'835'
		)
END

-- Insert script for SystemConfigurationKeys AllowERAutoPostLedgerTransactions   Engineering Improvement Initiatives 357 
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'AllowERAutoPostLedgerTransactions'
		)
BEGIN
	INSERT INTO SystemConfigurationKeys (
		CreatedBy
		,CreateDate
		,ModifiedBy
		,ModifiedDate
		,[Key]
		,Value
		,AcceptedValues
		,[Description]
		,AllowEdit
		,Modules
		,Comments
		)
	VALUES (
		SYSTEM_USER
		,CURRENT_TIMESTAMP
		,SYSTEM_USER
		,CURRENT_TIMESTAMP
		,'AllowERAutoPostLedgerTransactions '
		,'N'					
		,'Y,N'
		,'This key will control whether or not the 835 process will automatically post the ledger transactions to the ARLedger. If set to “No” the user will have to review the transactions and manually run the transaction batch.'
		,'Y'
		,'835'
		,'Default Existing Customer Value Y'
		)
END

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 17.71)
BEGIN
Update SystemConfigurations set DataModelVersion=17.72
PRINT 'STEP 7 COMPLETED'
END
Go

