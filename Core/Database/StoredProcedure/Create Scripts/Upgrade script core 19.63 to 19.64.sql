----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 19.63)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 19.63 or update.Upgrade Script Failed.>>>', 16, 1)
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
IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='PerDiemBillingConfigurations')
BEGIN
/* 
 * TABLE: PerDiemBillingConfigurations 
 */
 CREATE TABLE PerDiemBillingConfigurations( 
		PerDiemBillingConfigurationId			int	IDENTITY (1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,		
		ProgramId								int					 NOT NULL,
		BillableProcedureCode					int					 NOT NULL,
		LocationId								int					 NOT NULL,
		ClinicianId								int					 NOT NULL, 
		NonBillableProcedureCode				int					 NULL, 
		FromDate								datetime			 NOT NULL,
		ToDate									datetime			 NULL,		
		BillDischargeDate						type_YOrN			 NULL
												CHECK (BillDischargeDate in ('Y','N')),
		CONSTRAINT PerDiemBillingConfigurations_PK PRIMARY KEY CLUSTERED (PerDiemBillingConfigurationId) 
 )
 
  IF OBJECT_ID('PerDiemBillingConfigurations') IS NOT NULL
    PRINT '<<< CREATED TABLE PerDiemBillingConfigurations >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE PerDiemBillingConfigurations >>>', 16, 1)
    
    IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PerDiemBillingConfigurations]') AND name = N'XIE1_PerDiemBillingConfigurations')
  BEGIN
   CREATE NONCLUSTERED INDEX [XIE1_PerDiemBillingConfigurations] ON [dbo].[PerDiemBillingConfigurations] 
   (
   [ProgramId]  ASC
   )
   WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
   IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('PerDiemBillingConfigurations') AND name='XIE1_PerDiemBillingConfigurations')
   PRINT '<<< CREATED INDEX PerDiemBillingConfigurations.XIE1_PerDiemBillingConfigurations >>>'
   ELSE
   RAISERROR('<<< FAILED CREATING INDEX PerDiemBillingConfigurations.XIE1_PerDiemBillingConfigurations >>>', 16, 1)  
  END     
  
  IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PerDiemBillingConfigurations]') AND name = N'XIE2_PerDiemBillingConfigurations')
  BEGIN
   CREATE NONCLUSTERED INDEX [XIE2_PerDiemBillingConfigurations] ON [dbo].[PerDiemBillingConfigurations] 
   (
   [BillableProcedureCode]  ASC
   )
   WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
   IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('PerDiemBillingConfigurations') AND name='XIE2_PerDiemBillingConfigurations')
   PRINT '<<< CREATED INDEX PerDiemBillingConfigurations.XIE2_PerDiemBillingConfigurations >>>'
   ELSE
   RAISERROR('<<< FAILED CREATING INDEX PerDiemBillingConfigurations.XIE2_PerDiemBillingConfigurations >>>', 16, 1)  
  END    
  
     IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PerDiemBillingConfigurations]') AND name = N'XIE3_PerDiemBillingConfigurations')
  BEGIN
   CREATE NONCLUSTERED INDEX [XIE3_PerDiemBillingConfigurations] ON [dbo].[PerDiemBillingConfigurations] 
   (
   [LocationId]  ASC
   )
   WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
   IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('PerDiemBillingConfigurations') AND name='XIE3_PerDiemBillingConfigurations')
   PRINT '<<< CREATED INDEX PerDiemBillingConfigurations.XIE3_PerDiemBillingConfigurations >>>'
   ELSE
   RAISERROR('<<< FAILED CREATING INDEX PerDiemBillingConfigurations.XIE3_PerDiemBillingConfigurations >>>', 16, 1)  
  END     
  
  IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PerDiemBillingConfigurations]') AND name = N'XIE4_PerDiemBillingConfigurations')
  BEGIN
   CREATE NONCLUSTERED INDEX [XIE4_PerDiemBillingConfigurations] ON [dbo].[PerDiemBillingConfigurations] 
   (
   [ClinicianId]  ASC
   )
   WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
   IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('PerDiemBillingConfigurations') AND name='XIE4_PerDiemBillingConfigurations')
   PRINT '<<< CREATED INDEX PerDiemBillingConfigurations.XIE4_PerDiemBillingConfigurations >>>'
   ELSE
   RAISERROR('<<< FAILED CREATING INDEX PerDiemBillingConfigurations.XIE4_PerDiemBillingConfigurations >>>', 16, 1)  
  END   
  
     IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PerDiemBillingConfigurations]') AND name = N'XIE5_PerDiemBillingConfigurations')
  BEGIN
   CREATE NONCLUSTERED INDEX [XIE5_PerDiemBillingConfigurations] ON [dbo].[PerDiemBillingConfigurations] 
   (
   [NonBillableProcedureCode]  ASC
   )
   WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
   IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('PerDiemBillingConfigurations') AND name='XIE5_PerDiemBillingConfigurations')
   PRINT '<<< CREATED INDEX PerDiemBillingConfigurations.XIE5_PerDiemBillingConfigurations >>>'
   ELSE
   RAISERROR('<<< FAILED CREATING INDEX PerDiemBillingConfigurations.XIE5_PerDiemBillingConfigurations >>>', 16, 1)  
  END     

/* 
 * TABLE: PerDiemBillingConfigurations 
 */
ALTER TABLE PerDiemBillingConfigurations ADD CONSTRAINT Programs_PerDiemBillingConfigurations_FK
    FOREIGN KEY (ProgramId)
    REFERENCES Programs(ProgramId)
    
ALTER TABLE PerDiemBillingConfigurations ADD CONSTRAINT ProcedureCodes_PerDiemBillingConfigurations_FK
    FOREIGN KEY (BillableProcedureCode)
    REFERENCES ProcedureCodes(ProcedureCodeId)
    
ALTER TABLE PerDiemBillingConfigurations ADD CONSTRAINT Locations_PerDiemBillingConfigurations_FK
    FOREIGN KEY (LocationId)
    REFERENCES Locations(LocationId)
    
ALTER TABLE PerDiemBillingConfigurations ADD CONSTRAINT Staff_PerDiemBillingConfigurations_FK
    FOREIGN KEY (ClinicianId)
    REFERENCES Staff(StaffId)
    
ALTER TABLE PerDiemBillingConfigurations ADD CONSTRAINT ProcedureCodes_PerDiemBillingConfigurations_FK2
    FOREIGN KEY (NonBillableProcedureCode)
    REFERENCES ProcedureCodes(ProcedureCodeId) 
    
    
     
     PRINT 'STEP 4(A) COMPLETED'
END
 
 
---------------------------------------------------------------
--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 19.63)
BEGIN
Update SystemConfigurations set DataModelVersion=19.64
PRINT 'STEP 7 COMPLETED'
END
Go