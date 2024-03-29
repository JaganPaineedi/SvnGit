/****** Object:  StoredProcedure [dbo].[csp_SCDeleteListPageSCDisclosureServices]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteListPageSCDisclosureServices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCDeleteListPageSCDisclosureServices]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteListPageSCDisclosureServices]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create procedure [dbo].[csp_SCDeleteListPageSCDisclosureServices]             
(                                                                                                         
 @SessionId varchar(100)                                                                                                                         
)                                                                                                                      
as                                                                                                                      
/*********************************************************************/                                                                                                                              
/* Stored Procedure: dbo.[csp_SCDeleteClientDocumentListPageData]                */                                                                                                                              
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                                                                                                                              
/* Creation Date:    21/jan/2010                                         */                                                                                                                             
/*                                                                   */                                                                                                                              
/* Purpose:  To delete from ListPageSCDisclosureServices on basis of SessionId  */                                                                                                                              
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
/*   Date     Author   Purpose                  */                              
/*  21/jan/2010        Created      */                                 
        
        
  BEGIN      
  Delete from ListPageSCDisclosureServices where SessionId=@SessionId      
                                                                                                                            
  IF (@@error!=0)                                                                                                             
    BEGIN                                                      
        RAISERROR  20002 ''csp_SCDeleteListPageSCDisclosureServices : An error  occured''                                                                                                                              
                                                                                                                                 
        RETURN(1)                                                                                 
                                                                                        
    END           
  END
' 
END
GO
