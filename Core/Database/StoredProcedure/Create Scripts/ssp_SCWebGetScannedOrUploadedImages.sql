IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebGetScannedOrUploadedImages]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCWebGetScannedOrUploadedImages]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[ssp_SCWebGetScannedOrUploadedImages]         
(          
   @ImageRecordId int        
 )        
 as            
 /*        
 Created By:Ashwani Kumar Angrish        
 CreatedOn:15 July 2010        
 Purpose:Get the Images in ImageRecordItems by ImageRecordId        
      
 11/14/2018 jcarlson	   Fixed RAISERROR syntax
         
 */               
 begin                    
                 
	SELECT [ImageRecordItemId],[ImageRecordId] ,[ItemNumber]  ,[ItemImage] ,[RowIdentifier] ,[CreatedBy]            
		  ,[CreatedDate],[ModifiedBy]  ,[ModifiedDate],[RecordDeleted],[DeletedDate] ,[DeletedBy] 
	  FROM ImageRecordItems            
     where ImageRecordId=@ImageRecordId and  ISNULL(RecordDeleted, 'N') = 'N'
     order by ItemNumber            
                  
                      
	IF (@@error!=0)               
		BEGIN               
		  RAISERROR  ( '[ssp_SCWebGetScannedOrUploadedImages]: An Error Occured',16,1)
		 END               
 end
