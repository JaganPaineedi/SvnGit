/****** Object:  StoredProcedure [dbo].[csp_GetPsychiatricNoteDisconMedications]   Script Date: 03/26/2014******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetPsychiatricNoteDisconMedications]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_GetPsychiatricNoteDisconMedications]
GO

/****** Object:  StoredProcedure [dbo].[csp_GetPsychiatricNoteDisconMedications]    Script Date: 03/26/2014******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_GetPsychiatricNoteDisconMedications] (
	@ClientID INT
	,@DateOfService DATETIME
	)
AS
BEGIN
	/********************************************************************************                                                     
--    
-- Copyright: Streamline Healthcare Solutions    
-- "Psychiatric Service"  
-- Purpose: Script for Task #10 - camino Customizations  
--    
-- Author:  Lakshmi Kanth  
-- Date:    20-11-2015  
-- *****History****    
 13-Nov-2017  K.Soujanya   What:Changes made to pull all the discontinued medications that have been ordered /non-ordered based on Date of Service and Clientid
                           Why:Thresholds - Support,Task#1070
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
IF (@@error != 0)
BEGIN
	RAISERROR ('[csp_GetPsychiatricNoteDisconMedications] : An Error Occured',16,1)

	RETURN
END
