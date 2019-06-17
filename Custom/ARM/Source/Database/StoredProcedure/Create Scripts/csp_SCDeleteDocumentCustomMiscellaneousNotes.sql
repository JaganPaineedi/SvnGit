/****** Object:  StoredProcedure [dbo].[csp_SCDeleteDocumentCustomMiscellaneousNotes]    Script Date: 06/19/2013 17:49:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteDocumentCustomMiscellaneousNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCDeleteDocumentCustomMiscellaneousNotes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteDocumentCustomMiscellaneousNotes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create PROCEDURE [dbo].[csp_SCDeleteDocumentCustomMiscellaneousNotes]                                                                                        
(                                                                                                  
 @DocumentVersionId as int,                                                                                                  
 @DeletedBy as varchar(100)                                                                                                
)                                                                                                  
AS                                                                                                  
/*********************************************************************/                                                                                                    
/* Stored Procedure: csp_SCDeleteDocumentCustomMiscellaneousNotes*/                                                                                                    
/* Creation Date:    22/02/2010                                      */                                                                                                    
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
/*  22/02/2010   Vikas Vyas           Use for CustomMiscellaneousNotes of Document       */                                                                 
/*********************************************************************/                                                                                                     
                                                          
Begin                                              
    
 Begin try                              
    update CustomMiscellaneousNotes                                       
    set RecordDeleted=''Y'',                                            
    DeletedBy=@DeletedBy,                                            
    DeletedDate=getdate()                                            
      where DocumentVersionId=@DocumentVersionId                                                                                      
 end try                                              
                                                                                       
BEGIN CATCH                                                                           
    
DECLARE @Error varchar(8000)                                               
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                             
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_SCDeleteDocumentCustomMiscellaneousNotes'')                                                                             
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
