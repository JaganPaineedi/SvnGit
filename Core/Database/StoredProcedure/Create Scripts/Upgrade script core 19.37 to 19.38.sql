----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 19.37)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 19.37 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
-----
------ STEP 2 ----------

-----End of Step 2 -------

------ STEP 3 ------------
------ STEP 3 ------------

-- Added column(s) in StaffPreferences Table

IF OBJECT_ID('StaffPreferences') IS NOT NULL
BEGIN
	IF COL_LENGTH('StaffPreferences','RegisteredForMobileNotifications') IS NULL
	BEGIN
	 ALTER TABLE StaffPreferences  ADD RegisteredForMobileNotifications  type_YOrN	 NULL
								   CHECK (RegisteredForMobileNotifications in ('Y','N'))
	END

	IF COL_LENGTH('StaffPreferences','RegisteredForSMSNotifications') IS NULL
	BEGIN
	 ALTER TABLE StaffPreferences  ADD RegisteredForSMSNotifications type_YOrN	 NULL
								   CHECK (RegisteredForSMSNotifications in ('Y','N'))
	END

	IF COL_LENGTH('StaffPreferences','RegisteredForEmailNotifications') IS NULL
	BEGIN
	 ALTER TABLE StaffPreferences  ADD RegisteredForEmailNotifications  type_YOrN	 NULL
								   CHECK (RegisteredForEmailNotifications in ('Y','N'))
	END
	
	IF COL_LENGTH('StaffPreferences','LastTFATimeStamp') IS NULL
	BEGIN
	 ALTER TABLE StaffPreferences  ADD LastTFATimeStamp  datetime	 NULL
	 
	 EXEC sys.sp_addextendedproperty 'StaffPreferences_Description'
	,'LastTFATimeStamp column store Last Two-factor authentication date time'
	,'schema'
	,'dbo'
	,'table'
	,'StaffPreferences'
	,'column'
	,'LastTFATimeStamp'
	
	END

	
	IF COL_LENGTH('StaffPreferences','RegisteredForMobileNotificationsTimeStamp') IS NULL
	BEGIN
	 ALTER TABLE StaffPreferences  ADD RegisteredForMobileNotificationsTimeStamp   datetime	 NULL
	 
	 EXEC sys.sp_addextendedproperty 'StaffPreferences_Description'
	,'RegisteredForMobileNotificationsTimeStamp column store Mobile Device Registration date time'
	,'schema'
	,'dbo'
	,'table'
	,'StaffPreferences'
	,'column'
	,'RegisteredForMobileNotificationsTimeStamp'
	
	END
	
	
 PRINT 'STEP 3 COMPLETED'
 
END

------ END Of STEP 3 ------------

------ STEP 4 ---------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='StaffNotificationSubscriptions')
 BEGIN
/* 
 * TABLE: StaffNotificationSubscriptions 
 */

CREATE TABLE StaffNotificationSubscriptions(
    StaffNotificationSubscriptionId		int	Identity(1,1)			NOT NULL,
    CreatedBy							type_CurrentUser			NOT NULL,
    CreatedDate							type_CurrentDatetime		NOT NULL,
    ModifiedBy							type_CurrentUser			NOT NULL,
    ModifiedDate						type_CurrentDatetime		NOT NULL,
    RecordDeleted						type_YOrN					NULL
										CHECK (RecordDeleted in('Y','N')),
    DeletedBy							type_UserId					NULL,
    DeletedDate							datetime					NULL,
    StaffId								int							NULL,
	SubscriptionId						type_GlobalCode				NULL,
    CONSTRAINT StaffNotificationSubscriptions_PK PRIMARY KEY CLUSTERED (StaffNotificationSubscriptionId)		 	
)
 IF OBJECT_ID('StaffNotificationSubscriptions') IS NOT NULL
    PRINT '<<< CREATED TABLE StaffNotificationSubscriptions >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE StaffNotificationSubscriptions >>>', 16, 1)
    
     IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('StaffNotificationSubscriptions') AND name='XIE1_StaffNotificationSubscriptions')
	BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_StaffNotificationSubscriptions] ON [dbo].[StaffNotificationSubscriptions] 
		(
		[StaffId] ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('StaffNotificationSubscriptions') AND name='XIE1_StaffNotificationSubscriptions')
		PRINT '<<< CREATED INDEX StaffNotificationSubscriptions.XIE1_StaffNotificationSubscriptions >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX StaffNotificationSubscriptions.XIE1_StaffNotificationSubscriptions >>>', 16, 1)		
	END		  
  
/*  
 * TABLE: StaffNotificationSubscriptions 
 */ 
ALTER TABLE StaffNotificationSubscriptions ADD CONSTRAINT Staff_StaffNotificationSubscriptions_FK 
    FOREIGN KEY (StaffId)
    REFERENCES Staff(StaffId)
    
 
PRINT 'STEP 4(A) COMPLETED'
END

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='MobileDevices')
 BEGIN
/* 
 * TABLE: MobileDevices 
 */

CREATE TABLE MobileDevices(
    MobileDeviceId						int	Identity(1,1)			NOT NULL,
    CreatedBy							type_CurrentUser			NOT NULL,
    CreatedDate							type_CurrentDatetime		NOT NULL,
    ModifiedBy							type_CurrentUser			NOT NULL,
    ModifiedDate						type_CurrentDatetime		NOT NULL,
    RecordDeleted						type_YOrN					NULL
										CHECK (RecordDeleted in('Y','N')),
    DeletedBy							type_UserId					NULL,
    DeletedDate							datetime					NULL,
    StaffId								int							NULL,
	MobileDeviceIdentifier				varchar(500)				NULL,
	MobileDeviceName					varchar(500)				NULL,
	MobileSubscriptionIdentifier		varchar(500)				NULL,
	SubscribedForPushNotifications		type_YOrN					NULL
										CHECK (SubscribedForPushNotifications in('Y','N')),
    CONSTRAINT MobileDevices_PK PRIMARY KEY CLUSTERED (MobileDeviceId)		 	
)
 IF OBJECT_ID('MobileDevices') IS NOT NULL
    PRINT '<<< CREATED TABLE MobileDevices >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE MobileDevices >>>', 16, 1)
    
     IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('MobileDevices') AND name='XIE1_MobileDevices')
	BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_MobileDevices] ON [dbo].[MobileDevices] 
		(
		[StaffId] ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('MobileDevices') AND name='XIE1_MobileDevices')
		PRINT '<<< CREATED INDEX MobileDevices.XIE1_MobileDevices >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX MobileDevices.XIE1_MobileDevices >>>', 16, 1)		
	END		  
  
/*  
 * TABLE: MobileDevices 
 */ 
ALTER TABLE MobileDevices ADD CONSTRAINT Staff_MobileDevices_FK 
    FOREIGN KEY (StaffId)
    REFERENCES Staff(StaffId)
    
 
PRINT 'STEP 4(B) COMPLETED'
END

 ----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 19.37)
BEGIN
Update SystemConfigurations set DataModelVersion=19.38
PRINT 'STEP 7 COMPLETED'
END
Go
