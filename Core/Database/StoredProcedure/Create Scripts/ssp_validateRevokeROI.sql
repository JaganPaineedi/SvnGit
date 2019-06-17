IF EXISTS (SELECT
    *
  FROM sys.objects
  WHERE object_id = OBJECT_ID(N'[dbo].[ssp_validateRevokeROI]') AND type IN (N'P', N'PC'))
  DROP PROCEDURE [dbo].[ssp_validateRevokeROI]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[ssp_validateRevokeROI] 
@DocumentVersionId int
AS
/************************************************************************************/
/* Stored Procedure: dbo.[ssp_validateRevokeROI]   171     */
/* Copyright: 2012 Streamline Healthcare Solutions,  LLC       */
/* Creation Date:   22/Nov/2017             */
/* Purpose:To validate 'Revoke Release of Information' document    */
/*                     */
/* Input Parameters:  @DocumentVersionId      */
/*                     */
/* Output Parameters:   None              */
/*                     */
/* Return:  0=success, otherwise an error number         */
/*                     */
/* Called By:                  */
/*                     */
/* Calls:                   */
/*                     */
/* Data Modifications:                */
/*                     */
/* Updates:                   */
/* Modified Date            Name           Description					   */
/* 22/Nov/2017         Alok Kumar          Created	(Ref: Task#2013 Spring River - Customizations) */ 
/* 07/Feb/2018         Ponnin              Removed the validations for "Additional staff signature is required." For Ref: Task#2013 Spring River - Customizations */ 

/************************************************************************************/

BEGIN
  BEGIN TRY
    
    DECLARE @DocumentId int

    DECLARE @EffectiveDate Date 
    SELECT @DocumentId = DocumentId, @EffectiveDate=EffectiveDate FROM Documents WHERE CurrentDocumentVersionId = @DocumentVersionId
    
    DECLARE @CoSigner CHAR='N'
    
    IF EXISTS (
		SELECT TOP 1 StaffId
		FROM DocumentSignatures DS
		INNER JOIN Documents D ON D.AuthorId <> DS.StaffId AND D.DocumentId = @DocumentId
		WHERE DS.DocumentId = @DocumentId AND DS.StaffId IS NOT NULL
		)
	BEGIN
		SET @CoSigner = 'Y'
	END


    --INSERT INTO #validationReturnTable (TableName,
    --ColumnName,
    --ErrorMessage,
    --ValidationOrder)
    --  SELECT
    --    'DocumentRevokeReleaseOfInformations',
    --    'ClientWrittenConsent',
    --    'Additional staff signature is required.',
    --    1
    --  FROM DocumentRevokeReleaseOfInformations
    --  WHERE ClientWrittenConsent = 'Y' 
			 -- AND @CoSigner='N' 
			 -- AND documentVersionId = @documentVersionId
			 -- AND ISNULL(RecordDeleted, 'N') = 'N'



  END TRY
  BEGIN CATCH
    DECLARE @Error varchar(8000)
    SET @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****' + CONVERT(varchar(4000), ERROR_MESSAGE())
    + '*****' + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()), 'ssp_validateRevokeROI')
    + '*****' + CONVERT(varchar, ERROR_LINE()) + '*****' + CONVERT(varchar, ERROR_SEVERITY())
    + '*****' + CONVERT(varchar, ERROR_STATE())
  END CATCH
END