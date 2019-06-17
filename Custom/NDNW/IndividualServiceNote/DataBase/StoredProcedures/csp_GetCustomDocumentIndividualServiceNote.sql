IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetCustomDocumentIndividualServiceNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetCustomDocumentIndividualServiceNote] 
GO
    
CREATE PROCEDURE [dbo].[csp_GetCustomDocumentIndividualServiceNote]  (@DocumentVersionId INT)    
AS    
/********************************************************************************                                                       
--      
-- Copyright: Streamline Healthcare Solutions      
/*    Date        Author            Purpose */
/*   03/02/2015   Bernardin         To get CustomDocumentIndividualServiceNoteGenerals,CustomDocumentIndividualServiceNoteDBTs  table vlaues */
/*   12/22/2017   Veena             modified logic to get the objectives which is related to the selected goals for this document version for New Directions - Support Go Live 735   */
*********************************************************************************/    
BEGIN TRY    

 SELECT DocumentVersionId,
		CreatedBy,
		CreatedDate,
		ModifiedBy,
		ModifiedDate,
		RecordDeleted,
		DeletedBy,
		DeletedDate,
		DBT,
		OQYOQ,
		MotivationalInterviewing,
		EMDR,
		DV,
		TFCBT,
		MoodAffect,
		MoodAffectComments,
		ThoughtProcess,
		ThoughtProcessComments,
		Behavior,
		BehaviorComments,
		MedicalCondition,
		MedicalConditionComments,
		SubstanceAbuse,
		SubstanceAbuseComments,
		SelfHarm,
		SelfHarmIdeation,
		SelfHarmIntent,
		SelfHarmAttempt,
		SelfHarmMeans,
		SelfHarmPlan,
		selfHarmOther,
		SelfHarmOtherComments,
		SelfHarmInformed,
		SelfHarmInformedComments,
		SelfharmComments,
		HarmToOthers,
		HarmToOthersIdeation,
		HarmToOthersIntent,
		HarmToOthersAttempt,
		HarmToOthersMeans,
		HarmToOthersPlan,
		HarmToOthersOther,
		HarmToOthersOtherComments,
		HarmToOthersInformed,
		HarmToOthersInformedComments,
		HarmToOthersComments,
		HarmToProperty,
		HarmToPropertyIdeation,
		HarmToPropertyIntent,
		HarmToPropertyAttempt,
		HarmToPropertyMeans,
		HarmToPropertyPlan,
		HarmToPropertyOther,
		HarmToPropertyOtherComments,
		HarmToPropertyInformed,
		HarmToPropertyInformedComments,
		HarmToPropertyComments,
		SafetyPlanwasReviewed,
		WithOrWithOutClient,
		NextSteps,
		FocusOfTheSession,
		InterventionsProvided,
		ProgressMade,
		Overcome,
		PlanLastService,
		ShowSelectedItem 
 FROM CustomDocumentIndividualServiceNoteGenerals 
 WHERE ISNull(RecordDeleted, 'N') = 'N' AND DocumentVersionId = @DocumentVersionId   
 
 SELECT DocumentVersionId,
		CreatedBy,
		CreatedDate,
		ModifiedBy,
		ModifiedDate,
		RecordDeleted,
		DeletedBy,
		DeletedDate,
		SignificantInvolvement,
		OtherInvolvementDetail,
		WiseMind,
		NonJudgmentalStance,
		ObserveNotice,
		MindfulSkill,
		DescribeWords,
		Effectiveness,
		Participate,
		DearMan,
		FastInterpersonalSkill,
		GiveInterpersonalSkill,
		PleaseEmotionalRegulationSkill,
		PostiveExperience,
		Mastery,
		ActOpposite,
		DistractSkill,
		ProsConsSkill,
		SelfSootheSkill,
		RadicalAcceptance,
		Modeling,
		ImproveMoment,
		AssessingAbilities,
		Instructions,
		BehavioralRehearsal,
		FeedbackCoaching,
		ResponseReinforcement,
		HomeworkAssignment,
		DiscussionSimilarities,
		ReviewDiaryCard,
		BehavioralChainAnalysis 
 FROM CustomDocumentDBTs 
 WHERE ISNull(RecordDeleted, 'N') = 'N' AND DocumentVersionId = @DocumentVersionId 
 
 SELECT IndividualServiceNoteGoalId
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,RecordDeleted
		,DeletedBy
		,DeletedDate
		,DocumentVersionId
		,GoalId
		,GoalNumber
		,GoalText
		,CustomGoalActive
 FROM CustomIndividualServiceNoteGoals
 WHERE ISNull(RecordDeleted, 'N') = 'N' AND DocumentVersionId = @DocumentVersionId 
 
 SELECT IndividualServiceNoteObjectiveId
		,CO.CreatedBy
		,CO.CreatedDate
		,CO.ModifiedBy
		,CO.ModifiedDate
		,CO.RecordDeleted
		,CO.DeletedBy
		,CO.DeletedDate
		,CO.DocumentVersionId
		,CO.GoalId
		,CO.ObjectiveNumber
		,CO.ObjectiveText
		,CO.CustomObjectiveActive
		,CO.[Status]
FROM CustomIndividualServiceNoteObjectives CO join  --modified logic by Veena on 12/22/2017 for New Directions - Support Go Live 735
 CustomIndividualServiceNoteGoals CG on CG.GoalId=CO.Goalid
WHERE ISNull(CO.RecordDeleted, 'N') = 'N' AND CO.DocumentVersionId = @DocumentVersionId and ISNull(CG.RecordDeleted, 'N') = 'N'  and CG.DocumentVersionId = @DocumentVersionId 
  

SELECT     CISND.IndividualServiceNoteDiagnosisId, 
           CISND.CreatedBy, 
           CISND.CreatedDate, 
           CISND.ModifiedBy, 
           CISND.ModifiedDate, 
           CISND.RecordDeleted, 
           CISND.DeletedBy, 
           CISND.DeletedDate, 
           CISND.DocumentVersionId, 
           CISND.DSMCode, 
           CISND.DSMNumber, 
           CISND.DSMVCodeId, 
           CISND.ICD10Code, 
           CISND.ICD9Code, 
           CISND.[Order],
           DICD10.ICDDescription AS [Description]
FROM CustomIndividualServiceNoteDiagnoses CISND INNER JOIN DiagnosisICD10Codes DICD10 ON CISND.DSMVCodeId = DICD10.ICD10CodeId
WHERE ISNull(CISND.RecordDeleted, 'N') = 'N' AND CISND.DocumentVersionId = @DocumentVersionId 

  end try    
  
    
BEGIN CATCH    
 DECLARE @Error VARCHAR(8000)    
    
 SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_GetCustomDocumentIndividualServiceNote') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())    
    
 RAISERROR (    
   @Error    
   ,-- Message text.                    
   16    
   ,-- Severity.                    
   1 -- State.                    
   );    
END CATCH 