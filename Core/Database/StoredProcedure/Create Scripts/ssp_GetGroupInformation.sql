IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetGroupInformation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetGroupInformation]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetGroupInformation]    Script Date: 01/29/2016 16:45:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO  
CREATE Procedure  [dbo].[ssp_GetGroupInformation]   --1                   
@GroupId INT                                   
AS                                  
/******************************************************************************                                  
**  File:                                 
**  Name: Stored_Procedure_Name                                  
**  Desc:This is used to get group information against passed parameter                                   
**                                            
**  Return values:                                  
**                                   
**  Called by:GroupSerice.cs                                     
**                                                
**  Parameters:                                  
**  Input       Output                       
**  @GroupId    None                              
**     ----------       -----------                                  
**                                  
**  Auth:Pradeep                                   
**  Date:Dec 9,2009                                   
*******************************************************************************                                  
**  Change History                                  
*******************************************************************************                                  
**  Date:  Author:    Description:                                  
**  --------  --------    -------------------------------------------                                  
**  June 5th 2013 Wasif Butt  Sorting Clients and Staff list on Last Name      
 -- 02.25.2014  Ponnin      Removed ‘RowIdentifier’ and added ‘StartTime’ column according to Core data model change 'Upgrade script core 13.39 to 13.40.sql' for task  #155 of Philhaven Development      
 -- 06.08.2015      Akwinass     Attendance Columns Added (Task #829 Woods - Customizations)      
         'UsesAttendanceFunctions','AttendanceWeekly','AttendanceWeeklyOptions','AttendanceClientsEnrolledPrograms','AttendanceStandAloneDocumentCodeId','AttendanceScreenId','AttendanceDefaultProcedureCodeId'      
--  15.oct.2015  Basudev   what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.          
--         why:task #609, Network180 Customization    
--  29.Jan.2016  Pradeep Kumar Yadav   Added logic for cheking GroupService exist for groupId and also added one temporary column in Groups table ServiceExist     
-- 13/APRIL/2016 Akwinass   Removed AttendanceWeekly,AttendanceStandAloneDocumentCodeId from Groups Table and added GroupNoteType column to Groups Table(Task #167.1 in Valley - Support Go Live)  
-- 26 April 2017 Manjunath K   Added GroupClientDefaultProcedureCodes table. For Woods Support Go Live #444  
--15/May/2017 Kavya Added space white space after comma and before FirstName.-Core bugs#2343
--29/Mar/2018 Chita Ranjan What: Added new column ClassroomId Why: New Field added in Group Detail Page named as Classroom. PEP - Customizations #10005
*******************************************************************************/                    
BEGIN                    
  BEGIN TRY           
      
 DECLARE @GroupServiceExists nvarchar(20)        
 if Exists(Select GroupServiceId from GroupServices        
 where GroupId=@GroupId        
 and ISNULL(RecordDeleted,'N')<>'Y')        
 BEGIN        
  SET @GroupServiceExists = 'TRUE'        
 END        
 ELSE        
 BEGIN        
  SET @GroupServiceExists = 'FALSE'        
 END        
 --SELECT ISNULL(@GroupServiceExists,'FALSE')     
               
  --Get Group Information                    
    SELECT G.[GroupId]                      
      ,G.[GroupName]                      
      ,G.[GroupCode]                      
      ,G.[GroupType]                      
      ,G.[Comment]                      
      ,G.[ProcedureCodeId]                      
      ,G.[LocationId]                      
      ,G.[ProgramId]                      
      ,G.[ClinicianId]                      
      ,G.[Unit]                      
      ,G.[UnitType]                      
      ,G.[Active]                      
      ,G.[GroupNoteDocumentCodeId]                                     
      ,G.[CreatedBy]         
      ,G.[CreatedDate]                      
      ,G.[ModifiedBy]                      
      ,G.[ModifiedDate]                      
      ,G.[RecordDeleted]                      
      ,G.[DeletedDate]                      
      ,G.[DeletedBy]       
      ,G.AddClientsFromRoster                     
      ,GC.CodeName        
      ,G.StartTime      
      ,G.PlaceOfServiceId      
      -- 06.08.2015      Akwinass      
     ,G.UsesAttendanceFunctions      
     ,G.AttendanceWeeklyOptions      
     ,G.AttendanceClientsEnrolledPrograms       
     ,G.AttendanceScreenId      
     ,G.AttendanceDefaultProcedureCodeId 
     -- 13/APRIL/2016 Akwinass  
     ,G.GroupNoteType  
     ,@GroupServiceExists As ServiceExist 
     -- 29/Mar/2018 Chita Ranjan
     ,G.ClassroomId  
      FROM Groups G                  
      LEFT OUTER JOIN GlobalCodes GC on (GC.GlobalCodeId=G.UnitType   AND ISNULL(GC.RecordDeleted,'N')='N' AND GC.Active='Y')                   
       Where ISNULL(G.RecordDeleted,'N')='N' and GroupId=@GroupId                  
                        
      --Get Clients that attends the group                    
      SELECT GC.[GroupClientId],GC.[GroupId],GC.[ClientId],GC.[RowIdentifier],GC.[CreatedBy]                    
      ,GC.[CreatedDate],GC.[ModifiedBy],GC.[ModifiedDate],GC.[RecordDeleted]                    
      ,GC.[DeletedDate],GC.[DeletedBy],      
      CASE         
  WHEN ISNULL(Clients.ClientType, 'I') = 'I'        
   THEN ISNULL(Clients.LastName, '') + ', ' + ISNULL(Clients.FirstName, '')        
  ELSE ISNULL(Clients.OrganizationName, '')        
  END AS ClientName      
      --Clients.LastName+', ' +Clients.FirstName AS ClientName       
      from GroupClients GC                    
       INNER JOIN Clients On GC.ClientId=Clients.ClientId                    
       WHERE ISNULL(GC.RecordDeleted,'N')='N' AND ISNULL(Clients.RecordDeleted,'N')='N' and Clients.Active='Y' AND GC.GroupId=@GroupId       
    order by clients.LastName                     
        --Get Staffs that may lead the group                    
        SELECT GS.[GroupStaffId],GS.[GroupId],GS.[StaffId],GS.[RowIdentifier]                    
      ,GS.[CreatedBy]                    
      ,GS.[CreatedDate]                    
      ,GS.[ModifiedBy]                    
      ,GS.[ModifiedDate]                    
      ,GS.[RecordDeleted]                    
      ,GS.[DeletedDate]                    
      ,GS.[DeletedBy]                    
      ,Staff.LastName +', ' +Staff.FirstName AS StaffName  --Kavya Added space white space after comma and before FirstName.-Core bugs#2343                  
      FROM GroupStaff GS INNER JOIN Staff ON GS.StaffId=Staff.StaffId           
      WHERE ISNULL(GS.RecordDeleted,'N')='N' AND GS.GroupId=@GroupId                
   order by Staff.LastName      
         
         
       SELECT   
  ADPC.GroupClientDefaultProcedureCodeId,  
  ADPC.CreatedBy,  
  ADPC.CreatedDate,  
  ADPC.ModifiedBy,  
  ADPC.ModifiedDate,  
  ADPC.RecordDeleted,  
  ADPC.DeletedBy,  
  ADPC.DeletedDate,  
  ADPC.GroupId,  
  ADPC.ClientId,  
  ADPC.ProcedureCodeId,  
  CASE         
  WHEN ISNULL(C.ClientType, 'I') = 'I'        
  THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')        
  ELSE ISNULL(C.OrganizationName, '')        
  END AS ClientName,
  C.LastName as LastName,
  C.FirstName as FirstName
      FROM GroupClientDefaultProcedureCodes ADPC   
      LEFT JOIN Clients C on ADPC.ClientId = C.ClientId  
      WHERE ISNULL(ADPC.RecordDeleted,'N')='N' AND ADPC.GroupId=@GroupId                
          
         
            
  END TRY                    
  BEGIN CATCH                    
    DECLARE @Error varchar(8000)                                
          SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****'                                              
          + Convert(varchar(4000),ERROR_MESSAGE())                                                     
          + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),                                              
          '[ssp_GetGroupInformation]')                                  
          + '*****' + Convert(varchar,ERROR_LINE())                             
          + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                    
          + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                    
      RAISERROR                                                     
          (                                                     
            @Error, -- Message text.                         
            16, -- Severity.                                                     
            1 -- State.                                                     
          )                     
  END CATCH                    
END   