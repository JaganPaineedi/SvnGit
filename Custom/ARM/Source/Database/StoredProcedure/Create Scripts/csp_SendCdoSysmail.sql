/****** Object:  StoredProcedure [dbo].[csp_SendCdoSysmail]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SendCdoSysmail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SendCdoSysmail]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SendCdoSysmail]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE  PROCEDURE [dbo].[csp_SendCdoSysmail] 
   @From varchar(1024) ,
   @To varchar(1024) ,
   @Subject varchar(1024)=" ",
   @Body text
/*********************************************************************

This stored procedure takes the parameters and sends an e-mail. 
All the mail configurations are hard-coded in the stored procedure. 
Comments are added to the stored procedure where necessary.
References to the CDOSYS objects are at the following MSDN Web site:
http://msdn.microsoft.com/library/default.asp?url=/library/en-us/cdosys/html/_cdosys_messaging.asp

***********************************************************************/ 
   AS

/*
	DROP TABLE dbo.cstm_email_configuration

	CREATE TABLE dbo.cstm_email_configuration
	(
		PropertyName varchar(900)	not null primary key,
		property_desc varchar(1024)	not null,
		PropertyValue varchar(1024) null 	-- leave empty if you don''t want to to set the value at all
	)

	insert into dbo.cstm_email_configuration values
	(
		''http://schemas.microsoft.com/cdo/configuration/sendusing'',
		''Defines to send using via directory pickup (1) or port (2)'',
		''2''
	)

	insert into dbo.cstm_email_configuration values
	(
		''http://schemas.microsoft.com/cdo/configuration/smtpserver'',
		''Name of the SMTP server'',
		''RWD-EXC01''	-- Can be just server name if internal server
	)

	insert into dbo.cstm_email_configuration values
	(
		''http://schemas.microsoft.com/cdo/configuration/smtpserverport'',
		''Server TCP port for SMTP mail (usually 25)'',
		''25''
	)

	insert into dbo.cstm_email_configuration values
	(
		''http://schemas.microsoft.com/cdo/configuration/sendemailaddress'',
		''User e-maill address used when connecting to the SMTP server'',
		NULL
	)

	insert into dbo.cstm_email_configuration values
	(
		''http://schemas.microsoft.com/cdo/configuration/sendusername'',
		''Username used for basic SMTP authentication'',
		NULL	-- not needed if using NTLM authentication
	)

	insert into dbo.cstm_email_configuration values
	(
		''http://schemas.microsoft.com/cdo/configuration/sendpassword'',
		''Password used for basic SMTP authentication'',
		NULL		-- not needed if using NTLM authentication
	)

	insert into dbo.cstm_email_configuration values
	(
		''http://schemas.microsoft.com/cdo/configuration/smtpauthenticate'',
		''Indicates the type of authentication to be used for SMTP.  0 = None; 1 = Basic; 2 = NTLM (Windows Authentication)'',
		''2''
	)

*/

   Declare @iMessage int
   Declare @Hr int
   Declare @Source varchar(255)
   Declare @Description varchar(500)
   Declare @Output varchar(1000)

DECLARE
	@PropertyName	VARCHAR(900),
	@PropertyValue	VARCHAR(1024),
	@ConfigurationName VARCHAR(4000)

DECLARE cConfiguration CURSOR FAST_FORWARD FOR
SELECT
	PropertyName,
	PropertyValue
FROM dbo.[CustomEmailConfigurations]
WHERE PropertyValue IS NOT NULL

--************* Create the CDO.Message Object ************************
   EXEC @Hr = sp_OACreate ''CDO.Message'', @iMessage OUT

--***************Configuring the Message Object ******************
-- This is to configure a remote SMTP server.
-- http://msdn.microsoft.com/library/default.asp?url=/library/en-us/cdosys/html/_cdosys_schema_configuration_sendusing.asp

OPEN cConfiguration

FETCH cConfiguration INTO @PropertyName, @PropertyValue

WHILE @@FETCH_STATUS = 0
BEGIN
	SET @ConfigurationName = ''Configuration.fields("'' + @PropertyName + ''").Value''

	EXEC @Hr = sp_OASetProperty @iMessage, @ConfigurationName, @PropertyValue
	
	IF @Hr <> 0 GOTO error
	
	FETCH cConfiguration INTO @PropertyName, @PropertyValue

END

CLOSE cConfiguration

DEALLOCATE cConfiguration

-- Save the configurations to the message object.
   EXEC @Hr = sp_OAMethod @iMessage, ''Configuration.Fields.Update'', null
if @Hr <> 0 goto error


-- Set the e-mail parameters.
   EXEC @Hr = sp_OASetProperty @iMessage, ''To'', @To
if @Hr <> 0 goto error
   EXEC @Hr = sp_OASetProperty @iMessage, ''From'', @From
if @Hr <> 0 goto error
   EXEC @Hr = sp_OASetProperty @iMessage, ''Subject'', @Subject
if @Hr <> 0 goto error

   EXEC @Hr = sp_OAMethod @iMessage, ''Fields.Update'', null
if @Hr <> 0 goto error

-- If you are using HTML e-mail, use ''HTMLBody'' instead of ''TextBody''.
   EXEC @Hr = sp_OASetProperty @iMessage, ''TextBody'', @Body
if @Hr <> 0 goto error
   EXEC @Hr = sp_OAMethod @iMessage, ''Send'', NULL
if @Hr <> 0 goto error

   EXEC @Hr = sp_OADestroy @iMessage
if @Hr <> 0 goto error

return 0

error:
-- Sample error handling.
   IF @Hr <>0 
     select @Hr
     BEGIN
       EXEC @Hr = sp_OAGetErrorInfo NULL, @Source OUT, @Description OUT
       IF @Hr = 0
         BEGIN
           SELECT @Output = ''  Source: '' + @Source
           PRINT  @Output
           SELECT @Output = ''  Description: '' + @Description
           PRINT  @Output
         END
       ELSE
         BEGIN
           PRINT ''  sp_OAGetErrorInfo failed.''
           RETURN
         END
     END

-- Do some error handling after each step if you have to.
-- Clean up the objects created.
   EXEC @Hr = sp_OADestroy @iMessage

RETURN 1
' 
END
GO
