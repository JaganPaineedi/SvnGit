IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCSignatureUpdateGetDocumentReviewer]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCSignatureUpdateGetDocumentReviewer]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCSignatureUpdateGetDocumentReviewer] (
	  @DocumentID INT
	, @StaffID INT
	, @CreatedBy VARCHAR(30)
	, @SignerName VARCHAR(100)
	, @SignatureID int
	)
AS
/*********************************************************************/
/* Stored Procedure: ssp_SCSignatureUpdateGetDocumentReviewer        */
/* Creation Date:    3/18/2016                                       */
/* Purpose:          Decline signer,add new signer,update document 
                     reviewer and get signer list                    */
/* Created By:       Hemant Kumar                                    */
/* Data Modifications:                                               */
/*                                                                   */
/* Updates:                                                          */
/*   Date        Author           Purpose                            */
                               
                                
/*********************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @SignatureOrder INT
		DECLARE @varSignatureorder int
		select  @varSignatureorder= SignatureOrder from documentsignatures where SignatureID=@SignatureID 
		BEGIN TRAN  
		if exists(select * from documentsignatures where DocumentId= @DocumentId and SignatureOrder>@varSignatureorder)          
        Begin    
			update DocumentSignatures set SignatureOrder=SignatureOrder-1 where DocumentId= @DocumentId and SignatureOrder>@varSignatureorder          
        end
        
        update DocumentSignatures set Recorddeleted='Y',DeletedDate=getdate(),DeletedBy=@CreatedBy where SignatureID=@SignatureID            


			SELECT @SignatureOrder = isnull(Max(SignatureOrder), 0)
			FROM DocumentSignatures
			WHERE documentid = @DocumentId
				AND isNull(RecordDeleted, 'N') <> 'Y'

			IF (@SignatureOrder > 0)
				SET @SignatureOrder = @SignatureOrder + 1


			INSERT INTO DocumentSignatures (
				DocumentID
				, StaffID
				, CreatedBy
				, ModifiedBy
				, SignatureOrder
				, SignerName
				)
			VALUES (
				  @DocumentID
				, @StaffID
				, @CreatedBy
				, @CreatedBy
				, @SignatureOrder
				, @SignerName
				)
		    update Documents set ReviewerId=@StaffID where DocumentId=@DocumentID            
	   Commit Tran

			EXEC ssp_SCWebSignatureSignersList @DocumentID
		
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)
        IF @@trancount > 0   
            ROLLBACK TRAN  
		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'dbo.ssp_SCSignatureUpdateGetDocumentReviewer') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())
        IF @@trancount > 0   
            ROLLBACK TRAN  

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


