
 
/****** Object:  StoredProcedure [dbo].[ssp_GetMaxBatchIdFromImageRecords]    Script Date: 04/04/2013 18:28:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetMaxBatchIdFromImageRecords]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetMaxBatchIdFromImageRecords]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetMaxBatchIdFromImageRecords]    Script Date: 04/04/2013 18:28:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO 
 
 
 
 /*            
 Created By:Rajesh           
 CreatedOn:12-10-2015         
 Purpose:Get the Max BatchId            
             
             
 */   
Create PROCEDURE [dbo].[ssp_GetMaxBatchIdFromImageRecords]    
   
 AS    
  
BEGIN    
  
 SET NOCOUNT ON;    
Declare @Max INT  
  
SELECT @Max = MAX(BatchId) FROM ImageRecords  
  
SELECT @Max  
END    

