----- STEP 1 ----------

------ STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins


--Part2 Ends
-----End of Step 2 -------

------ STEP 3 ------------
IF  EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomInquiries')
BEGIN
IF COL_LENGTH('CustomInquiries','InquireFirstName')IS NOT NULL AND COL_LENGTH('CustomInquiries','InquirerFirstName')IS NULL
	BEGIN
		Exec sp_RENAME 'CustomInquiries.InquireFirstName' , 'InquirerFirstName', 'COLUMN'	
	END
	IF COL_LENGTH('CustomInquiries','DispositionComment')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD DispositionComment type_Comment2 NULL																																														
	END	
	IF COL_LENGTH('CustomInquiries','InquiryStatus')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD InquiryStatus type_GlobalCode NULL																																														
	END
	IF COL_LENGTH('CustomInquiries','InquiryStartDateTime')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD InquiryStartDateTime datetime  NULL
	END
		IF COL_LENGTH('CustomInquiries','InquiryEventId')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD InquiryEventId	int	NULL
	END
	IF COL_LENGTH('CustomInquiries','Sex')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD Sex	type_Sex NULL
										CHECK (Sex in ('U','F','M'))
	END
	IF COL_LENGTH('CustomInquiries','MedicaidId')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD MedicaidId	varchar (25) NULL										
	END
	IF COL_LENGTH('CustomInquiries','PresentingProblem')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD PresentingProblem	type_Comment2 NULL										
	END
	IF COL_LENGTH('CustomInquiries','UrgencyLevel')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD UrgencyLevel type_GlobalCode NULL										
	END
	IF COL_LENGTH('CustomInquiries','InquiryType')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD InquiryType type_GlobalCode NULL										
	END
	 IF COL_LENGTH('CustomInquiries','ContactType')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD ContactType type_GlobalCode NULL										
	END
	IF COL_LENGTH('CustomInquiries','Location')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD Location type_GlobalCode NULL										
	END
	IF COL_LENGTH('CustomInquiries','ClientCanLegalySign')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD ClientCanLegalySign type_YOrN   NULL
										CHECK (ClientCanLegalySign in ('Y','N'))										
	END
	IF COL_LENGTH('CustomInquiries','EmergencyContactFirstName')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD EmergencyContactFirstName type_FirstName NULL										
	END
	IF COL_LENGTH('CustomInquiries','EmergencyContactMiddleName')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD EmergencyContactMiddleName type_MiddleName NULL										
	END
	IF COL_LENGTH('CustomInquiries','EmergencyContactLastName')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD EmergencyContactLastName type_LastName NULL										
	END
	IF COL_LENGTH('CustomInquiries','EmergencyContactRelationToClient')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD EmergencyContactRelationToClient type_GlobalCode NULL										
	END
	IF COL_LENGTH('CustomInquiries','EmergencyContactHomePhone')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD EmergencyContactHomePhone varchar(25) NULL										
	END
	IF COL_LENGTH('CustomInquiries','EmergencyContactCellPhone')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD EmergencyContactCellPhone varchar(25) NULL										
	END
	IF COL_LENGTH('CustomInquiries','EmergencyContactWorkPhone')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD EmergencyContactWorkPhone varchar(25) NULL										
	END
	IF COL_LENGTH('CustomInquiries','PopulationDD')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD PopulationDD type_YesNoUnknown	NULL
										CHECK (PopulationDD in ('U','N','Y'))										
	END
	IF COL_LENGTH('CustomInquiries','SAType')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD SAType type_GlobalCode	NULL																				
	END
	IF COL_LENGTH('CustomInquiries','PrimarySpokenLanguage')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD PrimarySpokenLanguage type_GlobalCode	NULL																				
	END	
	IF COL_LENGTH('CustomInquiries','SchoolName')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD SchoolName varchar(50)	NULL																												
	END
	IF COL_LENGTH('CustomInquiries','AccomodationNeeded')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD AccomodationNeeded varchar(5) NULL																												
	END
	IF COL_LENGTH('CustomInquiries','Pregnant')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD Pregnant char(1) NULL
										CHECK (Pregnant in ('A','U','N','Y'))																												
	END
	IF COL_LENGTH('CustomInquiries','InjectingDrugs')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD InjectingDrugs type_YesNoUnknown NULL
										CHECK (InjectingDrugs in ('U','N','Y'))																																					
	END
	IF COL_LENGTH('CustomInquiries','GatheredBy')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD GatheredBy int NULL																																														
	END
	IF COL_LENGTH('CustomInquiries','ProgramId')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD ProgramId int NULL																																														
	END
	IF COL_LENGTH('CustomInquiries','ProgramId')IS NOT NULL
	BEGIN
		IF  NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Programs_CustomInquiries_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomInquiries]'))
		BEGIN	    
			ALTER TABLE CustomInquiries ADD CONSTRAINT Programs_CustomInquiries_FK 
				FOREIGN KEY (ProgramId)
				REFERENCES Programs(ProgramId) 
		END	
	END
	IF COL_LENGTH('CustomInquiries','GatheredByOther')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD GatheredByOther varchar(50) NULL																																														
	END
	IF COL_LENGTH('CustomInquiries','InquiryDetails')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD InquiryDetails type_Comment2 NULL																																														
	END
	IF COL_LENGTH('CustomInquiries','InquiryEndDateTime')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD InquiryEndDateTime datetime NULL																																														
	END
	IF COL_LENGTH('CustomInquiries','Living')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD Living type_GlobalCode NULL																																														
	END
	IF COL_LENGTH('CustomInquiries','NoOfBeds')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD NoOfBeds type_GlobalCode NULL																																														
	END
	IF COL_LENGTH('CustomInquiries','CountyOfResidence')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD CountyOfResidence char(5) NULL																																														
	END
	IF COL_LENGTH('CustomInquiries','COFR')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD COFR char(5) NULL																																														
	END
	IF COL_LENGTH('CustomInquiries','CorrectionStatus')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD CorrectionStatus type_GlobalCode NULL																																														
	END
	IF COL_LENGTH('CustomInquiries','EducationalStatus')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD EducationalStatus type_GlobalCode NULL																																														
	END
	IF COL_LENGTH('CustomInquiries','DHSStatus')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD DHSStatus type_YOrNOrNA	NULL
										CHECK (DHSStatus in ('A','N','Y'))																																														
	END
	IF COL_LENGTH('CustomInquiries','GuardianSameAsCaller')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD GuardianSameAsCaller type_YOrN	NULL
										CHECK (GuardianSameAsCaller in ('N','Y'))																																														
	END
	IF COL_LENGTH('CustomInquiries','GuardianFirstName')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD GuardianFirstName varchar(50) NULL																																																							
	END
	IF COL_LENGTH('CustomInquiries','GuardianLastName')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD GuardianLastName varchar(50) NULL																																																							
	END
	IF COL_LENGTH('CustomInquiries','GuardianPhoneNumber')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD GuardianPhoneNumber varchar(25) NULL																																																							
	END
	IF COL_LENGTH('CustomInquiries','GuardianPhoneType')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD GuardianPhoneType type_GlobalCode NULL																																																							
	END
	IF COL_LENGTH('CustomInquiries','GuardianDOB')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD GuardianDOB datetime NULL																																																							
	END
	IF COL_LENGTH('CustomInquiries','EmergencyContactSameAsCaller')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD EmergencyContactSameAsCaller type_YOrN	NULL
										CHECK (EmergencyContactSameAsCaller in ('N','Y'))																																																							
	END
	IF COL_LENGTH('CustomInquiries','MemberCell')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD MemberCell varchar(25)	NULL																																																																
	END
	IF COL_LENGTH('CustomInquiries','GurdianDPOAStatus')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD GurdianDPOAStatus char(1)	NULL																																																																
	END
	IF COL_LENGTH('CustomInquiries','GardianComment')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD GardianComment type_Comment2	NULL																																																																
	END
	IF COL_LENGTH('CustomInquiries','SSNUnknown')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD SSNUnknown type_YOrN	NULL
										CHECK (SSNUnknown in ('N','Y'))																																																							
	END
	IF COL_LENGTH('CustomInquiries','RiskAssessmentInDanger')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD RiskAssessmentInDanger type_YOrN	NULL
										CHECK (RiskAssessmentInDanger in ('N','Y'))																																																							
	END	
	IF COL_LENGTH('CustomInquiries','RiskAssessmentInDangerComment')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD RiskAssessmentInDangerComment type_Comment2	NULL																																																																
	END
	IF COL_LENGTH('CustomInquiries','RiskAssessmentCounselorAvailability')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD RiskAssessmentCounselorAvailability type_YOrN	NULL
										CHECK (RiskAssessmentCounselorAvailability in ('N','Y'))																																																							
	END	
	IF COL_LENGTH('CustomInquiries','RiskAssessmentCounselorAvailabilityComment')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD RiskAssessmentCounselorAvailabilityComment type_Comment2	NULL																																																																
	END
	IF COL_LENGTH('CustomInquiries','RiskAssessmentCrisisLine')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD RiskAssessmentCrisisLine type_Comment2	NULL																																																																
	END	
	IF COL_LENGTH('CustomInquiries','RiskAssessmentCrisisLineComment')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD RiskAssessmentCrisisLineComment type_Comment2	NULL																																																																
	END	
	IF COL_LENGTH('CustomInquiries','Medical')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD Medical type_Comment2	NULL																																																																
	END	
	IF COL_LENGTH('CustomInquiries','RiskAssessmentCrisisInformation')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD RiskAssessmentCrisisInformation type_YOrN	NULL
										CHECK (RiskAssessmentCrisisInformation in ('N','Y'))																																																							
	END	
	IF COL_LENGTH('CustomInquiries','ReferalOrganizationName')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD ReferalOrganizationName varchar(100)	NULL																																																																
	END	
	IF COL_LENGTH('CustomInquiries','ReferalPhone')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD ReferalPhone varchar(25)	NULL																																																																
	END	
	IF COL_LENGTH('CustomInquiries','ReferalFirstName')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD ReferalFirstName type_FirstName	NULL																																																																
	END	
	IF COL_LENGTH('CustomInquiries','ReferalLastName')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD ReferalLastName type_LastName	NULL																																																																
	END
	IF COL_LENGTH('CustomInquiries','ReferalAddressLine1')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD ReferalAddressLine1 type_Address	NULL																																																																
	END	
	IF COL_LENGTH('CustomInquiries','ReferalAddressLine2')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD ReferalAddressLine2 type_Address	NULL																																																																
	END	
	IF COL_LENGTH('CustomInquiries','ReferalCity')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD ReferalCity type_City	NULL																																																																
	END
	IF COL_LENGTH('CustomInquiries','ReferalState')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD ReferalState type_state	NULL																																																																
	END	
	IF COL_LENGTH('CustomInquiries','ReferalZip')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD ReferalZip type_ZipCode	NULL																																																																
	END	
	IF COL_LENGTH('CustomInquiries','ReferalEmail')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD ReferalEmail varchar(100)	NULL																																																																
	END	
	IF COL_LENGTH('CustomInquiries','ReferalComments')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD ReferalComments type_Comment2	NULL																																																																
	END	
	IF COL_LENGTH('CustomInquiries','PopulationDDClientSeeking')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD PopulationDDClientSeeking type_YOrN	NULL
										CHECK (PopulationDDClientSeeking in ('N','Y'))																																																															
	END	
	IF COL_LENGTH('CustomInquiries','PopulationAutism')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD PopulationAutism type_YesNoUnknown	NULL
										CHECK (PopulationAutism in ('N','Y','U'))																																																															
	END	
	IF COL_LENGTH('CustomInquiries','PopulationMH')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD PopulationMH type_YesNoUnknown	NULL
										CHECK (PopulationMH in ('N','Y','U'))																																																															
	END	
	IF COL_LENGTH('CustomInquiries','PopulationSUD')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD PopulationSUD type_YesNoUnknown	NULL
										CHECK (PopulationSUD in ('N','Y','U'))																																																															
	END	
	IF COL_LENGTH('CustomInquiries','PopulationAutismClientSeeking')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD PopulationAutismClientSeeking type_YOrN	NULL
										CHECK (PopulationAutismClientSeeking in ('N','Y'))																																																															
	END	
	IF COL_LENGTH('CustomInquiries','PopulationMHClientSeeking')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD PopulationMHClientSeeking type_YOrN	NULL
										CHECK (PopulationMHClientSeeking in ('N','Y'))																																																															
	END	
	IF COL_LENGTH('CustomInquiries','PopulationSUDClientSeeking')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD PopulationSUDClientSeeking type_YOrN	NULL
										CHECK (PopulationSUDClientSeeking in ('N','Y'))																																																															
	END
	IF COL_LENGTH('CustomInquiries','DispositionWaitListInformation')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD DispositionWaitListInformation varchar(max)	NULL																																																																
	END
	
	IF COL_LENGTH('CustomInquiries','IncomeGeneralHeadHousehold')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD IncomeGeneralHeadHousehold type_YOrN	NULL
										CHECK (IncomeGeneralHeadHousehold in ('N','Y'))																																																																	
	END	
	IF COL_LENGTH('CustomInquiries','IncomeGeneralHouseholdComposition')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD IncomeGeneralHouseholdComposition varchar(100)	NULL																																																																										
	END	
	IF COL_LENGTH('CustomInquiries','IncomeGeneralHousehold')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD IncomeGeneralHousehold int	NULL																																																																										
	END	
	IF COL_LENGTH('CustomInquiries','IncomeGeneralAnnualIncome')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD IncomeGeneralAnnualIncome money	NULL																																																																										
	END
	IF COL_LENGTH('CustomInquiries','IncomeGeneralMonthlyIncome')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD IncomeGeneralMonthlyIncome money	NULL																																																																										
	END	
	IF COL_LENGTH('CustomInquiries','IncomeGeneralDependents')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD IncomeGeneralDependents int	NULL																																																																										
	END
	IF COL_LENGTH('CustomInquiries','IncomeGeneralHouseholdAnnualIncome')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD IncomeGeneralHouseholdAnnualIncome money	NULL																																																																										
	END		
	IF COL_LENGTH('CustomInquiries','IncomeGeneralPrimarySource')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD IncomeGeneralPrimarySource varchar(100)	NULL																																																																										
	END
	IF COL_LENGTH('CustomInquiries','IncomeGeneralAlternativeSource')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD IncomeGeneralAlternativeSource varchar(100)	NULL																																																																										
	END	
	IF COL_LENGTH('CustomInquiries','IncomeSpecialFeeCharge')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD IncomeSpecialFeeCharge int	NULL																																																																										
	END	
	IF COL_LENGTH('CustomInquiries','IncomeSpecialFeeBeginDate')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD IncomeSpecialFeeBeginDate datetime	NULL																																																																										
	END
	IF COL_LENGTH('CustomInquiries','IncomeSpecialFeeComment')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD IncomeSpecialFeeComment type_Comment2 NULL																																																																										
	END	
	IF COL_LENGTH('CustomInquiries','IncomeSpecialFeeStartDate')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD IncomeSpecialFeeStartDate datetime	NULL																																																																										
	END
	IF COL_LENGTH('CustomInquiries','IncomeSpecialFeeEndDate')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD IncomeSpecialFeeEndDate datetime	NULL																																																																										
	END	
	IF COL_LENGTH('CustomInquiries','IncomeSpecialFeeIncomeVerified')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD IncomeSpecialFeeIncomeVerified type_YOrN	NULL
										CHECK (IncomeSpecialFeeIncomeVerified in ('N','Y'))																																																																	
	END	
	IF COL_LENGTH('CustomInquiries','IncomeSpecialFeePerSessionFee')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD IncomeSpecialFeePerSessionFee int	NULL																																																																										
	END	
	IF COL_LENGTH('CustomInquiries','OtherDemographicsLegal')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD OtherDemographicsLegal varchar(100)	NULL																																																																										
	END	
	IF COL_LENGTH('CustomInquiries','OtherDemographicsMaritalStatus')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD OtherDemographicsMaritalStatus varchar(100)	NULL																																																																										
	END	
	IF COL_LENGTH('CustomInquiries','PrimarySpokenLanguageOther')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD PrimarySpokenLanguageOther varchar(100)	NULL																																																																										
	END	
	IF COL_LENGTH('CustomInquiries','LimitedEnglishProficiency')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD LimitedEnglishProficiency type_YesNoUnknown	NULL
											CHECK (LimitedEnglishProficiency in ('N','Y','U'))																																																																										
	END	
	IF COL_LENGTH('CustomInquiries','SchoolDistric')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD SchoolDistric varchar(100)	NULL																																																																										
	END	
	IF COL_LENGTH('CustomInquiries','Education')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD Education varchar(100)	NULL																																																																										
	END
	IF COL_LENGTH('CustomInquiries','Homeless')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD Homeless type_YesNoUnknown	NULL
											CHECK (Homeless in ('N','Y','U'))																																																																										
	END
	IF COL_LENGTH('CustomInquiries','EmploymentStatus')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD EmploymentStatus  type_GlobalCode	NULL																																																																																					
	END	
	
	IF COL_LENGTH('CustomInquiries','InitialContact')IS NULL
	BEGIN
		ALTER TABLE CustomInquiries ADD InitialContact type_GlobalCode NULL
	END

	IF COL_LENGTH('CustomInquiries','Facility')IS NULL
	BEGIN
		ALTER TABLE CustomInquiries ADD Facility  type_GlobalCode NULL
	END																
END
/* Add column to CustomClients */
IF COL_LENGTH('CustomClients','Legal')IS NULL
BEGIN
	ALTER TABLE CustomClients ADD Legal type_GlobalCode NULL
END
------ END OF STEP 3 -----

------ STEP 4 ----------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomServiceTypePrograms')
 BEGIN
/* 
 * TABLE: CustomServiceTypePrograms 
 */
CREATE TABLE CustomServiceTypePrograms(
    CustomServiceTypeProgramId	int	identity(1,1)		NOT NULL,
	CreatedBy					type_CurrentUser        NOT NULL,
    CreatedDate					type_CurrentDatetime    NOT NULL,
    ModifiedBy					type_CurrentUser        NOT NULL,
    ModifiedDate				type_CurrentDatetime    NOT NULL,
    RecordDeleted				type_YOrN               NULL
								CHECK (RecordDeleted in ('Y','N')),
    DeletedBy					type_UserId             NULL,
    DeletedDate					datetime                NULL,
	ServiceType					type_GlobalCode			NULL,
	ProgramId					int						NULL,									
	CONSTRAINT CustomServiceTypePrograms_PK PRIMARY KEY CLUSTERED (CustomServiceTypeProgramId)                                
)

IF OBJECT_ID('CustomServiceTypePrograms') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomServiceTypePrograms >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomServiceTypePrograms >>>', 16, 1)
/* 
 * TABLE: CustomServiceTypePrograms 
 */ 
	ALTER TABLE CustomServiceTypePrograms ADD CONSTRAINT Programs_CustomServiceTypePrograms_FK 
	FOREIGN KEY (ProgramId)
	REFERENCES Programs(ProgramId)
	
	PRINT 'STEP 4(A) COMPLETED'
END

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomServiceDispositions')
BEGIN
/* 
 * TABLE: CustomServiceDispositions 
 */
CREATE TABLE CustomServiceDispositions(
    CustomServiceDispositionId          int IDENTITY(1,1)		NOT NULL,
    CreatedBy                           type_CurrentUser        NOT NULL,
    CreatedDate                         type_CurrentDatetime    NOT NULL,
    ModifiedBy                          type_CurrentUser        NOT NULL,
    ModifiedDate                        type_CurrentDatetime    NOT NULL,
    RecordDeleted                       type_YOrN               NULL
                                        CHECK (RecordDeleted in ('Y','N')),   
    DeletedBy                           type_UserId             NULL,
    DeletedDate                         datetime                NULL,                                      
    ServiceType		                    type_GlobalCode         NULL,
    CustomDispositionId		            int                     NULL,      
    CONSTRAINT CustomServiceDispositions_PK PRIMARY KEY CLUSTERED (CustomServiceDispositionId)
)
IF OBJECT_ID('CustomServiceDispositions') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomServiceDispositions >>>'
ELSE
   RAISERROR('<<< FAILED CREATING TABLE CustomServiceDispositions >>>', 16, 1)
/* 
 * TABLE: CustomServiceDispositions 
 */
ALTER TABLE CustomServiceDispositions ADD CONSTRAINT CustomDispositions_CustomServiceDispositions_FK 
FOREIGN KEY (CustomDispositionId)
REFERENCES CustomDispositions(CustomDispositionId)

PRINT 'STEP 4(B) COMPLETED'
END

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomProviderServices')
BEGIN
/* 
 * TABLE: CustomProviderServices 
 */
CREATE TABLE CustomProviderServices(
    CustomProviderServiceId             int IDENTITY(1,1)       NOT NULL,
    CreatedBy                           type_CurrentUser        NOT NULL,
    CreatedDate                         type_CurrentDatetime    NOT NULL,
    ModifiedBy                          type_CurrentUser        NOT NULL,
    ModifiedDate                        type_CurrentDatetime    NOT NULL,
    RecordDeleted                       type_YOrN               NULL
                                        CHECK (RecordDeleted in ('Y','N')),
    DeletedBy                           type_UserId             NULL,
    DeletedDate                         datetime                NULL,
    ProgramId		                    int                     NULL, 
    CustomServiceDispositionId          int                     NULL,    
    CONSTRAINT CustomProviderServices_PK PRIMARY KEY CLUSTERED (CustomProviderServiceId)
)
IF OBJECT_ID('CustomProviderServices') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomProviderServices >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomProviderServices >>>', 16, 1)

/* 
 * TABLE: CustomProviderServices 
 */
ALTER TABLE CustomProviderServices ADD CONSTRAINT CustomServiceDispositions_CustomProviderServices_FK 
FOREIGN KEY (CustomServiceDispositionId)
REFERENCES CustomServiceDispositions(CustomServiceDispositionId)

ALTER TABLE CustomProviderServices ADD CONSTRAINT Programs_CustomProviderServices_FK 
FOREIGN KEY (ProgramId)
REFERENCES Programs(ProgramId)

PRINT 'STEP 4(C) COMPLETED'
END

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomInquiriesCoverageInformations')
BEGIN
/* 
 * TABLE: CustomInquiriesCoverageInformations 
 */
 CREATE TABLE CustomInquiriesCoverageInformations( 
		InquiriesCoverageInformationId		int identity(1,1)    NOT NULL,
		CreatedBy							type_CurrentUser     NOT NULL,
		CreatedDate							type_CurrentDatetime NOT NULL,
		ModifiedBy							type_CurrentUser     NOT NULL,
		ModifiedDate						type_CurrentDatetime NOT NULL,
		RecordDeleted						type_YOrN			 NULL
											CHECK (RecordDeleted in ('Y','N')),
		DeletedBy							type_UserId          NULL,
		DeletedDate							datetime             NULL,
		InquiryId							int					 NULL,
		CoveragePlanId 						int					 NULL,		
		InsuredId							varchar(25)			 NULL,
		GroupId								varchar(35)		     NULL,		
		Comment								type_Comment2		 NULL,
		NewlyAddedplan						type_YOrN			 NULL
											CHECK (NewlyAddedplan in ('Y','N')),																																																																																																											
	CONSTRAINT CustomInquiriesCoverageInformations_PK PRIMARY KEY CLUSTERED (InquiriesCoverageInformationId) 
 )
 
  IF OBJECT_ID('CustomInquiriesCoverageInformations') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomInquiriesCoverageInformations >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomInquiriesCoverageInformations >>>', 16, 1)
/* 
 * TABLE: CustomInquiriesCoverageInformations 
 */   

    
ALTER TABLE CustomInquiriesCoverageInformations ADD CONSTRAINT CustomInquiries_CustomInquiriesCoverageInformations_FK
    FOREIGN KEY (InquiryId)
    REFERENCES CustomInquiries(InquiryId)
    
ALTER TABLE CustomInquiriesCoverageInformations ADD CONSTRAINT CoveragePlans_CustomInquiriesCoverageInformations_FK
    FOREIGN KEY (CoveragePlanId)
    REFERENCES CoveragePlans(CoveragePlanId)
        
     PRINT 'STEP 4(D) COMPLETED'
 END
  ---------------------------------------------------------------
--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF NOT EXISTS (	SELECT [key]	FROM SystemConfigurationKeys WHERE [key] = 'CDM_InquiryDetails'	)
BEGIN
	INSERT INTO [dbo].[SystemConfigurationKeys] (
		CreatedBy
		,CreateDate
		,ModifiedBy
		,ModifiedDate
		,[Key]
		,Value
		)
	VALUES (
		'SHSDBA'
		,GETDATE()
		,'SHSDBA'
		,GETDATE()
		,'CDM_InquiryDetails'
		,'1.0'
		)

	PRINT 'STEP 7 COMPLETED'
END
GO


