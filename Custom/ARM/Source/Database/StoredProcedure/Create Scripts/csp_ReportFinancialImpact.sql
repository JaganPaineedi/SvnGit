/****** Object:  StoredProcedure [dbo].[csp_ReportFinancialImpact]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportFinancialImpact]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportFinancialImpact]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportFinancialImpact]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE       procedure [dbo].[csp_ReportFinancialImpact]
@StartDate datetime = null

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

	insert into #report
	select PayerType,
	s.Charge,
	pc.DisplayAs,
	s.Status,
	y.MonthNo,
       	y.YearMonth,
       	y.FiscalYear,
	NULL
        FROM Services s
        JOIN #year y on y.YearMonth = Convert(char(6), s.dateofservice, 112)
	JOIN ProcedureCodes pc on pc.ProcedureCodeId = s.ProcedureCodeId
	LEFT OUTER JOIN ClientCoveragePlans csp on csp.ClientId = s.ClientId
						AND Exists (select * from  ClientCoverageHistory cch 
				       	        where cch.ClientCoveragePlanId = csp.ClientCoveragePlanId
                                            	AND cch.StartDate <= s.DateOfService
                                            	AND (cch.EndDate >= s.DateOfService OR cch.EndDate is NULL)
                                            	AND COBOrder = 1
					    	AND isnull(cch.RecordDeleted, ''N'') = ''N'' )
	LEFT OUTER JOIN CoveragePlans cp on cp.CoveragePlanId = csp.CoveragePlanId
	LEFT OUTER JOIN Payers p on p.PayerId = cp.PayerId
	LEFT OUTER JOIN GlobalCodes gc on gc.GlobalCodeId = p.PayerType
	WHERE --s.ProcedureCodeId = 274 --Initial Assessment
	s.ProgramId in (12, 13, 14)
	AND s.status in (71, 70, 72, 73, 75) --Show, NoShow, Complete
	AND isnull(s.RecordDeleted, ''N'') = ''N'' 
	AND isnull(csp.RecordDeleted, ''N'') = ''N'' 
	AND isnull(cp.RecordDeleted, ''N'') = ''N'' 
	AND isnull(p.RecordDeleted, ''N'') = ''N''




 


select 	r.MonthNo,
	Case When r.PayerType in (10185, 10098) then ''Capitated''
             when r.PayerType in (10371) then ''Qualified Health Plans''
             else ''Commercial''
        end as PayerType,
	r.ProcedureCode,
--Charges
       Sum(case when r.Status in (71, 75) and r.FiscalYear <> @FiscalYear then r.Charge else 0 end) as month_charge_last_year,
       Sum(case when r.Status in (71, 75) and r.FiscalYear =  @FiscalYear then r.Charge else 0 end) as month_charge_this_year,
/*       Sum(case when r.Status in (71, 75) and r.MonthNo =  2 and r.FiscalYear =  @FiscalYear then r.Charge else 0 end) as month_02_charge_this_year,
       Sum(case when r.Status in (71, 75) and r.MonthNo =  2 and r.FiscalYear <> @FiscalYear then r.Charge else 0 end) as month_02_charge_last_year,
       Sum(case when r.Status in (71, 75) and r.MonthNo =  3 and r.FiscalYear =  @FiscalYear then r.Charge else 0 end) as month_03_charge_this_year,
       Sum(case when r.Status in (71, 75) and r.MonthNo =  3 and r.FiscalYear <> @FiscalYear then r.Charge else 0 end) as month_03_charge_last_year,
       Sum(case when r.Status in (71, 75) and r.MonthNo =  4 and r.FiscalYear =  @FiscalYear then r.Charge else 0 end) as month_04_charge_this_year,
       Sum(case when r.Status in (71, 75) and r.MonthNo =  4 and r.FiscalYear <> @FiscalYear then r.Charge else 0 end) as month_04_charge_last_year,
       Sum(case when r.Status in (71, 75) and r.MonthNo =  5 and r.FiscalYear =  @FiscalYear then r.Charge else 0 end) as month_05_charge_this_year,
       Sum(case when r.Status in (71, 75) and r.MonthNo =  5 and r.FiscalYear <> @FiscalYear then r.Charge else 0 end) as month_05_charge_last_year,
       Sum(case when r.Status in (71, 75) and r.MonthNo =  6 and r.FiscalYear =  @FiscalYear then r.Charge else 0 end) as month_06_charge_this_year,
       Sum(case when r.Status in (71, 75) and r.MonthNo =  6 and r.FiscalYear <> @FiscalYear then r.Charge else 0 end) as month_06_charge_last_year,
       Sum(case when r.Status in (71, 75) and r.MonthNo =  7 and r.FiscalYear =  @FiscalYear then r.Charge else 0 end) as month_07_charge_this_year,
       Sum(case when r.Status in (71, 75) and r.MonthNo =  7 and r.FiscalYear <> @FiscalYear then r.Charge else 0 end) as month_07_charge_last_year,
       Sum(case when r.Status in (71, 75) and r.MonthNo =  8 and r.FiscalYear =  @FiscalYear then r.Charge else 0 end) as month_08_charge_this_year,
       Sum(case when r.Status in (71, 75) and r.MonthNo =  8 and r.FiscalYear <> @FiscalYear then r.Charge else 0 end) as month_08_charge_last_year,
       Sum(case when r.Status in (71, 75) and r.MonthNo =  9 and r.FiscalYear =  @FiscalYear then r.Charge else 0 end) as month_09_charge_this_year,
       Sum(case when r.Status in (71, 75) and r.MonthNo =  9 and r.FiscalYear <> @FiscalYear then r.Charge else 0 end) as month_09_charge_last_year,
       Sum(case when r.Status in (71, 75) and r.MonthNo = 10 and r.FiscalYear =  @FiscalYear then r.Charge else 0 end) as month_10_charge_this_year,
       Sum(case when r.Status in (71, 75) and r.MonthNo = 10 and r.FiscalYear <> @FiscalYear then r.Charge else 0 end) as month_10_charge_last_year,
       Sum(case when r.Status in (71, 75) and r.MonthNo = 11 and r.FiscalYear =  @FiscalYear then r.Charge else 0 end) as month_11_charge_this_year,
       Sum(case when r.Status in (71, 75) and r.MonthNo = 11 and r.FiscalYear <> @FiscalYear then r.Charge else 0 end) as month_11_charge_last_year,
       Sum(case when r.Status in (71, 75) and r.MonthNo = 12 and r.FiscalYear =  @FiscalYear then r.Charge else 0 end) as month_12_charge_this_year,
       Sum(case when r.Status in (71, 75) and r.MonthNo = 12 and r.FiscalYear <> @FiscalYear then r.Charge else 0 end) as month_12_charge_last_year,
*/
-- Number of Services
       Sum(case when r.Status in (70, 71, 72, 73, 75) and r.FiscalYear <> @FiscalYear then 1 else 0 end) as month_service_last_year,
       Sum(case when r.Status in (70, 71, 72, 73, 75) and r.FiscalYear =  @FiscalYear then 1 else 0 end) as month_service_this_year,
/*       Sum(case when r.Status in (71, 72, 75) and r.MonthNo =  2 and r.FiscalYear =  @FiscalYear then 1 else 0 end) as month_02_service_this_year,
       Sum(case when r.Status in (71, 72, 75) and r.MonthNo =  2 and r.FiscalYear <> @FiscalYear then 1 else 0 end) as month_02_service_last_year,
       Sum(case when r.Status in (71, 72, 75) and r.MonthNo =  3 and r.FiscalYear =  @FiscalYear then 1 else 0 end) as month_03_service_this_year,
       Sum(case when r.Status in (71, 72, 75) and r.MonthNo =  3 and r.FiscalYear <> @FiscalYear then 1 else 0 end) as month_03_service_last_year,
       Sum(case when r.Status in (71, 72, 75) and r.MonthNo =  4 and r.FiscalYear =  @FiscalYear then 1 else 0 end) as month_04_service_this_year,
       Sum(case when r.Status in (71, 72, 75) and r.MonthNo =  4 and r.FiscalYear <> @FiscalYear then 1 else 0 end) as month_04_service_last_year,
       Sum(case when r.Status in (71, 72, 75) and r.MonthNo =  5 and r.FiscalYear =  @FiscalYear then 1 else 0 end) as month_05_service_this_year,
       Sum(case when r.Status in (71, 72, 75) and r.MonthNo =  5 and r.FiscalYear <> @FiscalYear then 1 else 0 end) as month_05_service_last_year,
       Sum(case when r.Status in (71, 72, 75) and r.MonthNo =  6 and r.FiscalYear =  @FiscalYear then 1 else 0 end) as month_06_service_this_year,
       Sum(case when r.Status in (71, 72, 75) and r.MonthNo =  6 and r.FiscalYear <> @FiscalYear then 1 else 0 end) as month_06_service_last_year,
       Sum(case when r.Status in (71, 72, 75) and r.MonthNo =  7 and r.FiscalYear =  @FiscalYear then 1 else 0 end) as month_07_service_this_year,
       Sum(case when r.Status in (71, 72, 75) and r.MonthNo =  7 and r.FiscalYear <> @FiscalYear then 1 else 0 end) as month_07_service_last_year,
       Sum(case when r.Status in (71, 72, 75) and r.MonthNo =  8 and r.FiscalYear =  @FiscalYear then 1 else 0 end) as month_08_service_this_year,
       Sum(case when r.Status in (71, 72, 75) and r.MonthNo =  8 and r.FiscalYear <> @FiscalYear then 1 else 0 end) as month_08_service_last_year,
       Sum(case when r.Status in (71, 72, 75) and r.MonthNo =  9 and r.FiscalYear =  @FiscalYear then 1 else 0 end) as month_09_service_this_year,
       Sum(case when r.Status in (71, 72, 75) and r.MonthNo =  9 and r.FiscalYear <> @FiscalYear then 1 else 0 end) as month_09_service_last_year,
       Sum(case when r.Status in (71, 72, 75) and r.MonthNo = 10 and r.FiscalYear =  @FiscalYear then 1 else 0 end) as month_10_service_this_year,
       Sum(case when r.Status in (71, 72, 75) and r.MonthNo = 10 and r.FiscalYear <> @FiscalYear then 1 else 0 end) as month_10_service_last_year,
       Sum(case when r.Status in (71, 72, 75) and r.MonthNo = 11 and r.FiscalYear =  @FiscalYear then 1 else 0 end) as month_11_service_this_year,
       Sum(case when r.Status in (71, 72, 75) and r.MonthNo = 11 and r.FiscalYear <> @FiscalYear then 1 else 0 end) as month_11_service_last_year,
       Sum(case when r.Status in (71, 72, 75) and r.MonthNo = 12 and r.FiscalYear =  @FiscalYear then 1 else 0 end) as month_12_service_this_year,
       Sum(case when r.Status in (71, 72, 75) and r.MonthNo = 12 and r.FiscalYear <> @FiscalYear then 1 else 0 end) as month_12_service_last_year,
*/

-- Number of Canceled Services
       Sum(case when r.Status in (73) and r.FiscalYear <> @FiscalYear then 1 else 0 end) as month_ca_service_last_year,
       Sum(case when r.Status in (73) and r.FiscalYear =  @FiscalYear then 1 else 0 end) as month_ca_service_this_year,


-- Number of No Show Services
       Sum(case when r.Status in (72) and r.FiscalYear <> @FiscalYear then 1 else 0 end) as month_ns_service_last_year,
       Sum(case when r.Status in (72) and r.FiscalYear =  @FiscalYear then 1 else 0 end) as month_ns_service_this_year
/*       Sum(case when r.Status in (72) and r.MonthNo =  2 and r.FiscalYear =  @FiscalYear then 1 else 0 end) as month_02_ns_service_this_year,
       Sum(case when r.Status in (72) and r.MonthNo =  2 and r.FiscalYear <> @FiscalYear then 1 else 0 end) as month_02_ns_service_last_year,
       Sum(case when r.Status in (72) and r.MonthNo =  3 and r.FiscalYear =  @FiscalYear then 1 else 0 end) as month_03_ns_service_this_year,
       Sum(case when r.Status in (72) and r.MonthNo =  3 and r.FiscalYear <> @FiscalYear then 1 else 0 end) as month_03_ns_service_last_year,
       Sum(case when r.Status in (72) and r.MonthNo =  4 and r.FiscalYear =  @FiscalYear then 1 else 0 end) as month_04_ns_service_this_year,
       Sum(case when r.Status in (72) and r.MonthNo =  4 and r.FiscalYear <> @FiscalYear then 1 else 0 end) as month_04_ns_service_last_year,
       Sum(case when r.Status in (72) and r.MonthNo =  5 and r.FiscalYear =  @FiscalYear then 1 else 0 end) as month_05_ns_service_this_year,
       Sum(case when r.Status in (72) and r.MonthNo =  5 and r.FiscalYear <> @FiscalYear then 1 else 0 end) as month_05_ns_service_last_year,
       Sum(case when r.Status in (72) and r.MonthNo =  6 and r.FiscalYear =  @FiscalYear then 1 else 0 end) as month_06_ns_service_this_year,
       Sum(case when r.Status in (72) and r.MonthNo =  6 and r.FiscalYear <> @FiscalYear then 1 else 0 end) as month_06_ns_service_last_year,
       Sum(case when r.Status in (72) and r.MonthNo =  7 and r.FiscalYear =  @FiscalYear then 1 else 0 end) as month_07_ns_service_this_year,
       Sum(case when r.Status in (72) and r.MonthNo =  7 and r.FiscalYear <> @FiscalYear then 1 else 0 end) as month_07_ns_service_last_year,
       Sum(case when r.Status in (72) and r.MonthNo =  8 and r.FiscalYear =  @FiscalYear then 1 else 0 end) as month_08_ns_service_this_year,
       Sum(case when r.Status in (72) and r.MonthNo =  8 and r.FiscalYear <> @FiscalYear then 1 else 0 end) as month_08_ns_service_last_year,
       Sum(case when r.Status in (72) and r.MonthNo =  9 and r.FiscalYear =  @FiscalYear then 1 else 0 end) as month_09_ns_service_this_year,
       Sum(case when r.Status in (72) and r.MonthNo =  9 and r.FiscalYear <> @FiscalYear then 1 else 0 end) as month_09_ns_service_last_year,
       Sum(case when r.Status in (72) and r.MonthNo = 10 and r.FiscalYear =  @FiscalYear then 1 else 0 end) as month_10_ns_service_this_year,
       Sum(case when r.Status in (72) and r.MonthNo = 10 and r.FiscalYear <> @FiscalYear then 1 else 0 end) as month_10_ns_service_last_year,
       Sum(case when r.Status in (72) and r.MonthNo = 11 and r.FiscalYear =  @FiscalYear then 1 else 0 end) as month_11_ns_service_this_year,
       Sum(case when r.Status in (72) and r.MonthNo = 11 and r.FiscalYear <> @FiscalYear then 1 else 0 end) as month_11_ns_service_last_year,
       Sum(case when r.Status in (72) and r.MonthNo = 12 and r.FiscalYear =  @FiscalYear then 1 else 0 end) as month_12_ns_service_this_year,
       Sum(case when r.Status in (72) and r.MonthNo = 12 and r.FiscalYear <> @FiscalYear then 1 else 0 end) as month_12_ns_service_last_year
*/

  from #year y
       join #report r on r.YearMonth = y.YearMonth

 group by r.MonthNo,
       case when r.PayerType in (10185, 10098) then ''Capitated''
            when r.PayerType in (10371) then ''Qualified Health Plans''
            else ''Commercial''
            end,
	r.ProcedureCode


 order by 1,2,3

drop table #year
drop table #report
' 
END
GO
