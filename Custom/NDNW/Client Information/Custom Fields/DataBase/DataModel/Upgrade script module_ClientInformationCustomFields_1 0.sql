---- STEP 1 ----------

------ STEP 2 ----------

-----End of Step 2 -------

------ STEP 3 ------------
IF OBJECT_ID('CustomClients') IS NOT NULL	
BEGIN
	IF COL_LENGTH('CustomClients','InsuranceType') IS NULL
	BEGIN
		ALTER TABLE CustomClients  ADD InsuranceType	type_GlobalCode	NULL
	END
		PRINT 'STEP 3 COMPLETED'

END

------ END OF STEP 3 ----

------ STEP 4 ----------

 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomClients')
BEGIN
/* 
  TABLE: CustomClients 
 */
 CREATE TABLE CustomClients( 
		ClientId						int 						NOT NULL, 
		CreatedBy						type_CurrentUser			NOT NULL,
		CreatedDate						type_Currentdatetime		NOT NULL,
		ModifiedBy						type_CurrentUser			NOT NULL,
		ModifiedDate					type_Currentdatetime		NOT NULL,
		RecordDeleted					type_YOrN					NULL
										CHECK (RecordDeleted in ('Y','N')),
		DeletedBy						type_UserId					NULL,	
		DeletedDate						datetime					NULL,	
		AccompaniedByChild				type_YOrN					NULL
										CHECK (AccompaniedByChild in ('Y','N')),
		ChildName1						varchar(250)				NULL,
		ChildDOB1						datetime					NULL,
		MoveInDate1						datetime					NULL,
		MoveOutDate1					datetime					NULL,
		ReasonForLeaving1				varchar(250)				NULL,
		ChildName2						varchar(250)				NULL,
		ChildDOB2						datetime					NULL,
		MoveInDate2						datetime					NULL,
		MoveOutDate2					datetime					NULL,
		ReasonForLeaving2				varchar(250)				NULL,
		ChildName3						varchar(250)				NULL,
		ChildDOB3						varchar(250)				NULL,
		MoveInDate3						datetime					NULL,
		MoveOutDate3					datetime					NULL,
		ReasonForLeaving3				varchar(250)				NULL,
		CurrentlyEnrolledInEducation	type_YOrN					NULL
										CHECK (CurrentlyEnrolledInEducation in ('Y','N')),
		NameOfSchool					varchar(250)				NULL,
		TCUEntryDate					datetime					NULL,
		TCUScore						varchar(250)				NULL,
		NinetyDayScoreDate				datetime					NULL,
		NinetyDayScore					varchar(250)				NULL,
		DischargeScoreDate				datetime					NULL,
		DischargeScore					varchar(250)				NULL,
		AIPDateOfIncarceration			datetime					NULL,
		AIPPotentialReleaseDate			datetime					NULL,
		AIPActualReleaseDate			datetime					NULL,
		AIPTransLeaveDate				datetime					NULL,
		AIPPostPrisonSupervisionEndDate datetime					NULL,
		ChildMedicaidId1				int							NULL,
		ChildMedicaidId2				int							NULL,
		ChildMedicaidId3				int							NULL,
		FoodStampsAdmissionDate			date						NULL,
		FoodStampsSubmittedDate			date						NULL,
		FoodStampsApprovalDate			date						NULL,
		FoodStampsClientLeaveDate		date						NULL,
		FoodStampsClientLeaveTime		datetime					NULL,
		Legal							type_GlobalCode				NULL,
		SIDNumber						varchar(30)					NULL,
		ODLOINumber						varchar(30)					NULL,
		EducationLevel					type_GlobalCode				NULL,
		ForensicTreatment				type_GlobalCode				NULL,
		MilitaryService					type_GlobalCode				NULL,
		JusticeSystemInvolvement		type_GlobalCode				NULL,
		NumberOfArrestsLast30Days		int							NULL,
		AdvanceDirective				type_GlobalCode				NULL,
		TobaccoUse						type_GlobalCode				NULL,
		AgeOfFirstTobaccoUse			int							NULL,
		TitleXXNo						varchar(50)					NULL,
		SamhisId						varchar(50)					NULL,
		InterpreterNeeded				type_GlobalCode				NULL,
		AIPSIDNumber					varchar(30)					NULL,
		MotherMaidenName				varchar(50)					NULL,
		JailDiversionStatus				type_GlobalCode				NULL,
		Race							varchar(30)					NULL,
		Ethnicity						varchar(30)					NULL,
		MaritalStatus					varchar(30)					NULL,
		EmploymentStatus				varchar(30)					NULL,
		EmploymentStartDate				date						NULL,
		EmploymentEndDate				date						NULL,
		WellVisitLast12Months			type_YOrN					NULL
										CHECK (WellVisitLast12Months in ('Y','N')),
		WellVisitLastDate				datetime					NULL,
		WellVisitReferralDate			datetime					NULL,
		PrimaryPhysician				type_GlobalCode				NULL,
		InsuranceType					type_GlobalCode				NULL,
		CONSTRAINT CustomClients_PK PRIMARY KEY CLUSTERED (ClientId)
 )
 
  IF OBJECT_ID('CustomClients') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomClients >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomClients >>>', 16, 1)
         
/* 
 * TABLE: CustomClients 
 */
         
	PRINT 'STEP 4(A) COMPLETED'
 END
-------END Of STEP 4-----

------ STEP 5 ---------------- 

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

If not exists (select [key] from SystemConfigurationKeys where [key] = 'CDM_ClientInformationCustomFields')
	begin
		INSERT intO [dbo].[SystemConfigurationKeys]
				   (CreatedBy
				   ,CreateDate 
				   ,ModifiedBy
				   ,ModifiedDate
				   ,[Key]
				   ,Value
				   )
			 VALUES    
				   ('SHSDBA'
				   ,GETDATE()
				   ,'SHSDBA'
				   ,GETDATE()
				   ,'CDM_ClientInformationCustomFields'
				   ,'1.0'
				   )
 PRINT 'STEP 7 COMPLETED'
 End

 