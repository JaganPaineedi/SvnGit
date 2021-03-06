/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDocumentCrisisInterventionNote]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentCrisisInterventionNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocumentCrisisInterventionNote]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentCrisisInterventionNote]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

create PROCEDURE   [dbo].[csp_RDLCustomDocumentCrisisInterventionNote]
(
@DocumentVersionId  int 
)
AS

/*********************************************************************************************/
/* Updates
Date			Author					Purpose
3/Aug/2012		Jagdeep			Task No. 1851 - Harbor Go Live (To handle 2nd version exception in case of RDL)
Nov/13/2015     Hemant Kumar    Added Ser.OtherPersonsPresent to show the Other persons present on PDFs 
                                (A Renewed Mind - Support #386)
                                
 Feb/2/2017     Vijeta         Incresed the lenght of Service Unit 5 to 20 while converting it to varchar 
                               (A Renewed Mind - Support #581)
*/
/*********************************************************************************************/
Begin

BEGIN TRY

SELECT  SystemConfig.OrganizationName,
  C.LastName + '', '' + C.FirstName as ClientName,
  Documents.ClientID,
  CONVERT(VARCHAR(10), DOCUMENTS.EffectiveDate, 101) as EffectiveDate,
  S.FirstName + '' '' + S.LastName+ '','' +'' ''+ ISNull(GC.CodeName,'''') as ClinicianName,   
  --CASE DS.VerificationMode 
  --WHEN ''P'' THEN
  --''''
  --WHEN ''S'' THEN 
  --(SELECT PhysicalSignature FROM DocumentSignatures DS WHERE dv.DocumentId=DS.DocumentId) 
  --END as [Signature],
  --CONVERT(VARCHAR(10), DS.SignatureDate, 101) as SignatureDate,
  LTRIM(RIGHT(CONVERT(VARCHAR(20), SE.DateOfService, 100), 7)) as BeginTime,
     --convert(varchar(5),(SE.EndDateOfService-SE.DateOfService),108) +'' ''+ GC2.CodeName  as Duration,
     convert(varchar(20),SE.Unit)+'' ''+GC2.CodeName  as Duration,
     --DS.VerificationMode as VerificationStyle,
        GC3.CodeName  as ReferralExternalServicesType,
        GC4.CodeName as ReferralHarborServicesType,
        CDCI.PresentingCrisisImmediateNeeds,        
        CDCI.UseOfAlcholDrugsImpactingCrisis,
        CDCI.CrisisInThePast,
        CDCI.CrisisInThePastHowPreviouslyStabilized,
        CDCI.CrisisInThePastIssuesSinceStabilization,
        CDCI.PastAttemptsHarmNone,
        CDCI.PastAttemptsHarmSelf,
        CDCI.PastAttemptsHarmOthers,
        CDCI.PastAttemptsHarmComment,
        CDCI.CurrentRiskHarmSelf,
        CDCI.CurrentRiskHarmSelfComment,
        CDCI.CurrenRiskHarmOthers,
        CDCI.CurrentRiskHarmOthersComment,
        CDCI.MedicalConditionsImpactingCrisis,
        CDCI.ClientCurrentlyPrescribedMedications,
        CDCI.ClientComplyingWithMedications,
        CDCI.CurrentLivingSituationAndSupportSystems,
        CDCI.ClientStrengthsDealingWithCrisis,
        CDCI.CrisisDeEscalationInterventionsProvided,
        CDCI.CrisisPlanTreatmentRecommended,
        CDCI.WishesPreferencesOfIndividual,
        CDCI.ReferredVoluntaryHospitalization,
        CDCI.ReferredInvoluntaryHospitalization,
        CDCI.ReferralHarborServicesComment,
        CDCI.ReferralExternalServicesComment,
        CDCI.FollowUpInstructions,
        CDCI.CrisisWasResolved,
        CDCI.PlanToAvoidCrisisRecurrence,
        CDMS.ConsciousnessAlert,
        CDMS.ConsciousnessObtunded,
        CDMS.ConsciousnessSomnolent,
        CDMS.ConsciousnessOrientedX3,
        CDMS.ConsciousnessAppearsUnderInfluence,
        CDMS.ConsciousnessComment,
        CDMS.EyeContactAppropriate,
        CDMS.EyeContactStaring,
        CDMS.EyeContactAvoidant,
        CDMS.EyeContactComment,
        CDMS.AppearanceClean,
        CDMS.AppearanceNeatlyDressed,
        CDMS.AppearanceAppropriate,
        CDMS.AppearanceDisheveled,
        CDMS.AppearanceMalodorous,
        CDMS.AppearanceUnusual,
        CDMS.AppearancePoorlyGroomed,
        CDMS.AppearanceComment,
        CDMS.AgeAppropriate,
        CDMS.AgeOlder,
        CDMS.AgeYounger,
        CDMS.AgeComment,
        CDMS.BehaviorPleasant,
        CDMS.BehaviorGuarded,
        CDMS.BehaviorAgitated,
        CDMS.BehaviorImpulsive,
        CDMS.BehaviorWithdrawn,
        CDMS.BehaviorUncooperative,
        CDMS.BehaviorAggressive,
        CDMS.BehaviorComment,
        CDMS.PsychomotorNoAbnormalMovements,
        CDMS.PsychomotorAgitation,
        CDMS.PsychomotorAbnormalMovements,
        CDMS.PsychomotorRetardation,
        CDMS.PsychomotorComment,
        CDMS.MoodEuthymic,
        CDMS.MoodDysphoric,
        CDMS.MoodIrritable,
        CDMS.MoodDepressed,
        CDMS.MoodExpansive,
        CDMS.MoodAnxious,
        CDMS.MoodElevated,
        CDMS.MoodComment,
        CDMS.ThoughtContentWithinLimits,
        CDMS.ThoughtContentExcessiveWorries,
        CDMS.ThoughtContentOvervaluedIdeas,
        CDMS.ThoughtContentRuminations,
        CDMS.ThoughtContentPhobias,
        CDMS.ThoughtContentComment,
        CDMS.DelusionsNone,
        CDMS.DelusionsBizarre,
        CDMS.DelusionsReligious,
        CDMS.DelusionsGrandiose,
        CDMS.DelusionsParanoid,
        CDMS.DelusionsComment,
        CDMS.ThoughtProcessLogical,
        CDMS.ThoughtProcessCircumferential,
        CDMS.ThoughtProcessFlightIdeas,
        CDMS.ThoughtProcessIllogical,
        CDMS.ThoughtProcessDerailment,
        CDMS.ThoughtProcessTangential,
        CDMS.ThoughtProcessSomatic,
        CDMS.ThoughtProcessCircumstantial,
        CDMS.ThoughtProcessComment,
        CDMS.HallucinationsNone,
        CDMS.HallucinationsAuditory,
        CDMS.HallucinationsVisual,
        CDMS.HallucinationsTactile,
        CDMS.HallucinationsOlfactory,
        CDMS.HallucinationsComment,
        CDMS.IntellectAverage,
        CDMS.IntellectAboveAverage,
        CDMS.IntellectBelowAverage,
        CDMS.IntellectComment,
        CDMS.SpeechRate,
        CDMS.SpeechTone,
        CDMS.SpeechVolume,
        CDMS.SpeechArticulation,
        CDMS.SpeechComment,
        CDMS.AffectCongruent,
        CDMS.AffectReactive,
        CDMS.AffectIncongruent,
        CDMS.AffectLabile,
        CDMS.AffectComment,
        CDMS.RangeBroad,
        CDMS.RangeBlunted,
        CDMS.RangeFlat,
        CDMS.RangeFull,
        CDMS.RangeConstricted,
        CDMS.RangeComment,
        CDMS.InsightExcellent,
        CDMS.InsightGood,
        CDMS.InsightFair,
        CDMS.InsightPoor,
        CDMS.InsightImpaired,
        CDMS.InsightUnknown,
        CDMS.InsightComment,
        CDMS.JudgmentExcellent,
        CDMS.JudgmentGood,
        CDMS.JudgmentFair,
        CDMS.JudgmentPoor,
        CDMS.JudgmentImpaired,
        CDMS.JudgmentUnknown,
        CDMS.JudgmentComment,
        CDMS.MemoryShortTerm,
        CDMS.MemoryLongTerm,
        CDMS.MemoryAttention,
        CDMS.MemoryComment,
        CDMS.BodyHabitusAverage,
        CDMS.BodyHabitusThin,
        CDMS.BodyHabitusUnderweight,
        CDMS.BodyHabitusOverweight,
        CDMS.BodyHabitusObese,
        CDMS.BodyHabitusComment,
        SE.OtherPersonsPresent             
FROM [CustomDocumentCrisisInterventionNotes] CDCI
join DocumentVersions as dv on dv.DocumentVersionId = CDCI.DocumentVersionId
join CustomDocumentMentalStatuses CDMS on CDMS.DocumentVersionId=CDCI.DocumentVersionId 
join Documents ON  Documents.DocumentId = dv.DocumentId
join Staff S on Documents.AuthorId= S.StaffId 
join Clients C on Documents.ClientId= C.ClientId 
Left Join GlobalCodes GC On S.Degree=GC.GlobalCodeId 
left join Services SE on Documents.ServiceId=SE.ServiceId 
left join GlobalCodes GC2 on SE.UnitType = GC2.GlobalCodeId  
--left join DocumentSignatures DS on dv.DocumentId=DS.DocumentId
left join GlobalCodes GC3 on CDCI.ReferralExternalServicesType=GC3.GlobalCodeId 
left join GlobalCodes GC4 on CDCI.ReferralHarborServicesType=GC4.GlobalCodeId 
left join Locations L on SE.LocationId=L.LocationId
Cross Join SystemConfigurations as SystemConfig
where CDCI.DocumentVersionId=@DocumentVersionId 
and isnull(Documents.RecordDeleted,''N'')=''N''
and isnull(S.RecordDeleted,''N'')=''N''
and isnull(C.RecordDeleted,''N'')=''N''
and isNull(GC.RecordDeleted,''N'')=''N''
and isNull(GC.RecordDeleted,''N'')=''N''
and isNull(GC2.RecordDeleted,''N'')=''N''
--and isNull(DS.RecordDeleted,''N'')=''N''
and isNull(GC3.RecordDeleted,''N'')=''N''
and isNull(GC4.RecordDeleted,''N'')=''N''


END TRY

BEGIN CATCH

   DECLARE @Error VARCHAR(8000)       
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + ''*****'' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                            
   + ''*****'' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),''csp_RDLCustomDocumentCrisisInterventionNote'')                                                                                             
   + ''*****'' + CONVERT(VARCHAR,ERROR_LINE()) + ''*****'' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                              
   + ''*****'' + CONVERT(VARCHAR,ERROR_STATE())
  RAISERROR
  (
   @Error, -- Message text.
   16,  -- Severity.
   1  -- State.
  );
END CATCH
End
' 
END
GO
