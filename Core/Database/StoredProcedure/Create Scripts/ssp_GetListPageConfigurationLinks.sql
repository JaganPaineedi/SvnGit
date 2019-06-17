IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetListPageConfigurationLinks]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetListPageConfigurationLinks]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO 
     
CREATE PROCEDURE [dbo].[ssp_GetListPageConfigurationLinks] 
@ScreenId INT        
,@ViewId INT        
AS   
/****************************************************
--Stored Procedure: ssp_GetListPageConfigurationLinks 
-- Purpose:        
--          
-- Author: Rajesh S      
-- Date:   10/05/2017
--History
-- Date          Author          Purpose
-- 10/05/2017    Rajesh		Created to get the list page links EII - 562

***************************************************/      
BEGIN        
        
        
DECLARE @TemplateColumn TABLE        
(        
 ListPageColumnConfigurationColumnId INT  NULL        
 ,ListPageColumnConfigurationId INT NULL        
 ,FieldName varchar(500) NULL        
 ,Caption varchar(500) NULL        
 ,DisplayAs varchar(500) NULL        
 ,SortOrder INT NULL        
 ,ShowColumn type_YOrN NULL        
 ,Width INT NULL        
 ,Fixed type_YOrN NULL        
)        
        
INSERT INTO @TemplateColumn        
SELECT LCC.ListPageColumnConfigurationColumnId        
,LCC.ListPageColumnConfigurationId        
,LCC.FieldName        
,LCC.Caption        
,LCC.DisplayAs        
,LCC.SortOrder        
,LCC.ShowColumn        
,LCC.Width        
,LCC.Fixed        
FROM        
ListPageColumnConfigurations LC         
JOIN ListPageColumnConfigurationColumns LCC ON LC.ListPageColumnConfigurationId=LCC.ListPageColumnConfigurationId        
WHERE        
LC.ScreenId=@ScreenId        
--AND LC.ListPageColumnConfigurationId=@ViewId        
AND Template='Y'        
        
        
SELECT       
      
LCL.ListPageColumnConfigurationColumnLinkId      
,LCL.ListPageColumnConfigurationColumnId      
,LCL.ScreenId      
,LCL.PopUp      
,LCC.FieldName AS StandardColumns      
FROM        
ListPageColumnConfigurations LC         
JOIN ListPageColumnConfigurationColumns LCC ON LC.ListPageColumnConfigurationId=LCC.ListPageColumnConfigurationId        
JOIN ListPageColumnConfigurationColumnLinks LCL ON LCL.ListPageColumnConfigurationColumnId = LCC.ListPageColumnConfigurationColumnId        
--JOIN ListPageColumnConfigurationColumnLinkParameters LCLP ON LCLP.ListPageColumnConfigurationColumnLinkId = LCL.ListPageColumnConfigurationColumnLinkId        
WHERE        
LC.ScreenId=@ScreenId        
AND LC.ListPageColumnConfigurationId=@ViewId        
        
        
SELECT         
 LCLP.ListPageColumnConfigurationColumnLinkParameterId        
 ,LCLP.ListPageColumnConfigurationColumnLinkId        
 ,LCLP.ListPageColumnConfigurationColumnId        
 ,LCL1.FieldName    
 ,ISNULL(LCLP.KeyColumn,'N') AS KeyColumn        
FROM        
 ListPageColumnConfigurations LC         
 JOIN ListPageColumnConfigurationColumns LCC ON LC.ListPageColumnConfigurationId=LCC.ListPageColumnConfigurationId        
 JOIN ListPageColumnConfigurationColumnLinks LCL ON LCL.ListPageColumnConfigurationColumnId = LCC.ListPageColumnConfigurationColumnId        
 JOIN ListPageColumnConfigurationColumnLinkParameters LCLP ON LCLP.ListPageColumnConfigurationColumnLinkId = LCL.ListPageColumnConfigurationColumnLinkId        
 JOIN @TemplateColumn LCL1 ON LCLP.ListPageColumnConfigurationColumnId = LCL1.ListPageColumnConfigurationColumnId        
WHERE        
 LC.ScreenId=@ScreenId        
 AND LC.ListPageColumnConfigurationId=@ViewId        
        
        
        
END 