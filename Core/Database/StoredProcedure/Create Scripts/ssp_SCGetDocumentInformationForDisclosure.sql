IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'ssp_SCGetDocumentInformationForDisclosure')
                    AND type IN ( N'P', N'PC' ) )
    BEGIN
        DROP PROCEDURE ssp_SCGetDocumentInformationForDisclosure;
    END;
GO

CREATE PROCEDURE ssp_SCGetDocumentInformationForDisclosure
@DocumentId INT 
AS
/******************************************************************************
**		File: 
**		Name: ssp_SCGetDocumentInformationForDisclosure
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
**		--------		--------				-------------------------------------------
**      8/15/2017          jcarlson             created
*******************************************************************************/
    BEGIN TRY
	DECLARE @DM INT 

    SELECT @DM = GlobalCodeId
	FROM GlobalCodes 
	WHERE Category = 'DISCLOSEDELIVERYTYPE'
	AND Code = 'DM'
	AND ISNULL(RecordDeleted,'N')='N'

		SELECT d.DocumentId,
		dc.DocumentName,
		d.EffectiveDate,
		dbo.ssf_GetGlobalCodeNameById(d.CurrentVersionStatus) AS DocumentStatusName,
		st.DisplayAs AS DocumentAuthorName,
		d.DocumentId AS PrimaryId,
		dc.DocumentName AS Name,
		d.EffectiveDate AS [Date],
		st.DisplayAs AS Staff,
		d.ClientId AS ClientId,
		d.InProgressDocumentVersionId AS [Version],
		dc.DocumentCodeId AS DocumentCodeId,
		d.InProgressDocumentVersionId AS DocumentVersionId,
		'true' AS AddButtonEnabled,
		c.LastName + ', ' + c.FirstName AS ClientName,
		@DM AS DisclosureStatus
		FROM Documents AS d 
		JOIN dbo.DocumentVersions AS dv ON dv.DocumentVersionId = d.InProgressDocumentVersionId
		JOIN dbo.DocumentCodes AS dc ON d.DocumentCodeId = dc.DocumentCodeId
		JOIN dbo.Staff AS st ON d.AuthorId = st.StaffId
		JOIN dbo.Clients AS c ON d.ClientId = c.ClientId
		WHERE d.DocumentId = @DocumentId
        RETURN;


    END TRY
    BEGIN CATCH
        DECLARE @Error VARCHAR(8000);
        SELECT  @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetDocumentInformationForDisclosure') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());		
        RAISERROR(@Error,		16,1 );

    END CATCH;