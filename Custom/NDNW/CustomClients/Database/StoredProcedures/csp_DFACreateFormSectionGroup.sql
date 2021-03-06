/****** Object:  StoredProcedure [dbo].[csp_DFACreateFormSectionGroup]    Script Date: 12/26/2014 16:03:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[csp_DFACreateFormSectionGroup]
	@FormSectionId	int,
	@GroupName varchar(100),
	@SortOrder	int,
	@GroupLabel	varchar(1000),
	@Active	CHAR(1),
	@GroupEnableCheckBox	CHAR(1),
	@GroupEnableCheckBoxText	varchar(500),
	@GroupEnableCheckBoxColumnName	varchar(100),
	@NumberOfItemsInRow	int,
	@ShowPencilIcon	type_YOrN,
	@FormSectionGroupId int output,
	@abortIfExists char(1) = 'Y'
as
begin try

begin tran
set @FormSectionGroupId = null

select @FormSectionGroupId = FormSectionGroupId from dbo.FormSectionGroups where FormSectionId = @FormSectionId and SortOrder = @SortOrder and ISNULL(RecordDeleted, 'N') <> 'Y'

if @FormSectionGroupId is not null
begin
	if @abortIfExists = 'Y' raiserror('Form section group with sort order already exists and @abortIfExists = "Y"', 16, 1)
	
	update dbo.FormSectionGroups set
		GroupName = @GroupName,
		SortOrder = @SortOrder,
		GroupLabel = @GroupLabel,
		Active = @Active,
		GroupEnableCheckBox = @GroupEnableCheckBox,
		GroupEnableCheckBoxText = @GroupEnableCheckBoxText,
		GroupEnableCheckBoxColumnName = @GroupEnableCheckBoxColumnName,
		NumberOfItemsInRow = @NumberOfItemsInRow,
		ShowPencilIcon = @ShowPencilIcon
	where FormSectionGroupId = @FormSectionGroupId
	
end
else
begin
	insert into dbo.FormSectionGroups
	        (
			FormSectionId,
			GroupName,
			SortOrder,
			GroupLabel,
			Active,
			GroupEnableCheckBox,
			GroupEnableCheckBoxText,
			GroupEnableCheckBoxColumnName,
			NumberOfItemsInRow,
			ShowPencilIcon
	        )
	values  (
			@FormSectionId,
			@GroupName,
			@SortOrder,
			@GroupLabel,
			@Active,
			@GroupEnableCheckBox,
			@GroupEnableCheckBoxText,
			@GroupEnableCheckBoxColumnName,
			@NumberOfItemsInRow,
			@ShowPencilIcon
	        )	

	set @FormSectionGroupId = SCOPE_IDENTITY()
end

commit tran

end try
begin catch
if @@TRANCOUNT > 0 rollback tran
declare @error_message nvarchar(4000)
set @error_message = ERROR_PROCEDURE() + ': Line: ' + CAST(ERROR_LINE() as varchar) + ' - ' + ERROR_MESSAGE()

raiserror (@error_message, 16, 1)
end catch
