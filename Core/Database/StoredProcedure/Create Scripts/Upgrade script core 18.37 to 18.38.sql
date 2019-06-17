----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.37)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.37 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of Step 2 -------


------ STEP 3 ------------
	
------ END Of STEP 3 ------------

------ STEP 4 ---------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='DocumentMedicationReconciliations')
 BEGIN
/* 
 * TABLE: DocumentMedicationReconciliations 
 */

CREATE TABLE DocumentMedicationReconciliations(
    DocumentVersionId							int 						NOT NULL,
    CreatedBy									type_CurrentUser			NOT NULL,
    CreatedDate									type_CurrentDatetime		NOT NULL,
    ModifiedBy									type_CurrentUser			NOT NULL,
    ModifiedDate								type_CurrentDatetime		NOT NULL,
    RecordDeleted								type_YOrN					NULL
												CHECK (RecordDeleted in	('Y','N')),
    DeletedBy									type_UserId					NULL,
    DeletedDate									datetime					NULL,
    ClientCCDId									int							NULL,			
	ReconciliationType							char(1)						NULL
												CHECK (ReconciliationType in('V','C','D')),													
	Comment										type_Comment2				NULL,									
    CONSTRAINT DocumentMedicationReconciliations_PK PRIMARY KEY CLUSTERED (DocumentVersionId)		 	
)
 IF OBJECT_ID('DocumentMedicationReconciliations') IS NOT NULL
    PRINT '<<< CREATED TABLE DocumentMedicationReconciliations >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE DocumentMedicationReconciliations >>>', 16, 1)
    
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('DocumentMedicationReconciliations') AND name='XIE1_DocumentMedicationReconciliations')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_DocumentMedicationReconciliations] ON [dbo].[DocumentMedicationReconciliations] 
		(
		ClientCCDId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('DocumentMedicationReconciliations') AND name='XIE1_DocumentMedicationReconciliations')
		PRINT '<<< CREATED INDEX DocumentMedicationReconciliations.XIE1_DocumentMedicationReconciliations >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX DocumentMedicationReconciliations.XIE1_DocumentMedicationReconciliations >>>', 16, 1)		
		END 
    

/* 
 * TABLE: DocumentMedicationReconciliations	 
 */
 
   
ALTER TABLE DocumentMedicationReconciliations ADD CONSTRAINT DocumentVersions_DocumentMedicationReconciliations_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId) 
    
ALTER TABLE DocumentMedicationReconciliations ADD CONSTRAINT ClientCCDs_DocumentMedicationReconciliations_FK
    FOREIGN KEY (ClientCCDId)
    REFERENCES ClientCCDs(ClientCCDId) 
 
  EXEC sys.sp_addextendedproperty 'DocumentMedicationReconciliations_Description'
	,'ReconciliationType Column stores V,C,D .V-Verbal,C-CCD,D-Document'
	,'schema'
	,'dbo'
	,'table'
	,'DocumentMedicationReconciliations'
	,'column'
	,'ReconciliationType'
    
PRINT 'STEP 4(A) COMPLETED'
END	


IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='MedicationReconciliationCurrentMedications')
 BEGIN
/* 
 * TABLE: MedicationReconciliationCurrentMedications 
 */

CREATE TABLE MedicationReconciliationCurrentMedications(
    MedicationReconciliationCurrentMedicationId			int identity(1,1)			NOT NULL,
    CreatedBy											type_CurrentUser			NOT NULL,
    CreatedDate											type_CurrentDatetime		NOT NULL,
    ModifiedBy											type_CurrentUser			NOT NULL,
    ModifiedDate										type_CurrentDatetime		NOT NULL,
    RecordDeleted										type_YOrN					NULL
														CHECK (RecordDeleted in	('Y','N')),
    DeletedBy											type_UserId					NULL,
    DeletedDate											datetime					NULL,
	DocumentVersionId									int							NULL,	
	ClientMedicationInstructionId						int							NULL,	
	MedicationType										char(1)						NULL
														CHECK (MedicationType in('C','D','P','S','O')),								
    CONSTRAINT MedicationReconciliationCurrentMedications_PK PRIMARY KEY CLUSTERED (MedicationReconciliationCurrentMedicationId)		 	
)
 IF OBJECT_ID('MedicationReconciliationCurrentMedications') IS NOT NULL
    PRINT '<<< CREATED TABLE MedicationReconciliationCurrentMedications >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE MedicationReconciliationCurrentMedications >>>', 16, 1)
    
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('MedicationReconciliationCurrentMedications') AND name='XIE1_MedicationReconciliationCurrentMedications')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_MedicationReconciliationCurrentMedications] ON [dbo].[MedicationReconciliationCurrentMedications] 
		(
		DocumentVersionId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('MedicationReconciliationCurrentMedications') AND name='XIE1_MedicationReconciliationCurrentMedications')
		PRINT '<<< CREATED INDEX MedicationReconciliationCurrentMedications.XIE1_MedicationReconciliationCurrentMedications >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX MedicationReconciliationCurrentMedications.XIE1_MedicationReconciliationCurrentMedications >>>', 16, 1)		
		END 
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('MedicationReconciliationCurrentMedications') AND name='XIE2_MedicationReconciliationCurrentMedications')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_MedicationReconciliationCurrentMedications] ON [dbo].[MedicationReconciliationCurrentMedications] 
		(
		ClientMedicationInstructionId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('MedicationReconciliationCurrentMedications') AND name='XIE2_MedicationReconciliationCurrentMedications')
		PRINT '<<< CREATED INDEX MedicationReconciliationCurrentMedications.XIE2_MedicationReconciliationCurrentMedications >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX MedicationReconciliationCurrentMedications.XIE2_MedicationReconciliationCurrentMedications >>>', 16, 1)		
		END 
				
/* 
 * TABLE: MedicationReconciliationCurrentMedications	 
 */
 
   
ALTER TABLE MedicationReconciliationCurrentMedications ADD CONSTRAINT DocumentVersions_MedicationReconciliationCurrentMedications_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId) 
    
ALTER TABLE MedicationReconciliationCurrentMedications ADD CONSTRAINT ClientMedicationInstructions_MedicationReconciliationCurrentMedications_FK
    FOREIGN KEY (ClientMedicationInstructionId)
    REFERENCES ClientMedicationInstructions(ClientMedicationInstructionId) 
 
 EXEC sys.sp_addextendedproperty 'MedicationReconciliationCurrentMedications_Description'
	,'MedicationType Column stores C,D,P,S and O .C-CCD,D-Document,P-Prescribed Medications,S-Self Reported Medications,O-Other Medications'
	,'schema'
	,'dbo'
	,'table'
	,'MedicationReconciliationCurrentMedications'
	,'column'
	,'MedicationType' 
    
PRINT 'STEP 4(B) COMPLETED'
END	



IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='MedicationReconciliationCCDMedications')
 BEGIN
/* 
 * TABLE: MedicationReconciliationCCDMedications 
 */

CREATE TABLE MedicationReconciliationCCDMedications(
    MedicationReconciliationCCDMedicationId				int identity(1,1)			NOT NULL,
    CreatedBy											type_CurrentUser			NOT NULL,
    CreatedDate											type_CurrentDatetime		NOT NULL,
    ModifiedBy											type_CurrentUser			NOT NULL,
    ModifiedDate										type_CurrentDatetime		NOT NULL,
    RecordDeleted										type_YOrN					NULL
														CHECK (RecordDeleted in	('Y','N')),
    DeletedBy											type_UserId					NULL,
    DeletedDate											datetime					NULL,
	DocumentVersionId									int							NULL,	
	ClientCCDId											int							NULL,
	MedicationNameId									int							NULL,
	StrengthId											int							NULL,
	RouteId												int							NULL,
	UserDefinedMedicationId								int							NULL,
	RXNormCode											varchar(255)				NULL,
	MedicationName										varchar(500)				NULL,
	Quantity											decimal(18,2)				NULL,
	Unit												varchar(50)					NULL,
	UnitId												type_GlobalCode				NULL,
	StrengthDescription									varchar(250)				NULL,
	MedicationRoute										varchar(250)				NULL,
	Schedule											varchar(500)				NULL,
	ScheduleId											type_GlobalCode				NULL,
	MedicationStartDate									datetime					NULL,
	MedicationEndDate									datetime					NULL,
	AdditionalInformation								varchar(max)				NULL,
    CONSTRAINT MedicationReconciliationCCDMedications_PK PRIMARY KEY CLUSTERED (MedicationReconciliationCCDMedicationId)		 	
)
 IF OBJECT_ID('MedicationReconciliationCCDMedications') IS NOT NULL
    PRINT '<<< CREATED TABLE MedicationReconciliationCCDMedications >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE MedicationReconciliationCCDMedications >>>', 16, 1)
    
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('MedicationReconciliationCCDMedications') AND name='XIE1_MedicationReconciliationCCDMedications')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_MedicationReconciliationCCDMedications] ON [dbo].[MedicationReconciliationCCDMedications] 
		(
		DocumentVersionId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('MedicationReconciliationCCDMedications') AND name='XIE1_MedicationReconciliationCCDMedications')
		PRINT '<<< CREATED INDEX MedicationReconciliationCCDMedications.XIE1_MedicationReconciliationCCDMedications >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX MedicationReconciliationCCDMedications.XIE1_MedicationReconciliationCCDMedications >>>', 16, 1)		
		END 
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('MedicationReconciliationCCDMedications') AND name='XIE2_MedicationReconciliationCCDMedications')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_MedicationReconciliationCCDMedications] ON [dbo].[MedicationReconciliationCCDMedications] 
		(
		MedicationNameId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('MedicationReconciliationCCDMedications') AND name='XIE2_MedicationReconciliationCCDMedications')
		PRINT '<<< CREATED INDEX MedicationReconciliationCCDMedications.XIE2_MedicationReconciliationCCDMedications >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX MedicationReconciliationCCDMedications.XIE2_MedicationReconciliationCCDMedications >>>', 16, 1)		
		END 
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('MedicationReconciliationCCDMedications') AND name='XIE3_MedicationReconciliationCCDMedications')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE3_MedicationReconciliationCCDMedications] ON [dbo].[MedicationReconciliationCCDMedications] 
		(
		StrengthId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('MedicationReconciliationCCDMedications') AND name='XIE3_MedicationReconciliationCCDMedications')
		PRINT '<<< CREATED INDEX MedicationReconciliationCCDMedications.XIE3_MedicationReconciliationCCDMedications >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX MedicationReconciliationCCDMedications.XIE3_MedicationReconciliationCCDMedications >>>', 16, 1)		
		END 
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('MedicationReconciliationCCDMedications') AND name='XIE4_MedicationReconciliationCCDMedications')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE4_MedicationReconciliationCCDMedications] ON [dbo].[MedicationReconciliationCCDMedications] 
		(
		RouteId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('MedicationReconciliationCCDMedications') AND name='XIE4_MedicationReconciliationCCDMedications')
		PRINT '<<< CREATED INDEX MedicationReconciliationCCDMedications.XIE4_MedicationReconciliationCCDMedications >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX MedicationReconciliationCCDMedications.XIE4_MedicationReconciliationCCDMedications >>>', 16, 1)		
		END 
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('MedicationReconciliationCCDMedications') AND name='XIE5_MedicationReconciliationCCDMedications')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE5_MedicationReconciliationCCDMedications] ON [dbo].[MedicationReconciliationCCDMedications] 
		(
		ClientCCDId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('MedicationReconciliationCCDMedications') AND name='XIE5_MedicationReconciliationCCDMedications')
		PRINT '<<< CREATED INDEX MedicationReconciliationCCDMedications.XIE5_MedicationReconciliationCCDMedications >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX MedicationReconciliationCCDMedications.XIE5_MedicationReconciliationCCDMedications >>>', 16, 1)		
		END 
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('MedicationReconciliationCCDMedications') AND name='XIE6_MedicationReconciliationCCDMedications')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE6_MedicationReconciliationCCDMedications] ON [dbo].[MedicationReconciliationCCDMedications] 
		(
		UserDefinedMedicationId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('MedicationReconciliationCCDMedications') AND name='XIE6_MedicationReconciliationCCDMedications')
		PRINT '<<< CREATED INDEX MedicationReconciliationCCDMedications.XIE6_MedicationReconciliationCCDMedications >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX MedicationReconciliationCCDMedications.XIE6_MedicationReconciliationCCDMedications >>>', 16, 1)		
		END 
				
/* 
 * TABLE: MedicationReconciliationCCDMedications	 
 */
 
   
ALTER TABLE MedicationReconciliationCCDMedications ADD CONSTRAINT DocumentVersions_MedicationReconciliationCCDMedications_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId) 
    
ALTER TABLE MedicationReconciliationCCDMedications ADD CONSTRAINT ClientCCDs_MedicationReconciliationCCDMedications_FK
    FOREIGN KEY (ClientCCDId)
    REFERENCES ClientCCDs(ClientCCDId) 
    
 
 ALTER TABLE MedicationReconciliationCCDMedications ADD CONSTRAINT MDMedications_MedicationReconciliationCCDMedications_FK
    FOREIGN KEY (StrengthId)
    REFERENCES MDMedications(MedicationId) 
    
ALTER TABLE MedicationReconciliationCCDMedications ADD CONSTRAINT MDMedicationNames_MedicationReconciliationCCDMedications_FK2
    FOREIGN KEY (MedicationNameId)
    REFERENCES MDMedicationNames(MedicationNameId) 
    
ALTER TABLE MedicationReconciliationCCDMedications ADD CONSTRAINT MDRoutes_MedicationReconciliationCCDMedications_FK
    FOREIGN KEY (RouteId)
    REFERENCES MDRoutes(RouteId) 
    
ALTER TABLE MedicationReconciliationCCDMedications ADD CONSTRAINT UserDefinedMedications_MedicationReconciliationCCDMedications_FK
    FOREIGN KEY (UserDefinedMedicationId)
    REFERENCES UserDefinedMedications(UserDefinedMedicationId) 
    
    
PRINT 'STEP 4(B) COMPLETED'
END	
 ----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 18.37)
BEGIN
Update SystemConfigurations set DataModelVersion=18.38
PRINT 'STEP 7 COMPLETED'
END
Go
