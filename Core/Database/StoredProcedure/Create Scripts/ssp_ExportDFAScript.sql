IF EXISTS ( SELECT * 
            FROM   sysobjects 
            WHERE  id = object_id(N'[dbo].[ssp_ExportDFAScript]') 
                   and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
    DROP PROCEDURE [dbo].[ssp_ExportDFAScript]
END
Go

SET ANSI_NULLS ON
GO


CREATE PROCEDURE dbo.ssp_ExportDFAScript    
@FormId  INT,            
@Type CHAR(1),          
@ExportTable CHAR(1)          
AS      
/*********************************************************************/                  
/* Stored Procedure: dbo.ssp_ExportDFAScript  51262,'N','N'             */                  
/* Copyright:             */                  
/* Creation Date:  12-06-2017                                  */                  
/*                                                                   */                  
/* Purpose: Export dfa script          */                 
/*                                                                   */                
/* Input Parameters:       */                
/*                                                                   */                  
/* Output Parameters:                                */                  
/*                                                                   */                  
/* Return: */                  
/*                                                                   */                  
/* Called By:                                                        */                  
/*                                                                   */                  
/* Calls:                                                            */                  
/*                                                                   */                  
/* Data Modifications:                                               */                  
/*                                                                   */                  
/* Updates:                                                          */                  
/*  Date          Author      Purpose                                    */                  
/* 06/12/2017   Rajesh S      Created                                    */ 
/* 01/18/2018   Bibhu         Added RecordDeleted Check, GroupName, logic for NumberOfItemsInRow 
                              and Handling special characters with FOR XML PATH(”)(KCMHSAS - Support #960.59)   
/* 06/12/2017   Rajesh S      EII 627 Added new fields, FormJavascript,IsJavascriptOverride and FormGUID 
   12/11/2018   Prem Reddy    Added Isnull check for  FormJavascript Column as part of MFS Build Cycle Tasks #35
   22/11/2018   Prem Reddy    Added Isnull check for  IsJavascriptOverride Column as part of MFS Build Cycle Tasks #35
 */                                  */                  
/*********************************************************************/                   
BEGIN          
BEGIN TRY          
 DECLARE @SQLSCRIPT NVARCHAR(MAX)          
 SET @SQLSCRIPT = ''          
 DECLARE @TableName NVARCHAR(255)          
 DECLARE @NewLineChar AS CHAR(2) = CHAR(13) + CHAR(10)          
  SET  @SQLSCRIPT = 'BEGIN TRY '          
  SET  @SQLSCRIPT = @SQLSCRIPT + ' BEGIN TRANSACTION '          
  IF @ExportTable = 'Y'           
  BEGIN          
    SET @SQLSCRIPT = @SQLSCRIPT + (SELECT dbo.ssf_GetCreateTableScript(TableName) FROM  FORMS WHERE FormId = @FormId )          
  END   
  SET @SQLSCRIPT = @SQLSCRIPT + ' DECLARE @DFAJavaScript VARCHAR(MAX) SET  @DFAJavaScript = ' + '''' + (SELECT REPLACE(ISNULL(FormJavascript,''''),'''','''''') FROM Forms WHERE Formid = @FormId) +''''  
  IF @TYPE='N'  
     SET  @SQLSCRIPT = @SQLSCRIPT + ' DECLARE @FormIds table (FormId int)  DECLARE @FormId INT,@FormSectionId INT,@FormSectionGroupId INT DECLARE @NewFormSection TABLE ( NewFormSectionId int not null, OldFormSectionId int not null) DECLARE @NewFormSectionGroup TABLE ( NewFormSectionGroupId int not null, OldFormSectionGroupId int not null)'    
  IF @Type='I'          
   SET  @SQLSCRIPT = @SQLSCRIPT + 'SET IDENTITY_INSERT dbo.forms ON '          
            
             
            
  SET @SQLSCRIPT = @SQLSCRIPT + ' '+          
   (SELECT           
   CASE WHEN @Type='I' THEN 'IF NOT EXISTS (SELECT * FROM forms WHERE formid = ' ELSE '' END         
  + CASE WHEN @Type='I' THEN  CAST(formid AS VARCHAR(10)) + ') BEGIN ' ELSE '' END          
  + CASE WHEN @Type='I' THEN 'INSERT INTO forms(formid, formname, TableName, TotalNumberOfColumns, Active, RetrieveStoredProcedure,FormType,FormJavascript,IsJavascriptOverride,FormGUID,Core) values('  ELSE 'INSERT INTO forms(formname, TableName, TotalNumberOfColumns, Active, RetrieveStoredProcedure,FormType,FormJavascript,IsJavascriptOverride,Core) OUTPUT INSERTED.FormId INTO @FormIds values(' END       +  
   CASE WHEN @Type='I' THEN  CAST(formid AS VARCHAR(10))      ELSE '' END     
    + Case when formname is null then CASE WHEN @Type='I' THEN  ',' + ISNULL(CAST(formname AS VARCHAR(10)),'NULL') ELSE  ISNULL(CAST(formname AS VARCHAR(10)),'NULL') END            
    + CASE WHEN @Type='I' THEN  ',''' ELSE '''' END else CASE WHEN @Type='I' THEN  ','''+formname+''',''' ELSE ''''+formname+''',''' END  end           
    + TableName + ''',' +  ISNULL(cast(TotalNumberOfColumns AS varchar(10)),'NULL')           
    + ',''' +  Active           
    + ''',''' + ISNULL(RetrieveStoredProcedure,'') 
    + ''',''' +  CAST(FormType  AS VARCHAR(4))        
    + ''',@DFAJavaScript'  
    + ',''' +Isnull(IsJavascriptOverride,'N')      
    + ''''+  CASE WHEN @Type='I' THEN  ',''' +  CAST(FormGUID   AS NVARCHAR(MAX))  + ''','''+ISNULL(Core,'N')+''')'     ELSE ','''+ISNULL(Core,'N')+''')' END               
    
    + CASE WHEN @Type='I' THEN ' SET IDENTITY_INSERT dbo.forms OFF ' ELSE ' ' END            
    + CASE WHEN @Type='I' THEN ' END '  ELSE '' END         
   FROM FORMS WHERE FormId=@FormId FOR XML PATH(''))          
           
	IF @Type='I'          
	SET  @SQLSCRIPT = @SQLSCRIPT + ' SET IDENTITY_INSERT dbo.forms OFF '      
	     
	IF @Type='N'               
	SET  @SQLSCRIPT = @SQLSCRIPT + ' SET @FormId = (SELECT TOP 1 FormId FROM @FormIds) '  

	IF @Type='I'          
	SET  @SQLSCRIPT = @SQLSCRIPT + ' SET IDENTITY_INSERT dbo.FormSections ON '          
           
  SET @SQLSCRIPT = @SQLSCRIPT + ' '+          
   (SELECT           
	CASE WHEN @Type='I' THEN 'IF NOT EXISTS (SELECT * FROM FormSections WHERE FormSectionId = '  ELSE '' END        
  + CASE WHEN @Type='I' THEN CAST(FormSectionId AS VARCHAR(10)) + ') BEGIN ' ELSE '' END         
  + CASE WHEN @Type='I' THEN 'SET IDENTITY_INSERT dbo.FormSections ON ' ELSE ' ' END           
  + CASE WHEN @Type='I' THEN 'INSERT INTO dbo.FormSections(FormSectionId, formid, SortOrder, PlaceOnTopOfPage, SectionLabel, Active, SectionEnableCheckBox, SectionEnableCheckBoxText, SectionEnableCheckBoxColumnName, NumberOfColumns) values(' ELSE 'INSERT INTO dbo.FormSections(formid, SortOrder, PlaceOnTopOfPage, SectionLabel, Active, SectionEnableCheckBox, SectionEnableCheckBoxText, SectionEnableCheckBoxColumnName, NumberOfColumns) OUTPUT INSERTED.FormSectionId,'''+CAST(FormSectionId AS VARCHAR(10))+''' INTO @NewFormSection values(' END +           
   CASE WHEN @Type='I' THEN CAST(FormSectionId AS VARCHAR(10)) ELSE '' END          
  + CASE WHEN @Type='I' THEN ',' +  CAST(F.formid AS VARCHAR(10))    ELSE ' @FormId ' END       
  + ',' + CAST(SortOrder AS VARCHAR(10)) + '' +          
  + CASE WHEN PlaceOnTopOfPage is null then  ',' + 'NULL' + ''          
  ELSE ','''+ REPLACE(PlaceOnTopOfPage,'''','''''')+ '''' end           
           
  + CASE WHEN SectionLabel is null then  ',' + 'NULL'  + ''          
  ELSE ','''+ REPLACE(SectionLabel,'''','''''')+ '''' end           
  + ',''' + FS.Active + ''''          
           
  + CASE WHEN SectionEnableCheckBox is null then  ',' + 'NULL'  + ''          
  ELSE ','''+ REPLACE(SectionEnableCheckBox,'''','''''')+ '''' end           
           
  + CASE WHEN SectionEnableCheckBoxText is null then  ',' + 'NULL'  + ''          
  ELSE ','''+ REPLACE(SectionEnableCheckBoxText,'''','''''')+ '''' end           
           
  + CASE WHEN SectionEnableCheckBoxColumnName is null then  ',' + 'NULL'  + ''          
  ELSE ','''+ REPLACE(SectionEnableCheckBoxColumnName,'''','''''')+ '''' end           
           
  + ',' +  ISNULL(cast(NumberOfColumns AS varchar(10)),'NULL')          
  + ')'          
  + CASE WHEN @Type='I' THEN ' SET IDENTITY_INSERT dbo.FormSections OFF ' ELSE ' ' END          
  +CASE WHEN @Type='I' THEN ' END ' ELSE '' END         
   FROM dbo.FormSections FS          
   JOIN FORMS F ON FS.Formid = F.FormId           
   WHERE FS.FormId=@FormId  
   AND ISNULL(FS.RecordDeleted,'N')='N'   
   AND ISNULL(F.RecordDeleted,'N')='N'         
   FOR XML PATH(''), TYPE).value('.', 'nvarchar(MAX)')  ----- 01/18/2018   Bibhu          
             
   IF @Type='I'          
    SET  @SQLSCRIPT = @SQLSCRIPT + ' SET IDENTITY_INSERT dbo.FormSections OFF '          
              
   IF @Type='I'          
    SET  @SQLSCRIPT = @SQLSCRIPT + ' SET IDENTITY_INSERT dbo.FormSectionGroups ON  '          
             
   SET @SQLSCRIPT = @SQLSCRIPT + ' '+          
   (SELECT           
	CASE WHEN @Type='I' THEN 'IF NOT EXISTS (SELECT * FROM FormSectionGroups WHERE FormSectionGroupId = '  ELSE '' END        
  + CASE WHEN @Type='I' THEN  CAST(FormSectionGroupId AS VARCHAR(10)) + ') BEGIN '  ELSE '' END        
  +  CASE WHEN @Type='I' THEN 'SET IDENTITY_INSERT dbo.FormSectionGroups ON '  ELSE ' ' END          
  +  CASE WHEN @Type='I' THEN 'INSERT INTO dbo.FormSectionGroups (FormSectionGroupId, formsectionid, SortOrder, GroupLabel, Active, GroupEnableCheckBox, GroupEnableCheckBoxText, GroupEnableCheckBoxColumnName,  NumberOfItemsInRow,GroupName) VALUES(' ELSE  'INSERT INTO dbo.FormSectionGroups (formsectionid, SortOrder, GroupLabel, Active, GroupEnableCheckBox, GroupEnableCheckBoxText, GroupEnableCheckBoxColumnName,  NumberOfItemsInRow,GroupName) OUTPUT INSERTED.FormSectionGroupId,'''+ CAST(FormSectionGroupId AS VARCHAR(10))+''' INTO @NewFormSectionGroup VALUES(' END +          
	CASE WHEN @Type='I' THEN  CAST(FormSectionGroupId AS VARCHAR(10)) + ','  ELSE '' END                         ----- 01/18/2018   Bibhu 
  + CASE WHEN @Type='I' THEN CAST(FS.formsectionid AS VARCHAR(10)) ELSE '(SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = '+CAST(FS.formsectionid AS VARCHAR(10))+')' END + ','           
  + CAST(FSG.SortOrder AS VARCHAR(10)) + ''          
  + CASE WHEN GroupLabel is null then  ',' +'NULL'  + ''          
  ELSE ','''+ REPLACE(GroupLabel,'''','''''')+ '''' end           
  + ',''' + FSG.Active + ''''          
  + CASE WHEN GroupEnableCheckBox is null THEN  ',' + 'NULL'  + ''          
  ELSE ','''+ REPLACE(GroupEnableCheckBox,'''','''''')+ '''' END           
  + CASE WHEN GroupEnableCheckBoxText is null THEN  ',' + 'NULL'  + ''          
  ELSE ','''+ REPLACE(GroupEnableCheckBoxText,'''','''''')+ '''' END           
  + CASE WHEN GroupEnableCheckBoxColumnName is null THEN  ',' + 'NULL'  + ''          
  ELSE ','''+ REPLACE(GroupEnableCheckBoxColumnName,'''','''''')+ '''' END  
  + CASE WHEN NumberOfItemsInRow is null THEN  ',' + 'NULL'  + ''          
  ELSE ','''+ REPLACE(NumberOfItemsInRow,'''','''''')+ '''' END          
  + CASE WHEN GroupName is null THEN  ',' + 'NULL'  + ''          
  ELSE ','''+ REPLACE(GroupName,'''','''''')+ '''' END            
  + ')'          
  + CASE WHEN @Type='I' THEN ' SET IDENTITY_INSERT dbo.FormSectionGroups OFF ' ELSE ' ' END          
  + CASE WHEN @Type='I' THEN ' END ' ELSE '' END          
   FROM dbo.FormSectionGroups FSG          
   JOIN dbo.FormSections FS ON FSG.FormSectionId = FS.FormSectionId          
   JOIN FORMS F ON FS.Formid = F.FormId           
   WHERE FS.FormId=@FormId  
   AND ISNULL(FSG.RecordDeleted,'N')='N'  
   AND ISNULL(FS.RecordDeleted,'N')='N'   
   AND ISNULL(F.RecordDeleted,'N')='N'      
   FOR XML PATH(''), TYPE).value('.', 'nvarchar(MAX)')           
            
             
   IF @Type='I'          
    SET  @SQLSCRIPT = @SQLSCRIPT + ' SET IDENTITY_INSERT dbo.FormSectionGroups OFF  '          
              
   IF @Type='I'          
    SET  @SQLSCRIPT = @SQLSCRIPT + ' SET IDENTITY_INSERT dbo.Formitems ON  '          
             
   SET @SQLSCRIPT = @SQLSCRIPT + ' '+          
   (SELECT          
 CASE WHEN @Type='I' THEN  'IF NOT EXISTS (SELECT * FROM Formitems WHERE FormItemId = '  ELSE '' END        
  +CASE WHEN @Type='I' THEN  CAST(FormItemId AS VARCHAR(10)) + ') BEGIN '  ELSE '' END        
  + CASE WHEN @Type='I' THEN 'SET IDENTITY_INSERT dbo.Formitems ON ' ELSE ' ' END          
  + CASE WHEN @Type='I' THEN 'INSERT INTO Formitems (FormItemId,formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) VALUES(' ELSE 'INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) VALUES(' END +          
  CASE WHEN @Type='I' THEN CAST(FormItemId AS VARCHAR(10))  ELSE '' END         
  +CASE WHEN @Type='I' THEN  ',' + CAST(FI.formsectionid AS VARCHAR(10))   ELSE '(SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = '+CAST(FI.formsectionid AS VARCHAR(10))+')'  END       
  + ',' + CASE WHEN @Type='I' THEN CAST(FormSectionGroupId AS VARCHAR(10))+'' ELSE '(SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId='+CAST(FormSectionGroupId AS VARCHAR(10))+')'   END         
  + CASE WHEN ItemType is null then  ',' + 'NULL' + ''          
  ELSE ','''+ REPLACE(ItemType,'''','''''')+ '''' end           
  + CASE WHEN ItemLabel is null then  ',' + 'NULL' + ''          
  ELSE ','''+ REPLACE(ItemLabel,'''','''''')+ '''' end           
  + ',' +  cast(FI.SortOrder AS varchar(10)) +''          
  + ',''' + FI.Active + ''''          
  + CASE WHEN GlobalCodeCategory is null then  ',' + 'NULL'  + ''          
  ELSE ','''+ REPLACE(GlobalCodeCategory,'''','''''')+ '''' end           
  + CASE WHEN ItemColumnName is null then  ',' + 'NULL' + ''          
  ELSE ','''+ REPLACE(ItemColumnName,'''','''''')+ '''' end           
  + CASE WHEN ItemRequiresComment is null then  ',' + 'NULL'  + ''          
  ELSE ','''+ REPLACE(ItemRequiresComment,'''','''''')+ '''' end           
  + CASE WHEN ItemCommentColumnName is null then  ',' + 'NULL'  + ''          
  ELSE ','''+ REPLACE(ItemCommentColumnName,'''','''''')+ '''' end           
  + ',' +  ISNULL(cast(ItemWidth AS varchar(10)),'NULL')+''          
  + ',' + ISNULL(cast(MaximumLength AS VARCHAR(10)),'NULL')+''          
  + CASE WHEN DropdownType is null then  ',' + 'NULL'  + ''          
  ELSE ','''+ REPLACE(DropdownType,'''','''''')+ '''' end           
  + CASE WHEN SharedTableName is null then  ',' + 'NULL'  + ''          
  ELSE ','''+ REPLACE(SharedTableName,'''','''''')+ '''' end           
  + CASE WHEN StoredProcedureName is null then  ',' + 'NULL'  + ''          
  ELSE ','''+ REPLACE(StoredProcedureName,'''','''''')+ '''' end           
  + CASE WHEN ValueField is null then  ',' + 'NULL'  + ''          
  ELSE ','''+ REPLACE(ValueField,'''','''''')+ '''' end           
  + CASE WHEN TextField is null then  ',' + 'NULL' + ''          
  ELSE ','''+ REPLACE(TextField,'''','''''')+ '''' end           
  + ',' + ISNULL(cast(MultilineEditFieldHeight AS VARCHAR(10)),'NULL')+''          
  + CASE WHEN EachRadioButtonOnNewLine is null then  ',' + 'NULL'  + ''          
  ELSE ','''+ REPLACE(EachRadioButtonOnNewLine,'''','''''')+ '''' end           
  +')'          
  + CASE WHEN @Type='I' THEN ' SET IDENTITY_INSERT dbo.Formitems OFF  ' ELSE ' ' END          
  + CASE WHEN @Type='I' THEN  ' END ' ELSE '' END          
   FROM dbo.FormItems  FI          
   JOIN dbo.FormSections FS ON FI.FormSectionId = FS.FormSectionId          
   JOIN FORMS F ON FS.Formid = F.FormId          
   WHERE FS.FormId=@FormId 
   AND ISNULL(FI.RecordDeleted,'N')='N'  
   AND ISNULL(FS.RecordDeleted,'N')='N'   
   AND ISNULL(F.RecordDeleted,'N')='N'          
   FOR XML PATH(''), TYPE).value('.', 'nvarchar(MAX)')           
             
   IF @Type='I'          
    SET  @SQLSCRIPT = @SQLSCRIPT + ' SET IDENTITY_INSERT dbo.Formitems OFF  '          
           
  SET  @SQLSCRIPT = @SQLSCRIPT + ' COMMIT TRANSACTION; '          
  SET  @SQLSCRIPT = @SQLSCRIPT + ' END TRY '          
  SET  @SQLSCRIPT = @SQLSCRIPT + ' BEGIN CATCH '          
  SET  @SQLSCRIPT = @SQLSCRIPT + ' IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION; '          
  SET  @SQLSCRIPT = @SQLSCRIPT + ' DECLARE @ErrorMessage NVARCHAR(MAX) '      
  SET  @SQLSCRIPT = @SQLSCRIPT + ' DECLARE @ErrorSeverity INT '      
  SET  @SQLSCRIPT = @SQLSCRIPT + ' DECLARE @ErrorState INT '      
  SET  @SQLSCRIPT = @SQLSCRIPT + ' SET @ErrorMessage =  ERROR_MESSAGE() '      
  SET  @SQLSCRIPT = @SQLSCRIPT + ' SET @ErrorSeverity =  ERROR_SEVERITY() '      
  SET  @SQLSCRIPT = @SQLSCRIPT + ' SET @ErrorState =  ERROR_STATE() '      
  SET  @SQLSCRIPT = @SQLSCRIPT + ' RAISERROR  (@ErrorMessage,@ErrorSeverity,@ErrorState); '           
  SET  @SQLSCRIPT = @SQLSCRIPT + ' END CATCH '          
 SELECT @SQLSCRIPT          
END TRY    
BEGIN CATCH    
 DECLARE @ErrorMessage NVARCHAR(MAX)    
 DECLARE @ErrorSeverity INT    
 DECLARE @ErrorState INT    SET @ErrorMessage =  ERROR_MESSAGE()    
 SET @ErrorSeverity =  ERROR_SEVERITY()    
 SET @ErrorState =  ERROR_STATE()    
 RAISERROR  (@ErrorMessage,@ErrorSeverity,@ErrorState);    
END CATCH    
END