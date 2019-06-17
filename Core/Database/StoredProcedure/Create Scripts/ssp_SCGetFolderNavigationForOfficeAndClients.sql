
/****** Object:  StoredProcedure [dbo].[ssp_SCGetFolderNavigationForOfficeAndClients]    Script Date: 4/27/2018 3:53:32 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetFolderNavigationForOfficeAndClients]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetFolderNavigationForOfficeAndClients]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetFolderNavigationForOfficeAndClients]    Script Date: 4/27/2018 3:53:33 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetFolderNavigationForOfficeAndClients] 
@LoggedInUserId  int,                  
@StaffId int              
/********************************************************************************                      
-- Stored Procedure: dbo.ssp_SCGetFolderNavigationForOfficeAndClients                        
--                      
-- Copyright: 2009 Streamline Healthcate Solutions                      
--                      
-- Purpose: Get Folder Navigation banners                      
--                      
-- Updates:                                                                             
-- Date        Author           Purpose                      
-- 27Sep,2010  Damanpreet Kaur  Created.
-- 29 Sept 2011 Modified by Rakesh instead of ClientId passeed LoggedinUserId
-- 11 June 2012 Modified by Vikesh  Task 1482
-- 3 May 2018	Ponnin      Added union and included logic to handle the StaffPermissionExceptions table for folder permissions(Staff level permssions). 	Why: New Directions - Support Go Live - Task #811
 *******************************************************************************/                      
as                   
    
create table #temp1(StaffId int, PermissionTemplateType int, PermissionItemId int)    
    
insert into #temp1 
select sr.StaffId, pt.PermissionTemplateType, pti.PermissionItemId      
  from StaffRoles sr      
       join Staff s on s.StaffId = sr.StaffId      
       join PermissionTemplates pt on pt.RoleId = sr.RoleId      
       join PermissionTemplateItems pti on pti.PermissionTemplateId = pt.PermissionTemplateId      
 where pt.PermissionTemplateType in (5907)      
   and isnull(sr.RecordDeleted, 'N') = 'N'      
   and isnull(pt.RecordDeleted, 'N') = 'N'      
   and isnull(pti.RecordDeleted, 'N') = 'N'      
   and isnull(s.RecordDeleted, 'N') = 'N'      
   and sr.StaffId = @StaffId    

    UNION

	SELECT SPE.StaffId, SPE.PermissionTemplateType, SPE.PermissionItemId
	FROM StaffPermissionExceptions SPE
	WHERE SPE.StaffId = @StaffId
		AND SPE.PermissionTemplateType = 5907
		AND Allow = 'Y'
		AND ISNULL(SPE.RecordDeleted, 'N') = 'N'
		AND (
			(
				SPE.StartDate <= GETDATE()
				AND SPE.EndDate >= GETDATE()
				)
			OR (
				SPE.StartDate <= GETDATE()
				AND SPE.EndDate IS NULL
				)
			OR (SPE.StartDate IS NULL)
			)    

    
create table #temp(ReportId int,NavigationName varchar(250) ,DisplayAs varchar(250),ParentFolderId int)              
              
insert into #temp                                       
select distinct R.ReportId,R.Name,                      
       R.Name as DisplayAs,                      
       R.ParentFolderId                                                   
       from Reports as R                                       
       where           
        R.IsFolder = 'Y' and (R.ReportId in(select PermissionItemId from #temp1)     
       --or ((R.ReportId in(select R.ParentFolderId from Reports R inner join #temp1 t on t.PermissionItemId=R.ReportId)))    
       )                  
       and isnull(R.RecordDeleted, 'N') = 'N'                          
        order by [R].ParentFolderId         
    Select ReportId ,NavigationName ,DisplayAs,ParentFolderId                 
    from #temp order by NavigationName      
                                
 --Checking For Errors                              
  If (@@error!=0)                              
  Begin                              
   RAISERROR  ('ssp_SCGetFolderNavigationForOfficeAndClients: An Error Occured',16,1)                               
   Return                              
   End 
GO


