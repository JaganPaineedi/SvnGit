IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLIncidentReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLIncidentReport] 
GO
    
CREATE PROCEDURE [dbo].[csp_RDLIncidentReport]  (@PrimaryKeyId INT)    
AS    
/********************************************************************************                                                       
--      
-- Copyright: Streamline Healthcare Solutions      
/*    Date			Author            Purpose */
  12 April 2019		Vithobha		Fixed the latent issue by adding the missing columns, New Directions - Enhancements: #26
    
*********************************************************************************/    
BEGIN TRY 
   
 SELECT top 1 C.IncidentReportId
		,C.CreatedBy
		,C.CreatedDate
		,C.ModifiedBy
		,C.ModifiedDate
		,C.RecordDeleted
		,C.DeletedBy
		,C.DeletedDate
		,C.ClientId
		,C.IncidentReportDetailId
		,C.IncidentReportFollowUpOfIndividualStatusId
		,C.IncidentReportSupervisorFollowUpId
		,C.IncidentReportAdministratorReviewId
		,C.IncidentReportFallDetailId
		,C.IncidentReportFallFollowUpOfIndividualStatusId
		,C.IncidentReportFallSupervisorFollowUpId
		,C.IncidentReportFallAdministratorReviewId
		,C.IncidentSeizureDetailId
		,C.IncidentReportSeizureFollowUpOfIndividualStatusId
		,C.IncidentReportSeizureSupervisorFollowUpId
		,C.IncidentReportSeizureAdministratorReviewId
		,C.DetailVersionStatus
		,C.FollowUpOfIndividualStatusVersionStatus
		,C.SupervisorFollowUpVersionStatus
		,C.AdministratorReviewVersionStatus
		,C.FallDetailVersionStatus
		,C.FallFollowUpOfIndividualStatusVersionStatus
		,C.FallSupervisorFollowUpVersionStatus
		,C.FallAdministratorReviewVersionStatus
		,C.SeizureDetailVersionStatus
		,C.SeizureFollowUpOfIndividualStatusVersionStatus
		,C.SeizureSupervisorFollowUpVersionStatus
		,C.SeizureAdministratorReviewVersionStatus
		,CONVERT(VARCHAR(10), CS.DOB, 101) AS DOB
		,CONVERT(VARCHAR(10), C.CreatedDate, 101) AS EffectiveDate
		,CS.LastName+','+CS.FirstName As ClientName
		,CSS.SupervisorFollowUpInjury AS SupervisorFollowUpInjury
		,CSS.SupervisorFollowUpAdministratorNotified AS SupervisorFollowUpAdministratorNotified
		,CSSS.FallSupervisorFollowUpAdministratorNotified AS FallSupervisorFollowUpAdministratorNotified
		,CSaS.SeizureSupervisorFollowUpAdministratorNotified AS SeizureSupervisorFollowUpAdministratorNotified
		,C.IncidentReportManagerFollowUpId
		,C.IncidentReportSeizureManagerFollowUpId
		,C.IncidentReportFallManagerFollowUpId
		,CMF.ManagerFollowUpAdministratorNotified as ManagerFollowUpAdministratorNotified
		,CFMF.ManagerFollowUpAdministratorNotified as FallManagerFollowUpAdministratorNotified
		,CSMF.ManagerFollowUpAdministratorNotified as SeizureManagerFollowUpAdministratorNotified
 FROM CustomIncidentReports  C 
 left join Clients CS ON CS.ClientId=C.ClientId
 left join CustomIncidentReportSupervisorFollowUps CSS ON CSS.IncidentReportSupervisorFollowUpId=C.IncidentReportSupervisorFollowUpId
 left join CustomIncidentReportFallSupervisorFollowUps CSSS ON CSSS.IncidentReportFallSupervisorFollowUpId=C.IncidentReportFallSupervisorFollowUpId
 left join CustomIncidentReportSeizureSupervisorFollowUps CSaS ON CSaS.IncidentReportSeizureSupervisorFollowUpId=C.IncidentReportSeizureSupervisorFollowUpId
 left join CustomIncidentReportManagerFollowUps CMF ON CMF.IncidentReportManagerFollowUpId=C.IncidentReportManagerFollowUpId
 left join CustomIncidentReportFallManagerFollowUps CFMF ON CFMF.IncidentReportFallManagerFollowUpId=C.IncidentReportFallManagerFollowUpId
 left join CustomIncidentReportSeizureManagerFollowUps CSMF ON CSMF.IncidentReportSeizureManagerFollowUpId=C.IncidentReportSeizureManagerFollowUpId
 WHERE ISNull(C.RecordDeleted, 'N') = 'N' And ISNull(CS.RecordDeleted, 'N') = 'N' AND C.IncidentReportId = @PrimaryKeyId 
 
 Order By C.IncidentReportId desc      
  
  end try      
    
      
BEGIN CATCH      
 DECLARE @Error VARCHAR(8000)      
      
 SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLIncidentReport') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())      
      
 RAISERROR (      
   @Error      
   ,-- Message text.                      
   16      
   ,-- Severity.                      
   1 -- State.                      
   );      
END CATCH