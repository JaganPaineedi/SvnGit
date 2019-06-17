IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLScanOrUploadServiceDocuments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLScanOrUploadServiceDocuments]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[ssp_RDLScanOrUploadServiceDocuments] (@DocumentVersionId INT)
AS
/****************************************************************************************/
/* Stored Procedure: ssp_RDLScanOrUploadServiceDocuments								*/
/* Creation Date:  18 JAN 2017															*/
/* Purpose: To display "Scanned/Uploaded by Logged-in staff on behalf of External Staff"*/ 
/* Input Parameters: @DocumentVersionId													*/
/* Author: Akwinass																		*/
/****************************************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @DocumentId INT
		DECLARE @ServiceId INT
		DECLARE @AttachmentComments VARCHAR(MAX)
		DECLARE @ClinicianId INT

		SELECT TOP 1 @DocumentId = DocumentId
		FROM DocumentSignatures
		WHERE SignedDocumentVersionId = @DocumentVersionId
		
		SELECT TOP 1 @ServiceId = ServiceId
		FROM Documents
		WHERE DocumentId = @DocumentId
			AND ISNULL(RecordDeleted, 'N') = 'N'

		SELECT TOP 1 @AttachmentComments = AttachmentComments
			,@ClinicianId = ClinicianId
		FROM Services
		WHERE ServiceId = @ServiceId
			AND ISNULL(RecordDeleted, 'N') = 'N'
			
		DECLARE @ScannedUploadedBy VARCHAR(MAX)	
		DECLARE @ClinicianName VARCHAR(MAX)
		SELECT TOP 1 @ClinicianName = LastName +', '+ FirstName FROM Staff WHERE StaffId = @ClinicianId
		
		IF ISNULL(@AttachmentComments, '') <> ''
		BEGIN			
			DECLARE @OnBehalfOf VARCHAR(500)
			DECLARE @CheckIndex INT
			SET @CheckIndex = CHARINDEX('on behalf of', @AttachmentComments)
			
			IF ISNULL(@CheckIndex, 0) > 0
			BEGIN
				SET @OnBehalfOf = SUBSTRING(@AttachmentComments, @CheckIndex + 12 , LEN(@AttachmentComments))
				SET @ScannedUploadedBy = SUBSTRING(@AttachmentComments, 0, @CheckIndex)
			END
			ELSE
			BEGIN
				SET @ScannedUploadedBy = @AttachmentComments
			END

			IF ISNULL(@ScannedUploadedBy, '') <> '' AND ISNULL(@OnBehalfOf,'') <> ''
			BEGIN
				SET @AttachmentComments = @ScannedUploadedBy + ' on behalf of ' + @OnBehalfOf
			END
			ELSE IF ISNULL(@ScannedUploadedBy, '') <> '' AND ISNULL(@OnBehalfOf,'') = ''
			BEGIN
				SET @AttachmentComments = @ScannedUploadedBy
			END
		END
		
		IF ISNULL(@AttachmentComments, '') = ''
		BEGIN
			SELECT @ScannedUploadedBy = COALESCE(@ScannedUploadedBy + ' & ', ' ') + (LastName + ', ' + FirstName)
			FROM Staff
			WHERE UserCode IN (
					SELECT ModifiedBy
					FROM ImageRecords
					WHERE ISNULL(RecordDeleted, 'N') = 'N'
						AND ServiceId = @ServiceId
					)
				AND ISNULL(RecordDeleted, 'N') = 'N'
			
			IF RTRIM(LTRIM(@ScannedUploadedBy)) <> RTRIM(LTRIM(@ClinicianName))
				SET @AttachmentComments = 'Scanned/Uploaded by ' + @ScannedUploadedBy + ' on behalf of ' + @ClinicianName
			ELSE 
				SET @AttachmentComments = 'Scanned/Uploaded by ' + @ScannedUploadedBy
		END
		
		
		SELECT @AttachmentComments AS AttachmentComments
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLScanOrUploadServiceDocuments') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


