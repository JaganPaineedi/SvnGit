IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetReportDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetReportDetail]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

        
CREATE PROCEDURE  [dbo].[ssp_SCGetReportDetail]          
(      
 @ReportId int      
)      
      
As      
              
Begin              
/*********************************************************************/                
/* Stored Procedure: dbo.ssp_SCGetReportDetail                       */         
/* Creation Date:  07/07/2010                                        */                
/* Creation By:  Damanpreet Kaur                                                     */                
/* Purpose: Gets Data For Reports Details screen corressponding to ReportId       */               
/*                                                                   */              
/* Input Parameters: @ReportId*/              
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
/*   3-11-2016           Arjun K R          Added AddAsBanner column to banners select statement. AspinPointe Customization task #447 */                                                                       
/*********************************************************************/                 

         
select [ReportId]  
      ,[Name]  
      ,[Description]  
      ,[IsFolder]  
      ,[ParentFolderId]  
      ,[AssociatedWith]  
      ,[ReportServerId]  
      ,[ReportServerPath]  
      ,[RowIdentifier]  
      ,[CreatedBy]  
      ,[CreatedDate]  
      ,[ModifiedBy]  
      ,[ModifiedDate]  
      ,[RecordDeleted]  
      ,[DeletedDate]  
      ,[DeletedBy]  
      ,[AddAsBanner]        -- 3-11-2016           Arjun K R
 from Reports R       
 where ReportId =@ReportId  
 and isnull(R.RecordDeleted,'N') ='N'    
    
    
  --Checking For Errors      
  If (@@error!=0)      
  Begin      
   RAISERROR  20006   'ssp_SCGetReportDetail: An Error Occured'       
   Return      
   End      
      
End      
      
GO


