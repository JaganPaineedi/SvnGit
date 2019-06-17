----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.20)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.20 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of Step 2 -------

------ STEP 3 ------------

------ STEP 4 ---------------
 
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='PreferredActionTemplates')
BEGIN
/*  
 * TABLE: PreferredActionTemplates 
 */
 
 CREATE TABLE PreferredActionTemplates(
		PreferredActionTemplateId			INT	identity(1,1)		NOT NULL,
		CreatedBy							type_CurrentUser		NOT NULL,
		CreatedDate							type_CurrentDatetime	NOT NULL,
		ModifiedBy							type_CurrentUser		NOT NULL,
		ModifiedDate						type_CurrentDatetime	NOT NULL,
		RecordDeleted						type_YOrN				NULL
											CHECK (RecordDeleted in	('Y','N')),	
		DeletedBy							type_UserId				NULL,
		DeletedDate							datetime				NULL,
		TemplateName						varchar(50)		        NULL,	
		CONSTRAINT PreferredActionTemplates_PK PRIMARY KEY CLUSTERED (PreferredActionTemplateId)
 ) 
 IF OBJECT_ID('PreferredActionTemplates') IS NOT NULL
	PRINT '<<< CREATED TABLE PreferredActionTemplates >>>'
ELSE
	RAISERROR('<<< FAILED CREATING TABLE PreferredActionTemplates >>>', 16, 1)	
	
PRINT 'STEP 4(A) COMPLETED'
		
END

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='PreferredActionTemplateItems')
BEGIN
/*  
 * TABLE: PreferredActionTemplateItems 
 */
 
 CREATE TABLE PreferredActionTemplateItems(
		PreferredActionTemplateItemId		INT	identity(1,1)		NOT NULL,
		CreatedBy							type_CurrentUser		NOT NULL,
		CreatedDate							type_CurrentDatetime	NOT NULL,
		ModifiedBy							type_CurrentUser		NOT NULL,
		ModifiedDate						type_CurrentDatetime	NOT NULL,
		RecordDeleted						type_YOrN				NULL
											CHECK (RecordDeleted in	('Y','N')),	
		DeletedBy							type_UserId				NULL,
		DeletedDate							datetime				NULL,
		PreferredActionTemplateId			int						NULL,
		AssociatedScreenId					int						NULL,
		ListPageScreenId					int						NULL,
		ItemName							varchar(250)			NULL,
		DefaultFilters						varchar(8000)			NULL,
		SortOrder							int						NULL,
		PageAction							varchar(20)				NULL,
		ScreenTabIndex						int						NULL,
		CONSTRAINT PreferredActionTemplateItems_PK PRIMARY KEY CLUSTERED (PreferredActionTemplateItemId)
 ) 
 IF OBJECT_ID('PreferredActionTemplateItems') IS NOT NULL
	PRINT '<<< CREATED TABLE PreferredActionTemplateItems >>>'
ELSE
	RAISERROR('<<< FAILED CREATING TABLE PreferredActionTemplateItems >>>', 16, 1)	
	
 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('PreferredActionTemplateItems') AND name='XIE1_PreferredActionTemplateItems')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_PreferredActionTemplateItems] ON [dbo].[PreferredActionTemplateItems] 
		(
		PreferredActionTemplateId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('PreferredActionTemplateItems') AND name='XIE1_PreferredActionTemplateItems')
		PRINT '<<< CREATED INDEX PreferredActionTemplateItems.XIE1_PreferredActionTemplateItems >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX PreferredActionTemplateItems.XIE1_PreferredActionTemplateItems >>>', 16, 1)		
		END
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('PreferredActionTemplateItems') AND name='XIE2_PreferredActionTemplateItems')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_PreferredActionTemplateItems] ON [dbo].[PreferredActionTemplateItems] 
		(
		AssociatedScreenId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('PreferredActionTemplateItems') AND name='XIE2_PreferredActionTemplateItems')
		PRINT '<<< CREATED INDEX PreferredActionTemplateItems.XIE2_PreferredActionTemplateItems >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX PreferredActionTemplateItems.XIE2_PreferredActionTemplateItems >>>', 16, 1)		
		END	 
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('PreferredActionTemplateItems') AND name='XIE3_PreferredActionTemplateItems')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE3_PreferredActionTemplateItems] ON [dbo].[PreferredActionTemplateItems] 
		(
		ListPageScreenId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('PreferredActionTemplateItems') AND name='XIE3_PreferredActionTemplateItems')
		PRINT '<<< CREATED INDEX PreferredActionTemplateItems.XIE3_PreferredActionTemplateItems >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX PreferredActionTemplateItems.XIE3_PreferredActionTemplateItems >>>', 16, 1)		
		END	 
 
/* 
 * TABLE: PreferredActionTemplateItems 
 */	

ALTER TABLE PreferredActionTemplateItems ADD CONSTRAINT PreferredActionTemplates_PreferredActionTemplateItems_FK 
	FOREIGN KEY (PreferredActionTemplateId)
	REFERENCES PreferredActionTemplates(PreferredActionTemplateId)	
	
ALTER TABLE PreferredActionTemplateItems ADD CONSTRAINT Screens_PreferredActionTemplateItems_FK 
	FOREIGN KEY (AssociatedScreenId)
	REFERENCES Screens(ScreenId)	
	
ALTER TABLE PreferredActionTemplateItems ADD CONSTRAINT Screens_PreferredActionTemplateItems_FK2 
	FOREIGN KEY (ListPageScreenId)
	REFERENCES Screens(ScreenId)		
			
PRINT 'STEP 4(B) COMPLETED'
		
END

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='PreferredClientBannerItems')
BEGIN
/*  
 * TABLE: PreferredActionTemplateItems 
 */
 
 CREATE TABLE PreferredClientBannerItems(
		PreferredClientBannerItemId			INT	identity(1,1)		NOT NULL,
		CreatedBy							type_CurrentUser		NOT NULL,
		CreatedDate							type_CurrentDatetime	NOT NULL,
		ModifiedBy							type_CurrentUser		NOT NULL,
		ModifiedDate						type_CurrentDatetime	NOT NULL,
		RecordDeleted						type_YOrN				NULL
											CHECK (RecordDeleted in	('Y','N')),	
		DeletedBy							type_UserId				NULL,
		DeletedDate							datetime				NULL,
		PreferredActionTemplateId			int						NULL,
		BannerId							int						NULL,
		CONSTRAINT PreferredClientBannerItems_PK PRIMARY KEY CLUSTERED (PreferredClientBannerItemId)
 ) 
 IF OBJECT_ID('PreferredClientBannerItems') IS NOT NULL
	PRINT '<<< CREATED TABLE PreferredClientBannerItems >>>'
ELSE
	RAISERROR('<<< FAILED CREATING TABLE PreferredClientBannerItems >>>', 16, 1)	
	
 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('PreferredClientBannerItems') AND name='XIE1_PreferredClientBannerItems')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_PreferredClientBannerItems] ON [dbo].[PreferredClientBannerItems] 
		(
		PreferredActionTemplateId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('PreferredClientBannerItems') AND name='XIE1_PreferredClientBannerItems')
		PRINT '<<< CREATED INDEX PreferredClientBannerItems.XIE1_PreferredClientBannerItems >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX PreferredClientBannerItems.XIE1_PreferredClientBannerItems >>>', 16, 1)		
		END
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('PreferredClientBannerItems') AND name='XIE2_PreferredClientBannerItems')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_PreferredClientBannerItems] ON [dbo].[PreferredClientBannerItems] 
		(
		BannerId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('PreferredClientBannerItems') AND name='XIE2_PreferredClientBannerItems')
		PRINT '<<< CREATED INDEX PreferredClientBannerItems.XIE2_PreferredActionTemplateItems >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX PreferredClientBannerItems.XIE2_PreferredClientBannerItems >>>', 16, 1)		
		END	 
		 
 
/* 
 * TABLE: PreferredClientBannerItems 
 */	

ALTER TABLE PreferredClientBannerItems ADD CONSTRAINT PreferredActionTemplates_PreferredClientBannerItems_FK 
	FOREIGN KEY (PreferredActionTemplateId)
	REFERENCES PreferredActionTemplates(PreferredActionTemplateId)	
	
ALTER TABLE PreferredClientBannerItems ADD CONSTRAINT Banners_PreferredClientBannerItems_FK 
	FOREIGN KEY (BannerId)
	REFERENCES Banners(BannerId)	

PRINT 'STEP 4(C) COMPLETED'
		
END

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='ClientPopUpConfirmations')
BEGIN
/*  
 * TABLE: ClientPopUpConfirmations 
 */
 
 CREATE TABLE ClientPopUpConfirmations(
		ClientPopUpConfirmationId			INT	identity(1,1)		NOT NULL,
		CreatedBy							type_CurrentUser		NOT NULL,
		CreatedDate							type_CurrentDatetime	NOT NULL,
		ModifiedBy							type_CurrentUser		NOT NULL,
		ModifiedDate						type_CurrentDatetime	NOT NULL,
		RecordDeleted						type_YOrN				NULL
											CHECK (RecordDeleted in	('Y','N')),	
		DeletedBy							type_UserId				NULL,
		DeletedDate							datetime				NULL,
		StaffId								int						NULL,
		CONSTRAINT ClientPopUpConfirmations_PK PRIMARY KEY CLUSTERED (ClientPopUpConfirmationId)
 ) 
 IF OBJECT_ID('ClientPopUpConfirmations') IS NOT NULL
	PRINT '<<< CREATED TABLE ClientPopUpConfirmations >>>'
ELSE
	RAISERROR('<<< FAILED CREATING TABLE ClientPopUpConfirmations >>>', 16, 1)	
	
 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ClientPopUpConfirmations') AND name='XIE1_ClientPopUpConfirmations')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_ClientPopUpConfirmations] ON [dbo].[ClientPopUpConfirmations] 
		(
		StaffId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ClientPopUpConfirmations') AND name='XIE1_ClientPopUpConfirmations')
		PRINT '<<< CREATED INDEX ClientPopUpConfirmations.XIE1_ClientPopUpConfirmations >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ClientPopUpConfirmations.XIE1_ClientPopUpConfirmations >>>', 16, 1)		
		END
		 
 
/* 
 * TABLE: ClientPopUpConfirmations 
 */	
	
ALTER TABLE ClientPopUpConfirmations ADD CONSTRAINT Staff_ClientPopUpConfirmations_FK 
	FOREIGN KEY (StaffId)
	REFERENCES Staff(StaffId)	

PRINT 'STEP 4(D) COMPLETED'
		
END



----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 18.20)
BEGIN
Update SystemConfigurations set DataModelVersion=18.21
PRINT 'STEP 7 COMPLETED'
END
Go

