/****** Object:  StoredProcedure [dbo].[csp_job_ServiceErrorsScheduledServices]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_job_ServiceErrorsScheduledServices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_job_ServiceErrorsScheduledServices]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_job_ServiceErrorsScheduledServices]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE     procedure [dbo].[csp_job_ServiceErrorsScheduledServices]
as
/*
Modified By		Modified Date	Reason
avoss			12/22/2009		added to riverwood
*/


delete from se
from services as s
join serviceerrors as se on se.serviceid = s.serviceid
where isnull(s.recorddeleted, ''N'') <> ''Y''
and s.status in (72,73,76)

declare @ServiceId int, @ClientId int, @DateOfService datetime
-- for ssp_checkwarnings
declare
	@ProcedureCodeId INT,
	@ClinicianId INT,
	@StartDate DateTime,
	@EndDate DateTime,
	@Attending VARCHAR(10),
	@DSMCode1 VARCHAR(10),
	@DSMCode2 VARCHAR(10),
	@DSMCode3 VARCHAR(10),
	@ServiceCompletionStatus VARCHAR(10),
	@ProgramId int,
	@LocationId int,
	@Degree int,
	@UnitValue decimal(9,2),
	@PreviousStatus int                 

declare cSchedServices cursor for
select distinct s.ServiceId, s.ClientId, s.DateOfService
from Services as s
join ServiceErrors as se on se.ServiceId = s.ServiceId
where s.Status = 70
and isnull(s.RecordDeleted, ''N'') <> ''Y''
order by s.dateofservice


open cSchedServices

fetch cSchedServices into @ServiceId, @ClientId, @DateOfService

while @@fetch_status = 0
begin

	begin tran

	select
		@ProcedureCodeId = s.ProcedureCodeId,
		@ClinicianId = s.ClinicianId,
		@StartDate = s.DateOfService,
		@EndDate = s.EndDateOfService,
		@Attending = null,
		@DSMCode1 = s.DiagnosisCode1,
		@DSMCode2 = s.DiagnosisCode2,
		@DSMCode3 = s.DiagnosisCode3,
		@ServiceCompletionStatus = NULL,
		@ProgramId = s.ProgramId,
		@LocationId = s.LocationId,
		@Degree = st.Degree,
		@UnitValue = s.Unit,
		@PreviousStatus = s.Status
	from Services as s
	join staff as st on st.staffid = s.ClinicianId
	where s.ServiceId = @ServiceId

	if @@error <> 0 goto err_exit

	exec ssp_CheckWarnings
		@ClientId,
		@ServiceId,
		@ProcedureCodeId,
		@ClinicianId,
		@StartDate,
		@EndDate,
		@Attending,
		@DSMCode1,
		@DSMCode2,
		@DSMCode3,
		@ServiceCompletionStatus,
		@ProgramId,
		@LocationId,
		@Degree,
		@UnitValue,
		@PreviousStatus
	
	if @@error <> 0 goto err_exit

	commit tran

	fetch cSchedServices into @ServiceId, @ClientId, @DateOfService

end

close cSchedServices

deallocate cSchedServices

return

err_exit:
if @@trancount > 0 rollback tran
raiserror(''Error resetting the warnings on scheduled services'', 16, 1)
' 
END
GO
