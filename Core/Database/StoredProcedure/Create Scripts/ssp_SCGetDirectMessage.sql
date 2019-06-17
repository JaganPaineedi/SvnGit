IF EXISTS ( SELECT
                    *
                FROM
                    sys.objects
                WHERE
                    object_id = OBJECT_ID(N'ssp_SCGetDirectMessage')
                    AND type IN ( N'P' , N'PC' ) )
    BEGIN 
        DROP PROCEDURE ssp_SCGetDirectMessage; 
    END;
                    GO

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO
CREATE PROCEDURE ssp_SCGetDirectMessage @DirectMessageId INT
AS /******************************************************************************
**		File: ssp_SCGetDirectMessage.sql
**		Name: ssp_SCGetDirectMessage
**		Desc: 
**
**		This template can be customized:
**              
**		Return values:
** 
**		Called by:   
**              
**		Parameters:
**		Input							Output
**     ----------							-----------
**
**		Auth: 
**		Date: 
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		    Author:				    Description:
**		--------		--------				-------------------------------------------
**	    11/25/2016      jcarlson			    created
*******************************************************************************/ 
    BEGIN
	
        BEGIN TRY
		--Direct Messages
        SELECT
              a.DirectMessageId, a.CreatedBy, a.CreatedDate, a.ModifiedBy, a.ModifiedDate, a.RecordDeleted, a.DeletedBy, a.DeletedDate, a.MessageType, a.MessageId,
            a.MessageFrom, a.MessageInReplyTo, a.MessageSubject, a.MessageBody, a.MessageBodyMimeType, a.MessageState, a.MessageDescription, a.MessageReceivedDate,
            a.MessageSentDate, a.MessageUid, a.StaffId, a.StaffDirectMessageEmail, a.ClientDisclosureId, a.MessageStatus, a.MessageTo, a.MessageCC, a.MessageBCC,
            a.MessageRead,a.DirectAccountId
            FROM
                dbo.DirectMessages AS a
            WHERE
                a.DirectMessageId = @DirectMessageId;

		--Get Emails
		--SELECT a.DirectMessageEmailId, a.CreatedBy, a.CreatedDate, a.ModifiedBy, a.ModifiedDate, a.RecordDeleted, a.DeletedBy, a.DeletedDate, a.DirectMessageId,
  --           a.EmailFieldType, a.EmailAddress
		--FROM dbo.DirectMessagesEmails AS a
		--WHERE ISNULL(a.RecordDeleted,'N')='N'
		--AND a.DirectMessageId = @DirectMessageId;
		DECLARE @i AS VARBINARY(max);
		--Get Email Attachments, do not get the actual attachment data
	    SELECT
              a.DirectMessageAttachmentId, a.CreatedBy, a.CreatedDate, a.ModifiedBy, a.ModifiedDate, a.RecordDeleted, a.DeletedBy, a.DeletedDate, a.DirectMessageId,
            a.AttachmentId, a.AttachmentMimeType, a.AttachmentName, a.AttachmentSentDate, a.AttachmentReceivedDate, @i AS Attachment
		FROM dbo.DirectMessageAttachments AS a
		WHERE ISNULL(a.RecordDeleted,'N')='N'
		AND a.DirectMessageId = @DirectMessageId

		
        END TRY

        BEGIN CATCH
            DECLARE @Error VARCHAR(8000);

            SET @Error = CONVERT(VARCHAR , ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000) , ERROR_MESSAGE())
                + '*****' + ISNULL(CONVERT(VARCHAR , ERROR_PROCEDURE()) , 'ssp_SCGetDirectMessage') + '*****'
                + CONVERT(VARCHAR , ERROR_LINE()) + '*****' + CONVERT(VARCHAR , ERROR_SEVERITY()) + '*****'
                + CONVERT(VARCHAR , ERROR_STATE());

            RAISERROR (
				@Error
				,-- Message text.                                                                     
				16
				,-- Severity.                                                            
				1 -- State.                                                         
				);
        END CATCH;
    END;

GO

