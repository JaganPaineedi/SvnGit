/****** Object:  StoredProcedure [dbo].[csp_SCDeleteDocumentTPInterventionProcedures]    Script Date: 06/19/2013 17:49:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteDocumentTPInterventionProcedures]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCDeleteDocumentTPInterventionProcedures]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteDocumentTPInterventionProcedures]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_SCDeleteDocumentTPInterventionProcedures]    
(                                                                                                    
 @DocumentVersionId as int,                                                                                                    
 @DeletedBy as varchar(100)                                                                                                  
)                                                                                                    
AS                                                                                                    
/*********************************************************************/                                                                                                      
/* Stored Procedure: dbo.csp_SCDeleteDocumentTPInterventionProcedures*/                                                                                                      
/* Creation Date:     12/12/2009                                      */                                                                                                      
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
/*  12/12/2009   Vikas Vyas     Creation (for Treatment Plan Addendum HRM Documents)     */                                                                   
/*********************************************************************/                                                                                                       
                                                            
Begin                                                
      
 Begin try       
  Declare @NeedId as int    
    
  update TPInterventionProcedures set RecordDeleted=''Y'',DeletedBy=@DeletedBy, DeletedDate=getDate()                
  where NeedId                             
  in                             
  (                            
  select NeedId from TPNeeds where DocumentVersionId=@DocumentVersionId  and Isnull(RecordDeleted,''N'')<>''Y''
  )    
 end try                                                
                                                                                         
BEGIN CATCH                                                                             
      
DECLARE @Error varchar(8000)                                                 
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                               
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_SCDeleteTPInterventionProcedures'')                                                                               
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
