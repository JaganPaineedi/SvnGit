----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 16.61)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 16.61 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of Step 2 -------

------ STEP 3 ------------

------ End of STEP 3 ------------
------ STEP 4 ---------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='ClientDocumentAssignmentDocuments')
BEGIN
/*  
 * TABLE: ClientDocumentAssignmentDocuments 
 */
 CREATE TABLE ClientDocumentAssignmentDocuments(	
			ClientDocumentAssignmentDocumentId 		int	identity(1,1)		NOT NULL,
			CreatedBy								type_CurrentUser		NOT NULL,
			CreatedDate								type_CurrentDatetime	NOT NULL,
			ModifiedBy								type_CurrentUser		NOT NULL,
			ModifiedDate							type_CurrentDatetime	NOT NULL,
			RecordDeleted							type_YOrN				NULL
													CHECK (RecordDeleted in ('Y','N')),
			DeletedBy								type_UserId				NULL,
			DeletedDate								datetime				NULL,
			DocumentId								int						NULL,
			ClientDocumentAssignmentId				int						NULL,
			CONSTRAINT ClientDocumentAssignmentDocuments_PK PRIMARY KEY CLUSTERED (ClientDocumentAssignmentDocumentId)

 )
  IF OBJECT_ID('ClientDocumentAssignmentDocuments') IS NOT NULL
    PRINT '<<< CREATED TABLE ClientDocumentAssignmentDocuments >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE ClientDocumentAssignmentDocuments >>>', 16, 1)
    
  IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ClientDocumentAssignmentDocuments') AND name='XIE1_ClientDocumentAssignmentDocuments')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_ClientDocumentAssignmentDocuments] ON [dbo].[ClientDocumentAssignmentDocuments] 
		(
		DocumentId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ClientDocumentAssignmentDocuments') AND name='XIE1_ClientDocumentAssignmentDocuments')
		PRINT '<<< CREATED INDEX ClientDocumentAssignmentDocuments.XIE1_ClientDocumentAssignmentDocuments >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ClientDocumentAssignmentDocuments.XIE1_ClientDocumentAssignmentDocuments >>>', 16, 1)		
		END	 
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ClientDocumentAssignmentDocuments') AND name='XIE2_ClientDocumentAssignmentDocuments')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_ClientDocumentAssignmentDocuments] ON [dbo].[ClientDocumentAssignmentDocuments] 
		(
		ClientDocumentAssignmentId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ClientDocumentAssignmentDocuments') AND name='XIE2_ClientDocumentAssignmentDocuments')
		PRINT '<<< CREATED INDEX ClientDocumentAssignmentDocuments.XIE2_ClientDocumentAssignmentDocuments >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ClientDocumentAssignmentDocuments.XIE2_ClientDocumentAssignmentDocuments >>>', 16, 1)		
		END	 
		
/* 
 * TABLE: ClientDocumentAssignmentDocuments 
 */  
 		
ALTER TABLE ClientDocumentAssignmentDocuments ADD CONSTRAINT Documents_ClientDocumentAssignmentDocuments_FK 
    FOREIGN KEY (DocumentId)
    REFERENCES Documents(DocumentId)
    
ALTER TABLE ClientDocumentAssignmentDocuments ADD CONSTRAINT ClientDocumentAssignments_ClientDocumentAssignmentDocuments_FK 
    FOREIGN KEY (ClientDocumentAssignmentId)
    REFERENCES ClientDocumentAssignments(ClientDocumentAssignmentId)		
     			   			        
    PRINT 'STEP 4(A) COMPLETED'
END

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 16.61)
BEGIN
Update SystemConfigurations set DataModelVersion=16.62
PRINT 'STEP 7 COMPLETED'
END
Go

