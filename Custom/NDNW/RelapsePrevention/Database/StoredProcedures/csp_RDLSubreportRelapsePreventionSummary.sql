IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubreportRelapsePreventionSummary]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubreportRelapsePreventionSummary]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[csp_RDLSubreportRelapsePreventionSummary]                                          
(                                                            
 @DocumentVersionId as int                                                            
)                                            
AS          
                                                       
                                                          
/*********************************************************************                        
-- Stored Procedure: dbo.[csp_RDLSubreportRelapsePreventionSummary]                                                           
                          
-- Creation Date:    04/JUNE/2015                
--                         
-- Purpose:  Return Tables for RelapsePreventions and fill the type Dataset                        
--                        
-- Create:                        
--   Date       Author    Purpose                        
--  04/JUNE/2015  Anto   To fetch RelapsePreventions               
--        
*********************************************************************/     
BEGIN                                                      
  BEGIN TRY  
	   
	SELECT CRP.DocumentVersionId
			,dbo.csf_GetGlobalCodeNameById(CRLP.LifeDomain) AS LifeDomain
			,CRG.MyGoal AS Goals
			,CRO.RelapseObjectives AS Objectives
			,CRS.RelapseActionSteps AS ActionSteps
		FROM CustomDocumentRelapsePreventionPlans CRP
		LEFT JOIN CustomRelapseLifeDomains CRLP ON CRP.DocumentVersionId = CRLP.DocumentVersionId
			AND ISNULL(CRLP.RecordDeleted, 'N') = 'N'
		LEFT JOIN CustomRelapseGoals CRG ON CRG.RelapseLifeDomainId = CRLP.RelapseLifeDomainId
			AND CRG.DocumentVersionId = CRLP.DocumentVersionId
			AND CRG.RelapseGoalStatus IN (
				SELECT GlobalcodeId
				FROM GlobalCodes
				WHERE Category = 'Xrelapsegoalstatus'
					AND Code = 'INPROGRESS'
					AND ISNULL(RecordDeleted, 'N') = 'N'
				)
			AND ISNULL(CRG.RecordDeleted, 'N') = 'N'
		LEFT JOIN CustomRelapseObjectives CRO ON CRO.RelapseGoalId = CRG.RelapseGoalId
			AND CRG.DocumentVersionId = CRO.DocumentVersionId
			AND CRO.ObjectiveStatus IN (
				SELECT GlobalcodeId
				FROM GlobalCodes
				WHERE Category = 'Xrelapseobjstatus'
					AND Code = 'INPROGRESS'
					AND ISNULL(RecordDeleted, 'N') = 'N'
				)
			AND ISNULL(CRO.RecordDeleted, 'N') = 'N'
		LEFT JOIN CustomRelapseActionSteps CRS ON CRS.RelapseObjectiveId = CRO.RelapseObjectiveId
			AND CRS.DocumentVersionId = CRO.DocumentVersionId
			AND CRS.ActionStepStatus IN (
				SELECT GlobalcodeId
				FROM GlobalCodes
				WHERE Category = 'Xactionstepstatus'
					AND Code = 'INPROGRESS'
					AND ISNULL(RecordDeleted, 'N') = 'N'
				)
			AND ISNULL(CRS.RecordDeleted, 'N') = 'N'
		WHERE CRP.DocumentVersionId = @DocumentVersionId
			AND ISNULL(CRP.RecordDeleted, 'N') = 'N'		
				  
	END TRY	                                             
   
 BEGIN CATCH  
  DECLARE @Error varchar(8000)                             
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                           
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RDLSubreportRelapsePreventionSummary')                                                           
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                            
   + '*****' + Convert(varchar,ERROR_STATE())                                                          
  RAISERROR                                                           
  (                                                          
   @Error, -- Message text.                                                          
   16, -- Severity.                                                          
   1 -- State.                                                          
  )           
 END CATCH                                                
End  