----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.46)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.46 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END

------ STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins

--Part2 Ends	

-----End of Step 2 -------

------ STEP 3 ------------

-----END Of STEP 3--------------------

------ STEP 4 ------------

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='DocumentAuthorizationRequests')
BEGIN
/* 
 * TABLE: DocumentAuthorizationRequests 
 */
CREATE TABLE DocumentAuthorizationRequests(
			DocumentVersionId							int						NOT NULL,
			CreatedBy									type_CurrentUser        NOT NULL,
			CreatedDate									type_CurrentDatetime    NOT NULL,
			ModifiedBy									type_CurrentUser        NOT NULL,
			ModifiedDate								type_CurrentDatetime    NOT NULL,
			RecordDeleted								type_YOrN               NULL
														CHECK (RecordDeleted in ('Y','N')),
			DeletedBy									type_UserId             NULL,
			DeletedDate									datetime				NULL,
			InsurerId									int						NULL,
			ProviderId									int						NULL,
			Requestor									varchar(max)			NULL,													
			CONSTRAINT DocumentAuthorizationRequests_PK PRIMARY KEY CLUSTERED (DocumentVersionId) 
 )
 

  IF OBJECT_ID('DocumentAuthorizationRequests') IS NOT NULL
    PRINT '<<< CREATED TABLE DocumentAuthorizationRequests >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE DocumentAuthorizationRequests >>>', 16, 1)
    	
/* 
 * TABLE: DocumentAuthorizations 
 */ 
 
ALTER TABLE DocumentAuthorizationRequests ADD CONSTRAINT DocumentVersions_DocumentAuthorizationRequests_FK 
	FOREIGN KEY (DocumentVersionId)
	REFERENCES DocumentVersions(DocumentVersionId)
 
ALTER TABLE DocumentAuthorizationRequests ADD CONSTRAINT Insurers_DocumentAuthorizationRequestss_FK 
	FOREIGN KEY (InsurerId)
	REFERENCES Insurers(InsurerId)
	
ALTER TABLE DocumentAuthorizationRequests ADD CONSTRAINT Providers_DocumentAuthorizationRequests_FK 
	FOREIGN KEY (ProviderId)
	REFERENCES Providers(ProviderId)
 
	PRINT 'STEP 4(A) COMPLETED'
END

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='AuthorizationRequests')
BEGIN
/* 
 * TABLE: AuthorizationRequests 
 */	
CREATE TABLE AuthorizationRequests(
			AuthorizationRequestId								int	identity(1,1)		  NOT NULL,
			CreatedBy											type_CurrentUser          NOT NULL,
			CreatedDate											type_CurrentDatetime      NOT NULL,
			ModifiedBy											type_CurrentUser          NOT NULL,
			ModifiedDate										type_CurrentDatetime      NOT NULL,
			RecordDeleted										type_YOrN                 NULL
																CHECK (RecordDeleted in ('Y','N')),
			DeletedBy											type_UserId               NULL,
			DeletedDate											datetime				  NULL,
			DocumentVersionId									int						  NULL,
			SiteId												int						  NULL,
			BillingCodeId										int						  NULL,
			BillingCodeModifierId								int						  NULL,
			ProviderAuthorizationId								int						  NULL,	
			[Status]											type_GlobalCode			  NULL,	
			Active												type_YOrN                 NULL
																CHECK (Active in ('Y','N')),
			Appealed											type_YOrN                 NULL
																CHECK (Appealed in ('Y','N')),
			Urgent												type_YOrN                 NULL
																CHECK (Urgent in ('Y','N')),
			StartDate											datetime				  NULL,
			EndDate												datetime				  NULL,
			Frequency											type_GlobalCode			  NULL,
			Units												int						  NULL,
			TotalUnits											decimal(18,2)			  NULL,
			Modifier1											varchar(10)				  NULL,
			Modifier2											varchar(10)				  NULL,
			Modifier3											varchar(10)				  NULL,
			Modifier4											varchar(10)				  NULL,
			Comment												type_Comment2			  NULL,
			CONSTRAINT AuthorizationRequests_PK PRIMARY KEY CLUSTERED (AuthorizationRequestId)
)

  IF OBJECT_ID('AuthorizationRequests') IS NOT NULL
    PRINT '<<< CREATED TABLE AuthorizationRequests >>>'
	ELSE
    RAISERROR('<<< FAILED CREATING TABLE AuthorizationRequests >>>', 16, 1)
    
    IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[AuthorizationRequests]') AND name = N'XIE1_AuthorizationRequests')
	BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_AuthorizationRequests] ON [dbo].[AuthorizationRequests] 
		(	
		[DocumentVersionId] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('AuthorizationRequests') AND name='XIE1_AuthorizationRequests')
		PRINT '<<< CREATED INDEX AuthorizationRequests.XIE1_AuthorizationRequests >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX AuthorizationRequests.XIE1_AuthorizationRequests >>>', 16, 1)
	END 
    
    
/* 
 * TABLE: AuthorizationRequests 
 */   
    
ALTER TABLE AuthorizationRequests ADD CONSTRAINT DocumentVersions_AuthorizationRequests_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
    
 ALTER TABLE AuthorizationRequests ADD CONSTRAINT BillingCodes_AuthorizationRequests_FK
    FOREIGN KEY (BillingCodeId)
    REFERENCES BillingCodes(BillingCodeId)
    
 ALTER TABLE AuthorizationRequests ADD CONSTRAINT Sites_AuthorizationRequests_FK
    FOREIGN KEY (SiteId)
    REFERENCES Sites(SiteId)
    
ALTER TABLE AuthorizationRequests ADD CONSTRAINT BillingCodeModifiers_AuthorizationRequests_FK
    FOREIGN KEY (BillingCodeModifierId)
    REFERENCES BillingCodeModifiers(BillingCodeModifierId)
    
ALTER TABLE AuthorizationRequests ADD CONSTRAINT ProviderAuthorizations_AuthorizationRequests_FK
    FOREIGN KEY (ProviderAuthorizationId)
    REFERENCES ProviderAuthorizations(ProviderAuthorizationId)
    
    
     PRINT 'STEP 4(B) COMPLETED'
 END


----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.46)
BEGIN
Update SystemConfigurations set DataModelVersion=15.47
PRINT 'STEP 7 COMPLETED'
END
Go