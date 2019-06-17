
/****** Object:  StoredProcedure [dbo].[ssp_RDLStaffRoleException]    Script Date: 11/23/2015 15:45:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLStaffRoleException]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLStaffRoleException]
GO



/****** Object:  StoredProcedure [dbo].[ssp_RDLStaffRoleException]    Script Date: 11/23/2015 15:45:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
                      
CREATE PROCEDURE [dbo].[ssp_RDLStaffRoleException]                                                
@StaffId INT=0                             
AS                                                  
/******************************************************************************                                                        
**  File:                                                         
**  Name:                                       
**  Desc:                                        
**  Return values:                                                        
**  Called by:                                                          
**  Parameters:StaffId                                                        
**  Input    Output                                     
**                                  
**                                  
**                                                     
**  Auth:  Pradeep Kumar Tripathi         
**  Purpose: used to display any staff/user accounts who have been granted or denied a permission that is outside of any roles assigned to that staff/user account.         
**  The report should display the username, id, and any specific permissions granted or denied that are not congruent with the roles assigned to the user.         
**  It should list the permission type, parent, permission item and indicate either A) "granted" If the user has a permission granted to account that is NOT included in any of the user's assigned roles; or B) "denied" if the user does NOT have a permissio
  
    
      
n that is included in one of the user's assigned roles                            
                                               
*******************************************************************************                                                        
**  Change History                                                        
*******************************************************************************                                                        
**  Date:       Author:    Description:                                                        
**  --------  --------    ----------------------------------------------------                                                        
                   
                        
*******************************************************************************/                                                      
BEGIN                                                  
BEGIN TRY   
if (@StaffId='')  
set @StaffId=0  
        
  declare @StaffRoles table (StaffId int,RoleId int)        
  INSERT INTO @StaffRoles(StaffId,RoleId)        
  SELECT S.StaffId,SR.RoleId FROm StaffRoles SR        
  INNER JOIN Staff S on S.StaffId=SR.StaffId        
  INNER JOIN Globalcodes GC ON GC.GlobalCodeId=SR.RoleId        
  --WHERE S.StaffId  = CASE WHEN (@StaffId  is null) THEN S.StaffId ELSE @StaffId end    
  WHERE S.StaffId  = CASE WHEN (@StaffId=0) THEN S.StaffId ELSE @StaffId end        
  AND ISNULL(SR.RecordDeleted,'N') <> 'Y'        
  and  ISNULL(GC.RecordDeleted,'N') <> 'Y'        
  AND ISNULL(GC.ACTIVE,'N') = 'Y'        
          
          
  declare @PermissionItems table (              
 PermissionTemplateType int,              
 PermissionTemplateTypeName varchar(100),              
 PermissionItemId int,              
 PermissionItemName varchar(250),              
 ParentId int,              
 ParentName varchar(100),              
 Denied char(1),              
           
 Granted char(1),              
 GrantedBy varchar(50),              
 GrantedON DateTime,        
 StaffPermissionExceptionId int)                                                 
  DECLARE @Reports TABLE (        
 ParentFolderId INT        
 ,ParentFolderName VARCHAR(max)        
 ,ReportId INT        
 ,ReportName VARCHAR(500)        
 )         
         
 -- Get report item catalog                  
 ;WITH ReportCatalog (        
  ParentFolderId        
  ,ParentFolderName        
  ,ReportId        
  ,ReportName        
  )        
 AS (        
  -- Anchor definition                  
  SELECT r.ParentFolderId AS ParentFolderId        
   ,convert(VARCHAR(max), '') AS ParentFolderName        
   ,r.ReportId AS ReportId        
   ,r.NAME AS ReportName        
 FROM Reports r        
  WHERE r.ParentFolderId IS NULL        
   AND isnull(r.RecordDeleted, 'N') = 'N'        
          
  UNION ALL        
          
  -- Recursive definition               
  SELECT r.ParentFolderId        
   ,rc.ParentFolderName + CASE         
    WHEN len(rc.ParentFolderName) > 0        
     THEN '\'        
    ELSE ''        
    END + rc.ReportName        
   ,r.ReportId        
   ,r.NAME        
  FROM Reports r        
  INNER JOIN ReportCatalog rc ON rc.ReportId = r.ParentFolderId        
  WHERE isnull(r.RecordDeleted, 'N') = 'N'        
  )        
 INSERT INTO @Reports (        
  ParentFolderId        
  ,ParentFolderName        
  ,ReportId        
  ,ReportName        
  )        
 SELECT rc.ParentFolderId        
  ,rc.ParentFolderName        
  ,rc.ReportId        
  ,rc.ReportName + CASE         
   WHEN r.IsFolder = 'Y'        
    THEN ' (Folder)'        
   ELSE ''        
   END AS ReportName        
 FROM ReportCatalog rc        
 INNER JOIN Reports r ON r.ReportId = rc.ReportId          
         
 -- Get all available permission items         
 -- Get all available permission items              
insert into @PermissionItems (              
       PermissionTemplateType,              
       PermissionTemplateTypeName,              
       PermissionItemId,              
       PermissionItemName,              
       ParentId,              
       ParentName)                      
-- Screen Controls                  
SELECT gc.GlobalCodeId AS PermissionTemplateType        
 ,gc.CodeName AS PermissionTemplateTypeName        
 ,spc.ScreenPermissionControlId AS PermissionItemId        
 ,spc.DisplayAs AS PermissionItemName        
 ,s.ScreenId AS ParentId        
 ,s.ScreenName AS ParentName        
FROM ScreenPermissionControls spc        
INNER JOIN Screens s ON s.ScreenId = spc.ScreenId        
INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = 5701        
WHERE isnull(s.RecordDeleted, 'N') = 'N' AND isnull(spc.RecordDeleted, 'N') = 'N'        
UNION ALL        
        
-- Screen Controls Update Mode                 
SELECT gc.GlobalCodeId AS PermissionTemplateType        
 ,gc.CodeName AS PermissionTemplateTypeName        
 ,spc.ScreenPermissionControlId AS PermissionItemId        
 ,spc.DisplayAs AS PermissionItemName        
 ,s.ScreenId AS ParentId        
 ,s.ScreenName AS ParentName        
FROM ScreenPermissionControls spc        
INNER JOIN Screens s ON s.ScreenId = spc.ScreenId        
INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = 5920        
WHERE  isnull(s.RecordDeleted, 'N') = 'N'        
 AND isnull(spc.RecordDeleted, 'N') = 'N'        
        
UNION ALL            
-- Document codes                  
SELECT gc.GlobalCodeId        
 ,gc.CodeName        
 ,dc.DocumentCodeId        
 ,dc.DocumentName        
 ,NULL        
 ,NULL        
FROM DocumentCodes dc        
INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = 5702        
WHERE  dc.Active = 'Y' AND isnull(dc.RecordDeleted, 'N') = 'N'          
        
UNION ALL        
         
-- Flags        
SELECT GC.GlobalCodeId        
 ,GC.CodeName        
 ,FT.FlagTypeId        
 ,FT.FlagType        
 ,NULL        
 ,NULL        
FROM FlagTypes FT        
INNER JOIN GlobalCodes GC ON dbo.ssf_GetGlobalCodeNameById(GC.GlobalCodeId) = 'Flags'        
WHERE  FT.Active = 'Y'        
 AND ISNULL(FT.RecordDeleted, 'N') = 'N'        
 AND ISNULL(FT.PermissionedFlag, 'N') = 'Y'        
        
UNION ALL        
        
-- Banners                  
SELECT gc.GlobalCodeId        
 ,gc.CodeName        
 ,b.BannerId        
 ,CASE WHEN b.BannerName = b.DisplayAs THEN b.BannerName ELSE b.BannerName + ' (' + b.DisplayAs + ')' END        
 ,t.TabId        
 ,t.TabName        
FROM Banners b        
INNER JOIN Tabs t ON t.TabId = b.TabId        
INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = 5703        
WHERE b.Active = 'Y'        
 AND isnull(b.RecordDeleted, 'N') = 'N'        
 AND isnull(t.RecordDeleted, 'N') = 'N'        
        
UNION ALL        
        
-- Staff lists                  
SELECT gc.GlobalCodeId        
 ,gc.CodeName        
 ,sl.GlobalCodeId        
 ,sl.CodeName        
 ,NULL        
 ,NULL        
FROM GlobalCodes sl        
INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = 5704        
WHERE  sl.Category = 'STAFFLIST'        
 AND sl.Active = 'Y'        
 AND isnull(sl.RecordDeleted, 'N') = 'N'        
        
UNION ALL        
        
-- Client access rules                  
SELECT gc.GlobalCodeId        
 ,gc.CodeName        
 ,ca.GlobalCodeId        
 ,ca.CodeName        
 ,NULL        
 ,NULL        
FROM GlobalCodes ca        
INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = 5705        
WHERE  ca.Category = 'CLIENTACCESSRULE'        
 AND ca.Active = 'Y'        
 AND isnull(ca.RecordDeleted, 'N') = 'N'        
        
UNION ALL        
        
-- Widgets         
SELECT gc.GlobalCodeId        
 ,gc.CodeName        
 ,w.WidgetId        
 ,        
                 
 w.DisplayAs AS WidgetName        
 ,NULL        
 ,NULL        
FROM Widgets w        
INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = 5906        
WHERE isnull(w.RecordDeleted, 'N') = 'N'        
        
UNION ALL        
        
-- Reports                  
SELECT gc.GlobalCodeId        
 ,gc.CodeName        
 ,r.ReportId        
 ,r.ReportName        
 ,r.ParentFolderId        
 ,r.ParentFolderName        
FROM @Reports r        
INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = 5907        
        
UNION ALL        
        
-- Image Associations                  
SELECT gc.GlobalCodeId        
 ,gc.CodeName        
 ,ca.GlobalCodeId        
 ,ca.CodeName        
 ,NULL        
 ,NULL        
FROM GlobalCodes ca        
INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = 5908        
WHERE  ca.Category = 'IMAGEASSOCIATEDWITH'        
 AND ca.Active = 'Y'        
 AND isnull(ca.RecordDeleted, 'N') = 'N'        
        
UNION ALL        
        
-- Staff Access Rules          
SELECT gc.GlobalCodeId        
 ,gc.CodeName        
 ,ca.GlobalCodeId        
 ,ca.CodeName        
 ,NULL        
 ,NULL        
FROM GlobalCodes ca        
INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = 5909        
WHERE  ca.Category = 'STAFFACCESSRULE'        
 AND ca.Active = 'Y'        
 AND isnull(ca.RecordDeleted, 'N') = 'N'        
        
UNION ALL        
        
--Event Types          
SELECT gc.GlobalCodeId        
 ,gc.CodeName        
 ,et.EventTypeId        
 ,et.EventName        
 ,NULL        
 ,NULL        
FROM EventTypes et        
INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = 5905        
WHERE  isnull(et.RecordDeleted, 'N') = 'N'        
        
UNION ALL        
        
--Screens  which are not of Documents Type and not associated with any Banner         
SELECT gc.GlobalCodeId        
 ,gc.CodeName        
 ,s.ScreenId        
 ,s.ScreenName        
 ,t.TabId        
 ,t.TabName        
FROM Screens s        
INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = 5921        
INNER JOIN Tabs t ON t.TabId = s.TabId        
 AND S.ScreenType <> 5763        
WHERE  isnull(S.RecordDeleted, 'N') = 'N'        
 AND isnull(t.RecordDeleted, 'N') = 'N'        
 AND NOT EXISTS (        
  SELECT ScreenId        
  FROM Banners b        
  WHERE isnull(b.RecordDeleted, 'N') = 'N'        
   AND b.ScreenId = s.ScreenId        
  )        
        
UNION ALL        
        
-- Application dropdowns        
SELECT gc.GlobalCodeId        
 ,gc.CodeName        
 ,ad.GlobalCodeId        
 ,ad.CodeName        
 ,NULL        
 ,NULL        
FROM GlobalCodes ad        
INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = 5904        
WHERE  ad.Category = 'APPLICATIONDROPDOWNS'        
 AND ad.Active = 'Y'        
 AND isnull(ad.RecordDeleted, 'N') = 'N'        
                   
        
UNION ALL        
        
SELECT gc.GlobalCodeId AS PermissionTemplateType        
 ,gc.CodeName AS PermissionTemplateTypeName        
 ,os.OrderId AS PermissionItemId        
 ,os.OrderName AS PermissionItemName        
 ,gc1.GlobalCodeId AS ParentId        
 ,gc1.CodeName AS ParentName        
FROM GlobalCodes gc        
INNER JOIN GlobalCodes gc1 ON gc.GlobalCodeId = 5923        
INNER JOIN Orders os ON os.OrderType = gc1.GlobalCodeId        
WHERE  gc1.Category = 'ORDERTYPE'        
 AND os.Permissioned = 'Y'        
 AND ISNULL(gc.RecordDeleted, 'N') = 'N'        
 AND ISNULL(gc1.RecordDeleted, 'N') = 'N'        
 AND ISNULL(os.RecordDeleted, 'N') = 'N'        
         
 UNION ALL        
         
-- Client Information Drop down        
SELECT gc.GlobalCodeId        
 ,gc.CodeName        
 ,c.ClientInformationTabConfigurationId        
 ,c.TabName        
 ,c.ScreenId        
 ,s.ScreenName        
FROM ClientInformationTabConfigurations c        
INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = 5922        
INNER JOIN Screens s ON s.ScreenId = c.ScreenId        
WHERE isnull(c.RecordDeleted, 'N') = 'N'        
         
-- Document Codes (View)         
            UNION ALL        
            SELECT  gc.GlobalCodeId ,        
                    gc.CodeName ,        
                    dc.DocumentCodeId ,        
                    dc.DocumentName ,        
                    NULL ,        
                    NULL        
            FROM    DocumentCodes dc        
                    JOIN GlobalCodes gc ON gc.GlobalCodeId = 5924        
            WHERE   dc.Active = 'Y'        
                    AND ISNULL(dc.RecordDeleted, 'N') = 'N'           
                            
             
update pit              
   set Granted = spe.Allow,              
             
        GrantedBy=spe.CreatedBy,        
       GrantedON=spe.CreatedDate             
  from @PermissionItems pit              
       join StaffPermissionExceptions spe on spe.StaffId = CASE WHEN (@StaffId=0) THEN spe.StaffId ELSE @StaffId END and spe.PermissionTemplateType = pit.PermissionTemplateType and spe.PermissionItemId = pit.PermissionItemId              
 where isnull(spe.RecordDeleted, 'N') = 'N'         
 ----------------Final Select--------------------------        
 
 Select  S.staffid as Id        
 ,(S.LastName+', '+FirstName) as UserName        
 ,pit.PermissionTemplateTypeName as 'Permission Type',ISNULL(pit.ParentName,'') as 'Parent'        
 ,pit.PermissionItemName as 'Permission Item'        
 ,pit.Granted        
 ,pit.GrantedBy as 'Granted/Denied By'        
 ,Convert(varchar(10),pit.GrantedON,101) as 'Granted/Denied Date' 
        
  from @PermissionItems pit join StaffPermissionExceptions spe on  spe.StaffId= CASE WHEN (@StaffId =0) THEN spe.StaffId ELSE @StaffId END         
      and spe.PermissionTemplateType = pit.PermissionTemplateType        
      and spe.PermissionItemId = pit.PermissionItemId        
      Join Staff S on S.StaffId=spe.StaffId and ISNULL(S.RecordDeleted,'N')='N'              
      where isnull(spe.RecordDeleted, 'N') = 'N'        
      AND not exists(select *              
                from PermissionTemplates pt              
                     join @StaffRoles r on r.RoleId = pt.RoleId and r.StaffId=CASE WHEN (@StaffId=0) THEN spe.StaffId ELSE @StaffId END              
                     join PermissionTemplateItems pti on pti.PermissionTemplateId = pt.PermissionTemplateId              
               where pt.PermissionTemplateType = pit.PermissionTemplateType              
                 and pti.PermissionItemId = pit.PermissionItemId              
                 and isnull(pt.RecordDeleted, 'N') = 'N'              
                 and isnull(pti.RecordDeleted, 'N') = 'N')        
    and spe.Allow='Y'         
                      
  UNION 
      
  Select   S.staffid as Id        
 ,(S.LastName+', '+FirstName) as UserName        
  ,pit.PermissionTemplateTypeName as 'Permission Type',ISNULL(pit.ParentName,'') as 'Parent'        
 ,pit.PermissionItemName as 'Permission Item'        
 ,pit.Granted        
 ,pit.GrantedBy as 'Granted/Denied By'        
 ,convert(varchar(10),pit.GrantedON,101) as 'Granted/Denied Date'        
  from @PermissionItems pit join StaffPermissionExceptions spe on spe.StaffId = CASE WHEN (@StaffId=0) THEN spe.StaffId ELSE @StaffId END        
      and spe.PermissionTemplateType = pit.PermissionTemplateType        
      and spe.PermissionItemId = pit.PermissionItemId         
      Join Staff S on S.StaffId=spe.StaffId and ISNULL(S.RecordDeleted,'N')='N'              
      where isnull(spe.RecordDeleted, 'N') = 'N'        
      AND exists(select *              
                from PermissionTemplates pt              
                     join @StaffRoles r on r.RoleId = pt.RoleId and r.StaffId=CASE WHEN (@StaffId=0) THEN spe.StaffId ELSE @StaffId END              
                     join PermissionTemplateItems pti on pti.PermissionTemplateId = pt.PermissionTemplateId              
               where pt.PermissionTemplateType = pit.PermissionTemplateType              
                 and pti.PermissionItemId = pit.PermissionItemId              
                 and isnull(pt.RecordDeleted, 'N') = 'N'              
                 and isnull(pti.RecordDeleted, 'N') = 'N')        
    and spe.Allow='N'         
    order by S.StaffId                                                
END TRY                                                    
                                                  
BEGIN CATCH                                                     
DECLARE @Error varchar(8000)                                                      
 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                       
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[ssp_RDLStaffRoleException]')                                                       
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())            
    + '*****' + Convert(varchar,ERROR_STATE())                                                      
                                                  
 RAISERROR                                                       
 (                                                      
  @Error, -- Message text.                                                      
  16, -- Severity.                                                      
  1 -- State.                                                      
 );                                                      
                                                      
END CATCH                                                   
END 

GO


