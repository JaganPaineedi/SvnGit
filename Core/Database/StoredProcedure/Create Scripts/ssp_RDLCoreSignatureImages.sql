/****** Object:  StoredProcedure [dbo].[ssp_RDLCoreSignatureImages]    Script Date: 01/18/2017 16:02:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLCoreSignatureImages]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLCoreSignatureImages]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLCoreSignatureImages]    Script Date: 01/18/2017 16:02:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_RDLCoreSignatureImages] (@DocumentVersionId INT)
AS
/*************************************************************************/
/* Stored Procedure: ssp_RDLReasonForNewVersion                          */
/* Creation Date:  18 JAN 2017                                           */
/* Purpose: Gets Data for Signatures                                     */
/* Input Parameters: @DocumentVersionId                                  */
/* Author: Akwinass                                                      */
/* 07/09/2018   Veena    modified to ssf instead of using csf - Renewed Mind - Support #917  */
/* 13/11/2018   Chita Ranjan   Added one more condition to display a text 'Agreed Over Phone' in the RDL when signature is done by using 
                               'Verbally Agreed Over Phone' option. PEP - Customizations #10212  */
/* 13/12/2018   Chita Ranjan    Added logic to check for "ShowSigningSuffixORBillingDegreeInSignatureRDL" system configuration key and display signing suffix on PDF 
                                Unison Customizations #10009.1  */
/* 02/20/2018   MD				Added logic to check for "ShowSigningSuffixORBillingDegreeInSignatureRDL" system configuration key and display billing degree on PDF 
								WestBridge - Support Go Live #40 */  
/*************************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @DocumentId INT
		DECLARE @Need5Columns CHAR(1)
		DECLARE @SystemConfigKeyValue VARCHAR(20)

		SELECT TOP 1 @DocumentId = DocumentId
		FROM DocumentSignatures
		WHERE SignedDocumentVersionId = @DocumentVersionId

		SELECT TOP 1 @Need5Columns = DocumentCodes.Need5Columns
		FROM DocumentCodes
		INNER JOIN Documents ON DocumentCodes.DocumentCodeId = Documents.DocumentCodeId
		WHERE Documents.DocumentId = @DocumentId
		
		DECLARE @Version INT
		SELECT TOP 1 @Version = [Version]
		FROM DocumentVersions
		WHERE ISNULL(RecordDeleted, 'N') = 'N'
			AND DocumentVersionId = @DocumentVersionId

        SET @SystemConfigKeyValue = (SELECT dbo.ssf_GetSystemConfigurationKeyValue('ShowSigningSuffixORBillingDegreeInSignatureRDL'))

		SELECT a.SignatureID
			,a.DocumentID
			,a.VerificationMode
			,CASE 
				WHEN a.IsClient = 'Y'
					THEN RTRIM(c.FirstName + ' ' + c.LastName)
				WHEN @SystemConfigKeyValue = 'BillingDegree'  -- Added by MD
                THEN ISNULL(b.Firstname, '') + ' ' + ISNULL(b.LastName, '')
				ELSE ISNULL(a.SignerName, ISNULL(b.Firstname, '') + ' ' + ISNULL(b.LastName, ''))
				END AS 'SignerName'
			,CASE 
				WHEN ISNULL(DeclinedSignature, 'N') = 'Y'
					THEN ' (Signature not available)'
				WHEN ISNULL(ClientSignedPaper, 'N') = 'Y'
					THEN ' (Signed Paper Copy)'
				WHEN a.VerificationMode='V'   --Chita Ranjan 13/11/2018
					THEN ' (Agreed Over Phone)'
				ELSE ''
				END AS 'Signature'
			,DeclinedSignature
			,a.StaffId
			,a.PhysicalSignature
			,CASE 
				WHEN a.RelationToClient IS NOT NULL
					THEN dbo.ssf_GetGlobalCodeNameById(a.RelationToClient)
				WHEN (a.StaffId IS NULL OR a.IsClient = 'Y')
					THEN ' Client'
				ELSE ' Clinician'
				END AS Relation
			,CASE 
				WHEN ISNULL(a.ClientSignedPaper, 'N') = 'Y'
					THEN 'See Paper Copy'
				ELSE CONVERT(VARCHAR(10), a.SignatureDate, 101)
				END AS 'SignatureDate'
			,CASE 
			    WHEN ISNULL(a.IsClient, 'N') = 'N' AND (@SystemConfigKeyValue = 'SigningSuffix')  -- Added by Chita on 12/12/2018
				       THEN ''
				WHEN (ISNULL(a.IsClient, 'N') = 'N')
					THEN dbo.ssf_GetDocumentSignatureCredentials(a.staffid, @DocumentVersionId)
				ELSE ''
				END AS 'Degree'
			,@Need5Columns AS 'Need5Columns'
		FROM documentSignatures a
		LEFT JOIN Staff b ON a.staffid = b.staffid
		LEFT JOIN Clients c ON c.Clientid = a.Clientid
		LEFT JOIN DocumentVersions DV ON DV.DocumentVersionId = a.SignedDocumentVersionId
		WHERE a.DocumentId = @DocumentId
			AND (a.SignatureDate IS NOT NULL OR ISNULL(DeclinedSignature, 'N') = 'Y')
			AND (a.RecordDeleted = 'N' OR a.RecordDeleted IS NULL)
			AND DV.[Version] = @Version
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLCoreSignatureImages') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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