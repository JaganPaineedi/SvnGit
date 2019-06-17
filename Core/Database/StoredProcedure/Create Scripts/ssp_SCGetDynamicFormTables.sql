                          
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ssp_SCGetDynamicFormTables')
BEGIN
	DROP  Procedure  ssp_SCGetDynamicFormTables
END
 
GO

Create PROCEDURE [dbo].[ssp_SCGetDynamicFormTables]                      
                                     
                                           
/******************************************************************************                                                  
**File: SharedTables.cs                                                  
**Name:SHS.DataServices                                
**Desc:Used to get all the Dynamic Form Tables                                   
**Return values:                                                  
**                                                               
**  Parameters:                                                  
**  Input       Output                                                  
**                                     
**                                            
**                                              
**                                            
**  Auth:  Sonia Dhamija                                          
**  Date:  12th June                                                 
*******************************************************************************                                                  
**  Change History                                                  
*******************************************************************************                                                  
**  Date:         Author:       Description:                           
**  --------  --------    ----------------------------------------------------       
 18/May/2011    Karan Garg Added 9 columns to FormItems table          
 14/June/2011    Jagdeep Hundal Added [EachRadioButtonOnNewLine] columns to FormItems table                
 8/Dec/2011       Sudhir Singh added [JavascriptFilePath]    colomn in Forms table   
 12/DEC/2011 Sudhir Singh added [InformationIcon],[InformationIconStoredProcedure]   colomn in formitems    
 13/Aug/2012  Vishant Garg added Active column in Forms table   
 20/Nov/2015 Ajay k Bangar Added HasStoredProcedureParameter Column in FormItems Table- Camino Customization:Task#18 :Add custom fields to client information C screen              
 13/Sept/2016  Nandita		      Added mobile column to DocumentCodes table
 02/08/2017 Rajesh				Added Column FormHTML in Forms table Engineering Improvement initiative -552
 05/10/2017 Rajesh				Added new columns FormType, DetailScreenId EII - 562
-- 02-06-2018   Rajesh		Added new columns FormJavascript,IsJavascriptOverride,FormGUID 
							and added select statement for table EII - 627
*******************************************************************************/                      
AS                      
 BEGIN                                                
                        
  BEGIN TRY                      
  SELECT [FormId]          
		,[FormName]          
		,[TableName]          
		,[TotalNumberOfColumns]   
		,[JavascriptFilePath]  
		,[Active]='Y'
		,[RetrieveStoredProcedure]
		,[Mobile]
		,[FormHTML]       
		,[FormType]  
		,[DetailScreenId] 
		,[FormJavascript]      
		,FormGUID   
    FROM [Forms] where ISNULL(RecordDeleted,'N')='N'              
                   
SELECT [FormSectionId]          
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
       FROM [FormSections] WHERE ISNULL(RecordDeleted,'N')='N'            
              
              
SELECT [FormSectionGroupId]            
      ,[FormSectionId]            
      ,[SortOrder]            
      ,[GroupLabel]            
      ,[Active]            
      ,[GroupEnableCheckBox]            
      ,[GroupEnableCheckBoxText]            
      ,[GroupEnableCheckBoxColumnName]            
      ,[NumberOfItemsInRow] 
      ,[ShowPencilIcon]            
  FROM [FormSectionGroups] WHERE ISNULL(RecordDeleted,'N')='N'            
            
SELECT [FormItemId]          
      ,[FormSectionId]          
      ,[FormSectionGroupId]          
      ,[ItemType]          
      ,[ItemLabel]          
      ,[SortOrder]          
      ,[Active]          
      ,[GlobalCodeCategory]          
      ,[ItemColumnName]          
      ,[ItemRequiresComment]          
      ,[ItemCommentColumnName]          
      ,[MaximumLength]          
      ,[DropdownType]          
      ,[SharedTableName]          
      ,[StoredProcedureName]          
      ,[ValueField]          
      ,[TextField]         
      ,itemWidth       
      ,[CreatedBy]      
      ,[CreatedDate]      
      ,[ModifiedBy]        
      ,[ModifiedDate]      
      ,[RecordDeleted]      
      ,[DeletedDate]      
      ,[DeletedBy]      
      ,[MultilineEditFieldHeight]    
    ,[EachRadioButtonOnNewLine]  
    ,[InformationIcon]
    ,[InformationIconStoredProcedure]
    ,ExcludeFromPencilIcon
    ,HasStoredProcedureParameter  -- added by Ajay on 20 Nov 2015:Task#18
	,Filter      
	,FilterName 
    FROM [FormItems] WHERE ISNULL(RecordDeleted,'N')='N'            
                                    
  END TRY                      
  BEGIN CATCH                      
   DECLARE @Error varchar(8000)                                                
      SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                 
         + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[ssp_SCGetDynamicFormTables]')                                                 
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