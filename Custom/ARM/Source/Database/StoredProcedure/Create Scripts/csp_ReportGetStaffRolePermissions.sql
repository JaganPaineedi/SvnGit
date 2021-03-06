/****** Object:  StoredProcedure [dbo].[csp_ReportGetStaffRolePermissions]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportGetStaffRolePermissions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportGetStaffRolePermissions]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportGetStaffRolePermissions]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

    
CREATE procedure [dbo].[csp_ReportGetStaffRolePermissions]   
@RoleId int,    
@PermissionTemplateType int,    
@ParentId int = null,    
@PermissionStatus char(1) = null -- ''G'' - granted, ''D'' - Denied, NULL - all    

AS 
/********************************************************************************                          
Report: Staff Role Permissions

	Date		User		Description
	----------	---------	------------------------------------
	05/26/2011	dharvey		Created		     
*********************************************************************************/                          
/*
DECLARE
@RoleId int,    
@PermissionTemplateType int,    
@ParentId int = null,    
@PermissionStatus char(1) = null -- ''G'' - granted, ''D'' - Denied, NULL - all     
SELECT 
@RoleId=4003
,@PermissionTemplateType=NULL
,@ParentId=NULL
,@PermissionStatus=''G''


select * from globalCOdes where category like ''STAFFROLE''

exec [dbo].[csp_ReportGetStaffRolePermissions] @RoleId=4002
,@PermissionTemplateType=NULL
,@ParentId=NULL
,@PermissionStatus=''G''

*/

DECLARE @Title varchar(max)
DECLARE @SubTitle varchar(max)
DECLARE @Comment varchar(max)


SET @Title = ''Staff Role Permissions''
SET @SubTitle = ''All ''
				+Case When @PermissionStatus=''G'' Then ''Granted''
						When @PermissionStatus=''D'' Then ''Denied''
						Else ''Granted or Denied'' End
				+'' Staff Role Permissions for ''
				+isnull((Select CodeName From GlobalCodes Where GlobalCodeId=@RoleId),''All Roles'')
				+'': ''
				+isnull((Select CodeName From GlobalCodes Where GlobalCodeId=@PermissionTemplateType),''All Template Types'')
SET @Comment = ''''
	

DECLARE @PermissionItems table (    
PermissionTemplateType int,    
PermissionTemplateTypeName varchar(100),    
PermissionItemId int,    
PermissionItemName varchar(250),    
ParentId int,    
ParentName varchar(100),    
Denied char(1),    
Granted char(1),    
PermissionTemplateItemId int)    
    
-- Get all available permission items    
insert into @PermissionItems (    
       PermissionTemplateType,    
       PermissionTemplateTypeName,    
       PermissionItemId,    
       PermissionItemName,    
       ParentId,    
       ParentName)    
  exec ssp_GetPermissionItems @PermissionTemplateType = null    
    
    
-- Everything is denied by default    
update @PermissionItems    
   set Granted = ''N'',    
       Denied = ''Y''    
           
-- Apply role permissions    
update pit    
   set Granted = ''Y'',    
       Denied = ''N'',    
       PermissionTemplateItemId = pti.PermissionTemplateItemId     
  from @PermissionItems pit    
       join PermissionTemplates pt on pt.PermissionTemplateType = pit.PermissionTemplateType     
       join PermissionTemplateItems pti on pti.PermissionTemplateId = pt.PermissionTemplateId and pti.PermissionItemId = pit.PermissionItemId    
 where pt.RoleId = @RoleId    
   and isnull(pt.RecordDeleted, ''N'') = ''N''    
   and isnull(pti.RecordDeleted, ''N'') = ''N''    
    
-- Final select    
select pit.PermissionTemplateType,    
       pit.PermissionTemplateTypeName,    
       pit.PermissionItemId,    
       LTRIM(RTRIM(pit.PermissionItemName)) as PermissionItemName,    
       pit.ParentId,    
       LTRIM(RTRIM(pit.ParentName)) as ParentName,    
       pit.Denied,    
       pit.Granted,    
       case when pit.PermissionTemplateItemId is null    
            then convert(int, 0 - row_number() over (order by  pit.PermissionTemplateItemId desc))       
            else pit.PermissionTemplateItemId     
       end as PermissionTemplateItemId,    
       pti.PermissionTemplateId,    
       pti.RowIdentifier,   
       --pti.CreatedBy,    
       --pti.CreatedDate,    
       --pti.ModifiedBy,    
       --pti.ModifiedDate,    
       --pti.RecordDeleted,     
       --pti.DeletedDate,    
       --pti.DeletedBy  
       @Title as Title
       , @SubTitle as SubTitle
       , @Comment as Comment
  from @PermissionItems pit    
       left join PermissionTemplateItems pti on pti.PermissionTemplateItemId = pit.PermissionTemplateItemId    
 where (pit.PermissionTemplateType = @PermissionTemplateType or @PermissionTemplateType is null)    
   and (pit.ParentId = @ParentId or @ParentId is null)    
   and ((pit.Granted = ''Y'' and @PermissionStatus = ''G'') or (pit.Denied = ''Y'' and @PermissionStatus = ''D'') or @PermissionStatus is null)    
 order by pit.PermissionTemplateTypeName, pit.ParentName, pit.PermissionItemName    
 
/*
--PermissionTemplates--              
select PermissionTemplateId              
      ,RoleId              
      ,PermissionTemplateType              
      ,RowIdentifier              
      ,CreatedBy              
      ,CreatedDate              
      ,ModifiedBy              
      ,ModifiedDate              
      ,RecordDeleted              
      ,DeletedDate              
      ,DeletedBy              
  from PermissionTemplates              
 where isnull(RecordDeleted, ''N'') <> ''Y''
 and RoleId=@RoleId
             
             
                
--PermissionTemplateItems--              
select PermissionTemplateItemId              
      ,PermissionTemplateId              
      ,PermissionItemId              
      ,RowIdentifier              
      ,CreatedBy              
      ,CreatedDate              
      ,ModifiedBy              
      ,ModifiedDate              
      ,RecordDeleted              
      ,DeletedDate  
      ,DeletedBy              
  from PermissionTemplateItems              
 where isnull(RecordDeleted, ''N'') <> ''Y'' 
 and PermissionTemplateId in (select PermissionTemplateId from PermissionTemplates
 where RoleId=@RoleId and isnull(RecordDeleted, ''N'') <> ''Y'')      
 */

' 
END
GO
