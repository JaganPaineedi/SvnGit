IF EXISTS (SELECT * 
           FROM   SYS.objects 
           WHERE  object_id = 
                  Object_id(N'[dbo].[csp_InitCustomDocumentRegistrations]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[csp_InitCustomDocumentRegistrations] 

GO 
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_InitCustomDocumentRegistrations] --641,560,null 
-- csp_InitCustomDocumentRegistrations 36,550,null                       
 (@ClientID          INT 
 ,@StaffID          INT 
 ,@CustomParameters XML) 
AS 
/***************************************************************************/ 
/* Stored Procedure: [csp_InitCustomDocumentRegistrations]          */ 
/* Creation Date:  08/Sept/2014                      */ 
/* Author:  Malathi Shiva                     */ 
/* Purpose: To Initialize                          */ 
/* Input Parameters:                            */ 
/* Output Parameters:                            */ 
/* Return:                                  */ 
/* Called By:CustomDocumentRegistrations Class Of DataService            */ 
/* Calls:                                  */ 
/*                        */ 
/* Data Modifications:                   */ 
/*  Modified By    Modified Date    Purpose        */ 
/*  Arjun K R      27-Feb-2015      Task #75 Valley Client Acceptance Testing Issues */
--  Md Hussain     01/12/2016		Added 'CurrentlyHomeless' column to initialize the data w.r.t Task #207 New Directions - Support Go Live
--  Veena S Mani   06/06/2018       Added top 1 condition for the phone numbers as the subquery returning more than one result. New Directions - Support Go Live #844
--  Rajeshwari S   19/12/2018       Added condition to get the Home Address w.r.t Task #899 New Directions - Support Go Live
  /*********************************************************************/ 
  BEGIN   
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
          DECLARE @HomePhone2 VARCHAR(80)  
          DECLARE @EmploymentStatus INT  
          DECLARE @ReferralDate  DATETIME  
          DECLARE @ReferralType  INT  
          DECLARE @ReferralSubtype INT   
          DECLARE @ReferralComment  VARCHAR(250)  
            
          -- Arjun K R Task #75 Valley Client Acceptance Testing Issues  
          DECLARE @ReferralScreeningDate DATE  
          SELECT @ReferralScreeningDate= convert(varchar(10),CustomInquiries.[InquiryStartDateTime],101)  
          FROM CustomInquiries WHERE ClientId=@ClientID ORDER BY 1 DESC  
            
          --DECLARE @Race    
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
                 ,@EmploymentStatus = EmploymentStatus  
          FROM   Clients   
          WHERE  ClientID = @ClientID   
                 AND IsNull(RecordDeleted, 'N') = 'N'   
  
          SELECT @AddressLine1 = CA.[Address]   
                 ,@City = CA.City   
                 ,@State = CA.[State]   
                 ,@Zip = CA.Zip   
          FROM   ClientAddresses CA   
          WHERE  ClientId = @ClientID 
                  AND AddressType=90   
                 AND IsNull(RecordDeleted, 'N') = 'N'   
                   
          SELECT TOP 1 @ReferralDate = ReferralDate  
     ,@ReferralType = ReferralType  
     ,@ReferralSubtype = ReferralSubtype  
     ,@ReferralComment = ReferralComment   
          FROM   ClientEpisodes  
          WHERE  ClientID = @ClientID  
                 AND IsNull(RecordDeleted, 'N') = 'N' and [Status] in (100,101)    
                ORDER BY EpisodeNumber DESC  
                  
            
          SET @HomePhone  =  (SELECT TOP 1 PhoneNumber   
             
          FROM   ClientPhones   
          WHERE  ClientID = @ClientID  AND PhoneType = 30  
                 AND IsNull(RecordDeleted, 'N') = 'N' Order by ModifiedDate Desc)  
                   
          SET @HomePhone2 = (SELECT TOP 1 PhoneNumber   
             
          FROM   ClientPhones   
          WHERE  ClientID = @ClientID  AND PhoneType = 32  
                 AND IsNull(RecordDeleted, 'N') = 'N' Order by ModifiedDate Desc)  
  
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
                               
           Declare @EpisodeInformation varchar(max)    
   SET @EpisodeInformation =(SELECT TOP 1('EpisodeNumber: '+ Convert(varchar(8),EpisodeNumber)  +'       
'+'Registration: '+ISNull(Convert(varchar(8),RegistrationDate,1),'')+'          '+'Discharged: '+ISNull(Convert(varchar(8),DischargeDate,1),'') )  from ClientEpisodes where ClientId=@ClientId and  ISNull(RecordDeleted,'N')='N' order by RegistrationDate desc )      
  
  
          --CustomDocumentRegistrations           
          SELECT TOP 1 Placeholder.TableName   
                       ,-1 AS DocumentVersionId   
                       ,CR.CreatedBy   
                       ,CR.CreatedDate   
                       ,CR.ModifiedBy   
                       ,CR.ModifiedDate   
                       ,CR.RecordDeleted   
                       ,CR.DeletedBy   
                       ,CR.DeletedDate   
                       ,NULL AS PrimaryCarePhysician   
                       ,NULL AS PrimaryProgramId   
                       ,NULL AS PrimaryCareCoOrdinatorId   
                       ,ResidenceCounty   
                       ,@FirstName                       AS FirstName   
                       ,@LastName                        AS LastName   
                       ,@MiddleName                      AS MiddleName   
                       ,@Suffix                          AS Suffix   
                       ,@Sex                             AS Sex   
                       ,@Age                             AS Age   
                       ,@DateOfBirth                     AS DateOfBirth   
                       ,@SSN                             AS SSN   
                       ,@MarritalStatus                  AS MaritalStatus   
                       ,PrimayMethodOfCommunication   
                       ,@PrimaryLanguage    AS PrimaryLanguage   
                       ,SecondaryLanguage   
                       ,OtherPrimaryLanguage   
                       ,@HispanicOrigin      AS HispanicOrigin   
                       ,InterpreterNeeded   
                       ,@MemberRace                      AS Race   
                       ,MedicaidId   
                       ,PatientType   
                       ,ClientDeaf   
                       ,ClientDevelopmentallyDisabled   
                       ,ClientHasVisuallyImpairment   
                       ,ClientHasNonAmbulation   
                       ,ClientHasSevereMedicalIssues 
                       ,CASE
                        WHEN (@AddressLine1 IS NOT NULL) THEN 'Y'
                        ELSE CurrentlyHomeless
                        END  as CurrentlyHomeless
                       ,@AddressLine1                    AS Address1   
                       ,Address2   
                       ,@City                            AS City   
                       ,ISNULL(@State,'OR')              AS [State]   
                       ,@Zip                             AS ZipCode   
                       ,@HomePhone                       AS HomePhone   
                       ,@HomePhone2       AS HomePhone2   
                       ,WorkPhone   
                       ,CellPhone   
                       ,MessagePhone   
                       ,Citizenship   
                       ,BirthPlace   
                       ,EducationalLevel   
                       ,EducationStatus   
                       ,@EmploymentStatus    AS EmploymentStatus  
                       ,Religion   
                       ,NULL       AS MilitaryStatus   
                       ,JusticeSystemInvolvement   
                       ,ForensicTreatment   
                       ,SSISSDStatus   
                       ,SmokingStatus   
                       ,ScreenForMHSUD   
                       ,AdvanceDirective   
                       ,Organization   
                       ,Phone   
                       ,PCPEmail   
                       ,'N' AS ClientWithOutPCP   
                       ,'N' AS ClientSeenByOtherProvider   
                       ,'' AS OtherProviders   
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
                       ,'' AS Financialcomment   
                       ,100 as Disposition   
                       ,@ReferralScreeningDate AS ReferralScreeningDate  -- Arjun K R Task #75 Valley Client Acceptance Testing Issues  
                       ,RegistrationDate   
                       ,@EpisodeInformation as Information   
                       ,@ReferralDate AS ReferralDate   
                       ,@ReferralType AS ReferralType   
                       ,@ReferralSubtype AS ReferralSubtype   
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
                       ,NULL AS ProgramStatus   
                       ,ProgramRequestedDate   
                       ,ProgramEnrolledDate   
                       ,NumberOfArrestsLast30Days  
        ,BirthCertificate  
        ,'' AS OtherProvidersCurrentlyTreating  
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
          FROM   (SELECT 'CustomDocumentRegistrations' AS TableName) AS   
                 Placeholder   
                 LEFT JOIN Documents Doc   
                        ON ( Doc.ClientId = @ClientID   
                             AND ISNULL(Doc.RecordDeleted, 'N') <> 'Y' )   
                 LEFT JOIN DocumentVersions DV   
                        ON ( DV.DocumentId = Doc.DocumentId   
                             AND ISNULL(DV.RecordDeleted, 'N') <> 'Y' )   
                 LEFT JOIN CustomdocumentRegistrations CR   
                        ON ( DV.DocumentVersionId = CR.DocumentVersionId  OR CR.DocumentVersionId=@LatestDocumentVersionID 
                             AND ISNULL(CR.RecordDeleted, 'N') <> 'Y' )   
          ORDER  BY Doc.EffectiveDate DESC   
                    ,Doc.ModifiedDate DESC   
  
           SELECT 'ClientContacts' AS TableName   
                 ,CC.ClientContactId   
     ,CC.RecordDeleted  
     ,CC.DeletedBy  
     ,CC.DeletedDate  
                 ,CC.ListAs   
                 ,GC.CodeName               AS RelationshipText,   
                 ( SELECT TOP ( 1 )    
                        PhoneNumber    
              FROM      ClientContactPhones    
              WHERE     ( ClientContactId = CC.ClientContactId )    
                        AND ( PhoneNumber IS NOT NULL )    
                        AND ( ISNULL(RecordDeleted, 'N') = 'N' )    
              ORDER BY  PhoneType    
            ) AS Phone ,  
                 CC.Organization   
                 ,CC.Guardian               AS GuardianText   
                 ,CC.EmergencyContact       AS EmergencyText   
                 ,CC.FinanciallyResponsible AS FinResponsibleText   
                 ,CC.HouseholdMember        AS HouseholdnumberText   
                 ,CC.Active                 AS Active   
          FROM  ClientContacts CC     
            INNER JOIN GlobalCodes GC ON GC.GlobalCodeId = CC.Relationship    
                                      AND ISNULL(GC.RecordDeleted,    
                                                 'N') <> 'Y'    
                                      AND GC.Category = 'RELATIONSHIP'    
       WHERE   ( ISNULL(CC.RecordDeleted, 'N') <> 'Y' )    
            AND ( CC.ClientId =  @ClientID )     
                           
        --DECLARE @LatestDocumentVersionID INT  
  
   
            SELECT 'CustomRegistrationFormsAndAgreements' AS TableName  
    ,- 1 AS DocumentVersionId   
   ,CRFA.CreatedBy  
   ,CRFA.CreatedDate  
   ,CRFA.ModifiedBy  
   ,CRFA.ModifiedDate  
   ,CRFA.RecordDeleted  
   ,CRFA.DeletedBy  
   ,CRFA.DeletedDate  
   ,CRFA.Form  
   ,CRFA.EnglishForm  
   ,CRFA.SpanishForm  
   ,CRFA.NoForm  
   ,CRFA.DeclinedForm  
      ,CRFA.NotApplicableForm  
      FROM systemconfigurations s  
  JOIN CustomRegistrationFormsAndAgreements CRFA ON CRFA.DocumentVersionId = @LatestDocumentVersionId  
   AND ISNULL(CRFA.RecordDeleted, 'N') = 'N'  
   ORDER BY CRFA.CustomRegistrationFormAndAgreementId ASC   
     
     
  Select 'CustomRegistrationCoveragePlans' AS TableName  
   ,-1 AS DocumentVersionId   
  ,CRCP.CreatedBy           
  ,CRCP.CreatedDate           
  ,CRCP.ModifiedBy           
  ,CRCP.ModifiedDate          
  ,CRCP.RecordDeleted        
  ,CRCP.DeletedBy           
  ,CRCP.DeletedDate           
  ,CRCP.CoveragePlanId            
  ,CRCP.InsuredId           
  ,CRCP.GroupNumber AS GroupId  
  ,CRCP.Comment    
   FROM ClientCoveragePlans CRCP  
      left join CoveragePlans CP on CP.CoveragePlanId = CRCP.CoveragePlanId  
   where ISNULL(CRCP.RecordDeleted, 'N') = 'N' and ISNULL(CP.RecordDeleted, 'N') = 'N' and ClientId = @ClientID  
     
     
  
      END TRY   
  
      BEGIN CATCH   
          DECLARE @Error VARCHAR(8000)   
  
          SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'   
                      + CONVERT(VARCHAR(4000), ERROR_MESSAGE())   
                      + '*****'   
                      + isnull(CONVERT(VARCHAR, ERROR_PROCEDURE()),   
                      'csp_InitCustomDocumentRegistrations')   
                      + '*****' + CONVERT(VARCHAR, ERROR_LINE())   
                      + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY())   
                      + '*****' + CONVERT(VARCHAR, ERROR_STATE())   
  
          RAISERROR ( @Error,   
                      -- Message text.                                                                                                        
                      16,   
                      -- Severity.                                                                                                        
                      1   
          -- State.                                                                                                        
          );   
      END CATCH   
  END  

GO 