/****** Object:  StoredProcedure [dbo].[csp_SCWebGetCustomTPNeeds]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCWebGetCustomTPNeeds]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCWebGetCustomTPNeeds]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCWebGetCustomTPNeeds]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'  
CREATE PROCEDURE [dbo].[csp_SCWebGetCustomTPNeeds]   
@ClientId int  
AS  
BEGIN  
/* Stored Procedure: dbo.csp_SCWebGetCustomTPNeeds                 */                                                                                                                          
/* Purpose:   To get data for CustomTPNeeds                        */                                                                                                                          
/*                                                                 */                                                                                                                          
/* Input Parameters:   @ClientID :-Id of the client*/                                                                                                                          
/*                                                                   */                                                                                                                          
/* Output Parameters:   None                                         */                                                                                                                          
/*                                                                   */                                                                                                                          
/* Return:  0=success, otherwise an error number                 */                                                                                                                          
/*                                                                   */                                                                                                                          
/* Called By:                  */                                                                                                                          
/*                                                                   */                                                                                                                          
/* Calls:                                                            */                                                                                                                          
/*                                                                   */                                                                                                                          
/* Data Modifications:                                               */                                                                                                                          
/*                                                                   */                                                                                                                          
/* Updates:                                                          */                                                                                                                          
/*   Date            Author         Purpose                          */                                                                                             
/*   12,July,2011    Rohit Katoch   To get data for CustomTPNeeds                                                     
                                                                      */        
/**********************************************************************/         
 SELECT [NeedId]  
      ,[CreatedBy]  
      ,[CreatedDate]  
      ,[ModifiedBy]  
      ,[ModifiedDate]  
      ,[RecordDeleted]  
      ,[DeletedDate]  
      ,[DeletedBy]  
      ,[ClientId]  
      ,[NeedText]  
  FROM CustomTPNeeds where ClientId=@ClientId and ISNULL(RecordDeleted,''N'')<>''Y''  
END  ' 
END
GO
