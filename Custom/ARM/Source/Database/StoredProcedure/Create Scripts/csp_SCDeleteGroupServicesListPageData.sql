/****** Object:  StoredProcedure [dbo].[csp_SCDeleteGroupServicesListPageData]    Script Date: 06/19/2013 17:49:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteGroupServicesListPageData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCDeleteGroupServicesListPageData]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteGroupServicesListPageData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create procedure [dbo].[csp_SCDeleteGroupServicesListPageData]         
(                                                                                                     
 @SessionId varchar(100)                                                                                                                     
)                                                                                                                  
as                                                                                                                  
/*********************************************************************/                                                                                                                          
/* Stored Procedure: dbo.[csp_SCDeleteGroupServicesListPageData]                */                                                                                                                          
/* Creation Date:    20May,2011                                         */                                                                                                                         
/*                                                                   */                                                                                                                          
/* Purpose:  To delete from ListPagePMGroupServices on basis of SessionId  */                                                                                                                          
/*                                                                   */                                                                                                                        
/* Input Parameters:	none        @SessionId */                                                                                                                        
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
/*   Date      Author        Purpose                  */                          
/*  20May,2011  Shifali      Created      */                             
    
    
  BEGIN  
  Delete from ListPagePMGroupServices where SessionId=@SessionId  
                                                                                                                        
  IF (@@error!=0)                                                                                                         
    BEGIN                                                  
        RAISERROR  20002 ''csp_SCDeleteGroupServicesListPageData : An error  occured''                                                                                                                          
                                                                                                                             
        RETURN(1)                                                                             
                                                                                    
    END       
  END ' 
END
GO
