/****** Object:  UserDefinedFunction [dbo].[csf_PMServiceCalculateCharge]    Script Date: 06/19/2013 18:03:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_PMServiceCalculateCharge]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[csf_PMServiceCalculateCharge]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_PMServiceCalculateCharge]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'create function [dbo].[csf_PMServiceCalculateCharge] (@ServiceId int) RETURNS money AS
begin

declare @retval int

declare @ClientId int, @DateOfService datetime, @ClinicianId int, 
@ProcedureCodeId int, @Units int, @ProgramId int, @LocationId int,
@ProcedureRateId int, @Charge money, @Degree int


-- Get Service Info
select @ClientId = s.ClientId, @DateOfService = s.DateOfService, @ClinicianId = s.ClinicianId,
@ProcedureCodeId = s.ProcedureCodeId, @Units = s.Unit, @ProgramId = s.ProgramId, @LocationId = s.LocationId,
@Degree = st.Degree
from Services as s
left outer join Staff as st on st.StaffId = s.ClinicianId
where s.ServiceId = @ServiceId

if @@rowcount = 0 goto no_service_info

select top 1 @ProcedureRateId = PR.ProcedureRateId, 
@Charge = (Case PR.ChargeType when ''E'' then PR.Amount -- For Exactly
when ''R'' then PR.Amount -- For Range 
when ''P'' then (PR.Amount)*convert(decimal(10,2),(@Units/convert(int,PR.FromUnit))) end) 
from ProcedureRates PR
LEFT JOIN ProcedureRateDegrees PRD ON (PR.ProcedureRateId = PRD.ProcedureRateId
and isnull(PRD.RecordDeleted,''N'') = ''N'')
LEFT JOIN ProcedureRateLocations PRL ON (PR.ProcedureRateId = PRL.ProcedureRateId
and isnull(PRL.RecordDeleted,''N'') = ''N'')
LEFT JOIN ProcedureRatePrograms PRP ON (PR.ProcedureRateId = PRP.ProcedureRateId
and isnull(PRP.RecordDeleted,''N'') = ''N'')
LEFT JOIN ProcedureRateStaff PRS ON (PR.ProcedureRateId = PRS.ProcedureRateId
and isnull(PRS.RecordDeleted,''N'') = ''N'')
where isnull(PR.RecordDeleted,''N'') = ''N''
and PR.CoveragePlanId is  null
and PR.ProcedureCodeId = @ProcedureCodeId
and PR.FromDate <= @DateOfService
and (dateadd(dd, 1, PR.ToDate) > @DateOfService or PR.ToDate is null)
and (PR.ChargeType <> ''P'' or @Units >= PR.FromUnit)
and (PR.ChargeType <> ''E'' or PR.FromUnit = @Units)
and (PR.ChargeType <> ''R'' or (@Units >= PR.FromUnit and @Units <= PR.ToUnit))
and (PRP.ProgramId is null or PRP.ProgramId = @ProgramId)
and (PRD.Degree is null or PRD.Degree = @Degree)
and (PRL.LocationId is null or PRL.LocationId = @LocationId)
and (PRS.StaffId is null or PRS.StaffId = @ClinicianId)
and (PR.ClientId is null or PR.ClientId = @ClientId)
order by PR.Priority ASC, 
(case when PRP.programId= @ProgramId then 1 else 0 end +
case when PRL.LocationId= @LocationId then 1 else 0 end +
case when PRD.Degree= @Degree then 1 else 0 end +
case when PR.ClientId= @ClientId then 1 else 0 end +
case when PRS.StaffId = @ClinicianId then 1 else 0 end) DESC

if @@error <> 0 goto select_error

return @Charge

no_service_info:
	return null

select_error:
	return -$1

end
' 
END
GO
