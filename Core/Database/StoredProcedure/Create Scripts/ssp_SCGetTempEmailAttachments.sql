IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'ssp_SCGetTempEmailAttachments')
                    AND type IN ( N'P', N'PC' ) )
    BEGIN
        DROP PROCEDURE ssp_SCGetTempEmailAttachments;
    END;
GO

CREATE PROCEDURE ssp_SCGetTempEmailAttachments
@TempEmailAttachmentIds VARCHAR(MAX),
@StaffId INT,
@Session VARCHAR(MAX),
@CustomInit CHAR(1)
AS
/******************************************************************************
**		File: 
**		Name: ssp_SCGetTempEmailAttachments
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
**		Date: 10/6/2017
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		    Author:				    Description:
**		--------		--------				-------------------------------------------
**      10/6/2017          jcarlson             created
*******************************************************************************/
    BEGIN TRY
	SELECT a.TemporaryEmailAttachmentId,CASE @CustomInit 
											WHEN 'N' THEN a.AttachmentData
											ELSE CONVERT(VARBINARY(max),NULL)
											END AS AttachmentData, a.AttachmentName,a.AttachmentMimeType,a.SessionId,a.StaffId
	FROM dbo.TemporaryEmailAttachments AS a
	JOIN dbo.fnSplitWithIndex(@TempEmailAttachmentIds,',') AS b ON a.TemporaryEmailAttachmentId = CONVERT(INT,b.item)
	WHERE a.SessionId  = @Session
	AND a.StaffId = @StaffId;

        RETURN;


    END TRY
    BEGIN CATCH
        DECLARE @Error VARCHAR(8000);
        SELECT  @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetTempEmailAttachments') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());		
        RAISERROR(@Error,		16,1 );

    END CATCH;