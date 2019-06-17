
/****** Object:  StoredProcedure [dbo].[csp_RDLGetDataCustomAcuteServicesPrescreens]   ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLGetDataCustomAcuteServicesPrescreens]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLGetDataCustomAcuteServicesPrescreens]
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLGetDataCustomAcuteServicesPrescreens]  ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create PROCEDURE [dbo].[csp_RDLGetDataCustomAcuteServicesPrescreens]                                                            
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
      ,stuff( right( convert( varchar(26), InitialCallTime, 109 ), 15 ), 7, 7, ' ' ) AS InitialCallTime                                   
      ,stuff( right( convert( varchar(26), ClientAvailableTimeForScreen, 109 ), 15 ), 7, 7, ' ' ) AS ClientAvailableTimeForScreen                         
      ,stuff( right( convert( varchar(26), DispositionTime, 109 ), 15 ), 7, 7, ' ' ) AS DispositionTime          
   ,[ElapsedHours]        
   ,[ElapsedMinutes]            
      ,[CMHStatus]              
      ,S.LastName + ',' + S.FirstName AS [CMHStatusPrimaryClinician]              
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
      ,gc.CodeName as [ClientRelationship]                
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
 --  ,[RiskOthersDestructionOfPropertyDescribe]            
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
   --   ,[RiskSelfCurrentSelfHarmOutcome]        
      ,[RiskSelfPreviousSelfHarm]              
      ,[RiskSelfPreviousSelfHarmDescribe]        
   --   ,[RiskSelfPreviousSelfHarmOutcome]              
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
      ,stuff( right( convert( varchar(26), SummaryAlternativeAppointmentTime, 109 ), 15 ), 7, 7, ' ' ) AS SummaryAlternativeAppointmentTime              
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
   ,s2.[LastName] + ', '+ s2.[FirstName] as [ScreeningCompletedBy]             
   ,[ClientSignedPaperCopy]  
   ,gc1.CodeName as [RiskSuicideHomicidePlanDetails]    
   ,G3.	CodeName AS	[RiskSuicideHomicidePlanAvailability]
,G4.	CodeName AS	[RiskSuicideHomicidePlanTime]
,G5.	CodeName AS	[RiskSuicideHomicidePlanLethalityMethod]
,G6.	CodeName AS	[RiskSuicideHomisideAttempts]
,G7.	CodeName AS	[RiskSuicideHomisideIsolation]
,G8.	CodeName AS	[RiskSuicideHomisideProbabilityTiming]
,G9.	CodeName AS	[RiskSuicideHomisidePrecaution]
,G10.	CodeName AS	[RiskSuicideHomisideActingToGetHelp]
,G11.	CodeName AS	[RiskSuicideHomisideFinalAct]
,G12.	CodeName AS	[RiskSuicideHomisideActiveForAttempt]
,G13.	CodeName AS	[RiskSuicideHomisideSucideNote]
,G14.	CodeName AS	[RiskSuicideHomisideOvertCommunication]
,G15.	CodeName AS	[RiskSuicideHomisideAllegedPurposed]
,G16.	CodeName AS	[RiskSuicideHomisideExpectationFatality]
,G17.	CodeName AS	[RiskSuicideHomisideConceptionOfMethod]
,G18.	CodeName AS	[RiskSuicideHomisideSeriousnessOfAttempt]
,G19.	CodeName AS	[RiskSuicideHomisideAttitudeLivingDying]
,G20.	CodeName AS	[RiskSuicideHomisideMedicalStatus]
,G21.	CodeName AS	[RiskSuicideHomisideConceptMedicalRescue]
,G22.	CodeName AS	[RiskSuicideHomisideDegreePremeditation]
,G23.	CodeName AS	[RiskSuicideHomisideStress]
,G24.	CodeName AS	[RiskSuicideHomisideCopingBehavior]
,G25.	CodeName AS	[RiskSuicideHomisideDepression]
,G26.	CodeName AS	[RiskSuicideHomisideResource]
,G27.	CodeName AS	[RiskSuicideHomisideLifeStyle]
,[RiskSuicideHomisideComments]
,[Recommendations]
,[RiskActionTakenMedicalER]
,[RiskActionTakenPsychiatricPlacement]
,[RiskActionTakenPsychiatricPlacementVoluntary]
,[RiskActionTakenPsychiatricPlacementInVoluntary]
,Ste.SiteName AS [ActionTakenPsychiatricPlacementHospital]
,[RiskActionDirectorsHoldPlaced]
,[RiskActionSecureTransport]
,[RiskActionSecureTransportCompanyName]
,[RiskActionTakenCrisisRespiteBed]
,[RiskActionTakenCrisisRespiteBedWithPsych]
,[RiskActionTakenCrisisRespiteBedWithoutPsych]
,[RiskActionTakenJail]
,[RiskActionSocialDextorBed]
,[RiskSentHomeAlone]
,[RiskSentHomeWithRelative]
,[RiskRefferedToFollowNextDay]
,[RiskReferedToPrivateProvider]
,[RiskReferedToPrivateProviderName]
,[RiskRefferedPyschiatristPMNHP]
,[RiskReferedToOther]
,[RiskReferedToOtherSpecify]
,G28.CodeName as [RiskSuicidePresentingDangersSuicide]
,G29.CodeName as [RiskSuicidePresentingDangersOtherHarmToSelf]
,G30.CodeName as [RiskSuicidePresentingDangersHarmToOthers]
,G31.CodeName as[RiskSuicidePresentingDangersHarmToProperty] 
,[RiskSuicideHomisideTotalScore]
          
  FROM CustomAcuteServicesPrescreens  CASP        
  Join DocumentVersions dv on dv.DocumentVersionId = casp.DocumentVersionId 
  and isnull(dv.RecordDeleted,'N')<>'Y'  and isnull(CASP.RecordDeleted,'N')<>'Y'                 
  Join Documents d on d.DocumentId = dv.DocumentId      
  and isnull(d.RecordDeleted,'N')<>'Y'                       
  Left OUTER JOIN GlobalCodes GC ON  CASP.ClientRelationship = GC.GlobalCodeId 
  Left OUTER JOIN GlobalCodes GC1 ON  CASP.RiskSuicideHomicidePlanDetails = GC1.GlobalCodeId
  Left OUTER JOIN GlobalCodes	G3	 ON CASP.	[RiskSuicideHomicidePlanAvailability]	 = 	G3.GlobalCodeId
 Left OUTER JOIN GlobalCodes	G4	 ON CASP.	[RiskSuicideHomicidePlanTime]	 = 	G4.GlobalCodeId
 Left OUTER JOIN GlobalCodes	G5	 ON CASP.	[RiskSuicideHomicidePlanLethalityMethod]	 = 	G5.GlobalCodeId
 Left OUTER JOIN GlobalCodes	G6	 ON CASP.	[RiskSuicideHomisideAttempts]	 = 	G6.GlobalCodeId
 Left OUTER JOIN GlobalCodes	G7	 ON CASP.	[RiskSuicideHomisideIsolation]	 = 	G7.GlobalCodeId
 Left OUTER JOIN GlobalCodes	G8	 ON CASP.	[RiskSuicideHomisideProbabilityTiming]	 = 	G8.GlobalCodeId
 Left OUTER JOIN GlobalCodes	G9	 ON CASP.	[RiskSuicideHomisidePrecaution]	 = 	G9.GlobalCodeId
 Left OUTER JOIN GlobalCodes	G10	 ON CASP.	[RiskSuicideHomisideActingToGetHelp]	 = G10.GlobalCodeId
 Left OUTER JOIN GlobalCodes	G11	 ON CASP.	[RiskSuicideHomisideFinalAct]	 = 	G11.GlobalCodeId
 Left OUTER JOIN GlobalCodes	G12	 ON CASP.	[RiskSuicideHomisideActiveForAttempt]	 = 	G12.GlobalCodeId
 Left OUTER JOIN GlobalCodes	G13	 ON CASP.	[RiskSuicideHomisideSucideNote]	 = 	G13.GlobalCodeId
 Left OUTER JOIN GlobalCodes	G14	 ON CASP.	[RiskSuicideHomisideOvertCommunication]	 = 	G14.GlobalCodeId
 Left OUTER JOIN GlobalCodes	G15	 ON CASP.	[RiskSuicideHomisideAllegedPurposed]	 = 	G15.GlobalCodeId
 Left OUTER JOIN GlobalCodes	G16	 ON CASP.	[RiskSuicideHomisideExpectationFatality]	 = 	G16.GlobalCodeId
 Left OUTER JOIN GlobalCodes	G17	 ON CASP.	[RiskSuicideHomisideConceptionOfMethod]	 = 	G17.GlobalCodeId
 Left OUTER JOIN GlobalCodes	G18	 ON CASP.	[RiskSuicideHomisideSeriousnessOfAttempt]	 = 	G18.GlobalCodeId
 Left OUTER JOIN GlobalCodes	G19	 ON CASP.	[RiskSuicideHomisideAttitudeLivingDying]	 = 	G19.GlobalCodeId
 Left OUTER JOIN GlobalCodes	G20	 ON CASP.	[RiskSuicideHomisideMedicalStatus]	 = 	G20	.GlobalCodeId
 Left OUTER JOIN GlobalCodes	G21	 ON CASP.	[RiskSuicideHomisideConceptMedicalRescue]	 = 	G21	.GlobalCodeId
 Left OUTER JOIN GlobalCodes	G22	 ON CASP.	[RiskSuicideHomisideDegreePremeditation]	 = 	G22	.GlobalCodeId
 Left OUTER JOIN GlobalCodes	G23	 ON CASP.	[RiskSuicideHomisideStress]	 =	G23	.GlobalCodeId
 Left OUTER JOIN GlobalCodes	G24	 ON CASP.	[RiskSuicideHomisideCopingBehavior]	 = 	G24	.GlobalCodeId
 Left OUTER JOIN GlobalCodes	G25	 ON CASP.	[RiskSuicideHomisideDepression]	 = 	G25	.GlobalCodeId
 Left OUTER JOIN GlobalCodes	G26	 ON CASP.	[RiskSuicideHomisideResource]	 = 	G26	.GlobalCodeId
 Left OUTER JOIN GlobalCodes	G27	 ON CASP.	[RiskSuicideHomisideLifeStyle]	 = 	G27	.GlobalCodeId
 Left OUTER JOIN GlobalCodes	G28	 ON CASP.	[RiskSuicidePresentingDangersSuicide]	 = 	G28	.GlobalCodeId
 Left OUTER JOIN GlobalCodes	G29	 ON CASP.	[RiskSuicidePresentingDangersOtherHarmToSelf]	 = 	G29	.GlobalCodeId
 Left OUTER JOIN GlobalCodes	G30	 ON CASP.	[RiskSuicidePresentingDangersHarmToOthers]	 = 	G30	.GlobalCodeId
 Left OUTER JOIN GlobalCodes	G31	 ON CASP.	[RiskSuicidePresentingDangersHarmToProperty]	 = 	G31	.GlobalCodeId
 Left OUTER JOIN Sites	Ste	 ON CASP.	[ActionTakenPsychiatricPlacementHospital]	 = Ste.SiteId

                    
  LEFT OUTER JOIN Staff S ON CASP.CMHStatusPrimaryClinician = S.StaffId and isnull(s.RecordDeleted, 'N')= 'N'                 
  LEFT OUTER JOIN Counties C ON CASP.ClientCounty = C.CountyFIPS
  left Join Services se on se.ServiceId = d.ServiceId             
  left Join Staff s2 on s2.StaffId = se.ClinicianId        
  WHERE ISNull(CASP.RecordDeleted,'N')='N' AND CASP.DocumentVersionId = @DocumentVersionId                   
                                                           
 END TRY                                                          
 BEGIN CATCH                                                                                                         
  DECLARE @Error varchar(8000)                                                                             
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                           
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RDLGetDataCustomAcuteServicesPrescreens')                                                                                                           
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
GO


