/****** Object:  StoredProcedure [dbo].[csp_ProcessEmailMessages]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ProcessEmailMessages]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ProcessEmailMessages]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ProcessEmailMessages]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_ProcessEmailMessages]
AS

DECLARE
	@MessageId			INT,
	@FromAddress			VARCHAR(1024),
	@ToAddress			VARCHAR(1024),
	@SubjectLine			VARCHAR(1024),
	@MessageBody			VARCHAR(8000),
	@MessageSourceApplication	VARCHAR(128),
	@MessageSourceKey		VARCHAR(1024)

DECLARE	@EmailStatus	INT

DECLARE cMessages INSENSITIVE CURSOR FOR
SELECT
	MessageId,
	FromAddress,
	ToAddress,
	SubjectLine,
	MessageBody,
	MessageSourceApplication,
	MessageSourceKey
FROM [dbo].[CustomEmailMessages]
WHERE
	MessageSentDate IS NULL
ORDER BY
	MessageId

OPEN cMessages

FETCH cMessages INTO
	@MessageId,
	@FromAddress,
	@ToAddress,
	@SubjectLine,
	@MessageBody,
	@MessageSourceApplication,
	@MessageSourceKey


WHILE @@FETCH_STATUS = 0
BEGIN
	BEGIN TRAN


	EXEC @EmailStatus = [dbo].[csp_sendCdoSysmail] @FromAddress, @ToAddress, @SubjectLine, @MessageBody
	IF (@@ERROR <> 0) OR (@EmailStatus <> 0) GOTO EmailError

	UPDATE [dbo].[CustomEmailMessages] SET
		MessageSentDate = GETDATE()
	WHERE
		MessageId = @MessageId

	IF (@@ERROR <> 0) GOTO EmailError

	COMMIT TRAN
	IF (@@ERROR <> 0) GOTO EmailError

	FETCH cMessages INTO
		@MessageId,
		@FromAddress,
		@ToAddress,
		@SubjectLine,
		@MessageBody,
		@MessageSourceApplication,
		@MessageSourceKey


END

CLOSE cMessages

DEALLOCATE cMessages

RETURN 0

EmailError:

ROLLBACK TRAN
RAISERROR(''E-mail Message Delivery Failure.'', 16, 1)
' 
END
GO
