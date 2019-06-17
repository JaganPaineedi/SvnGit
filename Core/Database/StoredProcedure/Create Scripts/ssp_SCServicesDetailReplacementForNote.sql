IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCServicesDetailReplacementForNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCServicesDetailReplacementForNote]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- ============================================================================================================================   
-- Author      : Akwinass.D 
-- Date        : 09/MAR/2018
-- Purpose     : To update respective tables for "Replacement for Note" image records. 
-- Updates:
-- Date			Author    Purpose 
-- 09/MAR/2018  Akwinass  Created.(Task #589.1 in Engineering Improvement Initiatives- NBL(I)) */
-- ============================================================================================================================
CREATE PROCEDURE [dbo].[ssp_SCServicesDetailReplacementForNote] @ServiceId INT,@StaffId INT,@CurrentUser VARCHAR(30)
AS
BEGIN
	BEGIN TRY
		DECLARE @ServiceStatus INT		
		DECLARE @NoteReplacement CHAR(1)
		DECLARE @Versions INT
		DECLARE @AuthorId INT
		DECLARE @ProcedureCodeId INT
		DECLARE @AssociatedNoteId INT
		
		SELECT TOP 1 @ServiceStatus = [Status]
			,@NoteReplacement = NoteReplacement
			,@ProcedureCodeId = ProcedureCodeId
			,@AuthorId = ClinicianId
		FROM Services
		WHERE ServiceId = @ServiceId
		
		SELECT @AssociatedNoteId = AssociatedNoteId
		FROM ProcedureCodes
		WHERE ProcedureCodeId = @ProcedureCodeId
			AND ISNULL(RecordDeleted, 'N') = 'N'
		
		SELECT @Versions = COUNT(1)
		FROM DocumentVersions
		WHERE DocumentId IN (SELECT DocumentId FROM Documents WHERE ServiceId = @ServiceId AND ISNULL(RecordDeleted, 'N') = 'N')
			AND ISNULL(RecordDeleted, 'N') = 'N'
		
		IF (ISNULL(@ServiceStatus,0) = 71 OR ISNULL(@ServiceStatus,0) = 75) AND ISNULL(@NoteReplacement,'N') = 'Y'
			AND EXISTS(SELECT 1 FROM ImageRecords WHERE ServiceId =  @ServiceId AND ISNULL(RecordDeleted, 'N') = 'N')
			AND ISNULL(@Versions,0) = 1
			AND ISNULL(@AssociatedNoteId, 0) > 0
		BEGIN
			UPDATE D
			SET D.[Status] = 22
				,D.DocumentShared = 'Y'
				,D.SignedByAuthor = 'Y'
				,D.CurrentVersionStatus = 22
				,ModifiedBy = @CurrentUser
				,ModifiedDate = GETDATE()
			FROM Documents D
			WHERE ServiceId = @ServiceId
				AND ISNULL(RecordDeleted, 'N') = 'N'
				AND D.CurrentVersionStatus <> 22				
			
			DECLARE @StaffName VARCHAR(MAX)
			DECLARE @AuthorName VARCHAR(MAX)
			SELECT TOP 1 @StaffName = LastName +', '+ FirstName FROM Staff WHERE StaffId = @StaffId
			SELECT TOP 1 @AuthorName = LastName +', '+ FirstName FROM Staff WHERE StaffId = @AuthorId
				
			UPDATE DocumentSignatures
			SET SignedDocumentVersionId = D.InProgressDocumentVersionId
				,SignerName = @AuthorName
				,SignatureDate = GETDATE()
				,VerificationMode = 'P'
				,ClientSignedPaper = 'N'
				,RevisionNumber = 1
				,ModifiedBy = @CurrentUser
				,ModifiedDate = GETDATE()
			FROM DocumentSignatures DS
			JOIN Documents D ON D.DocumentId = DS.DocumentId
			WHERE D.ServiceId = @ServiceId
				AND DS.SignatureOrder = 1
				AND ISNULL(DS.RecordDeleted, 'N') = 'N'
				AND ISNULL(D.RecordDeleted, 'N') = 'N' 
				AND SignedDocumentVersionId IS NULL
				
			--DECLARE @AttachmentComments VARCHAR(MAX)
			--SET @AttachmentComments = 'Scanned/Uploaded by ' + @StaffName + ' '
			--IF ISNULL(@StaffName, '') <> ISNULL(@AuthorName, '') AND ISNULL(@StaffName, '') <> '' AND ISNULL(@AuthorName, '') <> ''
			--BEGIN
			--	SET @AttachmentComments = @AttachmentComments + 'on behalf of ' + @AuthorName
			--END
			
			--UPDATE Services
			--SET AttachmentComments = @AttachmentComments
			--WHERE ServiceId = @ServiceId
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCServicesDetailReplacementForNote') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


