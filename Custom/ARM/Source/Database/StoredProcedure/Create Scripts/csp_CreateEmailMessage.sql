/****** Object:  StoredProcedure [dbo].[csp_CreateEmailMessage]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CreateEmailMessage]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CreateEmailMessage]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CreateEmailMessage]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE  PROCEDURE [dbo].[csp_CreateEmailMessage]
	@FromAddress			Varchar(1024),
	@ToAddress			Varchar(1024),
	@SubjectLine			Varchar(1024),
	@MessageBody			Varchar(8000),
	@MessageSourceApplication	Varchar(128) = NULL,
	@MessageSourceKey		Varchar(1024) = NULL
AS

BEGIN TRAN

INSERT INTO [dbo].[CustomEmailMessages]
(
	FromAddress,
	ToAddress,
	SubjectLine,
	MessageBody,
	MessageSourceApplication,
	MessageSourceKey	
)
VALUES
(
	@FromAddress,
	@ToAddress,
	@SubjectLine,
	@MessageBody,
	@MessageSourceApplication,
	@MessageSourceKey

)

IF @@ERROR <> 0 GOTO error

COMMIT TRAN
IF @@ERROR <> 0 GOTO error

RETURN 0

error:

ROLLBACK TRAN
RAISERROR(''csp_CreateEmailMessage: error encountered.  Contact tech support.'', 16, 1)
RETURN 1
' 
END
GO
