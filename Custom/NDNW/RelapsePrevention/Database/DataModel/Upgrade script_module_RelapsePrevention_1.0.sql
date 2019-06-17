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
IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentRelapsePreventionPlans')
BEGIN
/*  
 * TABLE: CustomDocumentRelapsePreventionPlans 
 */ 
CREATE TABLE CustomDocumentRelapsePreventionPlans(
		DocumentVersionId			int							NOT NULL,
		CreatedBy					type_CurrentUser			NOT NULL,
		CreatedDate					type_CurrentDatetime		NOT NULL,
		ModifiedBy					type_CurrentUser			NOT NULL,
		ModifiedDate				type_CurrentDatetime		NOT NULL,
		RecordDeleted				type_YOrN					NULL
									CHECK (RecordDeleted in ('Y','N')),
		DeletedBy					type_UserId					NULL,
		DeletedDate					datetime					NULL,
		PlanName					type_Comment2				NULL,	
		PlanPeriod					type_Comment2				NULL,	
		PlanStatus					type_GlobalCode				NULL,
		HighRiskSituations			type_GlobalCode				NULL,
		RecoveryActivities     		type_GlobalCode				NULL,
		PlanStartDate				datetime					NULL,
		PlanEndDate					datetime					NULL,
		NextReviewDate				datetime					NULL,
		ClientParticipated			type_YOrN				    NULL
									CHECK (ClientParticipated in ('Y','N'))	
		CONSTRAINT CustomDocumentRelapsePreventionPlans_PK PRIMARY KEY CLUSTERED (DocumentVersionId) 
 )
 
  IF OBJECT_ID('CustomDocumentRelapsePreventionPlans') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentRelapsePreventionPlans >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentRelapsePreventionPlans >>>', 16, 1)
/* 
 * TABLE: CustomDocumentRelapsePreventionPlans 
 */   
  
ALTER TABLE CustomDocumentRelapsePreventionPlans ADD CONSTRAINT DocumentVersions_CustomDocumentRelapsePreventionPlans_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)  
        
     PRINT 'STEP 4(A) COMPLETED'
 END
		
IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomRelapseLifeDomains')
BEGIN
/*  
 * TABLE: CustomRelapseLifeDomains 
 */ 
CREATE TABLE CustomRelapseLifeDomains(
		RelapseLifeDomainId			int identity(1,1)			NOT NULL,
		CreatedBy					type_CurrentUser			NOT NULL,
		CreatedDate					type_CurrentDatetime		NOT NULL,
		ModifiedBy					type_CurrentUser			NOT NULL,
		ModifiedDate				type_CurrentDatetime		NOT NULL,
		RecordDeleted				type_YOrN					NULL
									CHECK (RecordDeleted in ('Y','N')),
		DeletedBy					type_UserId					NULL,
		DeletedDate					datetime					NULL,
		DocumentVersionId			int							NULL,
		LifeDomainDetail			type_Comment2				NULL,
		LifeDomainDate				datetime					NULL,
		LifeDomain					type_GlobalCode				NULL,
		Resources					type_Comment2				NULL,
		Barriers					type_Comment2				NULL,
		LifeDomainNumber			int							NULL,
		CONSTRAINT CustomRelapseLifeDomains_PK PRIMARY KEY CLUSTERED (RelapseLifeDomainId) 
 )
 
  IF OBJECT_ID('CustomRelapseLifeDomains') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomRelapseLifeDomains >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomRelapseLifeDomains >>>', 16, 1)
/* 
 * TABLE: CustomRelapseLifeDomains 
 */   
  
ALTER TABLE CustomRelapseLifeDomains ADD CONSTRAINT DocumentVersions_CustomRelapseLifeDomains_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)  
        
     PRINT 'STEP 4(B) COMPLETED'
 END

		
IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomRelapseGoals')
BEGIN
/* 
 * TABLE: CustomRelapseGoals 
 */ 
CREATE TABLE CustomRelapseGoals(
		RelapseGoalId				int	identity(1,1)			NOT NULL,
		CreatedBy					type_CurrentUser			NOT NULL,
		CreatedDate					type_CurrentDatetime		NOT NULL,
		ModifiedBy					type_CurrentUser			NOT NULL,
		ModifiedDate				type_CurrentDatetime		NOT NULL,
		RecordDeleted				type_YOrN					NULL
									CHECK (RecordDeleted in ('Y','N')),
		DeletedBy					type_UserId					NULL,
		DeletedDate					datetime					NULL,	
		DocumentVersionId			int							NULL,
		RelapseLifeDomainId     	int							NULL,
		RelapseGoalStatus       	type_GlobalCode				NULL,
		ProjectedDate				datetime					NULL,
		MyGoal						type_Comment2				NULL,
		AchievedThisGoal      		type_Comment2				NULL,
		GoalNumber					varchar(50)					NULL,	
		CONSTRAINT CustomRelapseGoals_PK PRIMARY KEY CLUSTERED (RelapseGoalId) 
 )
 
  IF OBJECT_ID('CustomRelapseGoals') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomRelapseGoals >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomRelapseGoals >>>', 16, 1)
/* 
 * TABLE: CustomRelapseGoals 
 */   
  
ALTER TABLE CustomRelapseGoals ADD CONSTRAINT DocumentVersions_CustomRelapseGoals_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)  
    
ALTER TABLE CustomRelapseGoals ADD CONSTRAINT CustomRelapseLifeDomains_CustomRelapseGoals_FK
    FOREIGN KEY (RelapseLifeDomainId)
    REFERENCES CustomRelapseLifeDomains(RelapseLifeDomainId)  
        
     PRINT 'STEP 4(C) COMPLETED'
 END

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomRelapseObjectives')
BEGIN
/*  
 * TABLE: CustomRelapseObjectives 
 */ 

CREATE TABLE CustomRelapseObjectives(
		RelapseObjectiveId			int	identity(1,1)			NOT NULL,
		CreatedBy					type_CurrentUser			NOT NULL,
		CreatedDate					type_CurrentDatetime		NOT NULL,
		ModifiedBy					type_CurrentUser			NOT NULL,
		ModifiedDate				type_CurrentDatetime		NOT NULL,
		RecordDeleted				type_YOrN					NULL
									CHECK (RecordDeleted in ('Y','N')),
		DeletedBy					type_UserId					NULL,
		DeletedDate					datetime					NULL,	
		DocumentVersionId			int							NULL,
		RelapseGoalId         		int							NULL,
		RelapseObjectives       	type_Comment2				NULL,	
		ObjectivesCreateDate		datetime					NULL,
		ObjectiveStatus         	type_GlobalCode				NULL,
		IWillAchieve				type_Comment2				NULL,
		ExpectedAchieveDate			datetime					NULL,
		ResolutionDate				datetime					NULL,
		ObjectivesNumber			varchar(50)					NULL,
		CONSTRAINT CustomRelapseObjectives_PK PRIMARY KEY CLUSTERED (RelapseObjectiveId) 
 )
 
  IF OBJECT_ID('CustomRelapseObjectives') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomRelapseObjectives >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomRelapseObjectives >>>', 16, 1)
/* 
 * TABLE: CustomRelapseObjectives 
 */   
  
ALTER TABLE CustomRelapseObjectives ADD CONSTRAINT DocumentVersions_CustomRelapseObjectives_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)  
    
ALTER TABLE CustomRelapseGoals ADD CONSTRAINT CustomRelapseGoals_CustomRelapseGoals_FK
    FOREIGN KEY (RelapseGoalId)
    REFERENCES CustomRelapseGoals(RelapseGoalId)  
        
        
     PRINT 'STEP 4(D) COMPLETED'
 END

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomRelapseActionSteps')
BEGIN
/* 
 * TABLE: CustomRelapseActionSteps 
 */ 
CREATE TABLE CustomRelapseActionSteps(
		RelapseActionStepId			int	identity(1,1)			NOT NULL,
		CreatedBy					type_CurrentUser			NOT NULL,
		CreatedDate					type_CurrentDatetime		NOT NULL,
		ModifiedBy					type_CurrentUser			NOT NULL,
		ModifiedDate				type_CurrentDatetime		NOT NULL,
		RecordDeleted				type_YOrN					NULL
									CHECK (RecordDeleted in ('Y','N')),
		DeletedBy					type_UserId					NULL,
		DeletedDate					datetime					NULL,	
		DocumentVersionId			int							NULL,
		RelapseObjectiveId     		int							NULL,
		RelapseActionSteps      	type_Comment2				NULL,
		CreateDate					datetime					NULL,
		ActionStepStatus        	type_GlobalCode				NULL,
		ToAchieveMyGoal				type_Comment2				NULL,
		ActionStepNumber			varchar(50)					NULL,
		CONSTRAINT CustomRelapseActionSteps_PK PRIMARY KEY CLUSTERED (RelapseActionStepId) 
 )
 
  IF OBJECT_ID('CustomRelapseActionSteps') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomRelapseActionSteps >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomRelapseActionSteps >>>', 16, 1)
/* 
 * TABLE: CustomRelapseActionSteps 
 */   
  
ALTER TABLE CustomRelapseActionSteps ADD CONSTRAINT DocumentVersions_CustomRelapseActionSteps_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)  
    
ALTER TABLE CustomRelapseActionSteps ADD CONSTRAINT CustomRelapseObjectives_CustomRelapseActionSteps_FK
    FOREIGN KEY (RelapseObjectiveId)
    REFERENCES CustomRelapseObjectives(RelapseObjectiveId)  
        
     PRINT 'STEP 4(E) COMPLETED'
 END
	

---------------------------------------------------------------
--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF NOT EXISTS (	SELECT [key] FROM SystemConfigurationKeys	WHERE [key] = 'CDM_RelapsePrevention')
BEGIN
	INSERT INTO SystemConfigurationKeys (
		CreatedBy
		,CreateDate
		,ModifiedBy
		,ModifiedDate
		,[key]
		,Value
		)
	VALUES (
		'SHSDBA'
		,GETDATE()
		,'SHSDBA'
		,GETDATE()
		,'CDM_RelapsePrevention'
		,'1.0'
		)
	PRINT 'STEP 7 COMPLETED'
END
GO