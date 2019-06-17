IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'ssp_SCDirectMessageGetSummaryOfCare')
                    AND type IN ( N'P', N'PC' ) )
    BEGIN
        DROP PROCEDURE ssp_SCDirectMessageGetSummaryOfCare;
    END;
GO

CREATE PROCEDURE ssp_SCDirectMessageGetSummaryOfCare
@DocumentVersionId INT
AS
/******************************************************************************
**		File: 
**		Name: ssp_SCDirectMessageGetSummaryOfCare
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
**		Date: 10/3/2017
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		    Author:				    Description:
**		--------		--------				-------------------------------------------
**      10/3/2017          jcarlson             created
*******************************************************************************/
    BEGIN TRY
	SELECT d.ServiceId,d.ClientId,d.AuthorId
	FROM DocumentVersions AS dv
	JOIN Documents AS d ON dv.DocumentId = d.DocumentId
	WHERE dv.DocumentVersionId = @DocumentVersionId
        RETURN;
    END TRY
    BEGIN CATCH
        DECLARE @Error VARCHAR(8000);
        SELECT  @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCDirectMessageGetSummaryOfCare') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());		
        RAISERROR(@Error,		16,1 );

    END CATCH;