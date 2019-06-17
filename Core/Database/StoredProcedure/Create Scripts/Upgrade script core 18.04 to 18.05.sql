----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.04)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.04 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of Step 2 -------
------ STEP 3 ------------

-----End of Step 3 -------

------ STEP 4 ---------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CoveragePlanFullyResponsibleOverrides')
BEGIN
/*  
  TABLE: CoveragePlanFullyResponsibleOverrides 
 */
 CREATE TABLE CoveragePlanFullyResponsibleOverrides( 
		CoveragePlanFullyResponsibleOverrideId		int	identity(1,1)		NOT NULL,
		CreatedBy									type_CurrentUser		NOT NULL,
		CreatedDate									type_Currentdatetime	NOT NULL,
		ModifiedBy									type_CurrentUser		NOT NULL,
		ModifiedDate								type_Currentdatetime	NOT NULL,
		RecordDeleted								type_YOrN				NULL
													CHECK (RecordDeleted in ('Y','N')),
		DeletedBy									type_UserId				NULL,	
		DeletedDate									datetime				NULL,
		CoveragePlanId								int						NOT NULL, -- FK CoveragePlans
		Active										type_YOrN				NULL
													CHECK (Active in ('Y','N')),
		StartDate									date					NULL,
		EndDate										date					NULL,
		AllClients									type_YOrN				NULL
													CHECK (AllClients in ('Y','N')),
		ClientStartAge								int						NULL,
		ClientEndAge								int						NULL,
		InsurerGroupName							varchar(250)			NULL,
		ProviderSiteGroupName						varchar(250)			NULL,
		BillingCodeGroupName						varchar(250)			NULL,
		PlaceOfServiceGroupName						varchar(250)			NULL,
		DiagnosisCodeCategoryGroupName				varchar(250)			NULL,
		CONSTRAINT CoveragePlanFullyResponsibleOverrides_PK PRIMARY KEY CLUSTERED (CoveragePlanFullyResponsibleOverrideId)
 )
 
  IF OBJECT_ID('CoveragePlanFullyResponsibleOverrides') IS NOT NULL
    PRINT '<<< CREATED TABLE CoveragePlanFullyResponsibleOverrides >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CoveragePlanFullyResponsibleOverrides >>>', 16, 1)
    
 IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CoveragePlanFullyResponsibleOverrides]') AND name = N'XIE1_CoveragePlanFullyResponsibleOverrides')
		BEGIN
			CREATE NONCLUSTERED INDEX [XIE1_CoveragePlanFullyResponsibleOverrides] ON [dbo].[CoveragePlanFullyResponsibleOverrides] 
			(
			CoveragePlanId  ASC
			)
			WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
			IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CoveragePlanFullyResponsibleOverrides') AND name='XIE1_CoveragePlanFullyResponsibleOverrides')
			PRINT '<<< CREATED INDEX CoveragePlanFullyResponsibleOverrides.XIE1_CoveragePlanFullyResponsibleOverrides >>>'
			ELSE
			RAISERROR('<<< FAILED CREATING INDEX CoveragePlanFullyResponsibleOverrides.XIE1_CoveragePlanFullyResponsibleOverrides >>>', 16, 1)		
		END      
    
    
/* 
 * TABLE: CoveragePlanFullyResponsibleOverrides 
 */
 
 ALTER TABLE CoveragePlanFullyResponsibleOverrides ADD CONSTRAINT CoveragePlans_CoveragePlanFullyResponsibleOverrides_FK
    FOREIGN KEY (CoveragePlanId)
    REFERENCES CoveragePlans(CoveragePlanId) 
            
     PRINT 'STEP 4(A) COMPLETED'
 END
 
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CoveragePlanFullyResponsibleOverrideInsurers')
BEGIN
/*  
  TABLE: CoveragePlanFullyResponsibleOverrideInsurers 
 */
 CREATE TABLE CoveragePlanFullyResponsibleOverrideInsurers( 
		CoveragePlanFullyResponsibleOverrideInsurerId		int	identity(1,1)		NOT NULL,
		CreatedBy											type_CurrentUser		NOT NULL,
		CreatedDate											type_Currentdatetime	NOT NULL,
		ModifiedBy											type_CurrentUser		NOT NULL,
		ModifiedDate										type_Currentdatetime	NOT NULL,
		RecordDeleted										type_YOrN				NULL
															CHECK (RecordDeleted in ('Y','N')),
		DeletedBy											type_UserId				NULL,	
		DeletedDate											datetime				NULL,
		CoveragePlanFullyResponsibleOverrideId				int						NOT NULL, 
		InsurerId											int						NULL,
		CONSTRAINT CoveragePlanFullyResponsibleOverrideInsurers_PK PRIMARY KEY CLUSTERED (CoveragePlanFullyResponsibleOverrideInsurerId)
 )
 
  IF OBJECT_ID('CoveragePlanFullyResponsibleOverrideInsurers') IS NOT NULL
    PRINT '<<< CREATED TABLE CoveragePlanFullyResponsibleOverrideInsurers >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CoveragePlanFullyResponsibleOverrideInsurers >>>', 16, 1)
    
 IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CoveragePlanFullyResponsibleOverrideInsurers]') AND name = N'XIE1_CoveragePlanFullyResponsibleOverrideInsurers')
		BEGIN
			CREATE NONCLUSTERED INDEX [XIE1_CoveragePlanFullyResponsibleOverrideInsurers] ON [dbo].[CoveragePlanFullyResponsibleOverrideInsurers] 
			(
			CoveragePlanFullyResponsibleOverrideId  ASC
			)
			WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
			IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CoveragePlanFullyResponsibleOverrideInsurers') AND name='XIE1_CoveragePlanFullyResponsibleOverrideInsurers')
			PRINT '<<< CREATED INDEX CoveragePlanFullyResponsibleOverrideInsurers.XIE1_CoveragePlanFullyResponsibleOverrideInsurers >>>'
			ELSE
			RAISERROR('<<< FAILED CREATING INDEX CoveragePlanFullyResponsibleOverrideInsurers.XIE1_CoveragePlanFullyResponsibleOverrideInsurers >>>', 16, 1)		
		END     
		
 IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CoveragePlanFullyResponsibleOverrideInsurers]') AND name = N'XIE2_CoveragePlanFullyResponsibleOverrideInsurers')
		BEGIN
			CREATE NONCLUSTERED INDEX [XIE2_CoveragePlanFullyResponsibleOverrideInsurers] ON [dbo].[CoveragePlanFullyResponsibleOverrideInsurers] 
			(
			InsurerId  ASC
			)
			WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
			IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CoveragePlanFullyResponsibleOverrideInsurers') AND name='XIE2_CoveragePlanFullyResponsibleOverrideInsurers')
			PRINT '<<< CREATED INDEX CoveragePlanFullyResponsibleOverrideInsurers.XIE2_CoveragePlanFullyResponsibleOverrideInsurers >>>'
			ELSE
			RAISERROR('<<< FAILED CREATING INDEX CoveragePlanFullyResponsibleOverrideInsurers.XIE2_CoveragePlanFullyResponsibleOverrideInsurers >>>', 16, 1)		
		END   
    
    
/* 
 * TABLE: CoveragePlanFullyResponsibleOverrideInsurers 
 */
 
 ALTER TABLE CoveragePlanFullyResponsibleOverrideInsurers ADD CONSTRAINT CoveragePlanFullyResponsibleOverrides_CoveragePlanFullyResponsibleOverrideInsurers_FK
    FOREIGN KEY (CoveragePlanFullyResponsibleOverrideId)
    REFERENCES CoveragePlanFullyResponsibleOverrides(CoveragePlanFullyResponsibleOverrideId) 
    
 ALTER TABLE CoveragePlanFullyResponsibleOverrideInsurers ADD CONSTRAINT Insurers_CoveragePlanFullyResponsibleOverrideInsurers_FK
    FOREIGN KEY (InsurerId)
    REFERENCES Insurers(InsurerId) 
            
     PRINT 'STEP 4(B) COMPLETED'
 END
 
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CoveragePlanFullyResponsibleOverrideClients')
BEGIN
/*  
  TABLE: CoveragePlanFullyResponsibleOverrideClients 
 */
 CREATE TABLE CoveragePlanFullyResponsibleOverrideClients( 
		CoveragePlanFullyResponsibleOverrideClientId		int	identity(1,1)		NOT NULL,
		CreatedBy											type_CurrentUser		NOT NULL,
		CreatedDate											type_Currentdatetime	NOT NULL,
		ModifiedBy											type_CurrentUser		NOT NULL,
		ModifiedDate										type_Currentdatetime	NOT NULL,
		RecordDeleted										type_YOrN				NULL
															CHECK (RecordDeleted in ('Y','N')),
		DeletedBy											type_UserId				NULL,	
		DeletedDate											datetime				NULL,
		CoveragePlanFullyResponsibleOverrideId				int						NOT NULL, 
		ClientId											int						NULL,
		CONSTRAINT CoveragePlanFullyResponsibleOverrideClients_PK PRIMARY KEY CLUSTERED (CoveragePlanFullyResponsibleOverrideClientId)
 )
 
  IF OBJECT_ID('CoveragePlanFullyResponsibleOverrideClients') IS NOT NULL
    PRINT '<<< CREATED TABLE CoveragePlanFullyResponsibleOverrideClients >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CoveragePlanFullyResponsibleOverrideClients >>>', 16, 1)
    
 IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CoveragePlanFullyResponsibleOverrideClients]') AND name = N'XIE1_CoveragePlanFullyResponsibleOverrideClients')
		BEGIN
			CREATE NONCLUSTERED INDEX [XIE1_CoveragePlanFullyResponsibleOverrideClients] ON [dbo].[CoveragePlanFullyResponsibleOverrideClients] 
			(
			CoveragePlanFullyResponsibleOverrideId  ASC
			)
			WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
			IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CoveragePlanFullyResponsibleOverrideClients') AND name='XIE1_CoveragePlanFullyResponsibleOverrideClients')
			PRINT '<<< CREATED INDEX CoveragePlanFullyResponsibleOverrideClients.XIE1_CoveragePlanFullyResponsibleOverrideClients >>>'
			ELSE
			RAISERROR('<<< FAILED CREATING INDEX CoveragePlanFullyResponsibleOverrideClients.XIE1_CoveragePlanFullyResponsibleOverrideClients >>>', 16, 1)		
		END     
		
 IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CoveragePlanFullyResponsibleOverrideClients]') AND name = N'XIE2_CoveragePlanFullyResponsibleOverrideClients')
		BEGIN
			CREATE NONCLUSTERED INDEX [XIE2_CoveragePlanFullyResponsibleOverrideClients] ON [dbo].[CoveragePlanFullyResponsibleOverrideClients] 
			(
			ClientId  ASC
			)
			WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
			IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CoveragePlanFullyResponsibleOverrideClients') AND name='XIE2_CoveragePlanFullyResponsibleOverrideClients')
			PRINT '<<< CREATED INDEX CoveragePlanFullyResponsibleOverrideClients.XIE2_CoveragePlanFullyResponsibleOverrideClients >>>'
			ELSE
			RAISERROR('<<< FAILED CREATING INDEX CoveragePlanFullyResponsibleOverrideClients.XIE2_CoveragePlanFullyResponsibleOverrideClients >>>', 16, 1)		
		END   
    
    
/* 
 * TABLE: CoveragePlanFullyResponsibleOverrideClients 
 */
 
 ALTER TABLE CoveragePlanFullyResponsibleOverrideClients ADD CONSTRAINT CoveragePlanFullyResponsibleOverrides_CoveragePlanFullyResponsibleOverrideClients_FK
    FOREIGN KEY (CoveragePlanFullyResponsibleOverrideId)
    REFERENCES CoveragePlanFullyResponsibleOverrides(CoveragePlanFullyResponsibleOverrideId) 
    
 ALTER TABLE CoveragePlanFullyResponsibleOverrideClients ADD CONSTRAINT Clients_CoveragePlanFullyResponsibleOverrideClients_FK
    FOREIGN KEY (ClientId)
    REFERENCES Clients(ClientId) 
            
     PRINT 'STEP 4(C) COMPLETED'
 END

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CoveragePlanFullyResponsibleOverrideProviderSites')
BEGIN
/*  
  TABLE: CoveragePlanFullyResponsibleOverrideProviderSites 
 */
 CREATE TABLE CoveragePlanFullyResponsibleOverrideProviderSites( 
		CoveragePlanFullyResponsibleOverrideProviderSiteId	int	identity(1,1)		NOT NULL,
		CreatedBy											type_CurrentUser		NOT NULL,
		CreatedDate											type_Currentdatetime	NOT NULL,
		ModifiedBy											type_CurrentUser		NOT NULL,
		ModifiedDate										type_Currentdatetime	NOT NULL,
		RecordDeleted										type_YOrN				NULL
															CHECK (RecordDeleted in ('Y','N')),
		DeletedBy											type_UserId				NULL,	
		DeletedDate											datetime				NULL,
		CoveragePlanFullyResponsibleOverrideId				int						NOT NULL, 
		ProviderId											int						NULL,
		SiteId												int						NULL,
		CONSTRAINT CoveragePlanFullyResponsibleOverrideProviderSites_PK PRIMARY KEY CLUSTERED (CoveragePlanFullyResponsibleOverrideProviderSiteId)
 )
 
  IF OBJECT_ID('CoveragePlanFullyResponsibleOverrideProviderSites') IS NOT NULL
    PRINT '<<< CREATED TABLE CoveragePlanFullyResponsibleOverrideProviderSites >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CoveragePlanFullyResponsibleOverrideProviderSites >>>', 16, 1)
    
 IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CoveragePlanFullyResponsibleOverrideProviderSites]') AND name = N'XIE1_CoveragePlanFullyResponsibleOverrideProviderSites')
		BEGIN
			CREATE NONCLUSTERED INDEX [XIE1_CoveragePlanFullyResponsibleOverrideProviderSites] ON [dbo].[CoveragePlanFullyResponsibleOverrideProviderSites] 
			(
			CoveragePlanFullyResponsibleOverrideId  ASC
			)
			WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
			IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CoveragePlanFullyResponsibleOverrideProviderSites') AND name='XIE1_CoveragePlanFullyResponsibleOverrideProviderSites')
			PRINT '<<< CREATED INDEX CoveragePlanFullyResponsibleOverrideProviderSites.XIE1_CoveragePlanFullyResponsibleOverrideProviderSites >>>'
			ELSE
			RAISERROR('<<< FAILED CREATING INDEX CoveragePlanFullyResponsibleOverrideProviderSites.XIE1_CoveragePlanFullyResponsibleOverrideProviderSites >>>', 16, 1)		
		END     
		
 IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CoveragePlanFullyResponsibleOverrideProviderSites]') AND name = N'XIE2_CoveragePlanFullyResponsibleOverrideProviderSites')
		BEGIN
			CREATE NONCLUSTERED INDEX [XIE2_CoveragePlanFullyResponsibleOverrideProviderSites] ON [dbo].[CoveragePlanFullyResponsibleOverrideProviderSites] 
			(
			ProviderId  ASC
			)
			WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
			IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CoveragePlanFullyResponsibleOverrideProviderSites') AND name='XIE2_CoveragePlanFullyResponsibleOverrideProviderSites')
			PRINT '<<< CREATED INDEX CoveragePlanFullyResponsibleOverrideProviderSites.XIE2_CoveragePlanFullyResponsibleOverrideProviderSites >>>'
			ELSE
			RAISERROR('<<< FAILED CREATING INDEX CoveragePlanFullyResponsibleOverrideProviderSites.XIE2_CoveragePlanFullyResponsibleOverrideProviderSites >>>', 16, 1)		
		END 
		
 IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CoveragePlanFullyResponsibleOverrideProviderSites]') AND name = N'XIE3_CoveragePlanFullyResponsibleOverrideProviderSites')
		BEGIN
			CREATE NONCLUSTERED INDEX [XIE3_CoveragePlanFullyResponsibleOverrideProviderSites] ON [dbo].[CoveragePlanFullyResponsibleOverrideProviderSites] 
			(
			SiteId  ASC
			)
			WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
			IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CoveragePlanFullyResponsibleOverrideProviderSites') AND name='XIE3_CoveragePlanFullyResponsibleOverrideProviderSites')
			PRINT '<<< CREATED INDEX CoveragePlanFullyResponsibleOverrideProviderSites.XIE3_CoveragePlanFullyResponsibleOverrideProviderSites >>>'
			ELSE
			RAISERROR('<<< FAILED CREATING INDEX CoveragePlanFullyResponsibleOverrideProviderSites.XIE3_CoveragePlanFullyResponsibleOverrideProviderSites >>>', 16, 1)		
		END     
    
/* 
 * TABLE: CoveragePlanFullyResponsibleOverrideProviderSites 
 */
 
 ALTER TABLE CoveragePlanFullyResponsibleOverrideProviderSites ADD CONSTRAINT CoveragePlanFullyResponsibleOverrides_CoveragePlanFullyResponsibleOverrideProviderSites_FK
    FOREIGN KEY (CoveragePlanFullyResponsibleOverrideId)
    REFERENCES CoveragePlanFullyResponsibleOverrides(CoveragePlanFullyResponsibleOverrideId) 
    
 ALTER TABLE CoveragePlanFullyResponsibleOverrideProviderSites ADD CONSTRAINT Providers_CoveragePlanFullyResponsibleOverrideProviderSites_FK
    FOREIGN KEY (ProviderId)
    REFERENCES Providers(ProviderId) 
    
  ALTER TABLE CoveragePlanFullyResponsibleOverrideProviderSites ADD CONSTRAINT Sites_CoveragePlanFullyResponsibleOverrideProviderSites_FK
    FOREIGN KEY (SiteId)
    REFERENCES Sites(SiteId) 
            
     PRINT 'STEP 4(D) COMPLETED'
 END
  
 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CoveragePlanFullyResponsibleOverrideBillingCodes')
BEGIN
/*  
  TABLE: CoveragePlanFullyResponsibleOverrideBillingCodes 
 */
 CREATE TABLE CoveragePlanFullyResponsibleOverrideBillingCodes( 
		CoveragePlanFullyResponsibleOverrideBillingCodeId	int	identity(1,1)		NOT NULL,
		CreatedBy											type_CurrentUser		NOT NULL,
		CreatedDate											type_Currentdatetime	NOT NULL,
		ModifiedBy											type_CurrentUser		NOT NULL,
		ModifiedDate										type_Currentdatetime	NOT NULL,
		RecordDeleted										type_YOrN				NULL
															CHECK (RecordDeleted in ('Y','N')),
		DeletedBy											type_UserId				NULL,	
		DeletedDate											datetime				NULL,
		CoveragePlanFullyResponsibleOverrideId				int						NOT NULL, 
		BillingCodeModifierId								int						NULL,
		ApplyToAllModifiers									type_YOrN				NULL
															CHECK (ApplyToAllModifiers in ('Y','N')),
		CONSTRAINT CoveragePlanFullyResponsibleOverrideBillingCodes_PK PRIMARY KEY CLUSTERED (CoveragePlanFullyResponsibleOverrideBillingCodeId)
 )
 
  IF OBJECT_ID('CoveragePlanFullyResponsibleOverrideBillingCodes') IS NOT NULL
    PRINT '<<< CREATED TABLE CoveragePlanFullyResponsibleOverrideBillingCodes >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CoveragePlanFullyResponsibleOverrideBillingCodes >>>', 16, 1)
    
 IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CoveragePlanFullyResponsibleOverrideBillingCodes]') AND name = N'XIE1_CoveragePlanFullyResponsibleOverrideBillingCodes')
		BEGIN
			CREATE NONCLUSTERED INDEX [XIE1_CoveragePlanFullyResponsibleOverrideBillingCodes] ON [dbo].[CoveragePlanFullyResponsibleOverrideBillingCodes] 
			(
			CoveragePlanFullyResponsibleOverrideId  ASC
			)
			WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
			IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CoveragePlanFullyResponsibleOverrideBillingCodes') AND name='XIE1_CoveragePlanFullyResponsibleOverrideBillingCodes')
			PRINT '<<< CREATED INDEX CoveragePlanFullyResponsibleOverrideBillingCodes.XIE1_CoveragePlanFullyResponsibleOverrideBillingCodes >>>'
			ELSE
			RAISERROR('<<< FAILED CREATING INDEX CoveragePlanFullyResponsibleOverrideBillingCodes.XIE1_CoveragePlanFullyResponsibleOverrideBillingCodes >>>', 16, 1)		
		END     
		
 IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CoveragePlanFullyResponsibleOverrideBillingCodes]') AND name = N'XIE2_CoveragePlanFullyResponsibleOverrideBillingCodes')
		BEGIN
			CREATE NONCLUSTERED INDEX [XIE2_CoveragePlanFullyResponsibleOverrideBillingCodes] ON [dbo].[CoveragePlanFullyResponsibleOverrideBillingCodes] 
			(
			BillingCodeModifierId  ASC
			)
			WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
			IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CoveragePlanFullyResponsibleOverrideBillingCodes') AND name='XIE2_CoveragePlanFullyResponsibleOverrideBillingCodes')
			PRINT '<<< CREATED INDEX CoveragePlanFullyResponsibleOverrideBillingCodes.XIE2_CoveragePlanFullyResponsibleOverrideBillingCodes >>>'
			ELSE
			RAISERROR('<<< FAILED CREATING INDEX CoveragePlanFullyResponsibleOverrideBillingCodes.XIE2_CoveragePlanFullyResponsibleOverrideBillingCodes >>>', 16, 1)		
		END  
    
/* 
 * TABLE: CoveragePlanFullyResponsibleOverrideBillingCodes 
 */
 
 ALTER TABLE CoveragePlanFullyResponsibleOverrideBillingCodes ADD CONSTRAINT CoveragePlanFullyResponsibleOverrides_CoveragePlanFullyResponsibleOverrideBillingCodes_FK
    FOREIGN KEY (CoveragePlanFullyResponsibleOverrideId)
    REFERENCES CoveragePlanFullyResponsibleOverrides(CoveragePlanFullyResponsibleOverrideId) 
    
 ALTER TABLE CoveragePlanFullyResponsibleOverrideBillingCodes ADD CONSTRAINT BillingCodeModifiers_CCoveragePlanFullyResponsibleOverrideBillingCodes_FK
    FOREIGN KEY (BillingCodeModifierId)
    REFERENCES BillingCodeModifiers(BillingCodeModifierId) 
            
     PRINT 'STEP 4(E) COMPLETED'
 END
 
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CoveragePlanFullyResponsibleOverridePlaceOfServices')
BEGIN
/*  
  TABLE: CoveragePlanFullyResponsibleOverridePlaceOfServices 
 */
 CREATE TABLE CoveragePlanFullyResponsibleOverridePlaceOfServices( 
		CoveragePlanFullyResponsibleOverridePlaceOfServiceId	int	identity(1,1)		NOT NULL,
		CreatedBy												type_CurrentUser		NOT NULL,
		CreatedDate												type_Currentdatetime	NOT NULL,
		ModifiedBy												type_CurrentUser		NOT NULL,
		ModifiedDate											type_Currentdatetime	NOT NULL,
		RecordDeleted											type_YOrN				NULL
																CHECK (RecordDeleted in ('Y','N')),
		DeletedBy												type_UserId				NULL,	
		DeletedDate												datetime				NULL,
		CoveragePlanFullyResponsibleOverrideId					int						NOT NULL, 
		PlaceOfService											type_GlobalCode			NULL,
		CONSTRAINT CoveragePlanFullyResponsibleOverridePlaceOfServices_PK PRIMARY KEY CLUSTERED (CoveragePlanFullyResponsibleOverridePlaceOfServiceId)
 )
 
  IF OBJECT_ID('CoveragePlanFullyResponsibleOverridePlaceOfServices') IS NOT NULL
    PRINT '<<< CREATED TABLE CoveragePlanFullyResponsibleOverridePlaceOfServices >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CoveragePlanFullyResponsibleOverridePlaceOfServices >>>', 16, 1)
    
 IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CoveragePlanFullyResponsibleOverridePlaceOfServices]') AND name = N'XIE1_CoveragePlanFullyResponsibleOverridePlaceOfServices')
		BEGIN
			CREATE NONCLUSTERED INDEX [XIE1_CoveragePlanFullyResponsibleOverridePlaceOfServices] ON [dbo].[CoveragePlanFullyResponsibleOverridePlaceOfServices] 
			(
			CoveragePlanFullyResponsibleOverrideId  ASC
			)
			WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
			IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CoveragePlanFullyResponsibleOverridePlaceOfServices') AND name='XIE1_CoveragePlanFullyResponsibleOverridePlaceOfServices')
			PRINT '<<< CREATED INDEX CoveragePlanFullyResponsibleOverridePlaceOfServices.XIE1_CoveragePlanFullyResponsibleOverridePlaceOfServices >>>'
			ELSE
			RAISERROR('<<< FAILED CREATING INDEX CoveragePlanFullyResponsibleOverridePlaceOfServices.XIE1_CoveragePlanFullyResponsibleOverridePlaceOfServices >>>', 16, 1)		
		END     
		    
/* 
 * TABLE: CoveragePlanFullyResponsibleOverridePlaceOfServices 
 */
 
 ALTER TABLE CoveragePlanFullyResponsibleOverridePlaceOfServices ADD CONSTRAINT CoveragePlanFullyResponsibleOverrides_CoveragePlanFullyResponsibleOverridePlaceOfServices_FK
    FOREIGN KEY (CoveragePlanFullyResponsibleOverrideId)
    REFERENCES CoveragePlanFullyResponsibleOverrides(CoveragePlanFullyResponsibleOverrideId) 
    
            
     PRINT 'STEP 4(F) COMPLETED'
 END
  
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CoveragePlanFullyResponsibleOverrideDiagnosisCodeCategories')
BEGIN
/*  
  TABLE: CoveragePlanFullyResponsibleOverrideDiagnosisCodeCategories 
 */
 CREATE TABLE CoveragePlanFullyResponsibleOverrideDiagnosisCodeCategories( 
		CoveragePlanFullyResponsibleOverrideDiagnosisCodeCategoryId	int	identity(1,1)		NOT NULL,
		CreatedBy													type_CurrentUser		NOT NULL,
		CreatedDate													type_Currentdatetime	NOT NULL,
		ModifiedBy													type_CurrentUser		NOT NULL,
		ModifiedDate												type_Currentdatetime	NOT NULL,
		RecordDeleted												type_YOrN				NULL
																	CHECK (RecordDeleted in ('Y','N')),
		DeletedBy													type_UserId				NULL,	
		DeletedDate													datetime				NULL,
		CoveragePlanFullyResponsibleOverrideId						int						NOT NULL, 
		DiagnosisDSMVCodeCategoryId									int						NULL,
		CONSTRAINT CoveragePlanFullyResponsibleOverrideDiagnosisCodeCategories_PK PRIMARY KEY CLUSTERED (CoveragePlanFullyResponsibleOverrideDiagnosisCodeCategoryId)
 )
 
  IF OBJECT_ID('CoveragePlanFullyResponsibleOverrideDiagnosisCodeCategories') IS NOT NULL
    PRINT '<<< CREATED TABLE CoveragePlanFullyResponsibleOverrideDiagnosisCodeCategories >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CoveragePlanFullyResponsibleOverrideDiagnosisCodeCategories >>>', 16, 1)
    
 IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CoveragePlanFullyResponsibleOverrideDiagnosisCodeCategories]') AND name = N'XIE1_CoveragePlanFullyResponsibleOverrideDiagnosisCodeCategories')
		BEGIN
			CREATE NONCLUSTERED INDEX [XIE1_CoveragePlanFullyResponsibleOverrideDiagnosisCodeCategories] ON [dbo].[CoveragePlanFullyResponsibleOverrideDiagnosisCodeCategories] 
			(
			CoveragePlanFullyResponsibleOverrideId  ASC
			)
			WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
			IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CoveragePlanFullyResponsibleOverrideDiagnosisCodeCategories') AND name='XIE1_CoveragePlanFullyResponsibleOverrideDiagnosisCodeCategories')
			PRINT '<<< CREATED INDEX CoveragePlanFullyResponsibleOverrideDiagnosisCodeCategories.XIE1_CoveragePlanFullyResponsibleOverrideDiagnosisCodeCategories >>>'
			ELSE
			RAISERROR('<<< FAILED CREATING INDEX CoveragePlanFullyResponsibleOverrideDiagnosisCodeCategories.XIE1_CoveragePlanFullyResponsibleOverrideDiagnosisCodeCategories >>>', 16, 1)		
		END 
		
 IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CoveragePlanFullyResponsibleOverrideDiagnosisCodeCategories]') AND name = N'XIE2_CoveragePlanFullyResponsibleOverrideDiagnosisCodeCategories')
		BEGIN
			CREATE NONCLUSTERED INDEX [XIE2_CoveragePlanFullyResponsibleOverrideDiagnosisCodeCategories] ON [dbo].[CoveragePlanFullyResponsibleOverrideDiagnosisCodeCategories] 
			(
			DiagnosisDSMVCodeCategoryId  ASC
			)
			WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
			IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CoveragePlanFullyResponsibleOverrideDiagnosisCodeCategories') AND name='XIE2_CoveragePlanFullyResponsibleOverrideDiagnosisCodeCategories')
			PRINT '<<< CREATED INDEX CoveragePlanFullyResponsibleOverrideDiagnosisCodeCategories.XIE2_CoveragePlanFullyResponsibleOverrideDiagnosisCodeCategories >>>'
			ELSE
			RAISERROR('<<< FAILED CREATING INDEX CoveragePlanFullyResponsibleOverrideDiagnosisCodeCategories.XIE2_CoveragePlanFullyResponsibleOverrideDiagnosisCodeCategories >>>', 16, 1)		
		END     
		        
		    
/* 
 * TABLE: CoveragePlanFullyResponsibleOverrideDiagnosisCodeCategories 
 */
 
 ALTER TABLE CoveragePlanFullyResponsibleOverrideDiagnosisCodeCategories ADD CONSTRAINT CoveragePlanFullyResponsibleOverrides_CoveragePlanFullyResponsibleOverrideDiagnosisCodeCategories_FK
    FOREIGN KEY (CoveragePlanFullyResponsibleOverrideId)
    REFERENCES CoveragePlanFullyResponsibleOverrides(CoveragePlanFullyResponsibleOverrideId) 
    
 
 ALTER TABLE CoveragePlanFullyResponsibleOverrideDiagnosisCodeCategories ADD CONSTRAINT DiagnosisDSMVCodeCategories_CoveragePlanFullyResponsibleOverrideDiagnosisCodeCategories_FK
    FOREIGN KEY (DiagnosisDSMVCodeCategoryId)
    REFERENCES DiagnosisDSMVCodeCategories(DiagnosisDSMVCodeCategoryId) 
    
            
     PRINT 'STEP 4(G) COMPLETED'
 END
  
 
----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 18.04)
BEGIN
Update SystemConfigurations set DataModelVersion=18.05
PRINT 'STEP 7 COMPLETED'
END
Go

