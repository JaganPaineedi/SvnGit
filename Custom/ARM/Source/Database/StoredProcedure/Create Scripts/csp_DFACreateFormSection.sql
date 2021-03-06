/****** Object:  StoredProcedure [dbo].[csp_DFACreateFormSection]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_DFACreateFormSection]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_DFACreateFormSection]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_DFACreateFormSection]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_DFACreateFormSection]
	@FormId int,
	@SortOrder int,
	@PlaceOnTopOfPage CHAR(1),
	@SectionLabel	varchar(1000),
	@Active	CHAR(1),
	@SectionEnableCheckBox	CHAR(1),
	@SectionEnableCheckBoxText	varchar(500),
	@SectionEnableCheckBoxColumnName	varchar(100),
	@NumberOfColumns	int,
	@FormSectionId int output,
	@abortIfExists char(1) = ''Y''
as
begin try

begin tran
set @FormSectionId = null

select @FormSectionId = FormSectionId from dbo.FormSections where FormId = @FormId and SortOrder = @SortOrder and ISNULL(RecordDeleted, ''N'') <> ''Y''

if @FormSectionId is not null
begin
	if @abortIfExists = ''Y'' raiserror(''Form section with sort order already exists and @abortIfExists = "Y"'', 16, 1)
	
	update dbo.FormSections set
		PlaceOnTopOfPage = ISNULL(@PlaceOnTopOfPage, ''N''),
		SectionLabel = @SectionLabel,
		Active = @Active,
		SectionEnableCheckBox = @SectionEnableCheckBox,
		SectionEnableCheckBoxText = @SectionEnableCheckBoxText,
		SectionEnableCheckBoxColumnName = @SectionEnableCheckBoxColumnName,
		NumberOfColumns = @NumberOfColumns
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
	         NumberOfColumns
	        )
	values  (
			@FormId,
			@SortOrder,
			ISNULL(@PlaceOnTopOfPage, ''N''),
			@SectionLabel,
			@Active,
			@SectionEnableCheckBox,
			@SectionEnableCheckBoxText,
			@SectionEnableCheckBoxColumnName,
			@NumberOfColumns
	        )	


	set @FormSectionId = SCOPE_IDENTITY()
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
