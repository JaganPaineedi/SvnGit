IF EXISTS (SELECT *
             FROM sys.objects
            WHERE object_id = OBJECT_ID(N'ssp_SCCreateDirectMessageAttachment')
              AND type IN ( N'P', N'PC' ))
BEGIN
    DROP PROCEDURE ssp_SCCreateDirectMessageAttachment;
END;
GO

CREATE PROCEDURE ssp_SCCreateDirectMessageAttachment
    @DirectMessageId INT,
    @AttachmentMimeType VARCHAR(500),
    @AttachmentName VARCHAR(500),
    @Attachment VARBINARY(MAX),
    @CurrentUser VARCHAR(30)
AS
/******************************************************************************
**		File: 
**		Name: ssp_SCCreateDirectMessageAttachment
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
**		Date: 8/22/2017
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		    Author:				    Description:
**		--------		--------				-------------------------------------------
**      8/22/2017          jcarlson             created
*******************************************************************************/
BEGIN TRY
    BEGIN TRAN;
    DECLARE @CurrentDate DATETIME = GETDATE();

    INSERT INTO dbo.DirectMessageAttachments (CreatedBy,
                                              CreatedDate,
                                              ModifiedBy,
                                              ModifiedDate,
                                              DirectMessageId,
                                              AttachmentMimeType,
                                              AttachmentName,
                                              Attachment)
    SELECT @CurrentUser,
           @CurrentDate,
           @CurrentUser,
           @CurrentDate,
           @DirectMessageId,
           @AttachmentMimeType,
           @AttachmentName,
           @Attachment;


    COMMIT TRAN;
END TRY
BEGIN CATCH
    IF @@Trancount > 0
    BEGIN
        ROLLBACK TRAN;
    END;

    DECLARE @Error VARCHAR(8000);
    SELECT @Error
        = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
          + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCCreateDirectMessageAttachment') + '*****'
          + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
          + CONVERT(VARCHAR, ERROR_STATE());
    RAISERROR(@Error, 16, 1);

END CATCH;