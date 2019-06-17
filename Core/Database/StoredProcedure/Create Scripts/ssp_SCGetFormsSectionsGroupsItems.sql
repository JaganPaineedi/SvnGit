IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetFormsSectionsGroupsItems]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetFormsSectionsGroupsItems]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[ssp_SCGetFormsSectionsGroupsItems] 
(
	@FormId int
)	
AS
 /********************************************************************************                                                                                                              
-- Stored Procedure: ssp_SCGetFormsSectionsGroupsItems                                                                                                            
--                                                                                                              
-- Copyright: Streamline Healthcate Solutions                                                                                                              
--                                                                                                              
-- Purpose: To get the data from all 4 tables ie Forms, FormSections, FormSectionGroups,FormItems Table.                 
-- Parameters:
-- Input  	:               @FormId                                                                                                                                                                                                                                                                          
-- Author:                  Swapan Mohan                                                                                                       
-- Creation Date:           May 22,2012
-- Modifications:           Aug 23, 2012
-- Modified By:             Swapan Mohan
-- Modification Purpose:    Added more fields in Select command of FormItems table. 
-- Modified By :			Jaswinderjeet
-- Modification Purpose:	As Show Pencilicon Colum is is missing so add the the column in select statement 
-- Modified By :			Ajay k Bangar
-- Modified on :			20/Nov/2015
-- Modification Purpose:    Added HasStoredProcedureParameter Column in FormItems Table- Camino Customization:Task#18 :Add custom fields to client information C screen
-- Modified on :			13/Sept/2016  Nandita		      Added mobile column to Form table
-- Dec 7 2016	Pradeep.A	Added FormHTML and MobileFormHTML columns
-- 05-10-2017   Rajesh		Added new columns FormType, DetailScreenId EII - 562
-- 02-06-2018   Rajesh		Added new columns FormJavascript,IsJavascriptOverride,FormGUID 
							and added select statement for FormJavascriptXmlCollections table EII - 627
*********************************************************************************/  
BEGIN TRY  
	----------------FORMS---------------------------
SELECT [FormId]
	,F.[CreatedBy]
	,F.[CreatedDate]
	,F.[ModifiedBy]
	,F.[ModifiedDate]
	,F.[RecordDeleted]
	,F.[DeletedDate]
	,F.[DeletedBy]
	,F.[FormName]
	,F.[TableName]
	,F.[TotalNumberOfColumns]
	,F.[Active]
	,F.[RetrieveStoredProcedure]
	,F.[JavascriptFilePath]
	,F.[Mobile]
	,F.[FormHTML]
	,F.[MobileFormHTML]
	,F.[FormType]
	,G.Code AS [FormTypeCode]     
	,F.[DetailScreenId]   
	,ISNULL(F.[FormJavascript],'') AS FormJavascript           
	,F.[IsJavascriptOverride]          
	,F.[FormGUID] 
	,ISNULL(F.[Core],'N') AS Core    
	FROM [Forms]  F  
	LEFT JOIN [GlobalCodes] AS G ON G.GlobalCodeId = F.FormType  
	WHERE F.FormId=@FormId  
       ----------------FORM SECTIONS---------------------------
SELECT [FormSectionId]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedDate]
      ,[DeletedBy]
      ,[FormId]
      ,[SortOrder]
      ,[PlaceOnTopOfPage]
      ,[SectionLabel]
      ,[Active]
      ,[SectionEnableCheckBox]
      ,[SectionEnableCheckBoxText]
      ,[SectionEnableCheckBoxColumnName]
      ,[NumberOfColumns]
      ,[ShowPencilIcon]
FROM [FormSections] WHERE FormSections.FormId=@FormId ORDER BY SortOrder ASC
		----------------FORM SECTION GROUPS---------------------------
SELECT FormSectionGroupId
      ,FormSectionGroups.CreatedBy
      ,FormSectionGroups.CreatedDate
      ,FormSectionGroups.ModifiedBy
      ,FormSectionGroups.ModifiedDate
      ,FormSectionGroups.RecordDeleted
      ,FormSectionGroups.DeletedDate
      ,FormSectionGroups.DeletedBy
      ,FormSectionGroups.GroupName
      ,FormSectionGroups.FormSectionId
      ,FormSectionGroups.SortOrder
      ,FormSectionGroups.GroupLabel
      ,FormSectionGroups.Active
      ,FormSectionGroups.GroupEnableCheckBox
      ,FormSectionGroups.GroupEnableCheckBoxText
      ,FormSectionGroups.GroupEnableCheckBoxColumnName
      ,FormSectionGroups.NumberOfItemsInRow
      ,FormSectionGroups.ShowPencilIcon
  FROM [FormSectionGroups]
  INNER JOIN FormSections ON FormSections.FormSectionId=FormSectionGroups.FormSectionId
  WHERE FormSections.FormId=@FormId
 -- WHERE FormSectionId IN (SELECT FormSectionId FROM FormSections WHERE FormSections.FormId=100)
  ORDER BY FormSectionGroups.FormSectionId ASC  ,FormSectionGroups.SortOrder ASC

	----------------------FORM ITEMS-----------------------------
SELECT FormItems.[FormItemId]
      ,FormItems.[CreatedBy]
      ,FormItems.[CreatedDate]
      ,FormItems.[ModifiedBy]
      ,FormItems.[ModifiedDate]
      ,FormItems.[RecordDeleted]
      ,FormItems.[DeletedDate]
      ,FormItems.[DeletedBy]
      ,FormItems.[FormSectionId]
      ,FormItems.[FormSectionGroupId]
      ,FormItems.[ItemType]
      ,FormItems.[ItemLabel]
      ,FormItems.[SortOrder]
      ,FormItems.[Active]
      ,FormItems.[GlobalCodeCategory]
      ,FormItems.[ItemColumnName]
      ,FormItems.[ItemRequiresComment]
      ,FormItems.[ItemCommentColumnName]
      ,FormItems.[ItemWidth]
      ,FormItems.[MaximumLength]
      ,FormItems.[DropdownType]
      ,FormItems.[SharedTableName]
      ,FormItems.[StoredProcedureName]
      ,FormItems.[ValueField]
      ,FormItems.[TextField]
      ,FormItems.[MultilineEditFieldHeight]
      ,FormItems.[EachRadioButtonOnNewLine]
      --These 3 fields are added in select query as data-model is changed for FormItems table.
      ,FormItems.[InformationIcon]
      ,FormItems.[InformationIconStoredProcedure]
      ,FormItems.[ExcludeFromPencilIcon]
      ,FormItems.[HasStoredProcedureParameter] -- added by Ajay on 20 Nov 2015:Task#18
      ,FormItems.[Filter]      
      ,FormItems.[FilterName]   
  FROM [FormItems]
  INNER JOIN FormSections on FormSections.FormSectionId=FormItems.FormSectionId 
  WHERE ISNULL(FormItems.RecordDeleted,'N') = 'N' AND  FormItems.FormSectionId in (select FormSectionId from FormSections where FormId=@FormId) 
  order by FormItems.[FormSectionId]  ASC,FormItems.[FormSectionGroupId] ASC ,FormItems.[SortOrder] asc
  
  
	SELECT             
		FJ.FormJavascriptXmlCollectionId            
		,FJ.FormId            
		,FJ.JavascriptXML            
		,FJ.CreatedBy            
		,FJ.CreatedDate            
		,FJ.ModifiedBy            
		,FJ.ModifiedDate            
		,FJ.RecordDeleted            
		,FJ.DeletedDate            
		,FJ.DeletedBy            
	FROM            
		FormJavascriptXmlCollections FJ            
	INNER JOIN Forms F ON F.FormId = FJ.FormId            
	WHERE F.FormId=@FormId              
	AND ISNULL(FJ.RecordDeleted,'N') = 'N' 
END TRY                      
                    
BEGIN CATCH                      
 declare @Error varchar(8000)                      
 set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                       
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCGetFormsSectionsGroupsItems')                       
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                        
    + '*****' + Convert(varchar,ERROR_STATE())                      
 RAISERROR                       
 (                      
  @Error, -- Message text.                      
  16,  -- Severity.                      
  1  -- State.                      
 );                   
END CATCH
GO


