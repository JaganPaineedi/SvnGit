/****** Object:  StoredProcedure [dbo].[csp_SCDeleteDocumentCustomMDNotes]    Script Date: 06/19/2013 17:49:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteDocumentCustomMDNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCDeleteDocumentCustomMDNotes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteDocumentCustomMDNotes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create PROCEDURE  [dbo].[csp_SCDeleteDocumentCustomMDNotes]
(          
 @DocumentVersionId as int,                                                                                                  
 @DeletedBy as varchar(100) 
 )          
As
/******************************************************************************  
**  Name: csp_SCDeleteDocumentCustomMDNotes  
**  Desc: This fetches data for Service Note Custom Tables 
**  
**  This template can be customized:  
**                
**  Return values:  
**   
**  Parameters:  
**  Input       Output  
**     ----------      -----------  
**  DocumentVersionId,DeletedBy    Result Set containing values from Service Note Custom Tables
**  
**  Auth: Mohit Maddan 
**  Date: 1-April-2010  
*******************************************************************************  
**  Change History  
*******************************************************************************  
**  Date:    Author:    Description:  
**  --------   --------   -------------------------------------------  

*******************************************************************************/  
Begin                                              
    
 Begin try                              
    update CustomMDNotes                                       
    set RecordDeleted=''Y'',                                            
    DeletedBy=@DeletedBy,                                            
    DeletedDate=getdate()                                            
      where DocumentVersionId=@DocumentVersionId                                                                                      
 end try                                              
                                                                                       
BEGIN CATCH                                                                           
    
DECLARE @Error varchar(8000)                                               
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                             
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_SCDeleteDocumentCustomMDNotes'')                                                                             
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
