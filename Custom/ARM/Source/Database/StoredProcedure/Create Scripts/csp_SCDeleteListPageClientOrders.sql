/****** Object:  StoredProcedure [dbo].[csp_SCDeleteListPageClientOrders]    Script Date: 06/19/2013 17:49:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteListPageClientOrders]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCDeleteListPageClientOrders]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteListPageClientOrders]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'                
CREATE procedure [dbo].[csp_SCDeleteListPageClientOrders]                               
(                                                                                                                           
 @SessionId varchar(100)                                                                                                                                           
)                                                                                                                                        
as                                                                                                                                        
/*********************************************************************/                                                                                                                                                
/* Stored Procedure: dbo.[csp_SCDeleteListPageClientOrders]  */                                                                                                                                                
/* Creation Date:    01/June/2011                                        */                                                                                                                                               
/*                                                                   */                                                                                                                                                
/* Purpose:  To delete from ListPageClientOrders on basis of SessionId  */                                                                                                                                                
/*                                                                   */                                                                                                                                              
/* Input Parameters: none        @SessionId */                                                                                                                                              
/*                                                                   */                                                                                                                                                
/* Output Parameters:   None                           */                                                                                                                                                
/*                                                                   */                                                                                                                                                
/* Return:  0=success, otherwise an error number                     */                                                                                                                                                
/*                                                                   */                                                                                                                                                
/* Called By:    DeleteListPagesData()                                                     */                                                                                                                                                
/*                                                                   */                                                                                                                                                
/* Calls:         From ListPage Class  in DataServices                                                  */                                                                                                                                                
/*                                                                   */                        
/* Data Modifications:       */               
/*                     */                    
/* Updates:  */                          
/*   Date          Author              Purpose                  */                                                
/*  01/June/2011   Priya       Created      */                                                   
                          
                          
  BEGIN                        
  Delete from dbo.ListPageSCClientOrders where SessionId=@SessionId                        
                                                                                                                                              
  IF (@@error!=0)                                                                                                                               
    BEGIN                                                                        
        RAISERROR  20002 ''csp_SCDeleteListPageClientOrders : An error  occured''                                                                                                                                                
                                                                                                                                                   
        RETURN(1)                                                                                                   
                                                                                                          
    END                             
  END 
' 
END
GO
