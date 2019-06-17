/****** Object:  StoredProcedure [dbo].[ssp_InitializeLifeEventDetails]    Script Date: 12/06/2018 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_InitializeLifeEventDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_InitializeLifeEventDetails]
GO

/****** Object:  StoredProcedure [dbo].[ssp_InitializeLifeEventDetails]    Script Date: 12/06/2018 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE  [dbo].[ssp_InitializeLifeEventDetails]           
(                                  
 @StaffId int,            
 @ClientID int,            
 @CustomParameters xml                                  
)                                                          
As                                                                
Begin                                                                    
 /*********************************************************************/            
 /* Stored Procedure: [ssp_InitializeReportDetail]                    */   
 /* Creation Date : 28th April 2016                                 */  
 /* Creation By  : Rajeshwari S       */   
 /* Purpose   : Initialization StoredProcedure for Life Event Detail Page. Ref.AspenPointe - Support Go Live#894*/  
 /*********************************************************************/   
    SELECT 'ClientLifeEvents' as TableName,        
       -1 as [ClientLifeEventId]        
      ,-1 as[LifeEventId]        
      ,@ClientID as [ClientId]               
      ,'' as [CreatedBy]        
      ,CURRENT_TIMESTAMP as [CreatedDate]        
      ,'' as [ModifiedBy]        
      ,CURRENT_TIMESTAMP as [ModifiedDate]                   
                                 
END                    
                                      
--Checking For Errors         
If (@@error!=0)              
Begin                         
RAISERROR 20006 '[ssp_InitializeLifeEventDetail] : An Error Occured'             
Return                       
End 