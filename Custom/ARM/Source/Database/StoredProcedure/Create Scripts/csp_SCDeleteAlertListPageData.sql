/****** Object:  StoredProcedure [dbo].[csp_SCDeleteAlertListPageData]    Script Date: 06/19/2013 17:49:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteAlertListPageData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCDeleteAlertListPageData]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteAlertListPageData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_SCDeleteAlertListPageData]                  
(                                                                                                              
 @SessionId varchar(100)                                                                                                                              
)                                                                                                                           
as                                                                                                                           
/*********************************************************************/                                                                                                                                   
/* Stored Procedure: dbo.[csp_SCDeleteAlertListPageData]                */                                                                                                                                   
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                                                                                                                                   
/* Creation Date:    23/03/2010                                         */                                                                                                                                  
/*                                                                   */                                                                                                                                   
/* Purpose:  To delete from InboxList on basis of SessionId  */                                                                                                                                   
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
/* Data Modifications:                  */                      
/*  */                  
/* Updates:  */                                
/*   Date     Author   Purpose                  */                                   
/*               */                                      
             
             
  BEGIN           
  Delete from ListPageSCAlerts where SessionId=@SessionId           
                                                                                                                                 
  IF (@@error!=0)                                                                                                                  
    BEGIN                                                           
        RAISERROR  20002 ''ListPageSCAlerts : An error  occured''                                                                                                                                   
                                                                                                                                      
        RETURN(1)                                                                                      
                                                                                             
    END                
  END
' 
END
GO
