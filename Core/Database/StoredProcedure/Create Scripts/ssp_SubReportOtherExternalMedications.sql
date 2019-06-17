IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SubReportOtherExternalMedications]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SubReportOtherExternalMedications]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SubReportOtherExternalMedications] (@DocumentVersionId INT)
AS
/***********************************s*************************************/
/* Stored Procedure: ssp_SubReportOtherExternalMedications  3315941		 */
/* Copyright: 2017  Streamline SmartCare                            */
/* Creation Date: 07 Oct ,2017										 */
/*                                                                 */
/* Purpose: Gets Data for CCD Medications					 */
/*                                                                 */
/* Input Parameters: @DocumentVersionId                            */
/*                                                                 */
/* Output Parameters:                                              */
/* Purpose: Use For Rdl Report                                     */
/* Call By:                                                        */
/* Calls:                                                          */
/*                                                                 */
/* Author: Ravir                                      */
/* What : created Report for  Other External Medication Reconciliation     */
/* why : Meaningful Use - Stage 3 : #26.1                        */
/*  Date			Author			Purpose              */
/*	07 SEP 2018		Ravi			What: Report for  Other External Medication Reconciliation
									Comprehensive Customizations #6120.1  	*/
/************************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @ClientId INT

		SET @ClientId = (
				SELECT TOP 1 ClientId
				FROM Documents
				WHERE CurrentDocumentVersionId = @DocumentVersionId
				)

		DECLARE @Reconciliation VARCHAR(max)

		SET @Reconciliation = (
				SELECT TOP 1 'HIE' + ' - ' + convert(VARCHAR(10), p.ResponseDateTime, 101)
				FROM PMPAuditTrails p
				WHERE p.ClientId = @ClientId
					AND P.RequestType = 'X'
					AND p.PMPConnectionStatus = 'PASSED REQUEST'
					AND p.ResponseMessageXML IS NOT NULL
					AND ISNULL(p.RecordDeleted, 'N') = 'N'
				ORDER BY p.ResponseDateTime DESC
				)
	
		SELECT MedicationReconciliationExternalMedicationId
			,DocumentVersionId
			,CASE 
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
			,Quantity AS Dose
			,StrengthDescription AS Strength
			,MedicationRoute
			,CONVERT(VARCHAR(10),MedicationStartDate,101) AS MedicationStartDate
			,CONVERT(VARCHAR(10),MedicationEndDate,101) AS MedicationEndDate
			,AdditionalInformation AS Instructions
			,@Reconciliation AS Reconciliation
			,DiscontinuedMedication
		FROM MedicationReconciliationExternalMedications MM
		WHERE DocumentVersionId = @DocumentVersionId
			AND ISNULL(MM.RecordDeleted, 'N') = 'N'
			AND ISNULL(MM.DiscontinuedMedication, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SubReportOtherExternalMedications') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****ERROR_STATE=' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error /* Message text*/
				,16 /*Severity*/
				,1 /*State*/
				)
	END CATCH
END
GO


