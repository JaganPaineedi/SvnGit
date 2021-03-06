/****** Object:  StoredProcedure [dbo].[csp_RDLCustomMANote]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomMANote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomMANote]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomMANote]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_RDLCustomMANote]
(
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010
)
As

Begin
/************************************************************************/
/* Stored Procedure: csp_RDLCustomMedicationAdministrations				*/
/* Copyright: 2006 Streamline SmartCare									*/
/* Creation Date:  Oct 26, 2007											*/
/*																		*/
/* Purpose: Gets Data for CustomMedicationAdministrations				*/
/*																		*/
/* Input Parameters: DocumentID,Version									*/
/* Output Parameters:													*/
/* Purpose: Use For Rdl Report											*/
/* Calls:																*/
/* Author: Rishu Chopra													*/
/* Modified by: Rupali Patil											*/
/*********************************************************************/

Declare @DisplayMedicalStatus char(1)
Set @DisplayMedicalStatus = ''Y''                     


IF Exists (Select 1 From CustomMedicalStatus Where DocumentVersionId = @DocumentVersionId
				and ([MuscleTics] is null
					and [MuscleInvoluntaryMovement] is null
					and [MuscleRestlessness] is null
					and [MuscleTremorsShaking] is null
					and [MuscleOther] is null
					and [MuscleOther] is null
					and isnull(convert(Varchar(2000), [MuscleOtherText]), '''') = ''''
					and [GaitShuffling] is null
					and [GaitWideBased] is null
					and [GaitFestinating] is null
					and [GaitAtaxia] is null
					and [GaitWeakness] is null
					and [GaitSteady] is null
					and [GaitUnsteady] is null
					and [GaitPropelling] is null
					and [GaitOther] is null
					and isnull(convert(Varchar(2000), [GaitOtherText]), '''') = ''''
					and [SpeechSlurred] is null
					and [SpeechIncomprehensible] is null
					and [SpeechNonVerbal] is null
					and [SpeechDisorganized] is null
					and [SpeechPressured] is null
					and [SpeechAphasic] is null
					and [SpeechOther] is null
					and isnull(convert(Varchar(2000), [SpeechOtherText]), '''') = ''''
					and [PainAching] is null
					and [PainStabbing] is null
					and [PainOther] is null
					and isnull(convert(Varchar(2000), [PainOtherText]), '''') = ''''
					and [ThoughtProcessTangential] is null
					and [ThoughtProcessCircumstantial] is null
					and [ThoughtProcessRacing] is null
					and [ThoughtProcessOther] is null					
					and isnull(convert(Varchar(2000), [ThoughtProcessOtherText]), '''') = ''''
					and [AssociationsLoose] is null
					and [AssociationsFlight] is null
					and [AssociationsOther] is null					
					and isnull(convert(Varchar(2000), [AssociationsOtherText]), '''') = ''''
					and [JudgementPoor] is null
					and [JudgementFair] is null
					and [JudgementGrosslyImpaired] is null					
					and [JudgementDifficultyProblemSolving] is null					
					and [JudgementDifficultyConsequenceActions] is null					
					and [JudgementIncreasedRisk] is null
					and [JudgementOther] is null					
					and isnull(convert(Varchar(2000), [JudgementOtherText]), '''') = ''''
					and [AbnormalThoughtsDelusional] is null 
					and [AbnormalThoughtsImpoverished] is null
					and [AbnormalThoughtsBizarre] is null
					and [AbnormalThoughtsVisual] is null
					and [AbnormalThoughtsAuditory] is null
					and [AbnormalThoughtsGrandiosity] is null
					and [AbnormalThoughtsOthers] is null
					and isnull(convert(Varchar(2000), [AbnormalThoughtsOtherText]), '''') = ''''
					and [OrientationPerson] is null
					and [OrientationPlace] is null
					and [OrientationTime] is null								
					and isnull(convert(Varchar(2000), [OrientationPurposeOtherText]), '''') = ''''
					and isnull([FundOfKnowledgeNormal],''N'') = ''N''					
					and [RRMemoryShortTerm] is null
					and [RRMemoryAbstracting] is null
					and [RRMemorySequencing] is null								
					and [RRMemoryOrganizing] is null								
					and [RRMemoryLongTerm] is null								
					and [RRMemoryPlanning] is null								
					and [RRMemoryThinking] is null			
					and [RRMemoryOther] is null
					and isnull(convert(Varchar(2000), [RRMemoryOtherText]), '''') = ''''
					and [AttentionFollowsDirections] is null
					and [AttentionDistracted] is null
					and [AttentionImpulsive] is null								
					and [AttentionPoorImpulseControl] is null								
					and [AttentionOther] is null								
					and isnull(convert(Varchar(2000), [AttentionOtherText]), '''') = ''''
					and [LanguageRepetitive] is null
					and [LanguageInappropriate] is null
					and [LanguageOther] is null								
					and isnull(convert(Varchar(2000), [LanguageOtherText]), '''') = ''''
					and [MoodAffectAppropriate] is null
					and [MoodAffectEuthymic] is null
					and [MoodAffectRestricted] is null								
					and [MoodAffectBroad] is null								
					and [MoodAffectAlogia] is null								
					and [MoodAffectIrritable] is null								
					and [MoodAffectSad] is null								
					and [MoodAffectTearful] is null								
					and [MoodAffectAnxious] is null								
					and [MoodAffectCooperative] is null								
					and [MoodAffectFlat] is null								
					and [MoodAffectOther] is null								
					and isnull(convert(Varchar(2000), [MoodAffectOtherText]), '''') = ''''
					and [SleepHoursPerDay] is null
					and [SleepDifficultyMaintaining] is null
					and [SleepDifficultyFalling] is null								
					and [SleepNonRestorative] is null								
					and [SleepAbnormal] is null								
					and [SleepNightmares] is null								
					and [SleepOther] is null								
					and isnull(convert(Varchar(2000), [SleepOtherText]), '''') = ''''
					and [AppetiteIncreased] is null
					and [AppetiteDecreased] is null
					and [AppetiteOther] is null								
					and isnull(convert(Varchar(2000), [AppetiteOtherText]), '''') = '''')
					)
	BEGIN 
		SET @DisplayMedicalStatus = ''N''
	END

SELECT	Documents.ClientID
		,BloodPressure
		,Pulse
		,Respiratory
		,Weight
		,Intervention
		,ResponseToIntervention
		,AxisV
		,@DisplayMedicalStatus as DisplayMedicalStatus
FROM Documents
join DocumentVersions as dv on dv.DocumentId = Documents.DocumentId
left Join CustomMedicationAdministrations CMA on CMA.DocumentVersionId = dv.DocumentVersionId and ISNull(CMA.RecordDeleted,''N'') = ''N''    --Modified by Anuj Dated 03-May-2010
where dv.DocumentVersionId = @DocumentVersionId

--Checking For Errors
If (@@error!=0)
	Begin
		RAISERROR  20006   ''csp_RDLCustomMedicationAdministrations : An Error Occured''
		Return
	End
End
' 
END
GO
