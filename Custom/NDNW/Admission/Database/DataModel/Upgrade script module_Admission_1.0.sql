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
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentRegistrations')
BEGIN
/*   
 * TABLE: CustomDocumentRegistrations 
 */
 CREATE TABLE CustomDocumentRegistrations( 
		DocumentVersionId					int					 NOT NULL,
		CreatedBy							type_CurrentUser     NOT NULL,
		CreatedDate							type_CurrentDatetime NOT NULL,
		ModifiedBy							type_CurrentUser     NOT NULL,
		ModifiedDate						type_CurrentDatetime NOT NULL,
		RecordDeleted						type_YOrN			 NULL
											CHECK (RecordDeleted in ('Y','N')),
		DeletedBy							type_UserId          NULL,
		DeletedDate							datetime             NULL,
		PrimaryCarePhysician				int					 NULL,
		PrimaryProgramId					int					 NULL,
		PrimaryCareCoOrdinatorId			int					 NULL,
		ResidenceCounty						char(5)				 NULL,	
		FirstName							type_FirstName		 NULL,	
		LastName							type_LastName		 NULL,
		MiddleName							type_MiddleName		 NULL,
		Suffix								varchar(10)			 NULL,
		Sex									type_GlobalCode		 NULL,
		DateOfBirth							datetime			 NULL,
		SSN									char(9)				 NULL,
		MaritalStatus						type_GlobalCode		 NULL,
		PrimayMethodOfCommunication			type_GlobalCode		 NULL,
		PrimaryLanguage						type_GlobalCode		 NULL,
		SecondaryLanguage					type_GlobalCode		 NULL,
		OtherPrimaryLanguage				varchar(20)			 NULL,
		HispanicOrigin						type_GlobalCode		 NULL,
		InterpreterNeeded					type_GlobalCode		 NULL,
		Race								type_GlobalCode		 NULL,
		MedicaidId							int					 NULL,
		PatientType							type_GlobalCode		 NULL,
		ClientDeaf							type_YOrN			 NULL
											CHECK (ClientDeaf in ('Y','N')),
		ClientDevelopmentallyDisabled		type_YOrN			 NULL
											CHECK (ClientDevelopmentallyDisabled in ('Y','N')),
		ClientHasVisuallyImpairment			type_YOrN			 NULL
											CHECK (ClientHasVisuallyImpairment in ('Y','N')),
		ClientHasNonAmbulation				type_YOrN			 NULL
											CHECK (ClientHasNonAmbulation in ('Y','N')),
		ClientHasSevereMedicalIssues		type_YOrN			 NULL
											CHECK (ClientHasSevereMedicalIssues in ('Y','N')),
		CurrentlyHomeless					type_YesNoUnknown	 NULL
											CHECK (CurrentlyHomeless in ('Y','N','U')),
		Address1							type_Address		 NULL,
		Address2							type_Address		 NULL,
		City								type_City			 NULL,
		[State]								type_State			 NULL,
		ZipCode								type_ZipCode		 NULL,		
		HomePhone							type_PhoneNumber	 NULL,
		HomePhone2							type_PhoneNumber	 NULL,
		WorkPhone							type_PhoneNumber	 NULL,
		CellPhone							type_PhoneNumber	 NULL,
		MessagePhone						type_PhoneNumber	 NULL,
		Citizenship							type_GlobalCode		 NULL,
		BirthPlace							varchar(50)			 NULL,
		EducationalLevel					type_GlobalCode		 NULL,
		EducationStatus						type_GlobalCode		 NULL,
		EmploymentStatus					type_GlobalCode		 NULL,
		Religion							type_GlobalCode		 NULL,
		MilitaryStatus						type_GlobalCode		 NULL,
		JusticeSystemInvolvement			type_GlobalCode		 NULL,
		ForensicTreatment					type_GlobalCode		 NULL,
		SSISSDStatus						type_GlobalCode		 NULL,
		SmokingStatus						type_GlobalCode		 NULL,
		ScreenForMHSUD						type_GlobalCode		 NULL,
		AdvanceDirective					type_GlobalCode		 NULL,		
		Organization						varchar(50)			 NULL,
		Phone								type_PhoneNumber	 NULL,
		PCPEmail							varchar(100)		 NULL,
		ClientWithOutPCP					type_YOrN			 NULL
											CHECK (ClientWithOutPCP in ('Y','N')),
		ClientSeenByOtherProvider			type_YOrN			 NULL
											CHECK (ClientSeenByOtherProvider in ('Y','N')),
		OtherProviders						type_Comment2		 NULL,
		PreviousMentalHealthServices		type_YOrN			 NULL
											CHECK (PreviousMentalHealthServices in ('Y','N')),
		PreviousSubstanceAbuseServices		type_YesNoUnknown	  NULL
											CHECK (PreviousSubstanceAbuseServices in ('Y','N','U')),
		VBHService							type_YOrN			 NULL
											CHECK (VBHService in ('Y','N')),
		StateHospitalService				type_YOrN			 NULL
											CHECK (StateHospitalService in ('Y','N')),
		PsychiatricHospitalService			type_YOrN			 NULL
											CHECK (PsychiatricHospitalService in ('Y','N')),
		GeneralHospitalService				type_YOrN			 NULL
											CHECK (GeneralHospitalService in ('Y','N')),
		OutPatientService					type_YOrN			 NULL
											CHECK (OutPatientService in ('Y','N')),
		ResidentialService					type_YOrN			 NULL
											CHECK (ResidentialService in ('Y','N')),
		SubAbuseOutPatientService			type_YOrN			 NULL
											CHECK (SubAbuseOutPatientService in ('Y','N')),
		PreviousTreatmentComments			type_Comment2		 NULL,
		HeadOfHousehold						type_YOrN			 NULL
											CHECK (HeadOfHousehold in ('Y','N')),
		ResidenceType						type_GlobalCode		 NULL,
		HouseholdComposition				type_GlobalCode		 NULL,
		NumberInHousehold					int				     NULL,
		DependentsInHousehold				int					 NULL,
		HouseholdAnnualIncome				money				 NULL,
		ClientAnnualIncome					money				 NULL,
		ClientMonthlyIncome					money				 NULL, 
		PrimarySource						type_GlobalCode		 NULL,
		AlternativeSource					type_GlobalCode		 NULL,
		ClientStandardRate					decimal(18,2)		 NULL,
		SpecialFeeBeginDate					datetime			 NULL,
		SpecialFeeComment					type_Comment2		 NULL,
		SlidingFeeStartDate					datetime			 NULL,
		SlidingFeeEndDate					datetime			 NULL,
		IncomeVerified						type_YOrN			 NULL
											CHECK (IncomeVerified in ('Y','N')),
		PerSessionFee						money				 NULL,
		Financialcomment					type_Comment2		 NULL,
		Disposition							type_GlobalCode      NULL,
		ReferralScreeningDate				datetime			 NULL,	
		RegistrationDate					datetime			 NULL,	
		Information							type_Comment2		 NULL,
		ReferralDate						datetime			 NULL,
		ReferralType						type_GlobalCode		 NULL,
		ReferralSubtype						type_GlobalSubcode	 NULL,
		ReferralOrganization				varchar(100)		 NULL,
		ReferrralPhone					    type_PhoneNumber	 NULL,
		ReferrralFirstName					type_FirstName		 NULL,
		ReferrralLastName					type_LastName		 NULL,
		ReferrralAddress1					type_Address		 NULL,	
		ReferrralAddress2					type_Address		 NULL,
		ReferrralCity						type_City			 NULL,
		ReferrralState						type_State			 NULL,
		ReferrralZipCode					type_ZipCode		 NULL,	
		ReferrralEmail						varchar(100)		 NULL,
		ReferrralComment					type_Comment2		 NULL,		
		ProgramStatus						type_GlobalCode		 NULL,	
		ProgramRequestedDate				datetime			 NULL,
		ProgramEnrolledDate					datetime			 NULL,
		NumberOfArrestsLast30Days			int					 NULL,
		BirthCertificate					type_YOrN			 NULL
											CHECK (BirthCertificate in ('Y','N')),	
		OtherProvidersCurrentlyTreating		type_Comment2		 NULL,
		SSNUnknown							type_YOrN			 NULL
											CHECK (SSNUnknown in ('Y','N')),
		CountyOfTreatment					type_County			 NULL,
		LivingArrangments					type_GlobalCode		 NULL,
		TribalAffiliation					type_GlobalCode		 NULL,
		Medicaid							type_YOrN			 NULL
											CHECK (Medicaid in ('Y','N')),
		CivilCommitment						type_YOrN			 NULL
											CHECK (CivilCommitment in ('Y','N')),
		IEP									type_YOrN			 NULL
											CHECK (IEP in ('Y','N')),
		VocationalRehab						type_YOrN			 NULL
											CHECK (VocationalRehab in ('Y','N')),
		RegisteredVoter						type_YOrN			 NULL
											CHECK (RegisteredVoter in ('Y','N')),
		NumberOfEmployersLast12Months		int					 NULL,
		NumberOfArrestPast12Months			int					 NULL,
		VotingInformation					type_Comment2		 NULL,
		SchoolAttendance					type_GlobalCode		 NULL,
		RegisteredSexOffender				type_GlobalCode		 NULL,
		ClientType							type_GlobalCode		 NULL,
		MilitaryService						type_GlobalCode		 NULL,
		Facility							type_GlobalCode		 NULL,		
		CONSTRAINT CustomDocumentRegistrations_PK PRIMARY KEY CLUSTERED (DocumentVersionId) 
 )
 
  IF OBJECT_ID('CustomDocumentRegistrations') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentRegistrations >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentRegistrations >>>', 16, 1)
/* 
 * TABLE: CustomDocumentRegistrations 
 */   

    
ALTER TABLE CustomDocumentRegistrations ADD CONSTRAINT DocumentVersions_CustomDocumentRegistrations_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)

    
ALTER TABLE CustomDocumentRegistrations ADD CONSTRAINT Programs_CustomDocumentRegistrations_FK
    FOREIGN KEY (PrimaryProgramId)
    REFERENCES Programs(ProgramId)
    
ALTER TABLE CustomDocumentRegistrations ADD CONSTRAINT ExternalReferralProviders_CustomDocumentRegistrations_FK
    FOREIGN KEY (PrimaryCarePhysician)
    REFERENCES ExternalReferralProviders(ExternalReferralProviderId)
        
ALTER TABLE CustomDocumentRegistrations ADD CONSTRAINT Staff_CustomDocumentRegistrations_FK
    FOREIGN KEY (PrimaryCareCoOrdinatorId)
    REFERENCES Staff(StaffId)
 
 ALTER TABLE CustomDocumentRegistrations ADD CONSTRAINT Counties_CustomDocumentRegistrations_FK
    FOREIGN KEY (ResidenceCounty)
    REFERENCES Counties(CountyFIPS)   
        
     PRINT 'STEP 4(A) COMPLETED'
 END

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomRegistrationFormsAndAgreements')
BEGIN
/*   
 * TABLE: CustomRegistrationFormsAndAgreements 
 */
 CREATE TABLE CustomRegistrationFormsAndAgreements( 
		CustomRegistrationFormAndAgreementId	int identity(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		DocumentVersionId						int					 NULL,
        Form									type_GlobalCode		 NULL,
        EnglishForm								type_YOrN			 NULL
												CHECK (EnglishForm in ('Y','N')),
        SpanishForm								type_YOrN			 NULL
												CHECK (SpanishForm in ('Y','N')),
        NoForm									type_YOrN			 NULL
												CHECK (NoForm in ('Y','N')),
        DeclinedForm							type_YOrN			 NULL
												CHECK (DeclinedForm in ('Y','N')),
        NotApplicableForm						type_YOrN			 NULL
												CHECK (NotApplicableForm in ('Y','N')),																																																																																																					
		CONSTRAINT CustomRegistrationFormsAndAgreements_PK PRIMARY KEY CLUSTERED (CustomRegistrationFormAndAgreementId) 
 )
 
  IF OBJECT_ID('CustomRegistrationFormsAndAgreements') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomRegistrationFormsAndAgreements >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomRegistrationFormsAndAgreements >>>', 16, 1)
/* 
 * TABLE: CustomRegistrationFormsAndAgreements 
 */   

    
ALTER TABLE CustomRegistrationFormsAndAgreements ADD CONSTRAINT DocumentVersions_CustomRegistrationFormsAndAgreements_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)  
        
     PRINT 'STEP 4(B) COMPLETED'
 END

 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomRegistrationCoveragePlans')
BEGIN
/*    
 * TABLE: CustomRegistrationCoveragePlans 
 */
 CREATE TABLE CustomRegistrationCoveragePlans( 
		RegistrationCoveragePlanId				int identity(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		DocumentVersionId						int					 NULL,
        CoveragePlanId							int					 NULL,
        InsuredId								varchar(25)   		 NULL,
        GroupId									varchar(35)			 NULL,
        Comment									type_Comment2		 NULL,																																																																																																			
		CONSTRAINT CustomRegistrationCoveragePlans_PK PRIMARY KEY CLUSTERED (RegistrationCoveragePlanId) 
 )
 
  IF OBJECT_ID('CustomRegistrationCoveragePlans') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomRegistrationCoveragePlans >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomRegistrationCoveragePlans >>>', 16, 1)
/* 
 * TABLE: CustomRegistrationCoveragePlans 
 */   

    
ALTER TABLE CustomRegistrationCoveragePlans ADD CONSTRAINT DocumentVersions_CustomRegistrationCoveragePlans_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)  
 
 ALTER TABLE CustomRegistrationCoveragePlans ADD CONSTRAINT CoveragePlans_CustomRegistrationCoveragePlans_FK
    FOREIGN KEY (CoveragePlanId)
    REFERENCES CoveragePlans(CoveragePlanId) 
                           
     PRINT 'STEP 4(C) COMPLETED'
 END
 
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentValidationExceptions')
 BEGIN
/*  
 * TABLE: CustomDocumentValidationExceptions 
 */

CREATE TABLE CustomDocumentValidationExceptions(
    DocumentVersionId				int				NULL,
    AuthorId						int             NOT NULL,
    ClientId					    int             NULL,
    DocumentCodeId                  int             NULL,
   	EffectiveDate					Datetime		NULL,
   	ValidToDate						Datetime		NOT NULL,
	Comment							varchar(1000)	NULL,
	DocumentValidationId			int				NULL,
)

 IF OBJECT_ID('CustomDocumentValidationExceptions') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentValidationExceptions >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentValidationExceptions >>>', 16, 1)
/* 
 * TABLE: CustomDocumentValidationExceptions 
 */   
    
ALTER TABLE CustomDocumentValidationExceptions ADD CONSTRAINT DocumentValidations_CustomDocumentValidationExceptions_FK 
    FOREIGN KEY (DocumentValidationId)
    REFERENCES DocumentValidations(DocumentValidationId)
    
    PRINT 'STEP 4(D) COMPLETED'

END

 ---------------------------------------------------------------
--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------


If not exists (select [key] from SystemConfigurationKeys where [key] = 'CDM_Admission')
	begin
		INSERT INTO [dbo].[SystemConfigurationKeys]
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
				   ,'CDM_Admission'
				   ,'1.0'
				   )
	End

 PRINT 'STEP 7 COMPLETED'
 GO
