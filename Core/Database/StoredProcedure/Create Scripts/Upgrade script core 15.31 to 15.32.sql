----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.31)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.31 for update.Upgrade Script Failed.>>>', 16, 1)
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
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='LabSoftOrganizations')
BEGIN
/*  
 * TABLE: LabSoftOrganizations 
 */
 CREATE TABLE LabSoftOrganizations( 
		LabSoftOrganizationId			int	identity(1,1)	 NOT NULL,
		CreatedBy						type_CurrentUser     NOT NULL,
		CreatedDate						type_CurrentDatetime NOT NULL,
		ModifiedBy						type_CurrentUser     NOT NULL,
		ModifiedDate					type_CurrentDatetime NOT NULL,
		RecordDeleted					type_YOrN			 NULL
										CHECK (RecordDeleted in ('Y','N')),
		DeletedBy						type_UserId          NULL,
		DeletedDate						datetime             NULL,
		LabSoftOrganizationName			varchar(500)		 NULL,
		LabSoftCustomerId				varchar(500)		 NULL,			
		CONSTRAINT LabSoftOrganizations_PK PRIMARY KEY CLUSTERED (LabSoftOrganizationId)
)
IF OBJECT_ID('LabSoftOrganizations') IS NOT NULL
    PRINT '<<< CREATED TABLE LabSoftOrganizations >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE LabSoftOrganizations >>>', 16, 1)
    
/* 
 * TABLE: LabSoftOrganizations 
 */   

 PRINT 'STEP 4(A) COMPLETED' 
END
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='LabSoftServiceAuthentications')
BEGIN
/*  
 * TABLE: LabSoftServiceAuthentications 
 */
 CREATE TABLE LabSoftServiceAuthentications( 
		LabSoftServiceAuthenticationId			int	identity(1,1)		NOT NULL,
		CreatedBy								type_CurrentUser		NOT NULL,
		CreatedDate								type_CurrentDatetime	NOT NULL,
		ModifiedBy								type_CurrentUser		NOT NULL,
		ModifiedDate							type_CurrentDatetime	NOT NULL,
		RecordDeleted							type_YOrN				NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId				NULL,
		DeletedDate								datetime				NULL,
		LabSoftOrganizationId					int						NULL,	
		AuthenticationKey						varchar(500)			NULL,
		AuthenticationSecret					varchar(500)			NULL,		
		CONSTRAINT LabSoftServiceAuthentications_PK PRIMARY KEY CLUSTERED (LabSoftServiceAuthenticationId)
)
IF OBJECT_ID('LabSoftServiceAuthentications') IS NOT NULL
    PRINT '<<< CREATED TABLE LabSoftServiceAuthentications >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE LabSoftServiceAuthentications >>>', 16, 1)
    
/* 
 * TABLE: LabSoftServiceAuthentications 
 */   
    
ALTER TABLE LabSoftServiceAuthentications ADD CONSTRAINT LabSoftOrganizations_LabSoftServiceAuthentications_FK
    FOREIGN KEY (LabSoftOrganizationId)
    REFERENCES LabSoftOrganizations(LabSoftOrganizationId)    

 PRINT 'STEP 4(B) COMPLETED' 
END
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='LabSoftOrganizationConfigurations')
BEGIN
/*  
 * TABLE: LabSoftOrganizationConfigurations 
 */
 CREATE TABLE LabSoftOrganizationConfigurations( 
		LabSoftOrganizationConfigurationId		int	identity(1,1)		NOT NULL,
		CreatedBy								type_CurrentUser		NOT NULL,
		CreatedDate								type_CurrentDatetime	NOT NULL,
		ModifiedBy								type_CurrentUser		NOT NULL,
		ModifiedDate							type_CurrentDatetime	NOT NULL,
		RecordDeleted							type_YOrN				NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId				NULL,
		DeletedDate								datetime				NULL,
		LabSoftOrganizationId					int						NULL,	
		EMRKey									varchar(500)			NULL,
		LabSoftCustomerId						varchar(500)			NULL,	
		OrdersServiceUrl						varchar(max)			NULL,
		TestsServiceUrl							varchar(max)			NULL,
		QuestionsServiceUrl						varchar(max)			NULL,								
		CONSTRAINT LabSoftOrganizationConfigurations_PK PRIMARY KEY CLUSTERED (LabSoftOrganizationConfigurationId)
)
IF OBJECT_ID('LabSoftOrganizationConfigurations') IS NOT NULL
    PRINT '<<< CREATED TABLE LabSoftOrganizationConfigurations >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE LabSoftOrganizationConfigurations >>>', 16, 1)
    
/* 
 * TABLE: LabSoftOrganizationConfigurations 
 */   
    
ALTER TABLE LabSoftOrganizationConfigurations ADD CONSTRAINT LabSoftOrganizations_LabSoftOrganizationConfigurations_FK
    FOREIGN KEY (LabSoftOrganizationId)
    REFERENCES LabSoftOrganizations(LabSoftOrganizationId)
    

 PRINT 'STEP 4(C) COMPLETED' 
END

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='LabSoftMessages')
BEGIN
/*  
 * TABLE: LabSoftMessages 
 */
 CREATE TABLE LabSoftMessages( 
		LabSoftMessageId						int	identity(1,1)		NOT NULL,
		CreatedBy								type_CurrentUser		NOT NULL,
		CreatedDate								type_CurrentDatetime	NOT NULL,
		ModifiedBy								type_CurrentUser		NOT NULL,
		ModifiedDate							type_CurrentDatetime	NOT NULL,
		RecordDeleted							type_YOrN				NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId				NULL,
		DeletedDate								datetime				NULL,
		ClientOrderId							int						NULL,
		TransactionId							int						NULL,
		AccessionId								int						NULL,	
		CustomerId								varchar(500)			NULL,
		MessageId								int						NULL,
		RequestMessage							varchar(max)			NULL,
		ResultMessage							varchar(max)			NULL,
		MessageProcessingState					type_GlobalCode			NULL,
		MessageStatus							type_GlobalCode			NULL,
		ErrorDescription						nvarchar(max)			NULL,
		ReportByte								image					NULL,
		ReportType								varchar(500)			NULL,
		ResultMessageXML						xml						NULL,
		CONSTRAINT LabSoftMessages_PK PRIMARY KEY CLUSTERED (LabSoftMessageId)
)
IF OBJECT_ID('LabSoftMessages') IS NOT NULL
    PRINT '<<< CREATED TABLE LabSoftMessages >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE LabSoftMessages >>>', 16, 1)
    
/* 
 * TABLE: LabSoftMessages 
 */   
    
ALTER TABLE LabSoftMessages ADD CONSTRAINT ClientOrders_LabSoftMessages_FK
    FOREIGN KEY (ClientOrderId)
    REFERENCES ClientOrders(ClientOrderId)
    

 PRINT 'STEP 4(D) COMPLETED' 
END
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='LabSoftMessageLinks')
BEGIN
/*  
 * TABLE: LabSoftMessageLinks 
 */
 CREATE TABLE LabSoftMessageLinks( 
		LabSoftMessageLinkId			int	identity(1,1)		NOT NULL,
		CreatedBy						type_CurrentUser		NOT NULL,
		CreatedDate						type_CurrentDatetime	NOT NULL,
		ModifiedBy						type_CurrentUser		NOT NULL,
		ModifiedDate					type_CurrentDatetime	NOT NULL,
		RecordDeleted					type_YOrN				NULL
										CHECK (RecordDeleted in ('Y','N')),
		DeletedBy						type_UserId				NULL,
		DeletedDate						datetime				NULL,
		LabSoftMessageId				int						NULL,
		EntityType						type_GlobalCode			NULL,
		EntityId						int						NULL,
		CONSTRAINT LabSoftMessageLinks_PK PRIMARY KEY CLUSTERED (LabSoftMessageLinkId)
)
IF OBJECT_ID('LabSoftMessageLinks') IS NOT NULL
    PRINT '<<< CREATED TABLE LabSoftMessageLinks >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE LabSoftMessageLinks >>>', 16, 1)
    
/* 
 * TABLE: LabSoftMessageLinks 
 */   
    
ALTER TABLE LabSoftMessageLinks ADD CONSTRAINT LabSoftMessages_LabSoftMessageLinks_FK
    FOREIGN KEY (LabSoftMessageId)
    REFERENCES LabSoftMessages(LabSoftMessageId)
    

 PRINT 'STEP 4(E) COMPLETED' 
END
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='LabSoftEventLog')
BEGIN
/*  
 * TABLE: LabSoftEventLog 
 */
 CREATE TABLE LabSoftEventLog( 
		LabSoftEventLogId				int	identity(1,1)		NOT NULL,
		CreatedBy						type_CurrentUser		NOT NULL,
		CreatedDate						type_CurrentDatetime	NOT NULL,
		ModifiedBy						type_CurrentUser		NOT NULL,
		ModifiedDate					type_CurrentDatetime	NOT NULL,
		RecordDeleted					type_YOrN				NULL
										CHECK (RecordDeleted in ('Y','N')),
		DeletedBy						type_UserId				NULL,
		DeletedDate						datetime				NULL,
		LabSoftMessageId				int						NULL,
		ErrorMessage					nvarchar(max)			NULL,
		VerboseInfo						nvarchar(max)			NULL,
		ErrorType						type_GlobalCode			NULL,
		CONSTRAINT LabSoftEventLog_PK PRIMARY KEY CLUSTERED (LabSoftEventLogId)
)
IF OBJECT_ID('LabSoftEventLog') IS NOT NULL
    PRINT '<<< CREATED TABLE LabSoftEventLog >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE LabSoftEventLog >>>', 16, 1)
    
/* 
 * TABLE: LabSoftEventLog 
 */   
    
ALTER TABLE LabSoftEventLog ADD CONSTRAINT LabSoftMessages_LabSoftEventLog_FK
    FOREIGN KEY (LabSoftMessageId)
    REFERENCES LabSoftMessages(LabSoftMessageId)
    

 PRINT 'STEP 4(F) COMPLETED' 
END

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='LabSoftMessageHistory')
BEGIN
/*  
 * TABLE: LabSoftMessageHistory 
 */
 CREATE TABLE LabSoftMessageHistory( 
		LabSoftMessageHistoryId			int	identity(1,1)		NOT NULL,
		CreatedBy						type_CurrentUser		NOT NULL,
		CreatedDate						type_CurrentDatetime	NOT NULL,
		ModifiedBy						type_CurrentUser		NOT NULL,
		ModifiedDate					type_CurrentDatetime	NOT NULL,
		RecordDeleted					type_YOrN				NULL
										CHECK (RecordDeleted in ('Y','N')),
		DeletedBy						type_UserId				NULL,
		DeletedDate						datetime				NULL,
		LabSoftMessageId				int						NULL,
		ClientOrderId					int						NULL,
		TransactionId					int						NULL,
		AccessionId						int						NULL,	
		CustomerId						varchar(500)			NULL,
		MessageId						int						NULL,
		RequestMessage					varchar(max)			NULL,
		ResultMessage					varchar(max)			NULL,
		MessageProcessingState			type_GlobalCode			NULL,
		MessageStatus					type_GlobalCode			NULL,
		ErrorDescription				nvarchar(max)			NULL,
		ReportByte						image					NULL,
		ReportType						varchar(500)			NULL,
		ResultMessageXML				xml						NULL,
		CONSTRAINT LabSoftMessageHistory_PK PRIMARY KEY CLUSTERED (LabSoftMessageHistoryId)
)
IF OBJECT_ID('LabSoftMessageHistory') IS NOT NULL
    PRINT '<<< CREATED TABLE LabSoftMessageHistory >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE LabSoftMessageHistory >>>', 16, 1)
    
/* 
 * TABLE: LabSoftMessageHistory 
 */   
    
ALTER TABLE LabSoftMessageHistory ADD CONSTRAINT LabSoftMessages_LabSoftMessageHistory_FK
    FOREIGN KEY (LabSoftMessageId)
    REFERENCES LabSoftMessages(LabSoftMessageId)
    
ALTER TABLE LabSoftMessageHistory ADD CONSTRAINT ClientOrders_LabSoftMessageHistory_FK
    FOREIGN KEY (ClientOrderId)
    REFERENCES ClientOrders(ClientOrderId)
    
    
 PRINT 'STEP 4(G) COMPLETED' 
END
--END Of STEP 4 ------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.31)
BEGIN
Update SystemConfigurations set DataModelVersion=15.32
PRINT 'STEP 7 COMPLETED'
END
Go
