/****** Object:  StoredProcedure [dbo].[csp_DFACreateFormSection]    Script Date: 12/26/2014 16:03:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[csp_DFACreateFormSection]
	@FormId int,
	@SortOrder int,
	@PlaceOnTopOfPage CHAR(1),
	@SectionLabel	varchar(1000),
	@Active	CHAR(1),
	@SectionEnableCheckBox	CHAR(1),
	@SectionEnableCheckBoxText	varchar(500),
	@SectionEnableCheckBoxColumnName	varchar(100),
	@NumberOfColumns	int,
	@ShowPencilIcon type_YOrN,
	@FormSectionId int output,
	@abortIfExists char(1) = 'Y'
as
begin try

begin tran
set @FormSectionId = null

select @FormSectionId = FormSectionId from dbo.FormSections where FormId = @FormId and SortOrder = @SortOrder and ISNULL(RecordDeleted, 'N') <> 'Y'

if @FormSectionId is not null
begin
	if @abortIfExists = 'Y' raiserror('Form section with sort order already exists and @abortIfExists = "Y"', 16, 1)
	
	update dbo.FormSections set
		PlaceOnTopOfPage = ISNULL(@PlaceOnTopOfPage, 'N'),
		SectionLabel = @SectionLabel,
		Active = @Active,
		SectionEnableCheckBox = @SectionEnableCheckBox,
		SectionEnableCheckBoxText = @SectionEnableCheckBoxText,
		SectionEnableCheckBoxColumnName = @SectionEnableCheckBoxColumnName,
		NumberOfColumns = @NumberOfColumns,
		ShowPencilIcon = @ShowPencilIcon
	where FormSectionId = @FormSectionId
	
end
else
begin
	insert into dbo.FormSections
	        (
	         FormId,
	         SortOrder,
	         PlaceOnTopOfPage,
	         SectionLabel,
	         Active,
	         SectionEnableCheckBox,
	         SectionEnableCheckBoxText,
	         SectionEnableCheckBoxColumnName,
	         NumberOfColumns,
	         ShowPencilIcon
	        )
	values  (
			@FormId,
			@SortOrder,
			ISNULL(@PlaceOnTopOfPage, 'N'),
			@SectionLabel,
			@Active,
			@SectionEnableCheckBox,
			@SectionEnableCheckBoxText,
			@SectionEnableCheckBoxColumnName,
			@NumberOfColumns,
			@ShowPencilIcon
	        )	


	set @FormSectionId = SCOPE_IDENTITY()
end

commit tran

end try
begin catch
if @@TRANCOUNT > 0 rollback tran
declare @error_message nvarchar(4000)
set @error_message = ERROR_PROCEDURE() + ': Line: ' + CAST(ERROR_LINE() as varchar) + ' - ' + ERROR_MESSAGE()

raiserror (@error_message, 16, 1)
end catch
