----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.19)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.19 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of Step 2 -------

------ STEP 3 ------------

------ STEP 4 ---------------
 
--This table will allow a many-to-many relationship between Sites and Categories
--NOTE: SiteCategory column in Sites table will become relic
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='SiteCategories')
BEGIN
/*  
 * TABLE: SiteCategories 
 */
 
 CREATE TABLE SiteCategories(
		SiteCategoryId						INT	identity(1,1)		NOT NULL,
		CreatedBy							type_CurrentUser		NOT NULL,
		CreatedDate							type_CurrentDatetime	NOT NULL,
		ModifiedBy							type_CurrentUser		NOT NULL,
		ModifiedDate						type_CurrentDatetime	NOT NULL,
		RecordDeleted						type_YOrN				NULL
											CHECK (RecordDeleted in	('Y','N')),	
		DeletedBy							type_UserId				NULL,
		DeletedDate							datetime				NULL,
		SiteId								int				        NULL,
		CategoryId							type_GlobalCode			NULL,			
		CONSTRAINT SiteCategories_PK PRIMARY KEY CLUSTERED (SiteCategoryId)
 ) 
 IF OBJECT_ID('SiteCategories') IS NOT NULL
	PRINT '<<< CREATED TABLE SiteCategories >>>'
ELSE
	RAISERROR('<<< FAILED CREATING TABLE SiteCategories >>>', 16, 1)	
	
 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('SiteCategories') AND name='XIE1_SiteCategories')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_SiteCategories] ON [dbo].[SiteCategories] 
		(
		SiteId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('SiteCategories') AND name='XIE1_SiteCategories')
		PRINT '<<< CREATED INDEX SiteCategories.XIE1_SiteCategories >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX SiteCategories.XIE1_SiteCategories >>>', 16, 1)		
		END	 
 
/* 
 * TABLE: SiteCategories 
 */	

ALTER TABLE SiteCategories ADD CONSTRAINT Sites_SiteCategories_FK 
	FOREIGN KEY (SiteId)
	REFERENCES Sites(SiteId)	
			
PRINT 'STEP 4(A) COMPLETED'
		
END
Go

--convert entries in SiteCategories column to entries SiteCategories table
IF COL_LENGTH('Sites','SiteCategory') IS NOT NULL
BEGIN
INSERT INTO SiteCategories (
	SiteId
	,CategoryId
	)
SELECT 
	SiteId
	,SiteCategory AS CategoryId
FROM Sites
WHERE SiteCategory IS NOT NULL
END
Go


----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 18.19)
BEGIN
Update SystemConfigurations set DataModelVersion=18.20
PRINT 'STEP 7 COMPLETED'
END
Go

