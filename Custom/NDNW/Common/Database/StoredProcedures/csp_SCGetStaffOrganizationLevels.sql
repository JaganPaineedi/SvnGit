IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetStaffOrganizationLevels]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetStaffOrganizationLevels]
GO

CREATE PROC [dbo].[csp_SCGetStaffOrganizationLevels]
(
	@StaffId INT
)
AS
/******************************************************************************                                            
**  File:                                             
**  Name: csp_SCGetStaffOrganizationLevels                                            
**  Desc: This storeProcedure will executed for binding dropdown in supervisor dashboard widget 
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
**  Date:		Author:    Description:   
**  --------	--------   -------------------------------------------   
** 19/2/2013    Maninder   Added check ISNULL(c.RecordDeleted,'N') = 'N' in where condition
*******************************************************************************/  
BEGIN
	select a.OrganizationLevelId, isnull(a.LevelName,d.ProgramName) +'(' + b.LevelTypeName + ')' AS 'LevelName',
	isnull(a.LevelName,d.ProgramName) as  'OrganizationLevelLevelName', b.LevelTypeName
	from  OrganizationLevels a
	inner join OrganizationLevelTypes b on a.LevelTypeId = b.LevelTypeId  
	left join OrganizationLevelStaff c on a.OrganizationLevelId = c.OrganizationLevelId
	left join programs d on a.ProgramId = d.ProgramId
	where (staffid = @StaffId or ManagerId = @StaffId) and ISNULL(a.RecordDeleted,'N') = 'N'  and ISNULL(c.RecordDeleted,'N') = 'N'
	order by b.LevelTypeId
	
END


