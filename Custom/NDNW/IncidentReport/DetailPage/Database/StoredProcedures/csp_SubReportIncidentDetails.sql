IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SubReportIncidentDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SubReportIncidentDetails] --1458
GO
    
CREATE PROCEDURE [dbo].[csp_SubReportIncidentDetails]  (@IncidentReportDetailId INT)    
AS    
/********************************************************************************                                                       
--      
-- Copyright: Streamline Healthcare Solutions      
/*    Date        Author            Purpose */
    
*********************************************************************************/    
BEGIN TRY      
  SELECT C.IncidentReportDetailId    
  ,C.CreatedBy    
  ,C.CreatedDate    
  ,C.ModifiedBy    
  ,C.ModifiedDate    
  ,C.RecordDeleted    
  ,C.DeletedBy    
  ,C.DeletedDate    
  ,C.IncidentReportId    
  ,C.DetailsStaffNotifiedForInjury    
  ,C.SignedBy    
  ,C.DetailsDescriptionOfincident    
  ,C.DetailsActionsTakenByStaff    
  ,C.DetailsWitnesses    
  ,Convert(varchar(10),C.DetailsDateStaffNotified,101) as DetailsDateStaffNotified
  ,(right('0' + LTRIM(SUBSTRING(CONVERT(varchar, C.DetailsTimestaffNotified, 100), 13, 2)),2)+ ':'
 + SUBSTRING(CONVERT(varchar, C.DetailsTimestaffNotified, 100), 16, 2) + ' '
 + SUBSTRING(CONVERT(varchar, C.DetailsTimestaffNotified, 100), 18, 2))as DetailsTimestaffNotified    
  ,C.DetailsNoMedicalStaffNotified    
  ,Convert(varchar,C.SignedDate,101) as SignedDate
  ,C.PhysicalSignature    
  ,C.CurrentStatus    
  ,C.InProgressStatus    
  ,S.LastName+','+S.FirstName As StaffName      
  ,SS.LastName+','+SS.FirstName As SignedByName  
  ,SSS.LastName+','+SSS.FirstName As SupervisorFlaggedId  
 FROM CustomIncidentReportDetails C      
 Left Join Staff S On S.StaffId=C.DetailsStaffNotifiedForInjury      
 Left Join Staff SS On SS.StaffId=C.SignedBy      
 Left Join Staff SSS On SSS.StaffId=C.DetailsSupervisorFlaggedId
 WHERE ISNull(C.RecordDeleted, 'N') = 'N' AND C.IncidentReportDetailId = @IncidentReportDetailId    
  
  end try      
    
      
BEGIN CATCH      
 DECLARE @Error VARCHAR(8000)      
      
 SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_SubReportIncidentDetails') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())      
      
 RAISERROR (      
   @Error      
   ,-- Message text.                      
   16      
   ,-- Severity.                      
   1 -- State.                      
   );      
END CATCH 