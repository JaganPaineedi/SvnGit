----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.97)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.97 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
-------------------------------------------------------------

------ STEP 3 ------------

IF OBJECT_ID('RWQMRules') IS NOT NULL
BEGIN
	 IF COL_LENGTH('RWQMRules','DefaultStaffId') IS NULL
	 BEGIN
		ALTER TABLE  RWQMRules  ADD DefaultStaffId int NULL
	 END
	 
	 IF COL_LENGTH('RWQMRules','ChargePayerType') IS NULL
	 BEGIN
		ALTER TABLE  RWQMRules  ADD ChargePayerType varchar(250) NULL
	 END
	 
	 IF COL_LENGTH('RWQMRules','AllChargePayerType') IS NULL
	 BEGIN
		ALTER TABLE  RWQMRules  ADD AllChargePayerType type_YOrN	 NULL
								CHECK (AllChargePayerType in ('Y','N')) 
	 END
	 
	 IF COL_LENGTH('RWQMRules','ChargePayer') IS NULL
	 BEGIN
		ALTER TABLE  RWQMRules  ADD ChargePayer varchar(250) NULL
	 END
	 
	 IF COL_LENGTH('RWQMRules','AllChargePayer') IS NULL
	 BEGIN
		ALTER TABLE  RWQMRules  ADD AllChargePayer type_YOrN	 NULL
								CHECK (AllChargePayer in ('Y','N')) 
	 END
	 
	 IF COL_LENGTH('RWQMRules','ChargePlan') IS NULL
	 BEGIN
		ALTER TABLE  RWQMRules  ADD ChargePlan varchar(250) NULL
	 END
	 
	 IF COL_LENGTH('RWQMRules','AllChargePlan') IS NULL
	 BEGIN
		ALTER TABLE  RWQMRules  ADD AllChargePlan type_YOrN	 NULL
								CHECK (AllChargePlan in ('Y','N')) 
	 END
	 
	  IF COL_LENGTH('RWQMRules','ChargeProgram') IS NULL
	 BEGIN
		ALTER TABLE  RWQMRules  ADD ChargeProgram varchar(250) NULL
	 END
	 
	 IF COL_LENGTH('RWQMRules','AllChargeProgram') IS NULL
	 BEGIN
		ALTER TABLE  RWQMRules  ADD AllChargeProgram type_YOrN	 NULL
								CHECK (AllChargeProgram in ('Y','N')) 
	 END
	 
	 IF COL_LENGTH('RWQMRules','ChargeLocation') IS NULL
	 BEGIN
		ALTER TABLE  RWQMRules  ADD ChargeLocation varchar(250) NULL 
	 END
	 
	 IF COL_LENGTH('RWQMRules','AllChargeLocation') IS NULL
	 BEGIN
		ALTER TABLE  RWQMRules  ADD AllChargeLocation type_YOrN	 NULL
								CHECK (AllChargeLocation in ('Y','N')) 
	 END
	 
	 IF COL_LENGTH('RWQMRules','ChargeServiceArea') IS NULL
	 BEGIN
		ALTER TABLE  RWQMRules  ADD ChargeServiceArea varchar(250) NULL
	 END
	 
	 IF COL_LENGTH('RWQMRules','AllChargeServiceArea') IS NULL
	 BEGIN
		ALTER TABLE  RWQMRules  ADD AllChargeServiceArea type_YOrN	 NULL
								CHECK (AllChargeServiceArea in ('Y','N')) 
	 END
	 
	 IF COL_LENGTH('RWQMRules','ChargeProcedureCode') IS NULL
	 BEGIN
		ALTER TABLE  RWQMRules  ADD ChargeProcedureCode varchar(250) NULL
	 END
	 
	 IF COL_LENGTH('RWQMRules','AllChargeProcedureCode') IS NULL
	 BEGIN
		ALTER TABLE  RWQMRules  ADD AllChargeProcedureCode type_YOrN	 NULL
								CHECK (AllChargeProcedureCode in ('Y','N')) 
	 END
	 
	 IF COL_LENGTH('RWQMRules','ChargeErrorReason') IS NULL
	 BEGIN
		ALTER TABLE  RWQMRules  ADD ChargeErrorReason varchar(250) NULL
	 END
	 
	 IF COL_LENGTH('RWQMRules','AllChargeErrorReason') IS NULL
	 BEGIN
		ALTER TABLE  RWQMRules  ADD AllChargeErrorReason type_YOrN	 NULL
								CHECK (AllChargeErrorReason in ('Y','N')) 
	 END
	 
	 IF COL_LENGTH('RWQMRules','ChargeAdjustmentCodes') IS NULL
	 BEGIN
		ALTER TABLE  RWQMRules  ADD ChargeAdjustmentCodes varchar(250) NULL
	 END
	 
	 IF COL_LENGTH('RWQMRules','AllChargeAdjustmentCodes') IS NULL
	 BEGIN
		ALTER TABLE  RWQMRules  ADD AllChargeAdjustmentCodes type_YOrN	 NULL
								CHECK (AllChargeAdjustmentCodes in ('Y','N')) 
	 END
	  
	 IF COL_LENGTH('RWQMRules','ChargeResponsibleDays') IS NULL
	 BEGIN
		ALTER TABLE  RWQMRules  ADD ChargeResponsibleDays type_GlobalCode	 NULL
	 END
	 
	 IF COL_LENGTH('RWQMRules','ClientFinancialResponsible') IS NULL
	 BEGIN
		ALTER TABLE  RWQMRules  ADD ClientFinancialResponsible char(1)	 NULL
								CHECK (ClientFinancialResponsible in ('C','F')) 
	
	EXEC sys.sp_addextendedproperty 'RWQMRules_Description'
	,'ClientFinancialResponsible column stores C,F. C = Client, F = Financial Responsible'
	,'schema'
	,'dbo'
	,'table'
	,'RWQMRules'
	,'column'
	,'ClientFinancialResponsible'						
	 END
	 
	 IF COL_LENGTH('RWQMRules','FinancialAssignmentChargeClientLastNameFrom') IS NULL
	 BEGIN
		ALTER TABLE  RWQMRules  ADD FinancialAssignmentChargeClientLastNameFrom varchar(25) NULL 
	 END
	 
	 IF COL_LENGTH('RWQMRules','FinancialAssignmentChargeClientLastNameTo') IS NULL
	 BEGIN
		ALTER TABLE  RWQMRules  ADD FinancialAssignmentChargeClientLastNameTo varchar(25)	 NULL
	 END
	 
	 IF COL_LENGTH('RWQMRules','IncludeClientCharge') IS NULL
	 BEGIN
		ALTER TABLE  RWQMRules  ADD IncludeClientCharge type_YOrN	 NULL
								CHECK (IncludeClientCharge in ('Y','N')) 
	 END
	 
	 IF COL_LENGTH('RWQMRules','ExcludePayerCharges') IS NULL
	 BEGIN
		ALTER TABLE  RWQMRules  ADD ExcludePayerCharges type_YOrN	 NULL
								CHECK (ExcludePayerCharges in ('Y','N')) 
	 END
	 
	 IF COL_LENGTH('RWQMRules','DefaultStaffId')IS NOT NULL
	 BEGIN
			IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Staff_RWQMRules_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[RWQMRules]'))
			BEGIN
				ALTER TABLE RWQMRules ADD CONSTRAINT Staff_RWQMRules_FK
				FOREIGN KEY (DefaultStaffId)
				REFERENCES Staff(StaffId) 
			END
	  END
	  
	  IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMRules') AND name='XIE1_RWQMRules')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_RWQMRules] ON [dbo].[RWQMRules] 
		(
		DefaultStaffId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMRules') AND name='XIE1_RWQMRules')
		PRINT '<<< CREATED INDEX RWQMRules.XIE1_RWQMRules >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX RWQMRules.XIE1_RWQMRules >>>', 16, 1)		
		END	
	 PRINT 'STEP 3 COMPLETED'
	 
END


--END Of STEP 3------------
------ STEP 4 ----------

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='RWQMRulePayerTypes')
BEGIN
/* 
 * TABLE: RWQMRulePayerTypes 
 */
 CREATE TABLE RWQMRulePayerTypes( 
		RWQMRulePayerTypeId						int identity(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,		
		RWQMRuleId								int					 NOT NULL,
		PayerTypeId								type_GlobalCode		 NULL,			
		CONSTRAINT RWQMRulePayerTypes_PK PRIMARY KEY CLUSTERED (RWQMRulePayerTypeId) 
 )
 
  IF OBJECT_ID('RWQMRulePayerTypes') IS NOT NULL
    PRINT '<<< CREATED TABLE RWQMRulePayerTypes >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE RWQMRulePayerTypes >>>', 16, 1)
    
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMRulePayerTypes') AND name='XIE1_RWQMRulePayerTypes')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_RWQMRulePayerTypes] ON [dbo].[RWQMRulePayerTypes] 
		(
		RWQMRuleId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMRulePayerTypes') AND name='XIE1_RWQMRulePayerTypes')
		PRINT '<<< CREATED INDEX RWQMRulePayerTypes.XIE1_RWQMRulePayerTypes >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX RWQMRulePayerTypes.XIE1_RWQMRulePayerTypes >>>', 16, 1)		
		END	    
    
/* 
 * TABLE: RWQMRulePayerTypes 
 */
 
 ALTER TABLE RWQMRulePayerTypes ADD CONSTRAINT RWQMRules_RWQMRulePayerTypes_FK
	FOREIGN KEY (RWQMRuleId)
	REFERENCES RWQMRules(RWQMRuleId)    
    
 PRINT 'STEP 4(A) COMPLETED'
 END
 
 
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='RWQMRulePayers')
BEGIN
/* 
 * TABLE: RWQMRulePayers 
 */
 CREATE TABLE RWQMRulePayers( 
		RWQMRulePayerId							int identity(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,		
		RWQMRuleId								int					 NOT NULL,
		PayerId									int					 NULL,
		CONSTRAINT RWQMRulePayers_PK PRIMARY KEY CLUSTERED (RWQMRulePayerId) 
 )
 
  IF OBJECT_ID('RWQMRulePayers') IS NOT NULL
    PRINT '<<< CREATED TABLE RWQMRulePayers >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE RWQMRulePayers >>>', 16, 1)
    
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMRulePayers') AND name='XIE1_RWQMRulePayers')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_RWQMRulePayers] ON [dbo].[RWQMRulePayers] 
		(
		RWQMRuleId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMRulePayers') AND name='XIE1_RWQMRulePayers')
		PRINT '<<< CREATED INDEX RWQMRulePayers.XIE1_RWQMRulePayers >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX RWQMRulePayers.XIE1_RWQMRulePayers >>>', 16, 1)		
		END	  
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMRulePayers') AND name='XIE2_RWQMRulePayers')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_RWQMRulePayers] ON [dbo].[RWQMRulePayers] 
		(
		PayerId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMRulePayers') AND name='XIE2_RWQMRulePayers')
		PRINT '<<< CREATED INDEX RWQMRulePayers.XIE2_RWQMRulePayers >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX RWQMRulePayers.XIE2_RWQMRulePayers >>>', 16, 1)		
		END	   
    
/* 
 * TABLE: RWQMRulePayers 
 */
 
 ALTER TABLE RWQMRulePayers ADD CONSTRAINT RWQMRules_RWQMRulePayers_FK
	FOREIGN KEY (RWQMRuleId)
	REFERENCES RWQMRules(RWQMRuleId)  
	
 ALTER TABLE RWQMRulePayers ADD CONSTRAINT Payers_RWQMRulePayers_FK
	FOREIGN KEY (PayerId)
	REFERENCES Payers(PayerId)   
    
 PRINT 'STEP 4(B) COMPLETED'
 END
 
 
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='RWQMRulePlans')
BEGIN
/* 
 * TABLE: RWQMRulePlans 
 */
 CREATE TABLE RWQMRulePlans( 
		RWQMRulePlanId							int identity(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,		
		RWQMRuleId								int					 NOT NULL,
		CoveragePlanId							int					 NULL,
		CONSTRAINT RWQMRulePlans_PK PRIMARY KEY CLUSTERED (RWQMRulePlanId) 
 )
 
  IF OBJECT_ID('RWQMRulePlans') IS NOT NULL
    PRINT '<<< CREATED TABLE RWQMRulePlans >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE RWQMRulePlans >>>', 16, 1)
    
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMRulePlans') AND name='XIE1_RWQMRulePlans')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_RWQMRulePlans] ON [dbo].[RWQMRulePlans] 
		(
		RWQMRuleId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMRulePlans') AND name='XIE1_RWQMRulePlans')
		PRINT '<<< CREATED INDEX RWQMRulePlans.XIE1_RWQMRulePlans >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX RWQMRulePlans.XIE1_RWQMRulePlans >>>', 16, 1)		
		END	  
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMRulePlans') AND name='XIE2_RWQMRulePlans')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_RWQMRulePlans] ON [dbo].[RWQMRulePlans] 
		(
		CoveragePlanId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMRulePlans') AND name='XIE2_RWQMRulePlans')
		PRINT '<<< CREATED INDEX RWQMRulePlans.XIE2_RWQMRulePlans >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX RWQMRulePlans.XIE2_RWQMRulePlans >>>', 16, 1)		
		END	   
    
/* 
 * TABLE: RWQMRulePlans 
 */
 
 ALTER TABLE RWQMRulePlans ADD CONSTRAINT RWQMRules_RWQMRulePlans_FK
	FOREIGN KEY (RWQMRuleId)
	REFERENCES RWQMRules(RWQMRuleId)  
	
 ALTER TABLE RWQMRulePlans ADD CONSTRAINT CoveragePlans_RWQMRulePlans_FK
	FOREIGN KEY (CoveragePlanId)
	REFERENCES CoveragePlans(CoveragePlanId)   
    
 PRINT 'STEP 4(C) COMPLETED'
 END
 
 
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='RWQMRulePrograms')
BEGIN
/* 
 * TABLE: RWQMRulePrograms 
 */
 CREATE TABLE RWQMRulePrograms( 
		RWQMRuleProgramId						int identity(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,		
		RWQMRuleId								int					 NOT NULL,
		ProgramId								int					 NULL,
		CONSTRAINT RWQMRulePrograms_PK PRIMARY KEY CLUSTERED (RWQMRuleProgramId) 
 )
 
  IF OBJECT_ID('RWQMRulePrograms') IS NOT NULL
    PRINT '<<< CREATED TABLE RWQMRulePrograms >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE RWQMRulePrograms >>>', 16, 1)
    
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMRulePrograms') AND name='XIE1_RWQMRulePrograms')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_RWQMRulePrograms] ON [dbo].[RWQMRulePrograms] 
		(
		RWQMRuleId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMRulePrograms') AND name='XIE1_RWQMRulePrograms')
		PRINT '<<< CREATED INDEX RWQMRulePrograms.XIE1_RWQMRulePrograms >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX RWQMRulePrograms.XIE1_RWQMRulePrograms >>>', 16, 1)		
		END	  
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMRulePrograms') AND name='XIE2_RWQMRulePrograms')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_RWQMRulePrograms] ON [dbo].[RWQMRulePrograms] 
		(
		ProgramId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMRulePrograms') AND name='XIE2_RWQMRulePrograms')
		PRINT '<<< CREATED INDEX RWQMRulePrograms.XIE2_RWQMRulePrograms >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX RWQMRulePrograms.XIE2_RWQMRulePrograms >>>', 16, 1)		
		END	   
    
/* 
 * TABLE: RWQMRulePrograms 
 */
 
 ALTER TABLE RWQMRulePrograms ADD CONSTRAINT RWQMRules_RWQMRulePrograms_FK
	FOREIGN KEY (RWQMRuleId)
	REFERENCES RWQMRules(RWQMRuleId)  
	
 ALTER TABLE RWQMRulePrograms ADD CONSTRAINT Programs_RWQMRulePrograms_FK
	FOREIGN KEY (ProgramId)
	REFERENCES Programs(ProgramId)   
    
 PRINT 'STEP 4(D) COMPLETED'
 END
 
 
  
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='RWQMRuleLocations')
BEGIN
/* 
 * TABLE: RWQMRuleLocations 
 */
 CREATE TABLE RWQMRuleLocations( 
		RWQMRuleLocationId						int identity(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,		
		RWQMRuleId								int					 NOT NULL,
		LocationId								int					 NULL,
		CONSTRAINT RWQMRuleLocations_PK PRIMARY KEY CLUSTERED (RWQMRuleLocationId) 
 )
 
  IF OBJECT_ID('RWQMRuleLocations') IS NOT NULL
    PRINT '<<< CREATED TABLE RWQMRuleLocations >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE RWQMRuleLocations >>>', 16, 1)
    
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMRuleLocations') AND name='XIE1_RWQMRuleLocations')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_RWQMRuleLocations] ON [dbo].[RWQMRuleLocations] 
		(
		RWQMRuleId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMRuleLocations') AND name='XIE1_RWQMRuleLocations')
		PRINT '<<< CREATED INDEX RWQMRuleLocations.XIE1_RWQMRuleLocations >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX RWQMRuleLocations.XIE1_RWQMRuleLocations >>>', 16, 1)		
		END	  
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMRuleLocations') AND name='XIE2_RWQMRuleLocations')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_RWQMRuleLocations] ON [dbo].[RWQMRuleLocations] 
		(
		LocationId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMRuleLocations') AND name='XIE2_RWQMRuleLocations')
		PRINT '<<< CREATED INDEX RWQMRuleLocations.XIE2_RWQMRuleLocations >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX RWQMRuleLocations.XIE2_RWQMRuleLocations >>>', 16, 1)		
		END	   
    
/* 
 * TABLE: RWQMRuleLocations 
 */
 
 ALTER TABLE RWQMRuleLocations ADD CONSTRAINT RWQMRules_RWQMRuleLocations_FK
	FOREIGN KEY (RWQMRuleId)
	REFERENCES RWQMRules(RWQMRuleId)  
	
 ALTER TABLE RWQMRuleLocations ADD CONSTRAINT Locations_RWQMRuleLocations_FK
	FOREIGN KEY (LocationId)
	REFERENCES Locations(LocationId)   
    
 PRINT 'STEP 4(F) COMPLETED'
 END
 
  
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='RWQMRuleServiceAreas')
BEGIN
/* 
 * TABLE: RWQMRuleServiceAreas 
 */
 CREATE TABLE RWQMRuleServiceAreas( 
		RWQMRuleServiceAreaId					int identity(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,		
		RWQMRuleId								int					 NOT NULL,
		ServiceAreaId							int					 NULL,
		CONSTRAINT RWQMRuleServiceAreas_PK PRIMARY KEY CLUSTERED (RWQMRuleServiceAreaId) 
 )
 
  IF OBJECT_ID('RWQMRuleServiceAreas') IS NOT NULL
    PRINT '<<< CREATED TABLE RWQMRuleServiceAreas >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE RWQMRuleServiceAreas >>>', 16, 1)
    
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMRuleServiceAreas') AND name='XIE1_RWQMRuleServiceAreas')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_RWQMRuleServiceAreas] ON [dbo].[RWQMRuleServiceAreas] 
		(
		RWQMRuleId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMRuleServiceAreas') AND name='XIE1_RWQMRuleServiceAreas')
		PRINT '<<< CREATED INDEX RWQMRuleServiceAreas.XIE1_RWQMRuleServiceAreas >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX RWQMRuleServiceAreas.XIE1_RWQMRuleServiceAreas >>>', 16, 1)		
		END	  
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMRuleServiceAreas') AND name='XIE2_RWQMRuleServiceAreas')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_RWQMRuleServiceAreas] ON [dbo].[RWQMRuleServiceAreas] 
		(
		ServiceAreaId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMRuleServiceAreas') AND name='XIE2_RWQMRuleServiceAreas')
		PRINT '<<< CREATED INDEX RWQMRuleServiceAreas.XIE2_RWQMRuleServiceAreas >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX RWQMRuleServiceAreas.XIE2_RWQMRuleServiceAreas >>>', 16, 1)		
		END	   
    
/* 
 * TABLE: RWQMRuleServiceAreas 
 */
 
 ALTER TABLE RWQMRuleServiceAreas ADD CONSTRAINT RWQMRules_RWQMRuleServiceAreas_FK
	FOREIGN KEY (RWQMRuleId)
	REFERENCES RWQMRules(RWQMRuleId)  
	
 ALTER TABLE RWQMRuleServiceAreas ADD CONSTRAINT ServiceAreas_RWQMRuleServiceAreas_FK
	FOREIGN KEY (ServiceAreaId)
	REFERENCES ServiceAreas(ServiceAreaId)   
    
 PRINT 'STEP 4(G) COMPLETED'
 END
 
 
 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='RWQMRuleProcedureCodes')
BEGIN
/* 
 * TABLE: RWQMRuleProcedureCodes 
 */
 CREATE TABLE RWQMRuleProcedureCodes( 
		RWQMRuleProcedureCodeId					int identity(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,		
		RWQMRuleId								int					 NOT NULL,
		ProcedureCodeId							int					 NULL,	
		CONSTRAINT RWQMRuleProcedureCodes_PK PRIMARY KEY CLUSTERED (RWQMRuleProcedureCodeId) 
 )
 
  IF OBJECT_ID('RWQMRuleProcedureCodes') IS NOT NULL
    PRINT '<<< CREATED TABLE RWQMRuleProcedureCodes >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE RWQMRuleProcedureCodes >>>', 16, 1)
    
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMRuleProcedureCodes') AND name='XIE1_RWQMRuleProcedureCodes')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_RWQMRuleProcedureCodes] ON [dbo].[RWQMRuleProcedureCodes] 
		(
		RWQMRuleId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMRuleProcedureCodes') AND name='XIE1_RWQMRuleProcedureCodes')
		PRINT '<<< CREATED INDEX RWQMRuleProcedureCodes.XIE1_RWQMRuleProcedureCodes >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX RWQMRuleProcedureCodes.XIE1_RWQMRuleProcedureCodes >>>', 16, 1)		
		END	  
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMRuleProcedureCodes') AND name='XIE2_RWQMRuleProcedureCodes')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_RWQMRuleProcedureCodes] ON [dbo].[RWQMRuleProcedureCodes] 
		(
		ProcedureCodeId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMRuleProcedureCodes') AND name='XIE2_RWQMRuleProcedureCodes')
		PRINT '<<< CREATED INDEX RWQMRuleProcedureCodes.XIE2_RWQMRuleProcedureCodes >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX RWQMRuleProcedureCodes.XIE2_RWQMRuleProcedureCodes >>>', 16, 1)		
		END	   
    
/* 
 * TABLE: RWQMRuleProcedureCodes 
 */
 
 ALTER TABLE RWQMRuleProcedureCodes ADD CONSTRAINT RWQMRules_RWQMRuleProcedureCodes_FK
	FOREIGN KEY (RWQMRuleId)
	REFERENCES RWQMRules(RWQMRuleId)  
	
 ALTER TABLE RWQMRuleProcedureCodes ADD CONSTRAINT ProcedureCodes_RWQMRuleProcedureCodes_FK
	FOREIGN KEY (ProcedureCodeId)
	REFERENCES ProcedureCodes(ProcedureCodeId)   
    
 PRINT 'STEP 4(H) COMPLETED'
 END

 
 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='RWQMRuleErrorReasons')
BEGIN
/* 
 * TABLE: RWQMRuleErrorReasons 
 */
 CREATE TABLE RWQMRuleErrorReasons( 
		RWQMRuleErrorReasonId					int identity(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,		
		RWQMRuleId								int					 NOT NULL,
		ErrorReasonId							type_GlobalCode		 NULL,	
		CONSTRAINT RWQMRuleErrorReasons_PK PRIMARY KEY CLUSTERED (RWQMRuleErrorReasonId) 
 )
 
  IF OBJECT_ID('RWQMRuleErrorReasons') IS NOT NULL
    PRINT '<<< CREATED TABLE RWQMRuleErrorReasons >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE RWQMRuleErrorReasons >>>', 16, 1)
    
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMRuleErrorReasons') AND name='XIE1_RWQMRuleErrorReasons')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_RWQMRuleErrorReasons] ON [dbo].[RWQMRuleErrorReasons] 
		(
		RWQMRuleId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMRuleErrorReasons') AND name='XIE1_RWQMRuleErrorReasons')
		PRINT '<<< CREATED INDEX RWQMRuleErrorReasons.XIE1_RWQMRuleErrorReasons >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX RWQMRuleErrorReasons.XIE1_RWQMRuleErrorReasons >>>', 16, 1)		
		END	    
    
/* 
 * TABLE: RWQMRuleErrorReasons 
 */
 
 ALTER TABLE RWQMRuleErrorReasons ADD CONSTRAINT RWQMRules_RWQMRuleErrorReasons_FK
	FOREIGN KEY (RWQMRuleId)
	REFERENCES RWQMRules(RWQMRuleId)   
    
 PRINT 'STEP 4(I) COMPLETED'
 END
 
 
 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='RWQMRuleAdjustmentCodes')
BEGIN
/* 
 * TABLE: RWQMRuleAdjustmentCodes 
 */
 CREATE TABLE RWQMRuleAdjustmentCodes( 
		RWQMRuleAdjustmentCodeId				int identity(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,		
		RWQMRuleId								int					 NOT NULL,
		AdjustmentCodes							type_GlobalCode		 NULL,	
		CONSTRAINT RWQMRuleAdjustmentCodes_PK PRIMARY KEY CLUSTERED (RWQMRuleAdjustmentCodeId) 
 )
 
  IF OBJECT_ID('RWQMRuleAdjustmentCodes') IS NOT NULL
    PRINT '<<< CREATED TABLE RWQMRuleAdjustmentCodes >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE RWQMRuleAdjustmentCodes >>>', 16, 1)
    
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMRuleAdjustmentCodes') AND name='XIE1_RWQMRuleAdjustmentCodes')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_RWQMRuleAdjustmentCodes] ON [dbo].[RWQMRuleAdjustmentCodes] 
		(
		RWQMRuleId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMRuleAdjustmentCodes') AND name='XIE1_RWQMRuleAdjustmentCodes')
		PRINT '<<< CREATED INDEX RWQMRuleAdjustmentCodes.XIE1_RWQMRuleAdjustmentCodes >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX RWQMRuleAdjustmentCodes.XIE1_RWQMRuleAdjustmentCodes >>>', 16, 1)		
		END	    
    
/* 
 * TABLE: RWQMRuleAdjustmentCodes 
 */
 
 ALTER TABLE RWQMRuleAdjustmentCodes ADD CONSTRAINT RWQMRules_RWQMRuleAdjustmentCodes_FK
	FOREIGN KEY (RWQMRuleId)
	REFERENCES RWQMRules(RWQMRuleId)   
    
 PRINT 'STEP 4(I) COMPLETED'
 END
------END Of STEP 4---------------

------ STEP 5 ----------------

-------END STEP 5-------------
------ STEP 6  ----------

----END Of STEP 6 ------------

------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 18.97)
BEGIN
Update SystemConfigurations set DataModelVersion=18.98
PRINT 'STEP 7 COMPLETED'
END
Go
