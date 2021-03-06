/****** Object:  StoredProcedure [dbo].[csp_validateCustomConnectionsNotes]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomConnectionsNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomConnectionsNotes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomConnectionsNotes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE   PROCEDURE [dbo].[csp_validateCustomConnectionsNotes]
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

Select ''CustomConnectionsNotes'', ''EmploymentStatus'', ''EmploymentStatus must be selected''
	From CustomConnectionsNotes
	Where DocumentVersionId = @DocumentVersionId
	and isnull(EmploymentStatus,'''')=''''
	and isnull(recordDeleted,''N'')=''N''
Union
Select ''CustomConnectionsNotes'', ''HoursWorked'', ''Hours worked must be specified''
	From CustomConnectionsNotes
	Where DocumentVersionId = @DocumentVersionId
	and HoursWorked is null
	and isnull(recordDeleted,''N'')=''N''
Union
Select ''CustomConnectionsNotes'', ''Location'', ''Location must be selected''
	From CustomConnectionsNotes
	Where DocumentVersionId = @DocumentVersionId
	and isnull(Location,'''')=''''
	and isnull(recordDeleted,''N'')=''N''
Union
Select ''CustomConnectionsNotes'', ''Purpose'', ''Purpose must be selected''
	From CustomConnectionsNotes
	Where DocumentVersionId = @DocumentVersionId
	and isnull(Purpose,'''')=''''
	and isnull(recordDeleted,''N'')=''N''
Union
Select ''CustomConnectionsNotes'', ''OnTime'', ''Please comment about contact''
	from CustomConnectionsNotes
	where DocumentVersionId = @DocumentVersionId
	and	isnull(OnTime,'''') = ''''
	and isnull(recordDeleted,''N'')=''N''
--	and	isnull(Hygiene,'''') = ''''
--	and	isnull(Appearance,'''') = ''''
--	and	isnull(SatisfactoryWork,'''') = ''''
--	and	isnull(ProductiveWork,'''') = ''''
--	and	isnull(ProductiveSession,'''') = ''''
--	and	isnull(AppropriatePlacement,'''') = ''''
--	and	isnull(InteractSupervisor,'''') = ''''
--	and	isnull(InteractCoWorker,'''') = ''''
--	and	isnull(convert(varchar(8000),Narrative),'''') = ''''
--	and	isnull(a.recordDeleted,''N'') <> ''Y''


--
--Check to make sure record exists in custom table for @DocumentCodeId
--
If not exists (Select 1 from CustomConnectionsNotes Where DocumentVersionId = @DocumentVersionId)
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

Select ''CustomConnectionsNotes'', ''DeletedBy'', ''Error occurred. Please contact your system administrator. No record exists in custom table.''
Where not exists  (Select 1 from CustomConnectionsNotes Where DocumentVersionId = @DocumentVersionId)
end




if @@error <> 0 goto error

return

error:
raiserror 50000 ''csp_validateCustomConnections failed.  Contact your system administrator.''
' 
END
GO
