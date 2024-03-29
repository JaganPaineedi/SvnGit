/****** Object:  StoredProcedure [dbo].[csp_ScannedFormDTSAutofill]    Script Date: 06/19/2013 17:49:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ScannedFormDTSAutofill]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ScannedFormDTSAutofill]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ScannedFormDTSAutofill]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[csp_ScannedFormDTSAutofill]
@ImageDatabaseId int,
@IndexName  varchar(10)
/********************************************************************************
-- Stored Procedure: dbo.csp_ScannedFormDTSAutofill 
--
-- Copyright: 2006 Streamline Healthcate Solutions
--
-- Purpose: Stages index field values
--
-- Updates:                     		                                
-- Date        Author      Purpose
-- 04.11.2007  SFarber     Modified to support ImageDatabaseId.      
--
*********************************************************************************/
as

declare @IdSeparator varchar(10)
declare @IndexId varchar(6)
declare @IndexValue varchar(100)
declare @IndexValues varchar(8000)
declare @StartToken varchar(20)
declare @EndToken varchar(20)
declare @Pointer varbinary(16)
declare @StartPosition int
declare @EndPosition int
declare @DeleteLength int
declare @InsertOffset int
declare @ValueSeparator char(1)

if @IndexName not in (''CLIENT'', ''DOCUMENT'') 
  goto error

select @IdSeparator = IdSeparator,
       @IndexId = convert(varchar(6), case @IndexName
                                            when ''CLIENT''  then IndexIdClient
                                            when ''DOCUMENT'' then IndexIdDocument
                                       end),
       @ValueSeparator = char(9)
  from CustomScannedFormConfig
 where ImageDatabaseId = @ImageDatabaseId

set @StartToken = ''<AUTOFILLVALUES'' + @IndexId + ''>''
set @EndToken = ''</AUTOFILLVALUES'' + @IndexId + ''>''


select @StartPosition = PATINDEX (''%'' + @StartToken + ''%'', AttributeValue)
  from CustomScannedFormAutofillStage
 where ImageDatabaseId = @ImageDatabaseId

if @StartPosition = 0
  goto error

select @EndPosition = PATINDEX (''%'' + @EndToken + ''%'' , AttributeValue)
  from CustomScannedFormAutofillStage
 where ImageDatabaseId = @ImageDatabaseId

if @EndPosition = 0 
  goto error


set @StartPosition = @StartPosition + Len(@StartToken)
set @EndPosition = @EndPosition - 1
set @DeleteLength = @EndPosition - @StartPosition
set @InsertOffset = @StartPosition - 1


select @Pointer = TextPtr(AttributeValue) 
  from CustomScannedFormAutofillStage
 where ImageDatabaseId = @ImageDatabaseId

if TextValid(''CustomScannedFormAutofillStage.AttributeValue'', @Pointer) <> 1
  goto error


updatetext CustomScannedFormAutofillStage.AttributeValue @Pointer @InsertOffset @DeleteLength ''''

if @@error <> 0 
  goto error

set @IndexValues = ''''

declare @IncludeAllClients char(1)
select @IncludeAllClients = isnull(IncludeAllClients, ''N'')
from CustomScannedFormConfig
where ImageDatabaseId = @ImageDatabaseId


-- Get a list of customers who are active
if @IndexName = ''CLIENT''
  declare cur_value cursor for
   select c.LastName + '', '' + c.FirstName + @IdSeparator + convert(varchar(10), c.ClientId)
     from Clients c
    where (@IncludeAllClients = ''Y'' or (@IncludeAllClients = ''N'' and Active = ''Y''))
else
  declare cur_value cursor for
   select documentDescription + @IdSeparator + documentName
     from DocumentCodes
    where documentName like ''SMF_%''
      and isnull(recordDeleted,''N'') <> ''Y''
    order by 1 desc

if @@error <> 0 goto error

open cur_value
if @@error <> 0 goto error

fetch cur_value into @IndexValue

if @@error <> 0 goto error

while @@fetch_status = 0
begin
  set @IndexValues = LTrim(RTrim(@IndexValues + @IndexValue)) + @ValueSeparator

  if Len(@IndexValues) > 4000
  begin
    updatetext CustomScannedFormAutofillStage.AttributeValue @Pointer @InsertOffset 0 @IndexValues

    if @@error <> 0 
      goto error
    
    set @IndexValues = ''''
  end

  fetch cur_value into @IndexValue
end

close cur_value
if @@error <> 0 goto error

deallocate cur_value
if @@error <> 0 goto error

-- Write the last chunck
if Len(@IndexValues) > 0
begin
  updatetext CustomScannedFormAutofillStage.AttributeValue @Pointer @InsertOffset 0 @IndexValues

  if @@error <> 0 
    goto error
end

updatetext CustomScannedFormAutofillStage.AttributeValue @Pointer @InsertOffset 0 @ValueSeparator
if @@error <> 0 
  goto error


error:

return
' 
END
GO
