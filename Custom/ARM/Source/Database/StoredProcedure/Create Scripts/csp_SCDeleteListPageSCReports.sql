/****** Object:  StoredProcedure [dbo].[csp_SCDeleteListPageSCReports]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteListPageSCReports]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCDeleteListPageSCReports]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteListPageSCReports]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create procedure [dbo].[csp_SCDeleteListPageSCReports]               
(                                                                                                           
 @SessionId varchar(100)                                                                                                                           
)                                                                                                                        
as                                                                                                                        
/*********************************************************************/                                                                                                                                
/* Stored Procedure: dbo.[csp_SCDeleteListPageSCReports]                */                                                                                                                                
/* Creation Date:    09/july/2010                                         */                                                                                                                               
/* Creation By:    Damanpreet Kaur                              */                                                                                                                               
/*                                                                   */                                                                                                                                
/* Purpose:  To delete from ListPageReports on basis of SessionId  */                                                                                                                                
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
          
          
  BEGIN        
  Delete from ListPageReports where SessionId=@SessionId        
                                                                                                                              
  IF (@@error!=0)                                                                                                               
    BEGIN                                                        
        RAISERROR  20002 ''csp_SCDeleteListPageSCReports : An error  occured''                                                                                                                                
                                                                                                                                   
        RETURN(1)                                                                                   
                                                                                          
    END             
  END
' 
END
GO
