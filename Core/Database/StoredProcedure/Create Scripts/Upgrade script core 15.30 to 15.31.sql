----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.30)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.30 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END

------ STEP 2 ----------
--Part1 Begin


--Part1 Ends

--Part2 Begins

--Part2 Ends	

-----End of Step 2 -------

 ------ STEP 3 ------------
 -----END Of STEP 3--------------------

------ STEP 4 ------------

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='StaffTimeSheetGenerals')
BEGIN
/*  
 * TABLE: StaffTimeSheetGenerals 
 */
 CREATE TABLE StaffTimeSheetGenerals( 
		StaffTimeSheetGeneralId					int identity(1,1)    NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		StaffId									int					 NULL,
		EmploymentType							char(1)				 NULL
												CHECK (EmploymentType in ('E','N')),
		BeginningBalancePersonalLeaveDate		datetime			 NULL,
		PersonalLeave							decimal(18,2)		 NULL,
		BeginningBalanceLongTermSickDate		datetime			 NULL,
		LongTermSick							decimal(18,2)		 NULL,
		CONSTRAINT StaffTimeSheetGenerals_PK PRIMARY KEY CLUSTERED (StaffTimeSheetGeneralId)
)
  IF OBJECT_ID('StaffTimeSheetGenerals') IS NOT NULL
    PRINT '<<< CREATED TABLE StaffTimeSheetGenerals >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE StaffTimeSheetGenerals >>>', 16, 1)
/*  
 * TABLE: StaffTimeSheetGenerals 
 */   
 
  
 ALTER TABLE StaffTimeSheetGenerals ADD CONSTRAINT Staff_StaffTimeSheetGenerals_FK
    FOREIGN KEY (StaffId)
    REFERENCES Staff(StaffId)
    
    IF EXISTS (SELECT *	FROM::fn_listextendedproperty('StaffTimeSheetGenerals_Description', 'schema', 'dbo', 'table', 'StaffTimeSheetGenerals', 'column', 'EmploymentType'))
BEGIN
	EXEC sys.sp_dropextendedproperty 'StaffTimeSheetGenerals_Description'
		,'schema'
		,'dbo'
		,'table'
		,'StaffTimeSheetGenerals'
		,'column'
		,'EmploymentType'
END

EXEC sys.sp_addextendedproperty 'StaffTimeSheetGenerals_Description'
	,'If EmploymentType cloumn data is  E  then  Exempt, If EmploymentType cloumn data is  N then  Non-Exempt'
	,'schema'
	,'dbo'
	,'table'
	,'StaffTimeSheetGenerals'
	,'column'
	,'EmploymentType'

     PRINT 'STEP 4(A) COMPLETED'
 END
 
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='StaffTimeSheetAccrualHistory')
BEGIN
/*  
 * TABLE: StaffTimeSheetAccrualHistory 
 */
 CREATE TABLE StaffTimeSheetAccrualHistory( 
		StaffTimeSheetAccrualHistoryId			int identity(1,1)    NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		StaffId									int					 NULL,
		EffectiveDate							datetime             NULL,
		EndDate									datetime             NULL,
		FullTimeEquivalentPercentage			decimal(18,2)		 NULL,
		ExpectedHours							decimal(18,2)		 NULL,
		AccrualRate								decimal(18,2)		 NULL,		
		AccrualType								type_GlobalCode		 NULL,
		AccrualRatePer							type_GlobalCode		 NULL,
		Comments								type_Comment2		 NULL,
		CONSTRAINT StaffTimeSheetAccrualHistory_PK PRIMARY KEY CLUSTERED (StaffTimeSheetAccrualHistoryId)
)
  IF OBJECT_ID('StaffTimeSheetAccrualHistory') IS NOT NULL
    PRINT '<<< CREATED TABLE StaffTimeSheetAccrualHistory >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE StaffTimeSheetAccrualHistory >>>', 16, 1)
/*  
 * TABLE: StaffTimeSheetAccrualHistory 
 */   
 
 ALTER TABLE StaffTimeSheetAccrualHistory ADD CONSTRAINT Staff_StaffTimeSheetAccrualHistory_FK
    FOREIGN KEY (StaffId)
    REFERENCES Staff(StaffId)
    
  PRINT 'STEP 4(B) COMPLETED'
 END
 
 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='StaffTimeSheetPersonalLeaveCashedOut')
BEGIN
/*  
 * TABLE: StaffTimeSheetPersonalLeaveCashedOut 
 */
 CREATE TABLE StaffTimeSheetPersonalLeaveCashedOut( 
		StaffTimeSheetPersonalLeaveCashedOutId	int identity(1,1)    NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		StaffId									int					 NULL,
		BeginningBalanceDate					datetime             NULL,
		BeginningBalance						decimal(18,2)        NULL,
		AmountCashedOut							decimal(18,2)		 NULL,
		ReminingBalance							decimal(18,2)		 NULL,		
		CONSTRAINT StaffTimeSheetPersonalLeaveCashedOut_PK PRIMARY KEY CLUSTERED (StaffTimeSheetPersonalLeaveCashedOutId)
)
  IF OBJECT_ID('StaffTimeSheetPersonalLeaveCashedOut') IS NOT NULL
    PRINT '<<< CREATED TABLE StaffTimeSheetPersonalLeaveCashedOut >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE StaffTimeSheetPersonalLeaveCashedOut >>>', 16, 1)
/*  
 * TABLE: StaffTimeSheetPersonalLeaveCashedOut 
 */   
 
 ALTER TABLE StaffTimeSheetPersonalLeaveCashedOut ADD CONSTRAINT Staff_StaffTimeSheetPersonalLeaveCashedOut_FK
    FOREIGN KEY (StaffId)
    REFERENCES Staff(StaffId)
    
  PRINT 'STEP 4(C) COMPLETED'
 END
 
 
 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='StaffTimeSheetAdjustments')
BEGIN
/*  
 * TABLE: StaffTimeSheetAdjustments 
 */
 CREATE TABLE StaffTimeSheetAdjustments( 
		StaffTimeSheetAdjustmentId				int identity(1,1)    NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		StaffId									int					 NULL,
		AdjustmentDate							datetime             NULL,
		AdjustmentType							type_GlobalCode 	 NULL,
		BeginningBalance						decimal(18,2)		 NULL,
		IncreaseOrDecrease						type_GlobalCode		 NULL,
		NumberOfHours  							decimal(18,2)		 NULL,
		ReminingBalance							decimal(18,2)		 NULL,		
		Comments								type_Comment2		 NULL,
		CONSTRAINT StaffTimeSheetAdjustments_PK PRIMARY KEY CLUSTERED (StaffTimeSheetAdjustmentId)
)
  IF OBJECT_ID('StaffTimeSheetAdjustments') IS NOT NULL
    PRINT '<<< CREATED TABLE StaffTimeSheetAdjustments >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE StaffTimeSheetAdjustments >>>', 16, 1)
/*  
 * TABLE: StaffTimeSheetAdjustments 
 */   
 
 ALTER TABLE StaffTimeSheetAdjustments ADD CONSTRAINT Staff_StaffTimeSheetAdjustments_FK
    FOREIGN KEY (StaffId)
    REFERENCES Staff(StaffId)
    
  PRINT 'STEP 4(D) COMPLETED'
 END
 
 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='StaffTimeSheetEntries')
BEGIN
/*  
 * TABLE: StaffTimeSheetEntries 
 */
 CREATE TABLE StaffTimeSheetEntries( 
		StaffTimeSheetEntryId					int identity(1,1)    NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		StaffId									int					 NULL,
		TimeSheetDay							datetime			 NULL,
		StartTime								datetime			 NULL,
		StopTime								datetime			 NULL,	
		TimeAway							    decimal(18,2)		 NULL,
		TotalHours								decimal(18,2)		 NULL,
		DaysNotWorked							type_GlobalCode		 NULL,
		BillableSecondaryLeaveHours 			decimal(18,2)		 NULL,
		ClinicalSupportHours					decimal(18,2)		 NULL,	
		ServiceHours							decimal(18,2)		 NULL,			
		CONSTRAINT StaffTimeSheetEntries_PK PRIMARY KEY CLUSTERED (StaffTimeSheetEntryId)
)
  IF OBJECT_ID('StaffTimeSheetEntries') IS NOT NULL
    PRINT '<<< CREATED TABLE StaffTimeSheetEntries >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE StaffTimeSheetEntries >>>', 16, 1)
    
  
/*  
 * TABLE: StaffTimeSheetEntries 
 */   
 
  
 ALTER TABLE StaffTimeSheetEntries ADD CONSTRAINT Staff_StaffTimeSheetEntries_FK
    FOREIGN KEY (StaffId)
    REFERENCES Staff(StaffId)        
 
  PRINT 'STEP 4(E) COMPLETED'
 END
 
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='StaffTimeSheetTimeAway')
BEGIN
/*  
 * TABLE: StaffTimeSheetTimeAway 
 */
 CREATE TABLE StaffTimeSheetTimeAway( 
		StaffTimeSheetTimeAwayId				int identity(1,1)    NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		StaffTimeSheetEntryId					int					 NULL,		
		StartTime								datetime			 NULL,
		EndTime									datetime			 NULL,	
		Duration							    decimal(18,2)		 NULL,
		Comment									type_Comment2		 NULL,			
		CONSTRAINT StaffTimeSheetTimeAway_PK PRIMARY KEY CLUSTERED (StaffTimeSheetTimeAwayId)
)
  IF OBJECT_ID('StaffTimeSheetTimeAway') IS NOT NULL
    PRINT '<<< CREATED TABLE StaffTimeSheetTimeAway >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE StaffTimeSheetTimeAway >>>', 16, 1)
    
  
/*  
 * TABLE: StaffTimeSheetTimeAway 
 */   
 
  
 ALTER TABLE StaffTimeSheetTimeAway ADD CONSTRAINT StaffTimeSheetEntries_StaffTimeSheetTimeAway_FK
    FOREIGN KEY (StaffTimeSheetEntryId)
    REFERENCES StaffTimeSheetEntries(StaffTimeSheetEntryId)        
 
  PRINT 'STEP 4(F) COMPLETED'
 END
 
 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='StaffTimeSheetSecondaryActivities')
BEGIN
/*  
 * TABLE: StaffTimeSheetSecondaryActivities 
 */
 CREATE TABLE StaffTimeSheetSecondaryActivities( 
		StaffTimeSheetSecondaryActivityId		int identity(1,1)    NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		StaffTimeSheetEntryId					int					 NULL,
		SecondaryActivity						type_GlobalCode		 NULL,
		StartTime								datetime			 NULL,
		EndTime									datetime			 NULL,	
		Duration							    decimal(18,2)		 NULL,
		Comment									type_Comment2		 NULL,			
		CONSTRAINT StaffTimeSheetSecondaryActivities_PK PRIMARY KEY CLUSTERED (StaffTimeSheetSecondaryActivityId)
)
  IF OBJECT_ID('StaffTimeSheetSecondaryActivities') IS NOT NULL
    PRINT '<<< CREATED TABLE StaffTimeSheetSecondaryActivities >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE StaffTimeSheetSecondaryActivities >>>', 16, 1)
    
  
/*  
 * TABLE: StaffTimeSheetSecondaryActivities 
 */   
 
  
 ALTER TABLE StaffTimeSheetSecondaryActivities ADD CONSTRAINT StaffTimeSheetEntries_StaffTimeSheetSecondaryActivities_FK
    FOREIGN KEY (StaffTimeSheetEntryId)
    REFERENCES StaffTimeSheetEntries(StaffTimeSheetEntryId)        
 
  PRINT 'STEP 4(G) COMPLETED'
 END
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='StaffTimeSheetTimeOff')
BEGIN
/* 
 * TABLE: StaffTimeSheetTimeOff 
 */
 CREATE TABLE StaffTimeSheetTimeOff( 
		StaffTimeSheetTimeOffId					int identity(1,1)    NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		StaffTimeSheetEntryId					int					 NULL,
		LeaveType								type_GlobalCode		 NULL,	
		Paid									type_YOrN			 NULL
												CHECK (Paid in ('Y','N')),								
		StartTime								datetime			 NULL,
		EndTime									datetime			 NULL,	
		Duration							    decimal(18,2)		 NULL,
		Comment									type_Comment2		 NULL,			
		CONSTRAINT StaffTimeSheetTimeOff_PK PRIMARY KEY CLUSTERED (StaffTimeSheetTimeOffId)
)
  IF OBJECT_ID('StaffTimeSheetTimeOff') IS NOT NULL
    PRINT '<<< CREATED TABLE StaffTimeSheetTimeOff >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE StaffTimeSheetTimeOff >>>', 16, 1)
    
  
/*  
 * TABLE: StaffTimeSheetTimeOff 
 */   
 
  
 ALTER TABLE StaffTimeSheetTimeOff ADD CONSTRAINT StaffTimeSheetEntries_StaffTimeSheetTimeOff_FK
    FOREIGN KEY (StaffTimeSheetEntryId)
    REFERENCES StaffTimeSheetEntries(StaffTimeSheetEntryId)        
 
  PRINT 'STEP 4(H) COMPLETED'
 END 
 
 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='StaffTimeSheetOverrideHistory')
BEGIN
/*  
 * TABLE: StaffTimeSheetOverrideHistory 
 */
 CREATE TABLE StaffTimeSheetOverrideHistory( 
		StaffTimeSheetOverrideHistoryId			int identity(1,1)    NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		StaffTimeSheetEntryId					int					 NULL,
		OverrideDateTime						datetime			 NULL,		
		TypeOfOverride							varchar(250)		 NULL,
		OverrideReason							type_Comment2		 NULL,					
		CONSTRAINT StaffTimeSheetOverrideHistory_PK PRIMARY KEY CLUSTERED (StaffTimeSheetOverrideHistoryId)
)
  IF OBJECT_ID('StaffTimeSheetOverrideHistory') IS NOT NULL
    PRINT '<<< CREATED TABLE StaffTimeSheetOverrideHistory >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE StaffTimeSheetOverrideHistory >>>', 16, 1)
    
  
/*  
 * TABLE: StaffTimeSheetOverrideHistory 
 */   
 
  
 ALTER TABLE StaffTimeSheetOverrideHistory ADD CONSTRAINT StaffTimeSheetEntries_StaffTimeSheetOverrideHistory_FK
    FOREIGN KEY (StaffTimeSheetEntryId)
    REFERENCES StaffTimeSheetEntries(StaffTimeSheetEntryId)        
 
  PRINT 'STEP 4(I) COMPLETED'
 END   
   
----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.30)
BEGIN
Update SystemConfigurations set DataModelVersion=15.31
PRINT 'STEP 7 COMPLETED'
END
Go