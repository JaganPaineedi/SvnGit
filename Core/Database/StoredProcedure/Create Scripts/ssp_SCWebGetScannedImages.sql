IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebGetScannedImages]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCWebGetScannedImages]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[ssp_SCWebGetScannedImages]         
(          
   @ImageRecordId int        
 )        
 as            
 /*        
 Created By:Vaibhav Khare	       
 CreatedOn:16-Sep-2014       
 Purpose:Get the Images in ImageRecordItems by ImageRecordId        
         
 11/14/2018 jcarlson	   Fixed RAISERROR syntax
          
 */               
 begin                    
                 
       SELECT [ImageRecordItemId],[ImageRecordId] ,[ItemNumber]  , CAST(null as Image)as [ItemImage] ,[RowIdentifier] ,[CreatedBy]                        
      ,[CreatedDate],[ModifiedBy]  ,[ModifiedDate],[RecordDeleted],[DeletedDate] ,[DeletedBy],Thumbnail FROM ImageRecordItems                        
        where ImageRecordId=@ImageRecordId and  ISNULL(RecordDeleted, 'N') = 'N'       
        order by ItemNumber             
                  
                      
IF (@@error!=0)               
    BEGIN               
      RAISERROR  ( '[ssp_SCWebGetScannedImages]: An Error Occured',16,1)
     END               
 end                               
                                  
