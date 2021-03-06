/****** Object:  StoredProcedure [dbo].[csp_SCDeleteGroupListPageData]    Script Date: 06/19/2013 17:49:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteGroupListPageData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCDeleteGroupListPageData]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteGroupListPageData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure [dbo].[csp_SCDeleteGroupListPageData]         
(                                                                                                     
 @SessionId varchar(100)                                                                                                                     
)                                                                                                                  
as                                                                                                                  
/*********************************************************************/                                                                                                                          
/* Stored Procedure: dbo.[csp_SCDeleteGroupListPageData]                */                                                                                                                          
/* Creation Date:    20May,2011                                         */                                                                                                                         
/*                                                                   */                                                                                                                          
/* Purpose:  To delete from ListPagePMGroups on basis of SessionId  */                                                                                                                          
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
  Delete from ListPagePMGroups where SessionId=@SessionId  
                                                                                                                        
  IF (@@error!=0)                                                                                                         
    BEGIN                                                  
        RAISERROR  20002 ''csp_SCDeleteGroupListPageData : An error  occured''                                                                                                                          
                                                                                                                             
        RETURN(1)                                                                             
                                                                                    
    END       
  END ' 
END
GO
