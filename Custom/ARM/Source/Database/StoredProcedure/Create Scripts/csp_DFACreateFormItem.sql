/****** Object:  StoredProcedure [dbo].[csp_DFACreateFormItem]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_DFACreateFormItem]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_DFACreateFormItem]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_DFACreateFormItem]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

create procedure [dbo].[csp_DFACreateFormItem]
	@FormSectionId	int,
	@FormSectionGroupId int,
	@SortOrder	int,

	@ItemType	int,
	@ItemLabel	varchar(1000),
	@Active	char(1),
	@GlobalCodeCategory	char(20),
	@ItemColumnName	varchar(100),
	@ItemRequiresComment	char(1),
	@ItemCommentColumnName	varchar(100),
	@ItemWidth	int,
	@MaximumLength	int,
	@DropdownType	char(1),
	@SharedTableName	varchar(100),
	@StoredProcedureName	varchar(100),
	@ValueField	varchar(100),
	@TextField	varchar(100),
	@MultilineEditFieldHeight	int,
	@EachRadioButtonOnNewLine	char(1),

	@FormItemId int output,
	@abortIfExists char(1) = ''Y''
as
begin try

begin tran

set @FormItemId = null

select @FormItemId = FormItemId
from dbo.FormItems 
where FormSectionId = @FormSectionId
	and FormSectionGroupId = @FormSectionGroupId
	and SortOrder = @SortOrder
	and ISNULL(RecordDeleted, ''N'') <> ''Y''


if @FormItemId is not null
begin
	if @abortIfExists = ''Y'' raiserror(''Form Item with sort order already exists and @abortIfExists = "Y"'', 16, 1)
	
	update dbo.FormItems set
		ItemType = @ItemType,
		ItemLabel = @ItemLabel,
		Active = @Active,
		GlobalCodeCategory = @GlobalCodeCategory,
		ItemColumnName = @ItemColumnName,
		ItemRequiresComment = @ItemRequiresComment,
		ItemCommentColumnName = @ItemCommentColumnName,
		ItemWidth = @ItemWidth,
		MaximumLength = @MaximumLength,
		DropdownType = @DropdownType,
		SharedTableName = @SharedTableName,
		StoredProcedureName = @StoredProcedureName,
		ValueField = @ValueField,
		TextField = @TextField,
		MultilineEditFieldHeight = @MultilineEditFieldHeight,
		EachRadioButtonOnNewLine = @EachRadioButtonOnNewLine
	where FormItemId = @FormItemId
	
end
else
begin
	insert into dbo.FormItems
	        (
			FormSectionId,
			FormSectionGroupId,
			ItemType,
			ItemLabel,
			SortOrder,
			Active,
			GlobalCodeCategory,
			ItemColumnName,
			ItemRequiresComment,
			ItemCommentColumnName,
			ItemWidth,
			MaximumLength,
			DropdownType,
			SharedTableName,
			StoredProcedureName,
			ValueField,
			TextField,
			MultilineEditFieldHeight,
			EachRadioButtonOnNewLine
	        )
	values  (
			@FormSectionId,
			@FormSectionGroupId,
			@ItemType,
			@ItemLabel,
			@SortOrder,
			@Active,
			@GlobalCodeCategory,
			@ItemColumnName,
			@ItemRequiresComment,
			@ItemCommentColumnName,
			@ItemWidth,
			@MaximumLength,
			@DropdownType,
			@SharedTableName,
			@StoredProcedureName,
			@ValueField,
			@TextField,
			@MultilineEditFieldHeight,
			@EachRadioButtonOnNewLine
	        )	

	set @FormItemId = SCOPE_IDENTITY()
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
