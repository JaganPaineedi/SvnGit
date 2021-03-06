/****** Object:  StoredProcedure [dbo].[csp_ReportOPServicesComparisonByClinicianSubReport]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportOPServicesComparisonByClinicianSubReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportOPServicesComparisonByClinicianSubReport]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportOPServicesComparisonByClinicianSubReport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE          procedure [dbo].[csp_ReportOPServicesComparisonByClinicianSubReport]
@StartDate datetime = null, 
@ProgramId int = null,
@ClinicianId int = null,
@Status int = null


as

declare @month         smallint
declare @FiscalYear   int


create table #year (
MonthNo    smallint  null,
YearMonth  char(6)   null)
--FiscalYear int       null)

create table #report (
PayerType int	     null,
Charge    money	     null,
ProcedureCode varchar(150) null,
ClinicianId int	     null,
ProgramId int	     null,
Status 	  int	     null,
MonthNo	  smallint   null,
YearMonth char(6)    null,
--FiscalYear int	     null,
ServiceCount	int  null
)

CREATE Table #Report2 (
ClinicianName varchar(150)	null,
ProgramName	varchar(100)	null,
ProcedureCodeName  varchar(100)	null,
Status		int		null,
ChargesMonth1	money		null,
ChargesMonth2	money		null,
ChargesMonth3	money		null,
ChargesMonth4	money		null,
ChargesMonth5	money		null,
ChargesMonth6	money		null,
ChargesMonth7	money		null,
ChargesMonth8	money		null,
ChargesMonth9	money		null,
ChargesMonth10	money		null,
ChargesMonth11	money		null,
ChargesMonth12	money		null,


NSChargesMonth1	money		null,
NSChargesMonth2	money		null,
NSChargesMonth3	money		null,
NSChargesMonth4	money		null,
NSChargesMonth5	money		null,
NSChargesMonth6	money		null,
NSChargesMonth7	money		null,
NSChargesMonth8	money		null,
NSChargesMonth9	money		null,
NSChargesMonth10	money		null,
NSChargesMonth11	money		null,
NSChargesMonth12	money		null,


ServicesMonth1	int		null,
ServicesMonth2	int		null,
ServicesMonth3	int		null,
ServicesMonth4	int		null,
ServicesMonth5	int		null,
ServicesMonth6	int		null,
ServicesMonth7	int		null,
ServicesMonth8	int		null,
ServicesMonth9	int		null,
ServicesMonth10	int		null,
ServicesMonth11	int		null,
ServicesMonth12	int		null,

NSServicesMonth1	int		null,
NSServicesMonth2	int		null,
NSServicesMonth3	int		null,
NSServicesMonth4	int		null,
NSServicesMonth5	int		null,
NSServicesMonth6	int		null,
NSServicesMonth7	int		null,
NSServicesMonth8	int		null,
NSServicesMonth9	int		null,
NSServicesMonth10	int		null,
NSServicesMonth11	int		null,
NSServicesMonth12	int		null)





set @Month = 0
set @FiscalYear = DatePart(yy, @StartDate)


while @month < 12
begin
  -- This fiscal year
  insert into #year(MonthNo, YearMonth)--, FiscalYear)
  select @month + 1,
         Convert(char(6), DateAdd(mm, - @month, @StartDate), 112)
--         @FiscalYear
/*
  -- Last fiscal year
  insert into #year(MonthNo, YearMonth, FiscalYear)
  select @month + 1,
         Convert(char(6), DateAdd(yy, -1, DateAdd(mm, @month, @StartDate)), 112),
         @FiscalYear - 1
*/

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
	and s.DateOfService <= @StartDate and s.DateOfService > dateadd(yy, -1, DateAdd(dd, 1, @StartDate))
	


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
	case when s.ProcedureCodeId in (206, 207, 287) then ''Individual Therapy''
		when s.ProcedureCodeId in (274) then ''Initial Assessment''
		when s.ProcedureCodeId in (211) then ''Group'' 
		else ''Other'' end,
	s.ClinicianId,
	case when @programId is not null then s.ProgramId
		else NULL end,
	s.Status,
	y.MonthNo,
       	y.YearMonth,
--       	y.FiscalYear,
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
	


Insert Into #Report2
	(ClinicianName,
	ProgramName,
	ProcedureCodeName,
	Status,
	ChargesMonth1,
	ChargesMonth2,
	ChargesMonth3,
	ChargesMonth4,
	ChargesMonth5,
	ChargesMonth6	,
	ChargesMonth7	,
	ChargesMonth8	,
	ChargesMonth9	,
	ChargesMonth10	,
	ChargesMonth11 ,
	ChargesMonth12	,
	NSChargesMonth1	,
	NSChargesMonth2	,
	NSChargesMonth3,
	NSChargesMonth4,
	NSChargesMonth5,
	NSChargesMonth6,
	NSChargesMonth7,
	NSChargesMonth8,
	NSChargesMonth9,
	NSChargesMonth10,
	NSChargesMonth11,
	NSChargesMonth12,
	ServicesMonth1,
	ServicesMonth2	,
	ServicesMonth3,
	ServicesMonth4	,
	ServicesMonth5,
	ServicesMonth6	,
	ServicesMonth7	,
	ServicesMonth8,
	ServicesMonth9	,
	ServicesMonth10,
	ServicesMonth11	,
	ServicesMonth12	,
	NSServicesMonth1,
	NSServicesMonth2,
	NSServicesMonth3,
	NSServicesMonth4,
	NSServicesMonth5,
	NSServicesMonth6,
	NSServicesMonth7,
	NSServicesMonth8,
	NSServicesMonth9,
	NSServicesMonth10	,
	NSServicesMonth11,
	NSServicesMonth12)

select 	st.LastName + '', '' + st.FirstName as ClinicianName,
	p.ProgramCode,
	r.ProcedureCode,
	@Status,

--Charges
       Sum(case when r.Status in (71, 75) and r.MonthNo = 1  then r.Charge else 0 end) ,
       Sum(case when r.Status in (71, 75) and r.MonthNo = 2  then r.Charge else 0 end),
       Sum(case when r.Status in (71, 75) and r.MonthNo = 3  then r.Charge else 0 end) ,
       Sum(case when r.Status in (71, 75) and r.MonthNo = 4  then r.Charge else 0 end),
       Sum(case when r.Status in (71, 75) and r.MonthNo = 5  then r.Charge else 0 end) ,
       Sum(case when r.Status in (71, 75) and r.MonthNo = 6  then r.Charge else 0 end) ,
       Sum(case when r.Status in (71, 75) and r.MonthNo = 7  then r.Charge else 0 end),
       Sum(case when r.Status in (71, 75) and r.MonthNo = 8  then r.Charge else 0 end) ,
       Sum(case when r.Status in (71, 75) and r.MonthNo = 9  then r.Charge else 0 end),
       Sum(case when r.Status in (71, 75) and r.MonthNo = 10  then r.Charge else 0 end) ,
       Sum(case when r.Status in (71, 75) and r.MonthNo = 11  then r.Charge else 0 end),
       Sum(case when r.Status in (71, 75) and r.MonthNo = 12  then r.Charge else 0 end),




--No Show Charges
       Sum(case when r.Status in (@Status) and r.MonthNo = 1  then r.Charge else 0 end),
       Sum(case when r.Status in (@Status) and r.MonthNo = 2  then r.Charge else 0 end) ,
       Sum(case when r.Status in (@Status) and r.MonthNo = 3  then r.Charge else 0 end) ,
       Sum(case when r.Status in (@Status) and r.MonthNo = 4  then r.Charge else 0 end),
       Sum(case when r.Status in (@Status) and r.MonthNo = 5  then r.Charge else 0 end),
       Sum(case when r.Status in (@Status) and r.MonthNo = 6  then r.Charge else 0 end),
       Sum(case when r.Status in (@Status) and r.MonthNo = 7  then r.Charge else 0 end) ,
       Sum(case when r.Status in (@Status) and r.MonthNo = 8  then r.Charge else 0 end) ,
       Sum(case when r.Status in (@Status) and r.MonthNo = 9  then r.Charge else 0 end) ,
       Sum(case when r.Status in (@Status) and r.MonthNo = 10  then r.Charge else 0 end) ,
       Sum(case when r.Status in (@Status) and r.MonthNo = 11  then r.Charge else 0 end) ,
       Sum(case when r.Status in (@Status) and r.MonthNo = 12  then r.Charge else 0 end) ,

     

-- Number of Services
       Sum(case when r.Status in (70, 71, 72, 73, 75) and r.MonthNo = 1  then 1 else 0 end) ,
       Sum(case when r.Status in (70, 71, 72, 73, 75) and r.MonthNo = 2  then 1 else 0 end) ,
       Sum(case when r.Status in (70, 71, 72, 73, 75) and r.MonthNo = 3  then 1 else 0 end),
       Sum(case when r.Status in (70, 71, 72, 73, 75) and r.MonthNo = 4  then 1 else 0 end),
       Sum(case when r.Status in (70, 71, 72, 73, 75) and r.MonthNo = 5  then 1 else 0 end) ,
       Sum(case when r.Status in (70, 71, 72, 73, 75) and r.MonthNo = 6  then 1 else 0 end) ,
       Sum(case when r.Status in (70, 71, 72, 73, 75) and r.MonthNo = 7  then 1 else 0 end) ,
       Sum(case when r.Status in (70, 71, 72, 73, 75) and r.MonthNo = 8  then 1 else 0 end),
       Sum(case when r.Status in (70, 71, 72, 73, 75) and r.MonthNo = 9  then 1 else 0 end),
       Sum(case when r.Status in (70, 71, 72, 73, 75) and r.MonthNo = 10  then 1 else 0 end),
       Sum(case when r.Status in (70, 71, 72, 73, 75) and r.MonthNo = 11  then 1 else 0 end) ,
       Sum(case when r.Status in (70, 71, 72, 73, 75) and r.MonthNo = 12  then 1 else 0 end) ,
    

-- Number of No Show Services
       Sum(case when r.Status in (@Status) and r.MonthNo = 1 then 1 else 0 end) ,
       Sum(case when r.Status in (@Status) and r.MonthNo = 2 then 1 else 0 end),
       Sum(case when r.Status in (@Status) and r.MonthNo = 3 then 1 else 0 end) ,
       Sum(case when r.Status in (@Status) and r.MonthNo = 4 then 1 else 0 end) ,
       Sum(case when r.Status in (@Status) and r.MonthNo = 5 then 1 else 0 end),
       Sum(case when r.Status in (@Status) and r.MonthNo = 6 then 1 else 0 end) ,
       Sum(case when r.Status in (@Status) and r.MonthNo = 7 then 1 else 0 end),
       Sum(case when r.Status in (@Status) and r.MonthNo = 8 then 1 else 0 end) ,
       Sum(case when r.Status in (@Status) and r.MonthNo = 9 then 1 else 0 end) ,
       Sum(case when r.Status in (@Status) and r.MonthNo = 10 then 1 else 0 end),
       Sum(case when r.Status in (@Status) and r.MonthNo = 11 then 1 else 0 end) ,
       Sum(case when r.Status in (@Status) and r.MonthNo = 12 then 1 else 0 end)


  from #year y
        join #report r on r.YearMonth = y.YearMonth
	join staff st on st.StaffId = r.ClinicianId
	left join programs p on p.programid = r.programid
  Where (@ProgramId is null
     Or
     (@ProgramId is not null
     AND r.ProgramId = @ProgramID))
	and (@ClinicianId is null
     Or 
     (@ClinicianId is not null
     AND @ClinicianId = r.ClinicianId))

 group by st.LastName + '', '' + st.FirstName,
	p.ProgramCode,
	r.ProcedureCode

 order by 1,2,3




-- Update for all staff

Insert Into #Report2
	(ClinicianName,
	ProgramName,
	ProcedureCodeName,
	Status,
	ChargesMonth1,
	ChargesMonth2,
	ChargesMonth3,
	ChargesMonth4,
	ChargesMonth5,
	ChargesMonth6	,
	ChargesMonth7	,
	ChargesMonth8	,
	ChargesMonth9	,
	ChargesMonth10	,
	ChargesMonth11 ,
	ChargesMonth12	,
	NSChargesMonth1	,
	NSChargesMonth2	,
	NSChargesMonth3,
	NSChargesMonth4,
	NSChargesMonth5,
	NSChargesMonth6,
	NSChargesMonth7,
	NSChargesMonth8,
	NSChargesMonth9,
	NSChargesMonth10,
	NSChargesMonth11,
	NSChargesMonth12,
	ServicesMonth1,
	ServicesMonth2	,
	ServicesMonth3,
	ServicesMonth4	,
	ServicesMonth5,
	ServicesMonth6	,
	ServicesMonth7	,
	ServicesMonth8,
	ServicesMonth9	,
	ServicesMonth10,
	ServicesMonth11	,
	ServicesMonth12	,
	NSServicesMonth1,
	NSServicesMonth2,
	NSServicesMonth3,
	NSServicesMonth4,
	NSServicesMonth5,
	NSServicesMonth6,
	NSServicesMonth7,
	NSServicesMonth8,
	NSServicesMonth9,
	NSServicesMonth10	,
	NSServicesMonth11,
	NSServicesMonth12)

select 	''All Clinicians'',
	p.ProgramCode,
	r.ProcedureCode,
	@Status,
--Charges
       Sum(case when r.Status in (71, 75) and r.MonthNo = 1  then r.Charge else 0 end) ,
       Sum(case when r.Status in (71, 75) and r.MonthNo = 2  then r.Charge else 0 end),
       Sum(case when r.Status in (71, 75) and r.MonthNo = 3  then r.Charge else 0 end) ,
       Sum(case when r.Status in (71, 75) and r.MonthNo = 4  then r.Charge else 0 end),
       Sum(case when r.Status in (71, 75) and r.MonthNo = 5  then r.Charge else 0 end) ,
       Sum(case when r.Status in (71, 75) and r.MonthNo = 6  then r.Charge else 0 end) ,
       Sum(case when r.Status in (71, 75) and r.MonthNo = 7  then r.Charge else 0 end),
       Sum(case when r.Status in (71, 75) and r.MonthNo = 8  then r.Charge else 0 end) ,
       Sum(case when r.Status in (71, 75) and r.MonthNo = 9  then r.Charge else 0 end),
       Sum(case when r.Status in (71, 75) and r.MonthNo = 10  then r.Charge else 0 end) ,
       Sum(case when r.Status in (71, 75) and r.MonthNo = 11  then r.Charge else 0 end),
       Sum(case when r.Status in (71, 75) and r.MonthNo = 12  then r.Charge else 0 end),




--No Show Charges
       Sum(case when r.Status in (@Status) and r.MonthNo = 1  then r.Charge else 0 end),
       Sum(case when r.Status in (@Status) and r.MonthNo = 2  then r.Charge else 0 end) ,
       Sum(case when r.Status in (@Status) and r.MonthNo = 3  then r.Charge else 0 end) ,
       Sum(case when r.Status in (@Status) and r.MonthNo = 4  then r.Charge else 0 end),
       Sum(case when r.Status in (@Status) and r.MonthNo = 5  then r.Charge else 0 end),
       Sum(case when r.Status in (@Status) and r.MonthNo = 6  then r.Charge else 0 end),
       Sum(case when r.Status in (@Status) and r.MonthNo = 7  then r.Charge else 0 end) ,
       Sum(case when r.Status in (@Status) and r.MonthNo = 8  then r.Charge else 0 end) ,
       Sum(case when r.Status in (@Status) and r.MonthNo = 9  then r.Charge else 0 end) ,
       Sum(case when r.Status in (@Status) and r.MonthNo = 10  then r.Charge else 0 end) ,
       Sum(case when r.Status in (@Status) and r.MonthNo = 11  then r.Charge else 0 end) ,
       Sum(case when r.Status in (@Status) and r.MonthNo = 12  then r.Charge else 0 end) ,

     

-- Number of Services
       Sum(case when r.Status in (70, 71, 72, 73, 75) and r.MonthNo = 1  then 1 else 0 end) ,
       Sum(case when r.Status in (70, 71, 72, 73, 75) and r.MonthNo = 2  then 1 else 0 end) ,
       Sum(case when r.Status in (70, 71, 72, 73, 75) and r.MonthNo = 3  then 1 else 0 end),
       Sum(case when r.Status in (70, 71, 72, 73, 75) and r.MonthNo = 4  then 1 else 0 end),
       Sum(case when r.Status in (70, 71, 72, 73, 75) and r.MonthNo = 5  then 1 else 0 end) ,
       Sum(case when r.Status in (70, 71, 72, 73, 75) and r.MonthNo = 6  then 1 else 0 end) ,
       Sum(case when r.Status in (70, 71, 72, 73, 75) and r.MonthNo = 7  then 1 else 0 end) ,
       Sum(case when r.Status in (70, 71, 72, 73, 75) and r.MonthNo = 8  then 1 else 0 end),
       Sum(case when r.Status in (70, 71, 72, 73, 75) and r.MonthNo = 9  then 1 else 0 end),
       Sum(case when r.Status in (70, 71, 72, 73, 75) and r.MonthNo = 10  then 1 else 0 end),
       Sum(case when r.Status in (70, 71, 72, 73, 75) and r.MonthNo = 11  then 1 else 0 end) ,
       Sum(case when r.Status in (70, 71, 72, 73, 75) and r.MonthNo = 12  then 1 else 0 end) ,
    

-- Number of No Show Services
       Sum(case when r.Status in (@Status) and r.MonthNo = 1 then 1 else 0 end) ,
       Sum(case when r.Status in (@Status) and r.MonthNo = 2 then 1 else 0 end),
       Sum(case when r.Status in (@Status) and r.MonthNo = 3 then 1 else 0 end) ,
       Sum(case when r.Status in (@Status) and r.MonthNo = 4 then 1 else 0 end) ,
       Sum(case when r.Status in (@Status) and r.MonthNo = 5 then 1 else 0 end),
       Sum(case when r.Status in (@Status) and r.MonthNo = 6 then 1 else 0 end) ,
       Sum(case when r.Status in (@Status) and r.MonthNo = 7 then 1 else 0 end),
       Sum(case when r.Status in (@Status) and r.MonthNo = 8 then 1 else 0 end) ,
       Sum(case when r.Status in (@Status) and r.MonthNo = 9 then 1 else 0 end) ,
       Sum(case when r.Status in (@Status) and r.MonthNo = 10 then 1 else 0 end),
       Sum(case when r.Status in (@Status) and r.MonthNo = 11 then 1 else 0 end) ,
       Sum(case when r.Status in (@Status) and r.MonthNo = 12 then 1 else 0 end)



  from #year y
        join #report r on r.YearMonth = y.YearMonth
	join staff st on st.StaffId = r.ClinicianId
	left join programs p on p.programid = r.programid
  Where (@ProgramId is null
     Or
     (@ProgramId is not null
     AND r.ProgramId = @ProgramID))
	and (@ClinicianId is null
     Or 
     (@ClinicianId is not null
     AND @ClinicianId = r.ClinicianId))

 group by p.ProgramCode,
	r.ProcedureCode

 order by 1,2,3


select * from #report2





--select * from #year

drop table #year
drop table #report
drop table #services
' 
END
GO
