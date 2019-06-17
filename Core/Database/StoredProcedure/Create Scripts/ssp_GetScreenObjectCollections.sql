 IF EXISTS ( SELECT * 
            FROM   sysobjects 
            WHERE  id = object_id(N'[dbo].[ssp_GetScreenObjectCollections]') 
                   and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
    DROP PROCEDURE [dbo].[ssp_GetScreenObjectCollections]
END
Go     
/*********************************************************************/              
/* Stored Procedure: dbo.ssp_GetScreenObjectCollections    --1629         */              
/* Copyright:             */              
/* Creation Date:  12-06-2017                                  */              
/*                                                                   */              
/* Purpose:Create Table          */             
/*                                                                   */            
/* Input Parameters:       */            
/*                                                                   */              
/* Output Parameters:                                */              
/*                                                                   */              
/* Return: */              
/*                                                                   */              
/* Called By:                                                        */              
/*                                                                   */              
/* Calls:                                                            */              
/*                                                                   */              
/* Data Modifications:                                               */              
/*                                                                   */              
/* Updates:                                                          */              
/*  Date        	 Author      Purpose                                    */              
/* 06/12/2017   Rajesh S      Created  Engineering improvement initiative 579 - DFA Detail Page                                   */              
/*********************************************************************/    
    
  CREATE PROCEDURE [dbo].[ssp_GetScreenObjectCollections]  
  AS  
  BEGIN  
	 SELECT  
	  ScreenObjectCollectionId  
	  ,ScreenId  
	  ,FormCollectionId  
	  ,CreatedBy  
	  ,CreatedDate  
	  ,ModifiedBy  
	  ,ModifiedDate  
	  ,RecordDeleted  
	  ,DeletedBy  
	  ,DeletedDate  
	 FROM  
		ScreenObjectCollections  
	 WHERE  
	 ISNULL(RecordDeleted, 'N') = 'N'    
   
  END