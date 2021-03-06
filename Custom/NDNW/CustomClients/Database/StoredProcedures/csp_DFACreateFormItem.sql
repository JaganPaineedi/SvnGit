/****** Object:  StoredProcedure [dbo].[csp_DFACreateFormItem]    Script Date: 12/26/2014 16:02:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[csp_DFACreateFormItem]
	@FormSectionId	int,
	@FormSectionGroupId int,
	@ItemType	type_GlobalCode,
	@ItemLabel	VARCHAR(1000),
	@SortOrder	int,
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
	@InformationIcon	type_YOrN,
	@InformationIconStoredProcedure	VARCHAR,
	@ExcludeFromPencilIcon	type_YOrN,
	@FormItemId int output,
	@abortIfExists char(1) = 'Y'
as
begin try

begin tran

set @FormItemId = null

select @FormItemId = FormItemId
from dbo.FormItems 
where FormSectionId = @FormSectionId
	and FormSectionGroupId = @FormSectionGroupId
	and SortOrder = @SortOrder
	and ISNULL(RecordDeleted, 'N') <> 'Y'


if @FormItemId is not null
begin
	if @abortIfExists = 'Y' raiserror('Form Item with sort order already exists and @abortIfExists = "Y"', 16, 1)
	
	update dbo.FormItems set
		ItemType = @ItemType,
		ItemLabel = @ItemLabel,
		SortOrder = @SortOrder,
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
		EachRadioButtonOnNewLine = @EachRadioButtonOnNewLine,
		InformationIcon = @InformationIcon,
		InformationIconStoredProcedure = @InformationIconStoredProcedure,
		ExcludeFromPencilIcon = @ExcludeFromPencilIcon
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
			EachRadioButtonOnNewLine,
			InformationIcon,
			InformationIconStoredProcedure,
			ExcludeFromPencilIcon
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
			@EachRadioButtonOnNewLine,
			@InformationIcon,
			@InformationIconStoredProcedure,
			@ExcludeFromPencilIcon
	        )	

	set @FormItemId = SCOPE_IDENTITY()
end


commit tran

end try
begin catch
if @@TRANCOUNT > 0 rollback tran
declare @error_message nvarchar(4000)
set @error_message = ERROR_PROCEDURE() + ': Line: ' + CAST(ERROR_LINE() as varchar) + ' - ' + ERROR_MESSAGE()

raiserror (@error_message, 16, 1)
end catch
