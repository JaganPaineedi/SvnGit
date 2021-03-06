/****** Object:  StoredProcedure [dbo].[csp_SCDeleteListPagePeerReviewAssigned]    Script Date: 06/19/2013 17:49:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteListPagePeerReviewAssigned]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCDeleteListPagePeerReviewAssigned]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteListPagePeerReviewAssigned]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_SCDeleteListPagePeerReviewAssigned]                     
(                                                                                                                 
 @SessionId varchar(100)                                                                                                                                 
)                                                                                                                              
as                                                                                                                              
/*********************************************************************/                                                                                                                                      
/* Stored Procedure: dbo.[csp_SCDeleteListPagePeerReviewAssigned]  */                                                                                                                                      
/* Creation Date:    26/May/2011                                        */                                                                                                                                     
/*                                                                   */                                                                                                                                      
/* Purpose:  To delete from ListPagePeerReviewAssigned on basis of SessionId  */                                                                                                                                      
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
/*  26/May/2011   Priyanka Gupta       Created      */                                         
                
                
  BEGIN              
  Delete from CustomListPageSCRecordReviews where SessionId=@SessionId              
                                                                                                                                    
  IF (@@error!=0)                                                                                                                     
    BEGIN                                                              
        RAISERROR  20002 ''csp_SCDeleteListPagePeerReviewAssigned : An error  occured''                                                                                                                                      
                                                                                                                                         
        RETURN(1)                                                                                         
                                                                                                
    END                   
  END
' 
END
GO
