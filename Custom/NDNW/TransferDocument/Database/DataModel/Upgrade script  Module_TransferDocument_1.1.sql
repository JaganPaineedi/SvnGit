----- STEP 1 ----------
IF ((SELECT value FROM SystemConfigurationKeys WHERE [key] = 'CDM_TransferDocument')  < 1.0 ) or
Not exists(SELECT 1 FROM SystemConfigurationKeys WHERE [key] = 'CDM_TransferDocument')
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 1.0 or CDM_TransferDocument update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins


--Part2 Ends
-----End of Step 2 -------

------ STEP 3 -----------
------ END OF STEP 3 -----

------ STEP 4 ---------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomTPGoals')
BEGIN
/* 
 * TABLE: CustomTPGoals 
 */
 CREATE TABLE CustomTPGoals(
		TPGoalId								int identity(1,1)	 NOT NULL, 
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		DocumentVersionId						int					 NULL,
		GoalNumber								int					 NULL,
		GoalText								type_Comment2		 NULL,
		TargeDate								datetime			 NULL,
		Active									type_Active			 NULL,	
												CHECK (Active in ('Y','N')),
		ProgressTowardsGoal						char(1)				 NULL
												CHECK (ProgressTowardsGoal in ('A','M','S','N','D')),
		DeletionNotAllowed						type_YOrN			  NULL
												CHECK (DeletionNotAllowed in ('Y','N')),
		CONSTRAINT CustomTPGoals_PK PRIMARY KEY CLUSTERED (TPGoalId) 
 )
 
 IF OBJECT_ID('CustomTPGoals') IS NOT NULL
    PRINT '<<< CREATED TABLE  CustomTPGoals >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE  CustomTPGoals >>>', 16, 1)
/* 
 * TABLE:  CustomTPGoals 
 */   
   
ALTER TABLE CustomTPGoals ADD CONSTRAINT DocumentVersions_CustomTPGoals_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)

PRINT 'STEP 4(A) COMPLETED'
 END

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomTPServices')
BEGIN
/* 
 * TABLE: CustomTPServices 
 */
 CREATE TABLE CustomTPServices(
		TPServiceId								int identity(1,1)	 NOT NULL, 
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		TPGoalId								int					 NULL,
		AuthorizationCodeId						int					 NULL,
		ServiceNumber							decimal(10,2)		 NULL,
		Units									decimal(10,4)		 NULL,
		FrequencyType							type_GlobalCode		 NULL,
		[Status]								type_GlobalCode		 NULL,
		DeletionNotAllowed						type_YOrN			 NULL
												CHECK (DeletionNotAllowed in ('Y','N')),
		CONSTRAINT CustomTPServices_PK PRIMARY KEY CLUSTERED (TPServiceId) 
 )
 
 IF OBJECT_ID('CustomTPServices') IS NOT NULL
    PRINT '<<< CREATED TABLE  CustomTPServices >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE  CustomTPServices >>>', 16, 1)
/* 
 * TABLE:  CustomTPGoals 
 */   
 CREATE NONCLUSTERED INDEX [XIE1_CustomTPServices] ON [dbo].[CustomTPServices] 
(	
[TPGoalId] ASC	
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomTPServices') AND name='XIE1_CustomTPServices')
PRINT '<<< CREATED INDEX CustomTPServices.XIE1_CustomTPServices >>>'
ELSE
RAISERROR('<<< FAILED CREATING INDEX CustomTPServices. XIE1_CustomTPServices >>>', 16, 1)


ALTER TABLE CustomTPServices ADD CONSTRAINT CustomTPGoals_CustomTPServices_FK
    FOREIGN KEY (TPGoalId)
    REFERENCES CustomTPGoals(TPGoalId)
   
   
ALTER TABLE CustomTPServices ADD CONSTRAINT AuthorizationCodes_CustomTPServices_FK
    FOREIGN KEY (AuthorizationCodeId)
    REFERENCES AuthorizationCodes(AuthorizationCodeId)

PRINT 'STEP 4(B) COMPLETED'
 END

--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
IF ((SELECT cast(value as decimal(10,2)) FROM SystemConfigurationKeys WHERE [key] = 'CDM_TransferDocument')  = 1.0 )
BEGIN
	UPDATE SystemConfigurationKeys SET value ='1.1' WHERE [key] = 'CDM_TransferDocument'
		PRINT 'STEP 7 COMPLETED'
END
GO
