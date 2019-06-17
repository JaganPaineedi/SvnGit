IF EXISTS (SELECT *
             FROM sys.objects
            WHERE object_id = OBJECT_ID(N'ssp_SCSendDirectMessage')
              AND type IN ( N'P', N'PC' ))
BEGIN
    DROP PROCEDURE ssp_SCSendDirectMessage;
END;
GO

CREATE PROCEDURE ssp_SCSendDirectMessage @DirectMessageId INT
AS
/******************************************************************************
**		File: 
**		Name: ssp_SCSendDirectMessage
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
    DECLARE @ReadyToSend INT;


    SELECT @ReadyToSend = GlobalCodeId
      FROM GlobalCodes
     WHERE Category                   = 'DirectMessageStatus'
       AND Code                       = 'RSVS'
       AND ISNULL(RecordDeleted, 'N') = 'N';


    UPDATE dbo.DirectMessages
       SET MessageStatus = @ReadyToSend
     WHERE DirectMessageId = @DirectMessageId;


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
          + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCSendDirectMessage') + '*****'
          + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
          + CONVERT(VARCHAR, ERROR_STATE());
    RAISERROR(@Error, 16, 1);

END CATCH;