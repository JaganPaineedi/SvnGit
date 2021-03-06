/****** Object:  StoredProcedure [dbo].[csp_ReportQHPByCostCenter]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportQHPByCostCenter]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportQHPByCostCenter]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportQHPByCostCenter]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_ReportQHPByCostCenter]
@FiscalYear  int,
@FromMonth   int,
@ToMonth     int,
@ReportType  char(1) = ''S'' -- ''S'' - Summary, ''D'' - Detail
/********************************************************************************
-- Stored Procedure: dbo.csp_ReportQHPByCostCenter 
--
-- Copyright: 2007 Streamline Healthcate Solutions
--
-- Purpose: QHP by cost center report
--
-- Updates:                     		                                
-- Date        Author      Purpose
-- 02.19.2007  SFarber     Created.      
--
*********************************************************************************/
as

create table #AccountingPeriods (AccountingPeriodId int null)

insert into #AccountingPeriods (
       AccountingPeriodId)
select AccountingPeriodId
  from AccountingPeriods
 where FiscalYear = @FiscalYear
   and SequenceNumber between @FromMonth and @ToMonth
   and isnull(RecordDeleted, ''N'') = ''N''


create table #Report (
ClientId        int         null,
ServiceId       int         null,
ChargeId        int         null,
CoveragePlanId  int         null,
PaymentId       int         null,
PayerId         int         null,
ProcedureCodeId int         null,
DateOfService   datetime    null,
AccountingDate  datetime    null,
Amount          money       null,
Account         varchar(10) null,
AccountType     varchar(10) null,
Subaccount      varchar(10) null)

insert into #Report (
       ClientId,
       ServiceId,
       ChargeId,
       CoveragePlanId,
       ProcedureCodeId,
       PaymentId,
       DateOfService,
       AccountingDate,
       AccountType,
       Subaccount,
       Amount)      
select s.ClientId,
       s.ServiceId,
       c.ChargeId,
       ccp.CoveragePlanId,
       s.ProcedureCodeId,
       l.PaymentId,
       s.DateOfService,
       convert(char(10), l.CreatedDate, 101),
       case when l.LedgerType in (4201, 4204)then ''REVENUE'' 
            when l.LedgerType = 4203         then ''ADJUSTMENT''
            else ''CASH''
       end,
       sap.Subaccount,
       -l.Amount
  from Services s
       join Charges c on c.ServiceId = s.ServiceId
       join ARLedger l on l.ChargeId = c.ChargeId
       join #AccountingPeriods ap on ap.AccountingPeriodId = l.AccountingPeriodId
       join ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = c.ClientCoveragePlanId
       join CustomQHPCoveragePlans qhp on qhp.CoveragePlanId = ccp.CoveragePlanId
       left join CustomGLSubAccountPrograms sap on sap.ProgramId = s.ProgramId and l.LedgerType in (4201, 4203, 4204)
 where l.LedgerType in (4201, 4202, 4203, 4204)
   and isnull(l.RecordDeleted, ''N'') = ''N''
   and isnull(c.RecordDeleted, ''N'') = ''N''
   and isnull(s.RecordDeleted, ''N'') = ''N''

update r
   set Account = a.Account
  from #Report r 
       join CustomGLAccountCoveragePlans acp on acp.CoveragePlanId = r.CoveragePlanId
       join CustomGLAccounts a on a.AccountType = r.AccountType and
                                  a.AccountSubtype = acp.AccountSubtype
 where r.AccountType in (''REVENUE'', ''ADJUSTMENT'')

update r
   set Account = a.Account
  from #Report r 
       join CustomGLAccounts a on a.AccountType = r.AccountType and
                                  a.AccountSubtype = ''ALL''
 where r.Account is null
   and r.AccountType in (''REVENUE'', ''ADJUSTMENT'')

update r
   set Account = a.Account
  from #Report r
       join Payments p on p.PaymentId = r.PaymentId
       join CustomGLAccounts a on a.AccountType = ''CASH'' and
                                  a.AccountSubType = case when p.PaymentMethod in (4363, 10379) then ''CREDITCARD''
                                                          when p.LocationId = 11001 then ''LOCKBOX'' 
                                                          when p.LocationId = 10942 then ''ALBION''
                                                          else ''ALL''
                                                     end
 where r.AccountType = ''CASH''

if @ReportType = ''S''
  select r.Account + case when r.Subaccount is not null then ''-'' + r.Subaccount else '''' end as Account,
         r.AccountType,
         null as ClientId, 
         null as CoveragePlan, 
         null as ProcedureCodeName,
         null as DateOfService,
         null as AccountingDate,
         sum(case when r.Amount > 0  then r.Amount else 0 end) DebitAmount,
         sum(case when r.Amount <= 0 then r.Amount else 0 end) CreditAmount
    from #Report r
   group by r.Account,
            r.Subaccount,
            r.AccountType
   order by case r.AccountType
                 when ''CASH'' then 1 
                 when ''REVENUE'' then 2
                 else 3 
            end,
            r.Account,
            r.Subaccount
else 
  select r.Account + case when r.Subaccount is not null then ''-'' + r.Subaccount else '''' end as Account,
         r.AccountType,
         r.ClientId, 
         cp.DisplayAs as CoveragePlan, 
         pc.ProcedureCodeName,
         r.DateOfService,
         r.AccountingDate,
         sum(case when r.Amount > 0  then r.Amount else 0 end) DebitAmount,
         sum(case when r.Amount <= 0 then r.Amount else 0 end) CreditAmount
    from #Report r
         left join CoveragePlans cp on cp.CoveragePlanId = r.CoveragePlanId
         left join ProcedureCodes pc on pc.ProcedureCodeId = r.ProcedureCodeId
   group by r.Account,
            r.Subaccount,
            r.AccountType,
            r.ClientId,
            r.CoveragePlanId,
            cp.DisplayAs,
            pc.ProcedureCodeName,
            r.DateOfService,
            r.AccountingDate
   order by case r.AccountType
                 when ''CASH'' then 1 
                 when ''REVENUE'' then 2
                 else 3 
            end,
            r.Account,
            r.Subaccount,
            r.AccountingDate,
            r.DateOfService,
            cp.DisplayAs,
            r.ClientId
' 
END
GO
