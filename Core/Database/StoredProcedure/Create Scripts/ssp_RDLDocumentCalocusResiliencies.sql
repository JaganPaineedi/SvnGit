IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLDocumentCalocusResiliencies]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLDocumentCalocusResiliencies] 
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_RDLDocumentCalocusResiliencies] (@DocumentVersionId INT)
AS
/***********************************************************************************/
/* Stored Procedure: [ssp_RDLDocumentCalocusResiliencies]         */
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
	,DC.ThereHasBeenNoPriorExperience
	,DC.ChildHasDemonstratedSignificant
	,DC.PriorExperienceIndicatesThatEfforts
	,DC.ThereHasBeenSuccessfulManagement
	,DC.AbleToTransitionSuccessfully
	,DC.ChildDemonstratedAverageAbility
	,DC.PreviousExperienceInTreatment
	,DC.SignificantAbilityToManageRecovery
	,DC.RecoveryHasBeenManagedForShort
	,DC.AbleToTransitionSuccessfullyAndAccept
	,DC.ChildHasDemonstratedAnInconsistent
	,DC.PreviousExperienceInTreatmentAtLowLevel
	,DC.RecoveryHasBeenMaintainedForModerate
	,DC.HasDemonstratedLimitedAbility
	,DC.DevelopmentalPressuresAndLifeChangesDeterioration
	,DC.AbleToTransitionSuccessfullyAndAcceptChange
	,DC.ChildHasDemonstratedFrequentEvidence
	,DC.PreviousTreatmentHasNotAchievedComplete
	,DC.AttemptsToMaintainWhateverGains
	,DC.DevelopmentalPressuresAndLifeChangesDistress
	,DC.TransitionsWithChangesInRoutine
	,DC.ChildHasDemonstratedSignificantAndConsistent
	,DC.PastResponseToTreatmentHasBeenQuite
	,DC.SymptomsArePersistentAndFunctionalAbility
	,DC.DevelopmentalPressuresAndLifeChangesTurmoil
	,DC.UnableToTransitionOrAcceptChanges
	,DC.ResiliencyTreatmentHistoryScore
	FROM DocumentCALOCUS DC
    INNER JOIN Documents D ON D.InProgressDocumentVersionId=DC.DocumentVersionId     
	WHERE  DC.DocumentVersionId=@DocumentVersionId 
		AND ISNULL(DC.RecordDeleted, 'N') = 'N'
		AND ISNULL(D.RecordDeleted, 'N') = 'N'
	  
		
		
  END TRY  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLDocumentCalocusResiliencies') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.  
    16  
    ,-- Severity.  
    1 -- State.  
    );  
 END CATCH  
END    