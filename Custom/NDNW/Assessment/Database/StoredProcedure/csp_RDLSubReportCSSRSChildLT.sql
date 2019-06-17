IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'csp_RDLSubReportCSSRSChildLT')
	BEGIN
		DROP  Procedure  csp_RDLSubReportCSSRSChildLT
	END

GO
Create Procedure [dbo].[csp_RDLSubReportCSSRSChildLT]
 @DocumentVersionId INT      
AS      
 /*********************************************************************/                                                                                            
 /* Stored Procedure: csp_RDLSubReportCSSRSChildLT      */                                                                                   
 /* Creation Date:  09/Jan/2015                                     */                                                                                            
 /* Purpose: To Get CSSRS Adult LT details           */      
 /* Input Parameters: @DocumentVersionId            */                                                                                          
                                                                                      
 /* Data Modifications:                                               */                                                                                            
                                                                                          
 /* Date              Author                  Purpose      */      
 /*********************************************************************/         
        
Begin                                  
Begin TRY  


Select DocumentVersionId,
DeadDescription,
dbo.csf_GetGlobalCodeNameById(DeadLifeTime) AS DeadLifeTime,
dbo.csf_GetGlobalCodeNameById(DeadPast1Month) AS DeadPast1Month,
NonSpecificDescription,
dbo.csf_GetGlobalCodeNameById(NonSpecificLifeTime) AS NonSpecificLifeTime,
dbo.csf_GetGlobalCodeNameById(NonSpecificPast1Month) AS NonSpecificPast1Month,
ActiveSuicidalIdeationDescription,
dbo.csf_GetGlobalCodeNameById(ActiveSuicidalIdeationLifeTime) AS ActiveSuicidalIdeationLifeTime,
dbo.csf_GetGlobalCodeNameById(ActiveSuicidalIdeationPast1Month) AS ActiveSuicidalIdeationPast1Month,
ASISomeIntentActDescription,
dbo.csf_GetGlobalCodeNameById(ASILifeTime) AS ASILifeTime,
dbo.csf_GetGlobalCodeNameById(ASIPast1Month) AS ASIPast1Month,
ASISpecificPlanAndIntentDescription,
dbo.csf_GetGlobalCodeNameById(ASISPILifeTime) AS ASISPILifeTime,
dbo.csf_GetGlobalCodeNameById(ASISPIPast1Month) AS ASISPIPast1Month,
dbo.csf_GetGlobalCodeNameById(LifeTimeMostSevere) AS LifeTimeMostSevere,
MostSevereDescription,
dbo.csf_GetGlobalCodeNameById(RecentMostSevere) AS RecentMostSevere,
RecentMostSevereDescription,
dbo.csf_GetGlobalCodeNameById(FrequencyMostSevereOne) AS FrequencyMostSevereOne,
dbo.csf_GetGlobalCodeNameById(FrequencyMostSevereTwo) AS FrequencyMostSevereTwo,
--dbo.csf_GetGlobalCodeNameById(DurationMostSevereOne) AS DurationMostSevereOne,
--dbo.csf_GetGlobalCodeNameById(DurationMostSevereTwo) AS DurationMostSevereTwo,
--dbo.csf_GetGlobalCodeNameById(ControllabilityMostSevereOne) AS ControllabilityMostSevereOne,
--dbo.csf_GetGlobalCodeNameById(ControllabilityMostSevereTwo) AS ControllabilityMostSevereTwo,
--dbo.csf_GetGlobalCodeNameById(DeterrentsMostSevereOne) AS DeterrentsMostSevereOne,
--dbo.csf_GetGlobalCodeNameById(DeterrentsMostSevereTwo) AS DeterrentsMostSevereTwo,
--dbo.csf_GetGlobalCodeNameById(ReasonsMostSevereOne) AS ReasonsMostSevereOne,
--dbo.csf_GetGlobalCodeNameById(ReasonsMostSevereTwo) AS ReasonsMostSevereTwo,
ActualAttemptDescription,
dbo.csf_GetGlobalCodeNameById(SuicidalBehaviourLifeTime) AS SuicidalBehaviourLifeTime,
SuicidalBehaviourAttemptNoOne,
dbo.csf_GetGlobalCodeNameById(SelfInjuriesOne) AS SelfInjuriesOne,
dbo.csf_GetGlobalCodeNameById(SuicidalBehaviourPast3Monts) AS SuicidalBehaviourPast3Monts,
SuicidalBehaviourAttemptNoTwo,
dbo.csf_GetGlobalCodeNameById(SelfInjuriesTwo) AS SelfInjuriesTwo,
InterruptedAttemptDescription,
dbo.csf_GetGlobalCodeNameById(InterruptedAttemptLifeTime) AS InterruptedAttemptLifeTime,
TotalNoInterruptedOne,
dbo.csf_GetGlobalCodeNameById(InterruptedAttemptPast3Months) AS InterruptedAttemptPast3Months,
TotalNoInterruptedTwo,
AbortedDescription,
dbo.csf_GetGlobalCodeNameById(AbortedLifeTime) AS AbortedLifeTime,
dbo.csf_GetGlobalCodeNameById(AbortedPast3Months) AS AbortedPast3Months,
AbortedOne,
AbortedTwo,
PreparatoryDescription,
dbo.csf_GetGlobalCodeNameById(PreparatoryLifeTime) AS PreparatoryLifeTime,
PreparatoryOne,
dbo.csf_GetGlobalCodeNameById(PreparatoryPast3Months) AS PreparatoryPast3Months,
PreparatoryTwo,
dbo.csf_GetGlobalCodeNameById(SuicidalBehaviorLifeTime) AS SuicidalBehaviorLifeTime,
dbo.csf_GetGlobalCodeNameById(SuicidalBehaviorPast3Months) AS SuicidalBehaviorPast3Months,
RecentAttemptDate,
LethalAttemptDate,
FirstAttemptDate,
dbo.csf_GetGlobalCodeNameById(ActualLethality1) AS ActualLethality1,
dbo.csf_GetGlobalCodeNameById(ActualLethality2) AS ActualLethality2,
dbo.csf_GetGlobalCodeNameById(ActualLethality3) AS ActualLethality3,
dbo.csf_GetGlobalCodeNameById(PotentialLethality1) AS PotentialLethality1,
dbo.csf_GetGlobalCodeNameById(PotentialLethality2) AS PotentialLethality2,
dbo.csf_GetGlobalCodeNameById(PotentialLethality3) AS PotentialLethality3,
dbo.csf_GetGlobalCodeNameById(SelfInjuriesIntentOne) AS SelfInjuriesIntentOne,
dbo.csf_GetGlobalCodeNameById(SelfInjuriesIntentTwo) AS SelfInjuriesIntentTwo
FROM CustomDocumentChildLTs WHERE DocumentVersionId = @DocumentVersionId

END TRY                                                                              
BEGIN CATCH                                  
DECLARE @Error varchar(8000)                                                                               
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                         
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RDLSubReportCSSRSChildLT')                                                                                                             
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                              
    + '*****' + Convert(varchar,ERROR_STATE())                              
 RAISERROR                                                                                                             
 (                                                                               
  @Error, -- Message text.                                                                                                            
  16, -- Severity.                                                                                                            
  1 -- State.                                                                                                            
 );                                                                                                          
END CATCH          
END