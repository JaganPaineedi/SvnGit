/****** Object:  StoredProcedure [dbo].[csp_ScannedFormDTSReport]    Script Date: 06/19/2013 17:49:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ScannedFormDTSReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ScannedFormDTSReport]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ScannedFormDTSReport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_ScannedFormDTSReport] 
@ImageDatabaseId int
/********************************************************************************
-- Stored Procedure: dbo.csp_ScannedFormDTSReport 
--
-- Copyright: 2006 Streamline Healthcate Solutions
--
-- Purpose: Prepares and sends Scanned Medical Form report
--
-- Updates:                     		                                
-- Date        Author      Purpose
-- 04.11.2007  SFarber     Modified to support ImageDatabaseId.      
--
*********************************************************************************/
as

declare @ToAddress			varchar(200),
	@FromAddress			varchar(200),
	@Subject			varchar(150),
	@SubjectLine			varchar(200),
	@MessageBody			varchar(8000),
	@ReportLine			varchar(250),
	@HeaderLine			varchar(500),
	@ScannedFormId			int,
	@ClientId			varchar(100),
	@DocumentName			varchar(100),
	@CompletedDate			varchar(10),
	@LogMessage			varchar(1000),
	@FirstError			char(1),
	@EmailCount			int

select @FromAddress = EmailFromAddress,
       @ToAddress   = EmailToAddress,
       @Subject     = EmailSubject + '' - '' + Convert(varchar(10), GetDate(), 101)
  from CustomScannedFormConfig
 where ImageDatabaseId = @ImageDatabaseId

set @HeaderLine = ''Scanned Medical Form Transformation process successfully completed.'' 
set @MessageBody = @HeaderLine
set @SubjectLine = @subject
set @FirstError = ''Y''
set @EmailCount = 0

declare cur_email cursor for
 select ScannedFormId,
        IsNull(ClientId, ''''),
        IsNull(DocumentName, ''''),
        IsNull(CompletedDate, ''''),
        LogMessage
   from CustomScannedFormStage
  where ImageDatabaseId = @ImageDatabaseId
    and LogMessage is not null
  order by ScannedFormId


if @@error <> 0 goto error

open cur_email
if @@error <> 0 goto error

fetch cur_email into @ScannedFormId,
                     @ClientId,
                     @DocumentName,
                     @CompletedDate,
                     @LogMessage

if @@error <> 0 goto error

while @@fetch_status = 0
begin
  if len(@MessageBody) > 7000
  begin

    exec csp_CreateEmailMessage	@FromAddress = @FromAddress, 
                              	@ToAddress   = @ToAddress,
                              	@SubjectLine = @SubjectLine,
                              	@MessageBody = @MessageBody

    if @@error <> 0 goto error

    
    set @MessageBody = @HeaderLine
    set @FirstError = ''Y''
    set @EmailCount = @EmailCount + 1
    set @SubjectLine = @subject + '' (Part '' + Convert(varchar, @EmailCount + 1) + '')''
  end

  -- Build email line for one record
  set @ReportLine = Replicate(''-'', 50) + char(13) + char(10) +
                     ''Form ID:      '' + char(9) + Convert(varchar, @ScannedFormId) + char(13) + char(10) +
                     ''Client:       '' + char(9) + @ClientId +  char(13) + char(10) +  
                     ''Document:     '' + char(9) + @DocumentName + char(13) + char(10) + 
                     ''Document Date:'' + char(9) + @CompletedDate + char(13) + char(10) +
                     ''Error Message:'' + char(9) + @LogMessage
 

  -- Add record to message body
  if @FirstError = ''Y''
  begin
    set @MessageBody = @MessageBody + char(13) + char(10) + char(13) + char(10) + 
                    ''The following forms could not be completed because of errors: ''
    set @FirstError = ''N''
  end 

  set @MessageBody = @MessageBody + char(13) + char(10) + @ReportLine

  fetch cur_email into @ScannedFormId,
                       @ClientId,
                       @DocumentName,
                       @CompletedDate,
                       @LogMessage

end

-- Send the last email
if Len(@MessageBody) > 0
begin

  exec csp_CreateEmailMessage	@FromAddress = @FromAddress, 
	                    	@ToAddress   = @ToAddress,
		            	@SubjectLine = @SubjectLine,
		            	@MessageBody = @MessageBody

  if @@error <> 0 goto error
end

close cur_email
if @@error <> 0 goto error

deallocate cur_email
if @@error <> 0 goto error

  
      
error:

return
' 
END
GO
