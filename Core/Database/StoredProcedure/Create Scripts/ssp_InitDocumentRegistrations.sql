  /****** Object:  StoredProcedure [dbo].[ssp_InitDocumentRegistrations]    Script Date: 12/Jan/2018 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_InitDocumentRegistrations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_InitDocumentRegistrations]
GO

/****** Object:  StoredProcedure [dbo].[ssp_InitDocumentRegistrations]    Script Date: 12/Jan/2018 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO  
    
 CREATE Procedure [dbo].[ssp_InitDocumentRegistrations]   
 @ClientID INT,                                              
 @StaffID INT,                                            
 @CustomParameters XML                
AS                
 /*********************************************************************/                                                                                                      
 /* Stored Procedure: ssp_InitDocumentRegistrations  3,550,null				 */                                                                                             
 /* Creation Date:  12/Jan/2018												*/                                                                                                      
 /* Purpose: To Initialized The Release Of Information						 */                
 /* Input Parameters: @ClientID , @StaffID , @CustomParameters					*/                                                                                                    
 /* Output Parameters:              */                                                                                                      
 /* Return:                 */                                                                                                      
 /* Called By:Initialization of Screen          */                                                                                            
 /* Calls:                                                            */                                                                                                      
 /*                                                                   */                                                                                                      
 /* Data Modifications:                                               */                                                                                                      
 /* Updates:                                                          */    
 /*  Date           Author             Purpose            */ 
/* 12/Jan/2018    Alok Kumar          Created. Ref: Task#618 Engineering Improvement Initiatives- NBL(I)  */                                                                                                                  
 /*********************************************************************/                   
                  
Begin												
Begin TRY           

	DECLARE @LatestDocumentVersionID INT              
	SET @LatestDocumentVersionID =(SELECT TOP 1 CurrentDocumentVersionId                                    
	FROM Documents a 
	INNER JOIN DocumentCodes Dc ON Dc.DocumentCodeid = a.DocumentCodeid                                                       
	WHERE a.ClientId = @ClientID                                                       
	and a.EffectiveDate <= convert(DATETIME, convert(VARCHAR, getDate(),101))                                                        
	and a.Status = 22                                                                            
	and isNull(a.RecordDeleted,'N')='N'                                                                                           
	ORDER BY a.EffectiveDate DESC,a.ModifiedDate DESC )
	  
	DECLARE @UserCode VARCHAR(100);
	SELECT @UserCode = UserCode
	FROM Staff
	WHERE StaffId = @StaffID

	
	Declare @ClientType Char(1),
			@ShortSSN varchar(10),
			@SSN varchar(25),
			@PrimaryClinicianId Int,
			@PrimaryPhysicianId Int,
			@Prefix varchar(10),
			@FirstName varchar(50),
			@MiddleName varchar(30),
			@LastName varchar(50),
			@Suffix varchar(10),
			@Email varchar(50),
			--@InsuredId Int,
			@Active Char(1),
			@ProfessionalSuffix varchar(10),
			@ShortEIN varchar(10),
			@EIN varchar(25),
			@OrganizationName varchar(100),
			@DOB datetime,
			@Comment varchar(Max),
			
			--@DOB
			@Age	varchar(20),
			@Sex	Char(1),
			@MaritalStatus Int,
			@GenderIdentity Int,
			@SexualOrientation Int,
			@DeceasedOn datetime,
			@CauseofDeath Int,
			@ExternalReferralProviderId Int,
			@ClientDoesNotHavePCP Char(1),
			--@PCPOrganizationName
			--@PCPPhone
			--@PCPEmail
			@FinanciallyResponsible Char(1),
			@AnnualHouseholdIncome Money,
			@NumberOfDependents Int,
			@LivingArrangement Int,
			@CountyOfResidence Varchar(5),
			@CountyOfResidenceText Varchar(100),
			@CountyOfTreatment Varchar(5),
			@CountyOfTreatmentText Varchar(100),
			@EducationalStatus Int,
			@MilitaryStatus Int,
			@EmploymentStatus Int,
			@EmploymentInformation Varchar(100),
			@PrimaryLanguage Int,
			@DoesNotSpeakEnglish Char(1),
			@HispanicOrigin Int,
			@ReminderPreference Int,
			@MobilePhoneProvider Int,
			@SchedulingPreferenceMonday Char(1),
			@SchedulingPreferenceTuesday Char(1),
			@SchedulingPreferenceWednesday Char(1),
			@SchedulingPreferenceThursday Char(1),
			@SchedulingPreferenceFriday Char(1),
			@GeographicLocation  Varchar(50),
			@SchedulingComment Varchar(Max),
			@PreferredGenderPronoun Int

			
			
			SELECT @ClientType = ClientType
				,@ShortSSN = SUBSTRING(SSN, 6, 9) 
				,@SSN = SSN
				,@PrimaryClinicianId = PrimaryClinicianId
				,@PrimaryPhysicianId = PrimaryPhysicianId
				,@Prefix = Prefix
				,@FirstName = FirstName
				,@MiddleName = MiddleName
				,@LastName = LastName
				,@Suffix = Suffix
				,@Email = Email
				--,@InsuredId = InsuredId
				,@Active = Active
				,@ProfessionalSuffix = ProfessionalSuffix
				,@ShortEIN = SUBSTRING(EIN, 6, 9)
				,@EIN = EIN
				,@OrganizationName = OrganizationName
				,@DOB = DOB
				,@Comment = Comment
				,@Age = CONVERT(Varchar(5), DATEDIFF(YEAR, C.DOB, GETDATE()) - 1) + ' Years'
				,@Sex = Sex
				,@MaritalStatus = MaritalStatus
				,@GenderIdentity = GenderIdentity
				,@SexualOrientation = SexualOrientation
				,@DeceasedOn = DeceasedOn
				,@CauseofDeath = CauseofDeath
				,@ExternalReferralProviderId = ExternalReferralProviderId
				,@ClientDoesNotHavePCP = ClientDoesNotHavePCP
				--@PCPOrganizationName
				--@PCPPhone
				--@PCPEmail
				,@FinanciallyResponsible = FinanciallyResponsible
				,@AnnualHouseholdIncome = AnnualHouseholdIncome
				,@NumberOfDependents = NumberOfDependents
				,@LivingArrangement = LivingArrangement
				,@CountyOfResidence = CountyOfResidence
				,@CountyOfResidenceText = Ltrim(Rtrim(Ct.CountyName)) + ' - ' + St.StateAbbreviation
				,@CountyOfTreatment = CountyOfTreatment
				,@CountyOfTreatmentText = Ltrim(Rtrim(CF.CountyName)) + ' - ' + Ss.StateAbbreviation
				,@EducationalStatus = EducationalStatus
				,@MilitaryStatus = MilitaryStatus
				,@EmploymentStatus = EmploymentStatus
				,@EmploymentInformation = EmploymentInformation
				,@PrimaryLanguage = PrimaryLanguage
				,@DoesNotSpeakEnglish = DoesNotSpeakEnglish
				,@HispanicOrigin = HispanicOrigin
				,@ReminderPreference = ReminderPreference
				,@MobilePhoneProvider = MobilePhoneProvider
				,@SchedulingPreferenceMonday = SchedulingPreferenceMonday
				,@SchedulingPreferenceTuesday = SchedulingPreferenceTuesday
				,@SchedulingPreferenceWednesday = SchedulingPreferenceWednesday
				,@SchedulingPreferenceThursday = SchedulingPreferenceThursday
				,@SchedulingPreferenceFriday = SchedulingPreferenceFriday
				,@GeographicLocation = GeographicLocation
				,@SchedulingComment = SchedulingComment
				,@PreferredGenderPronoun = PreferredGenderPronoun
			FROM Clients  C    
			left join Counties Ct on Ct.CountyFIPS = C.CountyOfResidence   
			left join Counties CF on CF.CountyFIPS = C.CountyOfTreatment    
			left join States St on St.StateFIPs = Ct.StateFIPs  
			left join States Ss on Ss.StateFIPs = CF.StateFIPs 
			WHERE C.ClientId = @ClientID


		--ClientCoveragePlans 
		DECLARE @InsuredId varchar(25)
		SET @InsuredId = ( Select top (1) a.InsuredId  
							from    ClientCoveragePlans as a    
							inner join CoveragePlans as b on b.CoveragePlanId = a.CoveragePlanId    
							inner join ClientCoverageHistory as c on a.ClientCoveragePlanId = c.ClientCoveragePlanId    
							where   a.ClientId = @ClientId    
									and b.MedicaidPlan = 'Y'    
									and ISNULL(a.RecordDeleted, 'N') <> 'Y'    
									and ISNULL(b.RecordDeleted, 'N') <> 'Y'    
									and ISNULL(c.RecordDeleted, 'N') <> 'Y'    
									and DATEDIFF(DAY, c.StartDate, GETDATE()) >= 0    
									and (    
										 (c.EndDate is null)    
									or (DATEDIFF(DAY, c.EndDate, GETDATE()) <= 0)    
										)    
							order by c.COBOrder     )


 	--DocumentRegistrations                  
	SELECT
		'DocumentRegistrations' AS TableName
		,-1 AS 'DocumentVersionId'
		,@UserCode AS [CreatedBy]
		,GETDATE() AS [CreatedDate]
		,@UserCode AS [ModifiedBy]
		,GETDATE() AS [ModifiedDate]
		,@ClientID AS ClientId
		,Case When Isnull(@ClientType,'') = '' then 'I'
			Else @ClientType END AS ClientType
		--,@ClientType AS ClientType
		,@ShortSSN AS ShortSSN 
		,@SSN AS SSN
		,@PrimaryClinicianId AS PrimaryClinicianId
		,@PrimaryPhysicianId AS PrimaryPhysicianId
		,@Prefix AS Prefix
		,@FirstName AS FirstName
		,@MiddleName AS MiddleName
		,@LastName AS LastName
		,@Suffix AS Suffix
		,@Email AS Email
		,@InsuredId AS InsuredId
		,@Active AS Active
		,@ProfessionalSuffix AS ProfessionalSuffix
		,@ShortEIN AS ShortEIN
		,@EIN AS EIN
		,@OrganizationName AS OrganizationName
		,@DOB AS DOB
		,@Comment AS Comment
	FROM systemconfigurations SC
	LEFT JOIN DocumentRegistrations DROI ON SC.DatabaseVersion = -1   
	left join Clients C on C.ClientId = @ClientID              
	   
	  

	  
   	--DocumentRegistrationDemographics                  
	SELECT
		'DocumentRegistrationDemographics' AS TableName
		,-1 AS 'DocumentVersionId'
		,@UserCode AS [CreatedBy]
		,GETDATE() AS [CreatedDate]
		,@UserCode AS [ModifiedBy]
		,GETDATE() AS [ModifiedDate]
		,@DOB AS DOB   
		,@Age AS Age
		,@Sex AS Sex
		,@MaritalStatus AS MaritalStatus
		,@GenderIdentity AS GenderIdentity
		,@SexualOrientation AS SexualOrientation
		,@DeceasedOn AS DeceasedOn
		,@CauseofDeath AS CauseofDeath
		,@ExternalReferralProviderId AS ExternalReferralProviderId
		,@ClientDoesNotHavePCP AS ClientDoesNotHavePCP
		--@PCPOrganizationName
		--@PCPPhone
		--@PCPEmail
		,@FinanciallyResponsible AS FinanciallyResponsible
		,@AnnualHouseholdIncome AS AnnualHouseholdIncome
		,@NumberOfDependents AS NumberOfDependents
		,@LivingArrangement AS LivingArrangement
		,@CountyOfResidence AS CountyOfResidence
		,@CountyOfResidenceText AS CountyOfResidenceText
		,@CountyOfTreatment AS CountyOfTreatment
		,@CountyOfTreatmentText AS CountyOfTreatmentText
		,@EducationalStatus AS EducationalStatus
		,@MilitaryStatus AS MilitaryStatus
		,@EmploymentStatus AS EmploymentStatus
		,@EmploymentInformation AS EmploymentInformation
		,@PrimaryLanguage AS PrimaryLanguage
		,@DoesNotSpeakEnglish AS DoesNotSpeakEnglish
		,@HispanicOrigin AS HispanicOrigin
		,@ReminderPreference AS ReminderPreference
		,@MobilePhoneProvider AS MobilePhoneProvider
		,@SchedulingPreferenceMonday AS SchedulingPreferenceMonday
		,@SchedulingPreferenceTuesday AS SchedulingPreferenceTuesday
		,@SchedulingPreferenceWednesday AS SchedulingPreferenceWednesday
		,@SchedulingPreferenceThursday AS SchedulingPreferenceThursday
		,@SchedulingPreferenceFriday AS SchedulingPreferenceFriday
		,@GeographicLocation AS GeographicLocation
		,@SchedulingComment AS SchedulingComment
		,@PreferredGenderPronoun AS PreferredGenderPronoun
	FROM systemconfigurations SC
	LEFT JOIN DocumentRegistrationDemographics DROI
	  ON SC.DatabaseVersion = -1
	  

	  
   	--DocumentRegistrationAdditionalInformations    
   	If ISNULL(@LatestDocumentVersionID ,-1) > -1
   	BEGIN
		Select TOP 1 'DocumentRegistrationAdditionalInformations' AS TableName,
		DROI.DocumentVersionId ,  
		[CreatedBy],
		[CreatedDate],
		[ModifiedBy],
		[ModifiedDate],
		[RecordDeleted],
		[DeletedBy],
		[DeletedDate],
		[Citizenship],
		[EmploymentStatus],
		[BirthPlace],
		[BirthCertificate],
		[MilitaryStatus],
		[EducationalLevel],
		[JusticeSystemInvolvement],
		[EducationStatus],
		[NumberOfArrestsLast30Days],
		[Religion],
		[SmokingStatus],
		[ForensicTreatment],
		[CriminogenicRiskLevel],
		[ScreenForMHSUD],[AdvanceDirective],[LivingArrangments],[SSISSDStatus]
		FROM [DocumentRegistrationAdditionalInformations] DROI                                                                              
		  where DROI.DocumentVersionId=@LatestDocumentVersionID
	 END
	 ELSE
	 BEGIN                      
		SELECT
		  'DocumentRegistrationAdditionalInformations' AS TableName,
		  -1 AS 'DocumentVersionId',
		  @UserCode AS [CreatedBy],
		  GETDATE() AS [CreatedDate],
		  @UserCode AS [ModifiedBy],
		  GETDATE() AS [ModifiedDate]
		FROM systemconfigurations SC
		LEFT JOIN DocumentRegistrationAdditionalInformations DROI
		  ON SC.DatabaseVersion = -1
	 END 

	 --Episode Tab
	 DECLARE @ReferralDate datetime
			,@ReferralType	int
			,@ReferralSubtype int
			,@ReferralOrganization varchar(100)
			,@ReferrralPhone varchar(50)
			,@ReferrralFirstName varchar(20)
			,@ReferrralLastName varchar(30)
			,@ReferrralAddress1 varchar(100)
			,@ReferrralAddress2 varchar(100)
			,@ReferrralCity varchar(30)
			,@ReferrralState char(2)
			,@ReferrralZipCode varchar(12)
			,@ReferrralEmail varchar(100)
			,@ReferrralComment varchar(Max)
			,@ReferralScreeningDate datetime

		SELECT Top 1 @ReferralDate = IQ.ReferralDate
			,@ReferralType = IQ.ReferralType
			,@ReferralSubtype = IQ.ReferralSubtype
			,@ReferralOrganization = IQ.ReferalOrganizationName 
			,@ReferrralPhone = IQ.ReferalPhone
			,@ReferrralFirstName = IQ.ReferalFirstName
			,@ReferrralLastName = IQ.ReferalLastName
			,@ReferrralAddress1 = IQ.ReferalAddressLine1
			,@ReferrralAddress2 = IQ.ReferalAddressLine2
			,@ReferrralCity = IQ.ReferalCity
			,@ReferrralState = IQ.ReferalState
			,@ReferrralZipCode = IQ.ReferalZip
			,@ReferrralEmail = IQ.ReferalEmail
			,@ReferrralComment = IQ.ReferalComments
			,@ReferralScreeningDate = GetDate()
		FROM Inquiries IQ Where IQ.ClientId = @ClientID
		AND InquiryStatus = (Select Top 1 GlobalCodeId From GlobalCodes Where Category = 'INQUIRYSTATUS' AND Code = 'COMPLETE')
		ORDER by IQ.InquiryStartDateTime DESC
	
   	--DocumentRegistrationEpisodes                  
	SELECT
	  'DocumentRegistrationEpisodes' AS TableName,
	  -1 AS 'DocumentVersionId',
	  @UserCode AS [CreatedBy],
	  GETDATE() AS [CreatedDate],	  
	  @UserCode AS [ModifiedBy],
	  GETDATE() AS [ModifiedDate]
		,@ReferralDate AS ReferralDate
		,@ReferralType AS ReferralType
		,@ReferralSubtype AS ReferralSubtype
		,@ReferralOrganization AS ReferralOrganization  
		  ,@ReferrralPhone AS ReferrralPhone  
		  ,@ReferrralFirstName AS ReferrralFirstName  
		  ,@ReferrralLastName AS ReferrralLastName  
		  ,@ReferrralAddress1 AS ReferrralAddress1  
		  ,@ReferrralAddress2 AS ReferrralAddress2  
		  ,@ReferrralCity AS ReferrralCity  
		  ,@ReferrralState AS ReferrralState  
		  ,@ReferrralZipCode AS ReferrralZipCode  
		  ,@ReferrralEmail AS ReferrralEmail  
		  ,@ReferrralComment AS ReferrralComment  
	FROM systemconfigurations SC
	LEFT JOIN DocumentRegistrationEpisodes DROI
	  ON SC.DatabaseVersion = -1
	  
	  
	  
   	--DocumentRegistrationProgramEnrollments                  
	SELECT
	  'DocumentRegistrationProgramEnrollments' AS TableName,
	  -1 AS 'DocumentVersionId',
	  @UserCode AS [CreatedBy],
	  GETDATE() AS [CreatedDate],
	  @UserCode AS [ModifiedBy],
	  GETDATE() AS [ModifiedDate]
	FROM systemconfigurations SC
	LEFT JOIN DocumentRegistrationProgramEnrollments DROI
	  ON SC.DatabaseVersion = -1
	  
	  
	  
	--DocumentRegistrationDemographicDeclines
	SELECT
	  'DocumentRegistrationDemographicDeclines' AS TableName,
	  --ClientDemographicInformationDeclineId as RegistrationDemographicDeclineId,
	  CreatedBy,
	  CreatedDate,
	  ModifiedBy,
	  ModifiedDate,
	  RecordDeleted,
	  DeletedBy,
	  DeletedDate,
	  ClientId,
	  ClientDemographicsId as ClientDeclinedToProvide
	FROM ClientDemographicInformationDeclines
	WHERE (ClientId = @ClientID)
	AND (RecordDeleted IS NULL
	OR RecordDeleted = 'N')



	--DocumentRegistrationClientEthnicities
	SELECT
	  'DocumentRegistrationClientEthnicities' AS TableName,
	  --[ClientEthnicityId],
	  [CreatedBy],
	  [CreatedDate],
	  [ModifiedBy],
	  [ModifiedDate],
	  [RecordDeleted],
	  [DeletedDate],
	  [DeletedBy],
	  [ClientId],
	  [EthnicityId]
	FROM [dbo].[ClientEthnicities]
	WHERE (ClientId = @ClientID)
	AND ISNULL(RecordDeleted, 'N') = 'N'
	
	
	
	--DocumentRegistrationClientRaces
	SELECT
	  'DocumentRegistrationClientRaces' AS TableName,
	  --ClientRaceId,
	  ClientId,
	  RaceId,
	  RowIdentifier,
	  CreatedBy,
	  CreatedDate,
	  ModifiedBy,
	  ModifiedDate,
	  RecordDeleted,
	  DeletedDate,
	  DeletedBy
	FROM ClientRaces
	WHERE (ClientId = @ClientID)
	AND (RecordDeleted IS NULL
	OR RecordDeleted = 'N')
	
	
	
	----DocumentRegistrationClientPictures
	----EXEC SSP_GetClientPicture @ClientId, 'N'
	Declare @GetPicture CHAR(1)
	Set @GetPicture = 'N'
	
	SELECT 
	'DocumentRegistrationClientPictures' AS TableName
	--,CP.[ClientPictureId]  
   ,CP.[CreatedBy]  
   ,CP.[CreatedDate]  
   ,CP.[ModifiedBy]  
   ,CP.[ModifiedDate]  
   ,CP.[RecordDeleted]  
   ,CP.[DeletedBy]  
   ,CP.[DeletedDate]  
   ,CP.[ClientId]  
   ,CP.[UploadedOn]  
   ,CP.[UploadedBy]  
   ,CP.[PictureFileName]  
   ,CASE @GetPicture  
    WHEN 'Y'  
     THEN CP.[Picture]  
    ELSE NULL  
    END AS Picture  
   ,CP.[Active]  
   ,CONVERT(VARCHAR(10), CP.[UploadedOn], 101) AS UploadedOnText  
   ,(S.LastName  + ', ' + S.FirstName ) AS UploadedByText  
  FROM ClientPictures CP  
  INNER JOIN Staff S ON S.StaffId = CP.UploadedBy  
  WHERE ClientId = @ClientId  
   AND CP.Active = 'Y'  
   AND ISNULL(CP.RecordDeleted, 'N') = 'N'  
	
	
	--DocumentRegistrationClientPhones
	SELECT
	  'DocumentRegistrationClientPhones' AS TableName,
	  --ClientPhones.ClientPhoneId,
	  ClientPhones.ClientId,
	  ClientPhones.PhoneType,
	  ClientPhones.PhoneNumber,
	  ClientPhones.PhoneNumberText,
	  ClientPhones.IsPrimary,
	  ClientPhones.DoNotContact,
	  ClientPhones.RowIdentifier,
	  ClientPhones.ExternalReferenceId,
	  ClientPhones.CreatedBy,
	  ClientPhones.CreatedDate,
	  ClientPhones.ModifiedBy,
	  ClientPhones.ModifiedDate,
	  ClientPhones.RecordDeleted,
	  ClientPhones.DeletedDate,
	  ClientPhones.DeletedBy,
	  GlobalCodes.SortOrder,
	  ClientPhones.DoNotLeaveMessage                                            
	FROM ClientPhones
	INNER JOIN GlobalCodes
	  ON ClientPhones.PhoneType = GlobalCodes.GlobalCodeId
	WHERE (ClientPhones.ClientId = @ClientID)
	AND (ISNULL(ClientPhones.RecordDeleted, 'N') = 'N')
	AND (GlobalCodes.Active = 'Y')
	AND (ISNULL(GlobalCodes.RecordDeleted, 'N') = 'N')




	--DocumentRegistrationClientAddresses                         
	SELECT
	  'DocumentRegistrationClientAddresses' AS TableName,
	  --ClientAddresses.ClientAddressId,
	  ClientAddresses.ClientId,
	  ClientAddresses.AddressType,
	  ClientAddresses.Address AS ClientAddress,
	  ClientAddresses.City,
	  ClientAddresses.State AS ClientState,
	  ClientAddresses.Zip,
	  ClientAddresses.Display,
	  ClientAddresses.Billing,
	  ClientAddresses.RowIdentifier,
	  ClientAddresses.ExternalReferenceId,
	  ClientAddresses.CreatedBy,
	  ClientAddresses.CreatedDate,
	  ClientAddresses.ModifiedBy,
	  ClientAddresses.ModifiedDate,
	  ClientAddresses.RecordDeleted,
	  ClientAddresses.DeletedDate,
	  ClientAddresses.DeletedBy,
	  GlobalCodes.SortOrder
	FROM ClientAddresses
	INNER JOIN GlobalCodes
	  ON ClientAddresses.AddressType = GlobalCodes.GlobalCodeId
	WHERE (ClientAddresses.ClientId = @ClientID)
	AND (ISNULL(ClientAddresses.RecordDeleted, 'N') = 'N')
	AND (GlobalCodes.Active = 'Y')
	AND (ISNULL(GlobalCodes.RecordDeleted, 'N') = 'N')
	
	
	
	
	--DocumentRegistrationCoverageInformations
	Select                  
	  'DocumentRegistrationCoverageInformations' AS TableName          
	  --,- 1 AS DocumentRegistrationCoverageInformationId                 
	  ,CRCP.CreatedBy                         
	  ,CRCP.CreatedDate                         
	  ,CRCP.ModifiedBy                         
	  ,CRCP.ModifiedDate                        
	  ,CRCP.RecordDeleted                      
	  ,CRCP.DeletedBy                         
	  ,CRCP.DeletedDate                
	  ,-1 as DocumentVersionId                         
	  ,CRCP.CoveragePlanId
	  ,CRCP.InsuredId                         
	  ,CRCP.GroupNumber AS GroupId                
	  ,CRCP.Comment                    
	FROM ClientCoveragePlans CRCP                
	left join CoveragePlans CP on CP.CoveragePlanId = CRCP.CoveragePlanId                
	where ISNULL(CRCP.RecordDeleted, 'N') = 'N' and ISNULL(CP.RecordDeleted, 'N') = 'N' and ClientId = @ClientID 
	
	
	
	
	--ClientContacts
	SELECT
	  'ClientContacts' AS TableName,
	  CC.CreatedBy,
	  CC.CreatedDate,
	  CC.ModifiedBy,
	  CC.ModifiedDate,
	  CC.ClientContactId,
	  CC.RecordDeleted,
	  CC.DeletedBy,
	  CC.DeletedDate,
	  CC.ListAs,
	  GC.CodeName AS RelationshipText,
	  ( SELECT TOP ( 1 )
					PhoneNumber
		  FROM      ClientContactPhones
		  WHERE     ( ClientContactId = CC.ClientContactId )
					AND ( PhoneNumber IS NOT NULL )
					AND ( ISNULL(RecordDeleted, 'N') = 'N' )
		  ORDER BY  PhoneType
		) AS Phone ,
	  CC.Organization,
	  CC.Guardian AS GuardianText,
	  CC.EmergencyContact AS EmergencyText,
	  CC.FinanciallyResponsible AS FinResponsibleText,
	  CC.HouseholdMember AS HouseholdnumberText,
	  CC.CareTeamMember AS CareTeamMemberText,
	  CC.Active AS Active
	FROM ClientContacts CC
	INNER JOIN GlobalCodes GC
	  ON GC.GlobalCodeId = CC.Relationship
	  AND ISNULL(GC.RecordDeleted, 'N') <> 'Y'
	  AND GC.Category = 'RELATIONSHIP'
	WHERE (ISNULL(CC.RecordDeleted, 'N') <> 'Y')
	AND (CC.ClientId = @ClientID)



	--CustomDocumentRegistrations                  
	SELECT
	  'CustomDocumentRegistrations' AS TableName,
	  -1 AS 'DocumentVersionId',
	  @UserCode AS [CreatedBy],
	  GETDATE() AS [CreatedDate],	  
	  @UserCode AS [ModifiedBy],
	  GETDATE() AS [ModifiedDate]
	FROM systemconfigurations SC
	LEFT JOIN CustomDocumentRegistrations DROI
	  ON SC.DatabaseVersion = -1
	  
	  
	  
	  EXEC ssp_SCGetFormsAndAgreementsData @ClientID


	
END TRY                                                                                        
BEGIN CATCH                                            
DECLARE @Error varchar(8000)                                                                                         
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                   
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_InitDocumentRegistrations')                                                                                                                       
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                                        
    + '*****' + Convert(varchar,ERROR_STATE())                                        
 RAISERROR                                                                                                                       
 (                                                                                         
  @Error, -- Message text.                                                                                                                      
  16, -- Severity.                                                                                                                      
  1 -- State.                                                                                                                      
 );                                                                                                                    
END CATCH                                                                   
END 