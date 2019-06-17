IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCPostUpdateInpatientCodingDocument]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
BEGIN
	DROP PROCEDURE ssp_SCPostUpdateInpatientCodingDocument
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCPostUpdateInpatientCodingDocument] (
	@ScreenKeyId INT
	,@StaffId INT
	,@CurrentUser VARCHAR(30)
	,@CustomParameters XML
	)
AS
/*********************************************************************/
/* Stored Procedure: [ssp_PostUpdateInpatientCodingDocument]             */
/* Date              Author                  Purpose                 */
/* 4/17/2015         Hemant kumar            what:This sp will update ClientInpatientVisits table columns AdmissionType,DischargeType,AdmissionSource why:Inpatient Coding Document #228                        */
/*********************************************************************/
/**  Change History **/                                                                         
/********************************************************************************/                                                                           
/**  Date:    Author:     Description: **/                                                                         
/**  --------  --------    ------------------------------------------- */  

BEGIN
	BEGIN TRY
		DECLARE @DocumentVersionId INT
		DECLARE @AdmitType INT
		DECLARE @AdmissionSource INT
		DECLARE @DischargeType INT
		DECLARE @InpatientVisit VARCHAR(Max)

		SELECT TOP 1 @DocumentVersionId = InProgressDocumentVersionId
		FROM Documents
		WHERE DocumentId = @ScreenKeyId
			AND Isnull(RecordDeleted, 'N') = 'N'

		SET @AdmitType = (
				SELECT AdmitType
				FROM InpatientCodingDocuments
				WHERE DocumentVersionId = @DocumentVersionId
				)
		SET @AdmissionSource = (
				SELECT AdmissionSource
				FROM InpatientCodingDocuments
				WHERE DocumentVersionId = @DocumentVersionId
				)
		SET @DischargeType = (
				SELECT DischargeType
				FROM InpatientCodingDocuments
				WHERE DocumentVersionId = @DocumentVersionId
				)
		SET @InpatientVisit = (
				SELECT ClientInpatientVisitId
				FROM InpatientCodingDocuments
				WHERE DocumentVersionId = @DocumentVersionId
				)

		UPDATE ClientInpatientVisits
		SET AdmissionType = @AdmitType
			,DischargeType = @DischargeType
			,AdmissionSource = @AdmissionSource
		WHERE ClientInpatientVisitId = @InpatientVisit
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(max)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_PostUpdateInpatientCodingDocument') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,
				-- Message text.                                                                                 
				16
				,
				-- Severity.                                                                                 
				1
				-- State.                                                                                 
				);
	END CATCH
END