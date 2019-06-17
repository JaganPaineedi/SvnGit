IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SubReportDiscontinuedMedications]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SubReportDiscontinuedMedications]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SubReportDiscontinuedMedications] (@DocumentVersionId INT)
AS
/************************************************************************/
/* Stored Procedure: ssp_SubReportDiscontinuedMedications  3315924		 */
/* Copyright: 2017  Streamline SmartCare                            */
/* Creation Date: 06 Oct ,2017										 */
/*                                                                 */
/* Purpose: Gets Data for Self Reported Medications					 */
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
/*  Date			Author			Purpose              */
/*	17 Aug 2018		Ravi			What: added new field DiscontinuedMedication to identify which medications were discontinued
									Denton - Customizations #2  medication reconciliation document 	*/
/*	07 SEP 2018		Ravi			What: Included Other External and CCD Medication Reconciliation to  DiscontinuedMedication
									Comprehensive Customizations #6120.1 	*/
/* 12/06/2018		Shankha B			Modified to get correct Start Date as reported in (Meaningful Use - Environment Issues Tracking #  7)*/		
/* 12/02/2019	Msood			What: Added the conditions to check Discontinue Date is Not NULL and Discontinue is 'Y' for Discontinued Medication
								Why: Discontinued Medication not displayed on RDL after signing the Medication Reconciliation document 	Key Point - Support Go Live #1445 */
/* 03/05/2019	Msood			What: Removed the check for Discontinued Medication
								Why: Discontinued Medication not displayed on RDL on Save on pdf on Medication Reconciliation document 	Key Point - Support Go Live #1445 */							
/************************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @ClientId INT

		SET @ClientId = (
				SELECT TOP 1 ClientId
				FROM Documents
				WHERE CurrentDocumentVersionId = @DocumentVersionId
				)

		SELECT DISTINCT MDM.MedicationName AS MedicationName
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
			,ISNULL(MRCM.DiscontinuedMedication, 'N') AS DiscontinuedMedication
		FROM MedicationReconciliationCurrentMedications MRCM
		INNER JOIN ClientMedicationInstructions CMI ON MRCM.ClientMedicationInstructionId = CMI.ClientMedicationInstructionId
		INNER JOIN ClientMedications CM ON (
				CMI.ClientMedicationId = CM.ClientMedicationId
				AND ISNULL(cm.RecordDeleted, 'N') = 'N'
				)
		LEFT JOIN GlobalCodes GC ON (GC.GlobalCodeID = CMI.Unit)
			AND ISNULL(gc.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes GC1 ON (GC1.GlobalCodeId = CMI.Schedule)
			AND ISNULL(gc1.RecordDeleted, 'N') = 'N'
		INNER JOIN MDMedicationNames MDM ON CM.MedicationNameId = MDM.MedicationNameId
		INNER JOIN MDMedications MD ON MD.MedicationID = CMI.StrengthId
		INNER JOIN MDRoutes MR ON MD.RouteID = MR.RouteID
		INNER JOIN ClientMedicationScriptDrugs CMSD ON CMI.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId
		WHERE MRCM.DocumentVersionId = @DocumentVersionId
			AND ISNULL(MRCM.RecordDeleted, 'N') = 'N'
			-- Msood 02/12/2019
			--AND CM.discontinuedate IS NOT NULL
			--AND Isnull(CM.Discontinued, 'N') = 'Y'
			AND (isnull(CM.MedicationStartDate, Getdate()) <= GetDate())
			AND ISNULL(CMI.Active, 'Y') = 'Y'
			AND ISNULL(CMI.RecordDeleted, 'N') = 'N'
			AND ISNULL(MRCM.RecordDeleted, 'N') = 'N'
			AND ISNULL(MRCM.DiscontinuedMedication, 'N') = 'Y'
		
		UNION
		
		SELECT CASE 
				WHEN (
						MM.MedicationName <> ''
						AND MM.MedicationName IS NOT NULL
						)
					THEN MedicationName
				ELSE (
						SELECT MedicationDescription
						FROM UserDefinedMedications
						WHERE UserDefinedMedicationId = MM.UserDefinedMedicationId
						)
				END AS MedicationName
			,StrengthDescription AS Strength
			,CAST(Quantity AS VARCHAR) AS Dose
			,MedicationRoute AS [Route]
			,AdditionalInformation AS Instructions
			,CONVERT(VARCHAR(10),MedicationStartDate,101) AS StartDate
			,CONVERT(VARCHAR(10),MedicationEndDate,101) AS EndDate
			,NULL AS Prescriber
			,ISNULL(DiscontinuedMedication, 'N') AS DiscontinuedMedication
		FROM MedicationReconciliationCCDMedications MM
		WHERE DocumentVersionId = @DocumentVersionId
			AND ISNULL(MM.RecordDeleted, 'N') = 'N'
			AND ISNULL(MM.DiscontinuedMedication, 'N') = 'Y'
		UNION
		
		SELECT CASE 
				WHEN (
						MM.MedicationName <> ''
						AND MM.MedicationName IS NOT NULL
						)
					THEN MedicationName
				ELSE (
						SELECT MedicationDescription
						FROM UserDefinedMedications
						WHERE UserDefinedMedicationId = MM.UserDefinedMedicationId
						)
				END AS MedicationName
			,StrengthDescription AS Strength
			,CAST(Quantity AS VARCHAR) AS Dose
			,MedicationRoute AS [Route]
			,AdditionalInformation AS Instructions
			,CONVERT(VARCHAR(10),MedicationStartDate,101) AS StartDate
			,CONVERT(VARCHAR(10),MedicationEndDate,101) AS EndDate
			,NULL AS Prescriber
			,ISNULL(DiscontinuedMedication, 'N') AS DiscontinuedMedication
		FROM MedicationReconciliationExternalMedications MM
		WHERE DocumentVersionId = @DocumentVersionId
			AND ISNULL(MM.RecordDeleted, 'N') = 'N'
			AND ISNULL(MM.DiscontinuedMedication, 'N') = 'Y'
		ORDER BY MedicationName ASC
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SubReportDiscontinuedMedications') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****ERROR_STATE=' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error /* Message text*/
				,16 /*Severity*/
				,1 /*State*/
				)
	END CATCH
END
GO


