/****** Object:  StoredProcedure [dbo].[ssp_SCSignatureAddSignerGetList]    Script Date: 01/05/2016 14:13:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCSignatureAddSignerGetList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCSignatureAddSignerGetList]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCSignatureAddSignerGetList]    Script Date: 01/05/2016 14:13:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCSignatureAddSignerGetList] (
	@DocumentID INT
	, @StaffID INT
	, @ClientID INT
	, @IsClient VARCHAR(1)
	, @CreatedBy VARCHAR(30)
	, @SignerName VARCHAR(100)
	, @SignedDocumentVersionId INT
	, @RelationToClient INT -- To save client relation
	)
AS
/*********************************************************************/
/* Stored Procedure: dbo.ssp_SCSignatureAddSignerGetList                  */
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */
/* Creation Date:    7/24/05                                         */
/*                                                                   */
/* Purpose:  Add new signer and get list           */
/*                                                                   */
/* Input Parameters:@DocumentID - DocumentID        */
/*  @DocumentID ,@StaffID int,@ClientID int,@IsClient,                  
@CreatedBy,SignerName ,SignedDocumentVersionId                       */
/*                                                                   */
/* Called By:                                                        */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/* Updates:                                                          */
/*   Date        Author           Purpose                                    */
/* 12March2010   Vikas Monga      Add a new signer and get signer list */
/* 28Sept2011    Shifali		  Removed SignedDocumentVersionId from params as per SHS team response,
Purpose- On Adding a Reviewer, SignedDocumentVersionId filed will not be set, it will be set on explicit Sign of document*/
/* 7May2012    Maninder    Passed CurrentDocumentVersionId to allow signing of versions by the client: Task#748 Threshold Bugs/Feature */
/* 14/12/12    Bernardin          Added RelationToClient column to save (Development Phase IV (Offshore) Task # 15) */
/*	2015-01-06		scooter			Changed StaffId check from "DocumentId" to "SignedDocumentVersionId"  */
/* 11/13/2015  Hemant             Added "OR DocumentID = @DocumentID" and commented "OR SignedDocumentVersionId = @SignedDocumentVersionId" to prevent the duplicate insertion of “Add Signer(s)"
                                  into DocumentSignatures table and stop the process of creating duplicate inprogress documents.
                                  add added code to stop the duplicate insertion of ‘Other Signer(s)’ in DocumentSignatures table
                                  Why:  Pines-Support #509 */
/* 1/5/2016     RCaffrey          Added check on SignerName so Co-Signer can sign multiple Versions and still not repeat - VanBuren Support #277 */  
/* 03/01/2016   Bernardin         Added check on SignerName so Client can sign multiple Versions and still not repeat - WMU - Support Go Live # 232 */                                  
/* 27 oct 2016   Vamsi             Added check for DeclinedSignature is 'N' or not wrt MFS - Support Go Live#24    */             
/* 09 Jan 2017   Venkatesh         Added check for "SignedDocumentVersionId" while adding the other signers  wrt  Andrews Centre Environment Issue Tracking #194    */              
 
/************************************************************************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @SignerExist BIT
		DECLARE @SignatureOrder INT

		SET @SignerExist = 0

		--Signer Type is other user          
		IF (
				isnull(@StaffID, 0) = 0
				AND isnull(@ClientID, 0) = 0
				)
				-- Start Here Hemant 11/13/2015
				BEGIN
					IF ((ISNULL(@RelationToClient,0) = 0 
						and exists(SELECT *
									FROM DocumentSignatures
									WHERE DocumentId = @DocumentID
										AND SignerName=@SignerName
										--Added by Venkatesh
										AND SignedDocumentVersionId=@SignedDocumentVersionId
										AND isnull(RecordDeleted, 'N') = 'N'
									))
					or
					  exists(SELECT *
									FROM DocumentSignatures
									WHERE DocumentId = @DocumentID
										AND SignerName=@SignerName
										AND RelationToClient=@RelationToClient
										--Added by Venkatesh
										AND SignedDocumentVersionId=@SignedDocumentVersionId
										AND isnull(RecordDeleted, 'N') = 'N'
									))
						BEGIN
							SET @SignerExist = 1
						END
					Else
						Begin
							SET @SignerExist = 0
						END
				END
				--End Here  Hemant 11/13/2015
		ELSE IF (isnull(@StaffID, 0) = 0)
			--Check if Client is already added or not  
		BEGIN
			IF EXISTS (
					SELECT *
					FROM DocumentSignatures
					WHERE ClientID = @ClientID
						AND DocumentId = @DocumentID
						AND isnull(RecordDeleted, 'N') = 'N'
						-- Added by Benardin on 03/01/2016 for WMU - Support Go Live # 232
						--AND (
						--	SignedDocumentVersionId IS NULL
						--	OR SignedDocumentVersionId = @SignedDocumentVersionId
						--	)
						
						AND(SignedDocumentVersionId IS NULL OR SignerName IS NULL)
						-- Changes end here
					)
				SET @SignerExist = 1
		END
		ELSE IF (isnull(@ClientID, 0) = 0)
		BEGIN
			--Check if staff  is already added or not  
			IF EXISTS (
					SELECT *
					FROM DocumentSignatures
					WHERE StaffId = @StaffID
						AND isnull(RecordDeleted, 'N') = 'N'
						AND (
							(
								@SignedDocumentVersionId IS NULL
								AND DocumentId = @DocumentID
								)
							--Hemant 11/13/2015
							--OR SignedDocumentVersionId = @SignedDocumentVersionId
							OR DocumentID = @DocumentID AND SignerName IS NULL 
							AND ISNULL(DeclinedSignature,'N')='N' --27 oct 2016 Vamsi
							)
						 )

				SET @SignerExist = 1
		END

		IF (@SignerExist = 0)
		BEGIN
			SELECT @SignatureOrder = isnull(Max(SignatureOrder), 0)
			FROM DocumentSignatures
			WHERE documentid = @DocumentId
				AND isNull(RecordDeleted, 'N') <> 'Y'

			IF (@SignatureOrder > 0)
				SET @SignatureOrder = @SignatureOrder + 1

			/*INSERT INTO DocumentSignatures (DocumentID,SignedDocumentVersionId,StaffID,ClientID,IsClient,CreatedBy,ModifiedBy,SignatureOrder,SignerName)                  
 VALUES(@DocumentID,@SignedDocumentVersionId,@StaffID,@ClientID,@IsClient,@CreatedBy,@CreatedBy,@SignatureOrder,@SignerName)                  
 */
			IF (@RelationToClient = 0)
				SET @RelationToClient = NULL;

			INSERT INTO DocumentSignatures (
				DocumentID
				, StaffID
				, ClientID
				, IsClient
				, CreatedBy
				, ModifiedBy
				, SignatureOrder
				, SignerName
				, RelationToClient
				)
			VALUES (
				@DocumentID
				, @StaffID
				, @ClientID
				, @IsClient
				, @CreatedBy
				, @CreatedBy
				, @SignatureOrder
				, @SignerName
				, @RelationToClient
				)

			EXEC ssp_SCWebSignatureSignersList @DocumentID
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'dbo.ssp_SCSignatureAddSignerGetList') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				, -- Message text.                                                      
				16
				, -- Severity.                                                      
				1 -- State.                                                      
				);
	END CATCH
END


GO


