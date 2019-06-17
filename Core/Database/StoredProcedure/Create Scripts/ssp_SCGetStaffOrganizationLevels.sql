IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetStaffOrganizationLevels]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetStaffOrganizationLevels]
GO
Create PROC [dbo].[ssp_SCGetStaffOrganizationLevels]      
(      
 @StaffId INT,    
 @OrganizationLevelId int = null    
)      
AS      
/******************************************************************************                                                  
**  File:                                                   
**  Name: ssp_SCGetStaffOrganizationLevels                                                  
**  Desc: This storeProcedure will executed for binding dropdown in supervision Reports List Page       
**        
**  Parameters:         
**  Input   @StaffId INT      
**  Output     ----------       -----------         
**          
**  Auth:  Sudhir Singh        
**  Date:  may 2, 2012        
*******************************************************************************         
**  Change History          
*******************************************************************************         
**  Date:  Author:    Description:         
**  --------  --------    -------------------------------------------         
**  6/7/2016 Hemant   Included Record delete check for OrganizationLevelStaff table.Thresholds - Support# 622   
** 7/12/2016 Lakshmi  Added condition if Levelnumber '0' Thresholds - Support# 720       
*******************************************************************************/        
BEGIN      
 declare @MainOrganizationLevelId int    
 IF ISNULL(@MainOrganizationLevelId,'') = ''    
 BEGIN    
  select top 1 @MainOrganizationLevelId = a.OrganizationLevelId     
  from  OrganizationLevels a    
  inner join OrganizationLevelTypes b on a.LevelTypeId = b.LevelTypeId      
  left join OrganizationLevelStaff c on a.OrganizationLevelId = c.OrganizationLevelId and ISNULL(c.RecordDeleted,'N') = 'N' -- Hemant 6/7/2016  
  where (staffid = @StaffId or ManagerId = @StaffId) and ISNULL(a.RecordDeleted,'N') = 'N'      
  order by b.LevelTypeId    
 END    
 IF ISNULL(@OrganizationLevelId,'') = ''    
  BEGIN    
  SET @OrganizationLevelId = @MainOrganizationLevelId    
 END    
     
 declare @MainLevelNumber int, @LevelNumber int      
 select @MainLevelNumber = isnull(LevelNumber,0) from OrganizationLevelTypes where LevelTypeId = (select LevelTypeId from OrganizationLevels       
 where OrganizationLevelId = @MainOrganizationLevelId)      
 select @LevelNumber = isnull(LevelNumber,0) from OrganizationLevelTypes where LevelTypeId = (select LevelTypeId from OrganizationLevels       
 where OrganizationLevelId = @OrganizationLevelId)    
 if(@MainOrganizationLevelId = @OrganizationLevelId)      
 Begin      
  select OrganizationLevelId,b.LevelTypeName +' - '+ isnull(a.LevelName,d.ProgramName) as LevelName from OrganizationLevels a      
  INNER JOIN OrganizationLevelTypes b ON a.LevelTypeId = b.LevelTypeId     
  left join programs d on a.ProgramId = d.ProgramId       
  where OrganizationLevelId = @MainOrganizationLevelId      
 END   
   else if (@LevelNumber-@MainLevelNumber = 0) --Lakshmi 7/12/2016
 begin
  select OrganizationLevelId,b.LevelTypeName +' - '+ isnull(a.LevelName,d.ProgramName) as LevelName from OrganizationLevels a        
  INNER JOIN OrganizationLevelTypes b ON a.LevelTypeId = b.LevelTypeId      
  left join programs d on a.ProgramId = d.ProgramId        
  where OrganizationLevelId = @OrganizationLevelId        
  order by OrganizationLevelId   
 end
    
 else if(@LevelNumber-@MainLevelNumber = 1)      
 Begin      
  select OrganizationLevelId,b.LevelTypeName +' - '+ isnull(a.LevelName,d.ProgramName) as LevelName from OrganizationLevels  a     
  INNER JOIN OrganizationLevelTypes b ON a.LevelTypeId = b.LevelTypeId    
  left join programs d on a.ProgramId = d.ProgramId      
  where OrganizationLevelId = @MainOrganizationLevelId      
  union      
  select OrganizationLevelId,b.LevelTypeName +' - '+ isnull(a.LevelName,d.ProgramName) as LevelName from OrganizationLevels a      
  INNER JOIN OrganizationLevelTypes b ON a.LevelTypeId = b.LevelTypeId    
  left join programs d on a.ProgramId = d.ProgramId      
  where OrganizationLevelId = @OrganizationLevelId      
  order by OrganizationLevelId      
 end       
 else if(@LevelNumber-@MainLevelNumber = 2)      
 Begin      
  select OrganizationLevelId,b.LevelTypeName +' - '+ isnull(a.LevelName,d.ProgramName) as LevelName from OrganizationLevels a    
  INNER JOIN OrganizationLevelTypes b ON a.LevelTypeId = b.LevelTypeId      
  left join programs d on a.ProgramId = d.ProgramId      
  where OrganizationLevelId = @MainOrganizationLevelId      
  union      
  select OrganizationLevelId,b.LevelTypeName +' - '+ isnull(a.LevelName,d.ProgramName) as LevelName from OrganizationLevels  a    
  INNER JOIN OrganizationLevelTypes b ON a.LevelTypeId = b.LevelTypeId       
  left join programs d on a.ProgramId = d.ProgramId      
  where OrganizationLevelId = (select ParentLevelId from OrganizationLevels where OrganizationLevelId = @OrganizationLevelId)      
  union      
  select OrganizationLevelId,b.LevelTypeName +' - '+ isnull(a.LevelName,d.ProgramName) as LevelName from OrganizationLevels a    
  INNER JOIN OrganizationLevelTypes b ON a.LevelTypeId = b.LevelTypeId         
  left join programs d on a.ProgramId = d.ProgramId      
  where OrganizationLevelId = @OrganizationLevelId      
  order by OrganizationLevelId      
 end      
 else if(@LevelNumber-@MainLevelNumber = 3)      
 Begin      
  select OrganizationLevelId,b.LevelTypeName +' - '+ isnull(a.LevelName,d.ProgramName) as LevelName from OrganizationLevels a    
  INNER JOIN OrganizationLevelTypes b ON a.LevelTypeId = b.LevelTypeId          
  left join programs d on a.ProgramId = d.ProgramId      
  where OrganizationLevelId = @MainOrganizationLevelId      
  union      
  select OrganizationLevelId,b.LevelTypeName +' - '+ isnull(a.LevelName,d.ProgramName) as LevelName from OrganizationLevels a     
  INNER JOIN OrganizationLevelTypes b ON a.LevelTypeId = b.LevelTypeId        
  left join programs d on a.ProgramId = d.ProgramId      
  where OrganizationLevelId = (select ParentLevelId from OrganizationLevels       
  where OrganizationLevelId = (select ParentLevelId from OrganizationLevels where OrganizationLevelId = @OrganizationLevelId))      
  union        
  select OrganizationLevelId,b.LevelTypeName +' - '+ isnull(a.LevelName,d.ProgramName) as LevelName from OrganizationLevels a    
  INNER JOIN OrganizationLevelTypes b ON a.LevelTypeId = b.LevelTypeId         
  left join programs d on a.ProgramId = d.ProgramId      
  where OrganizationLevelId = (select ParentLevelId from OrganizationLevels where OrganizationLevelId = @OrganizationLevelId)      
  union      
  select OrganizationLevelId,b.LevelTypeName +' - '+ isnull(a.LevelName,d.ProgramName) as LevelName from OrganizationLevels a    
  INNER JOIN OrganizationLevelTypes b ON a.LevelTypeId = b.LevelTypeId         
  left join programs d on a.ProgramId = d.ProgramId      
  where OrganizationLevelId = @OrganizationLevelId      
  order by OrganizationLevelId      
 end      
 else      
 begin      
  select OrganizationLevelId,  LevelName from OrganizationLevels  where OrganizationLevelId = -1      
 end     
      
END      
      