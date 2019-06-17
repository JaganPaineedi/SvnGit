IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentIndividualServiceNoteGeneral]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocumentIndividualServiceNoteGeneral] 
GO
    
CREATE PROCEDURE [dbo].[csp_RDLCustomDocumentIndividualServiceNoteGeneral]  (@DocumentVersionId INT)    
AS    
/********************************************************************************                                                       
--      
-- Copyright: Streamline Healthcare Solutions      
/*    Date        Author            Purpose */
/*   03/02/2015   Bernardin         To get CustomDocumentIndividualServiceNoteGenerals,CustomDocumentIndividualServiceNoteDBTs  table vlaues */
    
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
		PlanLastService  
 FROM CustomDocumentIndividualServiceNoteGenerals 
 WHERE ISNull(RecordDeleted, 'N') = 'N' AND DocumentVersionId = @DocumentVersionId  
  end try    
  
    
BEGIN CATCH    
 DECLARE @Error VARCHAR(8000)    
    
 SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLCustomDocumentIndividualServiceNoteGeneral') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())    
    
 RAISERROR (    
   @Error    
   ,-- Message text.                    
   16    
   ,-- Severity.                    
   1 -- State.                    
   );    
END CATCH 