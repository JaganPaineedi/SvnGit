
/****** Object:  StoredProcedure [dbo].[ssp_CreateCCDRDocument]    Script Date: 06/12/2015 14:47:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CreateCCDRDocument]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CreateCCDRDocument]
GO



/****** Object:  StoredProcedure [dbo].[ssp_CreateCCDRDocument]    Script Date: 06/12/2015 14:47:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_CreateCCDRDocument] (
	@DocumentCodeId INT
	,@ClientId INT
	,@Status INT
	,@StaffId INT
	)
AS
/*********************************************************************/
/* Stored Procedure: dbo.ssp_CreateCCDRDocument                             */
/* Copyright:  2005 Streamline Healthcare Solutions,  LLC        */
/* Creation Date:    05/Feb/2014            */
/* Purpose:    Create Continuity of Care Document and Record 'In Progress' Document   */
/*********************************************************************/
BEGIN
	DECLARE @CreatedBy VARCHAR(10)
	DECLARE @CreatedDate DATETIME
	DECLARE @DocumentShared CHAR(1)
	DECLARE @SignedByAuthor CHAR(1)
	DECLARE @SignedByAll CHAR(1)
	DECLARE @ContributingDocumentVersionId INT
	DECLARE @InsertedDocumentId VARCHAR(50)
	DECLARE @Version INT
	DECLARE @EffectiveDate DATETIME
	DECLARE @InsertedDocumentVersionId INT
	DECLARE @DueDate DATETIME

	BEGIN TRY
		SET @CreatedBy = 'SYSTEM'
		SET @CreatedDate = getdate()
		SET @DocumentShared = 'N'
		SET @SignedByAuthor = 'N'
		SET @SignedByAll = 'N'

		IF (@Version IS NULL)
		BEGIN
			SET @Version = 1
		END

		IF (@EffectiveDate IS NULL)
		BEGIN
			SET @EffectiveDate = cast(CONVERT(VARCHAR(10), getdate(), 101) AS DATETIME)
		END

		IF (@DueDate IS NULL)
		BEGIN
			SET @DueDate = @EffectiveDate
		END

		-- CREATE CLINICAL RECONCILIATION DOCUMENT    
		INSERT INTO Documents (
			CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,ClientId
			,DocumentCodeId
			,EffectiveDate
			--,DueDate           
			,[Status]
			,AuthorId
			,DocumentShared
			,SignedByAuthor
			,SignedByAll
			,CurrentVersionStatus
			)
		SELECT @CreatedBy
			,@CreatedDate
			,@CreatedBy
			,@CreatedDate
			,@ClientId
			,1631  -- Clinical Information Reconciliation
			,dateadd(YY, 1, @EffectiveDate)
			-- ,dateadd(YY, 1, @DueDate)           
			,22
			,@StaffId
			,@DocumentShared
			,@SignedByAuthor
			,@SignedByAll
			,22 

		SET @InsertedDocumentId = @@identity

		INSERT INTO DocumentVersions (
			CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,DocumentId
			,[Version]
			,AuthorId
			,EffectiveDate
			)
		SELECT @CreatedBy
			,@CreatedDate
			,@CreatedBy
			,@CreatedDate
			,@InsertedDocumentId
			,@Version
			,@StaffId
			,@EffectiveDate

		SET @InsertedDocumentVersionId = @@identity

		UPDATE Documents
		SET CurrentDocumentVersionId = @InsertedDocumentVersionId
			,InProgressDocumentVersionId = @InsertedDocumentVersionId
		WHERE DocumentId = @InsertedDocumentId

		EXEC ssp_SCSignatureAddFirstSigner @InsertedDocumentId
			,@InsertedDocumentVersionId

		SELECT @InsertedDocumentVersionId
		
		UPDATE DocumentSignatures 
		SET SignatureDate = GetDate() 
		WHERE Documentid = @InsertedDocumentId and StaffID = @StaffID and IsNull(RecordDeleted,'N')<>'Y'                      

	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(MAX)

		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_CreateCCDRDocument') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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

GO


