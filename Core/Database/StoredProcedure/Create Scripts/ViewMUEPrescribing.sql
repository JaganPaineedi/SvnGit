
/****** Object:  View [dbo].[ViewMUEPrescribing]    Script Date: 04/11/2018 18:46:06 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[ViewMUEPrescribing]'))
DROP VIEW [dbo].[ViewMUEPrescribing]
GO


/****** Object:  View [dbo].[ViewMUEPrescribing]    Script Date: 04/11/2018 18:46:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

        
        
CREATE view [dbo].[ViewMUEPrescribing] as            
/********************************************************************************            
-- View: dbo.ViewMUEPrescribing              
--            
-- Copyright: Streamline Healthcate Solutions            
--            
-- Purpose: returns all Electronic Prescriptions         
-- Updates:                                                                   
-- Date        Author      Purpose            
-- 11.10.2017  Gautam     Created.       
      Why:Meaningful Use - Stage 3 > Tasks #46 > Stage 3 Reports        
*********************************************************************************/        
        
 SELECT cmsd.ClientMedicationScriptId        
  ,C.ClientId        
  ,RTRIM(c.LastName + ', ' + c.FirstName) as ClientName        
  ,cms.OrderDate        
  ,MD.MedicationName        
  ,CASE         
   WHEN cmsa.Method = 'E'        
    THEN 'Yes'        
   ELSE 'No'        
   END as ETransmitted        
  ,cms.OrderingPrescriberId        
  ,cmsa.Method      
  ,L.TaxIdentificationNumber        
  ,cms.LocationId    
  ,mm.ClinicalFormulationId 
 FROM dbo.ClientMedicationScriptActivities AS cmsa        
 INNER JOIN dbo.ClientMedicationScriptDrugs AS cmsd ON cmsd.ClientMedicationScriptId = cmsa.ClientMedicationScriptId        
  AND isnull(cmsd.RecordDeleted, 'N') = 'N'        
 INNER JOIN dbo.ClientMedicationInstructions AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId        
  AND isnull(cmi.RecordDeleted, 'N') = 'N'        
 INNER JOIN dbo.ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = cmsd.ClientMedicationScriptId        
  AND isnull(cms.RecordDeleted, 'N') = 'N'        
 INNER JOIN dbo.Clients c ON cms.ClientId = c.ClientId        
  AND isnull(c.RecordDeleted, 'N') = 'N'        
 INNER JOIN dbo.MDMedications AS mm ON mm.MedicationId = cmi.StrengthId        
  AND isnull(mm.RecordDeleted, 'N') = 'N'        
 INNER JOIN MDMedicationNames MD ON MM.MedicationNameId = MD.MedicationNameId        
 LEFT JOIN Locations L On cms.LocationId=L.LocationId      
 WHERE isnull(cmsa.RecordDeleted, 'N') = 'N'        
 
GO


