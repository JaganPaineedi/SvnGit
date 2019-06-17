----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.49)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.49 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
-------------------------------------------------------------

------ STEP 3 ------------
IF OBJECT_ID('StaffPreferences') IS NOT NULL
BEGIN
	IF COL_LENGTH('StaffPreferences','NotifyMeOfMyServices') IS NULL
	BEGIN
		ALTER TABLE  StaffPreferences ADD   NotifyMeOfMyServices	type_YOrN		NULL
									  CHECK (NotifyMeOfMyServices in ('Y','N'))
	END
	PRINT 'STEP 3 COMPLETED'
END

--END Of STEP 3------------
------ STEP 4 ----------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='StaffNotifications')
 BEGIN
/* 
 * TABLE: StaffNotifications 
 */
CREATE TABLE StaffNotifications(
    StaffNotificationId						int	identity(1,1)		NOT NULL,
    CreatedBy								type_CurrentUser		NOT NULL,
    CreatedDate								type_CurrentDatetime    NOT NULL,
    ModifiedBy								type_CurrentUser        NOT NULL,
    ModifiedDate							type_CurrentDatetime    NOT NULL,
    RecordDeleted							type_YOrN               NULL
											CHECK (RecordDeleted in ('Y','N')),
    DeletedBy								type_UserId             NULL,
	DeletedDate								datetime                NULL, 	
	StaffId									int						NULL, 
	Active									type_YOrN               NULL
											CHECK (Active in ('Y','N')),
	Monday									type_YOrN               NULL
											CHECK (Monday in ('Y','N')),
	Tuesday									type_YOrN               NULL
											CHECK (Tuesday in ('Y','N')),
	Wednesday								type_YOrN               NULL
											CHECK (Wednesday in ('Y','N')),
	Thursday								type_YOrN               NULL
											CHECK (Thursday in ('Y','N')),
	Friday									type_YOrN               NULL
											CHECK (Friday in ('Y','N')),
	Saturday								type_YOrN               NULL
											CHECK (Saturday in ('Y','N')),
	Sunday									type_YOrN               NULL
											CHECK (Sunday in ('Y','N')),
	AllProgram								type_YOrN               NULL
											CHECK (AllProgram in ('Y','N')),
	ProgramGroupName						varchar(250)			NULL, 
	AllProcedure							type_YOrN               NULL
											CHECK (AllProcedure in ('Y','N')),	
	ProcedureGroupName						varchar(250)			NULL, 	
	AllStaff								type_YOrN               NULL
											CHECK (AllStaff in ('Y','N')),
	StaffGroupName							varchar(250)			NULL, 
	AllLocation								type_YOrN               NULL
											CHECK (AllLocation in ('Y','N')),	
	LocationGroupName						varchar(250)			NULL, 		
	CONSTRAINT StaffNotifications_PK PRIMARY KEY CLUSTERED (StaffNotificationId) 
 )
 
 IF OBJECT_ID('StaffNotifications') IS NOT NULL
    PRINT '<<< CREATED TABLE  StaffNotifications >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE StaffNotifications >>>', 16, 1)
    
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('StaffNotifications') AND name='XIE1_StaffNotifications')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_StaffNotifications] ON [dbo].[StaffNotifications] 
		(
		StaffId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('StaffNotifications') AND name='XIE1_StaffNotifications')
		PRINT '<<< CREATED INDEX StaffNotifications.XIE1_StaffNotifications >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX StaffNotifications.XIE1_StaffNotifications >>>', 16, 1)		
		END	
		

/* 
 * TABLE:  StaffNotifications 
 */   
   
ALTER TABLE StaffNotifications ADD CONSTRAINT Staff_StaffNotifications_FK
    FOREIGN KEY (StaffId)
    REFERENCES Staff(StaffId)
    
   
     PRINT 'STEP 4(A) COMPLETED'
 END  
 
 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='StaffNotificationPrograms')
 BEGIN
/* 
 * TABLE: StaffNotificationPrograms 
 */
CREATE TABLE StaffNotificationPrograms(
    StaffNotificationProgramId				int	identity(1,1)		NOT NULL,
    CreatedBy								type_CurrentUser		NOT NULL,
    CreatedDate								type_CurrentDatetime    NOT NULL,
    ModifiedBy								type_CurrentUser        NOT NULL,
    ModifiedDate							type_CurrentDatetime    NOT NULL,
    RecordDeleted							type_YOrN               NULL
											CHECK (RecordDeleted in ('Y','N')),
    DeletedBy								type_UserId             NULL,
	DeletedDate								datetime                NULL, 	
	StaffNotificationId						int						NOT NULL, 	
	ProgramId								int						NULL, 					
	CONSTRAINT StaffNotificationPrograms_PK PRIMARY KEY CLUSTERED (StaffNotificationProgramId) 
 )
 
 IF OBJECT_ID('StaffNotificationPrograms') IS NOT NULL
    PRINT '<<< CREATED TABLE  StaffNotificationPrograms >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE StaffNotificationPrograms >>>', 16, 1)
    
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('StaffNotificationPrograms') AND name='XIE1_StaffNotificationPrograms')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_StaffNotificationPrograms] ON [dbo].[StaffNotificationPrograms] 
		(
		StaffNotificationId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('StaffNotificationPrograms') AND name='XIE1_StaffNotificationPrograms')
		PRINT '<<< CREATED INDEX StaffNotificationPrograms.XIE1_StaffNotificationPrograms >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX StaffNotificationPrograms.XIE1_StaffNotificationPrograms >>>', 16, 1)		
		END	
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('StaffNotificationPrograms') AND name='XIE2_StaffNotificationPrograms')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_StaffNotificationPrograms] ON [dbo].[StaffNotificationPrograms] 
		(
		ProgramId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('StaffNotificationPrograms') AND name='XIE2_StaffNotificationPrograms')
		PRINT '<<< CREATED INDEX StaffNotificationPrograms.XIE2_StaffNotificationPrograms >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX StaffNotificationPrograms.XIE2_StaffNotificationPrograms >>>', 16, 1)		
		END	
		

/* 
 * TABLE:  StaffNotificationPrograms 
 */   
   
ALTER TABLE StaffNotificationPrograms ADD CONSTRAINT StaffNotifications_StaffNotificationPrograms_FK
    FOREIGN KEY (StaffNotificationId)
    REFERENCES StaffNotifications(StaffNotificationId)
    
ALTER TABLE StaffNotificationPrograms ADD CONSTRAINT Programs_StaffNotificationPrograms_FK
    FOREIGN KEY (ProgramId)
    REFERENCES Programs(ProgramId)
    
    
   
     PRINT 'STEP 4(B) COMPLETED'
 END  
 
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='StaffNotificationProcedures')
 BEGIN
/* 
 * TABLE: StaffNotificationProcedures 
 */
CREATE TABLE StaffNotificationProcedures(
    StaffNotificationProcedureId			int	identity(1,1)		NOT NULL,
    CreatedBy								type_CurrentUser		NOT NULL,
    CreatedDate								type_CurrentDatetime    NOT NULL,
    ModifiedBy								type_CurrentUser        NOT NULL,
    ModifiedDate							type_CurrentDatetime    NOT NULL,
    RecordDeleted							type_YOrN               NULL
											CHECK (RecordDeleted in ('Y','N')),
    DeletedBy								type_UserId             NULL,
	DeletedDate								datetime                NULL, 	
	StaffNotificationId						int						NOT NULL, 	
	ProcedureCodeId							int						NULL, 					
	CONSTRAINT StaffNotificationProcedures_PK PRIMARY KEY CLUSTERED (StaffNotificationProcedureId) 
 )
 
 IF OBJECT_ID('StaffNotificationProcedures') IS NOT NULL
    PRINT '<<< CREATED TABLE  StaffNotificationProcedures >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE StaffNotificationProcedures >>>', 16, 1)
    
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('StaffNotificationProcedures') AND name='XIE1_StaffNotificationProcedures')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_StaffNotificationProcedures] ON [dbo].[StaffNotificationProcedures] 
		(
		StaffNotificationId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('StaffNotificationProcedures') AND name='XIE1_StaffNotificationProcedures')
		PRINT '<<< CREATED INDEX StaffNotificationProcedures.XIE1_StaffNotificationProcedures >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX StaffNotificationProcedures.XIE1_StaffNotificationProcedures >>>', 16, 1)		
		END	
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('StaffNotificationProcedures') AND name='XIE2_StaffNotificationProcedures')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_StaffNotificationProcedures] ON [dbo].[StaffNotificationProcedures] 
		(
		ProcedureCodeId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('StaffNotificationProcedures') AND name='XIE2_StaffNotificationProcedures')
		PRINT '<<< CREATED INDEX StaffNotificationProcedures.XIE2_StaffNotificationProcedures >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX StaffNotificationProcedures.XIE2_StaffNotificationProcedures >>>', 16, 1)		
		END	
		

/* 
 * TABLE:  StaffNotificationProcedures 
 */   
   
ALTER TABLE StaffNotificationProcedures ADD CONSTRAINT StaffNotifications_StaffNotificationProcedures_FK
    FOREIGN KEY (StaffNotificationId)
    REFERENCES StaffNotifications(StaffNotificationId)
    
ALTER TABLE StaffNotificationProcedures ADD CONSTRAINT ProcedureCodes_StaffNotificationProcedures_FK
    FOREIGN KEY (ProcedureCodeId)
    REFERENCES ProcedureCodes(ProcedureCodeId)
    
    
   
     PRINT 'STEP 4(C) COMPLETED'
 END
 
 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='StaffNotificationStaff')
 BEGIN
/* 
 * TABLE: StaffNotificationStaff 
 */
CREATE TABLE StaffNotificationStaff(
    StaffNotificationStaffId				int	identity(1,1)		NOT NULL,
    CreatedBy								type_CurrentUser		NOT NULL,
    CreatedDate								type_CurrentDatetime    NOT NULL,
    ModifiedBy								type_CurrentUser        NOT NULL,
    ModifiedDate							type_CurrentDatetime    NOT NULL,
    RecordDeleted							type_YOrN               NULL
											CHECK (RecordDeleted in ('Y','N')),
    DeletedBy								type_UserId             NULL,
	DeletedDate								datetime                NULL, 	
	StaffNotificationId						int						NOT NULL, 	
	StaffId									int						NULL, 					
	CONSTRAINT StaffNotificationStaff_PK PRIMARY KEY CLUSTERED (StaffNotificationStaffId) 
 )
 
 IF OBJECT_ID('StaffNotificationStaff') IS NOT NULL
    PRINT '<<< CREATED TABLE  StaffNotificationStaff >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE StaffNotificationStaff >>>', 16, 1)
    
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('StaffNotificationStaff') AND name='XIE1_StaffNotificationStaff')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_StaffNotificationStaff] ON [dbo].[StaffNotificationStaff] 
		(
		StaffNotificationId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('StaffNotificationStaff') AND name='XIE1_StaffNotificationStaff')
		PRINT '<<< CREATED INDEX StaffNotificationStaff.XIE1_StaffNotificationStaff >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX StaffNotificationStaff.XIE1_StaffNotificationStaff >>>', 16, 1)		
		END	
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('StaffNotificationStaff') AND name='XIE2_StaffNotificationStaff')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_StaffNotificationStaff] ON [dbo].[StaffNotificationStaff] 
		(
		StaffId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('StaffNotificationStaff') AND name='XIE2_StaffNotificationStaff')
		PRINT '<<< CREATED INDEX StaffNotificationStaff.XIE2_StaffNotificationStaff >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX StaffNotificationStaff.XIE2_StaffNotificationStaff >>>', 16, 1)		
		END	
		

/* 
 * TABLE:  StaffNotificationStaff 
 */   
   
ALTER TABLE StaffNotificationStaff ADD CONSTRAINT StaffNotifications_StaffNotificationStaff_FK
    FOREIGN KEY (StaffNotificationId)
    REFERENCES StaffNotifications(StaffNotificationId)
    
ALTER TABLE StaffNotificationStaff ADD CONSTRAINT Staff_StaffNotificationStaff_FK
    FOREIGN KEY (StaffId)
    REFERENCES Staff(StaffId)
    
    
   
     PRINT 'STEP 4(D) COMPLETED'
 END
 
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='StaffNotificationLocations')
 BEGIN
/* 
 * TABLE: StaffNotificationLocations 
 */
CREATE TABLE StaffNotificationLocations(
    StaffNotificationLocationId				int	identity(1,1)		NOT NULL,
    CreatedBy								type_CurrentUser		NOT NULL,
    CreatedDate								type_CurrentDatetime    NOT NULL,
    ModifiedBy								type_CurrentUser        NOT NULL,
    ModifiedDate							type_CurrentDatetime    NOT NULL,
    RecordDeleted							type_YOrN               NULL
											CHECK (RecordDeleted in ('Y','N')),
    DeletedBy								type_UserId             NULL,
	DeletedDate								datetime                NULL, 	
	StaffNotificationId						int						NOT NULL, 	
	LocationId								int						NULL, 					
	CONSTRAINT StaffNotificationLocations_PK PRIMARY KEY CLUSTERED (StaffNotificationLocationId) 
 )
 
 IF OBJECT_ID('StaffNotificationLocations') IS NOT NULL
    PRINT '<<< CREATED TABLE  StaffNotificationLocations >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE StaffNotificationLocations >>>', 16, 1)
    
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('StaffNotificationLocations') AND name='XIE1_StaffNotificationLocations')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_StaffNotificationLocations] ON [dbo].[StaffNotificationLocations] 
		(
		StaffNotificationId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('StaffNotificationLocations') AND name='XIE1_StaffNotificationLocations')
		PRINT '<<< CREATED INDEX StaffNotificationLocations.XIE1_StaffNotificationLocations >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX StaffNotificationLocations.XIE1_StaffNotificationLocations >>>', 16, 1)		
		END	
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('StaffNotificationLocations') AND name='XIE2_StaffNotificationLocations')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_StaffNotificationLocations] ON [dbo].[StaffNotificationLocations] 
		(
		LocationId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('StaffNotificationLocations') AND name='XIE2_StaffNotificationLocations')
		PRINT '<<< CREATED INDEX StaffNotificationLocations.XIE2_StaffNotificationLocations >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX StaffNotificationLocations.XIE2_StaffNotificationLocations >>>', 16, 1)		
		END	
		

/* 
 * TABLE:  StaffNotificationLocations 
 */   
   
ALTER TABLE StaffNotificationLocations ADD CONSTRAINT StaffNotifications_StaffNotificationLocations_FK
    FOREIGN KEY (StaffNotificationId)
    REFERENCES StaffNotifications(StaffNotificationId)
    
ALTER TABLE StaffNotificationLocations ADD CONSTRAINT Locations_StaffNotificationLocations_FK
    FOREIGN KEY (LocationId)
    REFERENCES Locations(LocationId)
    
    
   
     PRINT 'STEP 4(E) COMPLETED'
 END
 
  
------END Of STEP 4---------------

------ STEP 5 ----------------

-------END STEP 5-------------
------ STEP 6  ----------

----END Of STEP 6 ------------

------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 18.49)
BEGIN
Update SystemConfigurations set DataModelVersion=18.50
PRINT 'STEP 7 COMPLETED'
END
Go
