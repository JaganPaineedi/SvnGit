/****** Object:  StoredProcedure [dbo].[csp_jobDocumentDueReminders]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_jobDocumentDueReminders]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_jobDocumentDueReminders]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_jobDocumentDueReminders]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_jobDocumentDueReminders] as
begin try
begin tran

declare @ClientId int
declare @msg varchar(max)

declare c1 insensitive cursor for
select d.ClientId, ''Map to employment review due for '' + ISNULL(c.LastName, '''') + '', '' + c.FirstName + '' within 10 days.''
--d.EffectiveDate, a.FrequencyOfReview, DATEADD(DAY, a.FrequencyOfReview, d.EffectiveDate) as DueDate, a.* 
from dbo.CustomDocumentMapToEmployments as a
join dbo.DocumentVersions as dv on dv.DocumentVersionId = a.DocumentVersionId
join dbo.Documents as d on d.CurrentDocumentVersionId = dv.DocumentVersionId
join dbo.Clients as c on c.ClientId = d.ClientId
where DATEDIFF(DAY, d.EffectiveDate, GETDATE()) between (a.FrequencyOfReview - 10)	and (a.FrequencyOfReview + 10)  -- due in 10 days or less and remind for 10 days after that
and c.Active = ''Y''
and d.Status = 22
and not exists (
	select *
	from dbo.Documents as d2
	where d2.DocumentCodeId = d.DocumentCodeId
	and d2.ClientId = d.ClientId
	and d2.Status = 22
	and d2.EffectiveDate > d.EffectiveDate
)
and ISNULL(a.RecordDeleted, ''N'') <> ''Y''
and ISNULL(dv.RecordDeleted, ''N'') <> ''Y''
and ISNULL(d.RecordDeleted, ''N'') <> ''Y''
and ISNULL(c.RecordDeleted, ''N'') <> ''Y''

open c1

fetch c1 into @ClientId, @msg

while @@FETCH_STATUS = 0
begin

	exec dbo.csp_CreateAlertHarborTreatmentTeam @TriggeringStaffId = 0, -- int
	    @ClientId = @ClientId, -- int
	    @msgSubject = ''Map to employment review due'', -- varchar(700)
	    @msgBody = @msg, -- varchar(3000)
	    @DocumentReference = null, -- int
	    @alertType = 81 -- int
	

	fetch c1 into @ClientId, @msg
end

close c1

deallocate c1


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
