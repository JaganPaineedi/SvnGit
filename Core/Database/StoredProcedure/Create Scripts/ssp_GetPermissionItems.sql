IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetPermissionItems]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetPermissionItems]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetPermissionItems] 
@PermissionTemplateType INT = NULL
AS
	/********************************************************************************                                
-- Stored Procedure: dbo.ssp_GetPermissionItems 5930                                
--                                
-- Copyright: Streamline Healthcate Solutions                                
--                                
-- Purpose: gets a list of permission items                         
--                                
-- Updates:                                                                                       
-- Date        Author			Purpose                                
-- 07.06.2010  SFarber			Created.           
-- 08.30.2010  SFarber			Added support for the 'Image Associations' template.           
--								Remapped 5706 and 5707 to 5906 and 5907 accordingly.    
-- 02.25.2011  SFarber          Added support for the 'Staff Access Rule' template.  
-- 06.08.2011  SFarber          Remapped missed case of 5707 to 5907.  Unioned 'Staff Access Rule' template to the main Select.  
-- 28.07.2011  Sonia Dhamija    Added support for 'Event Types' template
-- 08.31.2011  Kgarg			Added Support for the 'Screen Update Mode' (5920) template.
-- 04.21.2012  Anil chaturvedi	Change column name ref:task#971 in kalamazoo.
-- 04.30.2012  Rohit Katoch		Change column name ref:task#989 in kalamazoo.
-- 06.05.2012  Sonia Dhamija    Changes done to support new Permission Template i.e Screens
-- 04.07.2014  Shruthi.S        Changed widgetname pulling logic to display widgetnames as Master.Ref #2.1 Care Management to Smartcare.
-- 06.07.2014  SFarber          Added support for the 'Application Dropdowns' template. 
-- 12 Jan 2015	Avi Goyal		What : Added Result Set for Flag Types
								Why : Task : 600 Security Alerts ; Project : Network-180 Customizations  
-- 15.03.2015	Revathi			what:Added Orders in permission type
								why:task #873 woods-Customization  
-- MAY-7-2015	dharvey				Added missing UNIONs that were preventing template details from being displayed in UI    
-- MAY-8-2015	Steczynski			Added (DisplayAs) to presentation of banner name, System Improvements - Wish List Task #1      
-- JUN.23.2015	Chethan N			What : Added Document Code(View) in permission type
									Why : Macon Design Task#60  
-- Dec.13.2016	Ajay   			    What : Added CONTACT NOTE REASON in permission type
									Why : Woods - Support Go Live Task#143  
-- JUNE.27.2017 Akwinass		    What : Added "Action Templates" in permission type
									Why : Engineering Improvement Initiatives- NBL(I) #536              					
-- Jan.23.2018 Manjunath		    What : Added "SmartView" in permission type
--									Why : For Engineering Improvement Initiatives- NBL(I) 599. 
-- Feb.15.2018 RK                   What: Client Hover: Enhancements being requested
									Why: MHP-Customizations - Task 121
									
-- SEP.27.2018 Akwinass             What: Added Rx Permissions
									Why: #21 Renaissance - Dev Items
-- Dec-04-2018 Vishnu Narayanan     What : Added Notification Permissions
                                    Why : Mobile#6   
*********************************************************************************/
BEGIN           
    
BEGIN TRY

DECLARE @IsPermissionContactReason Char(1) 

      SET @IsPermissionContactReason = 
      (SELECT TOP 1 Value 
       FROM   SystemConfigurationKeys 
       WHERE  [Key] = 'SHOWPERMISSIONEDCONTACTREASONS' AND ISNULL(RecordDeleted,'N')='N' )
       
DECLARE @Reports TABLE (
	ParentFolderId INT
	,ParentFolderName VARCHAR(max)
	,ReportId INT
	,ReportName VARCHAR(500)
	)
	
 
IF (
		@PermissionTemplateType = 5907
		OR @PermissionTemplateType IS NULL
		)
BEGIN
	-- Get report item catalog          
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
END

-- Get all available permission items          
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
WHERE (
		gc.GlobalCodeId = @PermissionTemplateType
		OR @PermissionTemplateType IS NULL
		)
	AND isnull(s.RecordDeleted, 'N') = 'N'
	AND isnull(spc.RecordDeleted, 'N') = 'N'

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
WHERE (
		gc.GlobalCodeId = @PermissionTemplateType
		OR @PermissionTemplateType IS NULL
		)
	AND isnull(s.RecordDeleted, 'N') = 'N'
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
WHERE (
		gc.GlobalCodeId = @PermissionTemplateType
		OR @PermissionTemplateType IS NULL
		)
	AND dc.Active = 'Y'
	AND isnull(dc.RecordDeleted, 'N') = 'N'
-- Added By Avi Goyal, on 12 Jan 2015  

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
WHERE (
		GC.GlobalCodeId = @PermissionTemplateType
		OR @PermissionTemplateType IS NULL
		)
	AND FT.Active = 'Y'
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
WHERE (
		gc.GlobalCodeId = @PermissionTemplateType
		OR @PermissionTemplateType IS NULL
		)
	AND b.Active = 'Y'
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
WHERE (
		gc.GlobalCodeId = @PermissionTemplateType
		OR @PermissionTemplateType IS NULL
		)
	AND sl.Category = 'STAFFLIST'
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
WHERE (
		gc.GlobalCodeId = @PermissionTemplateType
		OR @PermissionTemplateType IS NULL
		)
	AND ca.Category = 'CLIENTACCESSRULE'
	AND ca.Active = 'Y'
	AND isnull(ca.RecordDeleted, 'N') = 'N'

UNION ALL

-- Widgets           
SELECT gc.GlobalCodeId
	,gc.CodeName
	,w.WidgetId
	,
	--Added by Shruthi.S To display the widgetname as master in staff details Roles/permissions.         
	w.DisplayAs AS WidgetName
	,NULL
	,NULL
FROM Widgets w
INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = 5906
WHERE (
		gc.GlobalCodeId = @PermissionTemplateType
		OR @PermissionTemplateType IS NULL
		)
	AND isnull(w.RecordDeleted, 'N') = 'N'

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
WHERE (
		gc.GlobalCodeId = @PermissionTemplateType
		OR @PermissionTemplateType IS NULL
		)

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
WHERE (
		gc.GlobalCodeId = @PermissionTemplateType
		OR @PermissionTemplateType IS NULL
		)
	AND ca.Category = 'IMAGEASSOCIATEDWITH'
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
WHERE (
		gc.GlobalCodeId = @PermissionTemplateType
		OR @PermissionTemplateType IS NULL
		)
	AND ca.Category = 'STAFFACCESSRULE'
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
WHERE (
		gc.GlobalCodeId = @PermissionTemplateType
		OR @PermissionTemplateType IS NULL
		)
	AND isnull(et.RecordDeleted, 'N') = 'N'

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
WHERE (
		gc.GlobalCodeId = @PermissionTemplateType
		OR @PermissionTemplateType IS NULL
		)
	AND isnull(S.RecordDeleted, 'N') = 'N'
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
WHERE (
		gc.GlobalCodeId = @PermissionTemplateType
		OR @PermissionTemplateType IS NULL
		)
	AND ad.Category = 'APPLICATIONDROPDOWNS'
	AND ad.Active = 'Y'
	AND isnull(ad.RecordDeleted, 'N') = 'N'
----Orders Added by Revathi 15.03.2015            

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
WHERE (
		gc.GlobalCodeId = @PermissionTemplateType
		OR @PermissionTemplateType IS NULL
		)
	AND gc1.Category = 'ORDERTYPE'
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
WHERE (
		gc.GlobalCodeId = @PermissionTemplateType
		OR @PermissionTemplateType IS NULL
		)
	AND isnull(c.RecordDeleted, 'N') = 'N'
	
-- Document Codes (View) Added by Chethan  N
            UNION ALL
            SELECT  gc.GlobalCodeId ,
                    gc.CodeName ,
                    dc.DocumentCodeId ,
                    dc.DocumentName ,
                    NULL ,
                    NULL
            FROM    DocumentCodes dc
                    JOIN GlobalCodes gc ON gc.GlobalCodeId = 5924
            WHERE   ( gc.GlobalCodeId = @PermissionTemplateType
                      OR @PermissionTemplateType IS NULL
                    )
                    AND dc.Active = 'Y'
                    AND ISNULL(dc.RecordDeleted, 'N') = 'N'
 
  UNION ALL
 	-- Client CONTACT NOTE REASON             
	SELECT gc.GlobalCodeId
		,gc.CodeName
		,ca.GlobalCodeId
		,ca.CodeName
		,gc1.GlobalCodeId
		,gc1.CodeName
		
	FROM GlobalCodes ca
	INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = 5925
	INNER JOIN GlobalCodes gc1 ON gc1.GlobalCodeId = 9409
	
	WHERE (
			gc.GlobalCodeId = @PermissionTemplateType
			OR @PermissionTemplateType IS NULL
			)
		AND ca.Category = 'CONTACTNOTEREASON'
		AND ca.Active = 'Y'
		AND isnull(ca.RecordDeleted, 'N') = 'N'
		AND  ISNULL(@IsPermissionContactReason,'N')='Y'
	
	UNION ALL	
	-- JUNE.27.2017 Akwinass
	SELECT gc.GlobalCodeId
		,gc.CodeName
		,sl.GlobalCodeId
		,sl.CodeName
		,NULL
		,NULL
	FROM GlobalCodes sl
	INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = 5927
	WHERE (
			gc.GlobalCodeId = @PermissionTemplateType
			OR @PermissionTemplateType IS NULL
			)
		AND sl.Category = 'ACTIONTEMPLATES'
		AND sl.Active = 'Y'
		AND isnull(sl.RecordDeleted, 'N') = 'N'
	UNION ALL	
	  -- SmartView     ---- Jan.23.2018 Manjunath         
	SELECT gc.GlobalCodeId  
	 ,gc.CodeName  
	 ,w.SmartViewSectionId  
	 ,w.DisplayAs AS SectionName  
	 ,NULL  
	 ,NULL  
	FROM SmartViewSections w  
	INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = 5929  
	WHERE (  
	  gc.GlobalCodeId = @PermissionTemplateType  
	  OR @PermissionTemplateType IS NULL  
	  )  
	 AND isnull(w.RecordDeleted, 'N') = 'N'  
--Feb.15.2018 RK 	
 UNION ALL    
 SELECT   
   5930 AS PermissionTemplateType  
   ,'Tool Tip' AS PermissionTemplateTypeName
   ,CIT.ClientInformationToolTipItemId AS PermissionItemId
   ,CIT.[Name] AS PermissionItemName  
   ,NULL  
   ,NULL   
 FROM  ClientInformationToolTipItems CIT   
 Where isnull(CIT.RecordDeleted, 'N') = 'N'
   and (@PermissionTemplateType=5930 OR @PermissionTemplateType IS NULL)
 
  UNION ALL
 

-- SEP.27.2018 Akwinass 
SELECT 5932 AS PermissionTemplateType
	,'Rx' AS PermissionTemplateTypeName
	,sa.ActionId AS PermissionItemId
	,sa.[Action] AS PermissionItemName
	,NULL
	,NULL
FROM SystemActions sa
WHERE isnull(sa.RecordDeleted, 'N') = 'N'
	AND sa.ApplicationId = 5
	AND sa.ActionId <> 10074
	AND (@PermissionTemplateType = 5932 OR @PermissionTemplateType IS NULL)
	
 --Vishnu Narayanan - Notifications  
 UNION ALL  
 SELECT gcs.GlobalCodeId    
  ,gcs.CodeName    
  ,gc.GlobalCodeId    
  ,gc.CodeName    
  ,NULL    
  ,NULL    
 FROM GlobalCodes gc    
 INNER JOIN GlobalCodes gcs ON gcs.GlobalCodeId = 5933
 WHERE (    
   gcs.GlobalCodeId = @PermissionTemplateType    
   OR @PermissionTemplateType IS NULL    
   )    
  AND gc.Category = 'NOTIFICATIONTYPE'    
  AND gc.Active = 'Y'    
  AND isnull(gc.RecordDeleted, 'N') = 'N'     		
  END TRY          
  BEGIN CATCH                           
  declare @Error varchar(8000)                                                      
  set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                       
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_GetPermissionItems')                                                       
  + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                        
  + '*****' + Convert(varchar,ERROR_STATE())                                                                      
  End CATCH          
 End 
GO

