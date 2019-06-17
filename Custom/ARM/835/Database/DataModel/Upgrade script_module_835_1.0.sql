----- STEP 1 ----------

------ STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins

--Part2 Ends

-----End of Step 2 -------

------ STEP 3 ------------

------ END OF STEP 3 -----

------ STEP 4 ----------
IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomERClaimLineCustomFields')
BEGIN
/*  
 * TABLE: CustomERClaimLineCustomFields 
 */
CREATE TABLE CustomERClaimLineCustomFields(
			ERClaimLineItemId							int						NOT NULL,
			CreatedBy									type_CurrentUser        NOT NULL,
			CreatedDate									type_CurrentDatetime    NOT NULL,
			ModifiedBy									type_CurrentUser        NOT NULL,
			ModifiedDate								type_CurrentDatetime    NOT NULL,
			RecordDeleted								type_YOrN               NULL
														CHECK (RecordDeleted in ('Y','N')),
			DeletedBy									type_UserId             NULL,
			DeletedDate									datetime				NULL,
			ClassOfContractCode							varchar(50)				NULL, --Description: REF|CE segment Element2 Used to identify cross over ERClaimLineItems 
			CONSTRAINT CustomERClaimLineCustomFields_PK PRIMARY KEY CLUSTERED (ERClaimLineItemId) 
 )
 
  IF OBJECT_ID('CustomERClaimLineCustomFields') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomERClaimLineCustomFields >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomERClaimLineCustomFields >>>', 16, 1)
/* 
 * TABLE: CustomERClaimLineCustomFields 
 */ 
   
ALTER TABLE CustomERClaimLineCustomFields ADD CONSTRAINT ERClaimLineItems_CustomERClaimLineCustomFields_FK 
	FOREIGN KEY (ERClaimLineItemId)
	REFERENCES ERClaimLineItems(ERClaimLineItemId)
	
	PRINT 'STEP 4(A) COMPLETED'
	
	EXEC sys.sp_addextendedproperty 'CustomERClaimLineCustomFields_Description'
	,'REF|CE segment Element2 Used to identify cross over ERClaimLineItems'
	,'schema'
	,'dbo'
	,'table'
	,'CustomERClaimLineCustomFields'
	,'column'
	,'ClassOfContractCode'
	
END

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomPayerClassOfContractCoveragePlans')
BEGIN
/*  
 * TABLE: CustomPayerClassOfContractCoveragePlans 
 */
CREATE TABLE CustomPayerClassOfContractCoveragePlans(
			PayerClassOfContractCoveragePlanId			int identity(1,1)		NOT NULL,
			CreatedBy									type_CurrentUser        NOT NULL,
			CreatedDate									type_CurrentDatetime    NOT NULL,
			ModifiedBy									type_CurrentUser        NOT NULL,
			ModifiedDate								type_CurrentDatetime    NOT NULL,
			RecordDeleted								type_YOrN               NULL
														CHECK (RecordDeleted in ('Y','N')),
			DeletedBy									type_UserId             NULL,
			DeletedDate									datetime				NULL,
			PayerId										int						NOT NULL,  --PayerId that sends 835 claims with this class of contract code
			CoveragePlanId								int						NOT NULL,  --Coverage plan ids that should be posted to if the class of contract code is encountered in the 835
			ClassOfContractCode							varchar(50)				NOT NULL,  --REF|CE Element 02 from the 835 used to identify cross overs
			StartDate									datetime				NOT NULL,
			EndDate										datetime				NULL,
			CONSTRAINT CustomPayerClassOfContractCoveragePlans_PK PRIMARY KEY CLUSTERED (PayerClassOfContractCoveragePlanId) 
 )
 
  IF OBJECT_ID('CustomPayerClassOfContractCoveragePlans') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomPayerClassOfContractCoveragePlans >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomPayerClassOfContractCoveragePlans >>>', 16, 1)
/* 
 * TABLE: CustomPayerClassOfContractCoveragePlans 
 */ 
   
ALTER TABLE CustomPayerClassOfContractCoveragePlans ADD CONSTRAINT Payers_CustomPayerClassOfContractCoveragePlans_FK 
	FOREIGN KEY (PayerId)
	REFERENCES Payers(PayerId)
	
ALTER TABLE CustomPayerClassOfContractCoveragePlans ADD CONSTRAINT CoveragePlans_CustomPayerClassOfContractCoveragePlans_FK 
	FOREIGN KEY (CoveragePlanId)
	REFERENCES CoveragePlans(CoveragePlanId)
	
	PRINT 'STEP 4(B) COMPLETED'
	
	EXEC sys.sp_addextendedproperty 'CustomPayerClassOfContractCoveragePlans_Description'
	,'PayerId that sends 835 claims with this class of contract code'
	,'schema'
	,'dbo'
	,'table'
	,'CustomPayerClassOfContractCoveragePlans'
	,'column'
	,'PayerId'
	
	EXEC sys.sp_addextendedproperty 'CustomPayerClassOfContractCoveragePlans_Description'
	,'REF|CE Element 02 from the 835 used to identify cross overs'
	,'schema'
	,'dbo'
	,'table'
	,'CustomPayerClassOfContractCoveragePlans'
	,'column'
	,'ClassOfContractCode'
	
	EXEC sys.sp_addextendedproperty 'CustomPayerClassOfContractCoveragePlans_Description'
	,'Coverage plan ids that should be posted to if the class of contract code is encountered in the 835'
	,'schema'
	,'dbo'
	,'table'
	,'CustomPayerClassOfContractCoveragePlans'
	,'column'
	,'CoveragePlanId'
	
END

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomEDIFilesERFiles')
BEGIN
/*  
 * TABLE: CustomEDIFilesERFiles 
 */
CREATE TABLE CustomEDIFilesERFiles(
			EDIFileId									int						NOT NULL,
			CreatedBy									type_CurrentUser        NOT NULL,
			CreatedDate									type_CurrentDatetime    NOT NULL,
			ModifiedBy									type_CurrentUser        NOT NULL,
			ModifiedDate								type_CurrentDatetime    NOT NULL,
			RecordDeleted								type_YOrN               NULL
														CHECK (RecordDeleted in ('Y','N')),
			DeletedBy									type_UserId             NULL,
			DeletedDate									datetime				NULL,
			ERFileId									int						NOT NULL, --Description: ERFile generated by the EDI File
			CONSTRAINT CustomEDIFilesERFiles_PK PRIMARY KEY CLUSTERED (EDIFileId) 
 )
 
  IF OBJECT_ID('CustomEDIFilesERFiles') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomEDIFilesERFiles >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomEDIFilesERFiles >>>', 16, 1)
/* 
 * TABLE: CustomEDIFilesERFiles 
 */ 
   
ALTER TABLE CustomEDIFilesERFiles ADD CONSTRAINT EDIFiles_CustomEDIFilesERFiles_FK 
	FOREIGN KEY (EDIFileId)
	REFERENCES EDIFiles(EDIFileId)
	
	
	PRINT 'STEP 4(C) COMPLETED'
	
	EXEC sys.sp_addextendedproperty 'CustomEDIFilesERFiles_Description'
	,'ERFile generated by the EDI File'
	,'schema'
	,'dbo'
	,'table'
	,'CustomEDIFilesERFiles'
	,'column'
	,'ERFileId'
	
END

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomEDITradingPartnersERSenders')
BEGIN
/*  
 * TABLE: CustomEDITradingPartnersERSenders  
 */
CREATE TABLE CustomEDITradingPartnersERSenders(
			EDITradingPartnerId							int						NOT NULL,
			CreatedBy									type_CurrentUser        NOT NULL,
			CreatedDate									type_CurrentDatetime    NOT NULL,
			ModifiedBy									type_CurrentUser        NOT NULL,
			ModifiedDate								type_CurrentDatetime    NOT NULL,
			RecordDeleted								type_YOrN               NULL
														CHECK (RecordDeleted in ('Y','N')),
			DeletedBy									type_UserId             NULL,
			DeletedDate									datetime				NULL,
			ERSenderId									int						NULL,       --ERSenderId to be used when running 835 files from this trading partner.
			CONSTRAINT CustomEDITradingPartnersERSenders_PK PRIMARY KEY CLUSTERED (EDITradingPartnerId) 
 )
 
  IF OBJECT_ID('CustomEDITradingPartnersERSenders') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomEDITradingPartnersERSenders >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomEDITradingPartnersERSenders >>>', 16, 1)
/* 
 * TABLE: CustomEDITradingPartnersERSenders 
 */ 
   
ALTER TABLE CustomEDITradingPartnersERSenders ADD CONSTRAINT EDITradingPartners_CustomEDITradingPartnersERSenders_FK 
	FOREIGN KEY (EDITradingPartnerId)
	REFERENCES EDITradingPartners(EDITradingPartnerId)
	
ALTER TABLE CustomEDITradingPartnersERSenders ADD CONSTRAINT ERSenders_CustomEDITradingPartnersERSenders_FK 
	FOREIGN KEY (ERSenderId)
	REFERENCES ERSenders(ERSenderId)
	
	PRINT 'STEP 4(D) COMPLETED'
	
	EXEC sys.sp_addextendedproperty 'CustomEDITradingPartnersERSenders_Description'
	,'ERSenderId to be used when running 835 files from this trading partner.'
	,'schema'
	,'dbo'
	,'table'
	,'CustomEDITradingPartnersERSenders'
	,'column'
	,'ERSenderId'
		
END

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomERClaimLineItemCharges')
BEGIN
/*  
 * TABLE: CustomERClaimLineItemCharges  
 */
CREATE TABLE CustomERClaimLineItemCharges(
			ERClaimLineItemChargeId		int	IDENTITY(1,1)		NOT NULL, 
			CreatedBy					type_CurrentUser		NOT NULL, 
			CreatedDate					type_CurrentDatetime	NOT NULL, 
			ModifiedBy					type_CurrentUser		NOT NULL, 
			ModifiedDate				type_CurrentDatetime	NOT NULL, 
			RecordDeleted				type_YOrN				NULL, 
										CHECK (RecordDeleted in ('Y','N')),
			DeletedBy					type_UserId				NULL, 
			DeletedDate					datetime				NULL, 
			ERClaimLineItemId			int						NOT NULL, 
			ChargeId					int						NOT NULL 
			CONSTRAINT CustomERClaimLineItemCharges_PK PRIMARY KEY CLUSTERED (ERClaimLineItemChargeId) 
 )
 
  IF OBJECT_ID('CustomERClaimLineItemCharges') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomERClaimLineItemCharges >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomERClaimLineItemCharges >>>', 16, 1)
/* 
 * TABLE: CustomERClaimLineItemCharges 
 */ 
 
 ALTER TABLE CustomERClaimLineItemCharges ADD CONSTRAINT Charges_CustomERClaimLineItemCharges_FK 
	FOREIGN KEY (ChargeId)
	REFERENCES Charges(ChargeId)
	
ALTER TABLE CustomERClaimLineItemCharges ADD CONSTRAINT ERClaimLineItems_CustomERClaimLineItemCharges_FK 
	FOREIGN KEY (ERClaimLineItemId)
	REFERENCES ERClaimLineItems(ERClaimLineItemId)

	PRINT 'STEP 4(E) COMPLETED'
	
END

--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------


------ STEP 7 -----------
IF NOT EXISTS (	SELECT [key] FROM SystemConfigurationKeys	WHERE [key] = 'CDM_835')
BEGIN
	INSERT INTO SystemConfigurationKeys (
		CreatedBy
		,CreateDate
		,ModifiedBy
		,ModifiedDate
		,[key]
		,Value
		)
	VALUES (
		'SHSDBA'
		,GETDATE()
		,'SHSDBA'
		,GETDATE()
		,'CDM_835'
		,'1.0'
		)
	PRINT 'STEP 7 COMPLETED'
END
GO