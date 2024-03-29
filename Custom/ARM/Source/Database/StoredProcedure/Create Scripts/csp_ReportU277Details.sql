/****** Object:  StoredProcedure [dbo].[csp_ReportU277Details]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportU277Details]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportU277Details]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportU277Details]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_ReportU277Details]
	@FromDate datetime,
	@ToDate datetime,
	@SenderId varchar(200),
	@ExcludeA220 char(1),
	@ExcludeZeroBalanceCharges char(1) = ''N''
as


select
	u.*,
	c.LastName + '', '' + c.FirstName as ClientName,
	c.ClientId,
	pc.DisplayAs,
	s.DateOfService,
	st.LastName + '', '' + st.FirstName as ClinicianName,
	cli.Units,
	cli.ChargeAmount
from CustomU277ReportData as u
join dbo.ClaimLineItems as cli on cli.ClaimLineItemId = u.ClaimLineItemId
join (
	select ClaimLineItemId, MIN(ChargeId) as ChargeId
	from dbo.ClaimLineItemCharges 
	group by ClaimLineItemId
) as clic on clic.ClaimLineItemId = cli.ClaimLineItemId
join dbo.Charges as chg on chg.ChargeId = clic.ChargeId
join dbo.Services as s on s.ServiceId = chg.ServiceId
join dbo.Clients as c on c.ClientId = s.ClientId
join dbo.ProcedureCodes as pc on pc.ProcedureCodeId = s.ProcedureCodeId
join dbo.Staff as st on st.StaffId = s.ClinicianId
where DATEDIFF(DAY, u.DateProcessed, @FromDate) <= 0
and DATEDIFF(DAY, u.DateProcessed, @ToDate) >= 0
and ((@SenderId is null) or (u.SenderId like ''%'' + @SenderId + ''%'') or (LEN(LTRIM(RTRIM(@SenderId))) = 0))
and ((@ExcludeA220 = ''N'') or (@ExcludeA220 = ''Y'' and u.Error1 <> ''A2:20''))
--and s.ServiceId = 2780609 and chg.ChargeId = 2660959
and (
	ISNULL(@ExcludeZeroBalanceCharges, ''N'') <> ''Y''
	or (
		@ExcludeZeroBalanceCharges = ''Y''
		-- charge must exist in OpenCharges table to be included
		and exists (
			select *
			from dbo.OpenCharges as oc
			where oc.ChargeId = chg.ChargeId
		)
	)
)
' 
END
GO
