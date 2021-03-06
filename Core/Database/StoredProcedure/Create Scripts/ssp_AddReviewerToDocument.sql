/****** Object:  StoredProcedure [dbo].[ssp_AddReviewerToDocument]    Script Date: 02/09/2016 12:39:46 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_AddReviewerToDocument]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_AddReviewerToDocument]
GO

/****** Object:  StoredProcedure [dbo].[ssp_AddReviewerToDocument]    Script Date: 02/09/2016 12:39:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_AddReviewerToDocument] (
	@ReviewerId INT
	,@DocumentId INT	
	,@ClientSignedPaper VARCHAR(1)
	,@MultipleDocumentId VARCHAR(MAX) = NULL
	)
	/********************************************************************/
	/* Stored Procedure: dbo.ssp_SCGetClientOrdersDetails				*/
	/* Creation Date:  05 Aug,2011                                      */
	/*                                                                  */
	/* Purpose: To Add a Reviewer to a document, Insert a row in DOcumentSignatues for Reviewer */
	/*                                                                  */
	/* Input Parameters: @ReviewerId, @DocumentId         */
	/*                                                                  */
	/* Output Parameters:												*/
	/*                                                                  */
	/*  Date                  Author                 Purpose			*/
	/* 05 Aug,2011             Shifali				 Created			*/
	/* 13 Sep,2011             Shifali				 Modified as per SHS team response(Marking a document as 'To be Reviewed' should automatically share the document.)*/
	/* 28 Sep,2011             Shifali				 Modified as per SHS response(we donot need to set SignedDocumentVersionId while Adding a Revieiwer,it will set on explicit Sign.)*/
	/*29Sept2011			   Shifali		         Removed condition "AND DS.SignedDocumentVersionId = @DocumentVersionId" from SP While inserting a row in DOcumentSignatures table as per SHS team response/issue reported by QA(ReviewerDuplicacy in DocumentSignatures)*/
	/* 10 FEB 2016             Akwinass              Included @MultipleDocumentID for GroupServices (Task #124 in MFS - Customization Issue Tracking)*/
	/*13 Nov 2018 Chita Ranjan		 What:Added condition to Update the VerificationMode column in DocumentSignatures table dynamically based on selection in Signature Popup*/
    /*                      		 Why: PEP - Customizations #10212*/
	/********************************************************************/
AS
BEGIN
	BEGIN TRY
		/*--UPDATE Documents
		--SET ReviewerId = @ReviewerId,
		--Status = 25 -- To Be Reviewed Status GlobalCodeId
		--WHERE DocumentId=@DocumentId
					
		 --INSERT INTO DocumentSignatures            
		 --(DocumentId,SignedDocumentVersionId,StaffId,SignatureOrder,CreatedBy,CreatedDate,ModifiedBy,RevisionNumber)            
			--select  @DocumentId,D.CurrentDocumentVersionId,@ReviewerId,1,S.UserCode,GETDATE(),S.UserCode,DV.RevisionNumber            
			--from Documents D 
			--LEFT Join DocumentVersions DV on D.CurrentDocumentVersionId = DV.DocumentVersionId and isNull(DV.RecordDeleted,'N')<>'Y'  		 
			--LEFT Join Staff S on S.StaffId = D.AuthorId
			--where D.DocumentId=@DocumentId  and isNull(D.RecordDeleted,'N')<>'Y' */
		DECLARE @DocumentVersionId INT
		DECLARE @AuthorId INT
		DECLARE @UserCode VARCHAR(30)
		DECLARE @FirstName VARCHAR(100)
		DECLARE @LastName VARCHAR(100)
		DECLARE @SigningSuffix VARCHAR(100)
		DECLARE @VerificationMode VARCHAR(1) = 'P'  --Chita Ranjan 13/11/2018
		IF (@ClientSignedPaper = 'V')
	    BEGIN
	    SET @VerificationMode = 'V'
	    SET @ClientSignedPaper='N'
	    END
		-- 10 FEB 2016 Akwinass
		IF OBJECT_ID('tempdb..#MultipleDocuments') IS NOT NULL
			DROP TABLE #MultipleDocuments

		CREATE TABLE #MultipleDocuments (DocumentId INT)

		IF ISNULL(@DocumentId, 0) > 0
		BEGIN
			INSERT INTO #MultipleDocuments (DocumentId)
			VALUES (@DocumentId)
		END
		ELSE IF ISNULL(@DocumentId, 0) = 0 AND ISNULL(@MultipleDocumentID, '') <> ''
		BEGIN
			INSERT INTO #MultipleDocuments (DocumentId)
			SELECT D.DocumentId
			FROM Documents D
			WHERE EXISTS (SELECT 1 FROM dbo.fnSplit(ISNULL(@MultipleDocumentID,''), ',') WHERE ISNULL(item, '') <> '' AND item = D.DocumentId)
				AND ISNULL(D.RecordDeleted, 'N') = 'N'
		END

		DECLARE @Document_Id INT

		DECLARE document_cursor CURSOR
		FOR
		SELECT DocumentId
		FROM #MultipleDocuments

		OPEN document_cursor

		FETCH NEXT FROM document_cursor INTO @Document_Id

		WHILE @@FETCH_STATUS = 0
		BEGIN
			/*Added by Shifali on 14Sept2011 as per SHS Response about updating of DocumentSignatures && Documents fields 
		  While adding Reviewer*/
			SELECT @DocumentVersionId = InProgressDocumentVersionId
				,@AuthorId = AuthorId
			FROM Documents
			WHERE DocumentId = @Document_Id

			--UPDATE Documents
			--SET DocumentShared = 'Y'			
			--WHERE DocumentId = @DocumentId
			SELECT @FirstName = FirstName
				,@LastName = LastName
				,@SigningSuffix = ISNULL(SigningSuffix, '')
				,@UserCode = UserCode
			FROM Staff
			WHERE StaffID = @AuthorId
				AND ISNULL(RecordDeleted, 'N') <> 'Y'

			UPDATE DocumentSignatures
			SET SignatureDate = GETDATE()
				,ModifiedDate = GETDATE()
				,ModifiedBy = @UserCode
				,ClientSignedPaper = @ClientSignedPaper
				,SignerName = @FirstName + ' ' + @LastName + ' ' + CASE 
					WHEN @SigningSuffix = ''
						THEN ''
					ELSE ', ' + @SigningSuffix
					END
				,VerificationMode = @VerificationMode
				,SignedDocumentVersionId = @DocumentVersionId
			WHERE DocumentId = @Document_Id
				--AND SignedDocumentVersionId = @DocumentVersionId
				AND SignedDocumentVersionId IS NULL
				AND StaffId = @AuthorId
				AND ISNULL(RecordDeleted, 'N') = 'N'

			/*ENDS HERE*/
			IF NOT EXISTS (
					SELECT 1
					FROM DocumentSignatures DS
					LEFT JOIN Documents D ON D.DocumentId = DS.DocumentId
					LEFT JOIN DocumentVersions DV ON DS.SignedDocumentVersionId = DV.DocumentVersionId
					WHERE DS.DocumentId = @Document_Id
						AND DS.StaffId = @ReviewerId
						--AND DS.SignedDocumentVersionId = @DocumentVersionId
						AND DS.SignedDocumentVersionId IS NULL
					)
			BEGIN
				--Commented & Changed by Shifali in ref to SHS response(we donot need to set SignedDocumentVersionId 
				--While Adding a Revieiwer(it will set on explicit Sign)
				--INSERT INTO DocumentSignatures            
				--(DocumentId,SignedDocumentVersionId,StaffId,SignatureOrder,CreatedBy,CreatedDate,ModifiedBy,						RevisionNumber)            
				--SELECT @DocumentId,D.InProgressDocumentVersionId,@ReviewerId,1,S.UserCode,GETDATE(),S.UserCode,DV.					RevisionNumber            
				--FROM Documents D 
				--LEFT JOIN DocumentVersions DV ON D.InProgressDocumentVersionId = DV.DocumentVersionId AND ISNULL(DV.				RecordDeleted,'N')<>'Y'  		 
				--LEFT JOIN Staff S ON S.StaffId = D.AuthorId
				--WHERE D.DocumentId = @DocumentId AND ISNULL(D.RecordDeleted,'N')<>'Y'
				INSERT INTO DocumentSignatures (
					DocumentId
					,StaffId
					,SignatureOrder
					,CreatedBy
					,CreatedDate
					,ModifiedBy
					,RevisionNumber
					)
				SELECT @Document_Id
					,@ReviewerId
					,1
					,S.UserCode
					,GETDATE()
					,S.UserCode
					,DV.RevisionNumber
				FROM Documents D
				LEFT JOIN DocumentVersions DV ON D.InProgressDocumentVersionId = DV.DocumentVersionId
					AND ISNULL(DV.RecordDeleted, 'N') <> 'Y'
				LEFT JOIN Staff S ON S.StaffId = D.AuthorId
				WHERE D.DocumentId = @Document_Id
					AND ISNULL(D.RecordDeleted, 'N') <> 'Y'
			END

			FETCH NEXT FROM document_cursor INTO @Document_Id
		END

		CLOSE document_cursor

		DEALLOCATE document_cursor
		
		IF ISNULL(@DocumentId, 0) = 0 AND ISNULL(@MultipleDocumentID, '') <> ''
		BEGIN
			UPDATE D
			SET D.ReviewerId = @ReviewerId
				,D.CurrentVersionStatus = 25
				,D.DocumentShared = 'Y'
			FROM Documents D JOIN #MultipleDocuments MD ON D.DocumentId = MD.DocumentId
			WHERE ISNULL(D.RecordDeleted, 'N') = 'N'
				
			UPDATE D
			SET D.[Status] = 25
			FROM Documents D JOIN #MultipleDocuments MD ON D.DocumentId = MD.DocumentId
			WHERE ISNULL(D.RecordDeleted, 'N') = 'N'
				AND ISNULL(D.[Status], 0) <> 22
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_AddReviewerToDocument') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


