
/****** Object:  View [dbo].[ViewMUEPrescribingClientOrders]    Script Date: 04/11/2018 18:47:44 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[ViewMUEPrescribingClientOrders]'))
DROP VIEW [dbo].[ViewMUEPrescribingClientOrders]
GO


/****** Object:  View [dbo].[ViewMUEPrescribingClientOrders]    Script Date: 04/11/2018 18:47:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
  
create view [dbo].[ViewMUEPrescribingClientOrders] as      
/********************************************************************************      
-- View: dbo.ViewMUEPrescribingClientOrders        
--      
-- Copyright: Streamline Healthcate Solutions      
--      
-- Purpose: returns all Electronic Prescriptions   
-- Updates:                                                             
-- Date        Author      Purpose      
-- 11.10.2017  Gautam     Created.   
							Why:Meaningful Use - Stage 3 > Tasks #46 > Stage 3 Reports    
*********************************************************************************/  
  
 SELECT DISTINCT CO.ClientOrderId  
  ,C.ClientId  
  ,RTRIM(c.LastName + ', ' + c.FirstName) as ClientName  
  ,CO.OrderStartDateTime  
  ,MDM.MedicationName  
  ,CO.OrderingPhysician  
 FROM dbo.ClientOrders AS CO  
 INNER JOIN Orders AS O ON CO.OrderId = O.OrderId  
  AND ISNULL(O.RecordDeleted, 'N') = 'N'  
 INNER JOIN dbo.Clients c ON CO.ClientId = c.ClientId  
  AND isnull(c.RecordDeleted, 'N') = 'N'  
 INNER JOIN OrderStrengths AS OS ON CO.MedicationOrderStrengthId = OS.OrderStrengthId  
  AND ISNULL(OS.RecordDeleted, 'N') = 'N'  
 INNER JOIN MdMedications MM ON MM.medicationId = OS.medicationId  
  AND ISNULL(MM.RecordDeleted, 'N') = 'N'  
 INNER JOIN MDMedicationNames MDM ON MM.MedicationNameId = MDM.MedicationNameId  
 WHERE isnull(CO.RecordDeleted, 'N') = 'N'  
  AND EXISTS (  
   SELECT 1  
   FROM dbo.MDDrugs md  
   WHERE md.ClinicalFormulationId = mm.ClinicalFormulationId  
    AND isnull(md.RecordDeleted, 'N') = 'N'  
    AND md.DEACode = 0  
   )  
  AND O.OrderType = 8501 -- Medication Order 
GO


