IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetAllSubOrganizationLevels]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetAllSubOrganizationLevels]
GO

CREATE PROC [dbo].[ssp_SCGetAllSubOrganizationLevels]
(  
 @StaffId INT,
 @OrganizationLevelId INT
)  
AS  
/******************************************************************************                                              
**  File:                                               
**  Name: ssp_SCGetAllSubOrganizationLevels                                              
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
-- 13/oct/2015  Venkatesh   what: Modify the logic as per task #466 Valley Go Live Support                 
*******************************************************************************/    
BEGIN
	declare @LevelNumber int    
 select @LevelNumber = LevelNumber from OrganizationLevelTypes where LevelTypeId = (select LevelTypeId from OrganizationLevels       
 where OrganizationLevelId = @OrganizationLevelId)    
   
  declare @ProgramLevel char(1)    
 select @ProgramLevel = ISNULL(ProgramLevel,'N') from OrganizationLevelTypes where LevelTypeId = (select LevelTypeId from OrganizationLevels       
 where OrganizationLevelId = @OrganizationLevelId)   
     
  if (@levelNumber = 4   OR @ProgramLevel='Y')  
  begin     
   select 0 as OrganizationLevelId,'All Staff'  as LevelName , 'Staff' as levelHeader    
   union    
   select distinct Staff.staffid as OrganizationLevelId,isnull(LastName + ', ','') + FirstName as LevelName, 'Staff' as levelHeader     
   from OrganizationLevels    
   inner join OrganizationLevelStaff on OrganizationLevelStaff.OrganizationLevelId = OrganizationLevels.OrganizationLevelId    
             and isnull(OrganizationLevelStaff.RecordDeleted,'N') = 'N'    
   inner join Staff on isnull(Staff.Active,'Y') = 'Y' and isnull(Staff.RecordDeleted,'N') = 'N'    
            and OrganizationLevelStaff.Staffid = Staff.Staffid     
   where OrganizationLevels.OrganizationLevelId = @OrganizationLevelId     
  end      
  else if @levelNumber = 3  AND @ProgramLevel='N'     
  BEGIN     
   select 0 as OrganizationLevelId,'All Teams'  as LevelName, 'Team' as levelHeader    
   union    
   select distinct OrganizationLevels.OrganizationLevelId,isnull(LevelName,programs.ProgramName) as LevelName, 'Team' as levelHeader    
   from OrganizationLevels    
   left join programs on OrganizationLevels.ProgramId = programs.ProgramId and ISNULL(programs.RecordDeleted,'N') = 'N'       
   where ISNULL(OrganizationLevels.RecordDeleted,'N') = 'N' and OrganizationLevels.ParentLevelId = @OrganizationLevelId      
  END      
  else if @levelNumber = 2   AND @ProgramLevel='N'       
  Begin     
   select 0 as OrganizationLevelId,'All Programs'  as LevelName, 'Program' as levelHeader    
   union    
   select distinct b.OrganizationLevelId,ISNULL(b.LevelName,programs.ProgramName) as LevelName, 'Program' as levelHeader from OrganizationLevels a      
   RIGHT join OrganizationLevels b on a.ParentLevelId = b.OrganizationLevelId and ISNULL(a.RecordDeleted,'N') = 'N'   
    left join programs on b.ProgramId = programs.ProgramId and ISNULL(programs.RecordDeleted,'N') = 'N'        
   where  b.ParentLevelId = @OrganizationLevelId and ISNULL(b.RecordDeleted,'N') = 'N'   
   
  END         
  else if @levelNumber = 1     
  Begin     
   select 0 as OrganizationLevelId,'All Divisions'  as LevelName,'Division' as levelHeader    
   union    
   select distinct c.OrganizationLevelId,c.LevelName,'Division' as levelHeader from OrganizationLevels a      
   RIGHT join OrganizationLevels b on a.ParentLevelId = b.OrganizationLevelId and ISNULL(a.RecordDeleted,'N') = 'N'        
   RIGHT join OrganizationLevels c on b.ParentLevelId = c.OrganizationLevelId and ISNULL(b.RecordDeleted,'N') = 'N'    
   where  c.ParentLevelId = @OrganizationLevelId and ISNULL(c.RecordDeleted,'N') = 'N'     
  END      
END 
GO


