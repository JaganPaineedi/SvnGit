----- STEP 1 ----------

------ STEP 2 ----------
--Part1 Begin
--Part1 Ends

--Part2 Begins


--Part2 Ends
-----End of Step 2 -------

------ STEP 3 ------------

------ END OF STEP 3 -----

------ STEP 4 ----------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentTransfers')
BEGIN
/* 
 * TABLE: CustomDocumentTransfers 
 */
 CREATE TABLE CustomDocumentTransfers( 
		DocumentVersionId						int					 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,	
		TransferringStaff						int					 NULL,
		ReceivingStaff							int					 NULL,
		ReceivingProgram						int					 NULL,
		TransferStatus							type_GlobalCode		 NULL,
		AssessedNeedForTransfer					type_Comment2		 NULL,		
		ClientParticpatedWithTransfer			type_YOrN			 NULL
												CHECK (ClientParticpatedWithTransfer in ('Y','N')),
		TransferSentDate						datetime			 NULL,
		ReceivingComment						type_Comment2		 NULL,
		ReceivingAction							type_GlobalCode		 NULL,
		ReceivingActionDate						datetime			 NULL,
		CONSTRAINT CustomDocumentTransfers_PK PRIMARY KEY CLUSTERED (DocumentVersionId) 
 )
 
 IF OBJECT_ID('CustomDocumentTransfers') IS NOT NULL
    PRINT '<<< CREATED TABLE  CustomDocumentTransfers >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE  CustomDocumentTransfers >>>', 16, 1)
/* 
 * TABLE:  CustomDocumentTransfers 
 */   
   
ALTER TABLE CustomDocumentTransfers ADD CONSTRAINT DocumentVersions_CustomDocumentTransfers_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)

ALTER TABLE CustomDocumentTransfers ADD CONSTRAINT Programs_CustomDocumentTransfers_FK
    FOREIGN KEY (ReceivingProgram)
    REFERENCES Programs(ProgramId) 
       
ALTER TABLE CustomDocumentTransfers ADD CONSTRAINT Staff_CustomDocumentTransfers_FK
    FOREIGN KEY (TransferringStaff)
    REFERENCES Staff(StaffId)
    
ALTER TABLE CustomDocumentTransfers ADD CONSTRAINT Staff_CustomDocumentTransfers_FK2
    FOREIGN KEY (ReceivingStaff)
    REFERENCES Staff(StaffId)          
            
     PRINT 'STEP 4(A) COMPLETED'
 END
 

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomTransferServices')
BEGIN
/* 
 * TABLE: CustomTransferServices 
 */
 CREATE TABLE CustomTransferServices( 
		TransferServiceId						int identity(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,	
		DocumentVersionId						int					 NULL,
		AuthorizationCodeId						int					 NULL,
		CONSTRAINT CustomTransferServices_PK PRIMARY KEY CLUSTERED (TransferServiceId) 
 )
 
 IF OBJECT_ID('CustomTransferServices') IS NOT NULL
    PRINT '<<< CREATED TABLE  CustomTransferServices >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE  CustomTransferServices >>>', 16, 1)
/* 
 * TABLE:  CustomDocumentTransferServices 
 */   
   
ALTER TABLE CustomTransferServices ADD CONSTRAINT DocumentVersions_CustomTransferServices_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
 
ALTER TABLE CustomTransferServices ADD CONSTRAINT AuthorizationCodes_CustomTransferServices_FK
    FOREIGN KEY (AuthorizationCodeId)
    REFERENCES AuthorizationCodes(AuthorizationCodeId)
        
     PRINT 'STEP 4(B) COMPLETED'
 END
		
---------------------------------------------------------------
--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF NOT EXISTS (SELECT [key] FROM SystemConfigurationKeys WHERE [key] = 'CDM_TransferDocument')
	BEGIN
		INSERT INTO SystemConfigurationKeys
				   (CreatedBy
				   ,CreateDate 
				   ,ModifiedBy
				   ,ModifiedDate
				   ,[Key]
				   ,Value
				   )
			 VALUES    
				   ('SHSDBA'
				   ,GETDATE()
				   ,'SHSDBA'
				   ,GETDATE()
				   ,'CDM_TransferDocument'
				   ,'1.0'
				   )
		PRINT 'STEP 7 COMPLETED'
	END
 GO
			