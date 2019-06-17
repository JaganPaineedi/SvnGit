IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'ssp_SCDeleteTempEmailAttachments')
                    AND type IN ( N'P', N'PC' ) )
    BEGIN
        DROP PROCEDURE ssp_SCDeleteTempEmailAttachments;
    END;
GO

CREATE PROCEDURE ssp_SCDeleteTempEmailAttachments
@EmailIds VARCHAR(max),
@StaffId INT,
@Session VARCHAR(max)
AS
/******************************************************************************
**		File: 
**		Name: ssp_SCDeleteTempEmailAttachments
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
	BEGIN TRAN
       	DELETE FROM a FROM dbo.TemporaryEmailAttachments AS a
	JOIN dbo.fnSplitWithIndex(@EmailIds,',') AS b ON a.TemporaryEmailAttachmentId = CONVERT(INT,b.item)
	WHERE a.SessionId  = @Session
	AND a.StaffId = @StaffId;

    COMMIT TRAN 
    END TRY
    BEGIN CATCH
	IF @@Trancount > 0
	BEGIN
    ROLLBACK TRAN
	END
    
        DECLARE @Error VARCHAR(8000);
        SELECT  @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCDeleteTempEmailAttachments') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());		
        RAISERROR (	@Error,		16,	1 	);

    END CATCH;