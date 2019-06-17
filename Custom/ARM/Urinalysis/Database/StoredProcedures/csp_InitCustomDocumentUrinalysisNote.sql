/****** Object:  StoredProcedure [dbo].[csp_InitCustomDocumentUrinalysisNote]    Script Date: 07/19/2013 18:44:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDocumentUrinalysisNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomDocumentUrinalysisNote]
GO

/****** Object:  StoredProcedure [dbo].[csp_InitCustomDocumentUrinalysisNote]    Script Date: 07/19/2013 18:44:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author:  <Manju Padmanabhan>  
-- Create date: <18 July, 2013>  
-- Description: A Renewed Mind - Customizations Task #21 Urinalysis Service Note  
-- =============================================  
CREATE PROCEDURE [dbo].[csp_InitCustomDocumentUrinalysisNote]  
 @ClientID int,    
 @StaffID int,    
 @CustomParameters xml    
AS  
BEGIN  
 BEGIN TRY    
   
 Select TOP 1 PlaceHolder.TableName -- 'CustomDocumentUrinalysis' AS TableName    
 , -1 as 'DocumentVersionId',   
 '' as CreatedBy,    
 getdate() as CreatedDate,    
 '' as ModifiedBy,    
 getdate() as ModifiedDate    
 from (Select 'CustomDocumentUrinalysis' As TableName ) As PlaceHolder      
 --where DocumentVersionId = -1     
   
 END TRY    
    
 BEGIN CATCH    
     
 DECLARE @Error varchar(8000)    
 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())    
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_InitCustomDocumentUrinalysisNote')    
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


