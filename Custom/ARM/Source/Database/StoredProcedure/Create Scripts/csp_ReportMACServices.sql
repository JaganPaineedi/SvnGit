/****** Object:  StoredProcedure [dbo].[csp_ReportMACServices]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportMACServices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportMACServices]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportMACServices]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE          procedure [dbo].[csp_ReportMACServices]
@StartDate datetime = null, 
@EndDate datetime = null,
@Status char(10) = null

as

Create Table #Services
(ServiceId 	int null,
 ClientId	int null,
 ClientName	varchar(150) null,
 ClinicianId	int null,
 ClinicianName  varchar(150) null,
 DateOfService  DateTime null,
 ProcedureCodeId int null,
 ProcedureCodeName	varchar(150) null,
 Unit		int null,
 BillableUnits	int null,
 Charge		money null,
 Status 	char(10),
 ChargeExists	char(1) null,
 ProgramId	int null,
 LocationID	int null,
 Billable	char(1) null)

 
--Insert get initial service data

	Insert Into #Services
	(ServiceId,
	 ClientId,
	 ClientName,
	 ClinicianId,
	 ClinicianName,
	 DateOfService,
	 ProcedureCodeId,
	 ProcedureCodeName,
	 Unit,
	 Status,
	 ProgramId,
	 LocationId,
	 Billable)
	
	Select s.ServiceId,
	 s.ClientId,
	 c.LastName + '', '' + c.Firstname,
	 s.ClinicianId,
	 st.LastName + '', ''+ st.firstname,
	 s.DateOfService,
	 s.ProcedureCodeId,
	 pc.DisplayAs,
	 s.Unit,
	 gc.CodeName,
	 s.ProgramId,
	 s.LocationId,
	 s.Billable
	From Services s
	Join Staff st on st.StaffId = s.ClinicianId
	Join ProcedureCodes pc on pc.ProcedureCodeId = s.ProcedureCodeId
	Join clients c on c.clientId = s.ClientId
	Join GlobalCodes gc on gc.GlobalCodeId = s.Status
	Where	s.ProgramId in (32)
	AND isnull(s.RecordDeleted, ''N'') = ''N'' 
	AND isnull(st.RecordDeleted, ''N'') = ''N'' 
	AND isnull(pc.RecordDeleted, ''N'') = ''N'' 
	AND isnull(c.RecordDeleted, ''N'') = ''N'' 
	and s.DateOfService >= @StartDate
	and s.DateOfService <= dateadd(dd, 1, @EndDate)





-- Update Units for Billable Services
	
	Update s
	set BillableUnits = case when PR.BillingCodeUnitType  = ''A'' then PR.BillingCodeClaimUnits else
		convert(int, s.Unit/PR.BillingCodeUnits) * PR.BillingCodeClaimUnits end,
	Charge = (Case PR.ChargeType when ''E'' then PR.Amount -- For Exactly
		when ''R'' then PR.Amount -- For Range 
		when ''P'' then (PR.Amount)*convert(decimal(10,2),(s.Unit/convert(int,PR.FromUnit))) end) 
	From #Services s
	JOIN Staff ST ON (S.ClinicianId = ST.StaffId)
	JOIN procedurerates PR ON (S.ProcedureCodeId = PR.ProcedureCodeId)
--	and isnull(s.PrimaryCoverage, 0) = isnull(PR.CoveragePlanId,0))
	left outer join ProcedureRatePrograms PRP on PR.ProcedureRateId=PRP.ProcedureRateId	left outer join ProcedureRateLocations PRL on PR.ProcedureRateId=PRL.ProcedureRateId
	left outer join ProcedureRateDegrees PRD on PR.ProcedureRateId=PRD.ProcedureRateId
	left outer join ProcedureRateStaff PRS on PR.ProcedureRateId=PRS.ProcedureRateId
	left outer join ProcedureRateBillingCodes PRBC on PR.ProcedureRateId=PRBC.ProcedureRateId
	where isnull(PR.RecordDeleted,''N'') =''N'' AND
	isnull(PRP.RecordDeleted,''N'') =''N'' AND
	isnull(PRL.RecordDeleted,''N'') =''N'' AND
	isnull(PRD.RecordDeleted,''N'') =''N'' AND
	isnull(PRS.RecordDeleted,''N'') =''N'' AND
	isnull(PRBC.RecordDeleted,''N'') =''N'' AND
	PR.FromDate<= S.DateOfService And
	(dateadd(dd, 1, PR.ToDate) > S.DateOfService  or PR.ToDate is NULL)And
	(PRP.programId= S.ProgramId or PR.ProgramGroupName is Null) and
	(PRL.LocationId= S.LocationId or PR.LocationGroupName is NULL) and
	(PRD.Degree= ST.Degree or PR.DegreeGroupName is NULL) and 
	(PR.ClientId= S.ClientId or PR.ClientId is NULL) and
	(PRS.StaffId= S.ClinicianId or PR.StaffGroupName is NULL) and
	((PR.ChargeType = ''P'' and s.Unit >= PR.FromUnit 
	/*and convert(int, s.Unit*100)%convert(int, PR.FromUnit*100) = 0*/)
	or (PR.ChargeType = ''E'' and  s.Unit=PR.FromUnit)
	or (PR.ChargeType = ''R'' and s.Unit >= PR.FromUnit and s.Unit <= PR.ToUnit)
	) and
	(PR.Advanced <> ''Y'' or (s.Unit >= PRBC.FromUnit and s.Unit <= PRBC.ToUnit))



Select * from #Services
where status = @Status
or @Status = ''All''

Order by ClientName, DateOfService

drop table #Services
' 
END
GO
