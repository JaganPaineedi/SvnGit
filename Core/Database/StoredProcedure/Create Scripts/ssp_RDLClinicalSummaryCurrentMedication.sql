

/****** Object:  StoredProcedure [dbo].[ssp_RDLClinicalSummaryCurrentMedication]    Script Date: 06/11/2015 17:36:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLClinicalSummaryCurrentMedication]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLClinicalSummaryCurrentMedication]
GO



/****** Object:  StoredProcedure [dbo].[ssp_RDLClinicalSummaryCurrentMedication]    Script Date: 06/11/2015 17:36:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_RDLClinicalSummaryCurrentMedication] (
	@ServiceId INT = NULL
	,@ClientId INT
	,@DocumentVersionId INT = NULL
	)
AS
BEGIN
	/************************************************************************/
	/* Stored Procedure: ssp_RDLClinicalSummaryCurrentMedication      */
	/* Creation Date:  25 Feb 2014            */
	/* Purpose: Current Medication for Clinical Summary          */
	/* Input Parameters: @ServiceId          */
	/* Output Parameters:              */
	/* Author: Veena S Mani               */
	/* Updates:                 */
	/* Date    Author    Purpose        */
	/*  02/05/2014   Veena S Mani        Added parameters ClientId and EffectiveDate-Meaningful Use #18  */
	/*  019/05/2014  Veena S Mani        Added parameters DocumentId and removed EffectiveDate to make SP reusable for MeaningfulUse #7,#18 and #24.Also added the logic for the same. */
	/*  03/09/2014  Revathi    what: call ssf_GetGlobalCodeNameById ,ssf_GetMedicationInstruction instead of csf_GetGlobalCodeNameById ,csf_GetMedicationInstruction      
          why:task#36 MeaningfulUse        */
    /*  03/09/2015  Revathi			what: Get Active Medication
									why:	task#18 Post Certification         */ 	      
	/*************************************************************************/
	BEGIN TRY
		DECLARE @DOS DATETIME = NULL

		IF (@ServiceId IS NOT NULL)
		BEGIN
			SELECT @DOS = DateOfService
			FROM Services
			WHERE ServiceId = @ServiceId
		END
		ELSE IF (
				@ServiceId IS NULL
				AND @DocumentVersionId IS NOT NULL
				)
		BEGIN
			SELECT TOP 1 @DOS = EffectiveDate
			FROM Documents
			WHERE InProgressDocumentVersionId = @DocumentVersionId
				AND ISNULL(RecordDeleted, 'N') = 'N'
		END

		DECLARE @LastScriptIdTable TABLE (
			ClientMedicationInstructionId INT
			,ClientMedicationScriptId INT
			)

		INSERT INTO @LastScriptIdTable (
			ClientMedicationInstructionId
			,ClientMedicationScriptId
			)
		SELECT ClientMedicationInstructionId
			,ClientMedicationScriptId
		FROM (
			SELECT cmsd.ClientMedicationInstructionId
				,cmsd.ClientMedicationScriptId
				,cms.OrderDate
				,ROW_NUMBER() OVER (
					PARTITION BY cmsd.ClientMedicationInstructionId ORDER BY cms.OrderDate DESC
						,cmsd.ClientMedicationScriptId DESC
					) AS rownum
			FROM ClientMedicationScriptDrugs cmsd
			INNER JOIN ClientMedicationScripts cms ON (cmsd.ClientMedicationScriptId = cms.ClientMedicationScriptId)
			WHERE ClientMedicationInstructionId IN (
					SELECT ClientMedicationInstructionId
					FROM ClientMedications a
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

		SELECT DISTINCT MDM.MedicationName AS MedicationName
			,CM.PrescriberName
			,ISNULL(dbo.ssf_GetGlobalCodeNameById(CM.RXSource), '') AS SOURCE
			,ISNULL(CONVERT(VARCHAR(10), cms.OrderDate, 101), '') AS LastOrdered
			,ISNULL(CONVERT(VARCHAR(10), cm.MedicationStartDate, 101), '') AS MedicationStartDate
			,ISNULL(CONVERT(VARCHAR(10), CMSD.EndDate, 101), '') AS MedicationEndDate
			,'Yes' AS Script
			,CASE 
				WHEN (cm.IncludeCommentOnPrescription = 'Y')
					THEN COALESCE(dbo.ssf_GetMedicationInstruction(CMI.ClientMedicationInstructionId) + ', ', '') + isnull(cm.comments, '')
				ELSE dbo.ssf_GetMedicationInstruction(CMI.ClientMedicationInstructionId)
				END AS Instructions
			,CASE 
				WHEN (
						cm.discontinuedate <= @DOS
						AND CM.Discontinued = 'Y'
						)
					THEN 'Discontinued'
				ELSE 'Active'
				END AS MedicationStatus
			,CMI.Quantity AS Quantity
			,MD.StrengthDescription AS Strength
			,CMI.StrengthId
			,'NONE' AS NormCode
			,CM.PrescriberId
			,GC.CodeName AS Unit
			,GC1.CodeName AS Schedule
		FROM ClientMedicationInstructions CMI
		INNER JOIN ClientMedications CM ON (
				CMI.ClientMedicationId = CM.ClientMedicationId
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
			--AND cm.MedicationStartDate <= @DOS
			-- AND CMSD.EndDate > @DOS      
			AND ISNULL(cmi.Active, 'Y') = 'Y'
			AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'
			AND (
				CMSD.ClientMedicationScriptId IS NULL
				OR CMSD.ClientMedicationScriptId = LSId.ClientMedicationScriptId
				)
			AND ISNULL(CM.Discontinued,'N')  = 'N'	
		ORDER BY MDM.MedicationName
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_SCGetCurrentMedicationlist') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                                            
				16
				,-- Severity.                                                                                                            
				1 -- State.                                                                                                            
				);
	END CATCH
END

GO


