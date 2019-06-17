IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetPermissionTemplateParentItems]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetPermissionTemplateParentItems]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetPermissionTemplateParentItems]
	/********************************************************************************                                  
-- Stored Procedure: exec dbo.ssp_GetPermissionTemplateParentItems                                    
--                                  
-- Copyright: Streamline Healthcate Solutions                                  
--                                  
-- Purpose: gets parent items for permission templates            
--                                  
-- Updates:                                                                                         
-- Date        Author			Purpose
--------------------------------------------------------------------------------                                  
-- 08.30.2010	SFarber			Created.        
-- 08.25.2011	KGarg			Altered(Added Condition for 5920)                 
-- 06.05.2012	Sonia Dhamija	Supported new permission template type i.e screens  
-- 25.05.2014	Vaibhav Khare	Commiting on DEV environment     
-- 12 Jan 2015	Avi Goyal		What : Added Parent for Flags
								Why : Task : 600 Security Alerts ; Project : Network-180 Customizations
-- 15.03.2015	Revathi			what:Added Orders in permission type
								why:task #873 woods-Customization	
-- 13-Dec-2016  Ajay			what:Added CLIENT CONTACT NOTE in permission type
								why: Woods - Support Go Live: Task#143
-- JUNE.27.2017 Akwinass		What : Added "Action Templates" in permission type
								Why : Engineering Improvement Initiatives- NBL(I) #536 	
-- Jan.23.2018 Manjunath		What : Added "SmartView" in permission type
								Why : For Engineering Improvement Initiatives- NBL(I) 599.
-- SEP.27.2018 Akwinass         What: Added Rx Permissions
								Why: #21 Renaissance - Dev Items								
*********************************************************************************/
AS
BEGIN
	BEGIN TRY
	
	DECLARE @IsPermissionContactReason Char(1) 

      SET @IsPermissionContactReason = 
      (SELECT TOP 1 Value 
       FROM   SystemConfigurationKeys 
       WHERE  [Key] = 'SHOWPERMISSIONEDCONTACTREASONS' AND ISNULL(RecordDeleted,'N')='N') 

DECLARE @Reports TABLE (
	ParentFolderId INT
	,ParentFolderName VARCHAR(max)
	,ReportId INT
	,ReportName VARCHAR(500)
	);

WITH ReportCatalog (
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
ORDER BY rc.ParentFolderName
	,ReportName

-- Screen Controls            
SELECT gc.GlobalCodeId AS PermissionTemplateType
	,s.ScreenId AS ParentId
	,s.ScreenName AS ParentName
FROM Screens s
INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = 5701
WHERE isnull(s.RecordDeleted, 'N') = 'N'
	AND EXISTS (
		SELECT *
		FROM ScreenPermissionControls spc
		WHERE spc.ScreenId = s.ScreenId
			AND isnull(spc.RecordDeleted, 'N') = 'N'
		)

UNION

-- Screen Controls Update        
SELECT gc.GlobalCodeId AS PermissionTemplateType
	,s.ScreenId AS ParentId
	,s.ScreenName AS ParentName
FROM Screens s
INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = 5920
WHERE isnull(s.RecordDeleted, 'N') = 'N'
	AND EXISTS (
		SELECT *
		FROM ScreenPermissionControls spc
		WHERE spc.ScreenId = s.ScreenId
			AND isnull(spc.RecordDeleted, 'N') = 'N'
		)

UNION

-- Document codes            
SELECT gc.GlobalCodeId AS PermissionTemplateType
	,NULL AS ParentId
	,NULL AS ParentName
FROM GlobalCodes gc
WHERE gc.GlobalCodeId = 5702

UNION

-- Banners            
SELECT gc.GlobalCodeId AS PermissionTemplateType
	,t.TabId AS ParentId
	,t.TabName AS ParentName
FROM Tabs t
INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = 5703
WHERE isnull(t.RecordDeleted, 'N') = 'N'
	AND EXISTS (
		SELECT *
		FROM Banners b
		WHERE b.TabId = t.TabId
			AND b.Active = 'Y'
			AND isnull(b.RecordDeleted, 'N') = 'N'
		)

UNION

-- Staff lists            
SELECT gc.GlobalCodeId AS PermissionTemplateType
	,NULL AS ParentId
	,NULL AS ParentName
FROM GlobalCodes gc
WHERE gc.GlobalCodeId = 5704

UNION

-- Client access rules            
SELECT gc.GlobalCodeId AS PermissionTemplateType
	,NULL AS ParentId
	,NULL AS ParentName
FROM GlobalCodes gc
WHERE gc.GlobalCodeId = 5705

UNION

-- Widgets             
SELECT gc.GlobalCodeId AS PermissionTemplateType
	,NULL AS ParentId
	,NULL AS ParentName
FROM GlobalCodes gc
WHERE gc.GlobalCodeId = 5906

UNION

-- Reports            
SELECT gc.GlobalCodeId AS PermissionTemplateType
	,r.ParentFolderId AS ParentId
	,r.ParentFolderName AS ParentName
FROM @Reports r
INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = 5907

UNION

-- Image Associations            
SELECT gc.GlobalCodeId AS PermissionTemplateType
	,NULL AS ParentId
	,NULL AS ParentName
FROM GlobalCodes gc
WHERE gc.GlobalCodeId = 5908

UNION

-- Screens (Tab)
SELECT gc.GlobalCodeId AS PermissionTemplateType
	,s.ScreenId AS ParentId
	,s.ScreenName AS ParentName
FROM Screens s
INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = 5922
WHERE isnull(s.RecordDeleted, 'N') = 'N'
	AND s.ScreenId IN (969)

UNION

-- Screens Template i.e 5921     
SELECT gc.GlobalCodeId AS PermissionTemplateType
	,t.TabId AS ParentId
	,t.TabName AS ParentName
FROM Tabs t
INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = 5921
WHERE isnull(t.RecordDeleted, 'N') = 'N'
	AND EXISTS (
		SELECT *
		FROM Screens S
		WHERE S.TabId = t.TabId
			AND isnull(S.RecordDeleted, 'N') = 'N'
		)
-- Added By Avi Goyal, on 12 Jan 2015 

UNION

-- Flags
SELECT GC.GlobalCodeId AS PermissionTemplateType
	,NULL AS ParentId
	,NULL AS ParentName
FROM GlobalCodes GC
WHERE dbo.ssf_GetGlobalCodeNameById(GC.GlobalCodeId) = 'Flags'


	
UNION

--Select permission type: Orders Added by Revathi 15.03.2015
SELECT gc.GlobalCodeId AS PermissionTemplateType
	,gc1.GlobalCodeId AS ParentId
	,gc1.CodeName AS ParentName
FROM Globalcodes gc
INNER JOIN GlobalCodes gc1 ON gc.GlobalCodeId = 5923
WHERE gc1.Category = 'ORDERTYPE'
	AND ISNULL(gc1.RecordDeleted, 'N') = 'N'
	AND ISNULL(gc.RecordDeleted, 'N') = 'N'

UNION

-- JUNE.27.2017 Akwinass           
SELECT gc.GlobalCodeId AS PermissionTemplateType
	,NULL AS ParentId
	,NULL AS ParentName
FROM GlobalCodes gc
WHERE gc.GlobalCodeId = 5927

UNION
-- Jan.23.2018 Manjunath
--SmartView             
SELECT gc.GlobalCodeId AS PermissionTemplateType
	,NULL AS ParentId
	,NULL AS ParentName
FROM GlobalCodes gc
WHERE gc.GlobalCodeId = 5929 
AND ISNULL(gc.RecordDeleted, 'N') = 'N'
-- Added by Ajay:Select permission type:  CLIENT CONTACT NOTE
UNION 
SELECT gc.GlobalCodeId AS PermissionTemplateType  
 ,gc1.GlobalCodeId AS ParentId  
 ,gc1.CodeName AS ParentName  
FROM Globalcodes gc  
INNER JOIN GlobalCodes gc1 ON gc.GlobalCodeId = 5925  
WHERE gc1.Category = 'CLIENTCONTACTNOTE'  
 AND ISNULL(gc1.RecordDeleted, 'N') = 'N'  
 AND ISNULL(gc.RecordDeleted, 'N') = 'N'  
 AND  ISNULL(@IsPermissionContactReason,'N')='Y'
 		
UNION
-- SEP.27.2018 Akwinass           
SELECT gc.GlobalCodeId AS PermissionTemplateType
	,NULL AS ParentId
	,NULL AS ParentName
FROM GlobalCodes gc
WHERE gc.GlobalCodeId = 5932

ORDER BY PermissionTemplateType  
 ,ParentName  
 ,ParentId  

   
	
END TRY          
  BEGIN CATCH                           
  declare @Error varchar(8000)                                                      
  set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                       
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_GetPermissionTemplateParentItems')                                                       
  + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                        
  + '*****' + Convert(varchar,ERROR_STATE())                                                                      
  End CATCH          
 End 
GO

