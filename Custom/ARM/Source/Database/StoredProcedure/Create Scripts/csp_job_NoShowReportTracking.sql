/****** Object:  StoredProcedure [dbo].[csp_job_NoShowReportTracking]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_job_NoShowReportTracking]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_job_NoShowReportTracking]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_job_NoShowReportTracking]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_job_NoShowReportTracking]
	@procedure_category varchar(128),
	@procedure_code_name varchar(128)
/********************************************************************************/
/* Updates the cstm_NoShowReportTracking table to support the No-Show		*/
/* letter printing process.							*/
/********************************************************************************/
as

declare	@procedure_category_code int

-- get the global code for the procedure category passed to the procedure

select @procedure_category_code = gc.globalcodeid
from globalcodes as gc
where gc.category = @procedure_category
and gc.codename = @procedure_code_name

if @procedure_category_code is null goto no_global_code

--print @procedure_category_code

insert into Cstm_NoShowReportTracking(ServiceId, ClientId, CreatedDate)
Select s.ServiceId, s.ClientId, getdate()
from Services as s
join ProcedureCodes as p on (p.ProcedureCodeId = s.ProcedureCodeId)
join Programs as pr on pr.ProgramId = s.ProgramId
where
isnull(s.RecordDeleted, ''N'') <> ''Y'' 
and s.Status = 72	-- no-show
and s.DateOfService >= ''2/1/2007''
and @procedure_category_code in
(isnull(p.Category1, 0), isnull(p.Category2, 0), isnull(p.Category3, 0)) 
and not exists (	-- no pending reporting entry for client
	select * from cstm_NoShowReportTracking as t
	where t.ClientId = s.ClientId
	and (t.ReportRunDate IS NULL OR t.PotentialCancelPrintDate IS NULL)
)
and not exists (	-- no printed entry after the date of service (prevents letter reprints)
	select *
	from Cstm_NoShowReportTracking as t2
	where (t2.ServiceId = s.ServiceId)
	or ( (t2.ClientId = s.ClientId) and (datediff(day, s.DateOfService, t2.ReportRunDate) >= 0))
)
and pr.ProgramName in
(
''Outpatient Services - Albion'',
''Outpatient Services - Lakeview'',
''Outpatient Services - Downtown''
)

return 0

no_global_code:
declare @err_message varchar(128)
set @err_message = ''No global code exists for category: '' + @procedure_category + '', name: '' + @procedure_code_name
raiserror(@err_message, 16, 1)
return -1
' 
END
GO
