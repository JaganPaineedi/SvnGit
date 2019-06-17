IF EXISTS (
		SELECT *
		FROM sysobjects
		WHERE type = 'P'
			AND NAME = 'ssp_SCSignatureSignedByClient'
		)
BEGIN
	DROP PROCEDURE ssp_SCSignatureSignedByClient
END
GO

CREATE PROCEDURE [dbo].[ssp_SCSignatureSignedByClient] (
	@ClientID INT
	,@DocumentID INT
	,@ClientSignedPaper VARCHAR(1)
	,@SignatureData IMAGE
	,@SignatureID INT = NULL
	,@DocumentVersionId INT
	,@ModifiedBy VARCHAR(30)
	)
AS
/*********************************************************************/
/* Stored Procedure: dbo.ssp_SignatureSignedByClient                */
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */
/* Creation Date:    7/24/05                                         */
/*                                                                   */
/* Purpose:  Procedure changes the status of signature and insert client's signature */
/*                                                                   */
/* Input Parameters:@ClientID - ClientID                          
     @DocumentID - DocumentID                  
     @Version - Version                  
     @ClientSignedPaper - ClientSignedPaper                  
     @SignatureData - SignatureData     */
/*                                                                   */
/* Output Parameters:   None                           */
/*                                                                   */
/* Return:  0=success, otherwise an error number                     */
/*                                                                   */
/* Called By:                                                        */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/* Updates:                                                          */
/*   Date     Author       Purpose                                    */
/*  7/24/05   Kulwinder    Created                                    */
/*  11/30/2007 Vikas Vyas   Update Modified Date In DocumentSignature Table   */
/*03Oct2011  Shifali   Added condition AND SignedDocumentVersionId IS NULL*/
/*27April2012  Maninder   Added param  @ModifiedBy*/
/* 19April2013 Bernardin  Reverted back to Previous version    */
/*  21 Oct 2015    Revathi    what:Changed code to display Clients LastName and FirstName when ClientType='I' else  OrganizationName.  /   
/							  why:task #609, Network180 Customization  */
/* 13-Nov-2018  Chita Ranjan   What: Added condition to update the VerificationMode column in DocumentSignatures table based on signature option selected in signature popup. 
                               Why: A new signature option called Verbally Agreed Over Phone has beed added in the core signature Popup as part of PEP-Customizations #10212 */
/*********************************************************************/
BEGIN
	BEGIN TRANSACTION

	DECLARE @FirstName VARCHAR(100)
	DECLARE @LastName VARCHAR(100)
	DECLARE @SigningSuffix VARCHAR(100)
	DECLARE @RevisionNumber INT
	DECLARE @SignerName VARCHAR(200) --Added by Revathi 21 Oct 2015
    DECLARE @VerificationMode varchar(1)  = 'S' -- Chita Ranjan 13 Nov 2018
  
	  IF (@ClientSignedPaper = 'V')
	  BEGIN
	  SET @VerificationMode = 'V'
	  SET @ClientSignedPaper='N'
	  END
	  
	  
	SELECT @RevisionNumber = RevisionNumber
	FROM DocumentVersions DV
	WHERE DV.DocumentVersionId = @DocumentVersionId

	--Raman             
	IF (@ClientID != 0)
	BEGIN
		SELECT @FirstName = FirstName
			,@LastName = LastName
			,
			--Added by Revathi 21 Oct 2015
			@SignerName = CASE 
				WHEN ISNULL(ClientType, 'I') = 'I'
					THEN ISNULL(LastName, '') + ', ' + ISNULL(FirstName, '')
				ELSE ISNULL(OrganizationName, '')
				END
		FROM Clients
		WHERE ClientID = @ClientID
			AND ISNULL(RecordDeleted, 'N') <> 'Y'

		UPDATE DocumentSignatures
		SET SignatureDate = GETDATE()
			,ModifiedDate = GETDATE()
			,ModifiedBy = @ModifiedBy
			,ClientSignedPaper = @ClientSignedPaper
			,VerificationMode = @VerificationMode
			,ClientID = @ClientID
			,PhysicalSignature = @SignatureData
			,SignerName = @SignerName --Added by Revathi 21 Oct 2015
			--,SignerName = @LastName + ', ' + @FirstName  
			,RevisionNumber = @RevisionNumber
			,SignedDocumentVersionId = @DocumentVersionId
		WHERE DocumentId = @DocumentID
			AND IsClient = 'Y'
			AND ISNULL(RecordDeleted, 'N') = 'N'
			AND SignedDocumentVersionId IS NULL
	END
	ELSE
	BEGIN
		UPDATE DocumentSignatures
		SET SignatureDate = GETDATE()
			,ModifiedDate = GETDATE()
			,ModifiedBy = @ModifiedBy
			,ClientSignedPaper = @ClientSignedPaper
			,VerificationMode = @VerificationMode
			,PhysicalSignature = @SignatureData
			,RevisionNumber = @RevisionNumber
			,SignedDocumentVersionId = @DocumentVersionId
		WHERE DocumentId = @DocumentID
			AND ISNULL(IsClient, 'N') = 'N'
			AND SignatureID = @SignatureID
			AND ISNULL(RecordDeleted, 'N') = 'N'
			AND SignedDocumentVersionId IS NULL
	END

	IF (@@error != 0)
	BEGIN
		--RAISERROR 20002 'ssp_SCSignatureSignedByClient: An Error Occured While Updating '
      DECLARE @Error varchar(8000)                                                   
	  SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                 
		+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCSignatureSignedByClient: An Error Occured While Updating ')                                                                                 
		+ '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                  
		+ '*****' + Convert(varchar,ERROR_STATE())                               
	 RAISERROR                                                                                 
	 (                                                   
	  @Error, -- Message text.                                                                                
	  16, -- Severity.                                                                                
	  1 -- State.                                                                                
	 );  
		ROLLBACK TRANSACTION

		RETURN (1)
	END

	COMMIT TRANSACTION

	RETURN (0)
END
GO

