/****** Object:  StoredProcedure [dbo].[csp_validateCustomMiscellaneousNotes]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomMiscellaneousNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomMiscellaneousNotes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomMiscellaneousNotes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE    PROCEDURE [dbo].[csp_validateCustomMiscellaneousNotes]
@DocumentVersionId	Int--,@documentCodeId	Int
as

Insert into #validationReturnTable
(TableName,
ColumnName,
ErrorMessage
)
--This validation returns three fields
--Field1 = TableName
--Field2 = ColumnName
--Field3 = ErrorMessage
--select * from CustomMiscellaneousNotes

Select ''CustomMiscellaneousNotes'', ''Narration'', ''Narrative must be specified.''
From CustomMiscellaneousNotes cm
Where isnull(convert(varchar(max),Narration),'''')=''''
and cm.DocumentVersionId = @DocumentVersionId

Union

Select ''CustomMiscellanousNotes'', ''DeletedBy'', ''Service - Location must be specified.''
From services s
join documents d on d.serviceid = s.serviceId
Where s.LocationId is null
and isnull(d.RecordDeleted, ''N'') = ''N''
and isnull(s.RecordDeleted, ''N'') = ''N''
and d.CurrentDocumentVersionId = @DocumentVersionId

--These procedure codes are no longer active and therefore no longer applicable - DJH - 10/28/2010
/* 
UNION
SELECT ''CustomMiscellanousNotes'', ''DeletedBy'', ''Please select proper "Primary Care" Procedure Code on Service Tab.''
FROM 
documents d 
join services sr on sr.serviceid = d.serviceid
join staff s on s.staffid = d.authorid
where sr.procedurecodeid in (538,537)  --Office Visit General, Office Procedure General
and d.CurrentDocumentVersionId = @DocumentVersionId
and isnull(d.recorddeleted, ''N'') = ''N''
and isnull(sr.recorddeleted, ''N'') = ''N''
and isnull(s.recorddeleted, ''N'') = ''N''
*/

exec [csp_validateCustomServicesTab] @DocumentVersionId--, @DocumentCodeId


--
--Check to make sure record exists in custom table for @DocumentCodeId
--
If not exists (Select 1 from CustomMiscellaneousNotes Where DocumentVersionId = @DocumentVersionId)
begin 

Insert into CustomBugTracking
(DocumentVersionId, Description, CreatedDate)
Values
(@DocumentVersionId, ''No record exists in custom table.'', GETDATE())

Insert into #validationReturnTable
(TableName,
ColumnName,
ErrorMessage
)

Select ''CustomMiscellanousNotes'', ''DeletedBy'', ''Error occurred. Please contact your system administrator. No record exists in custom table.''
Where not exists  (Select 1 from CustomMiscellaneousNotes Where DocumentVersionId = @DocumentVersionId)
end



if @@error <> 0 goto error

return

error:
raiserror 50000 ''csp_validateCustomMiscellaneousNotes failed.  Contact your system administrator.''
' 
END
GO
