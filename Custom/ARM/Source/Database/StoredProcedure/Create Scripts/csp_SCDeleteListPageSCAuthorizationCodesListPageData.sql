/****** Object:  StoredProcedure [dbo].[csp_SCDeleteListPageSCAuthorizationCodesListPageData]    Script Date: 06/19/2013 17:49:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteListPageSCAuthorizationCodesListPageData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCDeleteListPageSCAuthorizationCodesListPageData]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteListPageSCAuthorizationCodesListPageData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create procedure [dbo].[csp_SCDeleteListPageSCAuthorizationCodesListPageData]           
(                                                                                                       
 @SessionId varchar(100)                                                                                                                       
)                                                                                                                    
as                                                                                                                    
/*********************************************************************/                                                                                                                            
/* Stored Procedure: dbo.[csp_SCDeleteListPageSCAuthorizationCodesListPageData]                */                                                                                                                            
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                                                                                                                            
/* Creation Date:    22/jan/2010                                         */                                                                                                                           
/*                                                                   */                                                                                                                            
/* Purpose:  To delete from ListPageSCAuthorizationCodes on basis of SessionId  */                                                                                                                            
/*                                                                   */                                                                                                                          
/* Input Parameters: none        @SessionId */                                                                                                                          
/*                                                                   */                                                                                                                            
/* Output Parameters:   None                           */                                                                                                                            
/*                                                                   */                                                                                                                            
/* Return:  0=success, otherwise an error number                     */                                                                                                                            
/*                                                                   */                                                                                                                            
/* Called By:                                                        */                                                                                                                            
/*                                                                   */                                                                                                                            
/* Calls:                                                            */                                                                                                                            
/*                                                                   */                                                                                                                            
/* Data Modifications:                                               */                                       
/*                           */           
/* Updates:  */                         
/*   Date          Author     Purpose                  */                            
/*  22/jan/2010   Ankesh       Created      */                               
      
      
  BEGIN    
  Delete from ListPageSCAuthorizationCodes where SessionId=@SessionId    
                                                                                                                          
  IF (@@error!=0)                                                                                                           
    BEGIN                                                    
        RAISERROR  20002 ''csp_SCDeleteListPageSCAuthorizationCodesListPageData : An error  occured''                                                                                                                            
                                                                                                                               
        RETURN(1)                                                                               
                                                                                      
    END         
  END
' 
END
GO
