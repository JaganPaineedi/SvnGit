/****** Object:  StoredProcedure [dbo].[csp_GetDynamicAssessmentForms]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetDynamicAssessmentForms]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetDynamicAssessmentForms]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetDynamicAssessmentForms]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_GetDynamicAssessmentForms]    
(                
 @FormIds VARCHAR(500)                
)     
/*********************************************************************/  
/* Procedure: csp_GetDynamicAssessmentForms            */  
/*                                                                   */  
/* Purpose: retrieve Dynamic form tables data for rendering the -   */  
/*    dynamic page according to Form Id.  -                          */  
/*                                                                   */  
/* Parameters: @FormIds VARCHAR(500)                                */  
/*                                                                   */  
/*                                                                   */  
/* Returns/Results: returns a result set containing the              */  
/*    Tables for redering the dynamic pages                          */  
/*                                                                   */  
/* Created By: Chandan Srivastava                                       */  
/*                                                                   */  
/* Created Date: 4/25/2009                                           */  
/*                                                                   */  
/* Revision History:                                                 */  
/*********************************************************************/             
AS   
               
BEGIN     
 BEGIN TRY             
  SELECT                  
  FormId,                
  FormName,                
  TableName,                
  --RowIdentifier,                
  CreatedBy,                
  CreatedDate,                
  ModifiedBy,                
  ModifiedDate,                
  RecordDeleted,                
  DeletedDate,                
  DeletedBy                
  FROM Forms WHERE FormId in (SELECT item FROM [dbo].fnSplit(@FormIds,'',''))                 
  AND ISNULL(RecordDeleted,''N'')<>''Y''                
           
           
           
  select                 
  FS.FormSectionId,                
  FS.FormId,                
  FS.SortOrder,                
  FS.SectionLabel,                
  FS.Active,                
  FS.SectionEnableCheckBox,                
  FS.SectionEnableCheckBoxText,                
  FS.SectionEnableCheckBoxColumnName,                
  --FS.RowIdentifier,                
  FS.CreatedBy,                
  FS.CreatedDate,                
  FS.ModifiedBy,                
  FS.ModifiedDate,                
  FS.RecordDeleted,                
  FS.DeletedDate,                
  FS.DeletedBy                
  From FormSections as FS                
  Inner join Forms on Forms.FormId = FS.FormId and Forms.FormId in (SELECT item FROM [dbo].fnSplit(@FormIds,'',''))                
  Where ISNULL(Forms.RecordDeleted,''N'')<>''Y'' AND ISNULL(FS.RecordDeleted,''N'')<>''Y'' AND FS.Active = ''Y''             
  Order by FS.Formid asc ,FS.SortOrder Asc                
           
           
           
  select                
  FSG.FormSectionGroupId,                
  FSG.FormSectionId,                
  FSG.SortOrder,                
  FSG.GroupLabel,                
  FSG.Active,                
  FSG.GroupEnableCheckBox,                
  FSG.GroupEnableCheckBoxText,                
  FSG.GroupEnableCheckBoxColumnName,                
  FSG.NumberOfItemsInRow,                
  --FSG.RowIdentifier,                
  FSG.CreatedBy,                
  FSG.CreatedDate,                
  FSG.ModifiedBy,                
  FSG.ModifiedDate,                
  FSG.RecordDeleted,                
  FSG.DeletedDate,                
  FSG.DeletedBy                
  From FormSectionGroups FSG                
  Inner join FormSections FS ON FS.FormSectionId = FSG.FormSectionId                 
  Inner Join Forms F ON F.FormId = FS.FormId AND F.FormId in (SELECT item FROM [dbo].fnSplit(@FormIds,'',''))                
  where ISNULL(F.RecordDeleted,''N'')<>''Y'' AND ISNULL(FS.RecordDeleted,''N'')<>''Y'' AND ISNULL(FSG.RecordDeleted,''N'')<>''Y''               
  AND FS.Active =''Y'' AND FSG.Active = ''Y''        
  
  select                 
  FI.FormItemId,                
  FI.FormSectionId,                
  FI.FormSectionGroupId,                
  FI.ItemType,                
  FI.ItemLabel,                
  FI.SortOrder,                
  FI.Active,                
  FI.GlobalCodeCategory,                
  FI.ItemColumnName,                
  FI.ItemRequiresComment,                
  FI.ItemCommentColumnName,     
  FI.MaximumLength,               
  --FI.RowIdentifier,                
  FI.CreatedBy,                
  FI.CreatedDate,                
  FI.ModifiedBy,                
  FI.ModifiedDate,                
  FI.RecordDeleted,                
  FI.DeletedDate,                
  FI.DeletedBy                
  From FormItems FI                
  Inner Join FormSectionGroups FSG On FSG.FormSectionGroupId = FI.FormSectionGroupId                 
  Inner join FormSections FS ON FS.FormSectionId = FSG.FormSectionId                 
  Inner Join Forms F ON F.FormId = FS.FormId AND F.FormId in (SELECT item FROM [dbo].fnSplit(@FormIds,'',''))                
  where ISNULL(F.RecordDeleted,''N'')<>''Y'' AND  ISNULL(FI.RecordDeleted,''N'')<>''Y''           
  AND ISNULL(FSG.RecordDeleted,''N'')<>''Y''  AND ISNULL(FS.RecordDeleted,''N'')<>''Y''          
  AND FI.Active = ''Y'' AND FSG.Active = ''Y'' AND FS.Active = ''Y''        
  ORDER BY FSG.SortOrder,FI.SortOrder          
  
 END TRY  
   
 BEGIN CATCH  
   DECLARE @Error varchar(8000)                         
   SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                       
   + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_GetDynamicAssessmentForms'')                                                       
   + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                        
   + ''*****'' + Convert(varchar,ERROR_STATE())                                                      
  RAISERROR                                                       
  (                                                      
   @Error, -- Message text.                                                      
   16, -- Severity.                                                      
   1 -- State.                                                      
  );                                                      
 END CATCH  
      
END
' 
END
GO
