/****** Object:  StoredProcedure [dbo].[csp_SCWebGetServiceNoteCustomDocumentMedicationReviewNotes]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCWebGetServiceNoteCustomDocumentMedicationReviewNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCWebGetServiceNoteCustomDocumentMedicationReviewNotes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCWebGetServiceNoteCustomDocumentMedicationReviewNotes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE  [dbo].[csp_SCWebGetServiceNoteCustomDocumentMedicationReviewNotes]
(
 @DocumentVersionId  int
)
As
/******************************************************************************
**  Name: [csp_SCWebGetServiceNoteCustomDocumentMedicationReviewNotes]
**  Desc: This fetches data for Service Note Custom Tables
**
**
**  Return values:
**  Call By:
**  Calls:
**  Parameters:
**  Input       Output
**     ----------      -----------
**  DocumentVersionId    Result Set containing values from Service Note Custom Tables
**
**  Auth: Jagdeep
**  Date: 20-7-11
**  Purpose:
*******************************************************************************
**  Change History
*******************************************************************************
**  Date:    Author:    Description:
**  --------   --------   -------------------------------------------
**  17/07/2012    Jagdeep Hundal    modify CurrentDocumentVersionId to InprogressDocumentVersionId to get client id
**  18/07/2012		T. Remisoski    Revised to correct how client id is retrieved and also minimize possibility of concurrency issues
*******************************************************************************/
BEGIN TRY
DECLARE @ClientId int

SELECT @ClientId = ClientId 
from Documents as d
join dbo.DocumentVersions as dv on dv.DocumentId = d.DocumentId
where dv.DocumentVersionId = @DocumentVersionId

DECLARE @clientName varchar(110)
DECLARE @clientAge int
DECLARE @clientGender varchar(10)
DECLARE @Age varchar(10)
DECLARE @index int
DECLARE @PreviousTreatmentRecommendationsAndOrders varchar(max)
DECLARE @PreviousChangesSinceLastVisit varchar(max)

select @clientName = LastName+'', ''+ FirstName,
	@clientGender = case Sex when ''M'' then ''Male'' else ''Female'' end
from Clients                                                                                       
where ClientId=@ClientID 
and IsNull(RecordDeleted,''N'')=''N''      
          
Exec csp_CalculateAge @ClientId, @Age out     
set @index=(select CHARINDEX('' '', @Age ))    
set @clientAge = substring(@Age,0,@index)      

Select CDMN.[DocumentVersionId]
      ,CDMN.[CreatedBy]
      ,CDMN.[CreatedDate]
      ,CDMN.[ModifiedBy]
      ,CDMN.[ModifiedDate]
      ,CDMN.[RecordDeleted]
      ,CDMN.[DeletedBy]
      ,CDMN.[DeletedDate]
      ,@clientName as [ClientName]
      ,@clientAge as [ClientAge]
      ,@clientGender as [ClientGender]
      ,CDMN.[CurrentMedications]
      ,CDMN.[PreviousTreatmentRecommendationsAndOrders]
      ,CDMN.[PreviousChangesSinceLastVisit]
      ,CDMN.[ChangesSinceLastVisit]
      ,CDMN.[MedicationsPrescribed]
      ,CDMN.[MedEducationSideEffectsDiscussed]
      ,CDMN.[MedEducationAlternativesReviewed]
      ,CDMN.[MedEducationAgreedRegimen]
      ,CDMN.[MedEducationAwareOfSubstanceUseRisks]
      ,CDMN.[MedEducationAwareOfEmergencySymptoms]
      ,CDMN.[TreatmentRecommendationsAndOrders]
      ,CDMN.[OtherInstructions]
      ,CDMN.MoreThan50PercentTimeSpentCounseling

  FROM [CustomDocumentMedicationReviewNotes] CDMN
  WHERE [DocumentVersionId]=@DocumentVersionId
  and ISNull(RecordDeleted,''N'')=''N''
   
--    -----For DiagnosesIII-----
--   SELECT
--  DocumentVersionId
--      ,CreatedBy
--      ,CreatedDate
--      ,ModifiedBy
--      ,ModifiedDate
--      ,RecordDeleted
--      ,DeletedDate
--      ,DeletedBy
-- ,Specification
--   FROM DiagnosesIII
--   WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,''N'')=''N''

--   -----For DiagnosesIV-----
--   SELECT
--  DocumentVersionId
--  ,PrimarySupport
--  ,SocialEnvironment
--  ,Educational
--  ,Occupational
--  ,Housing
--  ,Economic
--  ,HealthcareServices
--  ,Legal
--  ,Other
--  ,Specification
--  ,CreatedBy
--  ,CreatedDate
--  ,ModifiedBy
--  ,ModifiedDate
--  ,RecordDeleted
--  ,DeletedDate
--  ,DeletedBy
--   FROM DiagnosesIV
--   WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,''N'')=''N''
--   -----For DiagnosesV-----
-- SELECT
-- DocumentVersionId
-- ,AxisV
-- ,CreatedBy
-- ,CreatedDate
-- ,ModifiedBy
-- ,ModifiedDate
-- ,RecordDeleted
-- ,DeletedDate
-- ,DeletedBy
-- FROM DiagnosesV
-- WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,''N'')=''N''
-- -----For DiagnosesIAndII-----


--select
--  DIandII.DocumentVersionId
--  ,DIandII.DiagnosisId
--  ,DIandII.Axis
--  ,DIandII.DSMCode
--  ,DIandII.DSMNumber
--  ,DIandII.DiagnosisType
--  ,DIandII.RuleOut
--  ,DIandII.Billable
--  ,DIandII.Severity
--  ,DIandII.DSMVersion
--  ,DIandII.DiagnosisOrder
--  ,DIandII.Specifier
--  ,DIandII.Remission
--  ,DIandII.Source
--  ,DIandII.RowIdentifier
--  ,DIandII.CreatedBy
--  ,DIandII.CreatedDate
--  ,DIandII.ModifiedBy
--  ,DIandII.ModifiedDate
--  ,DIandII.RecordDeleted
--  ,DIandII.DeletedDate
--  ,DIandII.DeletedBy
--  ,DSM.DSMDescription
--  ,case DIandII.RuleOut when ''Y'' then ''R/O'' else '''' end as RuleOutText
--   FROM DiagnosesIAndII  DIandII
--  inner join DiagnosisDSMDescriptions DSM on  DSM.DSMCode = DIandII.DSMCode
--  and DSM.DSMNumber =DIandII.DSMNumber
--   WHERE  DocumentVersionId=@DocumentVersionId   AND ISNULL(RecordDeleted,''N'')=''N''

--  --DiagnosesIIICodes
-- SELECT DIIICod.DiagnosesIIICodeId, DIIICod.DocumentVersionId,DIIICod.ICDCode,DICD.ICDDescription,DIIICod.Billable,DIIICod.CreatedBy,DIIICod.CreatedDate,DIIICod.ModifiedBy,DIIICod.ModifiedDate,DIIICod.RecordDeleted,DIIICod.DeletedDate,DIIICod.DeletedBy



-- FROM    DiagnosesIIICodes as DIIICod inner join DiagnosisICDCodes as DICD on DIIICod.ICDCode=DICD.ICDCode
-- WHERE (DIIICod.DocumentVersionId = @DocumentVersionId) AND (ISNULL(DIIICod.RecordDeleted, ''N'') = ''N'')

-- ---DiagnosesMaxOrder
--   SELECT  top 1 max(DiagnosisOrder) as DiagnosesMaxOrder  ,CreatedBy,ModifiedBy,CreatedDate,ModifiedDate,
--   RecordDeleted,DeletedBy,DeletedDate from  DiagnosesIAndII
--   where DocumentVersionId=@DocumentVersionId
--   and  IsNull(RecordDeleted,''N'')=''N'' group by CreatedBy,ModifiedBy,CreatedDate,ModifiedDate,RecordDeleted,DeletedBy,DeletedDate
--   order by DiagnosesMaxOrder desc
   
   
  --For Mental Status Tab --
     Select DocumentVersionId,
      CreatedBy
      ,CreatedDate
      ,ModifiedBy
      ,ModifiedDate
      ,RecordDeleted
      ,DeletedBy
      ,DeletedDate ,ConsciousnessNA
      ,ConsciousnessAlert
      ,ConsciousnessObtunded
      ,ConsciousnessSomnolent
      ,ConsciousnessOrientedX3
      ,ConsciousnessAppearsUnderInfluence
      ,ConsciousnessComment
      ,EyeContactNA
      ,EyeContactAppropriate
      ,EyeContactStaring
      ,EyeContactAvoidant
      ,EyeContactComment
      ,AppearanceNA
      ,AppearanceClean
      ,AppearanceNeatlyDressed
      ,AppearanceAppropriate
      ,AppearanceDisheveled
      ,AppearanceMalodorous
      ,AppearanceUnusual
      ,AppearancePoorlyGroomed
      ,AppearanceComment
      ,AgeNA
      ,AgeAppropriate
      ,AgeOlder
      ,AgeYounger
      ,AgeComment
      ,BehaviorNA
      ,BehaviorPleasant
      ,BehaviorGuarded
      ,BehaviorAgitated
      ,BehaviorImpulsive
      ,BehaviorWithdrawn
      ,BehaviorUncooperative
      ,BehaviorAggressive
      ,BehaviorComment
      ,PsychomotorNA
      ,PsychomotorNoAbnormalMovements
      ,PsychomotorAgitation
      ,PsychomotorAbnormalMovements
      ,PsychomotorRetardation
      ,PsychomotorComment
      ,MoodNA
      ,MoodEuthymic
      ,MoodDysphoric
      ,MoodIrritable
      ,MoodDepressed
      ,MoodExpansive
      ,MoodAnxious
      ,MoodElevated
      ,MoodComment
      ,ThoughtContentNA
      ,ThoughtContentWithinLimits
      ,ThoughtContentExcessiveWorries
      ,ThoughtContentOvervaluedIdeas
      ,ThoughtContentRuminations
      ,ThoughtContentPhobias
      ,ThoughtContentComment
      ,DelusionsNA
      ,DelusionsNone
      ,DelusionsBizarre
      ,DelusionsReligious
      ,DelusionsGrandiose
      ,DelusionsParanoid
      ,DelusionsComment
      ,ThoughtProcessNA
      ,ThoughtProcessLogical
      ,ThoughtProcessCircumferential
      ,ThoughtProcessFlightIdeas
      ,ThoughtProcessIllogical
      ,ThoughtProcessDerailment
      ,ThoughtProcessTangential
      ,ThoughtProcessSomatic
      ,ThoughtProcessCircumstantial
      ,ThoughtProcessComment
      ,HallucinationsNA
      ,HallucinationsNone
      ,HallucinationsAuditory
,HallucinationsVisual
      ,HallucinationsTactile
      ,HallucinationsOlfactory
      ,HallucinationsComment
      ,IntellectNA
      ,IntellectAverage
      ,IntellectAboveAverage
      ,IntellectBelowAverage
      ,IntellectComment
      ,SpeechNA
      ,SpeechRate
      ,SpeechTone
      ,SpeechVolume
      ,SpeechArticulation
      ,SpeechComment
      ,AffectNA
      ,AffectCongruent
      ,AffectReactive
      ,AffectIncongruent
      ,AffectLabile
      ,AffectComment
      ,RangeNA
      ,RangeBroad
      ,RangeBlunted
      ,RangeFlat
      ,RangeFull
      ,RangeConstricted
      ,RangeComment
      ,InsightNA
      ,InsightExcellent
      ,InsightGood
      ,InsightFair
      ,InsightPoor
      ,InsightImpaired
      ,InsightUnknown
      ,InsightComment
      ,JudgmentNA
      ,JudgmentExcellent
      ,JudgmentGood
      ,JudgmentFair
      ,JudgmentPoor
      ,JudgmentImpaired
      ,JudgmentUnknown
      ,JudgmentComment
      ,MemoryNA
      ,MemoryShortTerm
      ,MemoryLongTerm
      ,MemoryAttention
      ,MemoryComment
       ,BodyHabitusNA
  ,BodyHabitusAverage
  ,BodyHabitusThin
  ,BodyHabitusUnderweight
  ,BodyHabitusOverweight
  ,BodyHabitusObese
  ,BodyHabitusComment
      From CustomDocumentMentalStatuses
      WHERE DocumentVersionId=@DocumentVersionId  AND    ISNULL(RecordDeleted,''N'')=''N''
      
      exec ssp_SCGetDataDiagnosisNew  @DocumentVersionId  


END TRY

BEGIN CATCH
 declare @Error varchar(8000)
 set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_SCWebGetServiceNoteCustomDocumentMedicationReviewNotes'')
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())
    + ''*****'' + Convert(varchar,ERROR_STATE())
 RAISERROR
 (
  @Error, -- Message text.
  16,  -- Severity.
  1  -- State.
 );
END CATCH
' 
END
GO
