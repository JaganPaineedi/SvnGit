----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.51)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.51 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
-------------------------------------------------------------

------ STEP 3 ------------

--END Of STEP 3------------
------ STEP 4 ----------
IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='ListPageColumnConfigurationColumnLinks')
BEGIN
/*  
 * TABLE: ListPageColumnConfigurationColumnLinks
 */ 
CREATE TABLE ListPageColumnConfigurationColumnLinks(
		ListPageColumnConfigurationColumnLinkId 	int	identity(1,1)		NOT NULL,
		CreatedBy									type_CurrentUser		NOT NULL,
		CreatedDate									type_CurrentDatetime	NOT NULL,
		ModifiedBy									type_CurrentUser		NOT NULL,
		ModifiedDate								type_CurrentDatetime	NOT NULL,
		RecordDeleted								type_YOrN				NULL
													CHECK (RecordDeleted in ('Y','N')),
		DeletedBy									type_UserId				NULL,
		DeletedDate									datetime				NULL,
		ListPageColumnConfigurationColumnId			int						NULL,
        ScreenId									int						NULL,
        PopUp										type_YOrN				NULL
													CHECK (PopUp in ('Y','N')),
		CONSTRAINT ListPageColumnConfigurationColumnLinks_PK PRIMARY KEY CLUSTERED (ListPageColumnConfigurationColumnLinkId) 
) 

 IF OBJECT_ID('ListPageColumnConfigurationColumnLinks') IS NOT NULL
    PRINT '<<< CREATED TABLE ListPageColumnConfigurationColumnLinks >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE ListPageColumnConfigurationColumnLinks >>>', 16, 1)
    
 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ListPageColumnConfigurationColumnLinks') AND name='XIE1_ListPageColumnConfigurationColumnLinks')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_ListPageColumnConfigurationColumnLinks] ON [dbo].[ListPageColumnConfigurationColumnLinks] 
		(
		ListPageColumnConfigurationColumnId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ListPageColumnConfigurationColumnLinks') AND name='XIE1_ListPageColumnConfigurationColumnLinks')
		PRINT '<<< CREATED INDEX ListPageColumnConfigurationColumnLinks.XIE1_ListPageColumnConfigurationColumnLinks >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ListPageColumnConfigurationColumnLinks.XIE1_ListPageColumnConfigurationColumnLinks >>>', 16, 1)		
		END	  
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ListPageColumnConfigurationColumnLinks') AND name='XIE2_ListPageColumnConfigurationColumnLinks')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_ListPageColumnConfigurationColumnLinks] ON [dbo].[ListPageColumnConfigurationColumnLinks] 
		(
		ScreenId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ListPageColumnConfigurationColumnLinks') AND name='XIE2_ListPageColumnConfigurationColumnLinks')
		PRINT '<<< CREATED INDEX ListPageColumnConfigurationColumnLinks.XIE2_ListPageColumnConfigurationColumnLinks >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ListPageColumnConfigurationColumnLinks.XIE2_ListPageColumnConfigurationColumnLinks >>>', 16, 1)		
		END	 
 
    
/* 
 * TABLE: ListPageColumnConfigurationColumnLinks 
 */ 
 
  ALTER TABLE ListPageColumnConfigurationColumnLinks ADD CONSTRAINT ListPageColumnConfigurationColumns_ListPageColumnConfigurationColumnLinks_FK
    FOREIGN KEY (ListPageColumnConfigurationColumnId)
    REFERENCES ListPageColumnConfigurationColumns(ListPageColumnConfigurationColumnId)
    
 ALTER TABLE ListPageColumnConfigurationColumnLinks ADD CONSTRAINT Screens_ListPageColumnConfigurationColumnLinks_FK
    FOREIGN KEY (ScreenId)
    REFERENCES Screens(ScreenId)
       
PRINT 'STEP 4(A) COMPLETED'
END


IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='ListPageColumnConfigurationColumnLinkParameters')
BEGIN
/*  
 * TABLE: ListPageColumnConfigurationColumnLinkParameters
 */ 
CREATE TABLE ListPageColumnConfigurationColumnLinkParameters(
		ListPageColumnConfigurationColumnLinkParameterId 	int	identity(1,1)		NOT NULL,
		CreatedBy											type_CurrentUser		NOT NULL,
		CreatedDate											type_CurrentDatetime	NOT NULL,
		ModifiedBy											type_CurrentUser		NOT NULL,
		ModifiedDate										type_CurrentDatetime	NOT NULL,
		RecordDeleted										type_YOrN				NULL
															CHECK (RecordDeleted in ('Y','N')),
		DeletedBy											type_UserId				NULL,
		DeletedDate											datetime				NULL,
		ListPageColumnConfigurationColumnLinkId				int						NULL,
		ListPageColumnConfigurationColumnId					int						NULL,
		KeyColumn											type_YOrN				NULL
															CHECK (KeyColumn in ('Y','N')),
		CONSTRAINT ListPageColumnConfigurationColumnLinkParameters_PK PRIMARY KEY CLUSTERED (ListPageColumnConfigurationColumnLinkParameterId) 
) 

 IF OBJECT_ID('ListPageColumnConfigurationColumnLinkParameters') IS NOT NULL
    PRINT '<<< CREATED TABLE ListPageColumnConfigurationColumnLinkParameters >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE ListPageColumnConfigurationColumnLinkParameters >>>', 16, 1)
    
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ListPageColumnConfigurationColumnLinkParameters') AND name='XIE1_ListPageColumnConfigurationColumnLinkParameters')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_ListPageColumnConfigurationColumnLinkParameters] ON [dbo].[ListPageColumnConfigurationColumnLinkParameters] 
		(
		ListPageColumnConfigurationColumnId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ListPageColumnConfigurationColumnLinkParameters') AND name='XIE1_ListPageColumnConfigurationColumnLinkParameters')
		PRINT '<<< CREATED INDEX ListPageColumnConfigurationColumnLinkParameters.XIE1_ListPageColumnConfigurationColumnLinkParameters >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ListPageColumnConfigurationColumnLinkParameters.XIE1_ListPageColumnConfigurationColumnLinkParameters >>>', 16, 1)		
		END	  
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ListPageColumnConfigurationColumnLinkParameters') AND name='XIE2_ListPageColumnConfigurationColumnLinkParameters')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_ListPageColumnConfigurationColumnLinkParameters] ON [dbo].[ListPageColumnConfigurationColumnLinkParameters] 
		(
		ListPageColumnConfigurationColumnLinkId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ListPageColumnConfigurationColumnLinkParameters') AND name='XIE2_ListPageColumnConfigurationColumnLinkParameters')
		PRINT '<<< CREATED INDEX ListPageColumnConfigurationColumnLinkParameters.XIE2_ListPageColumnConfigurationColumnLinkParameters >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ListPageColumnConfigurationColumnLinkParameters.XIE2_ListPageColumnConfigurationColumnLinkParameters >>>', 16, 1)		
		END	   
     
/* 
 * TABLE: ListPageColumnConfigurationColumnLinkParameters 
 */ 
 
  ALTER TABLE ListPageColumnConfigurationColumnLinkParameters ADD CONSTRAINT ListPageColumnConfigurationColumns_ListPageColumnConfigurationColumnLinkParameters_FK
    FOREIGN KEY (ListPageColumnConfigurationColumnId)
    REFERENCES ListPageColumnConfigurationColumns(ListPageColumnConfigurationColumnId)    
 
  		
 ALTER TABLE ListPageColumnConfigurationColumnLinkParameters ADD CONSTRAINT ListPageColumnConfigurationColumnLinks_ListPageColumnConfigurationColumnLinkParameters_FK
    FOREIGN KEY (ListPageColumnConfigurationColumnLinkId)
    REFERENCES ListPageColumnConfigurationColumnLinks(ListPageColumnConfigurationColumnLinkId)
     
       
PRINT 'STEP 4(B) COMPLETED'
END

------END Of STEP 4---------------

------ STEP 5 ----------------

-------END STEP 5-------------
------ STEP 6  ----------

----END Of STEP 6 ------------

------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 18.51)
BEGIN
Update SystemConfigurations set DataModelVersion=18.52
PRINT 'STEP 7 COMPLETED'
END
Go
