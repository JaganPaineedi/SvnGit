IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetReportServerDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetReportServerDetail]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

                          
CREATE PROCEDURE  [dbo].[ssp_SCGetReportServerDetail] -- 0             
(            
 @ReportServerId int            
)           
As      
                 
Begin                    
/*********************************************************************/                      
/* Stored Procedure: dbo.ssp_SCGetReportServerDetail                */               
/* Creation Date:  10/07/2010                                    */                      
/* Creation By:  Damanpreet Kaur                                                     */                      
/* Purpose: Gets Data For ReportServers Details screen corressponding to ReportServerId       */                     
/*                                                                   */                    
/* Input Parameters: @ReportServerId*/                    
/*                                                                   */                       
/* Output Parameters:                                */                      
/*                                                                   */                      
/* Return:   */                      
/*                                                                   */                      
/* Called By:     */                      
/*                                                                   */                      
/* Calls:                                                            */                      
/*                                                                   */                      
/* Data Modifications:                                               */                      
/*                                                                   */                      
/*   Updates:                                                        */                      
/*     Date                  Author                    Purpose      */            
/*   24th Sep 2010         Damanpreet Kaur           Modified as per new data model            */  
/*   25th April 2017       Arjun K R                 Added Select statement for @ReportServerId=0. Task #490 Engineering Improvement Initiatives- NBL(I) */          
/*********************************************************************/       
      
       SELECT TOP 1 [ReportServerId]      
			  ,[Name]      
			  ,[URL]      
			  ,[ConnectionString]      
			  ,[RowIdentifier]      
			  ,[CreatedBy]      
			  ,[CreatedDate]      
			  ,[ModifiedBy]      
			  ,[ModifiedDate]      
			  ,[RecordDeleted]      
			  ,[DeletedDate]      
			  ,[DeletedBy]      
			  ,[UserName]    
			  ,[Password]    
			  ,[DomainName]  
		 FROM ReportServers R             
		 WHERE (ReportServerId = @ReportServerId OR @ReportServerId = 0)      
		 and ISNULL(R.RecordDeleted,'N') ='N'         
             
  If (@@error!=0)            
  Begin            
   RAISERROR  ('ssp_SCGetReportServerDetail: An Error Occured'   ,16,1) 
   return          
   End          
            
End 
GO


