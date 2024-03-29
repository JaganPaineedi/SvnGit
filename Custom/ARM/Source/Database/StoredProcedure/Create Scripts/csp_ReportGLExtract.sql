/****** Object:  StoredProcedure [dbo].[csp_ReportGLExtract]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportGLExtract]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportGLExtract]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportGLExtract]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


--dbo.csp_ReportGLExtract  @FiscalYear = 2011, -- int
--    @Month = 11, -- int
--    @CloseAccountingPeriod = ''N'', -- char(1)
--    @ReportType = ''F'' -- char(1)

CREATE procedure [dbo].[csp_ReportGLExtract]
@StartDate datetime,
@EndDate datetime,
@CloseAccountingPeriod char(1) = ''N'',
@ReportType  char(1) = ''F'' -- ''S'' - Segments Missing, ''F'' - Flat File Extract, ''C'' = CSV Extract
/********************************************************************************
-- Stored Procedure: dbo.csp_ReportGLExtract  
--
-- Copyright: 2007 Streamline Healthcate Solutions
--
-- Purpose: used for GL extract
--
-- Updates:                     		                                
-- Date        Author      Purpose
-- 10.17.2007  SFarber     Created.      
--
*********************************************************************************/
as

Set NoCount on

create table #Report (
ClientId        int         null,
ServiceId       int         null,
ChargeId        int         null,
ARLedgerId		int			null,
CoveragePlanId  int         null,
PayerId         int         null,
StaffId			int			null,
ProgramId		int			null,
LocationId		int			null,
ProcedureCodeId int         null,
DateOfService   datetime    null,
AccountingDate  datetime    null,
PostedDate		datetime	null,
Amount          money       null,
Account                   varchar(100) null,
AccountType               varchar(100) null,
AdjustmentCode            int         null,
SubaccountStaff           varchar(100) null,
SubaccountProcedure       varchar(100) null,
SubAccountLocation        varchar(100) null,
SubAccountProgramLocation varchar(100) null,
SubAccountHospStatus      varchar(100) null,
ARAccount                 varchar(100) null,
FullGLAccount			  varchar(100) null,
MissingAccounts				varchar(max) null)

create table #ExtractCSV (
EntryNumber int NOT NULL,
Chargeid int NULL,
GL int NULL,
DEPT int NULL,
EMP int NULL,
LOC int NULL,
RES1 int NULL,
UFMS int NULL,
DebitAmount float NULL,
CreditAmount float NULL,
EffectiveDate smalldatetime)

declare @ARAccount varchar(10)
--declare @AccountingPeriodId int
declare @SelfPayPayerType int = 20518	-- this is the payer type used by harbor for
declare @SelfPayARAccount varchar(100) = ''121009999999999999999''
declare @CashAccount varchar(100) = ''102509999999999999999''


insert into #Report (
       ClientId,
       ServiceId,
       ChargeId,
       ARLedgerId,
       CoveragePlanId,
		StaffId,
		ProgramId,
		LocationId,
       ProcedureCodeId,
       DateOfService,
       AccountingDate,
       PostedDate,
       AccountType,
       AdjustmentCode,
       Amount)      
select s.ClientId,
       s.ServiceId,
       c.ChargeId,
       l.ARLedgerId,
       ccp.CoveragePlanId,
       s.ClinicianId,
       s.ProgramId,
       s.LocationId,
       s.ProcedureCodeId,
       s.DateOfService,
       ap.StartDate,	-- Harbor does daily accounting periods
       l.PostedDate,
       case when l.LedgerType in (4201, 4204) then ''REVENUE'' when l.ledgertype = 4202 then ''CASH'' else ''ADJUSTMENT'' end,
       l.AdjustmentCode,
       l.Amount
  from Services s
       join Charges c on c.ServiceId = s.ServiceId
       join ARLedger l on l.ChargeId = c.ChargeId
       left join ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = c.ClientCoveragePlanId
       join dbo.AccountingPeriods as ap on ap.AccountingPeriodId = l.AccountingPeriodId
 where ap.EndDate >= @startDate
   and ap.StartDate <= @endDate
   and l.LedgerType in (4201, 4202, 4203, 4204) -- Charge, Adjustment, Transfer
   and isnull(l.RecordDeleted, ''N'') = ''N''
   --and isnull(c.RecordDeleted, ''N'') = ''N''
   --and isnull(s.RecordDeleted, ''N'') = ''N''


--select * from dbo.GlobalCodes where Category = ''arledgertype''

-- Set GL accounts
-- CASH
update #Report set Account = SUBSTRING(@CashAccount, 1, 5), FullGLAccount = @CashAccount where AccountType = ''CASH''

-- REVENUE
-- Match by coverage plan ID first
update  r
set     Account = a.Account
from    #Report r
join dbo.CoveragePlans as cp on cp.CoveragePlanId = r.CoveragePlanId
--join dbo.Payers as p on p.PayerId = cp.PayerId
join CustomGLAccounts a on a.AccountType = r.AccountType
                              and a.AccountCoveragePlanId = cp.CoveragePlanId
where   r.AccountType = ''REVENUE''
and r.Account is null
and ISNULL(a.RecordDeleted, ''N'') <> ''Y''

-- now payer id
update  r
set     Account = a.Account
from    #Report r
join dbo.CoveragePlans as cp on cp.CoveragePlanId = r.CoveragePlanId
join CustomGLAccounts a on a.AccountType = r.AccountType
                              and a.AccountPayerId = cp.PayerId
                              and a.AccountCoveragePlanId is null
where   r.AccountType = ''REVENUE''
and r.Account is null
and ISNULL(a.RecordDeleted, ''N'') <> ''Y''

-- now payer type
update  r
set     Account = a.Account
from    #Report r
join dbo.CoveragePlans as cp on cp.CoveragePlanId = r.CoveragePlanId
join dbo.Payers as py on py.PayerId = cp.PayerId
join CustomGLAccounts a on a.AccountType = r.AccountType
                              and a.AccountPayerTypeId = py.PayerType
                              and a.AccountCoveragePlanId is null
                              and a.AccountPayerId is null
where   r.AccountType = ''REVENUE''
and r.Account is null
and ISNULL(a.RecordDeleted, ''N'') <> ''Y''

-- handle self-pay revenue
update  r
set     Account = a.Account
from    #Report r
join    CustomGLAccounts a on a.AccountType = r.AccountType
                              and a.AccountPayerTypeId = @SelfPayPayerType
                              and a.AccountCoveragePlanId is null
                              and a.AccountPayerId is null
where   r.AccountType = ''REVENUE''
        and r.CoveragePlanId is null
        and r.Account is null
		and ISNULL(a.RecordDeleted, ''N'') <> ''Y''


--
-- ADJUSTMENTS
--
-- hierarchy is adjustmentcodegroup, coverage, payer, payer type
---- ADJUSTMENTCODEGROUP
------ Match by coverage plan ID first
update  r
set     Account = a.Account
from    #Report r
join dbo.CoveragePlans as cp on cp.CoveragePlanId = r.CoveragePlanId
join dbo.GlobalCodes as adj on adj.GlobalCodeId = r.AdjustmentCode
--join dbo.Payers as p on p.PayerId = cp.PayerId
join CustomGLAccounts a on a.AccountType = r.AccountType
                              and a.AccountCoveragePlanId = cp.CoveragePlanId
                              and a.AdjustmentCodeGroup = adj.ExternalCode2
where   r.AccountType = ''ADJUSTMENT''
and ISNULL(a.RecordDeleted, ''N'') <> ''Y''

-- now payer id
update  r
set     Account = a.Account
from    #Report r
join dbo.CoveragePlans as cp on cp.CoveragePlanId = r.CoveragePlanId
join dbo.GlobalCodes as adj on adj.GlobalCodeId = r.AdjustmentCode
join CustomGLAccounts a on a.AccountType = r.AccountType
                              and a.AccountPayerId = cp.PayerId
                              and a.AdjustmentCodeGroup = adj.ExternalCode2
                              and a.AccountCoveragePlanId is null
where   r.AccountType = ''ADJUSTMENT''
and r.Account is null
and ISNULL(a.RecordDeleted, ''N'') <> ''Y''

-- now payer type
update  r
set     Account = a.Account
from    #Report r
join dbo.CoveragePlans as cp on cp.CoveragePlanId = r.CoveragePlanId
join dbo.Payers as py on py.PayerId = cp.PayerId
join dbo.GlobalCodes as adj on adj.GlobalCodeId = r.AdjustmentCode
join CustomGLAccounts a on a.AccountType = r.AccountType
							  and a.AccountPayerTypeId = py.PayerType
                              and a.AdjustmentCodeGroup = adj.ExternalCode2
                              and a.AccountPayerId is null
                              and a.AccountCoveragePlanId is null
where   r.AccountType = ''ADJUSTMENT''
and r.Account is null
and ISNULL(a.RecordDeleted, ''N'') <> ''Y''

-- handle self-pay revenue
update  r
set     Account = a.Account
from    #Report r
join dbo.GlobalCodes as adj on adj.GlobalCodeId = r.AdjustmentCode
join CustomGLAccounts a on a.AccountType = r.AccountType
							  and a.AccountPayerTypeId = @SelfPayPayerType
                              and a.AdjustmentCodeGroup = adj.ExternalCode2
                              and a.AccountPayerId is null
                              and a.AccountCoveragePlanId is null
where   r.AccountType = ''ADJUSTMENT''
and r.CoveragePlanId is null
and r.Account is null
and ISNULL(a.RecordDeleted, ''N'') <> ''Y''

-- all others
update  r
set     Account = a.Account
from    #Report r
join dbo.GlobalCodes as adj on adj.GlobalCodeId = r.AdjustmentCode
join CustomGLAccounts a on a.AccountType = r.AccountType
                              and a.AdjustmentCodeGroup = adj.ExternalCode2
							  and a.AccountPayerTypeId is null
                              and a.AccountPayerId is null
                              and a.AccountCoveragePlanId is null
where   r.AccountType = ''ADJUSTMENT''
and r.Account is null
and ISNULL(a.RecordDeleted, ''N'') <> ''Y''

---NO ADJUSTMENT CODE MATCH STARTS HERE
------ Match by coverage plan ID first
update  r
set     Account = a.Account
from    #Report r
join dbo.CoveragePlans as cp on cp.CoveragePlanId = r.CoveragePlanId
join CustomGLAccounts a on a.AccountType = r.AccountType
                              and a.AccountCoveragePlanId = cp.CoveragePlanId
                              and a.AdjustmentCodeGroup is null
where   r.AccountType = ''ADJUSTMENT''
and r.Account is null
and ISNULL(a.RecordDeleted, ''N'') <> ''Y''


-- now payer id
update  r
set     Account = a.Account
from    #Report r
join dbo.CoveragePlans as cp on cp.CoveragePlanId = r.CoveragePlanId
join CustomGLAccounts a on a.AccountType = r.AccountType
                              and a.AccountPayerId = cp.PayerId
                              and a.AdjustmentCodeGroup is null
                              and a.AccountCoveragePlanId is null
where   r.AccountType = ''ADJUSTMENT''
and r.Account is null
and ISNULL(a.RecordDeleted, ''N'') <> ''Y''


-- now payer type
update  r
set     Account = a.Account
from    #Report r
join dbo.CoveragePlans as cp on cp.CoveragePlanId = r.CoveragePlanId
join dbo.Payers as py on py.PayerId = cp.PayerId
join CustomGLAccounts a on a.AccountType = r.AccountType
							  and a.AccountPayerTypeId = py.PayerType
                              and a.AdjustmentCodeGroup is null
                              and a.AccountPayerId is null
                              and a.AccountCoveragePlanId is null
where   r.AccountType = ''ADJUSTMENT''
and r.Account is null
and ISNULL(a.RecordDeleted, ''N'') <> ''Y''

-- self pay
update  r
set     Account = a.Account
from    #Report r
join CustomGLAccounts a on a.AccountType = r.AccountType
							  and a.AccountPayerTypeId = @SelfPayPayerType
                              and a.AdjustmentCodeGroup is null
                              and a.AccountPayerId is null
                              and a.AccountCoveragePlanId is null
where   r.AccountType = ''ADJUSTMENT''
and r.CoveragePlanId is null
and r.Account is null
and ISNULL(a.RecordDeleted, ''N'') <> ''Y''




-- 

update  r
set     Account = a.Account
from    #Report r
join dbo.GlobalCodes as adj on adj.GlobalCodeId = r.AdjustmentCode
join CustomGLAccounts a on a.AccountType = r.AccountType
                              and a.AdjustmentCodeGroup is null
							  and a.AccountPayerTypeId is null
                              and a.AccountPayerId is null
                              and a.AccountCoveragePlanId is null
where   r.AccountType = ''ADJUSTMENT''
and r.Account is null
and ISNULL(a.RecordDeleted, ''N'') <> ''Y''

--
-- assign sub-accounts
--
update r set
	SubAccountStaff = c.SubAccountNumber
from #Report as r
join dbo.CustomGLSubAccountClinicians as c on c.StaffId = r.StaffId
where ISNULL(c.RecordDeleted, ''N'') <> ''Y''

update r set
	SubaccountProcedure = c.SubAccountNumber
from #Report as r
join dbo.CustomGLSubAccountProcedureCodes as c on c.ProcedureCodeId = r.ProcedureCodeId
where ISNULL(c.RecordDeleted, ''N'') <> ''Y''

update r set
	SubAccountLocation = c.SubAccountNumber
from #Report as r
join dbo.CustomGLSubAccountLocations as c on c.LocationId = r.LocationId
where ISNULL(c.RecordDeleted, ''N'') <> ''Y''

-- Service Area, Program, Location
update r set
	SubAccountProgramLocation = c.SubAccountNumber
from #Report as r
join dbo.CustomGLSubAccountProgramLocations as c on c.ProgramId = r.ProgramId and c.LocationId = r.LocationId
where ISNULL(c.RecordDeleted, ''N'') <> ''Y''

update r set
	SubAccountProgramLocation = c.SubAccountNumber
from #Report as r
join dbo.CustomGLSubAccountProgramLocations as c on c.ProgramId = r.ProgramId and c.LocationId is null
	and r.SubAccountProgramLocation is null
where ISNULL(c.RecordDeleted, ''N'') <> ''Y''

-- weird combination but service area/location combo should be checked as well
update r set
	SubAccountProgramLocation = c.SubAccountNumber
from #Report as r
join dbo.Programs as p on p.ProgramId = r.ProgramId
join dbo.CustomGLSubAccountProgramLocations as c on c.ServiceAreaId = p.ServiceAreaId and c.ProgramId is null and c.LocationId = r.LocationId
	and r.SubAccountProgramLocation is null
where ISNULL(c.RecordDeleted, ''N'') <> ''Y''

update r set
	SubAccountProgramLocation = c.SubAccountNumber
from #Report as r
join dbo.Programs as p on p.ProgramId = r.ProgramId
join dbo.CustomGLSubAccountProgramLocations as c on c.ServiceAreaId = p.ServiceAreaId and c.ProgramId is null and c.LocationId is null
	and r.SubAccountProgramLocation is null
where ISNULL(c.RecordDeleted, ''N'') <> ''Y''


----
---- Currently no mapping for Hosp Status
----
update #Report set SubAccountHospStatus = ''99''


update #Report set FullGLAccount = Account + SubAccountProgramLocation + SubAccountStaff + SubAccountLocation + SubAccountHospStatus + SubAccountProcedure
where FullGLAccount is null

update r
   set ARAccount = a.Account
  from #Report r
join CustomGLAccountCoveragePlans as a on a.CoveragePlanId = r.CoveragePlanId
and ISNULL(a.RecordDeleted, ''N'') <> ''Y''

update r
   set ARAccount = @SelfPayARAccount
  from #Report r
where r.CoveragePlanId is null


if @ReportType = ''S''
begin
	select st.LastName + '', '' + st.FirstName as StaffName, c.LastName + '', '' + c.FirstName as ClientName, pc.DisplayAs as ProcedureCode, s.DateOfService,
	l.LocationCode, p.ProgramCode, cp.DisplayAs,
	case when r.Account is null then ''Account Missing-'' else '''' end
	+ case when r.SubAccountProgramLocation is null then ''Program/Location Group Segment Missing-'' else '''' end
	+ case when r.SubAccountStaff is null then ''Staff Segment Missing-'' else '''' end
	+ case when r.SubAccountLocation is null then ''Location Segment Missing-'' else '''' end
	+ case when r.SubAccountHospStatus is null then ''Hosp Status Segment Missing-'' else '''' end
	+ case when r.SubAccountProcedure is null then ''Procedure Segment Missing-'' else '''' end 
	+ case when r.ARAccount is null then ''AR Account Missing for Coverage Plan'' else '''' end as MissingSegments
	from #report as r
	join dbo.Services as s on s.ServiceId = r.ServiceId
	LEFT join dbo.Staff as st on st.StaffId = s.ClinicianId
	LEFT join dbo.Clients as c on c.ClientId = s.ClientId
	LEFT join dbo.ProcedureCodes as pc on pc.ProcedureCodeId = s.ProcedureCodeId
	LEFT join dbo.Locations as l on l.LocationId = s.LocationId
	LEFT join dbo.Programs as p on p.ProgramId = s.ProgramId
	LEFT join dbo.CoveragePlans as cp on cp.CoveragePlanId = r.CoveragePlanId
	where r.Account is null
	or r.SubAccountProgramLocation is null
	or r.SubAccountStaff is null
	or r.SubAccountLocation is null
	or r.SubAccountHospStatus is null
	or r.SubAccountProcedure is null
	or r.ARAccount is null

	return
end


create table #output (
	GLType varchar(20),
	FullGLAccount varchar(100),
	AccountingDate varchar(8),
	Credits decimal(11,2),
	Debits decimal(11,2),
	FlatFileRecord char(86)
)

insert into #output (
		GLType,
         FullGLAccount,
         AccountingDate,
         Debits,
         Credits
        )
select ''credit'',
	r.FullGLAccount,
	case when DATEPART(MONTH, AccountingDate) < 10 then ''0'' else '''' end + CAST(DATEPART(MONTH, AccountingDate) as varchar)
	+ case when DATEPART(day, AccountingDate) < 10 then ''0'' else '''' end + CAST(DATEPART(DAY, AccountingDate) as varchar)
	+ cast(DATEPART(YEAR, AccountingDate) as varchar),
	-(case when SUM(r.amount) < 0 then SUM(r.amount) else 0 end),
	case when SUM(r.amount) > 0 then SUM(r.amount) else 0 end
from #Report as r
group by r.FullGLAccount,
	case when DATEPART(MONTH, AccountingDate) < 10 then ''0'' else '''' end + CAST(DATEPART(MONTH, AccountingDate) as varchar)
	+ case when DATEPART(day, AccountingDate) < 10 then ''0'' else '''' end + CAST(DATEPART(DAY, AccountingDate) as varchar)
	+ cast(DATEPART(YEAR, AccountingDate) as varchar)


insert into #output (
		GLType,
         FullGLAccount,
         AccountingDate,
         Debits,
         Credits
        )
select ''debit'',
	r.ARAccount,
	case when DATEPART(MONTH, AccountingDate) < 10 then ''0'' else '''' end + CAST(DATEPART(MONTH, AccountingDate) as varchar)
	+ case when DATEPART(day, AccountingDate) < 10 then ''0'' else '''' end + CAST(DATEPART(DAY, AccountingDate) as varchar)
	+ cast(DATEPART(YEAR, AccountingDate) as varchar),
	case when SUM(r.amount) > 0 then SUM(r.amount) else 0 end,
	-(case when SUM(r.amount) < 0 then SUM(r.amount) else 0 end)
from #Report as r
group by r.ARAccount,
	case when DATEPART(MONTH, AccountingDate) < 10 then ''0'' else '''' end + CAST(DATEPART(MONTH, AccountingDate) as varchar)
	+ case when DATEPART(day, AccountingDate) < 10 then ''0'' else '''' end + CAST(DATEPART(DAY, AccountingDate) as varchar)
	+ cast(DATEPART(YEAR, AccountingDate) as varchar)

delete from #output where Credits = 0 and Debits = 0

--select * from #report where fullglaccount = ''401009992046312099104'' and DATEDIFF(DAY, posteddate, ''4/3/2012'') = 0

update #output set
	Debits = case when Debits > Credits then  Debits - Credits else 0.0 end,
	Credits = case when Credits > Debits then Credits - Debits else 0.0 end


update #output set FlatFileRecord = ''JV    '' + ''AR'' + AccountingDate + ''    ''
+ AccountingDate + ''AR'' + AccountingDate + ''     ''
+ FullGLAccount
+ REPLICATE(''0'', 11 - LEN(REPLACE(CAST(Debits as varchar), ''.'', ''''))) + REPLACE(CAST(Debits as varchar), ''.'', '''')
+ REPLICATE(''0'', 11 - LEN(REPLACE(CAST(Credits as varchar), ''.'', ''''))) + REPLACE(CAST(Credits as varchar), ''.'', '''')

if @ReportType = ''F''
begin
	select FlatFileRecord
	from #output
	order by FullGLAccount, AccountingDate
end
else if @ReportType = ''C''
begin
	select ''JV'' as SessionId,
		''Import from SmartCare'' as SessionDesc, 
		''BP'' as status, 
		SUBSTRING(AccountingDate,1,2) + ''/'' + SUBSTRING(AccountingDate, 3, 2) + ''/'' + SUBSTRING(AccountingDate, 5,4) as SessionDate,
		DENSE_RANK() over(order by AccountingDate) as EntryNumber,
		SUBSTRING(AccountingDate,1,2) + ''/'' + SUBSTRING(AccountingDate, 3, 2) + ''/'' + SUBSTRING(AccountingDate, 5,4) as EntryDate,
		''Import from SmartCare'' as EntryDesc, 
		SUBSTRING(FullGLAccount, 1, 5) as GL,
		SUBSTRING(FullGLAccount, 6, 3) as Dept,
		SUBSTRING(FullGLAccount, 9, 5) as EmplProc,
		SUBSTRING(FullGLAccount, 14, 3) as LocClinic,
		SUBSTRING(FullGLAccount, 17, 2) as Res1,
		SUBSTRING(FullGLAccount, 19, 3) as UFMS,
		Debits as Debit,
		Credits as Credit,
		''N'' as EntryType,
		SUBSTRING(AccountingDate,1,2) + ''/'' + SUBSTRING(AccountingDate, 3, 2) + ''/'' + SUBSTRING(AccountingDate, 5,4) as EffectiveDate,
		''Import from SmartCare'' as LineDescription
	from #output
	order by AccountingDate, FullGLAccount

end


if @CloseAccountingPeriod = ''Y''
begin
  begin tran

  update AccountingPeriods
     set OpenPeriod = ''N'',
         ModifiedBy = system_user,
         ModifiedDate = GetDate()
   where EndDate >= @startDate
	and StartDate <= @endDate
     and OpenPeriod = ''Y''

  if @@error <> 0
  begin
    rollback tran
    raiserror 50010 ''Failed to close accounting period.''
    return
  end

  commit tran 

end


--grant execute on dbo.csp_ReportGLExtract to public
--Drop Table #Report
--Drop Table #ExtractCSV

--End


' 
END
GO
