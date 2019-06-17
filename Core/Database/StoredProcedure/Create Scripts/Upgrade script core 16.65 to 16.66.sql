----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 16.65)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 16.65 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of Step 2 -------

------ STEP 3 ------------

------ End of STEP 3 ------------
------ STEP 4 ---------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='ListPageColumnConfigurations')
BEGIN
/*  
 * TABLE: ListPageColumnConfigurations 
 */
 CREATE TABLE ListPageColumnConfigurations(	
			ListPageColumnConfigurationId 			int	identity(1,1)		NOT NULL,
			CreatedBy								type_CurrentUser		NOT NULL,
			CreatedDate								type_CurrentDatetime	NOT NULL,
			ModifiedBy								type_CurrentUser		NOT NULL,
			ModifiedDate							type_CurrentDatetime	NOT NULL,
			RecordDeleted							type_YOrN				NULL
													CHECK (RecordDeleted in ('Y','N')),
			DeletedBy								type_UserId				NULL,
			DeletedDate								datetime				NULL,
			ScreenId								INT						NOT NULL,		
			StaffId									INT						NULL,
			ViewName								VARCHAR(500)			NULL,
			Active									type_Active				NOT NULL
													CHECK (Active in ('Y','N')),
			DefaultView								type_YOrN				NULL
													CHECK (DefaultView in ('Y','N')),
			Template								type_YOrN				NULL
													CHECK (Template in ('Y','N')),
			CONSTRAINT ListPageColumnConfigurations_PK PRIMARY KEY CLUSTERED (ListPageColumnConfigurationId)

 )
  IF OBJECT_ID('ListPageColumnConfigurations') IS NOT NULL
    PRINT '<<< CREATED TABLE ListPageColumnConfigurations >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE ListPageColumnConfigurations >>>', 16, 1)
    
  IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ListPageColumnConfigurations') AND name='XIE1_ListPageColumnConfigurations')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_ListPageColumnConfigurations] ON [dbo].[ListPageColumnConfigurations] 
		(
		ScreenId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ListPageColumnConfigurations') AND name='XIE1_ListPageColumnConfigurations')
		PRINT '<<< CREATED INDEX ListPageColumnConfigurations.XIE1_ListPageColumnConfigurations >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ListPageColumnConfigurations.XIE1_ListPageColumnConfigurations >>>', 16, 1)		
		END	 
		
/* 
 * TABLE: ListPageColumnConfigurations 
 */  
 		
ALTER TABLE ListPageColumnConfigurations ADD CONSTRAINT Screens_ListPageColumnConfigurations_FK 
    FOREIGN KEY (ScreenId)
    REFERENCES Screens(ScreenId)
    
ALTER TABLE ListPageColumnConfigurations ADD CONSTRAINT Staff_ListPageColumnConfigurations_FK 
    FOREIGN KEY (StaffId)
    REFERENCES Staff(StaffId)		
     			   			
EXEC sys.sp_addextendedproperty 'ListPageColumnConfigurations_Description'
	,'StaffId is only specified if staff are creating their own view for this list page'
	,'schema'
	,'dbo'
	,'table'
	,'ListPageColumnConfigurations'
	,'column'
	,'StaffId'  
	        
    PRINT 'STEP 4(A) COMPLETED'
END

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='ListPageColumnConfigurationColumns')
BEGIN
/*   
 * TABLE: ListPageColumnConfigurationColumns 
 */
 CREATE TABLE ListPageColumnConfigurationColumns(	
			ListPageColumnConfigurationColumnId 	int	identity(1,1)		NOT NULL,
			CreatedBy								type_CurrentUser		NOT NULL,
			CreatedDate								type_CurrentDatetime	NOT NULL,
			ModifiedBy								type_CurrentUser		NOT NULL,
			ModifiedDate							type_CurrentDatetime	NOT NULL,
			RecordDeleted							type_YOrN				NULL
													CHECK (RecordDeleted in ('Y','N')),
			DeletedBy								type_UserId				NULL,
			DeletedDate								datetime				NULL,
			ListPageColumnConfigurationId 			INT						NOT NULL,		
			FieldName								VARCHAR(500)			NOT NULL,       
			Caption									VARCHAR(500)			NOT NULL,       
			DisplayAs								VARCHAR(500)			NULL,           
			SortOrder								INT						NULL,           
			ShowColumn								type_YOrN				NULL
													CHECK (ShowColumn in ('Y','N')),        
			Width									INT					    NULL,       
			Fixed									type_YOrN				NULL
													CHECK (Fixed in ('Y','N')),             
			CONSTRAINT ListPageColumnConfigurationColumns_PK PRIMARY KEY CLUSTERED (ListPageColumnConfigurationColumnId)

 )
  IF OBJECT_ID('ListPageColumnConfigurationColumns') IS NOT NULL
    PRINT '<<< CREATED TABLE ListPageColumnConfigurationColumns >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE ListPageColumnConfigurationColumns >>>', 16, 1)
    
  IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ListPageColumnConfigurationColumns') AND name='XIE1_ListPageColumnConfigurationColumns')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_ListPageColumnConfigurationColumns] ON [dbo].[ListPageColumnConfigurationColumns] 
		(
		ListPageColumnConfigurationId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ListPageColumnConfigurationColumns') AND name='XIE1_ListPageColumnConfigurationColumns')
		PRINT '<<< CREATED INDEX ListPageColumnConfigurationColumns.XIE1_ListPageColumnConfigurationColumns >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ListPageColumnConfigurationColumns.XIE1_ListPageColumnConfigurationColumns >>>', 16, 1)		
		END	 
		
/* 
 * TABLE: ListPageColumnConfigurationColumns 
 */  
 		
ALTER TABLE ListPageColumnConfigurationColumns ADD CONSTRAINT ListPageColumnConfigurations_ListPageColumnConfigurationColumns_FK 
    FOREIGN KEY (ListPageColumnConfigurationId)
    REFERENCES ListPageColumnConfigurations(ListPageColumnConfigurationId) 
 
 EXEC sys.sp_addextendedproperty 'ListPageColumnConfigurationColumns_Description'
	,'FieldName is the name of the field returned by the List Page stored procedure'
	,'schema'
	,'dbo'
	,'table'
	,'ListPageColumnConfigurationColumns'
	,'column'
	,'FieldName' 
	
 EXEC sys.sp_addextendedproperty 'ListPageColumnConfigurationColumns_Description'
	,'Caption  is The default column header'
	,'schema'
	,'dbo'
	,'table'
	,'ListPageColumnConfigurationColumns'
	,'column'
	,'Caption' 
	
 EXEC sys.sp_addextendedproperty 'ListPageColumnConfigurationColumns_Description'
	,'DisplayAs Overrides the default column header'
	,'schema'
	,'dbo'
	,'table'
	,'ListPageColumnConfigurationColumns'
	,'column'
	,'DisplayAs' 
	
EXEC sys.sp_addextendedproperty 'ListPageColumnConfigurationColumns_Description'
	,'SortOrder Determines the visible index'
	,'schema'
	,'dbo'
	,'table'
	,'ListPageColumnConfigurationColumns'
	,'column'
	,'SortOrder' 
	
EXEC sys.sp_addextendedproperty 'ListPageColumnConfigurationColumns_Description'
	,'ShowColumn Determines if the column is visible and rendered '
	,'schema'
	,'dbo'
	,'table'
	,'ListPageColumnConfigurationColumns'
	,'column'
	,'ShowColumn' 
	
EXEC sys.sp_addextendedproperty 'ListPageColumnConfigurationColumns_Description'
	,'Width  Determines width in pixels of column '
	,'schema'
	,'dbo'
	,'table'
	,'ListPageColumnConfigurationColumns'
	,'column'
	,'Width' 
	
EXEC sys.sp_addextendedproperty 'ListPageColumnConfigurationColumns_Description'
	,'Fixed  Determines if the column is fixed and not movable, columns can only be fixed to the left side of the grid'
	,'schema'
	,'dbo'
	,'table'
	,'ListPageColumnConfigurationColumns'
	,'column'
	,'Fixed'  			   			
        
    PRINT 'STEP 4(B) COMPLETED'
END

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 16.65)
BEGIN
Update SystemConfigurations set DataModelVersion=16.66
PRINT 'STEP 7 COMPLETED'
END
Go

