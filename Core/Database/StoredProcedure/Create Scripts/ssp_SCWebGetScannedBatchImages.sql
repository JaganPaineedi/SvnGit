/****** Object:  StoredProcedure [dbo].[ssp_SCWebGetScannedBatchImages]    Script Date: 02/19/2016 19:47:12 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebGetScannedBatchImages]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCWebGetScannedBatchImages]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCWebGetScannedBatchImages]    Script Date: 02/19/2016 19:47:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
    
CREATE procedure [dbo].[ssp_SCWebGetScannedBatchImages]             
(              
   @ImageRecordIdList varchar(MAX)         
 )            
 as                
 /*            
 Created By:Rajesh           
 CreatedOn:12-10-2015         
 Purpose:Get the Images in ImageRecordItems by BatchId            
             
 11/14/2018 jcarlson	   Fixed RAISERROR syntax             
 */                   
 begin                        
  
  DECLARE @TargetImageRecordIds TABLE (ImageRecordId INTEGER)    
  
  INSERT  INTO @TargetImageRecordIds
                SELECT  item
                from    dbo.fnSplit(@ImageRecordIdList, ',')
                           
  SELECT   
   IRI.[ImageRecordItemId]    
   ,IRI.[ImageRecordId]     
   ,IRI.[ItemNumber]      
   ,NULL AS [ItemImage]     
   ,IRI.[RowIdentifier]     
   ,IRI.[CreatedBy]                              
   ,IRI.[CreatedDate]    
   ,IRI.[ModifiedBy]      
   ,IRI.[ModifiedDate]    
   ,IRI.[RecordDeleted]    
   ,IRI.[DeletedDate]     
   ,IRI.[DeletedBy]    
   ,IRI.[Thumbnail] 
  FROM  ImageRecordItems  IRI 
  JOIN @TargetImageRecordIds IR ON IR.ImageRecordId = IRI.ImageRecordId                          
  WHERE ISNULL(IRI.RecordDeleted, 'N') = 'N'           
        ORDER BY IRI.ImageRecordId               
                      
                          
IF (@@error!=0)                   
    BEGIN                   
      RAISERROR  ( '[ssp_SCWebGetScannedBatchImages]: An Error Occured',16,1)                 
     END                   
 end                                   
GO


