----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.39)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.39 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
-------------------------------------------------------------

------ STEP 3 ------------
--END Of STEP 3------------
------ STEP 4 ----------
IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomerForgotUsernameMailCredentials')
BEGIN
/* 
 * TABLE: CustomerForgotUsernameMailCredentials 
 */
CREATE TABLE CustomerForgotUsernameMailCredentials(
			CustomerForgotUsernameMailCredentialId		int	identity(1,1)		NOT NULL,
			CreatedBy									type_CurrentUser        NOT NULL,
			CreatedDate									type_CurrentDatetime    NOT NULL,
			ModifiedBy									type_CurrentUser        NOT NULL,
			ModifiedDate								type_CurrentDatetime    NOT NULL,
			RecordDeleted								type_YOrN               NULL
														CHECK (RecordDeleted in ('Y','N')),
			DeletedBy									type_UserId             NULL,
			DeletedDate									datetime				NULL,
			EmailId										varchar(250)			NULL,
			Username									varchar(250)			NULL,
			UserPassword								varchar(100)			NULL,
			ServerDetails								varchar(max)			NULL,
			PortDetails									varchar(max)			NULL,
			TimeoutPeriod								decimal(18,2)			NULL,
			EmailExpiryPeriod							decimal(18,2)			NULL,	
			ForgotUsernameSubject						varchar(max)			NULL,
			ForgotPasswordSubject						varchar(max)			NULL,
			ForgotUsernameBody							varchar(max)			NULL,
			ForgotPasswordBody							varchar(max)			NULL,
			CONSTRAINT CustomerForgotUsernameMailCredentials_PK PRIMARY KEY CLUSTERED (CustomerForgotUsernameMailCredentialId) 
 )
 
  IF OBJECT_ID('CustomerForgotUsernameMailCredentials') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomerForgotUsernameMailCredentials >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomerForgotUsernameMailCredentials >>>', 16, 1)
/* 
 * TABLE: CustomerForgotUsernameMailCredentials 
 */ 
   
	PRINT 'STEP 4(A) COMPLETED'
END


IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomerEmailLinkExpiry')
BEGIN
/* 
 * TABLE: CustomerEmailLinkExpiry 
 */
CREATE TABLE CustomerEmailLinkExpiry(
			CustomerEmailLinkExpiryId					int	identity(1,1)		NOT NULL,
			CreatedBy									type_CurrentUser        NOT NULL,
			CreatedDate									type_CurrentDatetime    NOT NULL,
			ModifiedBy									type_CurrentUser        NOT NULL,
			ModifiedDate								type_CurrentDatetime    NOT NULL,
			RecordDeleted								type_YOrN               NULL
														CHECK (RecordDeleted in ('Y','N')),
			DeletedBy									type_UserId             NULL,
			DeletedDate									datetime				NULL,
			StaffId										int						NULL,
			GUIId										varchar(250)			NULL,
			TypeOfRquest								char(1)	               NULL
														CHECK (TypeOfRquest in ('U','P')),
			TokenExpire									type_YOrN               NULL
														CHECK (TokenExpire in ('Y','N')),
			EmailTime									datetime				NULL,
			CONSTRAINT CustomerEmailLinkExpiry_PK PRIMARY KEY CLUSTERED (CustomerEmailLinkExpiryId) 
 )
 
  IF OBJECT_ID('CustomerEmailLinkExpiry') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomerEmailLinkExpiry >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomerEmailLinkExpiry >>>', 16, 1)
    
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CustomerEmailLinkExpiry]') AND name = N'XIE1_CustomerEmailLinkExpiry')
	BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_CustomerEmailLinkExpiry] ON [dbo].[CustomerEmailLinkExpiry] 
		(
		StaffId ASC		
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomerEmailLinkExpiry') AND name='XIE1_CustomerEmailLinkExpiry')
		PRINT '<<< CREATED INDEX CustomerEmailLinkExpiry.XIE1_CustomerEmailLinkExpiry >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX CustomerEmailLinkExpiry.XIE1_CustomerEmailLinkExpiry >>>', 16, 1)		
	END    
    
    
/* 
 * TABLE: CustomerEmailLinkExpiry 
 */ 
 
 ALTER TABLE CustomerEmailLinkExpiry ADD CONSTRAINT Staff_CustomerEmailLinkExpiry_FK
    FOREIGN KEY (StaffId)
    REFERENCES Staff(StaffId)
    
 EXEC sys.sp_addextendedproperty 'CustomerEmailLinkExpiry_Description'
	,'TypeOfRequest column stores U or P U- Forget UserName P- Forget Password '
	,'schema'
	,'dbo'
	,'table'
	,'CustomerEmailLinkExpiry'
	,'column'
	,'TypeOfRequest'   
    
   
	PRINT 'STEP 4(A) COMPLETED'
END


------END Of STEP 4---------------

------ STEP 5 ----------------

-------END STEP 5-------------
------ STEP 6  ----------

----END Of STEP 6 ------------

------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 18.39)
BEGIN
Update SystemConfigurations set DataModelVersion=18.40
PRINT 'STEP 7 COMPLETED'
END
Go
