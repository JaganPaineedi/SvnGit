/****** Object:  StoredProcedure [dbo].[csp_DFACreateForm]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_DFACreateForm]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_DFACreateForm]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_DFACreateForm]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_DFACreateForm]
	@FormName	varchar(1000),
	@TableName	varchar(100),
	@TotalNumberOfColumns	int,
	@Active	char(1),
	@RetrieveStoredProcedure varchar(100),
	@FormId int output,
	@abortIfExists char(1) = ''Y''
as
begin try

begin tran

set @FormId = null

select @FormId = FormId from dbo.Forms where FormName = @FormName and ISNULL(RecordDeleted, ''N'') <> ''Y''

if @FormId is not null
begin
	if @abortIfExists = ''Y'' raiserror(''Form with name already exists and @abortIfExists = "Y"'', 16, 1)
	
	update dbo.Forms set
		TableName = @TableName,
		TotalNumberOfColumns = @TotalNumberOfColumns,
		Active = @Active,
		RetrieveStoredProcedure = @RetrieveStoredProcedure
	where FormId = @FormId
end
else
begin

	insert into dbo.Forms
	        (
	         FormName,
	         TableName,
	         TotalNumberOfColumns,
	         Active,
	         RetrieveStoredProcedure
	        )
	values  (
	         @FormName, -- FormName - varchar(1000)
	         @TableName, -- TableName - varchar(100)
	         @TotalNumberOfColumns, -- TotalNumberOfColumns - int
	         @Active, -- Active - type_Active
	         @RetrieveStoredProcedure  -- RetrieveStoredProcedure - varchar(100)
	        )

	set @FormId = SCOPE_IDENTITY()
end

commit tran

end try
begin catch
if @@TRANCOUNT > 0 rollback tran
declare @error_message nvarchar(4000)
set @error_message = ERROR_PROCEDURE() + '': Line: '' + CAST(ERROR_LINE() as varchar) + '' - '' + ERROR_MESSAGE()

raiserror (@error_message, 16, 1)
end catch

' 
END
GO
