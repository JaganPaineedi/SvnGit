IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomPsychiatricNoteDiscontinuedMedicationList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomPsychiatricNoteDiscontinuedMedicationList] 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[csp_RDLCustomPsychiatricNoteDiscontinuedMedicationList] --8001956  --5,'D'  
(@DocumentVersionId INT=0)  
/*************************************************      
  Date:			Author:       Description:                                  
  -------------------------------------------------------------------------                  
  29-03-2016    Lakshmi		  Discontinued Medicationlist psychiatricnote #10 
  13-Nov-2017 K.Soujanya  What:Changes made to pull all the discontinued medications that have been ordered /non-ordered based on Date of Service and Clientid
                               Why:Thresholds - Support,Task#1070
  17-Nov-2017 Mrunali--      What:added a CustomPsychiatricNoteMedicationHistory  table in join condition, and added checks to fetch correct data
                             Why:Thresholds - Support #1072                             
************************************************/
  AS   
 BEGIN  
 BEGIN TRY  
 DECLARE @ClientID INT  
 ,@DateOfService DATETIME 

set @ClientID = (select top 1 ClientId from documents where CurrentDocumentVersionId = @DocumentVersionId)
set @DateOfService= (select top 1 dateofservice from Services where ServiceId=(select top 1 ServiceId from documents where CurrentDocumentVersionId = @DocumentVersionId ))
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
  JOIN clientmedicationscripts cms ON (cmsd.ClientMedicationScriptId = cms.ClientMedicationScriptId)  
  WHERE ClientMedicationInstructionId IN (  
    SELECT ClientMedicationInstructionId  
    FROM clientmedications a  
    JOIN dbo.ClientMedicationInstructions b ON (a.ClientMedicationId = b.ClientMedicationId)  
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
  
--Discontinued Medications  
 SELECT DISTINCT MDM.MedicationName + ' ' + '&' + ' ' + ISNULL(CAST(MD.StrengthDescription AS VARCHAR(max)), '') AS MedicationName  
  ,CASE   
   WHEN dbo.csf_GetGlobalCodeNameById(ISNULL(CAST(CMI.Schedule AS VARCHAR(50)), '')) = ''  
    THEN ''  
   ELSE dbo.csf_GetGlobalCodeNameById(ISNULL(CAST(CMI.Schedule AS VARCHAR(50)), ''))  
   END AS Direction  
  ,ISNULL(CAST(CMI.Quantity AS VARCHAR(50)), '') AS Quantity  
  ,ISNULL(CAST(CMSDS.Refills AS VARCHAR(50)), '') AS Refills  
  ,CM.PrescriberName  
 FROM ClientMedicationInstructions CMI  
 JOIN ClientMedications CM ON (  
   CMI.clientmedicationId = CM.clientMedicationid  
   AND ISNULL(cm.discontinued, 'N') = 'Y'  
   AND ISNULL(cm.RecordDeleted, 'N') <> 'Y'  
   ) 
   INNER JOIN CustomPsychiatricNoteMedicationHistory CDM  on CDM.ClientMedicationId =CMI .ClientMedicationId 
 LEFT JOIN GlobalCodes GC ON (GC.GlobalCodeID = CMI.Unit)  
  AND ISNULL(gc.RecordDeleted, 'N') <> 'Y'  
 LEFT JOIN GlobalCodes GC1 ON (GC1.GlobalCodeId = CMI.Schedule)  
  AND ISNULL(gc1.RecordDeleted, 'N') <> 'Y'  
 JOIN MDMedicationNames MDM ON (  
   CM.MedicationNameId = MDM.MedicationNameId  
   AND ISNULL(mdm.RecordDeleted, 'N') <> 'Y'  
   )  
 JOIN MDMedications MD ON (  
   MD.MedicationID = CMI.StrengthId  
   AND ISNULL(md.RecordDeleted, 'N') <> 'Y'  
   )  
 JOIN ClientMedicationScriptDrugs CMSD ON (  
   CMI.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId  
   AND ISNULL(CMSD.RecordDeleted, 'N') <> 'Y'  
   )  
 JOIN ClientMedicationScriptDrugStrengths CMSDS ON (  
   CM.clientMedicationid = CMSDS.clientMedicationid  
   AND ISNULL(CMSDS.RecordDeleted, 'N') <> 'Y'  
   )  
 LEFT JOIN @LastScriptIdTable LSId ON (  
   cmi.ClientMedicationInstructionId = LSId.ClientMedicationInstructionId  
   AND cmsd.ClientMedicationScriptId = LSId.ClientMedicationScriptId  
   )  
   AND (  
   CMSD.ClientMedicationScriptId IS NULL  
   OR CMSD.ClientMedicationScriptId = LSId.ClientMedicationScriptId  
   )  
 Left JOIN dbo.ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = LSId.ClientMedicationScriptId  
 WHERE cm.ClientId = @ClientId  
  AND ISNULL(cmi.Active, 'Y') = 'Y'  
  --AND ISNULL(CM.Ordered, 'N') = 'Y'  
  AND CM.DiscontinueDate=@DateOfService
  AND CM.Discontinued = 'Y'   
  AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y' 
   AND CDM.DocumentVersionId =@DocumentVersionId  
   AND CDM.MedicalStatus ='N'
  AND ISNULL(CDM.RecordDeleted, 'N') <> 'Y'  

END TRY
 BEGIN CATCH            
   DECLARE @Error varchar(8000)                                                   
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                          
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RDLCustomPsychiatricNoteDiscontinuedMedicationList')                                                                                 
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                  
   + '*****' + Convert(varchar,ERROR_STATE())                                             
   RAISERROR ( @Error, /* Message text.*/16, /* Severity.*/ 1 /*State.*/ );               
 END CATCH  
 END