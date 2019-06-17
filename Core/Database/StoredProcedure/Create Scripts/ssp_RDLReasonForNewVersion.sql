/****** Object:  StoredProcedure [dbo].[ssp_RDLReasonForNewVersion]    Script Date: 01/03/2017 17:04:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLReasonForNewVersion]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLReasonForNewVersion]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLReasonForNewVersion]    Script Date: 01/03/2017 17:04:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_RDLReasonForNewVersion]
	(@DocumentVersionId INT)
AS
/*************************************************************************/
/* Stored Procedure: ssp_RDLReasonForNewVersion                          */
/* Creation Date:  18 JAN 2017                                           */
/* Purpose: Gets Data for Reason For New Version                         */
/* Input Parameters: @DocumentVersionId                                  */
/* Author: Akwinass                                                      */
/*************************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @DocumentId INT

		SELECT TOP 1 @DocumentId = DocumentId
		FROM DocumentSignatures
		WHERE SignedDocumentVersionId = @DocumentVersionId
			AND ISNULL(RecordDeleted, 'N') = 'N'

		IF ISNULL(@DocumentId, 0) <= 0
		BEGIN
			SELECT TOP 1 @DocumentId = DocumentId
			FROM Documents
			WHERE CurrentDocumentVersionId = @DocumentVersionId
				AND ISNULL(RecordDeleted, 'N') = 'N'
		END

		IF ISNULL(@DocumentId, 0) <= 0
		BEGIN
			SELECT TOP 1 @DocumentId = DocumentId
			FROM Documents
			WHERE InProgressDocumentVersionId = @DocumentVersionId
				AND ISNULL(RecordDeleted, 'N') = 'N'
		END
		
		DECLARE @Version INT
		SELECT TOP 1 @Version = [Version]
		FROM DocumentVersions
		WHERE ISNULL(RecordDeleted, 'N') = 'N'
			AND DocumentVersionId = @DocumentVersionId
		
		DECLARE @Value VARCHAR(10)

		SELECT TOP 1 @Value = Value
		FROM SystemConfigurationKeys
		WHERE [Key] = 'SHOWREASONFORNEWVERSIONRDL'
			AND ISNULL(RecordDeleted, 'N') = 'N'

		SET @Value = ISNULL(@Value, 'N')
		
		IF @Value = 'Y'
		BEGIN
			SELECT DocumentVersionId
				,DocumentId
				,[Version]
				,AuthorId
				,CASE 
					WHEN EffectiveDate IS NOT NULL
						THEN CONVERT(VARCHAR(10), EffectiveDate, 101)
					ELSE ''
					END EffectiveDate
				,DocumentChanges
				,ReasonForChanges
				,RevisionNumber
				,RefreshView
				,ReasonForNewVersion
			FROM DocumentVersions
			WHERE DocumentId = @DocumentId
				AND ISNULL(RecordDeleted, 'N') = 'N'
				AND ISNULL(ReasonForNewVersion, '') <> ''
				AND [Version] <= @Version
			ORDER BY [Version] DESC
		END
		ELSE
		BEGIN
			SELECT TOP 0 DocumentVersionId
				,DocumentId
				,[Version]
				,AuthorId
				,CASE 
					WHEN EffectiveDate IS NOT NULL
						THEN CONVERT(VARCHAR(10), EffectiveDate, 101)
					ELSE ''
					END EffectiveDate
				,DocumentChanges
				,ReasonForChanges
				,RevisionNumber
				,RefreshView
				,ReasonForNewVersion
			FROM DocumentVersions
			WHERE DocumentId = @DocumentId
				AND ISNULL(RecordDeleted, 'N') = 'N'
				AND ISNULL(ReasonForNewVersion, '') <> ''
				AND [Version] <= @Version
			ORDER BY [Version] DESC
		END	
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLReasonForNewVersion') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


