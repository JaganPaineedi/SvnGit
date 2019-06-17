
/****** Object:  StoredProcedure [dbo].[ssp_SCEventTypes]    Script Date: 09/20/2016 17:52:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCEventTypes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCEventTypes]
GO


/****** Object:  StoredProcedure [dbo].[ssp_SCEventTypes]    Script Date: 09/20/2016 17:52:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE  [dbo].[ssp_SCEventTypes]                     
As                               
Begin                              
/*********************************************************************/                                
/* Stored Procedure: dbo.ssp_SCEventTypes               */                       
                      
                      
/* Creation Date:  20/03/2010                                  */                                
/*                                                                   */                                
/* Purpose: Gets EventTypes           */                               
/*                                                                   */                              
/* Input Parameters:      */                              
/*                                                                   */                                 
/* Output Parameters:                                    */                                
/*                                                                   */                                
/* Return:   */                                
/*                                                                   */                                
/* Called By:         */                    
/*                                                                   */                                
/* Calls:                                                            */                                
/*                                                                   */                                
/* Data Modifications:                                               */                                
/*                                                                   */                                
/*   Updates:                                                          */                                
                      
/*    Date                Author- Vikas Vyas         Purpose - Get data from Insurers    */                                
/*    20th - March-2010 */ 
/*   Modified By                                                        */       
/*  20th Sept 2016 shivanand   changes made for task #4 AspenPointe-Environment Issues */                    
/*********************************************************************/                                 
                            
 SELECT [EventTypeId]  
      ,[EventName]  
      ,[EventType]  
      ,[DisplayNextEventGroup]  
      ,[AssociatedDocumentCodeId]  
      ,[SummaryReportRDL]  
      ,[SummaryStoredProcedure]  
      ,[RowIdentifier]  
      ,[CreatedBy]  
      ,[CreatedDate]  
      ,[ModifiedBy]  
      ,[ModifiedDate]  
      ,[RecordDeleted]  
      ,[DeletedDate]  
      ,[DeletedBy] 
      ,[RequireProvider]   
  FROM [EventTypes]  
  Where ISNULL(RecordDeleted,'N')<>'Y'               
                    
    --Checking For Errors                      
    If (@@error!=0)                      
     Begin                      
      RAISERROR  20006   'ssp_SCEventTypes: An Error Occured'                       
     Return                      
     End                           
                         
                         
                      
End

GO


