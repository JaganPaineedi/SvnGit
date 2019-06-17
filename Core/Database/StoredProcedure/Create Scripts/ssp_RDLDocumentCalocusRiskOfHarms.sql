IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLDocumentCalocusRiskOfHarms]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLDocumentCalocusRiskOfHarms]  
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_RDLDocumentCalocusRiskOfHarms] (@DocumentVersionId INT)
AS
/***********************************************************************************/
/* Stored Procedure: [ssp_RDLDocumentCalocusRiskOfHarms]         */
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
	,DC.NoIndicationCurrentSuicidal
	,DC.NoIndicationOfAggression
	,DC.DevelopmentallyAppropriateAbility
	,DC.LowRiskVictimization
	,DC.PastHistoryFleetingSuicidal
	,DC.MildSuicidalIdeation
	,DC.IndicationOrReport
	,DC.SubstanceUse
	,DC.InfrequentBriefLapses
	,DC.SomeRiskForVictimization
	,DC.SignificantCurrentSuicidal
	,DC.NoActiveSuicidal
	,DC.IndicationOrReportOfIncidentsActing
	,DC.BingeOrExcessiveUse
	,DC.PeriodsOfInabilityToCare
	,DC.SignificantRiskForVictimization
	,DC.CurrentSuicidalOrHomicidalIdeation
	,DC.IndicationOrReportOfSignificantImpulsivity
	,DC.SignsOfConsistentDeficits
	,DC.RecentPatternOfExcessiveSubstance
	,DC.ClearAndPersistentInability
	,DC.ImminentRiskOfSevereVictimization
	,DC.CurrentSuicidalOrHomicidalBehavior
	,DC.WithoutExpressedAmbivalence
	,DC.WithAHistoryOfSeriousPast
	,DC.InPresenceOfCommandHalucination
	,DC.IndicationOrReportOfRepeatedBehavior
	,DC.RelentlesslyEngagingInAcutely
	,DC.APatternOfNearlyConstant
	,DC.RiskOfHarmScore
	FROM DocumentCALOCUS DC
    INNER JOIN Documents D ON D.InProgressDocumentVersionId=DC.DocumentVersionId     
	WHERE  DC.DocumentVersionId=@DocumentVersionId 
		AND ISNULL(DC.RecordDeleted, 'N') = 'N'
		AND ISNULL(D.RecordDeleted, 'N') = 'N'
	  
		
		
  END TRY  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLDocumentCalocusRiskOfHarms') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.  
    16  
    ,-- Severity.  
    1 -- State.  
    );  
 END CATCH  
END    