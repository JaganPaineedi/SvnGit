IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetClientMedications]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetClientMedications]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetClientMedications] --215,'n'
	@ClientId INT
	,@DocumentId INT
AS
/*********************************************************************/
/* Stored Procedure: ssp_GetClientMedications  215               */
/* Creation Date:  21/August/2017                                    */
/* Author : Arjun K R                                                */
/* Purpose: To Get Medication Reconciliation                         */
/* Input Parameters: @DocumentVersionId                              */
/* Output Parameters:                                                */
/* Return:                                                           */
/* Data Modifications:                                               */
/* Updates:                                                          */
/* Date              Author                  Purpose                 */
/* 17/08/2018       Arjun K R          Modified select query to pull IsSelect=Y for discontinued medications For task #2 Denton Customizations*/
/* 12/06/2018		Shankha B			Modified to get correct Start Date as reported in (Meaningful Use - Environment Issues Tracking # 7)*/
/*********************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @DocumentVersionId INT

		SET @DocumentVersionId = (
				SELECT TOP 1 ISNULL(DV.DocumentVersionId, 0)
				FROM Documents D
				INNER JOIN DocumentVersions DV ON D.CurrentDocumentVersionId = DV.DocumentVersionId
				INNER JOIN MedicationReconciliationCurrentMedications MRCM ON MRCM.DocumentVersionId = DV.DocumentVersionId
				WHERE ISNULL(D.RecordDeleted, 'N') = 'N'
					AND ISNULL(DV.RecordDeleted, 'N') = 'N'
					AND ISNULL(MRCM.RecordDeleted, 'N') = 'N'
					AND D.DocumentId = @DocumentId
				)

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

		SELECT DISTINCT CMI.ClientMedicationInstructionId
			,CM.CreatedBy
			,CM.CreatedDate
			,CM.ModifiedBy
			,CM.ModifiedDate
			,CM.RecordDeleted
			,CM.DeletedBy
			,CM.DeletedDate
			,CM.ClientId
			,ISNULL(CM.Ordered, 'N') AS Ordered
			,MDM.MedicationName AS MedicationName
			,MD.Strength + ' ' + MD.StrengthUnitOfMeasure AS Strength
			,cast(CMI.Quantity AS VARCHAR) + '  ' + dbo.ssf_GetGlobalCodeNameById(CMI.Unit) AS Dose
			,MR.RouteDescription AS [Route]
			,CASE 
				WHEN (cm.IncludeCommentOnPrescription = 'Y')
					THEN COALESCE(dbo.ssf_GetMedicationInstruction(CMI.ClientMedicationInstructionId) + ', ', '') + isnull(cm.comments, '')
				ELSE dbo.ssf_GetMedicationInstruction(CMI.ClientMedicationInstructionId)
				END AS Instructions
			,ISNULL(CONVERT(VARCHAR(10), CMSD.StartDate, 101), '') AS StrartDate
			,ISNULL(CONVERT(VARCHAR(10), CMSD.EndDate, 101), '') AS EndDate
			,CM.PrescriberName AS Prescriber
			-- ,CASE WHEN (ISNULL(MRCM.MedicationReconciliationCurrentMedicationId,0)<>0 and ISNULL(MRCM.RecordDeleted,'N')='N') THEN 'Y' WHEN MRCM.DocumentVersionId<>@DocumentVersionId THEN 'N' END AS IsSelected
			,CASE 
				WHEN ISNULL(MRCM.DiscontinuedMedication, 'Y') = 'N'
					THEN 'Y'
				ELSE 'N'
				END AS IsSelected
			,CASE 
				WHEN ISNULL(CM.UserDefinedMedicationNameId, 0) <> 0
					THEN 'Y'
				ELSE 'N'
				END AS Other
		FROM ClientMedicationInstructions CMI
		LEFT JOIN [MedicationReconciliationCurrentMedications] MRCM ON MRCM.ClientMedicationInstructionId = CMI.ClientMedicationInstructionId
			AND MRCM.DocumentVersionId = @DocumentVersionId
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
				AND ISNULL(MD.RecordDeleted, 'N') <> 'Y'
				)
		INNER JOIN MDRoutes MR ON (
				MD.RouteID = MR.RouteID
				AND ISNULL(MR.RecordDeleted, 'N') <> 'Y'
				)
		LEFT JOIN ClientMedicationScriptDrugs CMSD ON (
				CMI.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId
				AND ISNULL(CMSD.RecordDeleted, 'N') <> 'Y'
				)
		LEFT JOIN @LastScriptIdTable LSId ON (
				cmi.ClientMedicationInstructionId = LSId.ClientMedicationInstructionId
				AND cmsd.ClientMedicationScriptId = LSId.ClientMedicationScriptId
				)
		LEFT JOIN dbo.ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = LSId.ClientMedicationScriptId
		WHERE cm.ClientId = @ClientId
			AND cm.discontinuedate IS NULL
			AND Isnull(Discontinued, 'N') <> 'Y'
			AND (isnull(cm.MedicationStartDate, Getdate()) <= GetDate())
			AND ISNULL(cmi.Active, 'Y') = 'Y'
			AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'
			AND (
				CMSD.ClientMedicationScriptId IS NULL
				OR CMSD.ClientMedicationScriptId = LSId.ClientMedicationScriptId
				)
		--AND ((CM.Ordered='Y' AND @MedicationType='P') OR (CM.Ordered='N' AND @MedicationType='S'))   
		ORDER BY MDM.MedicationName
	END TRY

	BEGIN CATCH
		IF (@@error != 0)
		BEGIN
			RAISERROR (
					'ssp_GetClientMedications: An Error Occured'
					,16
					,1
					)

			RETURN
		END
	END CATCH
END
GO

