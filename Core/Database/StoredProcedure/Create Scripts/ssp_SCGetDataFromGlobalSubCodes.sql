
/****** Object:  StoredProcedure [dbo].[ssp_SCGetDataFromGlobalSubCodes]    Script Date: 11/27/2015 15:04:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetDataFromGlobalSubCodes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetDataFromGlobalSubCodes]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetDataFromGlobalSubCodes]    Script Date: 11/27/2015 15:04:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE  PROCEDURE  [dbo].[ssp_SCGetDataFromGlobalSubCodes]    
    
As    
            
Begin            
/*********************************************************************/              
/* Stored Procedure: dbo.ssp_SCGetDataFromGlobalSubCodes                */     
    
/* Copyright: 2005 Provider Claim Management System             */              
   
/* Create By: Ranjeetb                                            */   
/* Creation Date:  11/07/2007                                    */              
/*                                                                   */              
/* Purpose: Gets Data From GlobalSubCodes  */             
/*                                                                   */            
/* Input Parameters: None */            
/*                                                                   */               
/* Output Parameters:                                */              
/*                                                                   */              
/* Return:   */              
/*                                                                   */              
/* Called By: getGlobalSubCodes()  Method in MSDE Class Of DataService  in "Always Online Application"  */    
/* Modifications:  */  
/* Date    Author   Purpose      */  
/* 23/1/2012  Maninder  Applied condition RecordDeleted and Active   */  
/* 27/11/2015  Munish Sood  Added Sort Order Interact - Support 277   */     
/*********************************************************************/               
          
  select [GlobalSubCodeId]  
      ,[GlobalCodeId]  
      ,[SubCodeName]  
      ,[Code]  
      ,[Description]  
      ,[Active]  
      ,[CannotModifyNameOrDelete]  
      ,[SortOrder]  
      ,[ExternalCode1]  
      ,[ExternalSource1]  
      ,[ExternalCode2]  
      ,[ExternalSource2]  
      ,[Bitmap]  
      ,[BitmapImage]  
      ,[Color]  
      ,[RowIdentifier]  
      ,[CreatedBy]  
      ,[CreatedDate]  
      ,[ModifiedBy]  
      ,[ModifiedDate]  
      ,[DeletedBy]  
      ,[RecordDeleted]  
      ,[DeletedDate] from dbo.GlobalSubCodes    
  where isnull(RecordDeleted,'N')<>'Y' and Active='Y'  
  Order by SortOrder
    
  --Checking For Errors    
  If (@@error!=0)    
  Begin    
   RAISERROR  20006   'ssp_SCGetDataFromGlobalSubCodes: An Error Occured'     
   Return    
   End             
            
    
End    
    
    
    
    
GO


