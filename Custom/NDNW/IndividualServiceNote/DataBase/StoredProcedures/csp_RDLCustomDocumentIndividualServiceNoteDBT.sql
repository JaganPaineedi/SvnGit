IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentIndividualServiceNoteDBT]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocumentIndividualServiceNoteDBT] 
GO
    
CREATE PROCEDURE [dbo].[csp_RDLCustomDocumentIndividualServiceNoteDBT]  (@DocumentVersionId INT)    
AS    
/********************************************************************************                                                       
--      
-- Copyright: Streamline Healthcare Solutions      
/*    Date        Author            Purpose */
/*   03/02/2015   Bernardin         To get CustomDocumentIndividualServiceNoteDBTs  table vlaues */
    
*********************************************************************************/    
BEGIN TRY    

 SELECT DocumentVersionId,
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

  end try    
  
    
BEGIN CATCH    
 DECLARE @Error VARCHAR(8000)    
    
 SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLCustomDocumentIndividualServiceNoteDBT') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())    
    
 RAISERROR (    
   @Error    
   ,-- Message text.                    
   16    
   ,-- Severity.                    
   1 -- State.                    
   );    
END CATCH 