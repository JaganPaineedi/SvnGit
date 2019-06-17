----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.76)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.76 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
-------------------------------------------------------------

------ STEP 3 ------------

--END Of STEP 3------------
------ STEP 4 ----------
IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='DocumentReleaseOfInformations')
BEGIN
/*		  
 * TABLE: DocumentReleaseOfInformations
 */ 
CREATE TABLE DocumentReleaseOfInformations(
		DocumentVersionId						 	int						NOT NULL,
		CreatedBy									type_CurrentUser		NOT NULL,
		CreatedDate									type_CurrentDatetime	NOT NULL,
	    ModifiedBy									type_CurrentUser		NOT NULL,
	    ModifiedDate								type_CurrentDatetime	NOT NULL,
		RecordDeleted								type_YOrN				NULL
													CHECK (RecordDeleted in ('Y','N')),
		DeletedBy									type_UserId				NULL,
		DeletedDate									datetime				NULL,
		ProgramId									int						NULL,	
		ReleaseToFromContactId						int						NULL,
		RecordsStartDate							datetime				NULL,				
		RecordsEndDate								datetime				NULL,			
		ReleaseType									Char(1)					NULL
													CHECK (ReleaseType in ('O','C')), 
		ReleaseTo									type_YOrN				NULL
													CHECK (ReleaseTo in ('Y','N')),				
		ObtainFrom									type_YOrN				NULL
													CHECK (ObtainFrom in ('Y','N')),				
		ReleaseToFromOrganization					int						NULL,
		ReleaseContactType							type_GlobalCode			NULL,			
		Organization								varchar(100)			NULL,				
		ReleaseName									varchar(100)			NULL,				
		ReleaseAddress								type_Address			NULL,			
		ReleaseCity									type_City				NULL,			
		ReleaseState								type_State				NULL,			
		ReleasePhoneNumber							type_PhoneNumber		NULL,				
		ReleaseZip									type_ZipCode			NULL,	
		ExpirationStartDate							datetime				NULL,			
		ExpirationEndDate							datetime				NULL,		
		UsedOrDisclosedStartDate					datetime				NULL,
		UsedOrDisclosedEndDate						datetime				NULL,
		ROIType										type_GlobalCode			NULL,		
		OtherPurposeOfDisclosure					varchar(100)			NULL,				
		OtherInformationTobeUsedText				type_Comment2			NULL,				
		NoticeToClient								type_YOrN				NULL
													CHECK (NoticeToClient in ('Y','N')),				
		AccessToMyRecord							type_YOrN				NULL
													CHECK (AccessToMyRecord in ('Y','N')),						
		Attention									type_Comment2			NULL,			
		ContactAddress								type_Address			NULL,				
		ContactCity									type_City				NULL,			
		ContactState								type_State				NULL,			
		ContactPhoneNumber							type_PhoneNumber		NULL,			
		ContactZip									type_ZipCode			NULL,			
		ContactFax									type_PhoneNumber		NULL,				
		CopyGivenToClient							type_YOrN				NULL
													CHECK (CopyGivenToClient in ('Y','N')),				
		AgencyStaff									varchar(100)			NULL,				
		Restrictions								type_Comment2			NULL,
		AlcoholDrugAbuse							char(1)					NULL
													CHECK (AlcoholDrugAbuse in ('A','P')),
		AIDSRelatedComplex							char(1)					NULL
													CHECK (AIDSRelatedComplex in ('A','P')),
		CONSTRAINT DocumentReleaseOfInformations_PK PRIMARY KEY CLUSTERED (DocumentVersionId) 
) 

 IF OBJECT_ID('DocumentReleaseOfInformations') IS NOT NULL
    PRINT '<<< CREATED TABLE DocumentReleaseOfInformations >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE DocumentReleaseOfInformations >>>', 16, 1)
    

 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('DocumentReleaseOfInformations') AND name='XIE1_DocumentReleaseOfInformations')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_DocumentReleaseOfInformations] ON [dbo].[DocumentReleaseOfInformations] 
		(
		ProgramId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('DocumentReleaseOfInformations') AND name='XIE1_DocumentReleaseOfInformations')
		PRINT '<<< CREATED INDEX DocumentReleaseOfInformations.XIE1_DocumentReleaseOfInformations >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX DocumentReleaseOfInformations.XIE1_DocumentReleaseOfInformations >>>', 16, 1)		
		END	
		
 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('DocumentReleaseOfInformations') AND name='XIE12_DocumentReleaseOfInformations')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_DocumentReleaseOfInformations] ON [dbo].[DocumentReleaseOfInformations] 
		(
		ReleaseToFromContactId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('DocumentReleaseOfInformations') AND name='XIE2_DocumentReleaseOfInformations')
		PRINT '<<< CREATED INDEX DocumentReleaseOfInformations.XIE2_DocumentReleaseOfInformations >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX DocumentReleaseOfInformations.XIE2_DocumentReleaseOfInformations >>>', 16, 1)		
		END	
    
/* 
 * TABLE: DocumentReleaseOfInformations 
 */ 
 
 ALTER TABLE DocumentReleaseOfInformations ADD CONSTRAINT DocumentVersions_DocumentReleaseOfInformations_FK
	FOREIGN KEY (DocumentVersionId)
	REFERENCES DocumentVersions(DocumentVersionId) 
	
ALTER TABLE DocumentReleaseOfInformations ADD CONSTRAINT Programs_DocumentReleaseOfInformations_FK
	FOREIGN KEY (ProgramId)
	REFERENCES Programs(ProgramId) 
	
ALTER TABLE DocumentReleaseOfInformations ADD CONSTRAINT ClientContacts_DocumentReleaseOfInformations_FK
	FOREIGN KEY (ReleaseToFromContactId)
	REFERENCES ClientContacts(ClientContactId) 
	

EXEC sys.sp_addextendedproperty 'DocumentReleaseOfInformations_Description'
	,'ReleaseType Column stores O and C .O-Organization/Provider, C-Contact'
	,'schema'
	,'dbo'
	,'table'
	,'DocumentReleaseOfInformations'
	,'column'
	,'ReleaseType'
	

EXEC sys.sp_addextendedproperty 'AlcoholDrugAbuse_Description'
	,'AlcoholDrugAbuse Column stores A and P .A-Authorize the ROI, P-Prohibit the ROI'
	,'schema'
	,'dbo'
	,'table'
	,'DocumentReleaseOfInformations'
	,'column'
	,'AlcoholDrugAbuse'
	
EXEC sys.sp_addextendedproperty 'AlcoholDrugAbuse_Description'
	,'AIDSRelatedComplex Column stores A and P .A-Authorize the ROI, P-Prohibit the ROI'
	,'schema'
	,'dbo'
	,'table'
	,'DocumentReleaseOfInformations'
	,'column'
	,'AIDSRelatedComplex'
        
	
PRINT 'STEP 4(A) COMPLETED'
END


IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='ROIPurposeOfDisclosures')
BEGIN
/*		  
 * TABLE: ROIPurposeOfDisclosures
 */ 
CREATE TABLE ROIPurposeOfDisclosures(
		 ROIPurposeOfDisclosureId				 	int identity(1,1)		NOT NULL,
		 CreatedBy									type_CurrentUser		NOT NULL,
		 CreatedDate								type_CurrentDatetime	NOT NULL,
		 ModifiedBy									type_CurrentUser		NOT NULL,
		 ModifiedDate								type_CurrentDatetime	NOT NULL,
		 RecordDeleted								type_YOrN				NULL
													CHECK (RecordDeleted in ('Y','N')),
		 DeletedBy									type_UserId				NULL,
		 DeletedDate								datetime				NULL,
		 DocumentVersionId							int						NULL,
		 PurposeOfDisclosure						type_GlobalCode			NULL,						
		 CONSTRAINT ROIPurposeOfDisclosures_PK PRIMARY KEY CLUSTERED (ROIPurposeOfDisclosureId) 
) 

 IF OBJECT_ID('ROIPurposeOfDisclosures') IS NOT NULL
    PRINT '<<< CREATED TABLE ROIPurposeOfDisclosures >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE ROIPurposeOfDisclosures >>>', 16, 1)
    
    
 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ROIPurposeOfDisclosures') AND name='XIE1_ROIPurposeOfDisclosures')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_ROIPurposeOfDisclosures] ON [dbo].[ROIPurposeOfDisclosures] 
		(
		DocumentVersionId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ROIPurposeOfDisclosures') AND name='XIE1_ROIPurposeOfDisclosures')
		PRINT '<<< CREATED INDEX ROIPurposeOfDisclosures.XIE1_ROIPurposeOfDisclosures >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ROIPurposeOfDisclosures.XIE1_ROIPurposeOfDisclosures >>>', 16, 1)		
		END	
		
    
/* 
 * TABLE: ROIPurposeOfDisclosures 
 */ 
 
 ALTER TABLE ROIPurposeOfDisclosures ADD CONSTRAINT DocumentVersions_ROIPurposeOfDisclosures_FK
	FOREIGN KEY (DocumentVersionId)
	REFERENCES DocumentVersions(DocumentVersionId) 
       
	
PRINT 'STEP 4(B) COMPLETED'
END


IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='ROIExpirations')
BEGIN
/*		  
 * TABLE: ROIExpirations
 */ 
CREATE TABLE ROIExpirations(
		 ROIExpirationId				 			int identity(1,1)		NOT NULL,
		 CreatedBy									type_CurrentUser		NOT NULL,
		 CreatedDate								type_CurrentDatetime	NOT NULL,
		 ModifiedBy									type_CurrentUser		NOT NULL,
		 ModifiedDate								type_CurrentDatetime	NOT NULL,
		 RecordDeleted								type_YOrN				NULL
													CHECK (RecordDeleted in ('Y','N')),
		 DeletedBy									type_UserId				NULL,
		 DeletedDate								datetime				NULL,
		 DocumentVersionId							int						NULL,
		 Expiration									type_GlobalCode			NULL,						
		 CONSTRAINT ROIExpirations_PK PRIMARY KEY CLUSTERED (ROIExpirationId) 
) 

 IF OBJECT_ID('ROIExpirations') IS NOT NULL
    PRINT '<<< CREATED TABLE ROIExpirations >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE ROIExpirations >>>', 16, 1)
    
    
 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ROIExpirations') AND name='XIE1_ROIExpirations')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_ROIExpirations] ON [dbo].[ROIExpirations] 
		(
		DocumentVersionId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ROIExpirations') AND name='XIE1_ROIExpirations')
		PRINT '<<< CREATED INDEX ROIExpirations.XIE1_ROIExpirations >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ROIExpirations.XIE1_ROIExpirations >>>', 16, 1)		
		END	
		
    
/* 
 * TABLE: ROIExpirations 
 */ 
 
 ALTER TABLE ROIExpirations ADD CONSTRAINT DocumentVersions_ROIExpirations_FK
	FOREIGN KEY (DocumentVersionId)
	REFERENCES DocumentVersions(DocumentVersionId) 
       
	
PRINT 'STEP 4(C) COMPLETED'
END


IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='ROIUsedDisclosedInformations')
BEGIN
/*		  
 * TABLE: ROIUsedDisclosedInformations
 */ 
CREATE TABLE ROIUsedDisclosedInformations(
		 ROIUsedDisclosedInformationId				 int identity(1,1)		NOT NULL,
		 CreatedBy									type_CurrentUser		NOT NULL,
		 CreatedDate								type_CurrentDatetime	NOT NULL,
		 ModifiedBy									type_CurrentUser		NOT NULL,
		 ModifiedDate								type_CurrentDatetime	NOT NULL,
		 RecordDeleted								type_YOrN				NULL
													CHECK (RecordDeleted in ('Y','N')),
		 DeletedBy									type_UserId				NULL,
		 DeletedDate								datetime				NULL,
		 DocumentVersionId							int						NULL,
		 UsedOrDisclosed							type_GlobalCode			NULL,						
		 CONSTRAINT ROIUsedDisclosedInformations_PK PRIMARY KEY CLUSTERED (ROIUsedDisclosedInformationId) 
) 

 IF OBJECT_ID('ROIUsedDisclosedInformations') IS NOT NULL
    PRINT '<<< CREATED TABLE ROIUsedDisclosedInformations >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE ROIUsedDisclosedInformations >>>', 16, 1)
    
    
 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ROIUsedDisclosedInformations') AND name='XIE1_ROIUsedDisclosedInformations')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_ROIUsedDisclosedInformations] ON [dbo].[ROIUsedDisclosedInformations] 
		(
		DocumentVersionId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ROIUsedDisclosedInformations') AND name='XIE1_ROIUsedDisclosedInformations')
		PRINT '<<< CREATED INDEX ROIUsedDisclosedInformations.XIE1_ROIUsedDisclosedInformations >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ROIUsedDisclosedInformations.XIE1_ROIUsedDisclosedInformations >>>', 16, 1)		
		END	
		
    
/* 
 * TABLE: ROIUsedDisclosedInformations 
 */ 
 
 ALTER TABLE ROIUsedDisclosedInformations ADD CONSTRAINT DocumentVersions_ROIUsedDisclosedInformations_FK
	FOREIGN KEY (DocumentVersionId)
	REFERENCES DocumentVersions(DocumentVersionId) 
       
	
PRINT 'STEP 4(D) COMPLETED'
END


IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='ROIIDVerifyDetails')
BEGIN
/*		  
 * TABLE: ROIIDVerifyDetails
 */ 
CREATE TABLE ROIIDVerifyDetails(
		 ROIIDVerifyDetailsId						int identity(1,1)		NOT NULL,
		 CreatedBy									type_CurrentUser		NOT NULL,
		 CreatedDate								type_CurrentDatetime	NOT NULL,
		 ModifiedBy									type_CurrentUser		NOT NULL,
		 ModifiedDate								type_CurrentDatetime	NOT NULL,
		 RecordDeleted								type_YOrN				NULL
													CHECK (RecordDeleted in ('Y','N')),
		 DeletedBy									type_UserId				NULL,
		 DeletedDate								datetime				NULL,
		 DocumentVersionId							int						NULL,
		 IDVerified									type_GlobalCode			NULL,						
		 CONSTRAINT ROIIDVerifyDetails_PK PRIMARY KEY CLUSTERED (ROIIDVerifyDetailsId) 
) 

 IF OBJECT_ID('ROIIDVerifyDetails') IS NOT NULL
    PRINT '<<< CREATED TABLE ROIIDVerifyDetails >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE ROIIDVerifyDetails >>>', 16, 1)
    
    
 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ROIIDVerifyDetails') AND name='XIE1_ROIIDVerifyDetails')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_ROIIDVerifyDetails] ON [dbo].[ROIIDVerifyDetails] 
		(
		DocumentVersionId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ROIIDVerifyDetails') AND name='XIE1_ROIIDVerifyDetails')
		PRINT '<<< CREATED INDEX ROIIDVerifyDetails.XIE1_ROIIDVerifyDetails >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ROIIDVerifyDetails.XIE1_ROIIDVerifyDetails >>>', 16, 1)		
		END	
		
    
/* 
 * TABLE: ROIIDVerifyDetails 
 */ 
 
 ALTER TABLE ROIIDVerifyDetails ADD CONSTRAINT DocumentVersions_ROIIDVerifyDetails_FK
	FOREIGN KEY (DocumentVersionId)
	REFERENCES DocumentVersions(DocumentVersionId) 
       
	
PRINT 'STEP 4(E) COMPLETED'
END

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='DocumentRevokeReleaseOfInformations')
BEGIN
/*		  
 * TABLE: DocumentRevokeReleaseOfInformations
 */ 
CREATE TABLE DocumentRevokeReleaseOfInformations(
		 DocumentVersionId							int						NOT NULL,
		 CreatedBy									type_CurrentUser		NOT NULL,
		 CreatedDate								type_CurrentDatetime	NOT NULL,
		 ModifiedBy									type_CurrentUser		NOT NULL,
		 ModifiedDate								type_CurrentDatetime	NOT NULL,
		 RecordDeleted								type_YOrN				NULL
													CHECK (RecordDeleted in ('Y','N')),
		 DeletedBy									type_UserId				NULL,
		 DeletedDate								datetime				NULL,
		 ClientInformationReleaseId					int						NULL,
		 RevokeEndDate								datetime				NULL,	
		 ClientWrittenConsent						type_YOrN				NULL
													CHECK (ClientWrittenConsent in ('Y','N')),
		 CONSTRAINT DocumentRevokeReleaseOfInformations_PK PRIMARY KEY CLUSTERED (DocumentVersionId) 
) 

 IF OBJECT_ID('DocumentRevokeReleaseOfInformations') IS NOT NULL
    PRINT '<<< CREATED TABLE DocumentRevokeReleaseOfInformations >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE DocumentRevokeReleaseOfInformations >>>', 16, 1)
    
		
    
/* 
 * TABLE: DocumentRevokeReleaseOfInformations 
 */ 
 
 ALTER TABLE DocumentRevokeReleaseOfInformations ADD CONSTRAINT DocumentVersions_DocumentRevokeReleaseOfInformations_FK
	FOREIGN KEY (DocumentVersionId)
	REFERENCES DocumentVersions(DocumentVersionId) 
       
	
PRINT 'STEP 4(F) COMPLETED'
END

------END Of STEP 4---------------

------ STEP 5 ----------------

-------END STEP 5-------------
------ STEP 6  ----------

----END Of STEP 6 ------------

------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 18.76)
BEGIN
Update SystemConfigurations set DataModelVersion=18.77
PRINT 'STEP 7 COMPLETED'
END
Go
