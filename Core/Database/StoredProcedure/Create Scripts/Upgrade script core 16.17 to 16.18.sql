----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 16.17)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 16.17 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
--Part1 Begin
--Part1 Ends

--Part2 Begins


--Part2 Ends
-----End of Step 2 -------

------ STEP 3 ------------

------ END OF STEP 3 -----

------ STEP 4 ----------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CoveragePlanClaimBudgets')
BEGIN
/* 
 * TABLE: CoveragePlanClaimBudgets 
 */
 CREATE TABLE CoveragePlanClaimBudgets( 
		CoveragePlanClaimBudgetId			int	identity(1,1)	 NOT NULL,
		CreatedBy							type_CurrentUser     NOT NULL,
		CreatedDate							type_CurrentDatetime NOT NULL,
		ModifiedBy							type_CurrentUser     NOT NULL,
		ModifiedDate						type_CurrentDatetime NOT NULL,
		RecordDeleted						type_YOrN			 NULL
											CHECK (RecordDeleted in ('Y','N')),
		DeletedBy							type_UserId          NULL,
		DeletedDate							datetime             NULL,
		CoveragePlanId						int					 NOT NULL,
		BudgetName							varchar(100)		 NOT NULL,
		StartDate							date				 NOT NULL,
		EndDate								date				 NOT NULL,
		Active								type_YOrN			 NULL
											CHECK (Active in ('Y','N')),
		BudgetAmount						money				 NULL,
		PaidAmount							money				 NULL,
		CascadeToNextPlanWhenOverBudget		type_YOrN			 NULL
											CHECK (CascadeToNextPlanWhenOverBudget in ('Y','N')),
		InsurerGroupName					varchar(250)		 NULL,
		ProviderSiteGroupName				varchar(250)		 NULL,
		BillingCodeGroupName				varchar(250)		 NULL,
	CONSTRAINT CoveragePlanClaimBudgets_PK PRIMARY KEY CLUSTERED (CoveragePlanClaimBudgetId asc) 
 )
 
  IF OBJECT_ID('CoveragePlanClaimBudgets') IS NOT NULL
    PRINT '<<< CREATED TABLE CoveragePlanClaimBudgets >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CoveragePlanClaimBudgets >>>', 16, 1)
/* 
 * TABLE: CoveragePlanClaimBudgets 
 */   
 
 IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CoveragePlanClaimBudgets]') AND name = N'XIE1_CoveragePlanClaimBudgets')
	BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_CoveragePlanClaimBudgets] ON [dbo].[CoveragePlanClaimBudgets] 
		(
		[CoveragePlanId] asc
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CoveragePlanClaimBudgets') AND name='XIE1_CoveragePlanClaimBudgets')
		PRINT '<<< CREATED INDEX CoveragePlanClaimBudgets.XIE1_CoveragePlanClaimBudgets >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX CoveragePlanClaimBudgets.XIE1_CoveragePlanClaimBudgets >>>', 16, 1)		
	END

    
ALTER TABLE CoveragePlanClaimBudgets ADD CONSTRAINT CoveragePlans_CoveragePlanClaimBudgets_FK
    FOREIGN KEY (CoveragePlanId)
    REFERENCES CoveragePlans(CoveragePlanId)

        
     PRINT 'STEP 4(A) COMPLETED'
 END
 
 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CoveragePlanClaimBudgetInsurers')
BEGIN
/* 
 * TABLE: CoveragePlanClaimBudgetInsurers 
 */
 CREATE TABLE CoveragePlanClaimBudgetInsurers( 
		CoveragePlanClaimBudgetInsurerId		int identity(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		CoveragePlanClaimBudgetId				int					 NOT NULL,
        InsurerId								int					 NOT NULL,																																																																																																			
		CONSTRAINT CoveragePlanClaimBudgetInsurers_PK PRIMARY KEY CLUSTERED (CoveragePlanClaimBudgetInsurerId asc) 
 )
 
  IF OBJECT_ID('CoveragePlanClaimBudgetInsurers') IS NOT NULL
    PRINT '<<< CREATED TABLE CoveragePlanClaimBudgetInsurers >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CoveragePlanClaimBudgetInsurers >>>', 16, 1)
/* 
 * TABLE: CoveragePlanClaimBudgetInsurers 
 */ 
 
 
 IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CoveragePlanClaimBudgetInsurers]') AND name = N'XIE1_CoveragePlanClaimBudgetInsurers')
	BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_CoveragePlanClaimBudgetInsurers] ON [dbo].[CoveragePlanClaimBudgetInsurers] 
		(
		CoveragePlanClaimBudgetId asc
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CoveragePlanClaimBudgetInsurers') AND name='XIE1_CoveragePlanClaimBudgetInsurers')
		PRINT '<<< CREATED INDEX CoveragePlanClaimBudgetInsurers.XIE1_CoveragePlanClaimBudgetInsurers >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX CoveragePlanClaimBudgetInsurers.XIE1_CoveragePlanClaimBudgetInsurers >>>', 16, 1)		
	END  
	
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CoveragePlanClaimBudgetInsurers]') AND name = N'XIE2_CoveragePlanClaimBudgetInsurers')
	BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_CoveragePlanClaimBudgetInsurers] ON [dbo].[CoveragePlanClaimBudgetInsurers] 
		(
		InsurerId asc
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CoveragePlanClaimBudgetInsurers') AND name='XIE2_CoveragePlanClaimBudgetInsurers')
		PRINT '<<< CREATED INDEX CoveragePlanClaimBudgetInsurers.XIE2_CoveragePlanClaimBudgetInsurers >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX CoveragePlanClaimBudgetInsurers.XIE2_CoveragePlanClaimBudgetInsurers >>>', 16, 1)		
	END  

    
ALTER TABLE CoveragePlanClaimBudgetInsurers ADD CONSTRAINT CoveragePlanClaimBudgets_CoveragePlanClaimBudgetInsurers_FK
    FOREIGN KEY (CoveragePlanClaimBudgetId)
    REFERENCES CoveragePlanClaimBudgets(CoveragePlanClaimBudgetId)  
    
ALTER TABLE CoveragePlanClaimBudgetInsurers ADD CONSTRAINT Insurers_CoveragePlanClaimBudgetInsurers_FK
    FOREIGN KEY (InsurerId)
    REFERENCES Insurers(InsurerId)  
        
     PRINT 'STEP 4(B) COMPLETED'
 END

 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CoveragePlanClaimBudgetProviderSites')
BEGIN
/* 
 * TABLE: CoveragePlanClaimBudgetProviderSites 
 */
 CREATE TABLE CoveragePlanClaimBudgetProviderSites( 
		CoveragePlanClaimBudgetProviderSiteId	int identity(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		CoveragePlanClaimBudgetId				int					 NOT NULL,
        ProviderId								int					 NULL,
        SiteId									int			   		 NULL,																																																																																																		
		CONSTRAINT CoveragePlanClaimBudgetProviderSites_PK PRIMARY KEY CLUSTERED (CoveragePlanClaimBudgetProviderSiteId asc) 
 )
 
  IF OBJECT_ID('CoveragePlanClaimBudgetProviderSites') IS NOT NULL
    PRINT '<<< CREATED TABLE CoveragePlanClaimBudgetProviderSites >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CoveragePlanClaimBudgetProviderSites >>>', 16, 1)
/* 
 * TABLE: CoveragePlanClaimBudgetProviderSites 
 */  
  
	
 IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CoveragePlanClaimBudgetProviderSites]') AND name = N'XIE1_CoveragePlanClaimBudgetProviderSites')
	BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_CoveragePlanClaimBudgetProviderSites] ON [dbo].[CoveragePlanClaimBudgetProviderSites] 
		(
		CoveragePlanClaimBudgetId asc
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CoveragePlanClaimBudgetProviderSites') AND name='XIE1_CoveragePlanClaimBudgetProviderSites')
		PRINT '<<< CREATED INDEX CoveragePlanClaimBudgetProviderSites.XIE1_CoveragePlanClaimBudgetProviderSites >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX CoveragePlanClaimBudgetProviderSites.XIE1_CoveragePlanClaimBudgetProviderSites >>>', 16, 1)		
	END   
	
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CoveragePlanClaimBudgetProviderSites]') AND name = N'XIE2_CoveragePlanClaimBudgetProviderSites')
	BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_CoveragePlanClaimBudgetProviderSites] ON [dbo].[CoveragePlanClaimBudgetProviderSites] 
		(
		ProviderId asc
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CoveragePlanClaimBudgetProviderSites') AND name='XIE2_CoveragePlanClaimBudgetProviderSites')
		PRINT '<<< CREATED INDEX CoveragePlanClaimBudgetProviderSites.XIE2_CoveragePlanClaimBudgetProviderSites >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX CoveragePlanClaimBudgetProviderSites.XIE2_CoveragePlanClaimBudgetProviderSites >>>', 16, 1)		
	END  
	
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CoveragePlanClaimBudgetProviderSites]') AND name = N'XIE3_CoveragePlanClaimBudgetProviderSites')
	BEGIN
		CREATE NONCLUSTERED INDEX [XIE3_CoveragePlanClaimBudgetProviderSites] ON [dbo].[CoveragePlanClaimBudgetProviderSites] 
		(
		SiteId asc
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CoveragePlanClaimBudgetProviderSites') AND name='XIE3_CoveragePlanClaimBudgetProviderSites')
		PRINT '<<< CREATED INDEX CoveragePlanClaimBudgetProviderSites.XIE3_CoveragePlanClaimBudgetProviderSites >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX CoveragePlanClaimBudgetProviderSites.XIE3_CoveragePlanClaimBudgetProviderSites >>>', 16, 1)		
	END  

    
ALTER TABLE CoveragePlanClaimBudgetProviderSites ADD CONSTRAINT CoveragePlanClaimBudgets_CoveragePlanClaimBudgetProviderSites_FK
    FOREIGN KEY (CoveragePlanClaimBudgetId)
    REFERENCES CoveragePlanClaimBudgets(CoveragePlanClaimBudgetId)  
 
 ALTER TABLE CoveragePlanClaimBudgetProviderSites ADD CONSTRAINT Providers_CoveragePlanClaimBudgetProviderSites_FK
    FOREIGN KEY (ProviderId)
    REFERENCES Providers(ProviderId)
    
 ALTER TABLE CoveragePlanClaimBudgetProviderSites ADD CONSTRAINT Sites_CoveragePlanClaimBudgetProviderSites_FK
    FOREIGN KEY (SiteId)
    REFERENCES Sites(SiteId)  
                           
     PRINT 'STEP 4(C) COMPLETED'
 END
 
 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CoveragePlanClaimBudgetBillingCodes')
BEGIN
/* 
 * TABLE: CoveragePlanClaimBudgetBillingCodes 
 */
 CREATE TABLE CoveragePlanClaimBudgetBillingCodes( 
		CoveragePlanClaimBudgetBillingCodeId	int identity(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		CoveragePlanClaimBudgetId               int					 NOT NULL,
		BillingCodeModifierId                   int 				 NOT NULL,
		ApplyToAllModifiers						type_YOrN			 NULL
												CHECK (ApplyToAllModifiers in ('Y','N')),
		CONSTRAINT CoveragePlanClaimBudgetBillingCodes_PK PRIMARY KEY CLUSTERED (CoveragePlanClaimBudgetBillingCodeId asc)
)
IF OBJECT_ID('CoveragePlanClaimBudgetBillingCodes') IS NOT NULL
    PRINT '<<< CREATED TABLE CoveragePlanClaimBudgetBillingCodes >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CoveragePlanClaimBudgetBillingCodes >>>', 16, 1)

 IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CoveragePlanClaimBudgetBillingCodes]') AND name = N'XIE1_CoveragePlanClaimBudgetBillingCodes')
	BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_CoveragePlanClaimBudgetBillingCodes] ON [dbo].[CoveragePlanClaimBudgetBillingCodes] 
		(
		CoveragePlanClaimBudgetId asc
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CoveragePlanClaimBudgetBillingCodes') AND name='XIE1_CoveragePlanClaimBudgetBillingCodes')
		PRINT '<<< CREATED INDEX CoveragePlanClaimBudgetBillingCodes.XIE1_CoveragePlanClaimBudgetBillingCodes >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX CoveragePlanClaimBudgetBillingCodes.XIE1_CoveragePlanClaimBudgetBillingCodes >>>', 16, 1)		
	END 
	
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CoveragePlanClaimBudgetBillingCodes]') AND name = N'XIE2_CoveragePlanClaimBudgetBillingCodes')
	BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_CoveragePlanClaimBudgetBillingCodes] ON [dbo].[CoveragePlanClaimBudgetBillingCodes] 
		(
		BillingCodeModifierId asc
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CoveragePlanClaimBudgetBillingCodes') AND name='XIE2_CoveragePlanClaimBudgetBillingCodes')
		PRINT '<<< CREATED INDEX CoveragePlanClaimBudgetBillingCodes.XIE2_CoveragePlanClaimBudgetBillingCodes >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX CoveragePlanClaimBudgetBillingCodes.XIE2_CoveragePlanClaimBudgetBillingCodes >>>', 16, 1)		
	END    
	
 /* 
 * TABLE: CoveragePlanClaimBudgetBillingCodes 
 */   
    
ALTER TABLE CoveragePlanClaimBudgetBillingCodes ADD CONSTRAINT CoveragePlanClaimBudgets_CoveragePlanClaimBudgetBillingCodes_FK
    FOREIGN KEY (CoveragePlanClaimBudgetId)
    REFERENCES CoveragePlanClaimBudgets(CoveragePlanClaimBudgetId)
    
ALTER TABLE CoveragePlanClaimBudgetBillingCodes ADD CONSTRAINT BillingCodeModifiers_CoveragePlanClaimBudgetBillingCodes_FK
    FOREIGN KEY (BillingCodeModifierId)
    REFERENCES BillingCodeModifiers(BillingCodeModifierId)
    
 PRINT 'STEP 4(D) COMPLETED' 
END
 
 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CoveragePlanClaimBudgetClients')
BEGIN
/* 
 * TABLE: CoveragePlanClaimBudgetClients 
 */
 CREATE TABLE CoveragePlanClaimBudgetClients( 
		CoveragePlanClaimBudgetClientId			int identity(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		CoveragePlanClaimBudgetId               int					 NOT NULL,
		ClientId			                    int 				 NOT NULL,
		CONSTRAINT CoveragePlanClaimBudgetClients_PK PRIMARY KEY CLUSTERED (CoveragePlanClaimBudgetClientId asc)
)
IF OBJECT_ID('CoveragePlanClaimBudgetClients') IS NOT NULL
    PRINT '<<< CREATED TABLE CoveragePlanClaimBudgetClients >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CoveragePlanClaimBudgetClients >>>', 16, 1)
    
  IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CoveragePlanClaimBudgetClients]') AND name = N'XIE1_CoveragePlanClaimBudgetClients')
	BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_CoveragePlanClaimBudgetClients] ON [dbo].[CoveragePlanClaimBudgetClients] 
		(
		CoveragePlanClaimBudgetId asc
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CoveragePlanClaimBudgetClients') AND name='XIE1_CoveragePlanClaimBudgetClients')
		PRINT '<<< CREATED INDEX CoveragePlanClaimBudgetClients.XIE1_CoveragePlanClaimBudgetClients >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX CoveragePlanClaimBudgetClients.XIE1_CoveragePlanClaimBudgetClients >>>', 16, 1)		
	END  
	
	IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CoveragePlanClaimBudgetClients]') AND name = N'XIE2_CoveragePlanClaimBudgetClients')
	BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_CoveragePlanClaimBudgetClients] ON [dbo].[CoveragePlanClaimBudgetClients] 
		(
		ClientId asc
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CoveragePlanClaimBudgetClients') AND name='XIE2_CoveragePlanClaimBudgetClients')
		PRINT '<<< CREATED INDEX CoveragePlanClaimBudgetClients.XIE2_CoveragePlanClaimBudgetClients >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX CoveragePlanClaimBudgetClients.XIE2_CoveragePlanClaimBudgetClients >>>', 16, 1)		
	END      
    
/* 
 * TABLE: CoveragePlanClaimBudgetClients 
 */   
    
ALTER TABLE CoveragePlanClaimBudgetClients ADD CONSTRAINT CoveragePlanClaimBudgets_CoveragePlanClaimBudgetClients_FK
    FOREIGN KEY (CoveragePlanClaimBudgetId)
    REFERENCES CoveragePlanClaimBudgets(CoveragePlanClaimBudgetId)
    
ALTER TABLE CoveragePlanClaimBudgetClients ADD CONSTRAINT Clients_CoveragePlanClaimBudgetClients_FK
    FOREIGN KEY (ClientId)
    REFERENCES Clients(ClientId)
    
 PRINT 'STEP 4(E) COMPLETED' 
END
 
 
  IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='ClaimLineCoveragePlanClaimBudgets')
BEGIN
/* 
 * TABLE: ClaimLineCoveragePlanClaimBudgets 
 */
 CREATE TABLE ClaimLineCoveragePlanClaimBudgets( 
		ClaimLineCoveragePlanClaimBudgetId		int identity(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		CoveragePlanClaimBudgetId               int 				 NULL,
		ClaimLineId								int					 NULL,
		PaidAmount								money				 NULL,
		CONSTRAINT ClaimLineCoveragePlanClaimBudgets_PK PRIMARY KEY CLUSTERED (ClaimLineCoveragePlanClaimBudgetId asc)
)
IF OBJECT_ID('ClaimLineCoveragePlanClaimBudgets') IS NOT NULL
    PRINT '<<< CREATED TABLE ClaimLineCoveragePlanClaimBudgets >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE ClaimLineCoveragePlanClaimBudgets >>>', 16, 1)
    
    IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ClaimLineCoveragePlanClaimBudgets]') AND name = N'XIE1_ClaimLineCoveragePlanClaimBudgets')
	BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_ClaimLineCoveragePlanClaimBudgets] ON [dbo].[ClaimLineCoveragePlanClaimBudgets] 
		(
		CoveragePlanClaimBudgetId asc
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ClaimLineCoveragePlanClaimBudgets') AND name='XIE1_ClaimLineCoveragePlanClaimBudgets')
		PRINT '<<< CREATED INDEX ClaimLineCoveragePlanClaimBudgets.XIE1_ClaimLineCoveragePlanClaimBudgets >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ClaimLineCoveragePlanClaimBudgets.XIE1_ClaimLineCoveragePlanClaimBudgets >>>', 16, 1)		
	END  
	
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ClaimLineCoveragePlanClaimBudgets]') AND name = N'XIE2_ClaimLineCoveragePlanClaimBudgets')
	BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_ClaimLineCoveragePlanClaimBudgets] ON [dbo].[ClaimLineCoveragePlanClaimBudgets] 
		(
		ClaimLineId asc
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ClaimLineCoveragePlanClaimBudgets') AND name='XIE2_ClaimLineCoveragePlanClaimBudgets')
		PRINT '<<< CREATED INDEX ClaimLineCoveragePlanClaimBudgets.XIE2_ClaimLineCoveragePlanClaimBudgets >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ClaimLineCoveragePlanClaimBudgets.XIE2_ClaimLineCoveragePlanClaimBudgets >>>', 16, 1)		
	END  
    
/* 
 * TABLE: ClaimLineCoveragePlanClaimBudgets 
 */   
    
ALTER TABLE ClaimLineCoveragePlanClaimBudgets ADD CONSTRAINT ClaimLines_ClaimLineCoveragePlanClaimBudgets_FK
    FOREIGN KEY (ClaimLineId)
    REFERENCES ClaimLines(ClaimLineId)
    
ALTER TABLE ClaimLineCoveragePlanClaimBudgets ADD CONSTRAINT CoveragePlanClaimBudgets_ClaimLineCoveragePlanClaimBudgets_FK
    FOREIGN KEY (CoveragePlanClaimBudgetId)
    REFERENCES CoveragePlanClaimBudgets(CoveragePlanClaimBudgetId)
    
 PRINT 'STEP 4(F) COMPLETED' 
END
  
 
  ---------------------------------------------------------------
--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 16.17)
BEGIN
Update SystemConfigurations set DataModelVersion=16.18
PRINT 'STEP 7 COMPLETED'
END
Go
