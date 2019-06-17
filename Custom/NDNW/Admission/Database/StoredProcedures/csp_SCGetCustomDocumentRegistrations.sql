IF EXISTS (SELECT * 
           FROM   SYS.objects 
           WHERE  object_id = 
                  Object_id(N'[dbo].[csp_SCGetCustomDocumentRegistrations]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[csp_SCGetCustomDocumentRegistrations] 

GO 

CREATE PROCEDURE [dbo].[csp_SCGetCustomDocumentRegistrations] --54
-- csp_SCGetCustomDocumentRegistrations 54            
(@DocumentVersionId INT) 
AS 
/*********************************************************************/ 
/* Stored Procedure: [csp_SCGetCustomDocumentRegistrations]               */ 
/* Creation Date:  08 Sept 2014                                    */ 
/* Author:  Malathi Shiva                     */ 
/* Purpose: To load data after save */ 
/* Data Modifications:                   */ 
/*  Modified By    Modified Date    Purpose        */ 
/*                                                                   */ 
  /*********************************************************************/ 
  BEGIN TRY 
      DECLARE @LatestDocumentVersionID INT 
      DECLARE @Age VARCHAR(50) 
      DECLARE @LastName VARCHAR(50) 
      DECLARE @FirstName VARCHAR(30) 
      DECLARE @MiddleName VARCHAR(30) 
      DECLARE @SSN VARCHAR(25) 
      DECLARE @Suffix VARCHAR(10) 
      DECLARE @DateOfBirth DATETIME 
      DECLARE @Sex INT 
      DECLARE @MarritalStatus INT 
      DECLARE @PrimaryLanguage INT 
      DECLARE @HispanicOrigin INT 
      DECLARE @County VARCHAR(5) 
      DECLARE @AddressLine1 VARCHAR(150) 
      DECLARE @AddressLine2 VARCHAR(150) 
      DECLARE @City VARCHAR(50) 
      DECLARE @State VARCHAR(2) 
      DECLARE @Zip VARCHAR(25) 
      DECLARE @HomePhone VARCHAR(80) 
      --DECLARE @HomePhone2   
      --DECLARE @WorkPhone   
      --DECLARE @CellPhone   
      --DECLARE @MsgPhone   
      --DECLARE @Race   
      DECLARE @ClientID INT 
      DECLARE @CountyOfTreatment VARCHAR(5) 


      SELECT @ClientID = ClientId 
      FROM   Documents 
      WHERE  InProgressDocumentVersionId = @DocumentVersionId 

      SELECT @LastName = LastName 
             ,@MiddleName = MiddleName 
             ,@FirstName = FirstName 
             ,@SSN = SSN 
             ,@DateOfBirth = DOB 
             ,@Suffix = Suffix 
             ,@Sex = case 
              when Sex = 'M' then  5555
              when Sex = 'F' then   5556
              else   null           
              end             
             ,@MarritalStatus = MaritalStatus 
             ,@PrimaryLanguage = PrimaryLanguage 
             ,@HispanicOrigin = HispanicOrigin 
             ,@County = CountyOfResidence 
             ,@CountyOfTreatment = CountyOfTreatment
      FROM   Clients 
      WHERE  ClientID = @ClientID 
             AND IsNull(RecordDeleted, 'N') = 'N' 

      SELECT @AddressLine1 = CA.[Address] 
             ,@City = CA.City 
             ,@State = CA.[State] 
             ,@Zip = CA.Zip 
      FROM   ClientAddresses CA 
      WHERE  ClientId = @ClientID 
             AND IsNull(RecordDeleted, 'N') = 'N' 

      SELECT @HomePhone = PhoneNumber 
      FROM   ClientPhones 

      SET @LatestDocumentVersionID =(SELECT TOP 1 CurrentDocumentVersionId 
                                     FROM   CustomDocumentRegistrations CDR 
                                            ,Documents Doc 
                                     WHERE 
      CDR.DocumentVersionId = Doc.CurrentDocumentVersionId 
      AND Doc.ClientId = @ClientID 
      AND Doc.Status = 22 
      AND DocumentCodeId = 10500 
      AND IsNull(CDR.RecordDeleted, 'N') = 'N' 
      AND IsNull(Doc.RecordDeleted, 'N') = 'N' 
                                     ORDER  BY Doc.EffectiveDate DESC 
                                               ,Doc.ModifiedDate DESC) 

       EXEC csp_CalculateAge    
            @ClientID, 
            @Age OUT 

      SET @Age='(Age: ' + @Age + ')' 

      DECLARE @MemberRace INT 

      SET @MemberRace = (SELECT TOP 1 CR.RaceId 
                         FROM   ClientRaces CR 
                                INNER JOIN GlobalCodes GC 
                                        ON GC.GlobalCodeId = CR.RaceId 
                         WHERE  CR.ClientId = @ClientID 
                                AND ISNULL(CR.RecordDeleted, 'N') <> 'Y' 
                         ORDER  BY GC.CodeName) 

      SELECT 
      --CustomDocumentRegistrations          
      DocumentVersionId 
      ,CR.CreatedBy 
      ,CR.CreatedDate 
      ,CR.ModifiedBy 
      ,CR.ModifiedDate 
      ,CR.RecordDeleted 
      ,CR.DeletedBy 
      ,CR.DeletedDate 
      ,PrimaryCarePhysician 
      ,PrimaryProgramId 
      ,PrimaryCareCoOrdinatorId 
      ,ResidenceCounty 
      ,FirstName 
      ,LastName 
      ,MiddleName 
      ,Suffix 
      ,Sex 
      ,@Age            AS Age 
      ,DateOfBirth 
      ,SSN 
      ,MaritalStatus 
      ,PrimayMethodOfCommunication 
      ,PrimaryLanguage 
      ,SecondaryLanguage 
      ,OtherPrimaryLanguage 
      ,HispanicOrigin 
      ,InterpreterNeeded 
      ,Race 
      ,MedicaidId 
      ,PatientType 
      ,ClientDeaf 
      ,ClientDevelopmentallyDisabled 
      ,ClientHasVisuallyImpairment 
      ,ClientHasNonAmbulation 
      ,ClientHasSevereMedicalIssues 
      ,CurrentlyHomeless 
      ,Address1 
      ,Address2 
      ,City 
      ,[State] 
      ,ZipCode 
      ,HomePhone 
      ,HomePhone2 
      ,WorkPhone 
      ,CellPhone 
      ,MessagePhone 
      ,Citizenship 
      ,BirthPlace 
      ,EducationalLevel 
      ,EducationStatus 
      ,EmploymentStatus 
      ,Religion 
      ,MilitaryStatus 
      ,JusticeSystemInvolvement 
      ,ForensicTreatment 
      ,SSISSDStatus 
      ,SmokingStatus 
      ,ScreenForMHSUD 
      ,AdvanceDirective 
      ,Organization 
      ,Phone 
      ,PCPEmail 
      ,ClientWithOutPCP 
      ,ClientSeenByOtherProvider 
      ,OtherProviders 
      ,PreviousMentalHealthServices 
      ,PreviousSubstanceAbuseServices 
      ,VBHService 
      ,StateHospitalService 
      ,PsychiatricHospitalService 
      ,GeneralHospitalService 
      ,OutPatientService 
      ,ResidentialService 
      ,SubAbuseOutPatientService 
      ,PreviousTreatmentComments 
      ,HeadOfHousehold 
      ,ResidenceType 
      ,HouseholdComposition 
      ,NumberInHousehold 
      ,DependentsInHousehold 
      ,HouseholdAnnualIncome 
      ,ClientAnnualIncome 
      ,ClientMonthlyIncome 
      ,PrimarySource 
      ,AlternativeSource 
      ,ClientStandardRate 
      ,SpecialFeeBeginDate 
      ,SpecialFeeComment 
      ,SlidingFeeStartDate 
      ,SlidingFeeEndDate 
      ,IncomeVerified 
      ,PerSessionFee 
      ,Financialcomment 
      ,Disposition 
      ,ReferralScreeningDate 
      ,RegistrationDate 
      ,Information 
      ,ReferralDate 
      ,ReferralType 
      ,ReferralSubtype 
      ,ReferralOrganization 
      ,ReferrralPhone 
      ,ReferrralFirstName 
      ,ReferrralLastName 
      ,ReferrralAddress1 
      ,ReferrralAddress2 
      ,ReferrralCity 
      ,ReferrralState 
      ,ReferrralZipCode 
      ,ReferrralEmail 
      ,ReferrralComment 
      ,ProgramStatus 
      ,ProgramRequestedDate 
      ,ProgramEnrolledDate 
      ,NumberOfArrestsLast30Days
	  ,BirthCertificate
	  ,OtherProvidersCurrentlyTreating
	  ,CountyOfTreatment
	  ,SSNUnknown
	  ,LivingArrangments 
	  ,TribalAffiliation
					   ,Medicaid
					   ,CivilCommitment
					   ,IEP
					   ,VocationalRehab
					   ,RegisteredVoter
					   ,NumberOfEmployersLast12Months
					   ,NumberOfArrestPast12Months
					   ,VotingInformation
					   ,SchoolAttendance
					   ,RegisteredSexOffender
					   ,ClientType
					   ,MilitaryService
					   ,Facility
      FROM   [CustomDocumentRegistrations] CR 
      WHERE  ISNull(RecordDeleted, 'N') = 'N' 
             AND [DocumentVersionId] = @DocumentVersionId 

      EXEC csp_GetClientContacts 
        @ClientID 
        
      SELECT CustomRegistrationFormAndAgreementId
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,RecordDeleted
		,DeletedBy
		,DeletedDate
		,DocumentVersionId
		,Form
		,EnglishForm
		,SpanishForm
		,NoForm
		,DeclinedForm
		,NotApplicableForm
	FROM CustomRegistrationFormsAndAgreements
	WHERE ISNull(RecordDeleted, 'N') = 'N'
		AND DocumentVersionId = @DocumentVersionId
	ORDER BY CustomRegistrationFormAndAgreementId ASC
	
 Select RegistrationCoveragePlanId  
  ,CreatedBy         
  ,CreatedDate         
  ,ModifiedBy         
  ,ModifiedDate        
  ,RecordDeleted      
  ,DeletedBy         
  ,DeletedDate         
  ,DocumentVersionId       
  ,CoveragePlanId          
  ,InsuredId         
  ,GroupId          
  ,Comment  
  FROM CustomRegistrationCoveragePlans WHERE DocumentVersionId = @DocumentVersionId AND isNull(RecordDeleted,'N')<>'Y'  
	
  END TRY 

  BEGIN CATCH 
      DECLARE @Error VARCHAR(8000) 

      SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
                  + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) 
                  + '*****' 
                  + isnull(CONVERT(VARCHAR, ERROR_PROCEDURE()), 
                  'csp_SCGetCustomDocumentRegistrations') 
                  + '*****' + CONVERT(VARCHAR, ERROR_LINE()) 
                  + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) 
                  + '*****' + CONVERT(VARCHAR, ERROR_STATE()) 

      RAISERROR ( @Error,-- Message text.                        
                  16,-- Severity.                        
                  1 -- State.                        
      ); 
  END CATCH 

GO 