/****** Object:  StoredProcedure [dbo].[csp_PostSignatureUpdateASAMs]    Script Date: 12/08/2014 12:45:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PostSignatureUpdateASAMs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PostSignatureUpdateASAMs]
GO

/****** Object:  StoredProcedure [dbo].[csp_PostSignatureUpdateASAMs]    Script Date: 12/08/2014 12:45:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_PostSignatureUpdateASAMs] (@DocumentVersionId INT)
AS
/******************************************************************************* 
 * Stored Procedure: [csp_PostSignatureUpdateASAMs]
 * Creation Date:  08/DEC/2014
 * Purpose: To Initialize
 * Called By: ASAM Post signature updates
 * Calls:                                
 *                                       
 * Data Modifications:                   
 *   Updates:                            
 *  08/DEC/2014 	Akwinass.D		Post update SP for ASAM Document
 *	25/MAR/2015		G Sanborn		Add ClientId to test for existing ToDo doc. 
 *******************************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @ClientId INT
		DECLARE @ToDoDocumentId INT
		DECLARE @CurrentUserId VARCHAR(20)
		DECLARE @CurrentUserCode VARCHAR(20)
		DECLARE @AssignedTo INT
		DECLARE @ToDoEffectiveDate DATETIME
		DECLARE @ToDoDueDate DATETIME
		DECLARE @DocumentCodeId INT
		DECLARE @EffectiveDate DATETIME
		DECLARE @ToDoDocumentVersionId INT
		DECLARE @DocumentId INT
		DECLARE @SignerCount INT

		SELECT TOP 1 @ClientId = ClientId
			,@EffectiveDate = EffectiveDate
			,@DocumentCodeId = DocumentCodeId
			,@AssignedTo = AuthorId
			,@DocumentId = DocumentId
		FROM Documents
		WHERE CurrentDocumentVersionid = @DocumentVersionId
		
		SELECT @SignerCount = COUNT(1)
		FROM DocumentSignatures ds
		WHERE ds.DocumentId = @DocumentId
			AND ds.SignatureDate IS NOT NULL
			AND ISNULL(ds.RecordDeleted, 'N') = 'N'

		IF @SignerCount = 1
		BEGIN
			IF (SELECT TOP 1 PrimaryClinicianId FROM Clients WHERE ClientId = @ClientId) IS NOT NULL
			BEGIN
				SELECT TOP 1 @AssignedTo = PrimaryClinicianId
				FROM Clients
				WHERE ClientId = @ClientId
			END

			DECLARE @ProvidedLevel VARCHAR(250)
			DECLARE @Level DECIMAL(10, 4)

			SELECT TOP 1 @ProvidedLevel = GC.CodeName
			FROM CustomDocumentASAMs ASAM
			JOIN GlobalCodes GC ON ASAM.ProvidedLevel = GC.GlobalCodeId
			WHERE DocumentVersionId = @DocumentVersionId
				AND isnull(ASAM.RecordDeleted, 'N') = 'N'

			SET @ProvidedLevel = ISNULL(@ProvidedLevel, '')

			IF (@ProvidedLevel != '')
			BEGIN
				SELECT TOP 1 @ProvidedLevel = Token
				FROM dbo.SplitString(@ProvidedLevel, ' ')
				ORDER BY Position DESC

				SET @ProvidedLevel = ISNULL(@ProvidedLevel, '0.0')

				BEGIN TRY
					SET @Level = CAST(@ProvidedLevel AS DECIMAL(10, 4))
				END TRY
				BEGIN CATCH
					SET @Level = 0.0
				END CATCH
					
				IF @Level = 3.5000
				BEGIN
					SET @ToDoEffectiveDate = (SELECT DATEADD(day, 7, @EffectiveDate))
					SET @ToDoDueDate = (SELECT DATEADD(day, 14, @EffectiveDate))
				END
				ELSE IF @Level = 3.1000 OR @Level = 2.1000
				BEGIN
					SET @ToDoEffectiveDate = (SELECT DATEADD(day, 23, @EffectiveDate))
					SET @ToDoDueDate = (SELECT DATEADD(day, 30, @EffectiveDate))
				END
				ELSE IF @Level < 2.1000
				BEGIN
					SET @ToDoEffectiveDate = (SELECT DATEADD(day, 53, @EffectiveDate))
					SET @ToDoDueDate = (SELECT DATEADD(day, 60, @EffectiveDate))
				END
			END

			IF @ToDoEffectiveDate IS NOT NULL AND @ToDoDueDate IS NOT NULL
			BEGIN
				IF NOT EXISTS (
						SELECT DocumentId
						FROM Documents
						WHERE [Status] = 20
							AND ClientId = @ClientId							-- 03/25/15 gs
							AND DocumentCodeId = @DocumentCodeId				-- 03/25/15 gs
							AND CAST(EffectiveDate AS DATE) = CAST(@ToDoEffectiveDate AS DATE)
						)
				BEGIN
					INSERT INTO Documents (
						ClientId
						,DocumentCodeId
						,EffectiveDate
						,DueDate
						,[Status]
						,AuthorId
						,DocumentShared
						,SignedByAuthor
						,SignedByAll
						,ToSign
						,CurrentVersionStatus
						,CreatedBy
						,CreatedDate
						,ModifiedBy
						,ModifiedDate
						)
					VALUES (
						@ClientId
						,@DocumentCodeId
						,CONVERT(DATE, @ToDoEffectiveDate, 101)
						,CONVERT(DATE, @ToDoDueDate, 101)
						,20
						,@AssignedTo
						,'Y'
						,'N'
						,'N'
						,NULL
						,20
						,'SYSTEM'
						,GETDATE()
						,'SYSTEM'
						,GETDATE()
						)

					SET @ToDoDocumentId = @@IDENTITY

					-- Insert new document version  
					INSERT INTO DocumentVersions (
						DocumentId
						,Version
						,CreatedBy
						,CreatedDate
						,ModifiedBy
						,ModifiedDate
						)
					VALUES (
						@ToDoDocumentId
						,1
						,'SYSTEM'
						,GETDATE()
						,'SYSTEM'
						,GETDATE()
						)

					SET @ToDoDocumentVersionId = @@IDENTITY

					-- Insert new CustomDocumentReleaseOfInformations   
					INSERT INTO CustomDocumentASAMs (
						DocumentVersionId
						,ModifiedDate
						,CreatedBy
						,CreatedDate
						,ModifiedBy
						)
					VALUES (
						@ToDoDocumentVersionId
						,GETDATE()
						,'SYSTEM'
						,GETDATE()
						,'SYSTEM'
						)

					-- Set document current and in progress document version id to newly created document version id  
					UPDATE d
					SET CurrentDocumentVersionId = @ToDoDocumentVersionId
						,InProgressDocumentVersionId = @ToDoDocumentVersionId
					FROM Documents d
					WHERE d.DocumentId = @ToDoDocumentId
				END
			END
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + 
					 '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + 
					 '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_InitCustomRegistrations') + 
					 '*****' + Convert(VARCHAR, ERROR_LINE()) + 
					 '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + 
					 '*****' + Convert(VARCHAR, ERROR_STATE())

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


