IF EXISTS (SELECT *
             FROM sys.objects
            WHERE object_id = OBJECT_ID(N'ssp_SCCreateDirectMessage')
              AND type IN ( N'P', N'PC' ))
BEGIN
    DROP PROCEDURE ssp_SCCreateDirectMessage;
END;
GO

CREATE PROCEDURE ssp_SCCreateDirectMessage
    @CurrentUser VARCHAR(30),
    @MessageSubject VARCHAR(MAX),
    @MessageBody VARCHAR(MAX),
    @MessageBodyMimeType VARCHAR(500) = 'plain/text',
    @StaffId INT,
    @MessageTo VARCHAR(MAX),
    @MessageCC VARCHAR(MAX) = NULL,
    @MessageBCC VARCHAR(MAX) = NULL,
	@DirectAccountId INT,
    @DirectMessageId INT OUTPUT
AS
/******************************************************************************
**		File: 
**		Name: ssp_SCCreateDirectMessage
**		Desc: This is used to create a direct message record from the back end
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
**      8/22/2017       jcarlson	            created
*******************************************************************************/
BEGIN TRY
    BEGIN TRAN;
    DECLARE @CurrentDate DATETIME = GETDATE();
    DECLARE @NewMessage  INT,
            @ReadyToSend INT,
            @StaffEmail  VARCHAR(1000);


    SELECT @NewMessage = GlobalCodeId
      FROM GlobalCodes
     WHERE Category                   = 'DirectMessageStatus'
       AND Code                       = 'NM'
       AND ISNULL(RecordDeleted, 'N') = 'N';

    SELECT @ReadyToSend = GlobalCodeId
      FROM GlobalCodes
     WHERE Category                   = 'DirectMessageStatus'
       AND Code                       = 'NM'
       AND ISNULL(RecordDeleted, 'N') = 'N';

    SELECT @StaffEmail = DirectEmailAddress
      FROM Staff
     WHERE StaffId = @StaffId;




    INSERT INTO dbo.DirectMessages (CreatedBy,
                                    CreatedDate,
                                    ModifiedBy,
                                    ModifiedDate,
                                    MessageType,
                                    MessageFrom,
                                    MessageSubject,
                                    MessageBody,
                                    MessageBodyMimeType,
                                    StaffId,
                                    StaffDirectMessageEmail,
                                    MessageStatus,
                                    MessageTo,
                                    MessageCC,
                                    MessageBCC,
                                    MessageRead,
									DirectAccountId)
    SELECT @CurrentUser,
           @CurrentDate,
           @CurrentUser,
           @CurrentDate,
           'O',
           @StaffEmail,
           @MessageSubject,
           @MessageBody,
           @MessageBodyMimeType,
           @StaffId,
           @StaffEmail,
           @NewMessage,
           @MessageTo,
           @MessageCC,
           @MessageBCC,
           'N',
		   @DirectAccountId

    SELECT @DirectMessageId = SCOPE_IDENTITY();

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
          + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCCreateDirectMessage') + '*****'
          + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
          + CONVERT(VARCHAR, ERROR_STATE());
    RAISERROR(@Error, 16, 1);

END CATCH;