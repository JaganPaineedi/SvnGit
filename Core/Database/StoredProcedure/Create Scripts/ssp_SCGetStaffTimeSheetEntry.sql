  

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetStaffTimeSheetEntry]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetStaffTimeSheetEntry]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
           
CREATE PROCEDURE dbo.ssp_SCGetStaffTimeSheetEntry  
@StaffTimeSheetEntryId INT            
,@TimeSheetDay datetime = NULL      
,@StaffId INT = NULL                
AS        
-- =============================================      
-- Author      : Rajesh S  
-- Date        : 22/12/2015  
-- Purpose     : Get Timesheet data 
-- Author		Modified Date			Reason  
-- Neelima		06/01/2016			Added Global Code insted of hardcoding 'Other' Value in Dropdown.
--							Bear River - Customizations #30
-- =============================================             
BEGIN               
BEGIN TRY                 
              
            
   SET @StaffTimeSheetEntryId =  (SELECT TOP 1 StaffTimeSheetEntryId FROM StaffTimeSheetEntries WHERE TimeSheetDay = @TimeSheetDay AND StaffId = @StaffId AND ISNULL(RecordDeleted,'N')='N')              
     
               
               
  SELECT                 
    StaffTimeSheetEntryId                 
   ,CreatedBy                    
   ,CreatedDate                    
   ,ModifiedBy                    
   ,ModifiedDate                   
   ,RecordDeleted                   
   ,DeletedBy                    
   ,DeletedDate                    
   ,StaffId                     
   ,TimeSheetDay                   
   ,StartTime                    
   ,StopTime                    
   ,TimeAway                    
   ,TotalHours                    
   ,DaysNotWorked                   
   ,BillableSecondaryLeaveHours                
   ,ClinicalSupportHours                 
   ,ServiceHours                   
  FROM             
   StaffTimeSheetEntries             
  WHERE             
   (@TimeSheetDay IS NULL OR TimeSheetDay = @TimeSheetDay)            
   AND ISNULL(RecordDeleted, 'N') = 'N'             
   AND StaffTimeSheetEntryId = @StaffTimeSheetEntryId                
                  
                  
  SELECT                 
                  
   STA.StaffTimeSheetTimeAwayId                
   ,STA.CreatedBy                    
   ,STA.CreatedDate                    
   ,STA.ModifiedBy                    
   ,STA.ModifiedDate                   
   ,STA.RecordDeleted                   
                         
   ,STA.DeletedBy                    
   ,STA.DeletedDate                    
   ,STA.StaffTimeSheetEntryId                 
   ,STA.StartTime                    
   ,STA.EndTime                     
   ,STA.Duration                    
   ,STA.Comment                     
                 
    ,'Time Away' as TimeAwayText                     
            
  FROM StaffTimeSheetTimeAway STA                 
   JOIN StaffTimeSheetEntries STE ON STA.StaffTimeSheetEntryId = STE.StaffTimeSheetEntryId            
  WHERE             
   --STE.TimeSheetDay = @TimeSheetDay            
   STE.StaffTimeSheetEntryId = @StaffTimeSheetEntryId          
   AND ISNULL(STA.RecordDeleted, 'N') = 'N'             
                  
  SELECT                 
   STS.StaffTimeSheetSecondaryActivityId               
   ,STS.CreatedBy                     
   ,STS.CreatedDate                     
   ,STS.ModifiedBy                     
   ,STS.ModifiedDate                    
   ,STS.RecordDeleted                    
            
   ,STS.DeletedBy                     
   ,STS.DeletedDate                     
   ,STS.StaffTimeSheetEntryId                  
   ,STS.SecondaryActivity                   
   ,STS.StartTime                     
   ,STS.EndTime                      
   ,STS.Duration                     
   ,STS.Comment                      
   --,'Other' AS SecondaryActivityText     
   ,GC.CodeName as SecondaryActivityText						-- Added By Neelima for task  Bear River - Customizations #30        
  FROM StaffTimeSheetSecondaryActivities STS                
   JOIN StaffTimeSheetEntries STE ON STS.StaffTimeSheetEntryId = STE.StaffTimeSheetEntryId  
   LEFT JOIN GlobalCodes GC On GC.GlobalCodeId = STS.SecondaryActivity           -- Added By Neelima for task  Bear River - Customizations #30          
  WHERE             
   --STE.TimeSheetDay = @TimeSheetDay 
   STS.StaffTimeSheetEntryId = @StaffTimeSheetEntryId           
   AND ISNULL(STS.RecordDeleted, 'N') = 'N'        
   AND ISNULL(GC.RecordDeleted, 'N') = 'N'     -- Added By Neelima for task  Bear River - Customizations #30   
                  
  SELECT                 
                  
  STT.StaffTimeSheetTimeOffId                 
  ,STT.CreatedBy                    
  ,STT.CreatedDate                    
  ,STT.ModifiedBy                    
  ,STT.ModifiedDate                   
  ,STT.RecordDeleted                   
  ,STT.DeletedBy                    
  ,STT.DeletedDate         
  ,STT.StaffTimeSheetEntryId                 
  ,STT.LeaveType                    
  ,STT.StartTime                    
  ,STT.EndTime                     
  ,STT.Duration                    
  ,STT.Comment                     
  ,GC.CodeName AS TimeOffText    
  ,ISNULL(STT.Paid,'N') Paid     
  ,CASE WHEN STT.Paid='Y' THEN 'Paid'    
 ELSE 'UnPaid' END PaidText               
  FROM StaffTimeSheetTimeOff STT            
   JOIN StaffTimeSheetEntries STE ON STT.StaffTimeSheetEntryId = STE.StaffTimeSheetEntryId            
   LEFT JOIN GlobalCodes GC ON STT.LeaveType = GC.GlobalCodeId            
  WHERE             
   --STE.TimeSheetDay = @TimeSheetDay 
   STT.StaffTimeSheetEntryId = @StaffTimeSheetEntryId            
   AND ISNULL(STT.RecordDeleted, 'N') = 'N'              
                  
   SELECT                 
    STO.StaffTimeSheetOverrideHistoryId               
    ,STO.CreatedBy                    
    ,STO.CreatedDate                    
    ,STO.ModifiedBy                    
    ,STO.ModifiedDate                   
    ,STO.RecordDeleted                   
    ,STO.DeletedBy                    
    ,STO.DeletedDate                    
    ,STO.StaffTimeSheetEntryId                 
    ,STO.OverrideDateTime                  
    ,STO.TypeOfOverride                   
    ,STO.OverrideReason                   
    ,STO.TypeOfOverride AS OverrideTypeText                
   FROM             
    StaffTimeSheetOverrideHistory   STO             
    JOIN StaffTimeSheetEntries STE ON STO.StaffTimeSheetEntryId = STE.StaffTimeSheetEntryId            
   WHERE             
    --STE.TimeSheetDay = @TimeSheetDay 
    STO.StaffTimeSheetEntryId  = @StaffTimeSheetEntryId           
    AND ISNULL(STO.RecordDeleted, 'N') = 'N'             
             
 END TRY              
              
 BEGIN CATCH              
  DECLARE @Error VARCHAR(8000)              
              
  SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[ssp_SCGetStaffTimeSheetEntry]') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())              
              
  RAISERROR (              
    @Error              
    ,-- Message text.                                                                                      
    16              
    ,-- Severity.                                                                                      
    1 -- State.                                                                                      
    );              
 END CATCH              
end 