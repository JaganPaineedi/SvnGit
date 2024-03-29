/****** Object:  StoredProcedure [dbo].[csp_RDLGetDataCustomAcuteServicesPrescreens]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLGetDataCustomAcuteServicesPrescreens]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLGetDataCustomAcuteServicesPrescreens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLGetDataCustomAcuteServicesPrescreens]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_RDLGetDataCustomAcuteServicesPrescreens]                                                    
(                                                            
  @DocumentVersionId int                                  
)                                                            
                                                            
AS                                                  
/***************************************************************************/                                                         
/* Stored Procedure: [csp_RDLGetDataCustomAcuteServicesPrescreens] */                                                                                                         
/* Copyright: 2006 Streamline SmartCare               */                                                                                                                  
/* Creation Date:  14-July-2009                 */                                                                                                                  
/* Purpose: Gets Data [csp_RDLGetDataCustomAcuteServicesPrescreens] */                                                                                                                 
/* Input Parameters: @DocumentVersionId           */                                                                                                                
/* Output Parameters:                   */                                                                                                                  
/* Return:  0=success, otherwise an error number                           */                                                   
/* Purpose to show the RDL of CustomSubstanceUseAssessments    */                                                                                                        
/* Calls:                                                                  */                                                                        
/* Data Modifications:                                                     */                                                                        
/* Updates:                                                                */                                                                        
/* Date                 Author           Purpose        */                                                                        
/* 14-July-2009         Umesh           Created        */             
    
/***************************************************************************/                                                            
                                                  
BEGIN                                                                           
                                 
 BEGIN TRY                                                  
                           
      --------CustomAcuteServicesPrescreens-------------                     
  SELECT casp.[DocumentVersionId]      
      ,Convert(Varchar(10),DateOfPrescreen,101) as [DateOfPrescreen]                  
      ,stuff( right( convert( varchar(26), InitialCallTime, 109 ), 15 ), 7, 7, '' '' ) AS InitialCallTime                           
      ,stuff( right( convert( varchar(26), ClientAvailableTimeForScreen, 109 ), 15 ), 7, 7, '' '' ) AS ClientAvailableTimeForScreen                 
      ,stuff( right( convert( varchar(26), DispositionTime, 109 ), 15 ), 7, 7, '' '' ) AS DispositionTime  
	  ,[ElapsedHours]
	  ,[ElapsedMinutes]    
      ,[CMHStatus]      
      ,S.LastName + '','' + S.FirstName AS [CMHStatusPrimaryClinician]      
      ,[CMHCaseNumber]      
      ,[ClientName]      
      ,[ClientEthnicity]      
      ,[ClientSex]      
      ,[ClientMaritalStatus]      
      ,[ClientSSN]      
      ,Convert(Varchar(10),ClientDateOfBirth,101) as [ClientDateOfBirth]        
      ,[ClientAddress]      
      ,[ClientCity]      
      ,[ClientState]      
      ,[ClientZip]      
      ,C.CountyName AS [ClientCounty]       
      ,[ClientHomePhone]      
      ,[ClientEmergencyContact]      
      ,CodeName as [ClientRelationship]        
      ,[ClientEmergencyPhone]      
      ,[ClientGuardianName]      
      ,[ClientGuardianPhone]      
      ,[PaymentSourceIndigent]        ,[PaymentSourcePrivate]      
      ,[PaymentSourcePrivateEmployer]      
      ,[PaymentSourcePrivateNumber]      
      ,[PaymentSourceMedicare]      
      ,[PaymentSourceMedicareNumber]      
      ,[PaymentSourceMedicaid]      
      ,[PaymentSourceMedicaidNumber]      
      ,[PaymentSourceMedicaidType]      
      ,[PaymentMedicaidOtherCounty]      
      ,[PaymentSourceVA]      
      ,[PaymentSourceOther]      
      ,[PaymentSourceOtherDescribe]      
      ,[PaymentMedicaidVerified]      
      ,[ServiceRequested]      
      ,[ClientRecentLocation]      
      ,[ClientBelongingsLocation]      
      ,[ClientMailLocation]      
      ,[ClientReturnLocation]      
      ,[ClientFromDifferentCounty]      
      ,[ClientPriorLivingArrangement]      
      ,[ClientIsWardofState]      
      ,[ClientIsWardofStateCountyDetail]      
      ,[COFRAdditionalInformation]      
      ,[COFROtherCountyDetail]      
      ,[ReferralSourceName]      
      ,[ReferralSourcePhoneLocation]      
      ,[ReferralSourceContacted]      
      ,[ReferralSourceContactedExplain]      
      ,[ReferralSourceJailLiason]      
      ,[ReferralSourceFamilyMember]      
      ,[ReferralSourcePhysician]      
      ,[ReferralSourceMHProvider]      
      ,[ReferralSourcePetitioned]      
      ,[ReferralSourceOther]      
      ,[ReferralSourceOtherSpecify]      
      ,[ReferralContactTypeFaceToFace]      
      ,[ReferralContactTypePhone]      
      ,[ReferralContactTypePreBooking]      
      ,[ReferralContactTypePostBooking]      
      ,[ReferralPrecipitatingEvents]      
      ,[RiskOthersAAgressiveWithin24Hours]      
      ,[RiskOthersAgressivePast48Hours]      
      ,[RiskOthersAgressiveWithinPast4Weeks]      
      ,[RiskOthersCurrentHomicidalIdeation]      
      ,[RiskOthersCurrentHomicidalActive]      
      ,[RiskOthersCurrentHomicidalWithin48Hours]      
      ,[RiskOthersCurrentHomicidalWithin14Days]      
      ,[RiskOthersAWOL]      
      ,[RiskOthersVerbal]      
      ,[RiskOthersPhysical]      
      ,[RiskOthersSexualActingOut]      
      ,[RiskOthersDestructionOfProperty]      
      ,[RiskOthersHasPlan]      
      ,[RiskOthersHasPlanDescribe]      
      ,[RiskOthersAccessToMeans]      
      ,[RiskOthersAccessToMeansDescribe]      
      ,[RiskOthersVerbalDescribe]      
      ,[RiskOthersPhysicalDescribe]      
      ,[RiskOthersSexualActingOutDescribe]  
	  ,[RiskOthersDestructionOfPropertyDescribe]    
      ,[RiskOthersHistory]      
      ,[RiskOthersChargesPending]      
      ,[RiskOthersChargesPendingDescribe]      
      ,[RiskOthersJailHold]      
      ,[RiskSelfCurrentSuicidalIdeation]      
      ,[RiskSelfCurrentSuicidalActive]      
      ,[RiskSelfCurrentSuicidalWithin48Hours]      
      ,[RiskSelfCurrentSuicidalWithin14Days]      
      ,[RiskSelfHasPlan]      
      ,[RiskSelfHasPlanDescribe]      
      ,[RiskSelfEgoSyntonic]      
      ,[RiskSelfEgoDystonic]      
      ,[RiskSelfEgoDescribe]      
      ,[RiskSelfAccessToMeans]      
      ,[RiskSelfAccessToMeansDescribe]      
      ,[RiskSelfCurrentSelfHarm]      
      ,[RiskSelfCurrentSelfHarmDescribe]      
      ,[RiskSelfCurrentSelfHarmOutcome]
      ,[RiskSelfPreviousSelfHarm]      
      ,[RiskSelfPreviousSelfHarmDescribe]
      ,[RiskSelfFamilySuicideHistory]      
      ,[MentalStatusOrientaionPerson]      
      ,[MentalStatusOrientaionPlace]      
      ,[MentalStatusOrientaionTime]      
      ,[MentalStatusOrientaionCircumstance]      
      ,[MentalStatusLOCAlert]      
      ,[MentalStatusLOCSedate]      
      ,[MentalStatusLOCLethargic]      
      ,[MentalStatusLOCObtunded]      
      ,[MentalStatusLOCOther]      
      ,[MentalStatusLOCOtherDescribe]      
      ,[MentaStatusMoodAppropriate]      
      ,[MentaStatusMoodIncongruent]     
      ,[MentaStatusMoodHostile]      
      ,[MentaStatusMoodTearful]      
      ,[MentaStatusMoodOther]      
      ,[MentaStatusMoodOtherDescribe]      
      ,[MentaStatusAffectRestricted]      
      ,[MentaStatusAffectUnremarkable]      
      ,[MentaStatusAffectExpansive]      
      ,[MentaStatusAffectOther]      
      ,[MentaStatusAffectOtherDescribe]      
      ,[MentaStatusThoughtLucid]      
      ,[MentaStatusThoughtSuspicious]      
      ,[MentaStatusThoughtObsessive]      
      ,[MentaStatusThoughtObsessiveAbout]      
      ,[MentaStatusThoughtTangential]      
      ,[MentaStatusThoughtLoose]      
      ,[MentaStatusThoughtDelusional]      
      ,[MentaStatusThoughtPsychosis]      
      ,[MentaStatusThoughtImpoverished]      
      ,[MentaStatusThoughtConfused]      
      ,[MentaStatusSpeechClear]      
      ,[MentaStatusSpeechRapid]      
      ,[MentaStatusSpeechSlurred]      
      ,[MentaStatusJudgementImpaired]      
      ,[MentaStatusJudgementImpairedDescribe]      
      ,[MentalStatusImpulsivityApparent]      
      ,[MentalStatusImpulsivityApparentDescribe]      
      ,[MentalStatusInsightLimited]      
      ,[MentalStatusPxWithGrooming]      
      ,[MentalStatusSleepDisturbance]      
      ,[MentalStatusSleepDisturbanceDescribe]      
      ,[MentalStatusEatingDisturbance]      
      ,[MentalStatusEatingDisturbanceLbs]      
      ,[MentalStatusNotMedicationComplaint]      
      ,[SUCurrentUse]      
      ,[SUOdorOfSubstance]      
      ,[SUSlurredSpeech]      
      ,[SUWithdrawalSymptoms]      
      ,[SUDTOther]      
      ,[SUOtherDescribe]      
      ,[SUBlackOuts]      
      ,[SURelatedArrests]      
      ,[SURelatedSocialProblems]      
      ,[SUFrequentAbsences]      
      ,[SUCurrentTreatment]      
      ,[SUCurrentTreatmentProvider]      
      ,[SUProviderContactNumber]      
      ,[SUHistory]      
      ,[SUHistorySpecify]      
      ,[SUPreviousTreatment]      
      ,[SUReferralToSA]      
      ,[SUWhereReferred]      
      ,[SUNotReferredBecause]      
      ,[SUToxicologyResults]      
      ,[HHMentalHealthUnableToObtain]      
      ,[HHNumberOfIPPsychHospitalizations]      
      ,CONVERT(VARCHAR(10),[HHMostRecentIPHospitalizationDate],101) AS HHMostRecentIPHospitalizationDate  
      ,[HHMostRecentIPHospitalizationFacility]      
      ,[HHPreviousOPPsychTreatment]      
      ,[HHOPPsychUnableToObtain]      
      ,[HHTypeOfService]      
      ,[HHCurrentProviderAndCredentials]      
      ,[HHProviderCredentialsUnableToObtain]      
      ,CONVERT(VARCHAR(10),[HHDateLastSeenByCurrentProvider],101) AS HHDateLastSeenByCurrentProvider    
      ,[HHPrimaryCareProvider]      
      ,[HHPrimaryCareProviderPhone]      
      ,[HHNoPrimaryCarePhysician]      
      ,[HHAllergies]      
      ,[HHCurrentHealthConcerns]      
      ,[HHPreviousHealthConcerns]      
      ,[SIPsychiatricSymptoms]      
      ,[SIPossibleHarmToSelf]      
      ,[SIPossibleHarmToOthers]      
      ,[SIMedicationDrugComplications]      
      ,[SIDisruptionOfSelfCareAbilities]      
      ,[SIImpairedPersonalAdjustment]      
      ,[SIIntensityOfService]      
      ,[SummaryVoluntary]      
      ,[SummaryInvoluntary]      
      ,[SummaryInpatientFacilityName]      
      ,[AuthorizedDays]      
      ,[SummaryCrisisResidential]      
      ,[SummaryCrisisFacilityName]      
      ,[SummaryPartialHospitalization]      
      ,[SummaryPartialFacilityName]      
      ,[SummaryACT]      
      ,[SummaryCaseManagement]      
      ,[SummaryIOP]      
      ,[SummaryOutpatient]      
      ,[SummarySubstanceAbuse]      
      ,[SummaryOther]      
      ,[SummaryOtherSpecify]      
      ,[SummaryProviderRecommended]      
      ,[SummaryFamilyNotificationOffered]      
      ,[SummaryFamilyMemberName]      
      ,[SummaryInpatientRequestedAndDenied]      
      ,[SummarySecondOpinionRights]      
      ,[SummaryOfferedAlternativeServices]      
      ,[SummaryAlternativeServicesSpecify]      
      ,[SummaryAgreedToAlternativeServices]      
      ,Convert(Varchar(10),SummaryAlternativeAppointmentTime,101) AS SummaryAlternativeAppointmentDate      
      ,stuff( right( convert( varchar(26), SummaryAlternativeAppointmentTime, 109 ), 15 ), 7, 7, '' '' ) AS SummaryAlternativeAppointmentTime      
      ,[SummaryAlternativeAgencyName]      
      ,[SummaryAlternativeAgencyContactNumber]      
      ,[SummaryChooseOtherPlan]      
      ,[SummaryChooseOtherPlanSpecify]      
      ,[SummaryMedicaidRights]      
      ,[SummaryMedicaidRightsWhyNot]      
      ,[SummaryRefusedTreatment]      
      ,[SummaryNoServicesNeeded]      
      ,[SummaryUnableToObtainSignature]      
      ,[SummaryUnableToObtainSignatureReason]      
      ,[SummarySummary] 
	  ,se.[DateOfService]
	  ,se.[EndDateOfService]
	  ,s2.[LastName] + '', ''+ s2.[FirstName] as [ScreeningCompletedBy]     
          
  FROM CustomAcuteServicesPrescreens  CASP      
  Left OUTER JOIN GlobalCodes GC ON  CASP.ClientRelationship = GC.GlobalCodeId        
  LEFT OUTER JOIN Staff S ON CASP.CMHStatusPrimaryClinician = S.StaffId        
  LEFT OUTER JOIN Counties C ON CASP.ClientCounty = C.CountyFIPS 
  Join DocumentVersions dv on dv.DocumentVersionId = casp.DocumentVersionId
  Join Documents d on d.DocumentId = dv.DocumentId
  Join Services se on se.ServiceId = d.ServiceId     
  Join Staff s2 on s2.StaffId = se.ClinicianId
  WHERE ISNull(CASP.RecordDeleted,''N'')=''N'' AND casp.DocumentVersionId = @DocumentVersionId 
  and isnull(dv.RecordDeleted, ''N'')= ''N''
  and isnull(d.RecordDeleted, ''N'')= ''N''
  and isnull(s.RecordDeleted, ''N'')= ''N''
          
                                                   
 END TRY                                                  
 BEGIN CATCH                                                                                                 
  DECLARE @Error varchar(8000)                                                                     
   SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                   
   + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_RDLGetDataCustomAcuteServicesPrescreens'')                                                                                                   
   + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                             
   + ''*****'' + Convert(varchar,ERROR_STATE())                                                                                                  
                                                                                                                  
                                                                                                
   RAISERROR                                                                                                   
   (                                                                                               
    @Error, -- Message text.                                                                                                  
    16, -- Severity.                                                                   
    1 -- State.                                                                                                  
   );                                        
                                                          
 END CATCH                                                              
END
' 
END
GO
