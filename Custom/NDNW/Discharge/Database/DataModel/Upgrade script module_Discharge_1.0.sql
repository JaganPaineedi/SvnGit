----- STEP 1 ----------

------ STEP 2 ----------
--Part1 Begin
--Part1 Ends

--Part2 Begins


--Part2 Ends
-----End of Step 2 -------

------ STEP 3 ------------

IF COL_LENGTH('CustomClients','EducationLevel') IS NULL
BEGIN
	ALTER TABLE CustomClients ADD EducationLevel type_GlobalCode NULL
END

IF COL_LENGTH('CustomClients','ForensicTreatment') IS NULL
BEGIN
	ALTER TABLE CustomClients ADD ForensicTreatment type_GlobalCode NULL
END

IF COL_LENGTH('CustomClients','MilitaryService') IS NULL
BEGIN
	ALTER TABLE CustomClients ADD MilitaryService type_GlobalCode NULL
END

IF COL_LENGTH('CustomClients','Legal') IS NULL
BEGIN
	ALTER TABLE CustomClients ADD Legal type_GlobalCode NULL
END

IF COL_LENGTH('CustomClients','JusticeSystemInvolvement') IS NULL
BEGIN
	ALTER TABLE CustomClients ADD JusticeSystemInvolvement type_GlobalCode NULL
END

IF COL_LENGTH('CustomClients','NumberOfArrestsLast30Days') IS NULL
BEGIN
	ALTER TABLE CustomClients ADD NumberOfArrestsLast30Days int NULL
END

IF COL_LENGTH('CustomClients','AdvanceDirective') IS NULL
BEGIN
	ALTER TABLE CustomClients ADD AdvanceDirective type_GlobalCode NULL
END

IF COL_LENGTH('CustomClients','TobaccoUse') IS NULL
BEGIN
	ALTER TABLE CustomClients ADD TobaccoUse type_GlobalCode NULL
END

IF COL_LENGTH('CustomClients','AgeOfFirstTobaccoUse') IS NULL
BEGIN
	 ALTER TABLE CustomClients ADD AgeOfFirstTobaccoUse int NULL
END

IF COL_LENGTH('CustomClients','TitleXXNo') IS NULL
BEGIN
	ALTER TABLE CustomClients ADD TitleXXNo varchar(50) NULL
END

IF COL_LENGTH('CustomClients','SamhisId') IS NULL
BEGIN
	ALTER TABLE CustomClients ADD SamhisId varchar(50) NULL
END

PRINT 'STEP 3 COMPLETED'

------ END OF STEP 3 -----

------ STEP 4 ----------

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentDischarges')
BEGIN
/*		 
 * TABLE: CustomDocumentDischarges 
 */
 CREATE TABLE CustomDocumentDischarges( 
		DocumentVersionId						int					 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,	
		NewPrimaryClientProgramId				int					 NULL,	
		DischargeType							char(1)				 NULL
												CHECK (DischargeType in ('P', 'A')),      			
		TransitionDischarge						type_GlobalCode		 NULL,	
		DischargeDetails						type_Comment2		 NULL,
		OverallProgress 						type_Comment2		 NULL,	
		StatusLastContact						type_Comment2		 NULL,
		EducationLevel							type_GlobalCode		 NULL,
		MaritalStatus							type_GlobalCode		 NULL,
		EducationStatus							type_GlobalCode		 NULL,	
		EmploymentStatus						type_GlobalCode		 NULL,	
		ForensicCourtOrdered 					type_GlobalCode		 NULL,
		CurrentlyServingMilitary				type_GlobalCode		 NULL,	
		Legal									type_GlobalCode		 NULL,
		JusticeSystem							type_GlobalCode		 NULL,
		LivingArrangement 						type_GlobalCode		 NULL,
		Arrests									varchar(20)			 NULL,
		AdvanceDirective						type_GlobalCode		 NULL,
		TobaccoUse								type_GlobalCode		 NULL,
		AgeOfFirstTobaccoUse					varchar(20)			 NULL,
		CountyResidence							type_GlobalCode		 NULL,
		CountyFinancialResponsibility			type_GlobalCode		 NULL,
		NoReferral 								type_YOrN			 NULL
												CHECK (NoReferral in ('Y','N')),
		SymptomsReoccur 						type_Comment2		 NULL,
		ReferredTo 								type_Comment2		 NULL,
		Reason									type_Comment2		 NULL,
		DatesTimes 								type_Comment2		 NULL,
		ReferralDischarge					    type_GlobalCode		 NULL,
		TreatmentCompletion						type_GlobalCode		 NULL,
		CoOccurringHealthProblem     			type_YOrN			 NULL
												CHECK (CoOccurringHealthProblem in ('Y','N')),
		ClientType                   			type_GlobalCode		 NULL,
		HealthInsurance                         type_Comment2		 NULL,
		VocationalRehab              			type_YOrN			 NULL
												CHECK (VocationalRehab in ('Y','N')),
		SchoolAttendance             			type_GlobalCode		 NULL,
		StableHousing                      		int					 NULL,
		NumberOfMonthsEmployed            		int					 NULL,
		NumberOfEmployers                    	int					 NULL,
		ArrestsInLast12Months                   int					 NULL,
		IncarceratedInLast12Months              int					 NULL,
		GrossAnnualHouseholdIncome              decimal(18,2)		 NULL,
		CONSTRAINT CustomDocumentDischarges_PK PRIMARY KEY CLUSTERED (DocumentVersionId) 
 )
 
 IF OBJECT_ID('CustomDocumentDischarges') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentDischarges >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentDischarges >>>', 16, 1)
/* 
 * TABLE: CustomDocumentDischarges 
 */   
    
ALTER TABLE CustomDocumentDischarges ADD CONSTRAINT DocumentVersions_CustomDocumentDischarges_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
 
 PRINT 'STEP 4(A) COMPLETED'
 END
 
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDischargePrograms')
BEGIN
/* 
 * TABLE: CustomDischargePrograms 
 */
 CREATE TABLE CustomDischargePrograms( 
		DischargeProgramId						int identity(1,1)    NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,		
		DocumentVersionId						int					 NULL,
		ClientProgramId							int					 NULL,
		CONSTRAINT CustomDischargePrograms_PK PRIMARY KEY CLUSTERED (DischargeProgramId) 
 )
 
 IF OBJECT_ID('CustomDischargePrograms') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDischargePrograms >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDischargePrograms >>>', 16, 1)
/* 
 * TABLE: CustomDischargePrograms 
 */   
    
ALTER TABLE CustomDischargePrograms ADD CONSTRAINT DocumentVersions_CustomDischargePrograms_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
 
 ALTER TABLE CustomDischargePrograms ADD CONSTRAINT ClientPrograms_CustomDischargePrograms_FK
    FOREIGN KEY (ClientProgramId)
    REFERENCES ClientPrograms(ClientProgramId)
 
 PRINT 'STEP 4(B) COMPLETED'
 END
 
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDischargeReferrals')
BEGIN
/* 
 * TABLE: CustomDischargeReferrals 
 */
 CREATE TABLE CustomDischargeReferrals( 
		DischargeReferralId						int identity(1,1)    NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		DocumentVersionId						int					 NULL,
		Referral								type_GlobalCode		 NULL,
		Program									type_GlobalCode		 NULL,
		CONSTRAINT CustomDischargeReferrals_PK PRIMARY KEY CLUSTERED (DischargeReferralId) 
 )
 
 IF OBJECT_ID('CustomDischargeReferrals') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDischargeReferrals >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDischargeReferrals >>>', 16, 1)
/* 
 * TABLE: CustomDischargeReferrals 
 */   
    
ALTER TABLE CustomDischargeReferrals ADD CONSTRAINT DocumentVersions_CustomDischargeReferrals_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
 
 PRINT 'STEP 4(C) COMPLETED'
 END

---------------------------------------------------------------
--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF NOT EXISTS (SELECT [key] FROM SystemConfigurationKeys WHERE [key] = 'CDM_Discharge')
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
				   ,'CDM_Discharge'
				   ,'1.0'
				   )
		PRINT 'STEP 7 COMPLETED'
	END
 GO
