IF EXISTS ( SELECT * 
            FROM   sysobjects 
            WHERE  id = object_id(N'[dbo].[ssp_GetReportDataForMultitabDFADocument]') 
                   and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
    DROP PROCEDURE [dbo].[ssp_GetReportDataForMultitabDFADocument] 
END
Go   
/*********************************************************************/                  
/* Stored Procedure: dbo.ssp_GetReportDataFormMultitabDFADocument    --1629         */                  
/* Copyright:             */                  
/* Creation Date:  12-06-2017                                  */                  
/*                                                                   */                  
/* Purpose:Get the Form html field from forms table         */                 
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
/* 07/12/2017   Rajesh S      Created  - To Get the FormHtml for dfa multitab                                  */                  
/*********************************************************************/          
CREATE PROCEDURE [dbo].[ssp_GetReportDataForMultitabDFADocument] -- 10600      
@DocumentVersionId int        
AS        
BEGIN        
 DECLARE @FormIdsWithFormOrder  TABLE        
 (         
  FormId int ,         
  FormOrder int        
 )        
        
 DECLARE @FormIdsWithOutFormOrder  TABLE        
 (         
  FormId int ,         
  FormOrder int        
 )        
        
 INSERT INTO @FormIdsWithFormOrder        
 SELECT         
 ff.FormId, ff.FormOrder        
 FROM        
 Documents D        
 JOIN DocumentCodes DS ON D.DocumentCodeId = DS.DocumentCodeId        
 JOIN FormCollectionForms FF ON DS.FormCollectionId = FF.FormCollectionId        
-- where ds.DocumentCodeId=@DocumentCodeId        
 WHERE D.InProgressDocumentVersionId =  @DocumentVersionId        
 AND FF.Active='Y'        
 AND ISNULL(FF.RecordDeleted,'N') = 'N'        
 AND ISNULL(DS.RecordDeleted,'N') = 'N'        
 AND ISNULL(DS.RecordDeleted,'N') = 'N'        
 AND ISNULL(D.RecordDeleted,'N') = 'N'        
 AND FF.FormOrder IS NOT NULL        
        
 --SELECT * FROM @FormIdsWithFormOrder        
        
        
 INSERT INTO @FormIdsWithOutFormOrder        
 SELECT         
 ff.FormId, ff.FormOrder        
 FROM        
 Documents D        
 JOIN DocumentCodes DS ON D.DocumentCodeId = DS.DocumentCodeId        
 JOIN FormCollectionForms FF ON DS.FormCollectionId = FF.FormCollectionId        
 --where ds.DocumentCodeId=10600        
 WHERE D.InProgressDocumentVersionId = @DocumentVersionId        
 AND FF.Active='Y'        
 AND ISNULL(FF.RecordDeleted,'N') = 'N'        
 AND ISNULL(DS.RecordDeleted,'N') = 'N'        
 AND ISNULL(DS.RecordDeleted,'N') = 'N'        
 AND ISNULL(D.RecordDeleted,'N') = 'N'        
 AND FF.FormOrder IS NULL        
        
        
-- SELECT * FROM @FormIdsWithOutFormOrder        
        
        
 DECLARE @FormHTML TABLE        
 (        
  FormId INT        
  ,FormHTML NVARCHAR(MAX)        
  ,TableName VARCHAR(200)        
  ,FormOrder INT IDENTITY(1,1)        
 )        
        
        
 INSERT INTO @FormHTML        
 SELECT         
  FF.FormId,F.FormHTML,F.TableName        
 FROM         
 Forms F         
 JOIN @FormIdsWithFormOrder FF         
 ON F.FormId = FF.FormId         
 ORDER BY FF.FormOrder         
        
        
 INSERT INTO @FormHTML        
        
 SELECT         
 FF.FormId,F.FormHTML,F.TableName        
 FROM         
 Forms F         
 JOIN @FormIdsWithOutFormOrder FF         
 ON F.FormId = FF.FormId         
 ORDER BY F.FormName        
        
 SELECT * FROM @FormHTML        
        
 DECLARE @SelectTables NVARCHAR(MAX)         
 SET @SelectTables = (        
         
 SELECT STUFF((        
 SELECT ' SELECT * FROM '+tablename+'  WHERE DOCUMENTVERSIONID='+CAST(@DocumentVersionId AS VARCHAR(100))       
  FROM @FormHTML FOR XML PATH(''),TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, ''))       
    
   EXECUTE sp_executesql @SelectTables   
        
END
