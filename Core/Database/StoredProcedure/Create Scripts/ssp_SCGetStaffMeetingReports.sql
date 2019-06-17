IF EXISTS (SELECT * 
           FROM   SYS.objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_SCGetStaffMeetingReports]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_SCGetStaffMeetingReports] 

GO 
               
CREATE PROCEDURE [DBO].[ssp_SCGetStaffMeetingReports]   

/********************************************************************************                                                                
-- Stored Procedure: dbo.ssp_SCGetStaffMeetingReports                                                                 
--                                                                
-- Copyright: Streamline Healthcate Solutions                                                                
--                                                                
-- Purpose: used by Reports tab in StaffMeeting                                                               
--                                                                
-- Updates:                                                                                                                       
-- Date               Author                Purpose                                                                           
/*  19/Jun/2017       Anto                  Created a ssp to make it as a core sp - Core Bugs #2387 */                                                           
*********************************************************************************/                                                                
as                             
BEGIN                    
-- Grid Records             
select ReportId,ReportServerId,Name as ReportName,[Description],ReportServerPath from Reports inner join CustomConfigurations on CustomConfigurations.StaffMeetingReportFolderId=Reports.ParentFolderId            
where isnull(Reports.RecordDeleted,'N')<>'Y'   
      
          
            
If (@@error!=0)                                                        
Begin                                                        
 RAISERROR  ('[ssp_SCGetStaffMeetingReports] : An Error Occured',16,1)                                                         
 Return                                                        
End              
END  