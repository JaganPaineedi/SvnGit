/****** Object:  StoredProcedure [dbo].[csp_SCDeleteAuthorizationDocumentsListPageData]    Script Date: 06/19/2013 17:49:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteAuthorizationDocumentsListPageData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCDeleteAuthorizationDocumentsListPageData]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteAuthorizationDocumentsListPageData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_SCDeleteAuthorizationDocumentsListPageData]               
(                                                                                                           
 @SessionId varchar(100)                                                                                                                           
)                                                                                                                        
as                                                                                                                        
/*********************************************************************/                                                                                                                                
/* Stored Procedure: dbo.[csp_SCDeleteAuthorizationDocumentsListPageData]                */                                                                                                                                
/* Creation Date:    23 May,2011                                         */                                                                                                                               
/*                                                                   */                                                                                                                                
/* Purpose:  To delete from ListPageSCAuthorizationDocuments on basis of SessionId  */                                                                                                                                
/*                                                                   */                                                                                                                              
/* Input Parameters: none        @SessionId */                                                                                                                              
/*                                                                   */                                                                                                                                
/* Output Parameters:   None                           */                                                                                                                                
/*                                                                   */                                                                                                                                
/* Return:  0=success, otherwise an error number                     */                                                                                                                                
/*                                                                   */                                                                                                                                
/* Called By:   ssp_SCDeleteListPagesData                            */                                                                                                                                
/*                                                                   */                                                                                                                                
/* Calls:                                                            */                                                                                                                                
/*                                                                   */                                                                                                                                
/* Data Modifications:                                               */                                                                                                                                
/*                           */         
/* Updates:  */                             
/*   Date        Author        Purpose                  */                 
/*  23 May 2011  Pradeep      Created      */                                   
          
          
  BEGIN        
  Delete from ListPageSCAuthorizationDocuments where SessionId=@SessionId        
                                                                                                                              
  IF (@@error!=0)                                                                                                               
    BEGIN                                                        
        RAISERROR  20002 ''csp_SCDeleteAuthorizationDocumentsListPageData : An error  occured''                                                                                                                                
                                                                                                                                   
        RETURN(1)                                                                                   
                                                                                          
    END             
  END ' 
END
GO
