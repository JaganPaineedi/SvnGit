----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.16)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.16 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of Step 2 -------
------ STEP 3 ------------

-----End of Step 3 -------

-------------------add new column(s)  in FinancialAssignments table ---------------

IF OBJECT_ID('FinancialAssignments') IS NOT NULL
BEGIN

	IF COL_LENGTH('FinancialAssignments','ListPageFilter') IS  NULL
	BEGIN
		ALTER TABLE FinancialAssignments   ADD   ListPageFilter  type_YOrN    NULL
                                           CHECK (ListPageFilter in ('Y','N'))
	END
	
	IF COL_LENGTH('FinancialAssignments','RevenueWorkQueueManagement')IS   NULL
	BEGIN
		ALTER TABLE FinancialAssignments   ADD   RevenueWorkQueueManagement  type_YOrN    NULL
                                           CHECK (RevenueWorkQueueManagement in ('Y','N'))
	END
	
	IF COL_LENGTH('FinancialAssignments','RWQMAssignedId')IS   NULL
	BEGIN
		ALTER TABLE FinancialAssignments   ADD   RWQMAssignedId  int    NULL
	END
	
	IF COL_LENGTH('FinancialAssignments','RWQMAssignedBackupId')IS   NULL
	BEGIN
		ALTER TABLE FinancialAssignments   ADD   RWQMAssignedBackupId  int    NULL
	END
	
	IF COL_LENGTH('FinancialAssignments','ChargeAdjustmentCodes')IS   NULL
	BEGIN
		ALTER TABLE FinancialAssignments   ADD   ChargeAdjustmentCodes  varchar(250)    NULL
	END
	
	IF COL_LENGTH('FinancialAssignments','AllChargeAdjustmentCodes')IS   NULL
	BEGIN
		ALTER TABLE FinancialAssignments   ADD   AllChargeAdjustmentCodes  type_YOrN    NULL
                                           CHECK (AllChargeAdjustmentCodes in ('Y','N'))
	END
	
	IF COL_LENGTH('FinancialAssignments','ServiceClinicians')IS   NULL
	BEGIN
		ALTER TABLE FinancialAssignments   ADD   ServiceClinicians varchar(250)    NULL                                     
	END
	
	IF COL_LENGTH('FinancialAssignments','AllServiceClinicians')IS   NULL
	BEGIN
		ALTER TABLE FinancialAssignments   ADD   AllServiceClinicians  type_YOrN    NULL
                                           CHECK (AllServiceClinicians in ('Y','N'))
	END
	
	
	IF COL_LENGTH('FinancialAssignments','ExcludePayerCharges')IS   NULL
	BEGIN
		ALTER TABLE FinancialAssignments   ADD   ExcludePayerCharges  type_YOrN    NULL
                                           CHECK (ExcludePayerCharges in ('Y','N'))
	END
	
	IF COL_LENGTH('FinancialAssignments','ClientFinancialResponsible')IS   NULL
	BEGIN
		ALTER TABLE FinancialAssignments   ADD   ClientFinancialResponsible  char(1)    NULL
                                           CHECK (ClientFinancialResponsible in ('C','F'))
         EXEC sys.sp_addextendedproperty 'FinancialAssignments_Description'
		,'ClientFinancialResponsible Column Stores C or F . C-Client ,F-Financial Responsible '
		,'schema'
		,'dbo'
		,'table'
		,'FinancialAssignments'
		,'column'
		,'ClientFinancialResponsible'
		
	END
	
	
	IF COL_LENGTH('FinancialAssignments','RWQMAssignedId')IS NOT NULL
	 BEGIN
			IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Staff_FinancialAssignments_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[FinancialAssignments]'))
			BEGIN
				ALTER TABLE FinancialAssignments ADD CONSTRAINT Staff_FinancialAssignments_FK
				FOREIGN KEY (RWQMAssignedId)
				REFERENCES Staff(StaffId) 
			END
	  END
	  
	  IF COL_LENGTH('FinancialAssignments','RWQMAssignedBackupId')IS NOT NULL
	 BEGIN
			IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Staff_FinancialAssignments_FK2]') AND parent_object_id = OBJECT_ID(N'[dbo].[FinancialAssignments]'))
			BEGIN
				ALTER TABLE FinancialAssignments ADD CONSTRAINT Staff_FinancialAssignments_FK2
				FOREIGN KEY (RWQMAssignedBackupId)
				REFERENCES Staff(StaffId) 
			END
	  END
	  
	  IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('FinancialAssignments') AND name='XIE1_FinancialAssignments')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_FinancialAssignments] ON [dbo].[FinancialAssignments] 
		(
		RWQMAssignedId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('FinancialAssignments') AND name='XIE1_FinancialAssignments')
		PRINT '<<< CREATED INDEX FinancialAssignments.XIE1_FinancialAssignments >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX FinancialAssignments.XIE1_FinancialAssignments >>>', 16, 1)		
		END	 
		
	 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('FinancialAssignments') AND name='XIE2_FinancialAssignments')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_FinancialAssignments] ON [dbo].[FinancialAssignments] 
		(
		RWQMAssignedBackupId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('FinancialAssignments') AND name='XIE2_FinancialAssignments')
		PRINT '<<< CREATED INDEX FinancialAssignments.XIE2_FinancialAssignments >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX FinancialAssignments.XIE2_FinancialAssignments >>>', 16, 1)		
		END	 
	
	PRINT 'STEP 3 COMPLETED'	
END



-------------------add new column(s)  in Charges table ---------------
IF OBJECT_ID('Charges') IS NOT NULL
BEGIN

	IF COL_LENGTH('Charges','ChargeStatus')IS   NULL
	BEGIN
		ALTER TABLE Charges   ADD   ChargeStatus  type_GlobalCode    NULL
	END
	
	IF COL_LENGTH('Charges','StatusDate')IS   NULL
	BEGIN
		ALTER TABLE Charges   ADD   StatusDate  Datetime    NULL
	END
	
	IF COL_LENGTH('Charges','ExcludeChargeFromQueue')IS   NULL
	BEGIN
		ALTER TABLE Charges   ADD   ExcludeChargeFromQueue  type_YOrN    NULL
							  CHECK(ExcludeChargeFromQueue in ('Y','N'))
	END
	
	IF COL_LENGTH('Charges','DoNotCountTowardProductivity')IS   NULL
	BEGIN
		ALTER TABLE Charges   ADD   DoNotCountTowardProductivity  type_YOrN    NULL
							  CHECK(DoNotCountTowardProductivity in ('Y','N'))
	END
	
	IF COL_LENGTH('Charges','StatusComments')IS   NULL
	BEGIN
		ALTER TABLE Charges   ADD   StatusComments  type_Comment2    NULL
	END

END
------ STEP 4 ---------------

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='ChargeStatusHistory')
BEGIN
/*  
 * TABLE: ChargeStatusHistory 
 */
CREATE TABLE ChargeStatusHistory(
    ChargeStatusHistoryId					int identity(1,1)       NOT NULL,
    CreatedBy								type_CurrentUser        NOT NULL,
    CreatedDate								type_CurrentDatetime    NOT NULL,
    ModifiedBy								type_CurrentUser        NOT NULL,
    ModifiedDate							type_CurrentDatetime    NOT NULL,
    RecordDeleted							type_YOrN               NULL
											CHECK (RecordDeleted in ('Y','N')),
    DeletedBy								type_UserId             NULL,
    DeletedDate								datetime                NULL,
	ChargeId								int						NULL,						
	StatusDate								datetime                NULL, 
	ChargeStatus							type_GlobalCode         NULL,
   CONSTRAINT ChargeStatusHistory_PK PRIMARY KEY CLUSTERED (ChargeStatusHistoryId)                                     
)
IF OBJECT_ID('ChargeStatusHistory') IS NOT NULL
    PRINT '<<< CREATED TABLE ChargeStatusHistory >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE ChargeStatusHistory >>>', 16, 1)   

/* 
 * TABLE: ChargeStatusHistory 
 */
 
 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ChargeStatusHistory') AND name='XIE1_ChargeStatusHistory')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_ChargeStatusHistory] ON [dbo].[ChargeStatusHistory] 
		(
		ChargeId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ChargeStatusHistory') AND name='XIE1_ChargeStatusHistory')
		PRINT '<<< CREATED INDEX ChargeStatusHistory.XIE1_ChargeStatusHistory >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ChargeStatusHistory.XIE1_ChargeStatusHistory >>>', 16, 1)		
		END	 
    

/* 
 * TABLE: ChargeStatusHistory 
 */
ALTER TABLE ChargeStatusHistory ADD CONSTRAINT Charges_ChargeStatusHistory_FK 
    FOREIGN KEY (ChargeId)
    REFERENCES Charges(ChargeId)
    
 PRINT 'STEP 4(A) COMPLETED'
END




IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='FinancialAssignmentAdjustmentCodes')
BEGIN
/* 
 * TABLE: FinancialAssignmentAdjustmentCodes 
 */
CREATE TABLE FinancialAssignmentAdjustmentCodes(
    FinancialAssignmentAdjustmentCodeId     int identity(1,1)       NOT NULL,
    CreatedBy								type_CurrentUser        NOT NULL,
    CreatedDate								type_CurrentDatetime    NOT NULL,
    ModifiedBy								type_CurrentUser        NOT NULL,
    ModifiedDate							type_CurrentDatetime    NOT NULL,
    RecordDeleted							type_YOrN               NULL
											CHECK (RecordDeleted in ('Y','N')),
    DeletedBy								type_UserId             NULL,
    DeletedDate								datetime                NULL,
    FinancialAssignmentId					int						NULL,
	AdjustmentCodes							type_GlobalCode			NULL,
	AssignmentType							type_GlobalCode			NULL,
   CONSTRAINT FinancialAssignmentAdjustmentCodes_PK PRIMARY KEY CLUSTERED (FinancialAssignmentAdjustmentCodeId)                                     
)
IF OBJECT_ID('FinancialAssignmentAdjustmentCodes') IS NOT NULL
    PRINT '<<< CREATED TABLE FinancialAssignmentAdjustmentCodes >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE FinancialAssignmentAdjustmentCodes >>>', 16, 1)

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('FinancialAssignmentAdjustmentCodes') AND name='XIE1_FinancialAssignmentAdjustmentCodes')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_FinancialAssignmentAdjustmentCodes] ON [dbo].[FinancialAssignmentAdjustmentCodes] 
		(
		FinancialAssignmentId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('FinancialAssignmentAdjustmentCodes') AND name='XIE1_FinancialAssignmentAdjustmentCodes')
		PRINT '<<< CREATED INDEX FinancialAssignmentAdjustmentCodes.XIE1_FinancialAssignmentAdjustmentCodes >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX FinancialAssignmentAdjustmentCodes.XIE1_FinancialAssignmentAdjustmentCodes >>>', 16, 1)		
		END	   

/* 
 * TABLE: FinancialAssignmentAdjustmentCodes 
 */
ALTER TABLE FinancialAssignmentAdjustmentCodes ADD CONSTRAINT FinancialAssignments_FinancialAssignmentAdjustmentCodes_FK 
    FOREIGN KEY (FinancialAssignmentId)
    REFERENCES FinancialAssignments(FinancialAssignmentId)
    

 PRINT 'STEP 4(B) COMPLETED'
END

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='FinancialAssignmentClinicians')
BEGIN
/*  
 * TABLE: FinancialAssignmentClinicians 
 */
CREATE TABLE FinancialAssignmentClinicians(
    FinancialAssignmentClinicianId			int identity(1,1)       NOT NULL,
    CreatedBy								type_CurrentUser        NOT NULL,
    CreatedDate								type_CurrentDatetime    NOT NULL,
    ModifiedBy								type_CurrentUser        NOT NULL,
    ModifiedDate							type_CurrentDatetime    NOT NULL,
    RecordDeleted							type_YOrN               NULL
											CHECK (RecordDeleted in ('Y','N')),
    DeletedBy								type_UserId             NULL,
    DeletedDate								datetime                NULL,
    FinancialAssignmentId					int						NULL,
	ClinicianId								int						NULL,
	AssignmentType							type_GlobalCode			NULL,
   CONSTRAINT FinancialAssignmentClinicians_PK PRIMARY KEY CLUSTERED (FinancialAssignmentClinicianId)                                     
)
IF OBJECT_ID('FinancialAssignmentClinicians') IS NOT NULL
    PRINT '<<< CREATED TABLE FinancialAssignmentClinicians >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE FinancialAssignmentClinicians >>>', 16, 1)

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('FinancialAssignmentClinicians') AND name='XIE1_FinancialAssignmentClinicians')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_FinancialAssignmentClinicians] ON [dbo].[FinancialAssignmentClinicians] 
		(
		FinancialAssignmentId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('FinancialAssignmentClinicians') AND name='XIE1_FinancialAssignmentClinicians')
		PRINT '<<< CREATED INDEX FinancialAssignmentClinicians.XIE1_FinancialAssignmentClinicians >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX FinancialAssignmentClinicians.XIE1_FinancialAssignmentClinicians >>>', 16, 1)		
		END	 
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('FinancialAssignmentClinicians') AND name='XIE2_FinancialAssignmentClinicians')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_FinancialAssignmentClinicians] ON [dbo].[FinancialAssignmentClinicians] 
		(
		ClinicianId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('FinancialAssignmentClinicians') AND name='XIE2_FinancialAssignmentClinicians')
		PRINT '<<< CREATED INDEX FinancialAssignmentClinicians.XIE2_FinancialAssignmentClinicians >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX FinancialAssignmentClinicians.XIE2_FinancialAssignmentClinicians >>>', 16, 1)		
		END	 
	
    

/* 
 * TABLE: FinancialAssignmentClinicians 
 */
ALTER TABLE FinancialAssignmentClinicians ADD CONSTRAINT FinancialAssignments_FinancialAssignmentClinicians_FK 
    FOREIGN KEY (FinancialAssignmentId)
    REFERENCES FinancialAssignments(FinancialAssignmentId)
    
 ALTER TABLE FinancialAssignmentClinicians ADD CONSTRAINT Staff_FinancialAssignmentClinicians_FK 
    FOREIGN KEY (ClinicianId)
    REFERENCES Staff(StaffId)

 PRINT 'STEP 4(C) COMPLETED'
END


IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='RWQMActions')
BEGIN
/*  
 * TABLE:  RWQMActions 
 */
CREATE TABLE RWQMActions(
    RWQMActionId							int identity(1,1)       NOT NULL,
    CreatedBy								type_CurrentUser        NOT NULL,
    CreatedDate								type_CurrentDatetime    NOT NULL,
    ModifiedBy								type_CurrentUser        NOT NULL,
    ModifiedDate							type_CurrentDatetime    NOT NULL,
    RecordDeleted							type_YOrN               NULL
											CHECK (RecordDeleted in ('Y','N')),
    DeletedBy								type_UserId             NULL,
    DeletedDate								datetime                NULL,
	ActionName								varchar(250)			NULL,
	Active									type_YOrN               NULL
											CHECK (Active in ('Y','N')),
	AllowedChargeStatus						varchar(max)			NULL,
	AllAllowedChargeStatus					type_YOrN               NULL
											CHECK (AllAllowedChargeStatus in ('Y','N')),
	AllowedPreviousAction					varchar(max)			NULL,
	AllAllowedPreviousAction				type_YOrN               NULL
											CHECK (AllAllowedPreviousAction in ('Y','N')),
	Comments								type_Comment2			NULL,
   CONSTRAINT RWQMActions_PK PRIMARY KEY CLUSTERED (RWQMActionId)                                     
)
IF OBJECT_ID('RWQMActions') IS NOT NULL
    PRINT '<<< CREATED TABLE RWQMActions >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE RWQMActions >>>', 16, 1)   

/* 
 * TABLE: RWQMActions 
 */


 PRINT 'STEP 4(D) COMPLETED'
END

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='RWQMActionChargeStatuses')
BEGIN
/*  
 * TABLE: RWQMActionChargeStatuses 
 */
CREATE TABLE RWQMActionChargeStatuses(
    RWQMActionChargeStatusId				int identity(1,1)       NOT NULL,
    CreatedBy								type_CurrentUser        NOT NULL,
    CreatedDate								type_CurrentDatetime    NOT NULL,
    ModifiedBy								type_CurrentUser        NOT NULL,
    ModifiedDate							type_CurrentDatetime    NOT NULL,
    RecordDeleted							type_YOrN               NULL
											CHECK (RecordDeleted in ('Y','N')),
    DeletedBy								type_UserId             NULL,
    DeletedDate								datetime                NULL,
	RWQMActionId							int						NULL,
	ChargeStatus							type_GlobalCode			NULL,
   CONSTRAINT RWQMActionChargeStatuses_PK PRIMARY KEY CLUSTERED (RWQMActionChargeStatusId)                                     
)
IF OBJECT_ID('RWQMActionChargeStatuses') IS NOT NULL
    PRINT '<<< CREATED TABLE RWQMActionChargeStatuses >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE RWQMActionChargeStatuses >>>', 16, 1)   

/* 
 * TABLE: RWQMActionChargeStatuses 
 */
 
 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMActionChargeStatuses') AND name='XIE1_RWQMActionChargeStatuses')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_RWQMActionChargeStatuses] ON [dbo].[RWQMActionChargeStatuses] 
		(
		RWQMActionId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMActionChargeStatuses') AND name='XIE1_RWQMActionChargeStatuses')
		PRINT '<<< CREATED INDEX RWQMActionChargeStatuses.XIE1_RWQMActionChargeStatuses >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX RWQMActionChargeStatuses.XIE1_RWQMActionChargeStatuses >>>', 16, 1)		
		END	 
    

/* 
 * TABLE: RWQMActionChargeStatuses 
 */
ALTER TABLE RWQMActionChargeStatuses ADD CONSTRAINT RWQMActions_RWQMActionChargeStatuses_FK 
    FOREIGN KEY (RWQMActionId)
    REFERENCES RWQMActions(RWQMActionId)
    
 
 PRINT 'STEP 4(E) COMPLETED'
END

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='RWQMPreviousActions')
BEGIN
/*  
 * TABLE: RWQMPreviousActions 
 */
CREATE TABLE RWQMPreviousActions(
    RWQMPreviousActionId					int identity(1,1)       NOT NULL,
    CreatedBy								type_CurrentUser        NOT NULL,
    CreatedDate								type_CurrentDatetime    NOT NULL,
    ModifiedBy								type_CurrentUser        NOT NULL,
    ModifiedDate							type_CurrentDatetime    NOT NULL,
    RecordDeleted							type_YOrN               NULL
											CHECK (RecordDeleted in ('Y','N')),
    DeletedBy								type_UserId             NULL,
    DeletedDate								datetime                NULL,
	RWQMActionId							int						NULL,
	PreviousActionId						int						NULL,
   CONSTRAINT RWQMPreviousActions_PK PRIMARY KEY CLUSTERED (RWQMPreviousActionId)                                     
)
IF OBJECT_ID('RWQMPreviousActions') IS NOT NULL
    PRINT '<<< CREATED TABLE RWQMPreviousActions >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE RWQMPreviousActions >>>', 16, 1)   

/* 
 * TABLE: RWQMPreviousActions 
 */
 
 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMPreviousActions') AND name='XIE1_RWQMPreviousActions')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_RWQMPreviousActions] ON [dbo].[RWQMPreviousActions] 
		(
		RWQMActionId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMPreviousActions') AND name='XIE1_RWQMPreviousActions')
		PRINT '<<< CREATED INDEX RWQMPreviousActions.XIE1_RWQMPreviousActions >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX RWQMPreviousActions.XIE1_RWQMPreviousActions >>>', 16, 1)		
		END	 
		
 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMPreviousActions') AND name='XIE2_RWQMPreviousActions')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_RWQMPreviousActions] ON [dbo].[RWQMPreviousActions] 
		(
		PreviousActionId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMPreviousActions') AND name='XIE2_RWQMPreviousActions')
		PRINT '<<< CREATED INDEX RWQMPreviousActions.XIE2_RWQMPreviousActions >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX RWQMPreviousActions.XIE2_RWQMPreviousActions >>>', 16, 1)		
		END	 
    

/* 
 * TABLE: RWQMPreviousActions 
 */
ALTER TABLE RWQMPreviousActions ADD CONSTRAINT RWQMActions_RWQMPreviousActions_FK 
    FOREIGN KEY (RWQMActionId)
    REFERENCES RWQMActions(RWQMActionId)
    
 ALTER TABLE RWQMPreviousActions ADD CONSTRAINT RWQMActions_RWQMPreviousActions_FK2
    FOREIGN KEY (PreviousActionId)
    REFERENCES RWQMActions(RWQMActionId)
    
 
 PRINT 'STEP 4(F) COMPLETED'
END

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='RWQMRules')
BEGIN
/*  
 * TABLE:  RWQMRules 
 */
CREATE TABLE RWQMRules(
    RWQMRuleId								int identity(1,1)       NOT NULL,
    CreatedBy								type_CurrentUser        NOT NULL,
    CreatedDate								type_CurrentDatetime    NOT NULL,
    ModifiedBy								type_CurrentUser        NOT NULL,
    ModifiedDate							type_CurrentDatetime    NOT NULL,
    RecordDeleted							type_YOrN               NULL
											CHECK (RecordDeleted in ('Y','N')),
    DeletedBy								type_UserId             NULL,
    DeletedDate								datetime                NULL,
	StartDate								datetime				NULL,
	EndDate									datetime				NULL,
	Active									type_YOrN               NULL
											CHECK (Active in ('Y','N')),
	RWQMRuleName							varchar(250)			NULL,
	RulePriority							int						NULL,
	RuleType								type_GlobalCode			NULL,
	RuleNumberOfDays						int						NULL,
	Balance									money					NULL,
	IncludeFlaggedCharges					type_YOrN               NULL
											CHECK (IncludeFlaggedCharges in ('Y','N')),
	DaysToDueDate							int						NULL,
	DaysToOverdue							int						NULL,
	AllChargeActions						type_YOrN               NULL
											CHECK (AllChargeActions in ('Y','N')),
	ChargesActions							varchar(max)			NULL,
	AllChargeStatuses						type_YOrN               NULL
											CHECK (AllChargeStatuses in ('Y','N')),
	ChargeStatuses							varchar(max)			NULL,
	AllFinancialAssignments					type_YOrN               NULL
											CHECK (AllFinancialAssignments in ('Y','N')),
	FinancialAssignments					varchar(max)			NULL,
	Comments								type_Comment2			NULL,		
   CONSTRAINT RWQMRules_PK PRIMARY KEY CLUSTERED (RWQMRuleId)                                     
)
IF OBJECT_ID('RWQMRules') IS NOT NULL
    PRINT '<<< CREATED TABLE RWQMRules >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE RWQMRules >>>', 16, 1)   

/* 
 * TABLE: RWQMRules 
 */


 PRINT 'STEP 4(G) COMPLETED'
END


IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='RWQMRuleChargeActions')
BEGIN
/*  
 * TABLE: RWQMRuleChargeActions 
 */
CREATE TABLE RWQMRuleChargeActions(
    RWQMRuleChargeActionId					int identity(1,1)       NOT NULL,
    CreatedBy								type_CurrentUser        NOT NULL,
    CreatedDate								type_CurrentDatetime    NOT NULL,
    ModifiedBy								type_CurrentUser        NOT NULL,
    ModifiedDate							type_CurrentDatetime    NOT NULL,
    RecordDeleted							type_YOrN               NULL
											CHECK (RecordDeleted in ('Y','N')),
    DeletedBy								type_UserId             NULL,
    DeletedDate								datetime                NULL,
	RWQMRuleId								int						NULL,
	RWQMActionId							int						NULL,
   CONSTRAINT RWQMRuleChargeActions_PK PRIMARY KEY CLUSTERED (RWQMRuleChargeActionId)                                     
)
IF OBJECT_ID('RWQMRuleChargeActions') IS NOT NULL
    PRINT '<<< CREATED TABLE RWQMRuleChargeActions >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE RWQMRuleChargeActions >>>', 16, 1)   

/* 
 * TABLE: RWQMRuleChargeActions 
 */
 
 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMRuleChargeActions') AND name='XIE1_RWQMRuleChargeActions')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_RWQMRuleChargeActions] ON [dbo].[RWQMRuleChargeActions] 
		(
		RWQMRuleId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMRuleChargeActions') AND name='XIE1_RWQMRuleChargeActions')
		PRINT '<<< CREATED INDEX RWQMRuleChargeActions.XIE1_RWQMRuleChargeActions >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX RWQMRuleChargeActions.XIE1_RWQMRuleChargeActions >>>', 16, 1)		
		END	 
		
 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMRuleChargeActions') AND name='XIE2_RWQMRuleChargeActions')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_RWQMRuleChargeActions] ON [dbo].[RWQMRuleChargeActions] 
		(
		RWQMActionId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMRuleChargeActions') AND name='XIE2_RWQMRuleChargeActions')
		PRINT '<<< CREATED INDEX RWQMRuleChargeActions.XIE2_RWQMRuleChargeActions >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX RWQMRuleChargeActions.XIE2_RWQMRuleChargeActions >>>', 16, 1)		
		END	 
    

/* 
 * TABLE: RWQMRuleChargeActions 
 */
ALTER TABLE RWQMRuleChargeActions ADD CONSTRAINT RWQMRules_RWQMRuleChargeActions_FK 
    FOREIGN KEY (RWQMRuleId)
    REFERENCES RWQMRules(RWQMRuleId)
    
 ALTER TABLE RWQMRuleChargeActions ADD CONSTRAINT RWQMActions_RWQMRuleChargeActions_FK
    FOREIGN KEY (RWQMActionId)
    REFERENCES RWQMActions(RWQMActionId)
    
 
 PRINT 'STEP 4(H) COMPLETED'
END

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='RWQMRuleChargeStatuses')
BEGIN
/*  
 * TABLE:  RWQMRuleChargeStatuses 
 */
CREATE TABLE RWQMRuleChargeStatuses(
    RWQMRuleChargeStatusId					int identity(1,1)       NOT NULL,
    CreatedBy								type_CurrentUser        NOT NULL,
    CreatedDate								type_CurrentDatetime    NOT NULL,
    ModifiedBy								type_CurrentUser        NOT NULL,
    ModifiedDate							type_CurrentDatetime    NOT NULL,
    RecordDeleted							type_YOrN               NULL
											CHECK (RecordDeleted in ('Y','N')),
    DeletedBy								type_UserId             NULL,
    DeletedDate								datetime                NULL,
	RWQMRuleId								int						NULL,
	ChargeStatuses							type_GlobalCode			NULL,
   CONSTRAINT RWQMRuleChargeStatuses_PK PRIMARY KEY CLUSTERED (RWQMRuleChargeStatusId)                                     
)
IF OBJECT_ID('RWQMRuleChargeStatuses') IS NOT NULL
    PRINT '<<< CREATED TABLE RWQMRuleChargeStatuses >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE RWQMRuleChargeStatuses >>>', 16, 1)   

/* 
 * TABLE: RWQMRuleChargeStatuses 
 */
 
 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMRuleChargeStatuses') AND name='XIE1_RWQMRuleChargeStatuses')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_RWQMRuleChargeStatuses] ON [dbo].[RWQMRuleChargeStatuses] 
		(
		RWQMRuleId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMRuleChargeStatuses') AND name='XIE1_RWQMRuleChargeStatuses')
		PRINT '<<< CREATED INDEX RWQMRuleChargeStatuses.XIE1_RWQMRuleChargeStatuses >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX RWQMRuleChargeStatuses.XIE1_RWQMRuleChargeStatuses >>>', 16, 1)		
		END	 
    

/* 
 * TABLE: RWQMRuleChargeStatuses 
 */
ALTER TABLE RWQMRuleChargeStatuses ADD CONSTRAINT RWQMRules_RWQMRuleChargeStatuses_FK 
    FOREIGN KEY (RWQMRuleId)
    REFERENCES RWQMRules(RWQMRuleId)
       
 
 PRINT 'STEP 4(I) COMPLETED'
END


IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='RWQMRuleFinancialAssignments')
BEGIN
/*  
 * TABLE: RWQMRuleFinancialAssignments 
 */
CREATE TABLE RWQMRuleFinancialAssignments(
    RWQMRuleFinancialAssignmentId			int identity(1,1)       NOT NULL,
    CreatedBy								type_CurrentUser        NOT NULL,
    CreatedDate								type_CurrentDatetime    NOT NULL,
    ModifiedBy								type_CurrentUser        NOT NULL,
    ModifiedDate							type_CurrentDatetime    NOT NULL,
    RecordDeleted							type_YOrN               NULL
											CHECK (RecordDeleted in ('Y','N')),
    DeletedBy								type_UserId             NULL,
    DeletedDate								datetime                NULL,
	RWQMRuleId								int						NULL,
	FinancialAssignmentId					int						NULL,
   CONSTRAINT RWQMRuleFinancialAssignments_PK PRIMARY KEY CLUSTERED (RWQMRuleFinancialAssignmentId)                                     
)
IF OBJECT_ID('RWQMRuleFinancialAssignments') IS NOT NULL
    PRINT '<<< CREATED TABLE RWQMRuleFinancialAssignments >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE RWQMRuleFinancialAssignments >>>', 16, 1)   

/* 
 * TABLE: RWQMRuleFinancialAssignments 
 */
 
 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMRuleFinancialAssignments') AND name='XIE1_RWQMRuleFinancialAssignments')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_RWQMRuleFinancialAssignments] ON [dbo].[RWQMRuleFinancialAssignments] 
		(
		RWQMRuleId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMRuleFinancialAssignments') AND name='XIE1_RWQMRuleFinancialAssignments')
		PRINT '<<< CREATED INDEX RWQMRuleFinancialAssignments.XIE1_RWQMRuleFinancialAssignments >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX RWQMRuleFinancialAssignments.XIE1_RWQMRuleFinancialAssignments >>>', 16, 1)		
		END	 
		
 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMRuleFinancialAssignments') AND name='XIE2_RWQMRuleFinancialAssignments')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_RWQMRuleFinancialAssignments] ON [dbo].[RWQMRuleFinancialAssignments] 
		(
		FinancialAssignmentId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMRuleFinancialAssignments') AND name='XIE2_RWQMRuleFinancialAssignments')
		PRINT '<<< CREATED INDEX RWQMRuleFinancialAssignments.XIE2_RWQMRuleFinancialAssignments >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX RWQMRuleFinancialAssignments.XIE2_RWQMRuleFinancialAssignments >>>', 16, 1)		
		END	 
    

/* 
 * TABLE: RWQMRuleFinancialAssignments 
 */
ALTER TABLE RWQMRuleFinancialAssignments ADD CONSTRAINT RWQMRules_RWQMRuleFinancialAssignments_FK 
    FOREIGN KEY (RWQMRuleId)
    REFERENCES RWQMRules(RWQMRuleId)
    
 ALTER TABLE RWQMRuleFinancialAssignments ADD CONSTRAINT FinancialAssignments_RWQMRuleFinancialAssignments_FK
    FOREIGN KEY (FinancialAssignmentId)
    REFERENCES FinancialAssignments(FinancialAssignmentId)
    
 
 PRINT 'STEP 4(J) COMPLETED'
END

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='RWQMWorkQueue')
BEGIN
/*  
 * TABLE: RWQMWorkQueue 
 */
CREATE TABLE RWQMWorkQueue(
    RWQMWorkQueueId							int identity(1,1)       NOT NULL,
    CreatedBy								type_CurrentUser        NOT NULL,
    CreatedDate								type_CurrentDatetime    NOT NULL,
    ModifiedBy								type_CurrentUser        NOT NULL,
    ModifiedDate							type_CurrentDatetime    NOT NULL,
    RecordDeleted							type_YOrN               NULL
											CHECK (RecordDeleted in ('Y','N')),
    DeletedBy								type_UserId             NULL,
    DeletedDate								datetime                NULL,
	ChargeId								int						NULL,						
	FinancialAssignmentId					int						NULL,
	RWQMAssignedId							int						NULL,
	RWQMAssignedBackupId					int						NULL,
	RWQMRuleId								int						NULL,
	RWQMActionId							int						NULL,
	ClientContactNoteId						int						NULL,
	CompletedBy								int						NULL,
	DueDate									datetime                NULL,
	OverdueDate								datetime                NULL,	
	CompletedDate							datetime                NULL,
	ActionComments							type_Comment2			NULL,
   CONSTRAINT RWQMWorkQueue_PK PRIMARY KEY CLUSTERED (RWQMWorkQueueId)                                     
)
IF OBJECT_ID('RWQMWorkQueue') IS NOT NULL
    PRINT '<<< CREATED TABLE RWQMWorkQueue >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE RWQMWorkQueue >>>', 16, 1)   

/* 
 * TABLE: RWQMWorkQueue 
 */
 
 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMWorkQueue') AND name='XIE1_RWQMWorkQueue')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_RWQMWorkQueue] ON [dbo].[RWQMWorkQueue] 
		(
		ChargeId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMWorkQueue') AND name='XIE1_RWQMWorkQueue')
		PRINT '<<< CREATED INDEX RWQMWorkQueue.XIE1_RWQMWorkQueue >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX RWQMWorkQueue.XIE1_RWQMWorkQueue >>>', 16, 1)		
		END	 
		
 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMWorkQueue') AND name='XIE2_RWQMWorkQueue')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_RWQMWorkQueue] ON [dbo].[RWQMWorkQueue] 
		(
		RWQMRuleId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMWorkQueue') AND name='XIE2_RWQMWorkQueue')
		PRINT '<<< CREATED INDEX RWQMWorkQueue.XIE2_RWQMWorkQueue >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX RWQMWorkQueue.XIE2_RWQMWorkQueue >>>', 16, 1)		
		END	 
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMWorkQueue') AND name='XIE3_RWQMWorkQueue')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE3_RWQMWorkQueue] ON [dbo].[RWQMWorkQueue] 
		(
		FinancialAssignmentId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMWorkQueue') AND name='XIE3_RWQMWorkQueue')
		PRINT '<<< CREATED INDEX RWQMWorkQueue.XIE3_RWQMWorkQueue >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX RWQMWorkQueue.XIE3_RWQMWorkQueue >>>', 16, 1)		
		END	 
		 
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMWorkQueue') AND name='XIE4_RWQMWorkQueue')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE4_RWQMWorkQueue] ON [dbo].[RWQMWorkQueue] 
		(
		CompletedBy ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMWorkQueue') AND name='XIE4_RWQMWorkQueue')
		PRINT '<<< CREATED INDEX RWQMWorkQueue.XIE4_RWQMWorkQueue >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX RWQMWorkQueue.XIE4_RWQMWorkQueue >>>', 16, 1)		
		END	 

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMWorkQueue') AND name='XIE5_RWQMWorkQueue')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE5_RWQMWorkQueue] ON [dbo].[RWQMWorkQueue] 
		(
		RWQMActionId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMWorkQueue') AND name='XIE5_RWQMWorkQueue')
		PRINT '<<< CREATED INDEX RWQMWorkQueue.XIE5_RWQMWorkQueue >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX RWQMWorkQueue.XIE5_RWQMWorkQueue >>>', 16, 1)		
		END	 

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMWorkQueue') AND name='XIE6_RWQMWorkQueue')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE6_RWQMWorkQueue] ON [dbo].[RWQMWorkQueue] 
		(
		ClientContactNoteId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMWorkQueue') AND name='XIE6_RWQMWorkQueue')
		PRINT '<<< CREATED INDEX RWQMWorkQueue.XIE6_RWQMWorkQueue >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX RWQMWorkQueue.XIE6_RWQMWorkQueue >>>', 16, 1)		
		END	 
				   
		   

/* 
 * TABLE: RWQMWorkQueue 
 */
ALTER TABLE RWQMWorkQueue ADD CONSTRAINT Charges_RWQMWorkQueue_FK 
    FOREIGN KEY (ChargeId)
    REFERENCES Charges(ChargeId)
    
ALTER TABLE RWQMWorkQueue ADD CONSTRAINT RWQMRules_RWQMWorkQueue_FK
    FOREIGN KEY (RWQMRuleId)
    REFERENCES RWQMRules(RWQMRuleId)

ALTER TABLE RWQMWorkQueue ADD CONSTRAINT FinancialAssignments_RWQMWorkQueue_FK
    FOREIGN KEY (FinancialAssignmentId)
    REFERENCES FinancialAssignments(FinancialAssignmentId)

ALTER TABLE RWQMWorkQueue ADD CONSTRAINT RWQMActions_RWQMWorkQueue_FK
    FOREIGN KEY (RWQMActionId)
    REFERENCES RWQMActions(RWQMActionId)

ALTER TABLE RWQMWorkQueue ADD CONSTRAINT ClientContactNotes_RWQMWorkQueue_FK
    FOREIGN KEY (ClientContactNoteId)
    REFERENCES ClientContactNotes(ClientContactNoteId)
    
 ALTER TABLE RWQMWorkQueue ADD CONSTRAINT Staff_RWQMWorkQueue_FK
    FOREIGN KEY (CompletedBy)
    REFERENCES Staff(StaffId)
    
 ALTER TABLE RWQMWorkQueue ADD CONSTRAINT Staff_RWQMWorkQueue_FK2
    FOREIGN KEY (RWQMAssignedId)
    REFERENCES Staff(StaffId)
    
ALTER TABLE RWQMWorkQueue ADD CONSTRAINT Staff_RWQMWorkQueue_FK3
    FOREIGN KEY (RWQMAssignedBackupId)
    REFERENCES Staff(StaffId)
    
    
 PRINT 'STEP 4(K) COMPLETED'
END

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='RWQMClientContactNotes')
BEGIN
/*  
 * TABLE: RWQMClientContactNotes
 */
 CREATE TABLE RWQMClientContactNotes( 
		RWQMClientContactNoteId					int	identity(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime			 NULL,
		ClientContactNoteId						int					 NULL,
		RWQMWorkQueueId							int					 NULL,
		CONSTRAINT RWQMClientContactNotes_PK PRIMARY KEY CLUSTERED (RWQMClientContactNoteId)
)
  IF OBJECT_ID('RWQMClientContactNotes') IS NOT NULL
    PRINT '<<< CREATED TABLE RWQMClientContactNotes >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE RWQMClientContactNotes >>>', 16, 1)
    
 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMClientContactNotes') AND name='XIE1_RWQMClientContactNotes')
	BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_RWQMClientContactNotes] ON [dbo].[RWQMClientContactNotes] 
		(
		ClientContactNoteId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMClientContactNotes') AND name='XIE1_RWQMClientContactNotes')
		PRINT '<<< CREATED INDEX RWQMClientContactNotes.XIE1_RWQMClientContactNotes >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX RWQMClientContactNotes.XIE1_RWQMClientContactNotes >>>', 16, 1)		
	END	
	
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMClientContactNotes') AND name='XIE2_RWQMClientContactNotes')
	BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_RWQMClientContactNotes] ON [dbo].[RWQMClientContactNotes] 
		(
		RWQMWorkQueueId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('RWQMClientContactNotes') AND name='XIE2_RWQMClientContactNotes')
		PRINT '<<< CREATED INDEX RWQMClientContactNotes.XIE2_RWQMClientContactNotes >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX RWQMClientContactNotes.XIE2_RWQMClientContactNotes >>>', 16, 1)		
	END		
    
/*  
 * TABLE: RWQMClientContactNotes 
 */   
     
ALTER TABLE RWQMClientContactNotes ADD CONSTRAINT ClientContactNotes_RWQMClientContactNotes_FK
    FOREIGN KEY (ClientContactNoteId)
    REFERENCES ClientContactNotes(ClientContactNoteId)
    
ALTER TABLE RWQMClientContactNotes ADD CONSTRAINT RWQMWorkQueue_RWQMClientContactNotes_FK
    FOREIGN KEY (RWQMWorkQueueId)
    REFERENCES RWQMWorkQueue(RWQMWorkQueueId)
    
     PRINT 'STEP 4(L) COMPLETED'
 END



----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 18.16)
BEGIN
Update SystemConfigurations set DataModelVersion=18.17
PRINT 'STEP 7 COMPLETED'
END
Go

