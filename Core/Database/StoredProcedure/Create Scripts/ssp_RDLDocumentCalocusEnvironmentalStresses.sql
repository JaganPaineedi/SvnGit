IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLDocumentCalocusEnvironmentalStresses]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLDocumentCalocusEnvironmentalStresses] 
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_RDLDocumentCalocusEnvironmentalStresses] (@DocumentVersionId INT)
AS
/***********************************************************************************/
/* Stored Procedure: [ssp_RDLDocumentCalocusEnvironmentalStresses]         */
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
	,DC.AbsenceOfSignificantOrEnduringDifficulties
	,DC.AbsenceOfRecentTransitionsOrLossesOfConsequence
	,DC.MaterialNeedsMetWithoutSignificantCause
	,DC.LivingEnvironmentConduciveNormativeGrowth
	,DC.RoleExpectationsAreConsistentWithChild
	,DC.SignificantTransitionRequiringAdjustment
	,DC.MinorInterpersonalLossOrConflict
	,DC.TransientButSignificantIllnessOrInjury
	,DC.SomewhatInadequateMaterialResourcesThreat
	,DC.ExpectationsForPerformanceAtHomeOrSchool
	,DC.PotentialForExposureToSubstanceUse
	,DC.DisruptionOfFamilySocialMilieu
	,DC.InterpersonalOrMaterialLossThatHasSignificant
	,DC.SeriousIllnessInjuryForProlongedPeriod
	,DC.DangerOrThreatInNeighborhoodOrCommunity
	,DC.ExposureToSubstanceAbuseAndItsEffects
	,DC.RoleExpectationsThatExceedChild
	,DC.SeriousDisruptionOfFamilySocialMilieu
	,DC.ThreatOfSevereDisruptionInLifeCircumstances
	,DC.InabilityToMeetNeedsForPhysical
	,DC.ExposureToEndangeringCriminalActivities
	,DC.DifficultyAvoidingExposureToSubstanceUse
	,DC.HighlyTraumaticEnduringAndDisturbingCircumstances
	,DC.PoliticalOrRacialPersecution
	,DC.YouthFacesIncarcerationFosterHomePlacement
	,DC.SeverePainInjuryOrDisability
	,DC.RecoveryEnvironmentStressScore
	FROM DocumentCALOCUS DC
    INNER JOIN Documents D ON D.InProgressDocumentVersionId=DC.DocumentVersionId     
	WHERE  DC.DocumentVersionId=@DocumentVersionId 
		AND ISNULL(DC.RecordDeleted, 'N') = 'N'
		AND ISNULL(D.RecordDeleted, 'N') = 'N'
	  
		
		
  END TRY  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLDocumentCalocusEnvironmentalStresses') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.  
    16  
    ,-- Severity.  
    1 -- State.  
    );  
 END CATCH  
END    