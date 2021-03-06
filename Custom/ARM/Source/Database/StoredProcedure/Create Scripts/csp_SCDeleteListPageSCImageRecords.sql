/****** Object:  StoredProcedure [dbo].[csp_SCDeleteListPageSCImageRecords]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteListPageSCImageRecords]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCDeleteListPageSCImageRecords]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteListPageSCImageRecords]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_SCDeleteListPageSCImageRecords]                   
(                                                                                                               
 @SessionId varchar(100)                                                                                                                               
)                                                                                                                            
as                                                                                                                            
/*********************************************************************/                                                                                                                                    
/* Stored Procedure: dbo.[csp_SCDeleteListPageSCImageRecords]                */                                                                                                                                    
/* Creation Date:    24/july/2010                                         */                                                                                                                                   
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
/* Data Modifications:                          */             
/*                           */                   
/* Updates:  */                                 
/*   Date       Author				Purpose                  */                                    
/*   08-Sep-10  Devinder Pal Singh  Changed TableName      */
              
  BEGIN            
  Delete from ListPageImageRecords  where SessionId=@SessionId            
                                                                                                                                  
  IF (@@error!=0)                                                                                                                   
    BEGIN                                                            
        RAISERROR  20002 ''csp_SCDeleteListPageSCImageRecords : An error  occured''                                                                                                                                    
                                                                                                                                       
        RETURN(1)                                                                                       
                                                                                              
    END                 
  END
' 
END
GO
