
/****** Object:  View [dbo].[ViewMUCPOEMedicationImageRecords]    Script Date: 04/11/2018 19:02:08 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[ViewMUCPOEMedicationImageRecords]'))
DROP VIEW [dbo].[ViewMUCPOEMedicationImageRecords]
GO



/****** Object:  View [dbo].[ViewMUCPOEMedicationImageRecords]    Script Date: 04/11/2018 19:02:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


  
  
CREATE view [dbo].[ViewMUCPOEMedicationImageRecords] as      
/********************************************************************************      
-- View: dbo.ViewMUCPOEMedicationImageRecords        
--      
-- Copyright: Streamline Healthcate Solutions      
--      
-- Purpose: returns all CPOE Medication Image Records  
-- Updates:                                                             
-- Date        Author      Purpose      
-- 11.10.2017  Gautam     Created.  Why:Meaningful Use - Stage 3 > Tasks #46 > Stage 3 Reports    
*********************************************************************************/  
  
 SELECT IR.ImageRecordId,   
  IR.CreatedBy   ,  
  IR.AssociatedId    ,  
  cast(IR.EffectiveDate AS DATE)  as EffectiveDate,  
   RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName , 
  IR.RecordDescription  ,
  IR.ClientId
        FROM dbo.ImageRecords IR            
        Join Clients C  ON C.ClientId = IR.ClientId  
        WHERE isnull(IR.RecordDeleted, 'N') = 'N'          
         AND ISNULL(C.RecordDeleted, 'N') = 'N'            
         --AND IR.AssociatedId = 1622 -- Document Codes for 'Medications'                            
                                      

GO


