/****** Object:  StoredProcedure [dbo].[csp_JobScannedLabReviewAssignment]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_JobScannedLabReviewAssignment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_JobScannedLabReviewAssignment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_JobScannedLabReviewAssignment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_JobScannedLabReviewAssignment] as
/********************************************************************/
/* Stored Procedure: [csp_JobScannedLabReviewAssignment]			*/
/* Copyright: 2012 Streamline Healthcare Solutions,  LLC            */
/* Creation Date: [date]                                            */
/*                                                                  */
/* Purpose: [purpose												*/
/*                                                                  */
/* Input Parameters:   [params]										*/
/*                                                                  */
/* Output Parameters:   None										*/
/*                                                                  */
/* Return:  [return]												*/
/*                                                                  */
/* Called By:  [calledby]											*/
/*																	*/
/* Calls:															*/
/*																	*/
/* Data Modifications:												*/
/*																	*/
/* Updates:															*/
/*   Date   Author      Purpose										*/
/*																	*/
/********************************************************************/


begin try
begin tran

--declare @LabReviewDocumentCodeId int = 101001
declare @DocumentsAffected table (
	DocumentId int
)

update d set
	AuthorId = CAST(gc.ExternalCode1 as int)
output inserted.DocumentId into @DocumentsAffected(DocumentId)
from Documents as d
join CustomScannedMetadataFormLabResults as md on md.DocumentId = d.DocumentId
join dbo.GlobalCodes as gc on gc.GlobalCodeId = md.RouteToStaffId
where d.Status = 21
and md.RouteToStaffId is not null
and md.DateRoutedToStaff is null

update mf set
	DateRoutedToStaff = GETDATE()
from CustomScannedMetadataFormLabResults as mf
join @DocumentsAffected as da on da.DocumentId = mf.DocumentId

--select *
--
--select * from dbo.DocumentSignatures as ds where DATEDIFF(DAY, CreatedDate, GETDATE()) = 0
--select * from dbo.Documents where DocumentId = 275

--join @DocumentsAffected as da on da.DocumentId = ds.DocumentId


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
