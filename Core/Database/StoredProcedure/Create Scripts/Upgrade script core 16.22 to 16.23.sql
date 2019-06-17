----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 16.22)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 16.22 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 -----------

-----End of Step 2 -------

------ STEP 3 ------------

-- Added column(s) in Staff Table.

IF OBJECT_ID('Staff')  IS NOT NULL
BEGIN
	IF COL_LENGTH('Staff','MobileSmartKey') IS NULL
	BEGIN
		 ALTER TABLE Staff ADD  MobileSmartKey varchar(100)	NULL
	END	
	
	IF COL_LENGTH('Staff','AllowMobileAccess') IS NULL
	BEGIN
		 ALTER TABLE Staff ADD AllowMobileAccess type_YOrN   NULL
						   CHECK (AllowMobileAccess in ('Y','N'))
	END	
	
	IF COL_LENGTH('Staff','MobileSmartKeyExpiresNextLogin') IS NULL
	BEGIN
		 ALTER TABLE Staff ADD MobileSmartKeyExpiresNextLogin type_YOrN   NULL
						   CHECK (MobileSmartKeyExpiresNextLogin in ('Y','N'))
	END	
		
END


IF OBJECT_ID('Forms')  IS NOT NULL
BEGIN
	IF COL_LENGTH('Forms','FormHTML') IS NULL
	BEGIN
		 ALTER TABLE Forms ADD  FormHTML type_Comment2	NULL
	END	
	
	IF COL_LENGTH('Forms','MobileFormHTML') IS NULL
	BEGIN
		 ALTER TABLE Forms ADD  MobileFormHTML type_Comment2 	NULL
	END	
	
END


-----END Of STEP 3--------

------ STEP 4 ------------

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='StaffPreferences')
 BEGIN
/*  
 * TABLE: StaffPreferences 
 */

CREATE TABLE StaffPreferences(
    StaffPreferenceId							int identity(1,1)		NOT NULL,
    CreatedBy									type_CurrentUser		NOT NULL,
    CreatedDate									type_CurrentDatetime    NOT NULL,
    ModifiedBy									type_CurrentUser        NOT NULL,
    ModifiedDate								type_CurrentDatetime    NOT NULL,
    RecordDeleted								type_YOrN               NULL
												CHECK (RecordDeleted in ('Y','N')),
    DeletedBy									type_UserId             NULL,
	DeletedDate									datetime                NULL,
	StaffId										int						NOT NULL,
	DefaultMobileHomePageId						int						NULL,
	DefaultMobileProgramId						int						NULL,
	MobileCalendarEventsDaysLookUpInPast		int						NULL,
	MobileCalendarEventsDaysLookUpInFuture		int						NULL,
    CONSTRAINT StaffPreferences_PK PRIMARY KEY CLUSTERED (StaffPreferenceId)
)

IF OBJECT_ID('StaffPreferences') IS NOT NULL
    PRINT '<<< CREATED TABLE StaffPreferences >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE StaffPreferences >>>', 16, 1)

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('StaffPreferences') AND name='XIE1_StaffPreferences')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_StaffPreferences] ON [dbo].[StaffPreferences] 
		(
		StaffId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('StaffPreferences') AND name='XIE1_StaffPreferences')
		PRINT '<<< CREATED INDEX StaffPreferences.XIE1_StaffPreferences >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX  StaffPreferences.XIE1_StaffPreferences >>>', 16, 1)		
		END
		
/* 
 * TABLE: StaffPreferences 
 */
    
ALTER TABLE StaffPreferences ADD CONSTRAINT Staff_StaffPreferences_FK 
    FOREIGN KEY (StaffId)
    REFERENCES Staff(StaffId)    
    
    PRINT 'STEP 4(A) COMPLETED'
END


IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='MobileDashboards')
 BEGIN
/* 
 * TABLE: MobileDashboards 
 */

CREATE TABLE MobileDashboards(
    MobileDashboardId							int identity(1,1)		NOT NULL,
    CreatedBy									type_CurrentUser		NOT NULL,
    CreatedDate									type_CurrentDatetime    NOT NULL,
    ModifiedBy									type_CurrentUser        NOT NULL,
    ModifiedDate								type_CurrentDatetime    NOT NULL,
    RecordDeleted								type_YOrN               NULL
												CHECK (RecordDeleted in ('Y','N')),
    DeletedBy									type_UserId             NULL,
	DeletedDate									datetime                NULL,
	DashboardName								nvarchar(100)			NOT NULL,
	DashboardImage								nvarchar(100)			NOT NULL,
	RedirectUrl									nvarchar(100)			NOT NULL,
	ShowInMyPreference							type_YOrN               NULL
												CHECK (ShowInMyPreference in ('Y','N')),
	Active										type_YOrN               NULL
												CHECK (Active in ('Y','N')),
    CONSTRAINT MobileDashboards_PK PRIMARY KEY CLUSTERED (MobileDashboardId)
)

IF OBJECT_ID('MobileDashboards') IS NOT NULL
    PRINT '<<< CREATED TABLE MobileDashboards >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE MobileDashboards >>>', 16, 1)

		
/* 
 * TABLE: MobileDashboards 
 */
       
    PRINT 'STEP 4(B) COMPLETED'
END


IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='MobileOrigins')
 BEGIN
/* 
 * TABLE: MobileOrigins 
 */

CREATE TABLE MobileOrigins(
    MobileOriginId								int identity(1,1)		NOT NULL,
    CreatedBy									type_CurrentUser		NOT NULL,
    CreatedDate									type_CurrentDatetime    NOT NULL,
    ModifiedBy									type_CurrentUser        NOT NULL,
    ModifiedDate								type_CurrentDatetime    NOT NULL,
    RecordDeleted								type_YOrN               NULL
												CHECK (RecordDeleted in ('Y','N')),
    DeletedBy									type_UserId             NULL,
	DeletedDate									datetime                NULL,
	OriginSecret								nvarchar(100)			NOT NULL,
	Name										nvarchar(100)			NOT NULL,
	ApplicationType								int						NOT NULL,
	Active										type_YOrN               NULL
												CHECK (Active in ('Y','N')),
	RefreshTokenLifeTime						int						NULL,
	AllowedOrigin								nvarchar(100)			NOT NULL,
    CONSTRAINT MobileOrigins_PK PRIMARY KEY CLUSTERED (MobileOriginId)
)

IF OBJECT_ID('MobileOrigins') IS NOT NULL
    PRINT '<<< CREATED TABLE MobileOrigins >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE MobileOrigins >>>', 16, 1)

		
/* 
 * TABLE: MobileOrigins 
 */
       
    PRINT 'STEP 4(C) COMPLETED'
END



IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='MobileRefreshTokens')
 BEGIN
/* 
 * TABLE: MobileRefreshTokens 
 */

CREATE TABLE MobileRefreshTokens(
    MobileRefreshTokenId						int identity(1,1)		NOT NULL,
    CreatedBy									type_CurrentUser		NOT NULL,
    CreatedDate									type_CurrentDatetime    NOT NULL,
    ModifiedBy									type_CurrentUser        NOT NULL,
    ModifiedDate								type_CurrentDatetime    NOT NULL,
    RecordDeleted								type_YOrN               NULL
												CHECK (RecordDeleted in ('Y','N')),
    DeletedBy									type_UserId             NULL,
	DeletedDate									datetime                NULL,
	UserCode									nvarchar(100)			NOT NULL,
	ClientId									nvarchar(100)			NOT NULL,
	IssuedUtc									datetime				NOT NULL,
	ExpiresUtc									datetime				NOT NULL,
	ProtectedTicket								nvarchar(max)			NOT NULL,
    CONSTRAINT MobileRefreshTokens_PK PRIMARY KEY CLUSTERED (MobileRefreshTokenId)
)

IF OBJECT_ID('MobileRefreshTokens') IS NOT NULL
    PRINT '<<< CREATED TABLE MobileRefreshTokens >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE MobileRefreshTokens >>>', 16, 1)

		
/* 
 * TABLE: MobileRefreshTokens 
 */
       
    PRINT 'STEP 4(D) COMPLETED'
END

--- Data Migrated from Staff to StaffPreferences table

IF OBJECT_ID('StaffPreferences') IS NOT NULL
BEGIN
	INSERT INTO StaffPreferences 
	(CreatedBy,
	CreatedDate,
	ModifiedBy,
	ModifiedDate,
	StaffId,
	MobileCalendarEventsDaysLookUpInPast,
	MobileCalendarEventsDaysLookUpInFuture
	)
	SELECT
	 'DataMigration' as CreatedBy
	 ,GETDATE() as CreatedDate
	 ,'DataMigration' as ModifiedBy
	 ,GETDATE() as ModifiedDate
	 ,S.StaffId
	 ,15
	 ,15  
	FROM Staff S
	WHERE ISNULL(S.RecordDeleted,'N')='N'
	AND NOT EXISTS(SELECT 1 FROM StaffPreferences SP WHERE SP.StaffId=S.StaffId  AND ISNULL(SP.RecordDeleted,'N')='N')
END

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 16.22)
BEGIN
Update SystemConfigurations set DataModelVersion=16.23
PRINT 'STEP 7 COMPLETED'
END
Go


