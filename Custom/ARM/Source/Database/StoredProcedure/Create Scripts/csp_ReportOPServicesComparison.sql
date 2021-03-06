/****** Object:  StoredProcedure [dbo].[csp_ReportOPServicesComparison]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportOPServicesComparison]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportOPServicesComparison]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportOPServicesComparison]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE        procedure [dbo].[csp_ReportOPServicesComparison]
@StartDate datetime = null, 
@EndDate datetime = null,
@ProgramId int = null,
@ClinicianId int = null


as

declare @month         smallint
declare @FiscalYear   int


create table #year (
MonthNo    smallint  null,
YearMonth  char(6)   null,
FiscalYear int       null)

create table #report (
PayerType int	     null,
Charge    money	     null,
ProcedureCode varchar(150) null,
ClinicianId int	     null,
ProgramId int	     null,
Status 	  int	     null,
MonthNo	  smallint   null,
YearMonth char(6)    null,
FiscalYear int	     null,
ServiceCount	int  null
)



set @Month = 0
set @FiscalYear = DatePart(yy, @StartDate)


while @month < 12
begin
  -- This fiscal year
  insert into #year(MonthNo, YearMonth, FiscalYear)
  select @month + 1,
         Convert(char(6), DateAdd(mm, @month, @StartDate), 112),
         @FiscalYear

  -- Last fiscal year
  insert into #year(MonthNo, YearMonth, FiscalYear)
  select @month + 1,
         Convert(char(6), DateAdd(yy, -1, DateAdd(mm, @month, @StartDate)), 112),
         @FiscalYear - 1


  set @month = @month + 1
end


Create Table #Services
(ServiceId 	int null,
 ClientId	int null,
 ClinicianId	int null,
 ClinicianName  varchar(150) null,
 DateOfService  DateTime null,
 ProcedureCodeId int null,
 Unit		int null,
 Charge		money null,
 Status 	int null,
 ChargeExists	char(1) null,
 ProgramId	int null,
 LocationID	int null,
 Billable	char(1) null,
 PrimaryCoverage int null,
 BillableUnits	int null,
 FaceToFace	char(1) null,
 NonFaceToFace	char(1) null,
 BillableMarkedNB char(1) null)

 

--Insert get initial service data

	Insert Into #Services
	(ServiceId,
	 ClientId,
	 ClinicianId,
	 DateOfService,
	 ProcedureCodeId,
	 Unit,
	 Status,
	 ProgramId,
	 LocationId,
	 Billable)
	
	Select s.ServiceId,
	 s.ClientId,
	 s.ClinicianId,
	 s.DateOfService,
	 s.ProcedureCodeId,
	 s.Unit,
	 s.Status,
	 s.ProgramId,
	 s.LocationId,
	 s.Billable
	From Services s
	Where	s.ProgramId in (12, 13, 14)
	AND s.status in (71, 70, 72, 73, 75) 
	AND isnull(s.RecordDeleted, ''N'') = ''N'' 
	and ((s.DateOfService >= DateAdd(yy, -1, @StartDate) and s.DateOfService < DateAdd(dd, 1, DateAdd(yy, -1, @EndDate)))
			 or  (s.DateOfService >= @StartDate and s.DateOfService < DateAdd(dd, 1, @EndDate)))
	


-- Update Service With Primary Charge Coverage for Billable Service

	Update s
	Set PrimaryCoverage = ar.CoveragePlanId,
	ChargeExists = ''Y'',
	FaceToFace = ''Y''
	From #Services s
	Join Charges ch on s.ServiceId = ch.ServiceId and isnull(ch.RecordDeleted, ''N'') = ''N''
	Join Arledger ar on ar.ChargeId = ch.ChargeId and LedgerType = 4201 and isnull(ar.RecordDeleted, ''N'') = ''N''
	Join ProcedureCodes pc on pc.ProcedureCodeId = s.ProcedureCodeId
	where s.Billable = ''Y'' and isnull(pc.NotBillable, ''N'') = ''N'' 
	and s.ProcedureCodeId not in (select procedureCodeId from CustomReportProductivityNonBillable)




-- Update Service With Primary Charge Coverage for Non Billable Service

	Update s
	Set PrimaryCoverage = NULL,
	ChargeExists = ''N'',
	BillableMarkedNB = ''Y''
	From #Services s
	Join ProcedureCodes pc on pc.ProcedureCodeId = s.ProcedureCodeId
	where s.Billable = ''N'' and isnull(pc.NotBillable, ''N'') = ''N'' 
	and s.ProcedureCodeId not in (select procedureCodeId from CustomReportProductivityNonBillable)




-- Update Service for Non Billable Service

	Update s
	Set PrimaryCoverage = NULL,
	ChargeExists = ''N'',
	NonFaceToFace = ''Y''
	From #Services s
	Join ProcedureCodes pc on pc.ProcedureCodeId = s.ProcedureCodeId
	where (isnull(pc.NotBillable, ''N'') = ''Y'' 
	or s.ProcedureCodeId in (select procedureCodeId from CustomReportProductivityNonBillable))
	




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
--	and (s.FaceToFace = ''Y'' Or s.BillableMarkedNB = ''Y'')


-- Update Units for Non Billable Services
	Update s
	Set BillableUnits = case when nb.EncounterUnit = ''E'' then nb.Units 
			    when nb.EncounterUnit = ''U'' then 
				convert(int, s.Unit/nb.Units) * 1
			    else 1 end,
	Charge = 0
	From #Services s
	Left Join CustomReportProductivityNonBillable nb on nb.ProcedureCodeId = s.ProcedureCodeId and isnull(nb.RecordDeleted, ''N'') = ''N''
	Where s.NonFaceToFace = ''Y''
	and (isnull(s.Charge, 0) = 0 or BillableUnits is null)
	






	insert into #report
	select PayerType,
	s.Charge,
	pc.DisplayAs,
	s.ClinicianId,
	s.ProgramId,
	s.Status,
	y.MonthNo,
       	y.YearMonth,
       	y.FiscalYear,
	NULL
        FROM #Services s
        JOIN #year y on y.YearMonth = Convert(char(6), s.dateofservice, 112)
	JOIN ProcedureCodes pc on pc.ProcedureCodeId = s.ProcedureCodeId AND isnull(pc.RecordDeleted, ''N'') = ''N'' 
	LEFT OUTER JOIN ClientCoveragePlans csp on csp.ClientId = s.ClientId
						AND isnull(csp.RecordDeleted, ''N'') = ''N'' 
						AND Exists (select * from  ClientCoverageHistory cch 
				       	        where cch.ClientCoveragePlanId = csp.ClientCoveragePlanId
                                            	AND cch.StartDate <= s.DateOfService
                                            	AND (cch.EndDate >= s.DateOfService OR cch.EndDate is NULL)
                                            	AND COBOrder = 1
					    	AND isnull(cch.RecordDeleted, ''N'') = ''N'' )
	LEFT OUTER JOIN CoveragePlans cp on cp.CoveragePlanId = csp.CoveragePlanId AND isnull(cp.RecordDeleted, ''N'') = ''N'' 
	LEFT OUTER JOIN Payers p on p.PayerId = cp.PayerId AND isnull(p.RecordDeleted, ''N'') = ''N''
	LEFT OUTER JOIN GlobalCodes gc on gc.GlobalCodeId = p.PayerType
	WHERE s.ProgramId in (12, 13, 14)
	AND s.status in (71, 70, 72, 73, 75) 
	



select 	r.MonthNo,
	Case When r.PayerType in (10185, 10098) then ''Capitated''
             when r.PayerType in (10371) then ''Qualified Health Plans''
             else ''Commercial''
        end as PayerType,
	st.LastName + '', '' + st.FirstName as ClinicianName,
	p.ProgramCode,
	r.ProcedureCode,

--Charges
       Sum(case when r.Status in (71, 75) and r.FiscalYear <> @FiscalYear then r.Charge else 0 end) as month_charge_last_year,
       Sum(case when r.Status in (71, 75) and r.FiscalYear =  @FiscalYear then r.Charge else 0 end) as month_charge_this_year,

--No Show Charges
       Sum(case when r.Status in (72) and r.FiscalYear <> @FiscalYear then r.Charge else 0 end) as month_nscharge_last_year,
       Sum(case when r.Status in (72) and r.FiscalYear =  @FiscalYear then r.Charge else 0 end) as month_nscharge_this_year,


-- Number of Services
       Sum(case when r.Status in (70, 71, 72, 73, 75) and r.FiscalYear <> @FiscalYear then 1 else 0 end) as month_service_last_year,
       Sum(case when r.Status in (70, 71, 72, 73, 75) and r.FiscalYear =  @FiscalYear then 1 else 0 end) as month_service_this_year,


-- Number of Canceled Services
       Sum(case when r.Status in (73) and r.FiscalYear <> @FiscalYear then 1 else 0 end) as month_ca_service_last_year,
       Sum(case when r.Status in (73) and r.FiscalYear =  @FiscalYear then 1 else 0 end) as month_ca_service_this_year,


-- Number of No Show Services
       Sum(case when r.Status in (72) and r.FiscalYear <> @FiscalYear then 1 else 0 end) as month_ns_service_last_year,
       Sum(case when r.Status in (72) and r.FiscalYear =  @FiscalYear then 1 else 0 end) as month_ns_service_this_year


  from #year y
        join #report r on r.YearMonth = y.YearMonth
	join staff st on st.StaffId = r.ClinicianId
	join programs p on p.programid = r.programid
  Where (@ProgramId is null
     Or
     (@ProgramId is not null
     AND r.ProgramId = @ProgramID))
	and (@ClinicianId is null
     Or 
     (@ClinicianId is not null
     AND @ClinicianId = r.ClinicianId))

 group by r.MonthNo,
       case when r.PayerType in (10185, 10098) then ''Capitated''
            when r.PayerType in (10371) then ''Qualified Health Plans''
            else ''Commercial''
            end,
	st.LastName + '', '' + st.FirstName,
	p.ProgramCode,
	r.ProcedureCode


 order by 1,2,3,4,5

drop table #year
drop table #report
drop table #services
' 
END
GO
