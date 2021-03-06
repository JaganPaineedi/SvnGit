/****** Object:  StoredProcedure [dbo].[csp_SCDeleteListPageRecordReviewTemplate]    Script Date: 06/19/2013 17:49:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteListPageRecordReviewTemplate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCDeleteListPageRecordReviewTemplate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteListPageRecordReviewTemplate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_SCDeleteListPageRecordReviewTemplate]                       
(                                                                                                                   
 @SessionId varchar(100)                                                                                                                                   
)                                                                                                                                
as                                                                                                                                
/*********************************************************************/                                                                                                                                        
/* Stored Procedure: dbo.[csp_SCDeleteListPageRecordReviewTemplate]  */                                                                                                                                        
/* Creation Date:    01/June/2011                                        */                                                                                                                                       
/*                                                                   */                                                                                                                                        
/* Purpose:  To delete from ListPageRecordReviewTemplate on basis of SessionId  */                                                                                                                                        
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
/* Data Modifications:       */       
/*                           */            
/* Updates:  */                  
/*   Date          Author              Purpose                  */                                        
/*  01/June/2011   Priyanka Gupta       Created      */                                           
                  
                  
  BEGIN                
  Delete from CustomListPageSCRecordReviewTemplates where SessionId=@SessionId                
                                                                                                                                      
  IF (@@error!=0)                                                                                                                       
    BEGIN                                                                
        RAISERROR  20002 ''csp_SCDeleteListPageRecordReviewTemplate : An error  occured''                                                                                                                                        
                                                                                                                                           
        RETURN(1)                                                                                           
                                                                                                  
    END                     
  END
' 
END
GO
