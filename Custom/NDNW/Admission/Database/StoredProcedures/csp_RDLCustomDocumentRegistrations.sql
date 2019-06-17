

/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDocumentRegistrations]    Script Date: 10/23/2014 09:59:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentRegistrations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocumentRegistrations]
GO


/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDocumentRegistrations]    Script Date: 10/23/2014 09:59:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE  [dbo].[csp_RDLCustomDocumentRegistrations]                    
(                                      
@DocumentVersionId  int       
)                                      
As                                      
/************************************************************************/                                                
/* Stored Procedure: RDLCustomDocumentRegistrations    */                                                                   
/* Copyright: 2014  Streamline SmartCare                            */                                                                            
/* Creation Date:  oct 17 ,2014                                   */                                                
/*                                                                 */                                                
/* Purpose: Gets Data for CustomRegistrations      */                                               
/*                                                                 */                                              
/* Input Parameters: @DocumentVersionId                            */                                              
/*                                                                 */                                                 
/* Output Parameters:                                              */                                                
/* Purpose: Use For Rdl Report                                     */    
/* Call By:                                                        */                                      
/* Calls:                                                          */                                                
/*                                                                 */                                                
/* Author: Aravind                                          */  
--Updates
-- Date			Author					Purpose
-- 01/2016	MD Hussain K	Corrected the values for column 'CDR.[CurrentlyHomeless]' to match with values on Screen w.r.t #207 New Directions - Support Go Live 
/************************************************************************/   
                                                                    

BEGIN TRY
BEGIN
DECLARE @Age varchar(10)
DECLARE @Information varchar(max)
DECLARE @ClientId int                                                                                                                                                                                         
SELECT @ClientId = ClientId from Documents where                                                                                                                                                                                         
CurrentDocumentVersionId = @DocumentVersionId and IsNull(RecordDeleted,'N')= 'N' 
--Exec csp_CalculateAgeRegistrations @DocumentVersionId, @Age out
Exec csp_CalculateAge  @ClientID,@Age OUT 
 


--SET @Information =(SELECT TOP 1('Episode Number: '+ Convert(varchar(8),EpisodeNumber)  +'     
--'+'Registration: '+ISNull(Convert(varchar(8),RegistrationDate,1),'')+'          '+'Discharged: '+ISNull(Convert(varchar(8),DischargeDate,1),'') )  from ClientEpisodes where ClientId=@ClientId and  ISNull(RecordDeleted,'N')='N' order by RegistrationDate desc )    
 Select
        CDR.[DocumentVersionId]
      ,(Select OrganizationName from SystemConfigurations) as OrganizationName                                  
      ,Documents.ClientId                                  
      ,Clients.LastName + ', ' + Clients.FirstName as ClientName    
      ,CONVERT(VARCHAR(10),Documents.EffectiveDate,101) as EffectiveDate 
     ,CDR.[FirstName]
     ,CDR.[LastName]
     ,CDR.[MiddleName]
     ,CDR. [SSN]
     ,Convert(varchar(10),CDR.[DateOfBirth],101) as DateOfBirth
     ,@Age as Age
     ,dbo.csf_GetGlobalCodeNameById(CDR.[Sex]) as Sex
     ,CDR.Suffix
     ,CDR.SSNUnknown
     ,C1.CountyName as 'CountyResidence'
     ,C2.CountyName as 'FinancialCounty'
     --,case CDR.[Sex] when 'M' then 'Male' else 'Female'end as Sex 
     ,dbo.csf_GetGlobalCodeNameById(CDR.[MaritalStatus]) as MaritalStatus
     ,dbo.csf_GetGlobalCodeNameById(CDR.[PrimayMethodOfCommunication]) as PrimayMethodOfCommunication
     ,dbo.csf_GetGlobalCodeNameById(CDR.[InterpreterNeeded]) as InterpreterNeeded
     ,dbo.csf_GetGlobalCodeNameById(CDR.[PrimaryLanguage]) as PrimaryLanguage  
     ,dbo.csf_GetGlobalCodeNameById(CDR.[SecondaryLanguage]) as SecondaryLanguage 
     ,dbo.csf_GetGlobalCodeNameById(CDR.[HispanicOrigin]) as HispanicOrigin 
     ,dbo.csf_GetGlobalCodeNameById(CDR.[Race]) as Race 
     ,dbo.csf_GetGlobalCodeNameById(CDR.[PatientType]) as PatientType 
     ,CDR.MedicaidId 
     ,Case when isnull(CDR.[ClientDeaf],'') = 'Y' then 'Deaf' when isnull(CDR.[ClientDeaf],'') = 'N' then '' else '' end ClientDeaf
     ,Case when isnull(CDR.[ClientDevelopmentallyDisabled],'') = 'Y' then 'DevelopmentallyDisabled' when isnull(CDR.[ClientDevelopmentallyDisabled],'') = 'N' then '' else '' end ClientDevelopmentallyDisabled
     ,Case when isnull(CDR.[ClientHasVisuallyImpairment],'') = 'Y' then 'Blind/Severe visually Impairment' when isnull(CDR.[ClientHasVisuallyImpairment],'') = 'N' then '' else '' end ClientHasVisuallyImpairment
     ,Case when isnull(CDR.[ClientHasNonAmbulation],'') = 'Y' then 'Non-ambulation' when isnull(CDR.[ClientHasNonAmbulation],'') = 'N' then '' else '' end ClientHasNonAmbulation
     ,Case when isnull(CDR.[ClientHasSevereMedicalIssues],'') = 'Y' then 'SevereMedicalIssues' when isnull(CDR.[ClientHasSevereMedicalIssues],'') = 'N' then '' else '' end ClientHasSevereMedicalIssues
     ,Case when isnull(CDR.[CurrentlyHomeless],'') = 'N' then 'Client is homeless' 
		   when isnull(CDR.[CurrentlyHomeless],'') = 'Y' then 'Client is not homeless' 
		   when isnull(CDR.[CurrentlyHomeless],'') = 'U' then 'Client is chronically homeless' else '' end CurrentlyHomeless
     ,CDR.Address1
     ,CDR.Address2
     ,CDR.City
     ,CDR.State
     ,CDR.ZipCode
     ,CDR.HomePhone
     ,CDR.HomePhone2
     ,CDR.WorkPhone
     ,CDR.CellPhone
     ,CDR.MessagePhone
     ,dbo.csf_GetGlobalCodeNameById(CDR.[Citizenship]) as Citizenship
     ,dbo.csf_GetGlobalCodeNameById(CDR.[EducationalLevel]) as EducationalLevel
     ,dbo.csf_GetGlobalCodeNameById(CDR.[EducationStatus]) as EducationStatus
     --,dbo.csf_GetGlobalCodeNameById(CDR.[EmploymentStatus]) as EmploymentStatus
     ,dbo.csf_GetGlobalCodeNameById(CDR.[EmploymentStatus]) as EmploymentStatus
     ,dbo.csf_GetGlobalCodeNameById(CDR.[JusticeSystemInvolvement]) as JusticeSystemInvolvement
     ,dbo.csf_GetGlobalCodeNameById(CDR.[Religion]) as Religion
     ,dbo.csf_GetGlobalCodeNameById(CDR.[MilitaryStatus]) as MilitaryStatus
     ,dbo.csf_GetGlobalCodeNameById(CDR.[ForensicTreatment]) as ForensicTreatment
     --,dbo.csf_GetGlobalCodeNameById(CDR.[MilitaryStatus]) as MilitaryStatus
     ,dbo.csf_GetGlobalCodeNameById(CDR.[SmokingStatus]) as SmokingStatus
     ,dbo.csf_GetGlobalCodeNameById(CDR.[AdvanceDirective]) as AdvanceDirective
     ,dbo.csf_GetGlobalCodeNameById(CDR.[ScreenForMHSUD]) as ScreenForMHSUD
   --  ,dbo.csf_GetGlobalCodeNameById(CDR.[AdvanceDirective]) as AdvanceDirective
     ,dbo.csf_GetGlobalCodeNameById(CDR.[SSISSDStatus]) as SSISSDStatus
     ,dbo.csf_GetGlobalCodeNameById(CDR.[LivingArrangments]) as LivingArrangments
     
    --,CDR.PrimaryCarePhysician
      ,CDR.BirthPlace 
      
      ,ER.OrganizationName AS Organization 
      ,ER.Name AS PrimaryCarePhysician
      ,ER.PhoneNumber AS Phone 
      ,ER.Email AS PCPEmail 
      
      ,Case when isnull(CDR.[ClientWithOutPCP],'') = 'Y' then 'Client does not have PCP' when isnull(CDR.[ClientWithOutPCP],'') = 'N' then '' else '' end ClientWithOutPCP
     ,Case when isnull(CDR.[ClientSeenByOtherProvider],'') = 'Y' then 'Client is being seen by another behavioral haealth care provider if so,name and contact information' when isnull(CDR.[ClientSeenByOtherProvider],'') = 'N' then '' else '' end ClientSeenByOtherProvider
     -- ,ClientSeenByOtherProvider 
      ,CDR.OtherProviders 
    
      --,CDR.PreviousMentalHealthServices 
      --,CDR.PreviousSubstanceAbuseServices
      
         ,case when CDR.PreviousMentalHealthServices  = 'Y' then 'Yes' 
         else case when CDR.PreviousMentalHealthServices = 'N' then 'No' 
         
         else '' end end as PreviousMentalHealthServices
         
        ,case when CDR.PreviousSubstanceAbuseServices  = 'Y' then 'Yes' 
         when CDR.PreviousSubstanceAbuseServices = 'N' then 'No' 
         else case when CDR.PreviousSubstanceAbuseServices = 'U' then 'UnKnown' 
         else '' end end as PreviousSubstanceAbuseServices
  

      
     ,Case when isnull(CDR.[VBHService],'') = 'Y' then 'VBH' when isnull(CDR.[VBHService],'') = 'N' then '' else '' end VBHService 
     ,Case when isnull(CDR.[StateHospitalService],'') = 'Y' then 'State Hospital' when isnull(CDR.[StateHospitalService],'') = 'N' then '' else '' end StateHospitalService 
     ,Case when isnull(CDR.[PsychiatricHospitalService],'') = 'Y' then 'Psychiatric Hospital' when isnull(CDR.[PsychiatricHospitalService],'') = 'N' then '' else '' end PsychiatricHospitalService 
     ,Case when isnull(CDR.[GeneralHospitalService],'') = 'Y' then 'General Hospital' when isnull(CDR.[GeneralHospitalService],'') = 'N' then '' else '' end GeneralHospitalService 
     ,Case when isnull(CDR.[OutPatientService],'') = 'Y' then 'OutPatient' when isnull(CDR.[OutPatientService],'') = 'N' then '' else '' end OutPatientService
     ,Case when isnull(CDR.[ResidentialService],'') = 'Y' then 'Residential(Non Hospital)' when isnull(CDR.[ResidentialService],'') = 'N' then '' else '' end ResidentialService 
      ,Case when isnull(CDR.[SubAbuseOutPatientService],'') = 'Y' then 'Substance Abuse/Outpatient Program' when isnull(CDR.[SubAbuseOutPatientService],'') = 'N' then '' else '' end SubAbuseOutPatientService
      
    
      
      ,dbo.csf_GetGlobalCodeNameById(CDR.[ResidenceType]) as ResidenceType 
     ,dbo.csf_GetGlobalCodeNameById(CDR.[HouseholdComposition]) as HouseholdComposition
     ,dbo.csf_GetGlobalCodeNameById(CDR.[PrimarySource]) as PrimarySource
     ,dbo.csf_GetGlobalCodeNameById(CDR.[AlternativeSource]) as AlternativeSource
      
      
     
      ,CDR.PreviousTreatmentComments 
     -- ,CDR.HeadOfHousehold 
      ,Case when isnull(CDR.[HeadOfHousehold],'') = 'Y' then 'Head Of Household' when isnull(CDR.[HeadOfHousehold],'') = 'N' then '' else '' end HeadOfHousehold 
      
      ,CDR.NumberInHousehold 
      ,CDR.DependentsInHousehold 
      ,CDR.HouseholdAnnualIncome 
      ,CDR.ClientAnnualIncome 
      ,CDR.ClientMonthlyIncome 
     -- ,CDR.PrimarySource 
     -- ,CDR.AlternativeSource 
      ,CDR.ClientStandardRate
     ,CONVERT(varchar,CONVERT(date,CDR.SpecialFeeBeginDate),101) as SpecialFeeBeginDate 
       
      --,CDR.SpecialFeeBeginDate 
      ,CDR.SpecialFeeComment 
      
      ,CONVERT(varchar,CONVERT(date,CDR.SpecialFeeBeginDate),101) as SlidingFeeStartDate 
      ,CONVERT(varchar,CONVERT(date,CDR.SlidingFeeEndDate),101) as SlidingFeeEndDate
     -- ,CDR.SlidingFeeStartDate 
      --,CDR.SlidingFeeEndDate 
      
      ,Case when isnull(CDR.[IncomeVerified],'') = 'Y' then 'Income Verified' when isnull(CDR.[IncomeVerified],'') = 'N' then '' else '' end IncomeVerified 
     -- ,CDR.IncomeVerified 
      ,CDR.PerSessionFee 
      ,CDR.Financialcomment 
     -- ,CDR.Disposition 
      ,dbo.csf_GetGlobalCodeNameById(CDR.[Disposition]) as Disposition
      
       ,CONVERT(varchar,CONVERT(date,CDR.ReferralScreeningDate),101) as ReferralScreeningDate
      ,CONVERT(varchar,CONVERT(date,CDR.RegistrationDate ),101) as RegistrationDate 
     
      
      ,CDR.Information 
        ,CONVERT(varchar,CONVERT(date,CDR.ReferralDate),101) as ReferralDate 
      --,CDR.ReferralDate
      ,dbo.csf_GetGlobalCodeNameById(CDR.[ReferralType]) as ReferralType  
      --,CDR.ReferralType 
      ,dbo.csf_GetGlobalSubCodeById(CDR.[ReferralSubtype]) as ReferralSubtype 
      --,CDR.ReferralSubtype 
      ,CDR.ReferralOrganization 
      ,CDR.ReferrralPhone 
      ,CDR.ReferrralFirstName 
      ,CDR.ReferrralLastName 
      ,CDR.ReferrralAddress1 
      ,CDR.ReferrralAddress2 
      ,CDR.ReferrralCity 
      ,CDR.ReferrralState 
      ,CDR.ReferrralZipCode 
      ,CDR.ReferrralEmail 
      ,CDR.ReferrralComment 
     -- ,CDR.PrimaryProgramId
      ,PS.ProgramName as PrimaryProgramId
      
      ,dbo.csf_GetGlobalCodeNameById(CDR.[ProgramStatus]) as ProgramStatus
      
       ,S.LastName + ', ' + S.Firstname as PrimaryCareCoOrdinatorId
     -- ,CDR.ProgramStatus
      --,CDR.PrimaryCareCoOrdinatorId
      ,CONVERT(varchar,CONVERT(date,CDR.ProgramRequestedDate ),101) as ProgramRequestedDate 
      
    --  ,CONVERT(varchar,CONVERT(date,CDR.ProgramEnrolledDate  ),101) as ProgramEnrolledDate 
     ,convert(varchar(10),CDR.[ProgramEnrolledDate],101) as  ProgramEnrolledDate    
     
      ,CDR.NumberOfArrestsLast30Days
	 -- ,CDR.BirthCertificate
	  ,Case when isnull(CDR.[BirthCertificate],'') = 'Y' then 'BirthCertificate' when isnull(CDR.[BirthCertificate],'') = 'N' then '' else '' end BirthCertificate 
	  ,CDR.OtherProvidersCurrentlyTreating
	  ,dbo.csf_GetGlobalCodeNameById(TribalAffiliation) as TribalAffiliation
      ,Medicaid
      ,CivilCommitment
      ,IEP
      ,VocationalRehab
      ,RegisteredVoter
     ,NumberOfEmployersLast12Months
,NumberOfArrestPast12Months
,VotingInformation
,dbo.csf_GetGlobalCodeNameById(SchoolAttendance) as SchoolAttendance 
,dbo.csf_GetGlobalCodeNameById(RegisteredSexOffender) as RegisteredSexOffender
,dbo.csf_GetGlobalCodeNameById(CDR.ClientType) as ClientType
,dbo.csf_GetGlobalCodeNameById(MilitaryService) as MilitaryService
,dbo.csf_GetGlobalCodeNameById(Facility) as Facility
	  
     
 FROM Documents                        
INNER JOIN DocumentVersions  ON Documents.DocumentId = DocumentVersions.DocumentId                     
LEFT JOIN CustomDocumentRegistrations AS CDR ON CDR.DocumentVersionId = DocumentVersions.DocumentVersionId                   
JOIN Clients ON Clients.ClientId = Documents.ClientId 
LEFT JOIN Counties C1 on C1.CountyFIPS=CDR.ResidenceCounty  
LEFT JOIN Counties C2 on C2.CountyFIPS=CDR.CountyOfTreatment 
LEFT JOIN States on States.StateAbbreviation=CDR.State/* Modified  Devi Dayal*/ 
--LEFT JOIN Staff  on Staff.StaffId=CDR.PrimaryEpisodeWorkerId 
LEFT JOIN Staff S  on S.StaffId=CDR.PrimaryCareCoOrdinatorId 
LEFT JOIN GlobalSubCodes GS  on GS.GlobalSubCodeId=CDR.ReferralSubtype 
LEFT JOIN Programs PS on PS.ProgramId=CDR.PrimaryProgramId AND PS.ACTIVE='Y'
left join ExternalReferralProviders  ER on ER.ExternalReferralProviderId = CDR.PrimaryCarePhysician AND ER.ACTIVE='Y'
WHERE CDR.DocumentVersionId =@DocumentVersionId                 
and ISNULL(Documents.RecordDeleted,'N')='N'                      
and ISNULL(DocumentVersions.RecordDeleted,'N')='N'                                   
and ISNULL(CDR.RecordDeleted,'N')='N'                                     
and ISNULL(Clients.RecordDeleted,'N')='N'               
AND ISNULL(PS.RecordDeleted,'N')='N'   
AND ISNULL(ER.RecordDeleted,'N')='N'   



--       CR.[DocumentVersionId]
--      ,(Select OrganizationName from SystemConfigurations) as OrganizationName                                  
--      ,Documents.ClientId                                  
--      ,Clients.LastName + ', ' + Clients.FirstName as ClientName    
--      ,CONVERT(VARCHAR(10),Documents.EffectiveDate,110) as EffectiveDate  
--      ,CR.[Prefix] as Prefix 
--      ,CR.[FirstName]
--      ,CR.[LastName]
--      ,CR.[MiddleName]
--      ,CR.[Suffix] as Suffix
--      ,CR.[MemberNameAlias]
--      ,CR.[AliasFirstName]
--      ,CR.[AliasLastName]
--      ,Convert(varchar(8),CR.[DateOfBirth],1) as DateOfBirth
--      ,@Age as Age
--      ,dbo.csf_GetGlobalCodeNameById(CR.[Sex]) as Sex
--      --,case CR.[Sex] when 'M' then 'Male' else 'Female'end as Sex  
--      ,CR.[SSN]
--      ,dbo.csf_GetGlobalCodeNameById(CR.[MaritalStatus]) as MaritalStatus
--      ,CR.[MemberDeaf]
--      ,dbo.csf_GetGlobalCodeNameById(CR.[Race]) as Race 
--      ,dbo.csf_GetGlobalCodeNameById(CR.[HispanicOrigin]) as HispanicOrigin 
--      ,dbo.csf_GetGlobalCodeNameById(CR.[PrimaryLanguage]) as PrimaryLanguage 
--      ,dbo.csf_GetGlobalCodeNameById(CR.[SecondaryLanguage]) as SecondaryLanguage 
--      ,dbo.csf_GetGlobalCodeNameById(CR.[InterpreterNeeded]) as InterpreterNeeded 
--      ,dbo.csf_GetGlobalCodeNameById(CR.[PrimayMethodOfCommunication]) as PrimayMethodOfCommunication 
--      ,CR.[IDHSID]
--      ,CR.[DCFSID]
--      ,CR.[PCN]
--      ,CR.[Address1]
--      ,CR.[Address2]
--      ,CR.[City]
--      ,States.StateName AS [State]
--      ,CR.[ZipCode]
--      ,Counties.CountyName As [County]
--      ,CR.[HomePhone]
--      ,CR.[HomePhone2]
--      ,CR.[WorkPhone]
--      ,CR.[CellPhone]
--      ,CR.[Pager]
--      ,CR.[MessagePhone]
--      ,CR.[Email]
--      ,dbo.csf_GetGlobalCodeNameById(CR.[ResidenceType]) as ResidenceType 
--      ,dbo.csf_GetGlobalCodeNameById(CR.[HouseholdComposition]) as HouseholdComposition
--      ,dbo.csf_GetGlobalCodeNameById(CR.[FamilyHouseholdSize]) as FamilyHouseholdSize
--      ,CR.[HouseholdAnnualIncome]
--      ,CR.[HeadOfHousehold]
--      ,dbo.csf_GetGlobalCodeNameById(CR.[HairColor]) as HairColor
--      ,dbo.csf_GetGlobalCodeNameById(CR.[EyeColor]) as EyeColor
--      ,CR.[Height]
--      ,CR.[Weight]
--      ,CR.[IdentifyingMarks]
--      ,dbo.csf_GetGlobalCodeNameById(CR.[Citizenship]) as Citizenship
--      ,dbo.csf_GetGlobalCodeNameById(CR.[GuadianStatus]) as GuadianStatus
--      ,CR.[BirthPlace]
--      ,dbo.csf_GetGlobalCodeNameById(CR.[EducationalLevel]) as EducationalLevel
--      ,dbo.csf_GetGlobalCodeNameById(CR.[EmploymentStatus]) as EmploymentStatus
--      ,CR.[BirthCertificate]
--      ,dbo.csf_GetGlobalCodeNameById(CR.[Religion]) as Religion
--      ,dbo.csf_GetGlobalCodeNameById(CR.[MilitaryStatus]) as MilitaryStatus
--      ,dbo.csf_GetGlobalCodeNameById(CR.[ForensicTreatment]) as ForensicTreatment
--      ,dbo.csf_GetGlobalCodeNameById(CR.[JusticeSystemInvolvement]) as JusticeSystemInvolvement
--      ,dbo.csf_GetGlobalCodeNameById(CR.[SSISSDIStatus]) as SSISSDIStatus
--      ,dbo.csf_GetGlobalCodeNameById(CR.[SmokingStatus]) as SmokingStatus
--      ,dbo.csf_GetGlobalCodeNameById(CR.[ScreenForMisa]) as ScreenForMisa
--      ,dbo.csf_GetGlobalCodeNameById(CR.[AdvanceDirective]) as AdvanceDirective
--      ,CR.[ContinuosTreatment]
--      ,CR.[ContinuousResidence]
--      ,CR.[HistoryOfServices]
--      ,CR.[PreviousOutpatientTreatment]
--      ,CR.[NoPreviousOutpatientTreatment]
--      ,CR.[SeriousImpairment]
--      ,CR.[UnemployedPartTimeDueToMI]
--      ,CR.[DoesNotSeekServices]
--      ,CR.[LacksSupportingSystems]
--      ,CR.[RequiresAssistance]
--      ,CR.[ExhibitsInappropriateBehavior]
--      ,CR.[CurrentlyReceivingTreatment]
--      ,dbo.csf_GetGlobalCodeNameById(CR.[Disposition]) as Disposition
--      ,Convert(varchar(8),CR.[ReferralDate],1) as ReferralDate
--      ,Convert(varchar(8),CR.[RegistrationDate],1) as RegistrationDate
--      ,Convert(varchar(8),CR.[FirstContactDate],1) as FirstContactDate
--      ,Staff.lastname +', '+ Staff.firstname as PrimaryEpisodeWorkerId
--      ,dbo.csf_GetGlobalCodeNameById(CR.[ReferralType]) as ReferralType
--      ,CR.[ReferralSubtype]
--      --,GS.SubCodeName as ReferralSubtype
--      ,CR.[ReferralName]
--      ,CR.[ReferralAdditionalInformation]
--      ,dbo.csf_GetGlobalCodeNameById(CR.[ReferralReason1]) as ReferralReason1
--      ,dbo.csf_GetGlobalCodeNameById(CR.[ReferralReason2]) as ReferralReason2
--      ,dbo.csf_GetGlobalCodeNameById(CR.[ReferralReason3]) as ReferralReason3
--      ,CR.[ReferralComment]
--      ,PS.ProgramName as PrimaryTeamId/* Modified By Devi Dayal*/
--      ,dbo.csf_GetGlobalCodeNameById(CR.[TeamStatus]) as TeamStatus
--      ,Convert(varchar(8),CR.[ProgramRequestedDate],1) as ProgramRequestedDate
--      ,Convert(varchar(8),CR.[ProgramEnrolledDate],1) as ProgramEnrolledDate
--      ,S.lastname +', '+ S.firstname as TeamPrimaryWorkerId
--      ,MemberAnnualIncome
--      ,AdmissionsToInpatientTreatment  
--      ,RequiresFinancialAssistance
--      ,@Information as Information
--      ,CR.CurrentlyHomeless
--      ,CR.NoOfMonthsHomeless
--      ,CR.NoOfTimeHomeless
--      ,CR.AdultInHousehold
--      ,CR.ChildrenInHousehold
--      ,dbo.csf_GetGlobalCodeNameById(CR.[WilliamClassIMD]) as 'WilliamClassIMD'    
--      ,CR.FirstNameFictitious  
--	  ,CR.LastNameFictitious 
--	  ,CR.LastNameFictitious
--	  ,dbo.csf_GetGlobalCodeNameById(CR.RegisteredVoter) as 'RegisteredVoter' 
--FROM Documents                        
--INNER JOIN DocumentVersions  ON Documents.DocumentId = DocumentVersions.DocumentId                     
--LEFT JOIN CustomRegistrations AS CR ON CR.DocumentVersionId = DocumentVersions.DocumentVersionId                   
--JOIN Clients ON Clients.ClientId = Documents.ClientId 
--LEFT JOIN Counties on Counties.CountyFIPS=CR.County  
--LEFT JOIN States on States.StateAbbreviation=CR.State/* Modified  Devi Dayal*/ 
--LEFT JOIN Staff  on Staff.StaffId=CR.PrimaryEpisodeWorkerId 
--LEFT JOIN Staff S  on S.StaffId=CR.TeamPrimaryWorkerId 
--LEFT JOIN GlobalSubCodes GS  on GS.GlobalSubCodeId=CR.ReferralSubtype 
--LEFT JOIN Programs PS on PS.ProgramId=CR.PrimaryTeamId AND PS.ACTIVE='Y'
--WHERE CR.DocumentVersionId =@DocumentVersionId                 
--and ISNULL(Documents.RecordDeleted,'N')='N'                      
--and ISNULL(DocumentVersions.RecordDeleted,'N')='N'                                   
--and ISNULL(CR.RecordDeleted,'N')='N'                                     
--and ISNULL(Clients.RecordDeleted,'N')='N'               
--AND ISNULL(PS.RecordDeleted,'N')='N'              
END                                                                                        
END TRY                                                                                                 
--Checking For Errors                                      
BEGIN CATCH                                                   
   DECLARE @Error varchar(8000)                                                                                                                                 
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                      
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RDLCustomRegistrations')                     
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                      
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                                                            
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                               
                                                                                                                                
END CATCH          



GO


