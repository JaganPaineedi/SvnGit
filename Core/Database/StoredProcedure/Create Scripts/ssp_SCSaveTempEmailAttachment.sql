IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'ssp_SCSaveTempEmailAttachment')
                    AND type IN ( N'P', N'PC' ) )
    BEGIN
        DROP PROCEDURE ssp_SCSaveTempEmailAttachment;
    END;
GO

CREATE PROCEDURE ssp_SCSaveTempEmailAttachment
@AttachmentName VARCHAR(MAX),
@AttachmentMimeType VARCHAR(MAX),
@StaffId INT,
@Session VARCHAR(MAX),
@AttachmentData VARBINARY(max),
@CurrentUser VARCHAR(30)
AS
/******************************************************************************
**		File: 
**		Name: ssp_SCSaveTempEmailAttachment
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
	
	INSERT INTO dbo.TemporaryEmailAttachments ( CreatedBy, ModifiedBy, AttachmentName, AttachmentData, AttachmentMimeType, SessionId, StaffId )
	SELECT @CurrentUser,@CurrentUser,@AttachmentName,@AttachmentData,@AttachmentMimeType,@Session,@StaffId


	SELECT TemporaryEmailAttachmentId
	FROM dbo.TemporaryEmailAttachments
	WHERE TemporaryEmailAttachmentId = SCOPE_IDENTITY();


    COMMIT TRAN 
    END TRY
    BEGIN CATCH
	IF @@Trancount > 0
	BEGIN
    ROLLBACK TRAN
	END
    
        DECLARE @Error VARCHAR(8000);
        SELECT  @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCSaveTempEmailAttachment') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());		
        RAISERROR (	@Error,		16,	1 	);

    END CATCH;