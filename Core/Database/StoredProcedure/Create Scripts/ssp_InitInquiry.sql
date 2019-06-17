/****** Object:  StoredProcedure [dbo].[ssp_InitInquiry]    Script Date: 06/11/2018 03:53:09 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_InitInquiry]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_InitInquiry]
GO

/****** Object:  StoredProcedure [dbo].[ssp_InitInquiry]   Script Date: 06/11/2018 03:53:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

                
CREATE PROCEDURE [DBO].[ssp_InitInquiry]                 
 (                
 @ClientID INT                
 ,@StaffID INT                
 ,@CustomParameters XML                
 )                
AS                
-- =============================================                    
-- Author      : RK                 
-- Date        : 19/Dec/2017                  
-- Purpose     : Initializing SP Created.                 
-- Modified By     Modified Date    Purpose                
-- RK    19/Dec/2017       To initialize the tables InquiryDispositions, InquiryServiceDispositions, InquiryProviderServices                
-- =============================================                   
BEGIN                
 BEGIN TRY                
              
DECLARE @MaritalStatus VARCHAR(100)                
DECLARE @Language INT                
DECLARE @PrimaryClinicianId INT
DECLARE @PrimaryPhysicianId INT
DECLARE @FirstName VARCHAR(30)
DECLARE @MiddleName VARCHAR(30)
DECLARE @LastName VARCHAR(50)
DECLARE @Prefix VARCHAR(10)
DECLARE @Suffix VARCHAR(10)
DECLARE @Email VARCHAR(50)
DECLARE @Active Char(1)
DECLARE @ProfessionalSuffix VARCHAR(10)
DECLARE @DOB datetime
DECLARE @Age VARCHAR(20)
DECLARE @Sex Char(1)
DECLARE @GenderIdentity INT
DECLARE @SexualOrientation INT
DECLARE @DeceasedOn datetime
DECLARE @CauseOfDeath INT
DECLARE @PreferredGenderPronoun INT
DECLARE @FinanciallyResponsible Char(1)
DECLARE @AnnualHouseholdIncome money
DECLARE @NumberOfDependents INT
DECLARE @LivingArrangement INT
DECLARE @CountyOfResidence VARCHAR(5)
DECLARE @CountyOfTreatment VARCHAR(5)
DECLARE @CountyOfTreatmentText VARCHAR(100)
DECLARE @EducationalStatus INT
DECLARE @MilitaryStatus INT
DECLARE @EmploymentStatus INT
DECLARE @EmploymentInformation VARCHAR(100)
DECLARE @PrimaryLanguage INT
DECLARE @DoesNotSpeakEnglish Char(1)
DECLARE @HispanicOrigin INT
DECLARE @ReminderPreference INT
DECLARE @MobilePhoneProvider INT
DECLARE @SchedulingPreferenceMonday Char(1)
DECLARE @SchedulingPreferenceTuesday Char(1)
DECLARE @SchedulingPreferenceWednesday Char(1)
DECLARE @SchedulingPreferenceThursday Char(1)
DECLARE @SchedulingPreferenceFriday Char(1)
DECLARE @GeographicLocation VARCHAR(50)
DECLARE @SchedulingComment VARCHAR(max)

              
              
	SELECT @MaritalStatus=MaritalStatus
			,@Language=PrimaryLanguage 
			,@PrimaryClinicianId = PrimaryClinicianId
			,@PrimaryPhysicianId = PrimaryPhysicianId
			,@FirstName = FirstName
			,@MiddleName = MiddleName
			,@LastName = LastName
			,@Prefix = Prefix
			,@Suffix = Suffix
			,@Email = Email
			,@Active = Active
			,@ProfessionalSuffix = ProfessionalSuffix
			,@DOB = DOB
			,@Sex = Sex
			,@GenderIdentity = GenderIdentity
			,@SexualOrientation = SexualOrientation
			,@DeceasedOn = DeceasedOn
			,@CauseOfDeath = CauseOfDeath
			,@PreferredGenderPronoun = PreferredGenderPronoun
			,@FinanciallyResponsible = FinanciallyResponsible
			,@AnnualHouseholdIncome = AnnualHouseholdIncome
			,@NumberOfDependents = NumberOfDependents
			,@LivingArrangement = LivingArrangement
			,@CountyOfResidence = CountyOfResidence
			,@CountyOfTreatment = CountyOfTreatment
			,@CountyOfTreatmentText = (Ltrim(Rtrim(CF.CountyName)) + ' - ' + Ss.StateAbbreviation)
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
		FROM Clients       
		left join Counties CF on CF.CountyFIPS = Clients.CountyOfTreatment       
        left join States Ss on Ss.StateFIPs = CF.StateFIPs
        WHERE Clients.ClientId = @ClientID

      
DECLARE @CompletedGlobalCodeId INT                  
	                  
	SELECT @CompletedGlobalCodeId = GlobalCodeId                  
	FROM  GlobalCodes                  
	WHERE  Category = 'INQUIRYSTATUS'                  
	 AND Code = 'COMPLETE'                  
                
                
	SELECT 'Inquiries' AS TableName                
			,- 1 AS InquiryId                
			,'' AS CreatedBy                
			,GETDATE() AS CreatedDate                
			,'' AS ModifiedBy                
			,GETDATE() AS ModifiedDate,                
			RecordDeleted,                
			DeletedBy,                
			DeletedDate,                
			@StaffID as RecordedBy,                
			@StaffID as GatheredBy,                               
			@Language as PrimarySpokenLanguage,             
			@CompletedGlobalCodeId as InquiryStatus,                
			@PrimaryClinicianId AS PrimaryClinicianId
			,@PrimaryPhysicianId AS PrimaryPhysicianId
			,@FirstName AS InquirerFirstName
			,@MiddleName AS InquirerMiddleName
			,@LastName AS InquirerLastName
			,@Prefix AS Prefix
			,@Suffix AS Suffix
			,@Email AS InquirerEmail
			,@Active AS Active
			,@ProfessionalSuffix AS ProfessionalSuffix
			,@DOB AS DateOfBirth
			,@Sex AS Sex
			,@GenderIdentity AS GenderIdentity
			,@SexualOrientation AS SexualOrientation
			,@DeceasedOn AS DeceasedOn
			,@CauseOfDeath AS CauseOfDeath
			,@PreferredGenderPronoun AS PreferredGenderPronoun
			,@FinanciallyResponsible AS FinanciallyResponsible
			,@AnnualHouseholdIncome AS AnnualHouseholdIncome
			,@NumberOfDependents AS NumberOfDependents
			,@LivingArrangement AS LivingArrangement
			,@CountyOfResidence AS CountyOfResidence
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
	  FROM systemconfigurations s                
	 LEFT OUTER JOIN Inquiries  ON InquiryId = -1                 
                 
SELECT 'InquiryDispositions' AS TableName                
  ,- 1 AS InquiryDispositionId                
  ,'' AS CreatedBy                
  ,GETDATE() AS CreatedDate                
  ,'' AS ModifiedBy                
  ,GETDATE() AS ModifiedDate                  
  FROM systemconfigurations s                
 LEFT OUTER JOIN InquiryDispositions  ON InquiryId = -1                 
                 
SELECT 'InquiryServiceDispositions' AS TableName                
  ,- 1 AS InquiryServiceDispositionId                
  ,'' AS CreatedBy                
  ,GETDATE() AS CreatedDate                
  ,'' AS ModifiedBy                
  ,GETDATE() AS ModifiedDate                  
  FROM systemconfigurations s                
 LEFT OUTER JOIN InquiryServiceDispositions  ON InquiryDispositionId = -1                 
                 
SELECT 'InquiryProviderServices' AS TableName                
  ,- 1 AS InquiryProviderServiceId                
  ,'' AS CreatedBy                
  ,GETDATE() AS CreatedDate                
  ,'' AS ModifiedBy                
  ,GETDATE() AS ModifiedDate                  
  FROM systemconfigurations s                
 LEFT OUTER JOIN InquiryProviderServices  ON InquiryServiceDispositionId = -1                 
                
DECLARE @InquiryId INT                
SET @InquiryId= (SELECT  Top 1 InquiryId  from Inquiries  WHERE ClientId =  @ClientId order by  InquiryId desc)                
Select                  
  'InquiryCoverageInformations' AS TableName          
  --,- 1 AS InquiryCoverageInformationId                 
  ,CRCP.CreatedBy                         
  ,CRCP.CreatedDate                         
  ,CRCP.ModifiedBy                         
  ,CRCP.ModifiedDate                        
  ,CRCP.RecordDeleted                      
  ,CRCP.DeletedBy                         
  ,CRCP.DeletedDate                
  ,-1 as InquiryId                         
  ,CRCP.CoveragePlanId
  ,CRCP.InsuredId                         
  ,CRCP.GroupNumber AS GroupId                
  ,CRCP.Comment                    
     FROM ClientCoveragePlans CRCP                
 left join CoveragePlans CP on CP.CoveragePlanId = CRCP.CoveragePlanId                
   where ISNULL(CRCP.RecordDeleted, 'N') = 'N' and ISNULL(CP.RecordDeleted, 'N') = 'N' and ClientId = @ClientID       
       
  --Below are added by rk            ---"InquiryClientRaces", "InquiryClientDemographicInformationDeclines", "InquiryClientPictures", "InquiryClientEthnicities" };    
 ---ClientRaces    
 SELECT   'InquiryClientRaces' AS TableName             
  ,-1 AS InquiryClientRaceId    
  ,RaceId    
  ,CreatedBy    
  ,CreatedDate    
  ,ModifiedBy    
  ,ModifiedDate    
  ,RecordDeleted    
  ,DeletedDate    
  ,DeletedBy    
  ,-1 AS InquiryId    
 FROM   ClientRaces        
 WHERE  ClientId = @ClientId and ISNULL(RecordDeleted, 'N') = 'N' and ISNULL(RecordDeleted, 'N') = 'N'       
      
  SELECT   'InquiryClientDemographicInformationDeclines' AS TableName             
  ,-1 AS InquiryClientDemographicInformationDeclineId    
  ,CreatedBy    
  ,CreatedDate    
  ,ModifiedBy    
  ,ModifiedDate    
  ,RecordDeleted    
  ,DeletedBy    
  ,DeletedDate    
  ,-1 AS InquiryId    
  ,ClientDemographicsId    
 FROM   ClientDemographicInformationDeclines        
 WHERE  ClientId = @ClientId  and ISNULL(RecordDeleted, 'N') = 'N' and ISNULL(RecordDeleted, 'N') = 'N'    
     
      
    SELECT   'InquiryClientEthnicities' AS TableName             
  ,-1 AS InquiryClientEthnicityId    
  ,CreatedBy    
  ,CreatedDate    
  ,ModifiedBy    
  ,ModifiedDate    
  ,RecordDeleted    
  ,DeletedBy    
  ,DeletedDate    
  ,-1 AS InquiryId    
  ,EthnicityId    
 FROM   ClientEthnicities        
 WHERE  ClientId = @ClientId and ISNULL(RecordDeleted, 'N') = 'N' and ISNULL(RecordDeleted, 'N') = 'N'      
     
  SELECT   'InquiryClientPictures' AS TableName             
  ,-1 AS InquiryClientPictureId    
  ,CreatedBy    
  ,CreatedDate    
  ,ModifiedBy    
  ,ModifiedDate    
  ,RecordDeleted    
  ,DeletedBy    
  ,DeletedDate    
  ,UploadedBy    
  ,UploadedOn    
  ,PictureFileName    
  ,Picture    
  ,Active    
  ,-1 AS InquiryId    
 FROM   ClientPictures        
 WHERE  ClientId = 2105248 AND ISNULL(RecordDeleted, 'N') = 'N' AND ISNULL(RecordDeleted, 'N') = 'N' AND Active='Y'      
     
     
 ---- Need to uncomment if we are adding any Custumizations field for any customer.
 --SELECT 'CustomInquiries' AS TableName                
 -- ,- 1 AS InquiryId                
 -- ,'' AS CreatedBy                
 -- ,GETDATE() AS CreatedDate                
 -- ,'' AS ModifiedBy                
 -- ,GETDATE() AS ModifiedDate                  
 -- FROM systemconfigurations s                
 --LEFT OUTER JOIN CustomInquiries  ON InquiryId = -1  
 
                  
 END TRY                
                
 BEGIN CATCH                
  DECLARE @Error VARCHAR(8000)                
                
  SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_InitInquiry') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())                
                
  RAISERROR (                
    @Error                
    ,-- Message text.                                                                                                                  
    16                
    ,-- Severity.                                      
    1 -- State.                                                                                                                  
    );                
 END CATCH                
END 