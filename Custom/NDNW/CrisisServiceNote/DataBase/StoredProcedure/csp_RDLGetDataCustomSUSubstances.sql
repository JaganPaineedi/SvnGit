
/****** Object:  StoredProcedure [dbo].[csp_RDLGetDataCustomSUSubstances]   ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLGetDataCustomSUSubstances]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLGetDataCustomSUSubstances]
GO


/****** Object:  StoredProcedure [dbo].[csp_RDLGetDataCustomSUSubstances]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

    
    
CREATE PROCEDURE [dbo].[csp_RDLGetDataCustomSUSubstances]      
(                                                                
  @DocumentVersionId int                                    
)                                                                
                                                                
AS                                                      
/***************************************************************************/                                                             
/* Stored Procedure: [csp_RDLGetDataCustomSUSubstances] */                                                                                                             
/* Copyright: 2006 Streamline SmartCare               */                                                                                                                      
/* Creation Date:  14-July-2009                 */                                                                                                                      
/* Purpose: Gets Data [csp_RDLGetDataCustomSUSubstances] */                                                                                                                     
/* Input Parameters: @DocumentVersionId           */                                                                                                                    
/* Output Parameters:                   */                                                                                                                      
/* Return:  0=success, otherwise an error number                           */                                                       
/* Purpose to show the RDL for Venture PreScreen Substance Use Tab        */                                                                                                            
/* Calls:                                                                  */                                                                            
/* Data Modifications:                                                     */                                                                            
/* Updates:                                                                */                                                                            
/* Date                 Author           Purpose        */                                                                            
/* 14-July-2009         Umesh   Created        */                 
         
/***************************************************************************/                                                                
                                                      
BEGIN                                                                               
                                     
 BEGIN TRY                                                      
                
      ----For CustomSUSubstances Table                
      SELECT [SUSubstanceId]                
      ,CustomSUSubstances.[DocumentVersionId]                
      ,[SubstanceName]                
      ,[Amount]                
      ,[Frequency]                
      ,CustomSUSubstances.[RecordDeleted]                
                     
      FROM CustomSUSubstances    
   join DocumentVersions  ON        
   CustomSUSubstances.DocumentVersionId = DocumentVersions.DocumentVersionId and isnull(DocumentVersions.RecordDeleted,'N')<>'Y'    
   and isnull(CustomSUSubstances.RecordDeleted,'N')<>'Y'              
   join Documents  on Documents.DocumentId = DocumentVersions.DocumentId      
   and isnull(Documents.RecordDeleted,'N')<>'Y'     
      where ISNull(CustomSUSubstances.RecordDeleted,'N')='N' AND CustomSUSubstances.DocumentVersionId=@DocumentVersionId                  
                                                       
 END TRY                                                      
 BEGIN CATCH                      
  DECLARE @Error varchar(8000)                               
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                      
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[csp_RDLGetDataCustomSUSubstances]')                                                                                                       
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


