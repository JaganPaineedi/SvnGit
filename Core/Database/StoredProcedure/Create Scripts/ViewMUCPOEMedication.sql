
/****** Object:  View [dbo].[ViewMUCPOEMedication]    Script Date: 04/11/2018 19:01:20 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[ViewMUCPOEMedication]'))
DROP VIEW [dbo].[ViewMUCPOEMedication]
GO


/****** Object:  View [dbo].[ViewMUCPOEMedication]    Script Date: 04/11/2018 19:01:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
  
CREATE view [dbo].[ViewMUCPOEMedication] as      
/********************************************************************************      
-- View: dbo.ViewMUCPOEMedication        
--      
-- Copyright: Streamline Healthcate Solutions      
--      
-- Purpose: returns all CPOE Medication  
-- Updates:                                                             
-- Date        Author      Purpose      
-- 11.10.2017  Gautam     Created.Why:Meaningful Use - Stage 3 > Tasks #46 > Stage 3 Reports       
*********************************************************************************/  
  
   SELECT CM.ClientId,  
   CM.PrescriberId,  
   CAST(CM.MedicationStartDate AS DATE) as MedicationStartDate  ,  
   MD.MedicationName      ,
   RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName   
        FROM dbo.ClientMedications CM            
        INNER JOIN dbo.Clients C ON C.ClientId = CM.ClientId            
         AND ISNULL(C.RecordDeleted, 'N') = 'N'            
         INNER JOIN MDMedicationNames MD ON CM.MedicationNameId = MD.MedicationNameId   
        WHERE isnull(CM.RecordDeleted, 'N') = 'N'                     
         AND CM.Ordered = 'Y'                                         
GO


