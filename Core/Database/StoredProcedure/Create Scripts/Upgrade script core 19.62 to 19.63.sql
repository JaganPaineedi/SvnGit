----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 19.62)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 19.62 or update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
--Part1 Begin
--Part1 Ends

--Part2 Begins


--Part2 Ends
-----End of Step 2 -------

------ STEP 3 ------------

------ END OF STEP 3 -----

------ STEP 4 ----------

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='KPIMaster')
BEGIN
/*		 
 * TABLE:  KPIMaster 
 */
 CREATE TABLE KPIMaster( 
		KPIMasterId								int	IDENTITY(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		KPIName									varchar(100)		 NOT NULL,
		KPIDescription							varchar(max)		 NULL,
		Category								type_GlobalCode		 NULL,
		[Type]									type_GlobalCode		 NULL,
		CollectionPeriod						int					 NULL,
		RetentionPeriod							int					 NULL,
		CollectionMethod						type_GlobalCode		 NULL,
		Active									type_YOrN			 NULL
												CHECK (Active in ('Y','N')),
		RawData									type_YOrN			 NULL
												CHECK (RawData in ('Y','N')),
		RawDataTableName						varchar(128)		 NULL,
		CollectionStoredProcedure				varchar(100)		 NULL,
		AlertStoredProcedure					varchar(100)		 NULL,
		CONSTRAINT KPIMaster_PK PRIMARY KEY CLUSTERED (KPIMasterId) 
 )
 
 IF OBJECT_ID('KPIMaster') IS NOT NULL
    PRINT '<<< CREATED TABLE KPIMaster >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE KPIMaster >>>', 16, 1)
   
   
  /* 
 * TABLE: KPIMaster 
 */ 
 
     EXEC sys.sp_addextendedproperty 'KPIMaster_Description'
 ,'Category Column stores the GlobalCodeIds of Category ''KPICategory'''
 ,'schema'
 ,'dbo'
 ,'table'
 ,'KPIMaster'
 ,'column'
 ,'Category' 
        
        
     EXEC sys.sp_addextendedproperty 'KPIMaster_Description'
 ,'[Type] Column stores the GlobalCodeIds of Category ''KPIType'''
 ,'schema'
 ,'dbo'
 ,'table'
 ,'KPIMaster'
 ,'column'
 ,'[Type]' 
 
     EXEC sys.sp_addextendedproperty 'KPIMaster_Description'
 ,'CollectionPeriod Column stores the the timespan in seconds between the execution of Stored Procedure mentioned in CollectionStoredProcedure column'
 ,'schema'
 ,'dbo'
 ,'table'
 ,'KPIMaster'
 ,'column'
 ,'CollectionPeriod' 
  
      EXEC sys.sp_addextendedproperty 'KPIMaster_Description'
 ,'CollectionMethod Column stores the GlobalCodeIds of Category ''CollectionMethod''(either Automatic or manual)'
 ,'schema'
 ,'dbo'
 ,'table'
 ,'KPIMaster'
 ,'column'
 ,'CollectionMethod' 
     
    EXEC sys.sp_addextendedproperty 'KPIMaster_Description'
 ,'RawData Column stores to check whether we need to send the raw data to the mobile API'
 ,'schema'
 ,'dbo'
 ,'table'
 ,'KPIMaster'
 ,'column'
 ,'RawData' 
 
     EXEC sys.sp_addextendedproperty 'KPIMaster_Description'
 ,'CollectionStoredProcedure Column stores the SP name When we call the executable will be used to call the Stored Procedure' 
 ,'schema'
 ,'dbo'
 ,'table'
 ,'KPIMaster'
 ,'column'
 ,'CollectionStoredProcedure' 
 
  EXEC sys.sp_addextendedproperty 'KPIMaster_Description'
 ,'AlertStoredProcedure   Column stores the SP name which will be called by the executable once the Stored Procedure mentioned in collectionstoredprocedure column has been executed for a particular time interval'
 ,'schema'
 ,'dbo'
 ,'table'
 ,'KPIMaster'
 ,'column'
 ,'Category' 
        
           
 PRINT 'STEP 4(A) COMPLETED'
 END
 
 
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='KPIProcessedIds')
BEGIN

 CREATE TABLE KPIProcessedIds( 
		KPIProcessedId							int	IDENTITY(1,1)		NOT NULL,		
		CreatedBy								type_CurrentUser		NOT NULL,
		CreatedDate								type_CurrentDatetime	NOT NULL,
		ModifiedBy								type_CurrentUser		NOT NULL,
		ModifiedDate							type_CurrentDatetime	NOT NULL,
		RecordDeleted							type_YOrN				NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId				NULL,
		DeletedDate								datetime				NULL,
		KPIMasterId								int						NOT NULL,
		ProcessedId								int						NOT NULL,		
		CONSTRAINT KPIProcessedIds_PK PRIMARY KEY CLUSTERED (KPIProcessedId) 
 )
 
 IF OBJECT_ID('KPIProcessedIds') IS NOT NULL
    PRINT '<<< CREATED TABLE KPIProcessedIds >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE KPIProcessedIds >>>', 16, 1)
    
    
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[KPIProcessedIds]') AND name = N'XIE1_KPIProcessedIds')
  BEGIN
   CREATE NONCLUSTERED INDEX [XIE1_KPIProcessedIds] ON [dbo].[KPIProcessedIds] 
   (
   [KPIMasterId]  ASC
   )
   WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
   IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('KPIProcessedIds') AND name='XIE1_KPIProcessedIds')
   PRINT '<<< CREATED INDEX KPIProcessedIds.XIE1_KPIProcessedIds >>>'
   ELSE
   RAISERROR('<<< FAILED CREATING INDEX KPIProcessedIds.XIE1_KPIProcessedIds >>>', 16, 1)  
  END 
  
  
  /* 
 * TABLE: KPIProcessedIds 
 */ 
   ALTER TABLE KPIProcessedIds ADD CONSTRAINT KPIMaster_KPIProcessedIds_FK 
    FOREIGN KEY (KPIMasterId)
    REFERENCES KPIMaster(KPIMasterId) 
    
	EXEC sys.sp_addextendedproperty 'KPIProcessedIds_Description'
 ,'ProcessedId Column stores the Ids of Errorlog or IISLog' 
 ,'schema'
 ,'dbo'
 ,'table'
 ,'KPIProcessedIds'
 ,'column'
 ,'ProcessedId' 
  
 PRINT 'STEP 4(B) COMPLETED'
 END
 
 

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='IISLog')
BEGIN
/* 
 * TABLE: IISLog 
 */
 CREATE TABLE IISLog( 
		IISLogId								int	IDENTITY(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,	
		ReportingTime							datetime             NULL,	
		ReportingIP								varchar(20)			 NULL,
		IISLogDate								datetime             NULL,	
		IISLogTime								datetime             NULL,	
		ServerIP								varchar(20)			 NULL,	 
		ActionTakenByClient						varchar(20)			 NULL,
		FileBeingRequested						varchar(max)		 NULL,
		QueryBeingPerformedTheClient			varchar(max)		 NULL,
		Port									varchar(20)			 NULL,
		Username								varchar(20)			 NULL,
		ClientIP								varchar(20)			 NULL,
		UserAgent								varchar(500)		 NULL,
		PreviousSiteVisitedByTheUser			varchar(max)		 NULL,
		StatusOfTheAction						varchar(20)			 NULL,
		SubStatus								varchar(20)			 NULL,
		WindowsTerminology						varchar(20)			 NULL,
		TimeTaken								int					 NULL,
		IISLogFileName							varchar(100)		 NULL,
		CONSTRAINT IISLog_PK PRIMARY KEY CLUSTERED (IISLogId) 
 )
 
 IF OBJECT_ID('IISLog') IS NOT NULL
    PRINT '<<< CREATED TABLE IISLog >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE IISLog >>>', 16, 1)
    
    EXEC sys.sp_addextendedproperty 'IISLog_Description'
 ,'IISLog saves the IIS log information of the server into the database' 
 ,'schema'
 ,'dbo'
 ,'table'
 ,'IISLog'


     PRINT 'STEP 4(C) COMPLETED'
 END
 
 
 
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='IISLogFiles')
BEGIN
/* 
 * TABLE: IISLogFiles 
 */
 CREATE TABLE IISLogFiles( 
		IISLogFileId							int	IDENTITY(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,	
		IISLogFileName							varchar(100)		 NULL,	
		LastReadPosition						int					 NULL,	
		FileCreatedDate							datetime             NULL,	
		FileModifiedDate						datetime             NULL,	
		CONSTRAINT IISLogFiles_PK PRIMARY KEY CLUSTERED (IISLogFileId) 
 )
 
 IF OBJECT_ID('IISLogFiles') IS NOT NULL
    PRINT '<<< CREATED TABLE IISLogFiles >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE IISLogFiles >>>', 16, 1)    

    EXEC sys.sp_addextendedproperty 'IISLogFiles_Description'
 ,'IISLogFiles  maintains the records of the IIS log files which are sent by executable IISLogExtractor' 
 ,'schema'
 ,'dbo'
 ,'table'
 ,'IISLogFiles'

     PRINT 'STEP 4(D) COMPLETED'
 END

---------------------------------------------------------------
--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 19.62)
BEGIN
Update SystemConfigurations set DataModelVersion=19.63
PRINT 'STEP 7 COMPLETED'
END
Go