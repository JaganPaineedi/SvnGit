/****** Object:  StoredProcedure [dbo].[ssp_SCWebGetCustomAcuteServicesPrescreens]    Script Date: 11/18/2011 16:26:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebGetCustomAcuteServicesPrescreens]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCWebGetCustomAcuteServicesPrescreens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebGetCustomAcuteServicesPrescreens]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N' 
                                                       
Create PROCEDURE [dbo].[ssp_SCWebGetCustomAcuteServicesPrescreens]                                                                                         
(                          
  --@DocumentID int,                                                                                                                                      
  @DocumentVersionId int                                                                     
)                                                                                                
                                                                                                
AS                                                                                      
/***************************************************************************/                                                                                             
/* Stored Procedure: [ssp_SCWebGetCustomAcuteServicesPrescreens] */                                                                                                                                             
/* Creation Date:  26-Feb-2010                */                                                                                                                                                      
/* Purpose: Gets Data [ssp_SCWebGetCustomAcuteServicesPrescreens] */                                                                                                                                                     
/* Input Parameters: @DocumentId,@DocumentVersionId          */                                                                                                                                                    
/* Output Parameters:                   */                                                                                                                                                      
/* Return:  0=success, otherwise an error number                           */                                                                                       
/* Purpose to show the web document for CustomSubstanceUseAssessments    */                                                                                                                                            
/* Author Priya                                  
/* Sahil Bhagat  May 05,2010				Add DocumentBookmark Table                           
   Jitender Kumar Kamboj July 17 2010		Added new table DiagnosesIIICodes   */       
   Damanpreet Kaur Aug 7 2010				Added new table DiagnosesMaxOrder   
   Modified By Rakesh 01 April 2011			Change Columns Name RiskSelfPreviousSelfHarmOutcome                                                                 
											to RiskSelfPreviousSelfHarmOutcomes as datamodel changes */
/* Modified by Aravind 01 JAN 2013			Added  DIIICod.Source in DiagnosesIIICodes and DiagnosisAxisIVShowNone in DiagnosesIV 
											# 276 - Venture Region Support	   */    
/* Modified by Neelima 20 NOV 2014			Added AxisIorII in DiagnosisIAndII As per Customization bugs #110    */      
/* Modified by Vichee  15 MAY 2015          Removed Old diagnosis and Added New Diagnosis SP CWN-Support #344 */                                                                                           
/***************************************************************************/                                                                                                
                                                                                      
BEGIN                                                                                                               
                                                                     
 BEGIN TRY                                                                                      
                            
      --------CustomAcuteServicesPrescreens-------------                                                         
  SELECT [DocumentVersionId]                                      
      ,[DateOfPrescreen]                                      
      ,[InitialCallTime]                                      
      ,[ClientAvailableTimeForScreen]                                      
      ,[DispositionTime]                                      
      ,[ElapsedHours]                                      
      ,[ElapsedMinutes]                                      
      ,[CMHStatus]                                      
      ,[CMHStatusPrimaryClinician]                                      
      ,[CMHCaseNumber]                                      
      ,[ClientName]                                      
      ,[ClientEthnicity]            
      ,[ClientSex]                                      
      ,[ClientMaritalStatus]                                      
      ,[ClientSSN]                  
      ,[ClientDateOfBirth]                                      
      ,[ClientAddress]                                      
      ,[ClientCity]                                      
      ,[ClientState]                                      
      ,[ClientZip]                                      
      ,[ClientCounty]                                      
      ,[ClientHomePhone]                                      
      ,[ClientEmergencyContact]                                      
      ,[ClientRelationship]                                      
      ,[ClientEmergencyPhone]                                      
      ,[ClientGuardianName]                                      
      ,[ClientGuardianPhone]                                      
      ,[PaymentSourceIndigent]                                      
      ,[PaymentSourcePrivate]                                 
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
      ,[MentalStatusInsightLimitedDescribe]                                      
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
      ,[HHMostRecentIPHospitalizationDate]                                      
      ,[HHMostRecentIPHospitalizationFacility]                                      
      ,[HHPreviousOPPsychTreatment]                                      
      ,[HHOPPsychUnableToObtain]                                      
      ,[HHTypeOfService]        
      ,[HHCurrentProviderAndCredentials]                                      
      ,[HHProviderCredentialsUnableToObtain]                                      
      ,[HHDateLastSeenByCurrentProvider]                                      
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
      ,[SummaryAlternativeAppointmentTime]                                      
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
      ,[ClientSignedPaperCopy]                                      
      ,[SummarySummary]                
      ,RiskSelfCurrentSelfHarmOutcome                
      ,RiskSelfPreviousSelfHarmOutcomes                
      ,RiskOthersDestructionOfPropertyDescribe                                        
      ,[RowIdentifier]                                      
      ,[CreatedBy]                                      
      ,[CreatedDate]                                      
      ,[ModifiedBy]                   
      ,[ModifiedDate]                                      
      ,[RecordDeleted]                                      
      ,[DeletedDate]                                      
      ,[DeletedBy]                                      
  FROM [CustomAcuteServicesPrescreens]                         
  WHERE ISNull(RecordDeleted,''N'')=''N'' AND DocumentVersionId=@DocumentVersionId                                                  
                                                                                      
    ---For CustomMedicationHistory Table                                                   
    SELECT [MedicationHistoryId]                                            
      ,[DocumentVersionId]                                            
      ,[MedicationName]                                            
      ,[DosageFrequency]                                            
      ,[Purpose]                                            
      ,[PrescribingPhysician]                                            
      ,[RowIdentifier]                                            
      ,[CreatedBy]                                   
      ,[CreatedDate]                                            
      ,[ModifiedBy]                                            
      ,[ModifiedDate]                                            
      ,[RecordDeleted]                                            
      ,[DeletedDate]                                            
      ,[DeletedBy]                                                
     FROM CustomMedicationHistory where ISNull(RecordDeleted,''N'')=''N'' AND DocumentVersionId=@DocumentVersionId                                                
                                         
--      ----For CustomSUSubstances Table                                                
     SELECT [SUSubstanceId]                                                
      ,[DocumentVersionId]                                                
      ,[SubstanceName]                                                
      ,[Amount]                                                
      ,[Frequency]                                                
      ,[RowIdentifier]                                                
      ,[CreatedBy]                                                
      ,[CreatedDate]                                                
      ,[ModifiedBy]                                                
      ,[ModifiedDate]                                                
      ,[RecordDeleted]                                                
      ,[DeletedDate]                                           
      ,[DeletedBy]                                                
      FROM CustomSUSubstances  where ISNull(RecordDeleted,''N'')=''N'' AND DocumentVersionId=@DocumentVersionId                                                  
               
     exec ssp_SCGetDataDiagnosisNew  @DocumentVersionId                               
                        
   END TRY                                                       
                                                                                       
                                                                                     
 BEGIN CATCH                                               
  DECLARE @Error varchar(8000)                                                                                                         
   SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                                       
   + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''ssp_SCGetWebCustomAcuteServicesPrescreens'')                                                 
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
