IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportSignatureImagesFCS]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_RDLSubReportSignatureImagesFCS] 
GO

CREATE PROCEDURE [dbo].[csp_RDLSubReportSignatureImagesFCS] @DocumentVersionId INT
AS
/*********************************************************************/
/* Stored Procedure: [csp_RDLSubReportSignatureImagesFCS]               */
/* Creation Date:  19/Jan/2017                                    */
/* Purpose: RDL Header details */
/* Input Parameters:   @DocumentVersionId */
/* What:Moved from F&CS to NDNW; Why:New Directions - Support Go Live ,Task#286*/
/* Called By: K.Soujanya  */
/*   Updates:                                                          */
/*   Date              Author                  Purpose     */
/* *//*********************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @DocumentId INT
		DECLARE @Need5Columns CHAR(1)

		SET @DocumentId = (
				SELECT DISTINCT DocumentId
				FROM DocumentSignatures
				WHERE SignedDocumentVersionId = @DocumentVersionId
				);
		SET @Need5Columns = (
				SELECT DocumentCodes.Need5Columns
				FROM DocumentCodes
				INNER JOIN Documents ON DocumentCodes.DocumentCodeId = Documents.DocumentCodeId
				WHERE Documents.DocumentId = @DocumentId
				);

		DECLARE @Version INT

		SELECT TOP 1 @Version = [Version]
		FROM DocumentVersions
		WHERE ISNULL(RecordDeleted, 'N') = 'N'
			AND DocumentVersionId = @DocumentVersionId

		-- If the isClient='Y'  Then Get The name from client other wise from staff,Signername from DocumentSignature Table                      
		SELECT a.SignatureID
			,a.DocumentID
			,a.VerificationMode
			,CASE 
				WHEN a.IsClient = 'Y'
					THEN RTRIM(c.FirstName + ' ' + c.LastName)
				ELSE ISNULL(a.SignerName, ISNULL(b.Firstname, '') + ' ' + ISNULL(b.LastName, ''))
				END AS 'SignerName'
			,CASE 
				WHEN ISNULL(DeclinedSignature, 'N') = 'Y'
					THEN ' (Signature not available)'
				WHEN ISNULL(ClientSignedPaper, 'N') = 'Y'
					THEN ' (Signed Paper Copy)'
				ELSE ''
				END AS 'Signature'
			,DeclinedSignature
			,a.StaffId
			,a.PhysicalSignature
			,CASE 
				WHEN a.RelationToClient IS NOT NULL
					THEN dbo.csf_GetGlobalCodeNameById(a.RelationToClient)
				WHEN (
						a.StaffId IS NULL
						OR a.IsClient = 'Y'
						)
					THEN ' Client'
				ELSE ' Clinician'
				END AS Relation
			,CASE 
				WHEN ISNULL(a.ClientSignedPaper, 'N') = 'Y'
					THEN 'See Paper Copy'
				ELSE CONVERT(VARCHAR(10), a.SignatureDate, 101)
				END AS 'SignatureDate'
			,CASE 
				WHEN (ISNULL(a.IsClient, 'N') = 'N')
					THEN dbo.csf_GetDocumentSignatureCredentials(a.staffid, @DocumentVersionId)
				ELSE ''
				END AS 'Degree'
			,@Need5Columns AS 'Need5Columns'
		FROM documentSignatures a
		LEFT JOIN Staff b ON a.staffid = b.staffid
		LEFT JOIN Clients c ON c.Clientid = a.Clientid
		LEFT JOIN DocumentVersions DV ON DV.DocumentVersionId = a.SignedDocumentVersionId
		WHERE a.DocumentId = @DocumentId
			AND (
				a.SignatureDate IS NOT NULL
				OR ISNULL(DeclinedSignature, 'N') = 'Y'
				)
			AND (
				a.RecordDeleted = 'N'
				OR a.RecordDeleted IS NULL
				)
			AND DV.[Version] = @Version
			--AND (a.SignedDocumentVersionId = @DocumentVersionId)                 
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLSubReportSignatureImagesFCS') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


