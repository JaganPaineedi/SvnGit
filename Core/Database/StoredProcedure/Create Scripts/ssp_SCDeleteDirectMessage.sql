IF EXISTS (SELECT *
             FROM sys.objects
            WHERE object_id = OBJECT_ID(N'ssp_SCDeleteDirectMessage')
              AND type IN ( N'P', N'PC' ))
BEGIN
    DROP PROCEDURE ssp_SCDeleteDirectMessage;
END;
GO

CREATE PROCEDURE ssp_SCDeleteDirectMessage
    @DirectMessageId INT,
    @CurrentUser VARCHAR(30),
    @FromBackEnd BIT = 0
AS /******************************************************************************
**		File: 
**		Name: ssp_SCDeleteDirectMessage
**		Desc: 
**
**              
**		Return values:
** 
**		Called by: DirectMessageAjax.ashx > DeleteMessage
**              
**		Parameters:
**
**		Auth: jcarlson
**		Date: 7/11/2017
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		    Author:				    Description:
**		--------		--------				------------------------------
**      7/11/2017       jcarlson	            created
**		8/22/2017		jcarlson				Removed DirectMessageEmails as this is not going to be used currently.
*******************************************************************************/
BEGIN TRY
    BEGIN TRAN;
    DECLARE @CurrentDate DATETIME = GETDATE();
    DECLARE @Delete INT;

    SELECT @Delete = GlobalCodeId
      FROM GlobalCodes
     WHERE Category                   = 'DirectMessageStatus'
       AND Code                       = CASE
                                             WHEN @FromBackEnd = 0 THEN 'D'
                                             ELSE 'DMVS' END
       AND ISNULL(RecordDeleted, 'N') = 'N';

    UPDATE a
       SET a.RecordDeleted = 'Y',
           a.DeletedBy = @CurrentUser,
           a.DeletedDate = @CurrentDate
      FROM dbo.DirectMessageAttachments AS a
     WHERE a.DirectMessageId = @DirectMessageId;
    UPDATE a
       SET a.RecordDeleted = 'Y',
           a.DeletedBy = @CurrentUser,
           a.DeletedDate = @CurrentDate,
           a.MessageStatus = @Delete
      FROM dbo.DirectMessages AS a
     WHERE a.DirectMessageId = @DirectMessageId;



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
          + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCDeleteDirectMessage') + '*****'
          + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
          + CONVERT(VARCHAR, ERROR_STATE());
    RAISERROR(@Error, 16, 1);

END CATCH;