/****** Object:  StoredProcedure [dbo].[csp_SCDeleteDocumentTPNeeds]    Script Date: 06/19/2013 17:49:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteDocumentTPNeeds]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCDeleteDocumentTPNeeds]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteDocumentTPNeeds]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create PROCEDURE [dbo].[csp_SCDeleteDocumentTPNeeds]  
(                                                                                                  
 @DocumentVersionId as int,                                                                                                  
 @DeletedBy as varchar(100)                                                                                                
)                                                                                                  
AS                                                                                                  
/*********************************************************************/                                                                                                    
/* Stored Procedure: dbo.[csp_SCDeleteDocumentTPNeeds]*/                                                                                                    
/* Creation Date:    07/12/2009                                      */                                                                                                    
/*                                                                   */                                                                                                    
/* Purpose:   This procedure is used to Delete the Treatment Plan   
Addendum HRM documents for the passed DocumentVersionId and DeletedBy */                                                                                                  
/*                                                                   */                                                                                                  
/* Input Parameters: @DocumentVersionId,@DeletedBy                   */                                                                                                  
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
/*  07/12/2009   Ankesh Bharti     Creation (for Treatment Plan Addendum HRM Documents)     */                                               
/*********************************************************************/                                                                                                     
                                                          
Begin                                              
    
 Begin try                              
    update TPNeeds                                       
    set RecordDeleted=''Y'',                                            
    DeletedBy=@DeletedBy,                                            
    DeletedDate=getdate()                                            
      where DocumentVersionId=@DocumentVersionId                                                                                      
 end try                                              
                                                                                       
BEGIN CATCH                                                                           
    
DECLARE @Error varchar(8000)                                               
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                             
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_SCDeleteTPNeeds'')                                                                             
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
