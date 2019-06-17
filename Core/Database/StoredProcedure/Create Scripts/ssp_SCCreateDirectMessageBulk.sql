IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'ssp_SCCreateDirectMessageBulk')
                    AND type IN ( N'P', N'PC' ) )
    BEGIN
        DROP PROCEDURE ssp_SCCreateDirectMessageBulk;
    END;
GO

CREATE PROCEDURE ssp_SCCreateDirectMessageBulk
@StaffId INT,
@Xml NVARCHAR(MAX),
@XmlList NVARCHAR(MAX)
AS
/******************************************************************************
**		File: 
**		Name: ssp_SCCreateDirectMessageBulk
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
**      8/15/2017       jcarlson				created
**	   8/22/2017		jcarlson				Added "InReplyTo" to be saved to database
**	   8/28/2018	    jcarlson				Fixed bug where duplicate attachment entries where being created
												Fixed bug where attachments from the incoming message where being associated to the outgoing message with the same HISP MessageId if the user sent a message to themselves
**		12/28/2018		jcarlson				Harbor Support 1793 - Added logic to log the arguments to the error log in case of error. This should assist in debugging.			
*******************************************************************************/
    BEGIN TRY
	BEGIN TRAN

	DECLARE @Messages XML = CONVERT(XML,@Xml);
	DECLARE @MessageList XML = CONVERT(XML,@XmlList);
	DECLARE @UserCode VARCHAR(30)
	SELECT @UserCode = st.UserCode
	FROM Staff AS st
	WHERE st.StaffId = @StaffId

	DECLARE @DirectAccountId INT 
	SELECT @DirectAccountId = DirectAccountId
	FROM dbo.DirectAccounts 
	WHERE StaffId = @StaffId
	AND ISNULL(RecordDeleted,'N')='N'

	DECLARE @NewMessage INT;
SELECT @NewMessage = GlobalCodeId
FROM dbo.GlobalCodes
WHERE Category = 'DirectMessageStatus'
AND Code = 'R'
AND ISNULL(RecordDeleted,'N')='N'

	SELECT 
	a.value('(MessageId)[1]','varchar(max)') AS MessageId,
	a.value('(ReceivedDate)[1]','DateTime') AS RecievedDate,
	a.value('(SentDate)[1]','DateTime') AS SentDate,
	a.value('(Uid)[1]','varchar(max)') AS [Uid]
	INTO #MessageList
	FROM @MessageList.nodes('/DirectMessageSummary/Messages/DirectMessageBrief') AS One(a)
	
	SELECT x.value('(MessageId)[1]','varchar(max)') AS MessageId,
	x.value('(Description)[1]','varchar(max)') AS [Description],
	x.value('(State)[1]','varchar(max)') AS [State],
	x.value('(Sender)[1]','varchar(max)') AS Sender,
	x.value('(From)[1]','varchar(max)') AS [FROM],
	x.value('(Subject)[1]','varchar(max)') AS [Subject],
	b.value('(Content)[1]','varchar(max)') AS Body,
	a.value('(AttachmentId)[1]','varchar(max)') AS AttachmentId,
	a.value('(FileName)[1]','varchar(max)') AS [FileName],
	a.value('(MimeType)[1]','varchar(max)') AS MimeType,
	x.value('(InReplyTo)[1]','varchar(max)') AS InReplyTo
	INTO #Messages
	FROM @Messages.nodes('/ArrayOfDirectMessageResponse/DirectMessageResponse') AS One(x)
	Outer APPLY One.x.nodes('Attachment/DirectMessageResponseAttachment') AS Two(a)
	OUTER APPLY One.x.nodes('Body/DirectMessageBody') AS Three(b)

	CREATE TABLE #Output (
	DirectMessageId INT,
	MessageId VARCHAR(MAX)
	)
	INSERT INTO dbo.DirectMessages ( CreatedBy,ModifiedBy, MessageType, MessageId, MessageFrom,
	                                  MessageInReplyTo, MessageSubject, MessageBody, MessageBodyMimeType, MessageState, MessageDescription, MessageReceivedDate,
	                                  MessageSentDate, MessageUid, StaffId, StaffDirectMessageEmail, ClientDisclosureId, MessageStatus, MessageTo, MessageCC,
	                                  MessageBCC, MessageRead,DirectAccountId )
	
	SELECT DISTINCT @UserCode,@UserCode,'I', a.MessageId,a.[FROM],a.InReplyTo,a.[Subject],a.Body,'plain/text',a.[State],a.[Description],b.RecievedDate,b.SentDate,b.[Uid],@StaffId,NULL,NULL,@NewMessage,NULL,NULL,NULL,N'N',@DirectAccountId
	FROM #Messages AS a
	JOIN #MessageList AS b ON b.MessageId = a.MessageId
	WHERE NOT EXISTS (SELECT 1
						FROM dbo.DirectMessages AS dm
						WHERE ISNULL(dm.RecordDeleted,'N')='N'
						AND dm.MessageId = a.MessageId
						AND dm.MessageType = 'I'
						AND dm.StaffId = @StaffId
						AND dm.DirectAccountId = @DirectAccountId
					)
    INSERT INTO #Output ( DirectMessageId, MessageId )
    SELECT DISTINCT a.DirectMessageId, a.MessageId
	FROM dbo.DirectMessages AS a
	JOIN #Messages AS b ON a.MessageId = b.MessageId
	AND a.StaffId = @StaffId
	AND a.DirectAccountId = @DirectAccountId
	AND a.MessageType = 'I'

	INSERT INTO dbo.DirectMessageAttachments ( CreatedBy,ModifiedBy, DirectMessageId,
	                                            AttachmentId, AttachmentMimeType, AttachmentState, AttachmentDescription, AttachmentName, AttachmentSentDate,
	                                            AttachmentReceivedDate, Attachment )
	SELECT @UserCode,@UserCode,a.DirectMessageId,b.AttachmentId,b.MimeType,NULL,NULL,b.FileName,NULL,GETDATE(),NULL
	FROM #Output AS a
	JOIN #Messages AS b ON b.MessageId = a.MessageId
	AND ISNULL(b.AttachmentId,'') <> ''
	WHERE NOT EXISTS (SELECT 1
					  FROM dbo.DirectMessageAttachments AS dma
					  WHERE ISNULL(dma.RecordDeleted,'N')='N'
					  AND dma.DirectMessageId = a.DirectMessageId
					  AND dma.AttachmentId = b.AttachmentId
					  )

    COMMIT TRAN
    END TRY
    BEGIN CATCH
	IF @@Trancount > 0
	BEGIN
    ROLLBACK TRAN
	END
	declare @errorMessage varchar(max) = '@StaffId='  + convert(varchar(max),@StaffId) + CHAR(10)+CHAR(13) +
	'@Xml=' + isnull(@Xml,'No Value')  + CHAR(10)+CHAR(13) +
	'@XmlList=' + isnull(@XmlList,'No Value');
	declare @currentDate DateTime = GetDate();

	   exec ssp_SCLogError @ErrorMessage = @errorMessage,
	   @VerboseInfo = '',
	   @ErrorType = 'DM',
	   @CreatedBy = 'DM',
	   @CreatedDate = @currentDate,
	   @DataSetInfo = ''

		DECLARE @Error VARCHAR(8000);
        SELECT  @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCCreateDirectMessageBulk') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());		
        RAISERROR (	@Error,		16,	1 	);

    END CATCH;