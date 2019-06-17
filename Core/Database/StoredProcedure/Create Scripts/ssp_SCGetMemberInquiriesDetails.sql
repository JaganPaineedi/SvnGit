/****** Object:  StoredProcedure [dbo].[ssp_SCGetMemberInquiriesDetails]    Script Date: 06/11/2018 03:53:09 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetMemberInquiriesDetails]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetMemberInquiriesDetails]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetMemberInquiriesDetails]   Script Date: 06/11/2018 03:53:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[ssp_SCGetMemberInquiriesDetails]                         
 @inquiryId int                              
as                              
/*********************************************************************/                              
/* Stored Procedure: dbo.ssp_SCGetMemberInquiriesDetails  1015 */                                    
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC */                                    
/* Creation Date:    15-Dec-2011     */                                    
/*       */                                    
/* Purpose:  Used in getdata() for MemberInquiries Detail Page  */                                   
/*       */                                  
/* Input Parameters:     @inquiryId   */                                  
/*       */                                    
/* Output Parameters:   None    */                                    
/*       */                                    
/* Return:  0=success, otherwise an error number                */                                    
/*--------------------------------------------------------------------------------------------------------------*/                                    
/*  Date   Author     Purpose                */                              
/* ------------     -----------------       --------------------------------------------------------------------*/                              
/* 08/Sep/2011  Minakshi Varma   Created                */                              
/* 06/Jan/2012  Sudhir Singh   Updated                */                                        
/* April 13, 2012 Pralyankar Kumar Singh MOdified for Updating Client Information is Inquiries table */                                  
/* 22 jan 2013  Rakesh Garg    Why : for saving Arrival Time incase of Walk in Sub type   */                          
/*07 Aug 2013 katta sharath kumar Pull this sp from Newaygo database from 3.5xMerged with task #3 in Ionia County CMH - Customizations*/                              
/*07 Aug 2013   katta sharath kumar DangerToSelf,DangerToOthers,FamilyNaturalSupports,CommunitySupports,AreasofFunctioning,ActivitiesofDailyLiving,MoodManagement,Thinking,Behavior,SubstanceUse,Trauma,PriorServiceUtilization,Medical,Diagnosis,Recommendations w.r.t task #3 of project  Ionia County CMH - Customizations */                            
/*********************************************************************/                                         
BEGIN                                 
 BEGIN TRY                              
                               
  -- If Inquiry status is InProgress and clientId >0 then Update Inquiries Table with vaues of Inquiries  
   DECLARE @InProgressGlobalCodeId INT            
   SELECT  @InProgressGlobalCodeId = GlobalCodeId FROM    GlobalCodes WHERE   Category = 'INQUIRYSTATUS' AND Code = 'In Progress'
                               
  IF EXISTS(SELECT 1 FROM Inquiries Where InquiryId = @inquiryId AND ClientId >0 AND InquiryStatus = @InProgressGlobalCodeId )                              
  BEGIN                              
   ---- Update Client Information -----                              
   Update CI                               
   SET Ci.MemberFirstName = C.FirstName                               
    , CI.MemberLastName = C.LastName                               
    , CI.MemberMiddleName = C.MiddleName                               
    , CI.SSN = C.SSN                               
    , CI.DateOfBirth = C.DOB                               
    , CI.MemberEmail = C.Email                               
    , CI.LivingArrangement = C.LivingArrangement                               
    , CI.NoOfBeds = C.NumberOfBeds                               
    , CI.CountyOfResidence = C.CountyOfResidence                               
    , CI.CorrectionStatus = C.CorrectionStatus                               
    , CI.EducationalStatus = C.EducationalStatus   --commented by rk                        
    , CI.EmploymentStatus = C.EmploymentStatus                               
    --, CI.Sex = C.Sex                              
                               
   FROM Inquiries CI Inner JOIN Clients C ON CI.ClientId = C.ClientId                               
   WHERE CI.InquiryId = @inquiryId                              
   ------------------------------------------------------------------------                             
                              
   ------ Update Client Address ------------------                              
   Update CI                          
   SET Ci.Address1 = CA.Address                              
    , CI.City = CA.City                               
    , CI.State = CA.State                               
    , CI.ZipCode = CA.Zip                               
   FROM Inquiries CI Inner JOIN ClientAddresses CA ON CI.ClientId = CA.ClientId And CA.AddressType = 90 -- 90 = Home                              
   WHERE CI.InquiryId = @inquiryId                              
   -----------------------------------------------                              
                              
   -- Update Client Episod Informations ----------                              
   UPDATE CI                               
   SET CI.ReferralDate = CE.ReferralDate                               
    , CI.ReferralType = CE.ReferralType                               
    , CI.ReferralSubtype = CE.ReferralSubtype                           
    , CI.ReferralName = CE.ReferralName                               
    , CI.ReferralAdditionalInformation = CE.ReferralAdditionalInformation                               
   FROM Inquiries CI INNER JOIN Clients C ON CI.ClientId = C.ClientId                               
    INNER JOIN ClientEpisodes CE ON CE.ClientId = C.ClientId AND C.CurrentEpisodeNumber = CE.EpisodeNumber                               
   WHERE CI.InquiryId = @inquiryId                              
   -----------------------------------------------                              

   -- Update Inquiries                              
  END                              
  -------------------------------------------------------------------------------                              
          
                
  SELECT Inquiries.[InquiryId]                                        
   , Inquiries.[CreatedBy]                                        
   , Inquiries.[CreatedDate]                                        
   , Inquiries.[ModifiedBy]                                        
   , Inquiries.[ModifiedDate]                                
   , Inquiries.[RecordDeleted]                                        
   , Inquiries.[DeletedBy]                                        
   , Inquiries.[DeletedDate]                                        
   , Inquiries.[ClientId]                                        
   , Inquiries.[InquirerFirstName]                                        
   , Inquiries.[InquirerMiddleName]                                        
   , Inquiries.[InquirerLastName]                                   
   , Inquiries.[InquirerRelationToMember]                                        
   , Inquiries.[InquirerPhone]                                        
   , Inquiries.[InquirerPhoneExtension]                                        
   , Inquiries.[InquirerEmail]                                        
   , convert(varchar(10),Inquiries.[InquiryStartDateTime],101) as InquiryStartDate                                    
   ,/*convert(varchar(5),Inquiries.[InquiryStartDateTime],114)*/                       
   /*right(convert(VARCHAR(20),Inquiries.[InquiryStartDateTime],0),7) as InquiryStartTime */                              
   ltrim(substring(rtrim(right(CONVERT(VARCHAR(26), Inquiries.[InquiryStartDateTime], 100),7)),0,6)+ ' '+right(CONVERT(VARCHAR(26), Inquiries.[InquiryStartDateTime], 109),2))  as InquiryStartTime                                   
   , Inquiries.[InquiryStartDateTime]                                   
   , InquiryEventId -- This field added By pralyankar On Jan 11, 2012                                 
   , Inquiries.[MemberFirstName]                                        
   , Inquiries.[MemberMiddleName]                                        
   , Inquiries.[MemberLastName]                                        
   , Inquiries.[SSN]                                  
   , Inquiries.Sex                               
   , Inquiries.[DateOfBirth]                               
   , Inquiries.[MemberPhone]                                        
   , Inquiries.[MemberCell]                                        
   , Inquiries.[MemberEmail]                                        
   , Inquiries.[MaritalStatus]                                        
   , Inquiries.[Address1]                                        
   , Inquiries.[Address2]                                        
   , Inquiries.[City]                                        
   , Inquiries.[State]                                         
   , Inquiries.[ZipCode]                                        
   ---- Below Line written By Pralyankar On Jan 12, 2012 ---                              
   ---[dbo].[GetMedicaidId](Inquiries.[clientid]) -- Inquiries.[MedicaidId]   This column will be removed from the Datamodel.                               
   , Inquiries.[MedicaidId] ---added by Sudhir Singh                              
   ------------------------------------------------------------                                
   ,Clients.CareManagementId as [MasterId]                                       
   ,Inquiries.[PresentingProblem]                                        
   ,Inquiries.[UrgencyLevel]                                        
   ,Inquiries.[InquiryType]                                        
   ,Inquiries.[ContactType]                                        
   ,Inquiries.[Location]                                        
   ,Inquiries.[ClientCanLegalySign]                                        
   ,Inquiries.[EmergencyContactFirstName]                                        
   ,Inquiries.[EmergencyContactMiddleName]                                        
   ,Inquiries.[EmergencyContactLastName]                                        
   ,Inquiries.[EmergencyContactRelationToClient]                                        
   ,Inquiries.[EmergencyContactHomePhone]                                     
   ,Inquiries.[EmergencyContactCellPhone]                                        
   ,Inquiries.[EmergencyContactWorkPhone]                                        
   ,Inquiries.[PopulationDD]                                           
   ,Inquiries.[SAType]                                        
   ,Inquiries.[PrimarySpokenLanguage]                                                                               
   ,Inquiries.[Pregnant]                                                      
   ,Inquiries.[InjectingDrugs]                                 
   ,Inquiries.[RecordedBy]                                        
   ,Inquiries.[GatheredBy]                                        
   ,Inquiries.[ProgramId]                                        
   ,Inquiries.[GatheredByOther]                                        
   ,Inquiries.[DispositionComment]                                        
   ,Inquiries.[InquiryDetails]                          
   ,convert(varchar(10),Inquiries.[InquiryEndDateTime],101) as InquiryEndDate                                    
   /*convert(varchar(5),Inquiries.[InquiryEndDateTime],114) as InquiryEndTime */                              
   /*right(convert(VARCHAR(20),Inquiries.[InquiryEndDateTime],0),7) as InquiryEndTime  */                    
   ,ltrim(substring(rtrim(right(CONVERT(VARCHAR(26), Inquiries.[InquiryEndDateTime], 100),7)),0,6)+ ' '+right(CONVERT(VARCHAR(26), Inquiries.[InquiryEndDateTime], 109),2)) as  InquiryEndTime                                       
   ,Inquiries.[InquiryEndDateTime]                                        
   ,Inquiries.[InquiryStatus]                                        
   ,Inquiries.[ReferralDate]                                        
   ,Inquiries.[ReferralType]                                        
   ,Inquiries.[ReferralSubtype]                                        
   ,Inquiries.[ReferralName]                              
   ,Inquiries.[ReferralAdditionalInformation]                              
   ,Inquiries.[Living]                              
   ,Inquiries.[NoOfBeds]                              
   ,Inquiries.[CountyOfResidence]                     
   ,Inquiries.[CorrectionStatus]                              
   ,Inquiries.[EducationalStatus]                                        
   ,Inquiries.[EmploymentStatus]                                        
   ,Inquiries.[AssignedToStaffId]                                        
   ,Inquiries.[GuardianSameAsCaller]                                        
   ,Inquiries.[GuardianFirstName]                                        
   ,Inquiries.[GuardianLastName]                                        
   ,Inquiries.[GuardianPhoneNumber]                                        
   ,Inquiries.[GuardianPhoneType]                                        
   ,Inquiries.[GuardianDOB]                            
   ,Inquiries.[GuardianRelation]                                        
   ,Inquiries.[EmergencyContactSameAsCaller]                                
   ,Inquiries.[MemberCell]                                
   ,Inquiries.[GuardianDPOAStatus]                                
   ,Inquiries.[GuardianComment]      
   ,Inquiries.[SSNUnknown]                              
   ,Inquiries.[InquiryStatus] AS DefaultInquiryStatus                             
   ,Inquiries.[MemberPhoneExtension]                              
	,Inquiries.RiskAssessmentCrisisInformation                          
	,Inquiries.ReferalOrganizationName                           
	,Inquiries.ReferalPhone                           
	,Inquiries.ReferalFirstName                
	,Inquiries.ReferalLastName                           
	,Inquiries.ReferalAddressLine1                          
	,Inquiries.ReferalAddressLine2                          
	,Inquiries.ReferalCity                          
	,Inquiries.ReferalState                          
	,Inquiries.ReferalZip                          
	,Inquiries.ReferalEmail                          
	,Inquiries.ReferalComments                          
	,Inquiries.PopulationDDClientSeeking        
	,Inquiries.PopulationAutism                          
	,Inquiries.PopulationMH                          
	,Inquiries.PopulationSUD                          
	,Inquiries.PopulationAutismClientSeeking                          
	,Inquiries.PopulationMHClientSeeking                          
	,Inquiries.PopulationSUDClientSeeking                          
	,Inquiries.DispositionWaitListInformation                     
	,Inquiries.Homeless                            
	,Inquiries.RiskAssessmentInDanger                          
	,Inquiries.RiskAssessmentInDangerComment                          
	,Inquiries.RiskAssessmentCounselorAvailability                          
	,Inquiries.RiskAssessmentCounselorAvailabilityComment                          
	,Inquiries.RiskAssessmentCrisisLine                          
	,Inquiries.RiskAssessmentCrisisLineComment   
	             
	--Added by rk   -------------------                  
	,Inquiries.CoverageInformation                  
	,Inquiries.Active                
	,Inquiries.Prefix                
	,Inquiries.Suffix                
	,Inquiries.PrimaryClinicianId                
	,Inquiries.Comment                
	,Inquiries.LivingArrangement                
	,Inquiries.FinanciallyResponsible                
	,Inquiries.AnnualHouseholdIncome                
	,Inquiries.NumberOfDependents                
	,Inquiries.EmploymentStatus                
	,Inquiries.EmploymentInformation                
	,Inquiries.MilitaryStatus                      
	,Inquiries.DoesNotSpeakEnglish                
	,Inquiries.PrimaryLanguage                
	,Inquiries.HispanicOrigin                
	,Inquiries.DeceasedOn                
	,Inquiries.ReminderPreference                
	,Inquiries.MobilePhoneProvider                
	,Inquiries.SchedulingPreferenceMonday                
	,Inquiries.SchedulingPreferenceTuesday                
	,Inquiries.SchedulingPreferenceWednesday                
	,Inquiries.SchedulingPreferenceThursday                
	,Inquiries.SchedulingPreferenceFriday                
	,Inquiries.GeographicLocation                
	,Inquiries.SchedulingComment                
	,Inquiries.CauseOfDeath                
	,Inquiries.GenderIdentity                
	,Inquiries.SexualOrientation                
	,Inquiries.PrimaryPhysicianId                
	,Inquiries.ProfessionalSuffix                
	,Inquiries.PriorityPopulation      
	,Inquiries.CountyOfTreatment       
	,Ltrim(Rtrim(CF.CountyName)) + ' - ' + Ss.StateAbbreviation as CountyOfTreatmentText    
   
	-- Added by rk  End -------------------                             
	, A.RegistrationDate                           
	,A.EpisodeNumber                            
	,A.Status as 'EpisodeStatus'                          
	, A.DischargeDate   
	,Inquiries.PreferredGenderPronoun                           
	                         
  FROM Inquiries                                
   LEFT JOIN Clients ON  Inquiries.[ClientId] = Clients.ClientId                                
   Left JOIN clientepisodes A ON A.ClientId = Clients.ClientId And A.EpisodeNumber = Clients.CurrentEpisodeNumber   
   left join Counties CF on CF.CountyFIPS =Inquiries.CountyOfTreatment-- C.CountyOfTreatment    
   left join States Ss on Ss.StateFIPs = CF.StateFIPs                                  
                             
  WHERE InquiryId = @inquiryId                                
                                
                                
  SELECT [InquiryDispositionId]                              
   ,[CreatedBy]                              
   ,[CreatedDate]                              
   ,[ModifiedBy]                              
   ,[ModifiedDate]                              
   ,[RecordDeleted]                              
   ,[DeletedBy]                              
   ,[DeletedDate]                              
   ,[InquiryId]                              
   ,[Disposition]                              
  FROM [InquiryDispositions]                              
 WHERE InquiryId=@inquiryId                              
  AND ISNULL([InquiryDispositions].RecordDeleted,'N')<>'Y'                              
                                
  SELECT [InquiryServiceDispositionId]                              
   ,[InquiryServiceDispositions].[CreatedBy]                              
   ,[InquiryServiceDispositions].[CreatedDate]                              
   ,[InquiryServiceDispositions].[ModifiedBy]                              
   ,[InquiryServiceDispositions].[ModifiedDate]                              
   ,[InquiryServiceDispositions].[RecordDeleted]                              
   ,[InquiryServiceDispositions].[DeletedBy]                              
   ,[InquiryServiceDispositions].[DeletedDate]                              
   ,[InquiryServiceDispositions].[ServiceType]                              
   ,[InquiryServiceDispositions].[InquiryDispositionId]                              
  FROM [InquiryServiceDispositions]                              
   inner join [InquiryDispositions]                              
   on [InquiryServiceDispositions].[InquiryDispositionId]=[InquiryDispositions].InquiryDispositionId                              
  where [InquiryDispositions].InquiryId=@inquiryId                              
   AND ISNULL([InquiryServiceDispositions].RecordDeleted,'N')<>'Y'                              
   AND ISNULL([InquiryDispositions].RecordDeleted,'N')<>'Y'                   
                              
  SELECT [InquiryProviderServices].[InquiryProviderServiceId]                              
   ,[InquiryProviderServices].[CreatedBy]                              
   ,[InquiryProviderServices].[CreatedDate]                              
   ,[InquiryProviderServices].[ModifiedBy]                              
   ,[InquiryProviderServices].[ModifiedDate]                              
   ,[InquiryProviderServices].[RecordDeleted]                              
   ,[InquiryProviderServices].[DeletedBy]                              
   ,[InquiryProviderServices].[DeletedDate]                              
   ,[InquiryProviderServices].[ProgramId]                              
   ,[InquiryProviderServices].[InquiryServiceDispositionId]                              
  FROM [InquiryProviderServices]                 
   inner join [InquiryServiceDispositions] on [InquiryProviderServices].InquiryServiceDispositionId=[InquiryServiceDispositions].InquiryServiceDispositionId                              
   inner join [InquiryDispositions]on [InquiryServiceDispositions].[InquiryDispositionId]=[InquiryDispositions].InquiryDispositionId                              
  where [InquiryDispositions].InquiryId=@inquiryId                              
   AND ISNULL([InquiryProviderServices].RecordDeleted,'N')<>'Y'                              
   AND ISNULL([InquiryServiceDispositions].RecordDeleted,'N')<>'Y'                              
   AND ISNULL([InquiryDispositions].RecordDeleted,'N')<>'Y'                               
                             
   Select InquiryCoverageInformationId                          
  ,CreatedBy                                 
  ,CreatedDate                                 
  ,ModifiedBy                                 
  ,ModifiedDate                                
  ,RecordDeleted                              
  ,DeletedBy                                 
  ,DeletedDate                                 
  ,InquiryId                                 
  ,CoveragePlanId                                  
  ,InsuredId                                 
  ,GroupId                                  
  ,Comment                           
  ,NewlyAddedplan                                 
    FROM InquiryCoverageInformations WHERE InquiryId=@inquiryId  AND ISNULL(RecordDeleted,'N')<>'Y'                        
                              
    Select CoveragePlanId,DisplayAs FROM CoveragePlans             
          
    Exec [ssp_InquirySCGetClientRaces] @inquiryId     
    
    
      --CustomInquiries          
  SELECT [InquiryId]          
      ,[CreatedBy]          
      ,[CreatedDate]          
      ,[ModifiedBy]          
      ,[ModifiedDate]          
      ,[RecordDeleted]          
      ,[DeletedDate]          
      ,[DeletedBy]              
  FROM [dbo].[CustomInquiries]          
  WHERE     (InquiryId = @InquiryId) AND  ISNULL(RecordDeleted, 'N') = 'N' 
                   
                                      
   END TRY                                
 BEGIN CATCH                                     
 DECLARE @Error varchar(8000)                                      
    SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                       
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCGetMemberInquiriesDetails')                                         
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                        
    + '*****' + Convert(varchar,ERROR_STATE())                                      
                                     
    RAISERROR                                       
    (                                        
  @Error, -- Message text.                                      
  16, -- Severity.                                      
  1 -- State.                                      
    );                                   
 End CATCH                                         
End 