----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 16.58)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 16.58 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of Step 2 -------

------ STEP 3 ------------

------ STEP 4 ---------------
 
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='MobileBriefcase')
BEGIN
/*  
 * TABLE:  MobileBriefcase 
 */
 
 CREATE TABLE MobileBriefcase(
		MobileBriefcaseId					INT IDENTITY(1,1)		NOT NULL,
		CreatedBy							type_CurrentUser		NOT NULL,
		CreatedDate							type_CurrentDatetime	NOT NULL,
		ModifiedBy							type_CurrentUser		NOT NULL,
		ModifiedDate						type_CurrentDatetime	NOT NULL,
		RecordDeleted						type_YOrN				NULL
											CHECK (RecordDeleted in	('Y','N')),	
		DeletedBy							type_UserId				NULL,
		DeletedDate							datetime				NULL,
		StaffId								int						NULL,
		BreifcaseType						type_GlobalCode			NULL,
		BreifcaseTypeId						int						NULL,
		BriefcaseData						nvarchar(max)			NULL,
		CONSTRAINT MobileBriefcase_PK PRIMARY KEY CLUSTERED (MobileBriefcaseId)
 ) 
 IF OBJECT_ID('MobileBriefcase') IS NOT NULL
	PRINT '<<< CREATED TABLE MobileBriefcase >>>'
ELSE
	RAISERROR('<<< FAILED CREATING TABLE MobileBriefcase >>>', 16, 1)	
	
 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('MobileBriefcase') AND name='XIE1_MobileBriefcase')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_MobileBriefcase] ON [dbo].[MobileBriefcase] 
		(
		StaffId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('MobileBriefcase') AND name='XIE1_MobileBriefcase')
		PRINT '<<< CREATED INDEX MobileBriefcase.XIE1_MobileBriefcase >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX MobileBriefcase.XIE1_MobileBriefcase >>>', 16, 1)		
		END 
		
	
/* 
 * TABLE: MobileBriefcase 
 */	

ALTER TABLE MobileBriefcase ADD CONSTRAINT Staff_MobileBriefcase_FK 
	FOREIGN KEY (StaffId)
	REFERENCES Staff(StaffId)	
	
	
EXEC sys.sp_addextendedproperty 'MobileBriefcase_Description'
 ,'BreifcaseTypeId Stores a primary key value from multiple tables Based on Briefcase type'
 ,'schema'
 ,'dbo'
 ,'table'
 ,'MobileBriefcase'
 ,'column'
 ,'BreifcaseTypeId'	
	
		
PRINT 'STEP 4(A) COMPLETED'
		
END

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='DocumentServiceNoteGoals')
BEGIN 
/* 
 * TABLE:  DocumentServiceNoteGoals 
 */
 CREATE TABLE DocumentServiceNoteGoals( 
		DocumentServiceNoteGoalId			int	identity(1,1)		NOT NULL,
		CreatedBy							type_CurrentUser		NOT NULL,
		CreatedDate							type_CurrentDatetime	NOT NULL,
		ModifiedBy							type_CurrentUser		NOT NULL,
		ModifiedDate						type_CurrentDatetime	NOT NULL,
		RecordDeleted						type_YOrN				NULL
											CHECK (RecordDeleted in ('Y','N')),
		DeletedBy							type_UserId				NULL,
		DeletedDate							datetime				NULL,	
		DocumentVersionId					int						NULL,	
		GoalId								int						NULL,	
		GoalNumber							decimal(18,2)			NULL,
		GoalText							type_Comment2			NULL,
		CustomGoalActive					type_YOrN				NULL
											CHECK (CustomGoalActive in ('Y','N')),
		CONSTRAINT DocumentServiceNoteGoals_PK PRIMARY KEY CLUSTERED (DocumentServiceNoteGoalId) 
 )
 
  IF OBJECT_ID('DocumentServiceNoteGoals') IS NOT NULL
    PRINT '<<< CREATED TABLE DocumentServiceNoteGoals >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE DocumentServiceNoteGoals >>>', 16, 1)
    
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('DocumentServiceNoteGoals') AND name='XIE1_DocumentServiceNoteGoals')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_DocumentServiceNoteGoals] ON [dbo].[DocumentServiceNoteGoals] 
		(
		DocumentVersionId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('DocumentServiceNoteGoals') AND name='XIE1_DocumentServiceNoteGoals')
		PRINT '<<< CREATED INDEX DocumentServiceNoteGoals.XIE1_DocumentServiceNoteGoals >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX DocumentServiceNoteGoals.XIE1_DocumentServiceNoteGoals >>>', 16, 1)		
		END 
		
	 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('DocumentServiceNoteGoals') AND name='XIE2_DocumentServiceNoteGoals')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_DocumentServiceNoteGoals] ON [dbo].[DocumentServiceNoteGoals] 
		(
		GoalId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('DocumentServiceNoteGoals') AND name='XIE2_DocumentServiceNoteGoals')
		PRINT '<<< CREATED INDEX DocumentServiceNoteGoals.XIE2_DocumentServiceNoteGoals >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX DocumentServiceNoteGoals.XIE2_DocumentServiceNoteGoals >>>', 16, 1)		
		END 
    
/* 
 * TABLE: DocumentServiceNoteGoals 
 */   
 
   ALTER TABLE DocumentServiceNoteGoals ADD CONSTRAINT DocumentVersions_DocumentServiceNoteGoals_FK 
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
    
   ALTER TABLE DocumentServiceNoteGoals ADD CONSTRAINT CarePlanGoals_DocumentServiceNoteGoals_FK 
    FOREIGN KEY (GoalId)
    REFERENCES CarePlanGoals(CareplanGoalId)
 
 PRINT 'STEP 4(B) COMPLETED'
 END


 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='DocumentServiceNoteObjectives')
BEGIN
/* 
 * TABLE: DocumentServiceNoteObjectives 
 */
 CREATE TABLE DocumentServiceNoteObjectives( 
		DocumentServiceNoteObjectiveId		int	identity(1,1)		NOT NULL,
		CreatedBy							type_CurrentUser		NOT NULL,
		CreatedDate							type_CurrentDatetime	NOT NULL,
		ModifiedBy							type_CurrentUser		NOT NULL,
		ModifiedDate						type_CurrentDatetime	NOT NULL,
		RecordDeleted						type_YOrN				NULL
											CHECK (RecordDeleted in ('Y','N')),
		DeletedBy							type_UserId				NULL,
		DeletedDate							datetime				NULL,	
		DocumentVersionId					int						NULL,	
		GoalId								int						NULL,
		ObjectiveNumber						decimal(18,2)			NULL,
		CustomObjectiveActive				type_YOrN				NULL
											CHECK (CustomObjectiveActive in ('Y','N')),
		ObjectiveStatus						type_GlobalCode			NULL,
		ObjectiveText						type_Comment2			NULL,
		CONSTRAINT DocumentServiceNoteObjectives_PK PRIMARY KEY CLUSTERED (DocumentServiceNoteObjectiveId) 
 )
 
  IF OBJECT_ID('DocumentServiceNoteObjectives') IS NOT NULL
    PRINT '<<< CREATED TABLE DocumentServiceNoteObjectives >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE DocumentServiceNoteObjectives >>>', 16, 1)
    
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('DocumentServiceNoteObjectives') AND name='XIE1_DocumentServiceNoteObjectives')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_DocumentServiceNoteObjectives] ON [dbo].[DocumentServiceNoteObjectives] 
		(
		DocumentVersionId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('DocumentServiceNoteObjectives') AND name='XIE1_DocumentServiceNoteObjectives')
		PRINT '<<< CREATED INDEX DocumentServiceNoteObjectives.XIE1_DocumentServiceNoteObjectives >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX DocumentServiceNoteObjectives.XIE1_DocumentServiceNoteObjectives >>>', 16, 1)		
		END 
		
  IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('DocumentServiceNoteObjectives') AND name='XIE2_DocumentServiceNoteObjectives')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_DocumentServiceNoteObjectives] ON [dbo].[DocumentServiceNoteObjectives] 
		(
		GoalId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('DocumentServiceNoteObjectives') AND name='XIE2_DocumentServiceNoteObjectives')
		PRINT '<<< CREATED INDEX DocumentServiceNoteObjectives.XIE2_DocumentServiceNoteObjectives >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX DocumentServiceNoteObjectives.XIE2_DocumentServiceNoteObjectives >>>', 16, 1)		
		END 
    
/* 
 * TABLE: DocumentServiceNoteObjectives 
 */   
 
   ALTER TABLE DocumentServiceNoteObjectives ADD CONSTRAINT DocumentVersions_DocumentServiceNoteObjectives_FK 
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
    
   ALTER TABLE DocumentServiceNoteObjectives ADD CONSTRAINT CarePlanGoals_DocumentServiceNoteObjectives_FK 
    FOREIGN KEY (GoalId)
    REFERENCES CarePlanGoals(CareplanGoalId)
 
 
 PRINT 'STEP 4(C) COMPLETED'
 END
 
----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 16.58)
BEGIN
Update SystemConfigurations set DataModelVersion=16.59
PRINT 'STEP 7 COMPLETED'
END
Go

