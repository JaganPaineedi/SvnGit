/******************************************************************************     
** Name: Rx Screen  
--   
-- Purpose: Script to add entries into SystemReports for Rx related reports, 
-- New Directions - Support Go Live - Task# 310 
-- Author:  Malathi Shiva   
-- Date:    13 April 2016  
--       
**********************************************************************************/ 

SET IDENTITY_INSERT SystemReports ON 

GO 

IF NOT EXISTS (SELECT SystemReportId 
               FROM   SystemReports 
               WHERE  ReportName = 'Medications - View Client Consent History') 
  BEGIN 
      INSERT INTO SystemReports 
                  (SystemReportId 
                   ,ReportName 
                   ,ReportURL 
                   ,Active 
                   ,CreatedBy 
                   ,CreatedDate 
                   ,ModifiedBy 
                   ,ModifiedDate) 
      VALUES     ( 1016 
                   ,'Medications - View Client Consent History' 
                   ,'<specify URL>/<Report Folder Path>/ClientConsentHistory&rs:Command=Render&rc:Parameters=False&StartDate=<StartDate>&EndDate=<EndDate>&MedicationNameId=<MedicationNameId>' 
				   ,'Y' 
,'mshiva' 
,Getdate() 
,'mshiva' 
,Getdate() ) 
END 

SET IDENTITY_INSERT SystemReports OFF 