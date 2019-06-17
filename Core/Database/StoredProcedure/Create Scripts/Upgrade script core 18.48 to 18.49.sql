----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.48)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.48 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
-------------------------------------------------------------

------ STEP 3 ------------

--END Of STEP 3------------
------ STEP 4 ----------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='AssociateDocuments')
 BEGIN
/* 
 * TABLE: AssociateDocuments 
 */
CREATE TABLE AssociateDocuments(
    AssociateDocumentId							int	identity(1,1)		NOT NULL,
    CreatedBy									type_CurrentUser		NOT NULL,
    CreatedDate									type_CurrentDatetime    NOT NULL,
    ModifiedBy									type_CurrentUser        NOT NULL,
    ModifiedDate								type_CurrentDatetime    NOT NULL,
    RecordDeleted								type_YOrN               NULL
												CHECK (RecordDeleted in ('Y','N')),
    DeletedBy									type_UserId              NULL,
	DeletedDate									datetime                 NULL, 
	ClientId									int						 NULL,		
	NativeDocumentId							int						 NULL,
	NativeImageRecordId							int						 NULL,				
	DocumentId									int						 NULL,		
	CONSTRAINT AssociateDocuments_PK PRIMARY KEY CLUSTERED (AssociateDocumentId) 
 )
 
 IF OBJECT_ID('AssociateDocuments') IS NOT NULL
    PRINT '<<< CREATED TABLE  AssociateDocuments >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE AssociateDocuments >>>', 16, 1)
    
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('AssociateDocuments') AND name='XIE1_AssociateDocuments')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_AssociateDocuments] ON [dbo].[AssociateDocuments] 
		(
		ClientId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('AssociateDocuments') AND name='XIE1_AssociateDocuments')
		PRINT '<<< CREATED INDEX AssociateDocuments.XIE1_AssociateDocuments >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX AssociateDocuments.XIE1_AssociateDocuments >>>', 16, 1)		
		END	
		
   
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('AssociateDocuments') AND name='XIE2_AssociateDocuments')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_AssociateDocuments] ON [dbo].[AssociateDocuments] 
		(
		NativeDocumentId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('AssociateDocuments') AND name='XIE2_AssociateDocuments')
		PRINT '<<< CREATED INDEX AssociateDocuments.XIE2_AssociateDocuments >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX AssociateDocuments.XIE2_AssociateDocuments >>>', 16, 1)		
		END	
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('AssociateDocuments') AND name='XIE3_AssociateDocuments')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE3_AssociateDocuments] ON [dbo].[AssociateDocuments] 
		(
		DocumentId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('AssociateDocuments') AND name='XIE3_AssociateDocuments')
		PRINT '<<< CREATED INDEX AssociateDocuments.XIE3_AssociateDocuments >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX AssociateDocuments.XIE3_AssociateDocuments >>>', 16, 1)		
		END	
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('AssociateDocuments') AND name='XIE4_AssociateDocuments')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE4_AssociateDocuments] ON [dbo].[AssociateDocuments] 
		(
		NativeImageRecordId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('AssociateDocuments') AND name='XIE4_AssociateDocuments')
		PRINT '<<< CREATED INDEX AssociateDocuments.XIE4_AssociateDocuments >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX AssociateDocuments.XIE4_AssociateDocuments >>>', 16, 1)		
		END	
		

/* 
 * TABLE:  AssociateDocuments 
 */   
   
ALTER TABLE AssociateDocuments ADD CONSTRAINT Clients_AssociateDocuments_FK
    FOREIGN KEY (ClientId)
    REFERENCES Clients(ClientId)
    
   
ALTER TABLE AssociateDocuments ADD CONSTRAINT Documents_AssociateDocuments_FK
    FOREIGN KEY (NativeDocumentId)
    REFERENCES Documents(DocumentId)
    
ALTER TABLE AssociateDocuments ADD CONSTRAINT ImageRecodes_AssociateDocuments_FK
    FOREIGN KEY (NativeImageRecordId)
    REFERENCES ImageRecords(ImageRecordId)
    
ALTER TABLE AssociateDocuments ADD CONSTRAINT Documents_AssociateDocuments_FK2
    FOREIGN KEY (DocumentId)
    REFERENCES Documents(DocumentId)

     PRINT 'STEP 4(A) COMPLETED'
 END  
------END Of STEP 4---------------

------ STEP 5 ----------------

-------END STEP 5-------------
------ STEP 6  ----------

----END Of STEP 6 ------------

------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 18.48)
BEGIN
Update SystemConfigurations set DataModelVersion=18.49
PRINT 'STEP 7 COMPLETED'
END
Go
