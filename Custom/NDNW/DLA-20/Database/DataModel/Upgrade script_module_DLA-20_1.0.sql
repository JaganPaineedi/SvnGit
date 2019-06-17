----- STEP 1 ----------

------ STEP 2 ----------
--Part1 Begin
--Part1 Ends

--Part2 Begins


--Part2 Ends
-----End of Step 2 -------

------ STEP 3 ------------

------ END OF STEP 3 -----

------ STEP 4 ----------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentDLA20s')
BEGIN
/* 
 * TABLE: CustomDocumentDLA20s 
 */
 CREATE TABLE CustomDocumentDLA20s( 
		DocumentVersionId			int					 NOT NULL,
		CreatedBy					type_CurrentUser     NOT NULL,
		CreatedDate					type_CurrentDatetime NOT NULL,
		ModifiedBy					type_CurrentUser     NOT NULL,
		ModifiedDate				type_CurrentDatetime NOT NULL,
		RecordDeleted				type_YOrN			 NULL
									CHECK (RecordDeleted in ('Y','N')),
		DeletedBy					type_UserId          NULL,
		DeletedDate					datetime             NULL,
		CONSTRAINT CustomDocumentDLA20s_PK PRIMARY KEY CLUSTERED (DocumentVersionId) 
 )
 
  IF OBJECT_ID('CustomDocumentDLA20s') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentDLA20s >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentDLA20s >>>', 16, 1)
/* 
 * TABLE: CustomDocumentDLA20s 
 */   

ALTER TABLE CustomDocumentDLA20s ADD CONSTRAINT DocumentVersions_CustomDocumentDLA20s_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
 
 PRINT 'STEP 4(A) COMPLETED'
 END
 		
		
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomHRMActivities')
BEGIN
/* 
 * TABLE: CustomHRMActivities 
 */
 CREATE TABLE CustomHRMActivities( 
		HRMActivityId				int identity(1,1)    NOT NULL,
		CreatedBy					type_CurrentUser     NOT NULL,
		CreatedDate					type_CurrentDatetime NOT NULL,
		ModifiedBy					type_CurrentUser     NOT NULL,
		ModifiedDate				type_CurrentDatetime NOT NULL,
		RecordDeleted				type_YOrN			 NULL
									CHECK (RecordDeleted in ('Y','N')),
		DeletedBy					type_UserId          NULL,
		DeletedDate					datetime             NULL,
		HRMActivityDescription		type_Comment2		 NULL,
		SortOrder					int					 NULL,
		Active						type_Active			 NULL,
		AssociatedHRMNeedId			int					 NULL,
		Example						type_Comment2		 NULL,																																																																																																																	
	CONSTRAINT CustomHRMActivities_PK PRIMARY KEY CLUSTERED (HRMActivityId) 
 )
 
  IF OBJECT_ID('CustomHRMActivities') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomHRMActivities >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomHRMActivities >>>', 16, 1)
/* 
 * TABLE: CustomHRMActivities 
 */     
  PRINT 'STEP 4(B) COMPLETED'
 END
 
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDailyLivingActivityScores')
BEGIN
/* 
 * TABLE: CustomDailyLivingActivityScores 
 */
 CREATE TABLE CustomDailyLivingActivityScores( 
		DailyLivingActivityScoreId	int identity(1,1)    NOT NULL,
		CreatedBy					type_CurrentUser     NOT NULL,
		CreatedDate					type_CurrentDatetime NOT NULL,
		ModifiedBy					type_CurrentUser     NOT NULL,
		ModifiedDate				type_CurrentDatetime NOT NULL,
		RecordDeleted				type_YOrN			 NULL
									CHECK (RecordDeleted in ('Y','N')),
		DeletedBy					type_UserId          NULL,
		DeletedDate					datetime             NULL,
		DocumentVersionId			int					 NULL,
		HRMActivityId				int					 NULL,		
		ActivityScore				smallint			 NULL,
		ActivityComment				type_Comment2		 NULL,
		RowIdentifier				type_GUID			 NOT NULL,																																																																																																													
	CONSTRAINT CustomDailyLivingActivityScores_PK PRIMARY KEY CLUSTERED (DailyLivingActivityScoreId) 
 )
 
  IF OBJECT_ID('CustomDailyLivingActivityScores') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDailyLivingActivityScores >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDailyLivingActivityScores >>>', 16, 1)
/* 
 * TABLE: CustomDailyLivingActivityScores 
 */   

ALTER TABLE CustomDailyLivingActivityScores ADD CONSTRAINT DocumentVersions_CustomDailyLivingActivityScores_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
    
ALTER TABLE CustomDailyLivingActivityScores ADD CONSTRAINT CustomHRMActivities_CustomDailyLivingActivityScores_FK
    FOREIGN KEY (HRMActivityId)
    REFERENCES CustomHRMActivities(HRMActivityId)
    
     PRINT 'STEP 4(C) COMPLETED'
 END
 
 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDailyLivingActivities')
BEGIN
/* 
 * TABLE: CustomDailyLivingActivities 
 */
 CREATE TABLE CustomDailyLivingActivities( 
		DailyLivingActivityId					int identity(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		AssociatedHRMNeedId						int					 NULL,
		HRMActivityDescription					type_Comment2		 NULL,
		SortOrder								int					 NULL,
		Active									type_Active			 NULL
												CHECK (Active in ('Y','N')),
		Example									type_Comment2		 NULL,
		CONSTRAINT CustomDailyLivingActivities_PK PRIMARY KEY CLUSTERED (DailyLivingActivityId) 
 )
  IF OBJECT_ID('CustomDailyLivingActivities') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDailyLivingActivities >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDailyLivingActivities >>>', 16, 1)
/* 
 * TABLE: CustomDailyLivingActivities 
 */
    
 PRINT 'STEP 4(D) COMPLETED'
 END
			
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomYouthDLAScores')
BEGIN
/* 
 * TABLE: CustomYouthDLAScores 
 */
 CREATE TABLE CustomYouthDLAScores( 
		YouthDLAScoreId							int identity(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		DocumentVersionId						int					 NULL,
		DailyLivingActivityId					int					 NULL,
		ActivityScore							smallint			 NULL,
		ActivityComment							type_Comment2		 NULL,
		CONSTRAINT CustomYouthDLAScores_PK PRIMARY KEY CLUSTERED (YouthDLAScoreId) 
 )
  IF OBJECT_ID('CustomYouthDLAScores') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomYouthDLAScores >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomYouthDLAScores >>>', 16, 1)
/* 
 * TABLE: CustomYouthDLAScores 
 */
    
	ALTER TABLE CustomYouthDLAScores ADD CONSTRAINT DocumentVersions_CustomYouthDLAScores_FK
		FOREIGN KEY (DocumentVersionId)
		REFERENCES DocumentVersions(DocumentVersionId)
		
	ALTER TABLE CustomYouthDLAScores ADD CONSTRAINT CustomDailyLivingActivities_CustomYouthDLAScores_FK
		FOREIGN KEY (DailyLivingActivityId)
		REFERENCES CustomDailyLivingActivities(DailyLivingActivityId)
    
 PRINT 'STEP 4(E) COMPLETED'
 END
		
  ---------------------------------------------------------------
--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
IF NOT EXISTS (SELECT [key] FROM SystemConfigurationKeys WHERE [key] = 'CDM_DLA-20')
	BEGIN
		INSERT INTO SystemConfigurationKeys
				   (CreatedBy
				   ,CreateDate 
				   ,ModifiedBy
				   ,ModifiedDate
				   ,[key]
				   ,Value
				   )
			 VALUES    
				   ('SHSDBA'
				   ,GETDATE()
				   ,'SHSDBA'
				   ,GETDATE()
				   ,'CDM_DLA-20'
				   ,'1.0'
				   )
		PRINT 'STEP 7 COMPLETED'
	END
 GO
