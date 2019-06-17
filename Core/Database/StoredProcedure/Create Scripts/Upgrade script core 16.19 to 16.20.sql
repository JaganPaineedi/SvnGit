----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 16.19)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 16.19 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of Step 2 -------

------ STEP 3 --------------

/* Added Column(s) in SystemConfigurationKeys table */

IF OBJECT_ID('SystemConfigurationKeys')  IS NOT NULL
BEGIN
	IF COL_LENGTH('SystemConfigurationKeys','SourceTableName') IS NULL
	BEGIN
		 ALTER TABLE SystemConfigurationKeys ADD SourceTableName varchar(250) NULL
	END

	IF COL_LENGTH('SystemConfigurationKeys','AllowEdit') IS NULL
	BEGIN
		 ALTER TABLE SystemConfigurationKeys ADD AllowEdit   type_YorN DEFAULT ('Y') NULL
											 CHECK (AllowEdit in ('Y','N'))
	END
		
	PRINT 'STEP 3 COMPLETED'

END		
		
------ END OF STEP 3 -------

------ STEP 4 ---------------
  
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='Modules')
BEGIN
/* 
  TABLE: Modules 
 */
 CREATE TABLE Modules( 
		ModuleId					int identity(1,1)			NOT NULL, 
		CreatedBy					type_CurrentUser			NOT NULL,
		CreatedDate					type_Currentdatetime		NOT NULL,
		ModifiedBy					type_CurrentUser			NOT NULL,
		ModifiedDate				type_Currentdatetime		NOT NULL,
		RecordDeleted				type_YOrN					NULL
									CHECK (RecordDeleted in ('Y','N')),
		DeletedBy					type_UserId					NULL,	
		DeletedDate					datetime					NULL,
		ModuleName					varchar(250)				NULL,
		CONSTRAINT Modules_PK PRIMARY KEY CLUSTERED (ModuleId)
 )
 
  IF OBJECT_ID('Modules') IS NOT NULL
    PRINT '<<< CREATED TABLE Modules >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE Modules >>>', 16, 1)
  
/* 
 * TABLE: Modules 
 */
                
	PRINT 'STEP 4(A) COMPLETED'
 END

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='ModuleScreens')
BEGIN
/* 
  TABLE: ModuleScreens 
 */
 CREATE TABLE ModuleScreens( 
		ModuleScreenId						int identity(1,1)			NOT NULL, 
		CreatedBy							type_CurrentUser			NOT NULL,
		CreatedDate							type_Currentdatetime		NOT NULL,
		ModifiedBy							type_CurrentUser			NOT NULL,
		ModifiedDate						type_Currentdatetime		NOT NULL,
		RecordDeleted						type_YOrN					NULL
											CHECK (RecordDeleted in ('Y','N')),
		DeletedBy							type_UserId					NULL,	
		DeletedDate							datetime					NULL,
		ModuleId							int							NULL,
		ScreenId							int							NULL,
		CONSTRAINT ModuleScreens_PK PRIMARY KEY CLUSTERED (ModuleScreenId)
 )
 
  IF OBJECT_ID('ModuleScreens') IS NOT NULL
    PRINT '<<< CREATED TABLE ModuleScreens >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE ModuleScreens >>>', 16, 1)
 
 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ModuleScreens') AND name='XIE1_ModuleScreens')
	BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_ModuleScreens] ON [dbo].[ModuleScreens] 
		(
		  ModuleId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ModuleScreens') AND name='XIE1_ModuleScreens')
		PRINT '<<< CREATED INDEX ModuleScreens.XIE1_ModuleScreens >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ModuleScreens.XIE1_ModuleScreens >>>', 16, 1)		
	END	

 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ModuleScreens') AND name='XIE2_ModuleScreens')
	BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_ModuleScreens] ON [dbo].[ModuleScreens] 
		(
		  ScreenId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ModuleScreens') AND name='XIE2_ModuleScreens')
		PRINT '<<< CREATED INDEX ModuleScreens.XIE2_ModuleScreens >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ModuleScreens.XIE2_ModuleScreens >>>', 16, 1)		
	END	
	 
/* 
 * TABLE: ModuleScreens 
 */

 ALTER TABLE ModuleScreens ADD CONSTRAINT Modules_ModuleScreens_FK
    FOREIGN KEY (ModuleId)
    REFERENCES Modules(ModuleId)

ALTER TABLE ModuleScreens ADD CONSTRAINT Screens_ModuleScreens_FK
    FOREIGN KEY (ScreenId)
    REFERENCES Screens(ScreenId)
                
	PRINT 'STEP 4(B) COMPLETED'
 END
 
 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='ScreenConfigurationKeys')
BEGIN
/* 
  TABLE: ScreenConfigurationKeys 
 */
 CREATE TABLE ScreenConfigurationKeys( 
		ScreenConfigurationKeyId			int identity(1,1)			NOT NULL, 
		CreatedBy							type_CurrentUser			NOT NULL,
		CreatedDate							type_Currentdatetime		NOT NULL,
		ModifiedBy							type_CurrentUser			NOT NULL,
		ModifiedDate						type_Currentdatetime		NOT NULL,
		RecordDeleted						type_YOrN					NULL
											CHECK (RecordDeleted in ('Y','N')),
		DeletedBy							type_UserId					NULL,	
		DeletedDate							datetime					NULL,
		SystemConfigurationKeyId			int							NULL,
		ScreenId							int							NULL,
		CONSTRAINT ScreenConfigurationKeys_PK PRIMARY KEY CLUSTERED (ScreenConfigurationKeyId)
 )
 
  IF OBJECT_ID('ScreenConfigurationKeys') IS NOT NULL
    PRINT '<<< CREATED TABLE ScreenConfigurationKeys >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE ScreenConfigurationKeys >>>', 16, 1)
 
 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ScreenConfigurationKeys') AND name='XIE1_ScreenConfigurationKeys')
	BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_ScreenConfigurationKeys] ON [dbo].[ScreenConfigurationKeys] 
		(
		  SystemConfigurationKeyId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ScreenConfigurationKeys') AND name='XIE1_ScreenConfigurationKeys')
		PRINT '<<< CREATED INDEX ScreenConfigurationKeys.XIE1_ScreenConfigurationKeys >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ScreenConfigurationKeys.XIE1_ScreenConfigurationKeys >>>', 16, 1)		
	END	

 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ScreenConfigurationKeys') AND name='XIE2_ScreenConfigurationKeys')
	BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_ScreenConfigurationKeys] ON [dbo].[ScreenConfigurationKeys] 
		(
		  ScreenId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ScreenConfigurationKeys') AND name='XIE2_ScreenConfigurationKeys')
		PRINT '<<< CREATED INDEX ScreenConfigurationKeys.XIE2_ScreenConfigurationKeys >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ScreenConfigurationKeys.XIE2_ScreenConfigurationKeys >>>', 16, 1)		
	END	
	 
/* 
 * TABLE: ScreenConfigurationKeys 
 */

 ALTER TABLE ScreenConfigurationKeys ADD CONSTRAINT SystemConfigurationKeys_ScreenConfigurationKeys_FK
    FOREIGN KEY (SystemConfigurationKeyId)
    REFERENCES SystemConfigurationKeys(SystemConfigurationKeyId)

ALTER TABLE ScreenConfigurationKeys ADD CONSTRAINT Screens_ScreenConfigurationKeys_FK
    FOREIGN KEY (ScreenId)
    REFERENCES Screens(ScreenId)
                
	PRINT 'STEP 4(C) COMPLETED'
 END
 
 ------END Of STEP 4----------
 
------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 16.19)
BEGIN
Update SystemConfigurations set DataModelVersion=16.20
PRINT 'STEP 7 COMPLETED'
END
Go
