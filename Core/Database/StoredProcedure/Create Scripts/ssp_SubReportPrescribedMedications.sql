IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SubReportPrescribedMedications]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SubReportPrescribedMedications]
GO

SET ANSI_NULLS ON
GO

/****** Object:  StoredProcedure [dbo].[ssp_SubReportPrescribedMedications]    Script Date: 06-12-2018 16:18:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SubReportPrescribedMedications] (@DocumentVersionId INT)
AS
/************************************************************************/
/* Stored Procedure: ssp_SubReportPrescribedMedications  3315924		 */
/* Copyright: 2017  Streamline SmartCare                            */
/* Creation Date: 06 Oct ,2017										 */
/*                                                                 */
/* Purpose: Gets Data for Prescribed Medications						 */
/*                                                                 */
/* Input Parameters: @DocumentVersionId                            */
/*                                                                 */
/* Output Parameters:                                              */
/* Purpose: Use For Rdl Report                                     */
/* Call By:                                                        */
/* Calls:                                                          */
/*                                                                 */
/* Author: Alok Kumar                                      */
/* What : created Report for  Medication Reconciliation     */
/* why : Meaningful Use - Stage 3 : #26.1                        */
/* Date              Author                  Purpose                 */
/* 14/5/2017	      Anto				 Modified the logic as it in intalization to avoid duplicate values in the RDL - Aspen Point Build Cycle Tasks #81.1 */
/* 17/8/2018		Ravi			What: added new field DiscontinuedMedication to identify which medications were discontinued
									Denton - Customizations #2  medication reconciliation document 	*/
/* 12/06/2018		Shankha B			Modified to get correct Start Date as reported in (Meaningful Use - Environment Issues Tracking#  7)*/
/************************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @ClientId INT

		SET @ClientId = (
				SELECT TOP 1 ClientId
				FROM Documents
				WHERE CurrentDocumentVersionId = @DocumentVersionId
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
			,MDM.MedicationName AS MedicationName
			,MD.Strength + ' ' + MD.StrengthUnitOfMeasure AS Strength
			,cast(CMI.Quantity AS VARCHAR) + '  ' + dbo.ssf_GetGlobalCodeNameById(CMI.Unit) AS Dose
			,MR.RouteDescription AS [Route]
			,CASE 
				WHEN (CM.IncludeCommentOnPrescription = 'Y')
					THEN COALESCE(dbo.ssf_GetMedicationInstruction(CMI.ClientMedicationInstructionId) + ', ', '') + isnull(cm.comments, '')
				ELSE dbo.ssf_GetMedicationInstruction(CMI.ClientMedicationInstructionId)
				END AS Instructions
			,ISNULL(CONVERT(VARCHAR(10), CMSD.StartDate, 101), '') AS StrartDate
			,ISNULL(CONVERT(VARCHAR(10), CMSD.EndDate, 101), '') AS EndDate
			,CM.PrescriberName AS Prescriber
			,ISNULL(MRCM.DiscontinuedMedication, 'N') AS DiscontinuedMedication
		FROM ClientMedicationInstructions CMI
		LEFT JOIN [MedicationReconciliationCurrentMedications] MRCM ON MRCM.ClientMedicationInstructionId = CMI.ClientMedicationInstructionId
			AND MRCM.DocumentVersionId = @DocumentVersionId
		INNER JOIN ClientMedications CM ON (
				CMI.ClientMedicationId = CM.ClientMedicationId
				AND ISNULL(cm.RecordDeleted, 'N') = 'N'
				)
		LEFT JOIN GlobalCodes GC ON (GC.GlobalCodeID = CMI.Unit)
		LEFT JOIN GlobalCodes GC1 ON (GC1.GlobalCodeId = CMI.Schedule)
		INNER JOIN MDMedicationNames MDM ON (CM.MedicationNameId = MDM.MedicationNameId)
		INNER JOIN MDMedications MD ON (MD.MedicationID = CMI.StrengthId)
		INNER JOIN MDRoutes MR ON (MD.RouteID = MR.RouteID)
		LEFT JOIN ClientMedicationScriptDrugs CMSD ON (
				CMI.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId
				AND ISNULL(CMSD.RecordDeleted, 'N') = 'N'
				)
		LEFT JOIN @LastScriptIdTable LSId ON (
				cmi.ClientMedicationInstructionId = LSId.ClientMedicationInstructionId
				AND cmsd.ClientMedicationScriptId = LSId.ClientMedicationScriptId
				)
		LEFT JOIN dbo.ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = LSId.ClientMedicationScriptId
		WHERE cm.ClientId = @ClientId
			AND cm.discontinuedate IS NULL
			AND Isnull(Discontinued, 'N') = 'N'
			AND (isnull(cm.MedicationStartDate, Getdate()) <= GetDate())
			AND ISNULL(cmi.Active, 'Y') = 'Y'
			AND ISNULL(cmi.RecordDeleted, 'N') = 'N'
			AND ISNULL(MRCM.DiscontinuedMedication, 'N') = 'N'
			AND ISNULL(MRCM.MedicationType, '') = 'P'
			AND (
				CMSD.ClientMedicationScriptId IS NULL
				OR CMSD.ClientMedicationScriptId = LSId.ClientMedicationScriptId
				)
		ORDER BY MDM.MedicationName
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SubReportPrescribedMedications') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****ERROR_STATE=' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error /* Message text*/
				,16 /*Severity*/
				,1 /*State*/
				)
	END CATCH
END
GO


