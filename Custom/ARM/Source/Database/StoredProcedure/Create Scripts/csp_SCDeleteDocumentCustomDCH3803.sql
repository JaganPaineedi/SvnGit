/****** Object:  StoredProcedure [dbo].[csp_SCDeleteDocumentCustomDCH3803]    Script Date: 06/19/2013 17:49:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteDocumentCustomDCH3803]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCDeleteDocumentCustomDCH3803]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteDocumentCustomDCH3803]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_SCDeleteDocumentCustomDCH3803]
(                                                                                                
 @DocumentVersionId as int,                                                                                                
 @DeletedBy as varchar(100)                                                                                              
)                                                                                                
AS                                                                                                
/*********************************************************************/                                                                                                  
/* Stored Procedure: dbo.csp_SCDeleteDocumentCustomDCH3803*/                                                                                                  
/* Creation Date:    17/09/2009                                      */                                                                                                  
/*                                                                   */                                                                                                  
/* Purpose:   This procedure is used to Delete the documents   
     for the passed DocumentVersionId and DeletedBy    */                                                                                                
/*                                                                   */                                                                                                
/* Input Parameters: @DocumentVersionId,@DeletedBy                     */                                                                                                
/*                                                                   */                                                                                                  
/* Output Parameters:        */                                                                                                  
/*                                                                   */                                                                                                  
/* Return:  0=success, otherwise an error number                     */                                                                                                  
/*                                                                   */                                                                                                  
/* Called By:                                                        */                                                                                                  
/*                                                                   */                                                                                                  
/* Calls:                                                            */                                                                                                  
/*                                                                   */                                                                                                  
/* Data Modifications:                                               */                                                                                                  
/*                                                                   */                                                                                                  
/* Updates:                                                          */     
/*  Date         Author               Purpose                             */                                                           
/*  17/09/2009   Ankesh Bharti     Creation (for Custom Web Documents)     */                                                               
/*********************************************************************/                                                                                                   
                                                        
Begin                                            
  
 Begin try                            
    update CustomDCH3803                                     
    set RecordDeleted=''Y'',                                          
    DeletedBy=@DeletedBy,                                          
    DeletedDate=getdate()                                          
      where DocumentVersionId=@DocumentVersionId                                                                                    
 end try                                            
                                                                                     
BEGIN CATCH                                                                         
  
DECLARE @Error varchar(8000)                                             
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                           
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_SCDeleteDocumentCustomDCH3803'')                                                                           
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
