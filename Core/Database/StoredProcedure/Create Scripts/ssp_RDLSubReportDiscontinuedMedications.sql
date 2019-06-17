/****** Object:  StoredProcedure [dbo].[ssp_RDLSubReportDiscontinuedMedications]    Script Date: 06/21/2016 09:41:19 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSubReportDiscontinuedMedications]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLSubReportDiscontinuedMedications]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLSubReportDiscontinuedMedications]    Script Date: 06/21/2016 09:41:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_RDLSubReportDiscontinuedMedications] (@DocumentVersionId INT)
AS
BEGIN
	/********************************************************************************                                                           
--          
-- Copyright: Streamline Healthcare Solutions          
-- "CurrentMedications"        
-- Purpose: Script for CCC-Customizations task#12  (copied from Key Pointe – #604 made it core )      
--          
-- Author:  Ravichandra        
-- Date:    05-21-2018        
-- *****History****          

*********************************************************************************/
	DECLARE @ClientId INT
	DECLARE @DateOfService DATETIME
	DECLARE @ServiceId INT
	DECLARE @EffectiveDate DATETIME

	SELECT @ClientId = d.ClientId
		,@ServiceId = d.ServiceId
		,@EffectiveDate = CONVERT(VARCHAR, EffectiveDate, 101)
	FROM Documents d
	WHERE d.InProgressDocumentVersionId = @DocumentVersionId

	SELECT @DateOfService = s.DateOfService
	FROM services s
	LEFT JOIN Documents d ON d.ServiceId = s.ServiceId
	WHERE s.ServiceId = @ServiceId

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

	SELECT DISTINCT MDM.MedicationName AS MedicationName
		,ISNULL(CAST(MD.StrengthDescription AS VARCHAR(max)), '') AS StrengthDescription
		,CASE 
			WHEN dbo.ssf_GetGlobalCodeNameById(ISNULL(CAST(CMI.Schedule AS VARCHAR(50)), '')) = ''
				THEN ''
			ELSE dbo.ssf_GetGlobalCodeNameById(ISNULL(CAST(CMI.Schedule AS VARCHAR(50)), ''))
			END AS Direction
		,CASE 
			WHEN CMSD.PharmacyText IS NULL
				THEN CAST(CMSD.Pharmacy AS VARCHAR(30))
			ELSE CMSD.PharmacyText
			END AS Quantity
		,CAST(CMI.Quantity AS VARCHAR(50)) + ' ' + ISNULL(CAST(GC.CodeName AS VARCHAR(50)), '') AS Units
		,Convert(VARCHAR(10), CMSD.[StartDate], 101) AS RXStartDate
		,Convert(VARCHAR(10), CMSD.[EndDate], 101) AS RXEndDate
		,ISNULL(CAST(CMSD.Refills AS VARCHAR(50)), '') AS Refills
		,CM.PrescriberName
	FROM ClientMedicationInstructions CMI
	JOIN ClientMedications CM ON (
			CMI.clientmedicationId = CM.clientMedicationid
			AND ISNULL(cm.discontinued, 'N') = 'Y'
			AND cast(CM.DiscontinueDate AS DATE) <= CAST(@EffectiveDate AS DATE)
			AND ISNULL(cm.RecordDeleted, 'N') <> 'Y'
			AND CAST(CM.CreatedDate AS DATE) <= CAST(@EffectiveDate AS DATE)
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
			AND cast(CMSD.CreatedDate AS DATE) <= CAST(@EffectiveDate AS DATE)
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
	LEFT JOIN dbo.ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = LSId.ClientMedicationScriptId
	WHERE cm.ClientId = @ClientId
		AND ISNULL(cmi.Active, 'Y') = 'Y'
		AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'
		AND ISNULL(CM.Ordered, 'N') = 'Y'
		--ORDER BY MDM.MedicationName    
END

--Checking For Errors                     
IF (@@error != 0)
BEGIN
	DECLARE @Error VARCHAR(8000)

	SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLSubReportDiscontinuedMedications') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.           
			16
			,-- Severity.           
			1 -- State.                                                             
			);

	RETURN
END
GO


