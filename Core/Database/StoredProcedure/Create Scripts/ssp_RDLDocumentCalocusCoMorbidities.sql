IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLDocumentCalocusCoMorbidities]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLDocumentCalocusCoMorbidities] 
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_RDLDocumentCalocusCoMorbidities] (@DocumentVersionId INT)
AS
/***********************************************************************************/
/* Stored Procedure: [ssp_RDLDocumentCalocusCoMorbidities]         */
/* Creation Date:  Dec 1 ,2018                                                    */
/* Purpose: RDL Data from DocumentCALOCUS	   */
/* Input Parameters: @DocumentVersionId                                            */
/* Purpose: Use For Rdl Report                                                     */
/* Author: Bibhu		*/
/* What : created Report for DocumentCALOCUS					*/
/* whay : Task #21 	MHP - Enhancements                            */
/*******************************************************************************************************************************/

BEGIN
	BEGIN TRY

   
   SELECT    
	DC.DocumentVersionId	
	,DC.NoEvidenceOfMedicalIllness
	,DC.PastMedicalSubstanceUse
	,DC.MinimalDevelopmentalDelayDisorder
	,DC.SelfLimitedMedicalConditions
	,DC.OccasionalSelfLimitedEpisodes
	,DC.TransientOccasionalStressRelated
	,DC.DevelopmentalDisabilityIsPresentThat
	,DC.MedicalConditionsArePresentRequiring
	,DC.MedicalConditionsArePresentAdversely
	,DC.SubstanceAbuseSignificantAdverseEffect
	,DC.RecentSubstanceUseThatHasSignificantImpact
	,DC.PsychiatricSignsAndSymptomsArePresent
	,DC.MedicalConditionsArePresentRequireMonitoring
	,DC.MedicalConditionsArePresentAffecting
	,DC.UncontrolledSubstanceUsePresentSeriousThreat
	,DC.DevelopmentalDelayOrDisorderSignificantlyAlters
	,DC.PsychiatricSymptomsPresentClearlyImpairFunctioning
	,DC.SignificantMedicalConditionIsPresent
	,DC.MedicalConditionAcutelyChronicallyWorsens
	,DC.SubstanceDependencePresentWithInability
	,DC.DevelopmentalDisorderPresentComplicates
	,DC.AcuteSeverePsychiatricSymptomsPresent
	,DC.CoMorbidityScore
	FROM DocumentCALOCUS DC
    INNER JOIN Documents D ON D.InProgressDocumentVersionId=DC.DocumentVersionId     
	WHERE  DC.DocumentVersionId=@DocumentVersionId 
		AND ISNULL(DC.RecordDeleted, 'N') = 'N'
		AND ISNULL(D.RecordDeleted, 'N') = 'N'
	  
		
		
  END TRY  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLDocumentCalocusCoMorbidities') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.  
    16  
    ,-- Severity.  
    1 -- State.  
    );  
 END CATCH  
END    