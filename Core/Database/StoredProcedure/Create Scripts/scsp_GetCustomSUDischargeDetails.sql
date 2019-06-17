IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_GetCustomSUDischargeDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_GetCustomSUDischargeDetails]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 Create procedure [dbo].[scsp_GetCustomSUDischargeDetails]                                                                                  
                                                                 
/********************************************************************************                                                                              
-- Stored Procedure: dbo.scsp_GetCustomSUDischargeDetails                                                                                
--                                                                              
-- Copyright: Streamline Healthcate Solutions                                                                              
--                                                                              
-- Purpose: used by SSP to avoid the custom table CustomSUDischarges in Core Sp's                                                                            
--                                                                              
-- Updates:                                                                                                                                     
-- Date			Author			Purpose     
--30 Aug 16016	Vithobha		CREATED for AspenPointe-Environment Issues: #45
     
*********************************************************************************/                                                                              
AS                                                                              
BEGIN                                         
BEGIN TRY  
 IF OBJECT_ID('CustomSUDischarges') IS NOT NULL 
 BEGIN
  Select AdmissionDocumentId from CustomSUDischarges d WHERE ISNULL(d.RecordDeleted, 'N') = 'N'  
 END
 ELSE 
	select null  
	           
END TRY                                 
BEGIN CATCH                                            
                                          
DECLARE @Error varchar(8000)                                                                                         
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())         
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'scsp_GetCustomSUDischargeDetails')                                                                                                                       
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                                        
    + '*****' + Convert(varchar,ERROR_STATE())                                                                    
 RAISERROR                                                                           
 (                                                                                         
  @Error, -- Message text.                                                                                                                      
  16, -- Severity.                                                                                                                      
  1 -- State.                                                                                                                      
 );                                                                                                                    
END CATCH                                                                  
END 
GO


