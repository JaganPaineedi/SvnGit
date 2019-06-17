----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.72)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.72 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
-------------------------------------------------------------

------ STEP 3 ------------

--END Of STEP 3------------
------ STEP 4 ----------
IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='ProgressNoteAddOnCodes')
BEGIN
/*		  
 * TABLE: ProgressNoteAddOnCodes
 */ 
CREATE TABLE ProgressNoteAddOnCodes(
		 ProgressNoteAddOnCodeId				 	int identity(1,1)		NOT NULL,
		 CreatedBy									type_CurrentUser		NOT NULL,
		 CreatedDate								type_CurrentDatetime	NOT NULL,
		 ModifiedBy									type_CurrentUser		NOT NULL,
		 ModifiedDate								type_CurrentDatetime	NOT NULL,
		 RecordDeleted								type_YOrN				NULL
													CHECK (RecordDeleted in ('Y','N')),
		 DeletedBy									type_UserId				NULL,
		 DeletedDate								datetime				NULL,
		 DocumentVersionId							int						NULL,
		 AddOnProcedureCodeId						int						NULL,
		 AddOnServiceId								int						NULL,
		 AddOnProcedureCodeStartTime				datetime				NULL,
		 AddOnProcedureCodeUnit						decimal(18,2)			NULL,
		 AddOnProcedureCodeUnitType					type_GlobalCode			NULL,
		 CONSTRAINT ProgressNoteAddOnCodes_PK PRIMARY KEY CLUSTERED (ProgressNoteAddOnCodeId) 
) 

 IF OBJECT_ID('ProgressNoteAddOnCodes') IS NOT NULL
    PRINT '<<< CREATED TABLE ProgressNoteAddOnCodes >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE ProgressNoteAddOnCodes >>>', 16, 1)
    
    
 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ProgressNoteAddOnCodes') AND name='XIE1_ProgressNoteAddOnCodes')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_ProgressNoteAddOnCodes] ON [dbo].[ProgressNoteAddOnCodes] 
		(
		DocumentVersionId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ProgressNoteAddOnCodes') AND name='XIE1_ProgressNoteAddOnCodes')
		PRINT '<<< CREATED INDEX ProgressNoteAddOnCodes.XIE1_ProgressNoteAddOnCodes >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ProgressNoteAddOnCodes.XIE1_ProgressNoteAddOnCodes >>>', 16, 1)		
		END	
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ProgressNoteAddOnCodes') AND name='XIE2_ProgressNoteAddOnCodes')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_ProgressNoteAddOnCodes] ON [dbo].[ProgressNoteAddOnCodes] 
		(
		AddOnProcedureCodeId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ProgressNoteAddOnCodes') AND name='XIE2_ProgressNoteAddOnCodes')
		PRINT '<<< CREATED INDEX ProgressNoteAddOnCodes.XIE2_ProgressNoteAddOnCodes >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ProgressNoteAddOnCodes.XIE2_ProgressNoteAddOnCodes >>>', 16, 1)		
		END	 
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ProgressNoteAddOnCodes') AND name='XIE3_ProgressNoteAddOnCodes')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE3_ProgressNoteAddOnCodes] ON [dbo].[ProgressNoteAddOnCodes] 
		(
		AddOnServiceId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ProgressNoteAddOnCodes') AND name='XIE3_ProgressNoteAddOnCodes')
		PRINT '<<< CREATED INDEX ProgressNoteAddOnCodes.XIE3_ProgressNoteAddOnCodes >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ProgressNoteAddOnCodes.XIE3_ProgressNoteAddOnCodes >>>', 16, 1)		
		END	  
    
/* 
 * TABLE: ProgressNoteAddOnCodes 
 */ 
 
 ALTER TABLE ProgressNoteAddOnCodes ADD CONSTRAINT DocumentVersions_ProgressNoteAddOnCodes_FK
	FOREIGN KEY (DocumentVersionId)
	REFERENCES DocumentVersions(DocumentVersionId) 
        
 ALTER TABLE ProgressNoteAddOnCodes ADD CONSTRAINT ProcedureCodes_ProgressNoteAddOnCodes_FK
	FOREIGN KEY (AddOnProcedureCodeId)
	REFERENCES ProcedureCodes(ProcedureCodeId) 
	
        
 ALTER TABLE ProgressNoteAddOnCodes ADD CONSTRAINT Services_ProgressNoteAddOnCodes_FK
	FOREIGN KEY (AddOnServiceId)
	REFERENCES Services(ServiceId) 
	
PRINT 'STEP 4(A) COMPLETED'
END
------END Of STEP 4---------------

------ STEP 5 ----------------

-------END STEP 5-------------
------ STEP 6  ----------

----END Of STEP 6 ------------

------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 18.72)
BEGIN
Update SystemConfigurations set DataModelVersion=18.73
PRINT 'STEP 7 COMPLETED'
END
Go
