----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.41)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.41 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
-------------------------------------------------------------

------ STEP 3 ------------
--END Of STEP 3------------
------ STEP 4 ----------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='MDExternalVocabularyDescriptions')
 BEGIN
/* 
 * TABLE: MDExternalVocabularyDescriptions 
 */
CREATE TABLE MDExternalVocabularyDescriptions(
		MDExternalVocabularyDescriptionId			int identity(1,100)		NOT NULL,
		CreatedBy									type_CurrentUser		NOT NULL,
		CreatedDate									type_CurrentDatetime    NOT NULL,
		ModifiedBy									type_CurrentUser        NOT NULL,
		ModifiedDate								type_CurrentDatetime    NOT NULL,
		RecordDeleted								type_YOrN               NULL
													CHECK (RecordDeleted in ('Y','N')),
		DeletedBy									type_UserId              NULL,
		DeletedDate									datetime                 NULL, 
		MDExternalVocabularyIdentifier				varchar(500)			 NOT NULL,
		MDExternalVocabularyType					int						 NULL, 
		MDExternalVocabularySequence				int						 NULL, 
		MDExternalVocabularyDescription				varchar(500)			 NULL, 
	CONSTRAINT MDExternalVocabularyDescriptions_PK PRIMARY KEY CLUSTERED (MDExternalVocabularyDescriptionId) 
 )
 
 IF OBJECT_ID('MDExternalVocabularyDescriptions') IS NOT NULL
    PRINT '<<< CREATED TABLE  MDExternalVocabularyDescriptions >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE MDExternalVocabularyDescriptions >>>', 16, 1)
    
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ClientDisclosures') AND name='XIE1_MDExternalVocabularyDescriptions')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_MDExternalVocabularyDescriptions] ON [dbo].[MDExternalVocabularyDescriptions] 
		(
		MDExternalVocabularyIdentifier ASC,
		MDExternalVocabularyType ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('MDExternalVocabularyDescriptions') AND name='XIE1_MDExternalVocabularyDescriptions')
		PRINT '<<< CREATED INDEX MDExternalVocabularyDescriptions.XIE1_MDExternalVocabularyDescriptions >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX MDExternalVocabularyDescriptions.XIE1_MDExternalVocabularyDescriptions >>>', 16, 1)		
		END	 
        
/* 
 * TABLE:  MDExternalVocabularyDescriptions 
 */  
 
   
     PRINT 'STEP 4(A) COMPLETED'
 END 
 
 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='MDExternalVocabularyMappings')
 BEGIN
/* 
 * TABLE: MDExternalVocabularyMappings 
 */
CREATE TABLE MDExternalVocabularyMappings(
		MDExternalVocabularyMappingId				int identity(1,100)		NOT NULL,
		CreatedBy									type_CurrentUser		NOT NULL,
		CreatedDate									type_CurrentDatetime    NOT NULL,
		ModifiedBy									type_CurrentUser        NOT NULL,
		ModifiedDate								type_CurrentDatetime    NOT NULL,
		RecordDeleted								type_YOrN               NULL
													CHECK (RecordDeleted in ('Y','N')),
		DeletedBy									type_UserId              NULL,
		DeletedDate									datetime                 NULL, 
		FirstDatabankVocabularyIdentifier			varchar(500)			 NOT NULL,
		FirstDatabankVocabularyType					int						 NULL, 
		MDExternalVocabularyIdentifier				varchar(500)			 NOT NULL,
		MDExternalVocabularyType					int						 NULL, 
		MDVocabularyLinkType						int						 NULL, 
	CONSTRAINT MDExternalVocabularyMappings_PK PRIMARY KEY CLUSTERED (MDExternalVocabularyMappingId) 
 )
 
 IF OBJECT_ID('MDExternalVocabularyMappings') IS NOT NULL
    PRINT '<<< CREATED TABLE  MDExternalVocabularyMappings >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE MDExternalVocabularyMappings >>>', 16, 1)
    
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('MDExternalVocabularyMappings') AND name='XIE1_MDExternalVocabularyMappings')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_MDExternalVocabularyMappings] ON [dbo].[MDExternalVocabularyMappings] 
		(
		FirstDatabankVocabularyIdentifier ASC,
		FirstDatabankVocabularyType ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('MDExternalVocabularyMappings') AND name='XIE1_MDExternalVocabularyMappings')
		PRINT '<<< CREATED INDEX MDExternalVocabularyMappings.XIE1_MDExternalVocabularyMappings >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX MDExternalVocabularyMappings.XIE1_MDExternalVocabularyMappings >>>', 16, 1)		
		END	 
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('MDExternalVocabularyMappings') AND name='XIE2_MDExternalVocabularyMappings')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_MDExternalVocabularyMappings] ON [dbo].[MDExternalVocabularyMappings] 
		(
		MDExternalVocabularyIdentifier ASC,
		MDExternalVocabularyType ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('MDExternalVocabularyMappings') AND name='XIE2_MDExternalVocabularyMappings')
		PRINT '<<< CREATED INDEX MDExternalVocabularyMappings.XIE2_MDExternalVocabularyMappings >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX MDExternalVocabularyMappings.XIE2_MDExternalVocabularyMappings >>>', 16, 1)		
		END	 
        
/* 
 * TABLE:  MDExternalVocabularyMappings 
 */  
 
   
     PRINT 'STEP 4(B) COMPLETED'
 END 
 
 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='MDExternalConceptMappings')
 BEGIN
/* 
 * TABLE: MDExternalConceptMappings 
 */
CREATE TABLE MDExternalConceptMappings(
		MDExternalConceptMappingId					int identity(1,100)		NOT NULL,
		CreatedBy									type_CurrentUser		NOT NULL,
		CreatedDate									type_CurrentDatetime    NOT NULL,
		ModifiedBy									type_CurrentUser        NOT NULL,
		ModifiedDate								type_CurrentDatetime    NOT NULL,
		RecordDeleted								type_YOrN               NULL
													CHECK (RecordDeleted in ('Y','N')),
		DeletedBy									type_UserId              NULL,
		DeletedDate									datetime                 NULL, 
		FirstDatabankVocabularyIdentifier			varchar(500)			 NULL,
		FirstDatabankVocabularyType					int						 NULL,
		MDExternalVocabularyIdentifier				varchar(500)			 NOT NULL,
		MDExternalVocabularyType					int						 NULL,
		FirstDatabankVocabularyDescription			varchar(500)			 NOT NULL,
		FirstDatabankVocabularyStatusCode			int						 NULL,
		FirstDatabankVocabularyPicklistIndicator	int						 NULL,
		FirstDatabankVocabularyMultisetIndicator	int						 NULL,
		MDExternalVocabularyDescription				varchar(500)			 NULL,
		MDExternalVocabularyStatusCode				int						 NULL,
		RXNormCode									varchar(255)			 NULL,
		MappingAddDate								datetime				 NULL,
		MappingInactiveDate							datetime				 NULL,
	CONSTRAINT MDExternalConceptMappings_PK PRIMARY KEY CLUSTERED (MDExternalConceptMappingId) 
 )
 
 IF OBJECT_ID('MDExternalConceptMappings') IS NOT NULL
    PRINT '<<< CREATED TABLE  MDExternalConceptMappings >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE MDExternalConceptMappings >>>', 16, 1)
    
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('MDExternalConceptMappings') AND name='XIE1_MDExternalConceptMappings')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_MDExternalConceptMappings] ON [dbo].[MDExternalConceptMappings] 
		(
		FirstDatabankVocabularyType ASC,
		FirstDatabankVocabularyIdentifier ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('MDExternalConceptMappings') AND name='XIE1_MDExternalConceptMappings')
		PRINT '<<< CREATED INDEX MDExternalConceptMappings.XIE1_MDExternalConceptMappings >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX MDExternalConceptMappings.XIE1_MDExternalConceptMappings >>>', 16, 1)		
		END	 
		

/* 
 * TABLE:  MDExternalConceptMappings 
 */  
 
   
     PRINT 'STEP 4(C) COMPLETED'
 END 
 
------END Of STEP 4---------------

------ STEP 5 ----------------

-------END STEP 5-------------
------ STEP 6  ----------

----END Of STEP 6 ------------

------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 18.41)
BEGIN
Update SystemConfigurations set DataModelVersion=18.42
PRINT 'STEP 7 COMPLETED'
END
Go
