----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 19.67)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 19.67 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
--Part1 Begin
--Part1 Ends

--Part2 Begins


--Part2 Ends
-----End of Step 2 -------

------ STEP 3 ------------

IF OBJECT_ID('DocumentMedicationReconciliations') IS NOT NULL
BEGIN

	/* Drop Constraint */
declare @Cstname nvarchar(max), 
    @sql nvarchar(1000)

-- find constraint name
SELECT @Cstname=COALESCE(@Cstname+',','')+SCO.name 
    FROM
        sys.Objects TB
        INNER JOIN sys.Columns TC on (TB.Object_id = TC.object_id)
        INNER JOIN sys.sysconstraints SC ON (TC.Object_ID = SC.id and TC.column_id = SC.colid)
        INNER JOIN sys.objects SCO ON (SC.Constid = SCO.object_id)
    where
        TB.name='DocumentMedicationReconciliations'
        AND TC.name='ReconciliationType'
       order by SCO.name 
  if not @Cstname is null
begin
    select @sql = 'ALTER TABLE [DocumentMedicationReconciliations] DROP CONSTRAINT ' + @Cstname + ''   
    execute sp_executesql @sql
end
IF COL_LENGTH('DocumentMedicationReconciliations','ReconciliationType')IS NOT NULL
BEGIN
 ALTER TABLE DocumentMedicationReconciliations WITH CHECK ADD CHECK  (ReconciliationType in ('C','V','O'))									  
END
 
IF EXISTS (SELECT *	FROM::fn_listextendedproperty('DocumentMedicationReconciliations_Description', 'schema', 'dbo', 'table', 'DocumentMedicationReconciliations', 'column', 'ReconciliationType'))
BEGIN
	EXEC sys.sp_dropextendedproperty 'DocumentMedicationReconciliations_Description'
		,'schema'
		,'dbo'
		,'table'
		,'DocumentMedicationReconciliations'
		,'column'
		,'ReconciliationType'
END

EXEC sys.sp_addextendedproperty 'DocumentMedicationReconciliations_Description'
	,'ReconciliationType column stores C,V,O. C-CCD,V-Verbal,O-Other'
	,'schema'
	,'dbo'
	,'table'
	,'DocumentMedicationReconciliations'
	,'column'
	,'ReconciliationType' 
	 
	


IF COL_LENGTH('DocumentMedicationReconciliations','ExternalReferenceId')IS  NULL
BEGIN
 ALTER TABLE DocumentMedicationReconciliations ADD ExternalReferenceId int NULL	
END	

IF COL_LENGTH('DocumentMedicationReconciliations','ExternalReferenceId')IS NOT NULL
	BEGIN
				
	IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[DocumentMedicationReconciliations]') AND name = N'XIE2_DocumentMedicationReconciliations')
	  BEGIN
	   CREATE NONCLUSTERED INDEX [XIE2_DocumentMedicationReconciliations] ON [dbo].[DocumentMedicationReconciliations] 
	   (
	   [ExternalReferenceId]  ASC
	   )
	   WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	   IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('DocumentMedicationReconciliations') AND name='XIE2_DocumentMedicationReconciliations')
	   PRINT '<<< CREATED INDEX DocumentMedicationReconciliations.XIE2_DocumentMedicationReconciliations >>>'
	   ELSE
	   RAISERROR('<<< FAILED CREATING INDEX DocumentMedicationReconciliations.XIE2_DocumentMedicationReconciliations >>>', 16, 1)  
	  END     
	 
	END
	PRINT 'STEP 3 COMPLETED'
	END	

------ END OF STEP 3 -----

------ STEP 4 ----------

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='MedicationReconciliationExternalMedications')
 BEGIN
/* 
 * TABLE: MedicationReconciliationExternalMedications 
 */

CREATE TABLE MedicationReconciliationExternalMedications(
    MedicationReconciliationExternalMedicationId		int identity(1,1)			NOT NULL,
    CreatedBy											type_CurrentUser			NOT NULL,
    CreatedDate											type_CurrentDatetime		NOT NULL,
    ModifiedBy											type_CurrentUser			NOT NULL,
    ModifiedDate										type_CurrentDatetime		NOT NULL,
    RecordDeleted										type_YOrN					NULL
														CHECK (RecordDeleted in	('Y','N')),
    DeletedBy											type_UserId					NULL,
    DeletedDate											datetime					NULL,
	DocumentVersionId									int							NULL,	
	ExternalReferenceId									int							NULL,
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
	DiscontinuedMedication								type_YOrN					NULL
														CHECK (DiscontinuedMedication in ('Y','N')),
    CONSTRAINT MedicationReconciliationExternalMedications_PK PRIMARY KEY CLUSTERED (MedicationReconciliationExternalMedicationId)		 	
)
 IF OBJECT_ID('MedicationReconciliationExternalMedications') IS NOT NULL
    PRINT '<<< CREATED TABLE MedicationReconciliationExternalMedications >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE MedicationReconciliationExternalMedications >>>', 16, 1)
    
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('MedicationReconciliationExternalMedications') AND name='XIE1_MedicationReconciliationExternalMedications')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_MedicationReconciliationExternalMedications] ON [dbo].[MedicationReconciliationExternalMedications] 
		(
		DocumentVersionId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('MedicationReconciliationExternalMedications') AND name='XIE1_MedicationReconciliationExternalMedications')
		PRINT '<<< CREATED INDEX MedicationReconciliationExternalMedications.XIE1_MedicationReconciliationExternalMedications >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX MedicationReconciliationExternalMedications.XIE1_MedicationReconciliationExternalMedications >>>', 16, 1)		
		END 
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('MedicationReconciliationExternalMedications') AND name='XIE2_MedicationReconciliationExternalMedications')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_MedicationReconciliationExternalMedications] ON [dbo].[MedicationReconciliationExternalMedications] 
		(
		MedicationNameId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('MedicationReconciliationExternalMedications') AND name='XIE2_MedicationReconciliationExternalMedications')
		PRINT '<<< CREATED INDEX MedicationReconciliationExternalMedications.XIE2_MedicationReconciliationExternalMedications >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX MedicationReconciliationExternalMedications.XIE2_MedicationReconciliationExternalMedications >>>', 16, 1)		
		END 
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('MedicationReconciliationExternalMedications') AND name='XIE3_MedicationReconciliationExternalMedications')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE3_MedicationReconciliationExternalMedications] ON [dbo].[MedicationReconciliationExternalMedications] 
		(
		StrengthId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('MedicationReconciliationExternalMedications') AND name='XIE3_MedicationReconciliationExternalMedications')
		PRINT '<<< CREATED INDEX MedicationReconciliationExternalMedications.XIE3_MedicationReconciliationExternalMedications >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX MedicationReconciliationExternalMedications.XIE3_MedicationReconciliationExternalMedications >>>', 16, 1)		
		END 
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('MedicationReconciliationExternalMedications') AND name='XIE4_MedicationReconciliationExternalMedications')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE4_MedicationReconciliationExternalMedications] ON [dbo].[MedicationReconciliationExternalMedications] 
		(
		RouteId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('MedicationReconciliationExternalMedications') AND name='XIE4_MedicationReconciliationExternalMedications')
		PRINT '<<< CREATED INDEX MedicationReconciliationExternalMedications.XIE4_MedicationReconciliationExternalMedications >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX MedicationReconciliationExternalMedications.XIE4_MedicationReconciliationExternalMedications >>>', 16, 1)		
		END 
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('MedicationReconciliationExternalMedications') AND name='XIE5_MedicationReconciliationExternalMedications')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE5_MedicationReconciliationExternalMedications] ON [dbo].[MedicationReconciliationExternalMedications] 
		(
		ExternalReferenceId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('MedicationReconciliationExternalMedications') AND name='XIE5_MedicationReconciliationExternalMedications')
		PRINT '<<< CREATED INDEX MedicationReconciliationExternalMedications.XIE5_MedicationReconciliationExternalMedications >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX MedicationReconciliationExternalMedications.XIE5_MedicationReconciliationExternalMedications >>>', 16, 1)		
		END 
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('MedicationReconciliationExternalMedications') AND name='XIE6_MedicationReconciliationExternalMedications')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE6_MedicationReconciliationExternalMedications] ON [dbo].[MedicationReconciliationExternalMedications] 
		(
		UserDefinedMedicationId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('MedicationReconciliationExternalMedications') AND name='XIE6_MedicationReconciliationExternalMedications')
		PRINT '<<< CREATED INDEX MedicationReconciliationExternalMedications.XIE6_MedicationReconciliationExternalMedications >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX MedicationReconciliationExternalMedications.XIE6_MedicationReconciliationExternalMedications >>>', 16, 1)		
		END 
				
/* 
 * TABLE: MedicationReconciliationExternalMedications	 
 */
 
   
ALTER TABLE MedicationReconciliationExternalMedications ADD CONSTRAINT DocumentVersions_MedicationReconciliationExternalMedications_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)     
    
 
 ALTER TABLE MedicationReconciliationExternalMedications ADD CONSTRAINT MDMedications_MedicationReconciliationExternalMedications_FK
    FOREIGN KEY (StrengthId)
    REFERENCES MDMedications(MedicationId) 
    
ALTER TABLE MedicationReconciliationExternalMedications ADD CONSTRAINT MDMedicationNames_MedicationReconciliationExternalMedications_FK2
    FOREIGN KEY (MedicationNameId)
    REFERENCES MDMedicationNames(MedicationNameId) 
    
ALTER TABLE MedicationReconciliationExternalMedications ADD CONSTRAINT MDRoutes_MedicationReconciliationExternalMedications_FK
    FOREIGN KEY (RouteId)
    REFERENCES MDRoutes(RouteId) 
    
ALTER TABLE MedicationReconciliationExternalMedications ADD CONSTRAINT UserDefinedMedications_MedicationReconciliationExternalMedications_FK
    FOREIGN KEY (UserDefinedMedicationId)
    REFERENCES UserDefinedMedications(UserDefinedMedicationId) 
    
    
PRINT 'STEP 4(A) COMPLETED'
END	
 
---------------------------------------------------------------
--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 19.67)
BEGIN
Update SystemConfigurations set DataModelVersion=19.68
PRINT 'STEP 7 COMPLETED'
END
Go