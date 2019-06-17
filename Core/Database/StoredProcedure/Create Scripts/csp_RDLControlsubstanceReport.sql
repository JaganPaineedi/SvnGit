/****** Object:  StoredProcedure [dbo].[csp_RDLControlsubstanceReport]    ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLControlsubstanceReport]')
			AND type IN (
				N'P'
				, N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_RDLControlsubstanceReport];
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLControlsubstanceReport]    ******/
SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE PROCEDURE [dbo].[csp_RDLControlsubstanceReport] 
	  @StartDate DATETIME
	, @EndDate DATETIME 
	, @PrescriberId int
AS

/******************************************************************************
* Creation Date:  6/DEC/2016
*
* Purpose: Gather data for Control Substance Report - EPCS #31
* 
* Customer: EPCS
*
* Called By: Control Substance Report
*
* Calls:
*
* Dependent Upon:
*
* Depends upon this: Report Days to Service
*
* Modifications:
* Date			Author			Purpose
* 
*
*****************************************************************************/
SET NOCOUNT ON;

BEGIN

DECLARE @Local_PrescriberId INT  

SELECT @Local_PrescriberId = @PrescriberId  

DECLARE @StaffDegree INT  
 ,@TaxonomyCode INT  
 ,@VerbalOrdersRequireApproval CHAR(1)  
DECLARE @LastScriptIdTable TABLE (  
 ClientmedicationInstructionid INT  
 ,ClientMedicationScriptId INT  
 ,VerbalOrderReadBack CHAR(1)  
 )  
  
INSERT INTO @LastScriptIdTable (  
 ClientmedicationInstructionid  
 ,ClientMedicationScriptId  
 ,VerbalOrderReadBack  
 )  
SELECT ClientmedicationInstructionid  
 ,ClientMedicationScriptId  
 ,ISNULL(VerbalOrderReadBack, 'N')  
FROM (  
 SELECT cmsd.ClientmedicationInstructionid  
  ,cmsd.ClientMedicationScriptId  
  ,cms.VerbalOrderReadBack  
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
   WHERE 
    ISNULL(a.RecordDeleted, 'N') = 'N'  
    AND ISNULL(b.Active, 'Y') = 'Y'  
    AND ISNULL(b.RecordDeleted, 'N') = 'N'  
   )  
  AND ISNULL(cmsd.RecordDeleted, 'N') = 'N'  
  AND ISNULL(cms.RecordDeleted, 'N') = 'N'  
  AND ISNULL(cms.Voided, 'N') = 'N'  
 ) AS a  
WHERE rownum = 1  
  
DECLARE @ScriptsThatCanBeDiscontinued TABLE (  
 ClientMedicationScriptId INT  
 ,SureScriptsOutgoingMessageId INT  
 ,PharmacyName VARCHAR(100)  
 )  
  
IF EXISTS (  
  SELECT *  
  FROM staff s  
  JOIN globalcodes gc ON (s.SureScriptsServiceLevel = gc.GlobalCodeId)  
  WHERE s.StaffId = @Local_PrescriberId  
   AND gc.ExternalCode1 IS NOT NULL  
   AND (CAST(gc.ExternalCode1 AS INT) & 16) > 0  
  )  
BEGIN  
 INSERT INTO @ScriptsThatCanBeDiscontinued (  
  ClientMedicationScriptId  
  ,SureScriptsOutgoingMessageId  
  ,PharmacyName  
  )  
 SELECT cms.ClientMedicationScriptId  
  ,csa.SureScriptsOutgoingMessageId  
  ,dbo.csf_ReformatPharmacyName(p.PharmacyId)  
 FROM clientmedicationscripts cms  
 JOIN dbo.ClientMedicationScriptActivities csa ON (  
   cms.ClientMedicationScriptId = csa.ClientMedicationScriptId  
   AND csa.Method = 'E'  
   AND csa.SureScriptsOutgoingMessageId IS NOT NULL  
   )  
 JOIN dbo.Pharmacies p ON (cms.PharmacyId = p.PharmacyId)  
 JOIN dbo.SureScriptsPharmacyUpdate spu ON (  
   p.SureScriptsPharmacyIdentifier = spu.NCPDPID  
   AND spu.ActiveStartTime <= GETDATE()  
   AND (  
    spu.ActiveEndTime IS NULL  
    OR spu.ActiveEndTime >= GETDATE()  
    )  
   AND (CAST(spu.ServiceLevel AS INT) & 16) > 0  
   )  
 WHERE 
  cms.ClientMedicationScriptId IN (  
   SELECT clientmedicationscriptid  
   FROM @LastScriptIdTable  
   )  
END  
  
DECLARE @Consents TABLE (  
 ClientMedicationConsentId INT  
 ,ClientMedicationInstructionId INT  
 ,MedicationNameId INT  
 ,SignedByPrescriber CHAR(1)  
 ,SignedByClientRepresentative CHAR(1)  
 ,SignatureOrder INT  
 ,MedConsentsRequireClientSignature CHAR(1)  
 )  
  
INSERT INTO @Consents (  
 ClientMedicationConsentId  
 ,ClientMedicationInstructionId  
 ,MedicationNameId  
 ,SignedByPrescriber  
 ,SignedByClientRepresentative  
 ,SignatureOrder  
 ,MedConsentsRequireClientSignature  
 )  
SELECT ClientMedicationConsentId  
 ,ClientMedicationInstructionId  
 ,MedicationNameId  
 ,CMCD.SignedByPrescriber  
 ,CMCD.SignedByClientRepresentative  
 ,CASE   
  WHEN CMCD.SignedByPrescriber = 'Y'  
   AND ISNULL(CMCD.SignedByClientRepresentative, 'N') = 'N'  
   THEN 1  
  WHEN CMCD.SignedByPrescriber = 'Y'  
   AND CMCD.SignedByClientRepresentative = 'Y'  
   THEN 2  
  WHEN ISNULL(CMCD.SignedByPrescriber, 'N') = 'N'  
   AND ISNULL(CMCD.SignedByClientRepresentative, 'N') = 'N'  
   THEN 0  
  END AS SignatureOrder  
 ,sc.MedConsentsRequireClientSignature  
FROM ClientMedicationConsents CMC  
JOIN ClientMedicationConsentDocuments AS CMCD ON CMCD.DocumentVersionId = CMC.DocumentVersionId  
JOIN DocumentVersions AS DV ON CMCD.DocumentVersionId = DV.DocumentVersionId  
JOIN Documents AS D ON D.DocumentId = DV.DocumentId  
 --AND D.ClientId = @Local_ClientId  
 AND CMC.ConsentEndDate IS NULL  
 AND ISNULL(CMC.RecordDeleted, 'N') = 'N'  
JOIN dbo.SystemConfigurations sc ON (1 = 1)  
WHERE (ISNULL(CMC.ConsentEndDate, DATEADD(month, ISNULL(sc.ConsentDurationMonths, 12), ISNULL(CMCD.ConsentStartDate, CONVERT(DATE, GETDATE(), 101)))) >= CONVERT(DATE, GETDATE(), 101))  
  
SELECT @StaffDegree = s.Degree  
 ,@TaxonomyCode = s.TaxonomyCode  
FROM Staff AS s  
WHERE s.StaffId = @Local_PrescriberId


/*================================== */

DECLARE @ClientMedicationInstructionTable TABLE (  
 ClientMedicationInstructionId INT  
 ,ClientMedicationId INT  
 ,Instruction VARCHAR(500)
 , StartDate Datetime
 , EndDate Datetime
 , Refills  DECIMAL(10,2)
 , MedicationScriptId INT
 ) 

INSERT INTO @ClientMedicationInstructionTable
(
ClientMedicationInstructionId,
ClientMedicationId,
Instruction,
StartDate,
EndDate,
Refills,
MedicationScriptId
)

SELECT cmi.ClientMedicationInstructionId  
 ,cmi.ClientMedicationId  
 ,CASE IsNull(GC1.ExternalCode2, 'Y')  
  WHEN 'Y'  
   THEN (MD.StrengthDescription + ' ' + dbo.ssf_RemoveTrailingZeros(CMI.Quantity) + ' ' + CONVERT(VARCHAR, GC.CodeName) + ' ' + CONVERT(VARCHAR, GC1.CodeName)) + ' ' + CASE   
     WHEN CONVERT(VARCHAR, CMSD.Pharmacy) != '0.00'  
      THEN CONVERT(VARCHAR, CMSD.Pharmacy)  
     WHEN ISNULL(CMSD.PharmacyText, '') != ''  
      THEN CONVERT(VARCHAR, CMSD.PharmacyText)  
     ELSE ''    
     END  
  ELSE hl7.TextInstruction  
  END AS Instruction
 , CMSD.StartDate  
 , CMSD.EndDate     
 , CMSD.Refills     
 ,CAST(CMSD.ClientMedicationScriptId AS VARCHAR) AS MedicationScriptId  
FROM ClientMedicationInstructions CMI  
JOIN ClientMedications CM ON (  
  CMI.clientmedicationId = CM.clientMedicationid  
  AND ISNULL(cm.discontinued, 'N') <> 'Y'  
  AND ISNULL(cm.RecordDeleted, 'N') <> 'Y'  
  )  
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
LEFT JOIN ClientMedicationReconciliations CMR ON (  
  CMR.ClientMedicationId = cmi.ClientMedicationId  
  AND ISNULL(CMR.RecordDeleted, 'N') <> 'Y'  
  )  
LEFT JOIN HL7DocumentInboundMessageMappingsDeatils hl7 ON (  
  hl7.DocumentVersionId = cmr.DocumentVersionId  
  AND ISNULL(CMR.RecordDeleted, 'N') <> 'Y'  
  )  
LEFT JOIN @LastScriptIdTable LSId ON (cmi.ClientMedicationInstructionId = LSId.ClientMedicationInstructionId)  
-- the rest of the join is in the Where statement to eliminate multiple instruction records  
WHERE 
 --cm.ClientId = @Local_ClientId  
 --AND 
 cm.PrescriberId = @Local_PrescriberId  
 AND ISNULL(cmi.Active, 'Y') = 'Y'  
 AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'  
 AND (  
  CMSD.ClientMedicationScriptId IS NULL  
  OR CMSD.ClientMedicationScriptId = LSId.ClientMedicationScriptId  
  )  
 AND (  
  (  
   LSId.ClientMedicationScriptId IS NOT NULL  
   AND cmsd.ClientMedicationScriptId = LSId.ClientMedicationScriptId  
   )  
  OR LSId.ClientMedicationScriptId IS NULL  
  )  
ORDER BY CM.ClientMedicationId ASC  

--SELECT * FROM @ClientMedicationInstructionTable
--select * from @LastScriptIdTable
/*================================== */
  
  
SELECT @VerbalOrdersRequireApproval = ISNULL(VerbalOrdersRequireApproval, 'N')  
FROM SystemConfigurations;  
  
WITH ClientMeds  
AS (  
 SELECT CMS.CreatedDate, CM.ClientMedicationId  
  ,CM.ClientId  
  ,CS.FirstName + ' ' + CS.LastName as ClientName
  ,MDN.MedicationName AS MedicationName  
  ,CMIT.Instruction
  ,CMIT.Refills
  ,CM.Ordered  
  --,CM.MedicationNameId      
  ,CM.PrescriberId  
  --,CM.PrescriberName     
  ,CMIT.StartDate  as MedicationStartDate
  ,CMIT.EndDate    as MedicationEndDate  
  ,CAST(LSId.ClientMedicationScriptId AS VARCHAR) AS MedicationScriptId  
  ,ISNULL(MDDrugs.DEACODE, [dbo].[ssf_SCClientMedicationC2C5Drugs](mdmeds.MedicationId)) AS DrugCategory      
  ,ClientMedicationConsentId  
  ,CASE   
   WHEN cst.SignatureOrder = 1  
    AND cst.MedConsentsRequireClientSignature = 'N'  
    THEN 2  
   WHEN cst.SignatureOrder = 1  
    THEN 1  
   WHEN cst.SignatureOrder > 1  
    THEN 2  
   WHEN cst.SignatureOrder = 0  
    THEN 0  
   WHEN cst.SignatureOrder IS NULL  
    THEN 0  
   END AS SignedByMD  
 FROM ClientMedications CM  
 JOIN MDMedicationNames MDN ON (CM.MedicationNameId = MDN.MedicationNameId)  
 LEFT OUTER JOIN ClientMedicationInstructions cmi ON (  
   cmi.ClientMedicationId = CM.ClientMedicationId  
   AND ISNULL(cmi.Active, 'Y') = 'Y'  
   AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'  
   )  
 LEFT JOIN @LastScriptIdTable LSId ON (cmi.ClientMedicationInstructionId = LSId.ClientMedicationInstructionId)  
 LEFT OUTER JOIN MDMedications mdmeds ON (  
   mdmeds.MedicationId = cmi.StrengthId  
   AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'  
   AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'  
   )  
 LEFT OUTER JOIN MDDrugs ON (  
   mdmeds.ClinicalFormulationId = MDDrugs.ClinicalFormulationId  
   AND ISNULL(MDDrugs.RecordDeleted, 'N') <> 'Y'  
   )  
 LEFT OUTER JOIN ClientMedicationScriptDrugs cmsd ON (  
   cmsd.ClientMedicationInstructionId = LSId.ClientMedicationInstructionId  
   AND cmsd.ClientMedicationScriptId = LSID.ClientMedicationScriptId  
   AND ISNULL(cmsd.RecordDeleted, 'N') = 'N'  
   )  
 LEFT OUTER JOIN ClientMedicationScripts CMS ON (  
   CMS.ClientMedicationScriptId = cmsd.ClientMedicationScriptId  
   AND cms.ClientMedicationScriptId = LSID.ClientMedicationScriptId  
   AND ISNULL(cms.RecordDeleted, 'N') = 'N'  
   )  
 LEFT OUTER JOIN @Consents cst ON (  
   (  
    cst.ClientMedicationInstructionId = cmi.ClientMedicationInstructionId  
    AND CM.OffLabel = 'Y'  
    )  
   OR (  
    cst.MedicationNameId = CM.MedicationNameId  
    AND ISNULL(CM.OffLabel, 'N') = 'N'  
    )  
   )  
 LEFT OUTER JOIN Staff s ON (cm.PrescriberId = s.StaffId)  
 LEFT JOIN @ScriptsThatCanBeDiscontinued sd ON (LSId.ClientMedicationScriptId = sd.clientmedicationscriptid)  
 LEFT JOIN Pharmacies pr ON (CMS.PharmacyId = pr.PharmacyId) 
 LEFT JOIN Clients cs on cs.ClientId = cm.ClientId
 --LEFT JOIN @ClientMedicationInstructionTable CMIT on CMIT.ClientMedicationId = CM.ClientMedicationId 
 LEFT JOIN @ClientMedicationInstructionTable CMIT on LSId.ClientMedicationScriptId = CMIT.MedicationScriptId 
 
 
 
 WHERE cm.PrescriberId = @Local_PrescriberId  
 )  
 ,ClientMedsDistinct  
AS (  
 SELECT DISTINCT *  
 FROM ClientMeds  
 )  
SELECT *  
FROM ClientMedsDistinct  
WHERE (  
    ISNULL(Ordered, 'N') = 'Y'  
  AND MedicationScriptID IS NOT NULL  
  AND CONVERT(INT, DrugCategory)  > 0
AND (ClientMedsDistinct.CreatedDate >= (@StartDate) AND ClientMedsDistinct.CreatedDate < (@EndDate+1))
  )  
 OR (ISNULL(Ordered, 'N') = 'N' 
 AND CONVERT(INT, DrugCategory)  > 0
AND (ClientMedsDistinct.CreatedDate >= (@StartDate) AND ClientMedsDistinct.CreatedDate < (@EndDate+1))
 )    
ORDER BY CASE   
  WHEN Ordered = 'Y'  
   THEN 0  
  ELSE 1  
  END  
  ,ClientName asc
  ,MedicationName asc
  ,MedicationStartDate asc

END
GO




