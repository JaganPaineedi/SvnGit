----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.43)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.43 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
-------------------------------------------------------------

------ STEP 3 ------------

--END Of STEP 3------------
------ STEP 4 ----------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='DirectAccounts')
 BEGIN
/* 
 * TABLE: DirectAccounts 
 */
CREATE TABLE DirectAccounts(
    DirectAccountId								int	identity(1,1)		NOT NULL,
    CreatedBy									type_CurrentUser		NOT NULL,
    CreatedDate									type_CurrentDatetime    NOT NULL,
    ModifiedBy									type_CurrentUser        NOT NULL,
    ModifiedDate								type_CurrentDatetime    NOT NULL,
    RecordDeleted								type_YOrN               NULL
												CHECK (RecordDeleted in ('Y','N')),
    DeletedBy									type_UserId              NULL,
	DeletedDate									datetime                 NULL, 
	StaffId										int						 NULL,			--Foreign Key to Staff.StaffId
	DirectFirstName								varchar(500)			 NULL,
	DirectLastName								varchar(500)			 NULL,
	DirectEmailAddress							varchar(500)			 NULL,
	DirectPassword								varchar(500)			 NULL,
	DirectAlternativeEmail						varchar(500)			 NULL,
	DirectDescription							varchar(max)			 NULL,	
	CONSTRAINT DirectAccounts_PK PRIMARY KEY CLUSTERED (DirectAccountId) 
 )
 
 IF OBJECT_ID('DirectAccounts') IS NOT NULL
    PRINT '<<< CREATED TABLE  DirectAccounts >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE DirectAccounts >>>', 16, 1)
    
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('DirectAccounts') AND name='XIE1_DirectAccounts')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_DirectAccounts] ON [dbo].[DirectAccounts] 
		(
		StaffId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('DirectAccounts') AND name='XIE1_DirectAccounts')
		PRINT '<<< CREATED INDEX DirectAccounts.XIE1_DirectAccounts >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX DirectAccounts.XIE1_DirectAccounts >>>', 16, 1)		
		END	 
       
/* 
 * TABLE:  DirectAccounts 
 */   
   
ALTER TABLE DirectAccounts ADD CONSTRAINT Staff_DirectAccounts_FK
    FOREIGN KEY (StaffId)
    REFERENCES Staff(StaffId)
    
     PRINT 'STEP 4(A) COMPLETED'
 END 
 
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='DirectAccountImportRules')
 BEGIN
/* 
 * TABLE: DirectAccountImportRules 
 */
CREATE TABLE DirectAccountImportRules(
    DirectMessageImportRuleId					int	identity(1,1)		NOT NULL,
    CreatedBy									type_CurrentUser		NOT NULL,
    CreatedDate									type_CurrentDatetime    NOT NULL,
    ModifiedBy									type_CurrentUser        NOT NULL,
    ModifiedDate								type_CurrentDatetime    NOT NULL,
    RecordDeleted								type_YOrN               NULL
												CHECK (RecordDeleted in ('Y','N')),
    DeletedBy									type_UserId              NULL,
	DeletedDate									datetime                 NULL, 
	DirectAccountId								int						 NOT NULL, --Foreign Key to DirectAccounts.DirectAccountId
	EmailFrom									varchar(1000)			 NULL,
	StoredProcedure							    varchar(1000)			 NULL,
	Active									    type_YOrN	DEFAULT 'Y'	 NOT NULL 
											    CHECK (Active in ('Y','N')),	
	AttachmentType							    type_GlobalCode			NULL,
	CONSTRAINT DirectAccountImportRules_PK PRIMARY KEY CLUSTERED (DirectMessageImportRuleId) 
 )
 
 IF OBJECT_ID('DirectAccountImportRules') IS NOT NULL
    PRINT '<<< CREATED TABLE  DirectAccountImportRules >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE DirectAccountImportRules >>>', 16, 1)
    
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('DirectAccountImportRules') AND name='XIE1_DirectAccountImportRules')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_DirectAccountImportRules] ON [dbo].[DirectAccountImportRules] 
		(
		DirectAccountId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('DirectAccountImportRules') AND name='XIE1_DirectAccountImportRules')
		PRINT '<<< CREATED INDEX DirectAccountImportRules.XIE1_DirectAccountImportRules >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX DirectAccountImportRules.XIE1_DirectAccountImportRules >>>', 16, 1)		
		END	 
       
/* 
 * TABLE:  DirectAccountImportRules 
 */   
   
ALTER TABLE DirectAccountImportRules ADD CONSTRAINT DirectAccounts_DirectAccountImportRules_FK
    FOREIGN KEY (DirectAccountId)
    REFERENCES DirectAccounts(DirectAccountId)
    
     PRINT 'STEP 4(B) COMPLETED'
 END 



IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='DirectMessages')
 BEGIN
/* 
 * TABLE: DirectMessages 
 */
CREATE TABLE DirectMessages(
    DirectMessageId								int	identity(1,1)		NOT NULL,
    CreatedBy									type_CurrentUser		NOT NULL,
    CreatedDate									type_CurrentDatetime    NOT NULL,
    ModifiedBy									type_CurrentUser        NOT NULL,
    ModifiedDate								type_CurrentDatetime    NOT NULL,
    RecordDeleted								type_YOrN               NULL
												CHECK (RecordDeleted in ('Y','N')),
    DeletedBy									type_UserId              NULL,
	DeletedDate									datetime                 NULL, 
	ClientDisclosureId							INT						 NULL, --Foreign Key to ClientDisclosures.ClientDisclosureId
	DirectAccountId								int						NOT NULL,
	StaffId										INT						NOT NULL,
	MessageType									CHAR(1)					NOT NULL			 --(I)ncoming, (O)utgoing
												CHECK (MessageType in ('I','O')),
	MessageId									VARCHAR(1000)			NULL, --HISPDirect Id
	MessageFrom									VARCHAR(1000)			NULL,
	MessageInReplyTo							VARCHAR(1000)			NULL,
	MessageSubject								VARCHAR(MAX)			NULL,
	MessageBody									VARCHAR(MAX)			NULL,
	MessageBodyMimeType							VARCHAR(500)			NULL,
	MessageState								VARCHAR(25)				NULL, --Pass, Fail, Error
	MessageDescription							VARCHAR(500)			NULL, --Description State
	MessageReceivedDate							DATETIME				NULL,
	MessageSentDate								DATETIME				NULL,
	MessageUid									VARCHAR(1000)			NULL, -- string of IMAP message id
	StaffDirectMessageEmail						VARCHAR(1000)			NULL,
	MessageStatus								type_GlobalCode			NOT NULL,
	MessageTo									VARCHAR(MAX)			NULL,
	MessageCC									VARCHAR(MAX)			NULL,
	MessageBCC									VARCHAR(MAX)			NULL,
	MessageRead									type_YorN DEFAULT 'N'	NOT NULL 
												CHECK (MessageRead in ('Y','N')),
	CONSTRAINT DirectMessages_PK PRIMARY KEY CLUSTERED (DirectMessageId) 
 )
 
 IF OBJECT_ID('DirectMessages') IS NOT NULL
    PRINT '<<< CREATED TABLE  DirectMessages >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE DirectMessages >>>', 16, 1)
    
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('DirectMessages') AND name='XIE1_DirectMessages')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_DirectMessages] ON [dbo].[DirectMessages] 
		(
		ClientDisclosureId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('DirectMessages') AND name='XIE1_DirectMessages')
		PRINT '<<< CREATED INDEX DirectMessages.XIE1_DirectMessages >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX DirectMessages.XIE1_DirectMessages >>>', 16, 1)		
		END	 
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('DirectMessages') AND name='XIE2_DirectMessages')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_DirectMessages] ON [dbo].[DirectMessages] 
		(
		DirectAccountId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('DirectMessages') AND name='XIE2_DirectMessages')
		PRINT '<<< CREATED INDEX DirectMessages.XIE2_DirectMessages >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX DirectMessages.XIE2_DirectMessages >>>', 16, 1)		
		END	 
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('DirectMessages') AND name='XIE3_DirectMessages')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE3_DirectMessages] ON [dbo].[DirectMessages] 
		(
		StaffId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('DirectMessages') AND name='XIE3_DirectMessages')
		PRINT '<<< CREATED INDEX DirectMessages.XIE3_DirectMessages >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX DirectMessages.XIE3_DirectMessages >>>', 16, 1)		
		END	 
		
       
/* 
 * TABLE:  DirectMessages 
 */   
   
ALTER TABLE DirectMessages ADD CONSTRAINT ClientDisclosures_DirectMessages_FK
    FOREIGN KEY (ClientDisclosureId)
    REFERENCES ClientDisclosures(ClientDisclosureId)
    
ALTER TABLE DirectMessages ADD CONSTRAINT DirectAccounts_DirectMessages_FK
    FOREIGN KEY (DirectAccountId)
    REFERENCES DirectAccounts(DirectAccountId)  
    
ALTER TABLE DirectMessages ADD CONSTRAINT Staff_DirectMessages_FK
    FOREIGN KEY (StaffId)
    REFERENCES Staff(StaffId)  
 
 EXEC sys.sp_addextendedproperty 'DirectMessages_Description'
	,'MessageType cloumn Stores I or O. -(I)ncoming, (O)utgoing'
	,'schema'
	,'dbo'
	,'table'
	,'DirectMessages'
	,'column'
	,'MessageType'
	
EXEC sys.sp_addextendedproperty 'DirectMessages_Description'
	,'MessageId cloumn Stores HISPDirect Id'
	,'schema'
	,'dbo'
	,'table'
	,'DirectMessages'
	,'column'
	,'MessageId'
	
EXEC sys.sp_addextendedproperty 'DirectMessages_Description'
	,'MessageState cloumn Stores Pass, Fail, Error'
	,'schema'
	,'dbo'
	,'table'
	,'DirectMessages'
	,'column'
	,'MessageState'
	
EXEC sys.sp_addextendedproperty 'DirectMessages_Description'
	,'MessageDescription  cloumn Stores string of IMAP message id'
	,'schema'
	,'dbo'
	,'table'
	,'DirectMessages'
	,'column'
	,'MessageDescription '
    
     PRINT 'STEP 4(C) COMPLETED'
 END 
 
 
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='DirectMessageAttachments')
 BEGIN
/* 
 * TABLE: DirectMessageAttachments 
 */
CREATE TABLE DirectMessageAttachments(
    DirectMessageAttachmentId 					int	identity(1,1)		NOT NULL,
    CreatedBy									type_CurrentUser		NOT NULL,
    CreatedDate									type_CurrentDatetime    NOT NULL,
    ModifiedBy									type_CurrentUser        NOT NULL,
    ModifiedDate								type_CurrentDatetime    NOT NULL,
    RecordDeleted								type_YOrN               NULL
												CHECK (RecordDeleted in ('Y','N')),
    DeletedBy									type_UserId              NULL,
	DeletedDate									datetime                 NULL, 
	DirectMessageId 							INT						 NULL, --Foreign Key to DirectMessages.DirectMessageId
	AttachmentId								VARCHAR(1000)			 NULL, --HISPDirect Attachment Id
	AttachmentMimeType							VARCHAR(500)			 NULL,
	AttachmentState								VARCHAR(100)			 NULL,
	AttachmentDescription						VARCHAR(1000)			 NULL,
	AttachmentName								VARCHAR(500)			 NULL,
	AttachmentSentDate							DATETIME				 NULL,
	AttachmentReceivedDate						DATETIME				 NULL,
	Attachment									VARBINARY(MAX)			 NULL,
	CONSTRAINT DirectMessageAttachments_PK PRIMARY KEY CLUSTERED (DirectMessageAttachmentId) 
 )
 
 IF OBJECT_ID('DirectMessageAttachments') IS NOT NULL
    PRINT '<<< CREATED TABLE  DirectMessageAttachments >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE DirectMessageAttachments >>>', 16, 1)
    
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('DirectMessageAttachments') AND name='XIE1_DirectMessageAttachments')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_DirectMessageAttachments] ON [dbo].[DirectMessageAttachments] 
		(
		DirectMessageId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('DirectMessageAttachments') AND name='XIE1_DirectMessageAttachments')
		PRINT '<<< CREATED INDEX DirectMessageAttachments.XIE1_DirectMessageAttachments >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX DirectMessageAttachments.XIE1_DirectMessageAttachments >>>', 16, 1)		
		END	 
		
       
/* 
 * TABLE:  DirectMessageAttachments 
 */   
   
ALTER TABLE DirectMessageAttachments ADD CONSTRAINT DirectMessages_DirectMessageAttachments_FK
    FOREIGN KEY (DirectMessageId)
    REFERENCES DirectMessages(DirectMessageId) 
 
EXEC sys.sp_addextendedproperty 'DirectMessageAttachments_Description'
	,'AttachmentId  cloumn Stores HISPDirect Attachment Id'
	,'schema'
	,'dbo'
	,'table'
	,'DirectMessageAttachments'
	,'column'
	,'AttachmentId '    
     PRINT 'STEP 4(D) COMPLETED'
 END 
 
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='DirectAccountLog')
 BEGIN
/* 
 * TABLE: DirectAccountLog 
 */
CREATE TABLE DirectAccountLog(
    DirectAccountLogId		 					int	identity(1,1)		NOT NULL,
    CreatedBy									type_CurrentUser		NOT NULL,
    CreatedDate									type_CurrentDatetime    NOT NULL,
    ModifiedBy									type_CurrentUser        NOT NULL,
    ModifiedDate								type_CurrentDatetime    NOT NULL,
    RecordDeleted								type_YOrN               NULL
												CHECK (RecordDeleted in ('Y','N')),
    DeletedBy									type_UserId              NULL,
	DeletedDate									datetime                 NULL, 
	DirectAccountId 							int						 NOT NULL, 
	StaffId										int						 NOT NULL,
	DirectFirstName								varchar(500)			 NULL,
	DirectLastName								varchar(500)			 NULL,
	DirectEmailAddress							varchar(500)			 NULL,
	DirectPassword								varchar(500)			 NULL,
	DirectAlternativeEmail						varchar(500)			 NULL,
	DirectDescription							varchar(max)			 NULL,
	CONSTRAINT DirectAccountLog_PK PRIMARY KEY CLUSTERED (DirectAccountLogId) 
 )
 
 IF OBJECT_ID('DirectAccountLog') IS NOT NULL
    PRINT '<<< CREATED TABLE  DirectAccountLog >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE DirectAccountLog >>>', 16, 1)
    
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('DirectAccountLog') AND name='XIE1_DirectAccountLog')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_DirectAccountLog] ON [dbo].[DirectAccountLog] 
		(
		DirectAccountId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('DirectAccountLog') AND name='XIE1_DirectAccountLog')
		PRINT '<<< CREATED INDEX DirectAccountLog.XIE1_DirectAccountLog >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX DirectAccountLog.XIE1_DirectAccountLog >>>', 16, 1)		
		END	 
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('DirectAccountLog') AND name='XIE2_DirectAccountLog')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_DirectAccountLog] ON [dbo].[DirectAccountLog] 
		(
		StaffId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('DirectAccountLog') AND name='XIE2_DirectAccountLog')
		PRINT '<<< CREATED INDEX DirectAccountLog.XIE2_DirectAccountLog >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX DirectAccountLog.XIE2_DirectAccountLog >>>', 16, 1)		
		END	 
		
       
/* 
 * TABLE:  DirectAccountLog 
 */   
   
ALTER TABLE DirectAccountLog ADD CONSTRAINT DirectAccounts_DirectAccountLog_FK
    FOREIGN KEY (DirectAccountId)
    REFERENCES DirectAccounts(DirectAccountId) 
    
ALTER TABLE DirectAccountLog ADD CONSTRAINT Staff_DirectAccountLog_FK
    FOREIGN KEY (StaffId)
    REFERENCES Staff(StaffId) 
 
PRINT 'STEP 4(E) COMPLETED'

 END 
 
 
------END Of STEP 4---------------

------ STEP 5 ----------------

-------END STEP 5-------------
------ STEP 6  ----------

----END Of STEP 6 ------------

------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 18.43)
BEGIN
Update SystemConfigurations set DataModelVersion=18.44
PRINT 'STEP 7 COMPLETED'
END
Go
