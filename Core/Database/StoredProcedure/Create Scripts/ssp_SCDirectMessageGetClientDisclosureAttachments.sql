IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'ssp_SCDirectMessageGetClientDisclosureAttachments')
                    AND type IN ( N'P', N'PC' ) )
    BEGIN
        DROP PROCEDURE ssp_SCDirectMessageGetClientDisclosureAttachments;
    END;
GO

CREATE PROCEDURE ssp_SCDirectMessageGetClientDisclosureAttachments 
@ClientDisclosureId INT
AS
/******************************************************************************
**		File: 
**		Name: ssp_SCDirectMessageGetClientDisclosureAttachments
**		Desc: 
**
**              
**		Return values:
** 
**		Called by:   
**              
**		Parameters:
**
**		Auth: jcarlson
**		Date: 8/15/2017
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		    Author:				    Description:
**		--------		--------				-------------------------------
**      8/15/2017       jcarlson                created
**		8/22/2017		jcarlson				Added logic to ensure unique AttachmentNames and to pull image records Id from image records table along with any from CLientDisclosedRecords
**		11/30/2017		Sunil.D				    What:Added DocumentCodeId To the result set to use this in front end report viewer.
												Why:SC: Disclosure Requests: Send Direct Message: Error
												Offshore QA Bugs #615 
**		5/11/2018		Wasif Butt				Add ClientDisclosureRecords record deleted check and also sorting it based on the order attachments were added.
**      06/11/2018      Pranay B                Added union for the ImageRecords where ISNULL(a.ScannedOrUploaded,'')='U' because Uploaded files are not returened.
*******************************************************************************/
    BEGIN TRY

	SELECT a.ClientDisclosureId,a.DocumentId,a.ServiceId,a.ImageRecordId,ISNULL(d.InProgressDocumentVersionId,d2.InProgressDocumentVersionId) AS DocumentVersionId, ISNULL(ISNULL(dc.DocumentName,dc2.DocumentName),'Attachment') AS AttachmentName
	---11/30/2017		Sunil.D	
	,d.DocumentCodeId , a.ClientDisclosedRecordId
	INTO #Records
	FROM dbo.ClientDisclosedRecords AS a
	LEFT JOIN dbo.Documents AS d ON d.DocumentId = a.DocumentId
	LEFT JOIN dbo.DocumentCodes AS dc ON dc.DocumentCodeId = d.DocumentCodeId
	LEFT JOIN Services AS s ON s.ServiceId = a.ServiceId
	LEFT JOIN Documents AS d2 ON d2.ServiceId = s.ServiceId
	LEFT JOIN DocumentCodes AS dc2 ON d2.DocumentCodeId = dc2.DocumentCodeId
	WHERE a.ClientDisclosureId = @ClientDisclosureId
	AND ISNULL(a.RecordDeleted,'N')='N'
	UNION
	SELECT @ClientDisclosureId,NULL AS DocumentId,NULL AS ServiceId,a.ImageRecordId,NULL AS DocumentVersionId, 'Attachment' AS AttachmentName,NUll as DocumentCodeId , ClientDisclosedRecordId
	FROM dbo.ImageRecords AS a
	join dbo.ClientDisclosedRecords as cdr on cdr.ImageRecordId = a.ImageRecordId
	WHERE a.ClientDisclosureId = @ClientDisclosureId
	and isnull(cdr.RecordDeleted, 'N') = 'N'
	    
	UNION 
	SELECT @ClientDisclosureId,NULL AS DocumentId,NULL AS ServiceId,a.ImageRecordId,NULL AS DocumentVersionId, 'Attachment' AS AttachmentName,NUll as DocumentCodeId , NULL AS ClientDisclosedRecordId
	FROM dbo.ImageRecords AS a
	WHERE a.ClientDisclosureId = @ClientDisclosureId
	AND ISNULL(a.ScannedOrUploaded,'')='U'
	and isnull(a.RecordDeleted, 'N') = 'N'

	SELECT ClientDisclosureId, DocumentId, ServiceId, ImageRecordId, DocumentVersionId, AttachmentName + ' ' + CONVERT(VARCHAR(MAX),ROW_NUMBER() OVER	(PARTITION BY AttachmentName ORDER BY (SELECT 1))) + '.pdf' AS AttachmentName
    ---11/30/2017		Sunil.D	
	,DocumentCodeId 
	FROM #Records
	order by ClientDisclosedRecordId asc

    END TRY
    BEGIN CATCH
        DECLARE @Error VARCHAR(8000);
        SELECT  @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCDirectMessageGetClientDisclosureAttachments') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());		
        RAISERROR(@Error,		16,1 );

    END CATCH;