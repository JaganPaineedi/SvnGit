IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLDocumentCalocusAcceptanceChilds]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLDocumentCalocusAcceptanceChilds] 
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_RDLDocumentCalocusAcceptanceChilds] (@DocumentVersionId INT)
AS
/***********************************************************************************/
/* Stored Procedure: [ssp_RDLDocumentCalocusAcceptanceChilds]         */
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
	,DC.QuicklyFormsATrustingAndRespectfulPositive
	,DC.AbleToDefineProblemsAndUnderstands
	,DC.AcceptsAgeAppropriateResponsibilityForBehavior
	,DC.ActivelyParticipatesInTreatmentPlanning
	,DC.AbleToDevelopATrustingPositiveRelationship
	,DC.UnableToDefineTheProblemButCanUnderstand
	,DC.AcceptsLimitedAgeAppropriate
	,DC.PassivelyCooperatesInTreatmentPlanning
	,DC.AmbivalentAvoidantOrDistrustfulRelationship
	,DC.AcknowledgesExistenceOfProblemButResists
	,DC.MinimizesOrRationalizesDistressingBehaviors
	,DC.UnableToAcceptOthersDefinition
	,DC.FrequentlyMissesOrLateForTreatment
	,DC.ActivelyHostileRelationshipWithClinicians
	,DC.AcceptsNoAgeAppropriateResponsibilityRole
	,DC.ActivelyFrequentlyDisruptsOrStonewalls
	,DC.UnableToFormTherapeutic
	,DC.UnawareOfProblemOrItsConsequences
	,DC.UnableToCommunicateWithClinician
	,DC.TreatmentAcceptanceEngagementChildScore
	FROM DocumentCALOCUS DC
    INNER JOIN Documents D ON D.InProgressDocumentVersionId=DC.DocumentVersionId     
	WHERE  DC.DocumentVersionId=@DocumentVersionId 
		AND ISNULL(DC.RecordDeleted, 'N') = 'N'
		AND ISNULL(D.RecordDeleted, 'N') = 'N'
	  
		
		
  END TRY  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLDocumentCalocusAcceptanceChilds') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.  
    16  
    ,-- Severity.  
    1 -- State.  
    );  
 END CATCH  
END    