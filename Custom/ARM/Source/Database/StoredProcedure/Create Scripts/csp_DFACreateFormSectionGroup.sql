/****** Object:  StoredProcedure [dbo].[csp_DFACreateFormSectionGroup]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_DFACreateFormSectionGroup]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_DFACreateFormSectionGroup]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_DFACreateFormSectionGroup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

create procedure [dbo].[csp_DFACreateFormSectionGroup]
	@FormSectionId	int,
	@SortOrder	int,
	@GroupName varchar(100),
	@GroupLabel	varchar(1000),
	@Active	CHAR(1),
	@GroupEnableCheckBox	CHAR(1),
	@GroupEnableCheckBoxText	varchar(500),
	@GroupEnableCheckBoxColumnName	varchar(100),
	@NumberOfItemsInRow	int,
	@FormSectionGroupId int output,
	@abortIfExists char(1) = ''Y''
as
begin try

begin tran
set @FormSectionGroupId = null

select @FormSectionGroupId = FormSectionGroupId from dbo.FormSectionGroups where FormSectionId = @FormSectionId and SortOrder = @SortOrder and ISNULL(RecordDeleted, ''N'') <> ''Y''

if @FormSectionGroupId is not null
begin
	if @abortIfExists = ''Y'' raiserror(''Form section group with sort order already exists and @abortIfExists = "Y"'', 16, 1)
	
	update dbo.FormSectionGroups set
		GroupName = @GroupName,
		GroupLabel = @GroupLabel,
		Active = @Active,
		GroupEnableCheckBox = @GroupEnableCheckBox,
		GroupEnableCheckBoxText = @GroupEnableCheckBoxText,
		GroupEnableCheckBoxColumnName = @GroupEnableCheckBoxColumnName,
		NumberOfItemsInRow = @NumberOfItemsInRow
	where FormSectionGroupId = @FormSectionGroupId
	
end
else
begin
	insert into dbo.FormSectionGroups
	        (
			FormSectionId,
			SortOrder,
			GroupLabel,
			Active,
			GroupEnableCheckBox,
			GroupEnableCheckBoxText,
			GroupEnableCheckBoxColumnName,
			NumberOfItemsInRow
	        )
	values  (
			@FormSectionId,
			@SortOrder,
			@GroupLabel,
			@Active,
			@GroupEnableCheckBox,
			@GroupEnableCheckBoxText,
			@GroupEnableCheckBoxColumnName,
			@NumberOfItemsInRow
	        )	

	set @FormSectionGroupId = SCOPE_IDENTITY()
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
