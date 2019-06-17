/****** Object:  StoredProcedure [dbo].[csp_GetPsychiatricNoteMedications]    Script Date: 07/09/2015 15:28:38 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetPsychiatricNoteMedications]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_GetPsychiatricNoteMedications]
GO

/****** Object:  StoredProcedure [dbo].[csp_GetPsychiatricNoteMedications] 36959,null   Script Date: 07/09/2015 15:28:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_GetPsychiatricNoteMedications] (
	@ClientID INT
	,@DateOfService DATETIME
	)
AS
BEGIN
	/********************************************************************************                                                     
--    
-- Copyright: Streamline Healthcare Solutions    
-- "Medical note"   csp_GetPsychiatricNoteMedications 4,'03/08/2017'
-- Purpose: Script for Task #10 - Camino Customizations  
--    
-- Author:  Lakshmi  
-- Date:    13-11-2015  
/* 10-May -2016     Venkatesh       What: Current medications should be any prescribed medication that is active.  
										  Not order by should be any add medications that are entered   
										  So we are showing only Prescribed medications in the Current Medication Sections else in the Not Ordered Medications
          Why: As per task #147 in Camino - Environment Issues Tracking*/        

---,Added by sunil 16/01/2017- column CM.SpecialInstructions AS InstructionsText  from ClientMedications table to get instruction text
-- 13-Nov-2017 K.Soujanya -- What:Changes made to pull all the discontinued medications that have been ordered /non-ordered based on Date of Service and Clientid
                             Why:Thresholds - Support,Task#1070
                             
-- 17-Nov-2017 Mrunali--     What:Fetched column ClientMedicationId
                             Why:Thresholds - Support #1072
/* 28/09/2018  Sunil Dasari    What:Added check condition to get current medications based on effective date of the Psych Note.
                               Why:A psych note is created with a previous effective date and if the client has medications prescribed after the effective date of the service note they show in the medication history
                               A Renewed Mind - Support #974 */
*********************************************************************************/
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

	SELECT DISTINCT
	 CM.clientMedicationid AS ClientMedicationId , 
	 MDM.MedicationName AS MedicationName
		,CM.PrescriberName
		,ISNULL(dbo.ssf_GetGlobalCodeNameById(CM.RXSource), '') AS [Source]
		,ISNULL(CONVERT(VARCHAR(10), cms.OrderDate, 101), '') AS LastOrdered
		,ISNULL(CONVERT(VARCHAR(10), cm.MedicationStartDate, 101), '') AS MedicationStartDate
		,ISNULL(CONVERT(VARCHAR(10), CMSD.EndDate, 101), '') AS MedicationEndDate
		,'Yes' AS Script
		,dbo.csf_GetMedicationInstruction(CMI.ClientMedicationInstructionId) AS Instructions
		,CM.SpecialInstructions AS InstructionsText  -- Added by sunil.D
  
	FROM ClientMedicationInstructions CMI
	INNER JOIN ClientMedications CM ON (
			CMI.clientmedicationId = CM.clientMedicationid
			AND ISNULL(cm.discontinued, 'N') <> 'Y'
			AND ISNULL(cm.RecordDeleted, 'N') <> 'Y'
			)
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
	AND cm.Ordered = 'Y'
		AND ISNULL(cmi.Active, 'Y') = 'Y'
		AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'
		AND (
			CMSD.ClientMedicationScriptId IS NULL
			OR CMSD.ClientMedicationScriptId = LSId.ClientMedicationScriptId
			) 
		AND CAST(CM.MedicationStartDate as date) <=CAST( @DateOfService as DATE)  
		AND isnull(CAST( CMSD.EndDate as date),CAST(CM.MedicationEndDate as date)) >=CAST( @DateOfService as DATE) 
	ORDER BY MDM.MedicationName

	SELECT DISTINCT
	 CM.clientMedicationid AS ClientMedicationId , 
	 MDM.MedicationName AS MedicationName
		,CM.PrescriberName
		,ISNULL(dbo.ssf_GetGlobalCodeNameById(CM.RXSource), '') AS [Source]
		,ISNULL(CONVERT(VARCHAR(10), cms.OrderDate, 101), '') AS LastOrdered
		,ISNULL(CONVERT(VARCHAR(10), cm.MedicationStartDate, 101), '') AS MedicationStartDate
		,ISNULL(CONVERT(VARCHAR(10), CMSD.EndDate, 101), '') AS MedicationEndDate
		,'No' AS Script
		,dbo.csf_GetMedicationInstruction(CMI.ClientMedicationInstructionId) AS Instructions
		,CM.SpecialInstructions AS InstructionsText  -- Added by sunil.D
	FROM ClientMedicationInstructions CMI
	INNER JOIN ClientMedications CM ON (
			CMI.clientmedicationId = CM.clientMedicationid
			AND ISNULL(cm.discontinued, 'N') <> 'Y'
			AND ISNULL(cm.RecordDeleted, 'N') <> 'Y'
			)
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
	ORDER BY MDM.MedicationName

	--Discontinued Medications  
 SELECT DISTINCT
  CM.clientMedicationid AS ClientMedicationId , 
  MDM.MedicationName + ' ' + '&' + ' ' + ISNULL(CAST(MD.StrengthDescription AS VARCHAR(max)), '') AS MedicationName  
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

END

--Checking For Errors               
IF (@@error != 0)
BEGIN
	RAISERROR ('[csp_GetPsychiatricNoteMedications] : An Error Occured',16,1)

	RETURN
END
GO

