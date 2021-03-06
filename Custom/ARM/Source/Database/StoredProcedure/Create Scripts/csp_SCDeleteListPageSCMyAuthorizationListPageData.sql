/****** Object:  StoredProcedure [dbo].[csp_SCDeleteListPageSCMyAuthorizationListPageData]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteListPageSCMyAuthorizationListPageData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCDeleteListPageSCMyAuthorizationListPageData]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteListPageSCMyAuthorizationListPageData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE procedure [dbo].[csp_SCDeleteListPageSCMyAuthorizationListPageData]           
(                                                                                                       
 @SessionId varchar(100)                                                                                                                       
)                                                                                                                    
as                                                                                                                    
/*********************************************************************/                                                                                                                            
/* Stored Procedure: dbo.[csp_SCDeleteListPageSCMyAuthorizationListPageData]                */                                                                                                                            
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                                                                                                                            
/* Creation Date:    24/March/2011                                       */                                                                                                                           
/*                                                                   */                                                                                                                            
/* Purpose:  To delete from ListPageSCMyAuthorizations on basis of SessionId  */                                                                                                                            
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
/*  24/March/2011   Rakesh       Created      */                               
      
      
  BEGIN    
  Delete from ListPageSCMyAuthorizations where SessionId=@SessionId    
                                                                                                                          
  IF (@@error!=0)                                                                                                           
    BEGIN                                                    
        RAISERROR  20002 ''csp_SCDeleteListPageSCMyAuthorizationListPageData : An error  occured''                                                                                                                            
                                                                                                                               
        RETURN(1)                                                                               
                                                                                      
    END         
  END ' 
END
GO
