/****** Object:  StoredProcedure [dbo].[csp_SCDeleteDocumentCustomAcuteServicesPrescreens]    Script Date: 06/19/2013 17:49:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteDocumentCustomAcuteServicesPrescreens]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCDeleteDocumentCustomAcuteServicesPrescreens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteDocumentCustomAcuteServicesPrescreens]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create PROCEDURE [dbo].[csp_SCDeleteDocumentCustomAcuteServicesPrescreens]                                                                                      
(                                                                                                
 @DocumentVersionId as int,                                                                                                
 @DeletedBy as varchar(100)                                                                                              
)                                                                                                
AS                                                                                                
/*********************************************************************/                                                                                                  
/* Stored Procedure: dbo.[csp_SCDeleteDocumentCustomAcuteServicesPrescreens]*/                                                                                                  
/* Copyright: 2006 Streamline Healthcare Solutions,  LLC             */                                                                                                  
/* Creation Date:    16/07/2009                                      */                                                                                                  
/*                                                                   */                                                                                                  
/* Purpose:   This procedure is used to Delete the documents   
			  for the passed DocumentVersionId						 */                                                                                                
/*                                                                   */                                                                                                
/* Input Parameters: @DocumentVersionId			                     */                                                                                                
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
/*  16/07/2009   Loveena     Creation (for delete Custom Web Documents)     */                                                               
/*********************************************************************/                                                                                                   
                                                        
Begin                                            
  
 Begin try                            
    update CustomAcuteServicesPrescreens                                     
    set RecordDeleted=''Y'',                                          
    DeletedBy=@DeletedBy,                                          
    DeletedDate=getdate()                                          
      where DocumentVersionId=@DocumentVersionId                                                                                    
 end try                                            
                                                                                     
BEGIN CATCH                                                                         
  
DECLARE @Error varchar(8000)                                             
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                           
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''[csp_SCDeleteDocumentCustomAcuteServicesPrescreens]'')                                                                           
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
