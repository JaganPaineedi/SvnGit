IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomPsychiatricNoteMedicationNotSC]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomPsychiatricNoteMedicationNotSC] 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[csp_RDLCustomPsychiatricNoteMedicationNotSC] --8001960 --5,'D'  
(@DocumentVersionId INT=0)  
/*************************************************      
  Date:   Author:       Description:                                  
        
  -------------------------------------------------------------------------                  
 15-07-2015    Vijay         What: csp_RDLCustomPsychiatricNoteMedicationNotSC 734787     
                             Why:task #651 Network 180 Customization
 02-03-2016	   Lakshmi       Commented current medications camino custamizations #10.1      
 17-Nov-2017   Mrunali      What:added a CustomPsychiatricNoteMedicationHistory  table in join condition, and added checks to fetch correct data
                            Why:Thresholds - Support #1072                         
************************************************/
  AS   
 BEGIN  
      
 BEGIN TRY  
 
 DECLARE @ClientID INT  
 ,@DateOfService DATETIME 

set @ClientID = (select top 1 ClientId from documents where CurrentDocumentVersionId = @DocumentVersionId)
set @DateOfService= (select top 1 dateofservice from Services where ServiceId=(select top 1 ServiceId from documents where CurrentDocumentVersionId = @DocumentVersionId ))
DECLARE @AgencyName VARCHAR(MAX)

SELECT @AgencyName=AgencyName FROM AGENCY

 DECLARE @LastScriptIdTable TABLE (  
  ClientmedicationInstructionid INT  
  ,ClientMedicationScriptId INT  
  )  
  
 INSERT INTO @LastScriptIdTable (  
  ClientmedicationInstructionid  
  ,ClientMedicationScriptId  
  )  
 SELECT ClientmedicationInstructionid  
  ,ClientMedicationScriptId  
 FROM (  
  SELECT cmsd.ClientmedicationInstructionid  
   ,cmsd.ClientMedicationScriptId  
   ,cms.OrderDate  
   ,ROW_NUMBER() OVER (  
    PARTITION BY cmsd.ClientmedicationInstructionid ORDER BY cms.OrderDate DESC  
     ,cmsd.ClientMedicationScriptId DESC  
    ) AS rownum  
  FROM clientmedicationscriptdrugs cmsd  
  INNER JOIN clientmedicationscripts cms ON (cmsd.ClientMedicationScriptId = cms.ClientMedicationScriptId)  
  WHERE ClientMedicationInstructionId IN (  
    SELECT ClientMedicationInstructionId  
    FROM clientmedications a  
    INNER JOIN dbo.ClientMedicationInstructions b ON (a.ClientMedicationId = b.ClientMedicationId)  
    WHERE a.ClientId = @ClientId  
     AND ISNULL(a.RecordDeleted, 'N') = 'N'  
     AND ISNULL(b.Active, 'Y') = 'Y'  
     AND ISNULL(b.RecordDeleted, 'N') = 'N'  
    )  
   AND ISNULL(cmsd.RecordDeleted, 'N') = 'N'  
   AND ISNULL(cms.RecordDeleted, 'N') = 'N'  
   AND ISNULL(cms.Voided, 'N') = 'N'  
  ) AS a  
 WHERE rownum = 1  
  
 SET @DateOfService = CONVERT(VARCHAR, @DateOfService, 101)  

 SELECT DISTINCT MDM.MedicationName AS MedicationName  
  ,CM.PrescriberName  
  
  ,ISNULL(dbo.ssf_GetGlobalCodeNameById(CM.RXSource), '') AS SOURCE  
  
  ,ISNULL(CONVERT(VARCHAR(10), cms.OrderDate, 101), '') AS LastOrdered  
  ,ISNULL(CONVERT(VARCHAR(10), cm.MedicationStartDate, 101), '') AS MedicationStartDate  
  ,ISNULL(CONVERT(VARCHAR(10), CMSD.EndDate, 101), '') AS MedicationEndDate 
   
  ,'No' AS Script  
  
  ,dbo.csf_GetMedicationInstruction(CMI.ClientMedicationInstructionId) AS Instructions  
 ,CM.SpecialInstructions AS InstructionsText
 ,@AgencyName AS  AgencyName
 FROM ClientMedicationInstructions CMI  
 INNER JOIN ClientMedications CM ON (  
   CMI.clientmedicationId = CM.clientMedicationid  
   AND ISNULL(cm.discontinued, 'N') <> 'Y'  
   AND ISNULL(cm.RecordDeleted, 'N') <> 'Y'  
   )  
    INNER JOIN CustomPsychiatricNoteMedicationHistory CDM  on CDM.ClientMedicationId =CMI .ClientMedicationId
 LEFT JOIN GlobalCodes GC ON (GC.GlobalCodeID = CMI.Unit)  
  AND ISNULL(gc.RecordDeleted, 'N') <> 'Y'  
 LEFT JOIN GlobalCodes GC1 ON (GC1.GlobalCodeId = CMI.Schedule)  
  AND ISNULL(gc1.RecordDeleted, 'N') <> 'Y'  
 INNER JOIN MDMedicationNames MDM ON (  
   CM.MedicationNameId = MDM.MedicationNameId  
   AND ISNULL(mdm.RecordDeleted, 'N') <> 'Y'  
   )  
 INNER JOIN MDMedications MD ON (  
   MD.MedicationID = CMI.StrengthId  
   AND ISNULL(md.RecordDeleted, 'N') <> 'Y'  
   )  
 INNER JOIN ClientMedicationScriptDrugs CMSD ON (  
   CMI.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId  
   AND ISNULL(CMSD.RecordDeleted, 'N') <> 'Y'  
   )  
 LEFT JOIN @LastScriptIdTable LSId ON (  
   cmi.ClientMedicationInstructionId = LSId.ClientMedicationInstructionId  
   AND cmsd.ClientMedicationScriptId = LSId.ClientMedicationScriptId  
   )  
 LEFT JOIN dbo.ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = LSId.ClientMedicationScriptId  
 WHERE cm.ClientId = @ClientId  
  AND cm.Ordered = 'N'  
  --and isnull(CM.SmartCareOrderEntry,'N') = 'N'     
  AND ISNULL(cmi.Active, 'Y') = 'Y'  
  AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'  
  AND (  
   CMSD.ClientMedicationScriptId IS NULL  
   OR CMSD.ClientMedicationScriptId = LSId.ClientMedicationScriptId  
   )  
    AND CDM.DocumentVersionId =@DocumentVersionId  
   AND CDM.MedicalStatus ='N'
   AND ISNULL(CDM.RecordDeleted, 'N') <> 'Y'  
 ORDER BY MDM.MedicationName  
  
 End TRY  
   
  BEGIN CATCH            
   DECLARE @Error varchar(8000)                                                   
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                          
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RDLCustomPsychiatricNoteMedicationNotSC')                                                                                 
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                  
   + '*****' + Convert(varchar,ERROR_STATE())                                             
   RAISERROR ( @Error, /* Message text.*/16, /* Severity.*/ 1 /*State.*/ );               
 END CATCH            
END