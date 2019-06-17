IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SubReportIncidentGeneral]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SubReportIncidentGeneral] 
GO
    
CREATE PROCEDURE [dbo].[csp_SubReportIncidentGeneral]  (@PrimaryKeyId INT)    
AS    
/********************************************************************************                                                       
--      
-- Copyright: Streamline Healthcare Solutions      
/*    Date        Author            Purpose */
    
*********************************************************************************/    
BEGIN TRY     

 SELECT C.IncidentReportGeneralId
	,C.CreatedBy
	,C.CreatedDate
	,C.ModifiedBy
	,C.ModifiedDate
	,C.RecordDeleted
	,C.DeletedBy
	,C.DeletedDate
	,C.IncidentReportId
	,C.GeneralProgram
	,Convert(varchar,C.GeneralDateOfIncident,101) as GeneralDateOfIncident
	,C.GeneralTimeOfIncident
	,C.GeneralResidence
	,Convert(varchar,C.GeneralDateStaffNotified,101) as GeneralDateStaffNotified
	,C.GeneralSame
	,C.GeneralTimeStaffNotified
	,dbo.csf_GetGlobalCodeNameById(C.GeneralLocationOfIncident) AS GeneralLocationOfIncident
	,dbo.csf_GetGlobalCodeNameById(C.GeneralLocationDetails) AS GeneralLocationDetails
	,C.GeneralLocationDetailsText
	,dbo.csf_GetGlobalCodeNameById(C.GeneralIncidentCategory) AS GeneralIncidentCategory
	,dbo.csf_GetGlobalCodeNameById(C.GeneralSecondaryCategory) AS GeneralSecondaryCategory
  ,G.CodeName As GeneralIncidentCategoryText
  ,G.Code As GeneralIncidentCategoryCode
  ,SG.SubCodeName As GeneralSecondaryCategoryText
  ,SG.Code As GeneralSecondaryCategoryCode
  ,P.ProgramName as ProgramName
 FROM CustomIncidentReportGenerals  C 
 left Join GlobalCodes G On G.GlobalCodeId=C.GeneralIncidentCategory
 left Join GlobalSubCodes SG On SG.GlobalSubCodeId=C.GeneralSecondaryCategory
 left join Programs P ON P.ProgramId=C.GeneralProgram
 WHERE ISNull(C.RecordDeleted, 'N') = 'N' And ISNull(G.RecordDeleted, 'N') = 'N' AND C.IncidentReportId = @PrimaryKeyId       
  
  end try      
    
      
BEGIN CATCH      
 DECLARE @Error VARCHAR(8000)      
      
 SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_SubReportIncidentGeneral') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())      
      
 RAISERROR (      
   @Error      
   ,-- Message text.                      
   16      
   ,-- Severity.                      
   1 -- State.                      
   );      
END CATCH 