IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetImageRecordItem]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetImageRecordItem]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO							  

CREATE procedure [dbo].[ssp_GetImageRecordItem]                     
(                      
   @ImageRecordItemId int                    
 )                    
 as                        
 /*                    
 Created By:Vaibhav Khare                    
 CreatedOn:15 Sep 2014                    
 Purpose:Get the Images in ImageRecordItems by ImageRecordId                    
                     
   11/14/2018    jcarlson	  Fixed RAISERROR syntax			   
                     
 */                           
 begin                                
                             
      SELECT ImageRecordItemId,      
ImageRecordItemId,      
ImageRecordId,      
ItemNumber,      
ItemImage,      
RowIdentifier,      
CreatedBy,      
CreatedDate,      
ModifiedBy,      
ModifiedDate,      
RecordDeleted,      
DeletedDate,      
DeletedBy,      
Thumbnail FROM ImageRecordItems                        
        where ImageRecordItemId=@ImageRecordItemId             
                              
                                  
IF (@@error!=0)                           
    BEGIN                           
      RAISERROR  ( '[ssp_GetImageRecordItem]: An Error Occured',16,1)
     END                           
 end 
