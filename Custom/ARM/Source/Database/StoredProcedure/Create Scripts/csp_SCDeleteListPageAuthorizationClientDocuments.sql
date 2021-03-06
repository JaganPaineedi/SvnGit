/****** Object:  StoredProcedure [dbo].[csp_SCDeleteListPageAuthorizationClientDocuments]    Script Date: 06/19/2013 17:49:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteListPageAuthorizationClientDocuments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCDeleteListPageAuthorizationClientDocuments]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteListPageAuthorizationClientDocuments]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'  
Create procedure [dbo].[csp_SCDeleteListPageAuthorizationClientDocuments]               
(                                                                                                           
 @SessionId varchar(100)                                                                                                                           
)                                                                                                                        
as                                                                                                                        
 /********************************************************************************************/                                                    
/* Stored Procedure: csp_SCDeleteListPageAuthorizationClientDocuments      */                                           
/* Copyright: 2009 Streamline Healthcare Solutions           */                                                    
/* Creation Date:  15 Nov 2010                */                                                    
/* Purpose: used by A Authorization Document List page          */  
/* Input Parameters: @SessionId                */                                                  
/* Output Parameters:                  */                                                    
/* Return:                     */                                                    
/* Called By:                    */                                                    
/* Calls:                     */                                                    
/* Data Modifications:                  */                                                    
/*       Date              Author                   Purpose         */                                                    
/*      
      20 April 2011        Rakesh     Modified        */     
/********************************************************************************************/                        
          
          
  BEGIN   
  begin try       
  Delete from ListPageSCAuthorizationClientDocuments where SessionId=@SessionId        
                                                                                                                              
  end try                              
BEGIN CATCH                                
                              
DECLARE @Error varchar(8000)                                                                             
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                           
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_SCDeleteListPageAuthorizationClientDocuments'')                                                                                                           
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                                                            
    + ''*****'' + Convert(varchar,ERROR_STATE())                                                         
 RAISERROR                                                                                                           
 (           
  @Error, -- Message text.                                                                                                          
  16, -- Severity.                                                                                                          
  1 -- State.                                                                                                          
 );                                                                                                        
END CATCH                  
  END ' 
END
GO
