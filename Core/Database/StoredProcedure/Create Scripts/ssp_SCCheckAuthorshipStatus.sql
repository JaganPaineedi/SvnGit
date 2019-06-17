/****** Object:  StoredProcedure [dbo].[ssp_SCCheckAuthorshipStatus]    Script Date: 07/22/2015 18:54:52 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCCheckAuthorshipStatus]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCCheckAuthorshipStatus]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCCheckAuthorshipStatus]    Script Date: 07/22/2015 18:54:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*********************************************************/
/* Stored Procedure: dbo.ssp_SCCheckAuthorshipStatus        */
/* Creation Date:  07/22/2015                             */
/* Purpose: To check whether the document has the Authorship    */
/*  Date                  Author                 Purpose  */
/* 07/22/2015             Ponnin               Created  */
/**********************************************************/
CREATE PROCEDURE [dbo].[ssp_SCCheckAuthorshipStatus] @DocumentCodeId INT
	,@DocumentId INT
	,@DocumentVersionId INT
	,@ClientId INT
AS
BEGIN
	BEGIN TRY
		DECLARE @AuthorShipStatus VARCHAR(10)
		SET @AuthorShipStatus = 'No'

		IF EXISTS (
				SELECT 1
				FROM documentcodes
				WHERE DocumentCodeId = @DocumentCodeId
					AND AllowEditingByNonAuthors = 'Y'
					AND ISNULL(RecordDeleted, 'N') = 'N'
				)
		BEGIN
			IF EXISTS (
					SELECT 1
					FROM Documents
					WHERE DocumentCodeId = @DocumentCodeId
						AND ClientId = @ClientId
						AND DocumentId = @DocumentId
						AND [Status] <> 22
						AND CurrentVersionStatus <> 22
						AND InProgressDocumentVersionId = @DocumentVersionId
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
			BEGIN
				SET @AuthorShipStatus = 'Yes'
			END
		END

		SELECT @AuthorShipStatus
	END TRY

	BEGIN CATCH
		RAISERROR 20006 'ssp_SCCheckAuthorshipStatus: An Error Occured'

		RETURN
	END CATCH
END
GO

