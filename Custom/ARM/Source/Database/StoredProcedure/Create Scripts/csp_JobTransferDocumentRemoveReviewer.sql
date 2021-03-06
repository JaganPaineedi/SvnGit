/****** Object:  StoredProcedure [dbo].[csp_JobTransferDocumentRemoveReviewer]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_JobTransferDocumentRemoveReviewer]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_JobTransferDocumentRemoveReviewer]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_JobTransferDocumentRemoveReviewer]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_JobTransferDocumentRemoveReviewer] as

-- Remove the reviewer from a transfer document that has been sent and accepted.
begin try

begin tran

declare @documentId int, @documentVersionId int

declare cDocs insensitive cursor for
select d.DocumentId, d.CurrentDocumentVersionId
from dbo.Documents as d
join dbo.CustomDocumentTransfers as t on t.DocumentVersionId = d.CurrentDocumentVersionId
where d.Status = 25
and t.TransferStatus = 20426

open cDocs

fetch cDocs into @documentId, @documentVersionId

while @@FETCH_STATUS = 0
begin
	exec [csp_CustomDocumentTransferWorkflow]
		@ScreenKeyId = @documentId,
		@StaffId = 1,
		@CurrentUser =  ''ADMIN'',
		@CustomParameters = null

	-- Important: this references the production DocumentVersionViews table so this delete statement should only be run against production
	if DB_NAME() = ''HarborStreamlineProd''
	begin
		--print ''deleting''
		delete from DocumentVersionViews.dbo.DocumentVersionViews where DocumentVersionId = @documentVersionId
	end
	else
	begin
		delete from dbo.DocumentVersionViews where DocumentVersionId = @documentVersionId
	end
	
	
	
	fetch cDocs into @documentId, @documentVersionId


end

close cDocs

deallocate cDocs

commit tran

end try

begin catch
if @@TRANCOUNT > 0 rollback tran
declare @error_message nvarchar(4000)
set @error_message = ERROR_MESSAGE()
raiserror (@error_message, 16, 1)
end catch

' 
END
GO
