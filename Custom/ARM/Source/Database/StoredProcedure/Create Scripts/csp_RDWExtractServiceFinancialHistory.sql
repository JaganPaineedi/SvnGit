/****** Object:  StoredProcedure [dbo].[csp_RDWExtractServiceFinancialHistory]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDWExtractServiceFinancialHistory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDWExtractServiceFinancialHistory]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDWExtractServiceFinancialHistory]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_RDWExtractServiceFinancialHistory]
@AffiliateId int,
@ExtractDate datetime
as

--
-- ASSUMPTION: The service extract has already been run successfully
--

set nocount on
set ansi_warnings off

create table #Sfh (
ServiceId              int          not null,
AccountingYear         smallint     not null,
AccountingMonth        tinyint      not null,
CoveragePlanId         varchar(20)  not null,  
InsuredId              varchar(25)  null,
Charge                 money        null,
Payment                money        null,
Adjustment             money        null)

create table #Extract (
ServiceId              int          not null,
AccountingYear         smallint     not null,
AccountingMonth        tinyint      not null,
CoveragePlanId         varchar(20)  not null,  
InsuredId              varchar(25)  null,
Charge                 money        null,
Payment                money        null,
Adjustment             money        null)


-- Delete all entries that have not been acknowledged
delete from CustomRDWExtractServiceFinancialHistory where AcknowledgedDate is null

if @@error <> 0 goto error

-- Create summary of the current financial history
insert into #Sfh (
       ServiceId,
       AccountingYear,
       AccountingMonth,
       CoveragePlanId,
       InsuredId,
       Charge,
       Payment,
       Adjustment)
select ServiceId,
       AccountingYear,
       AccountingMonth,
       CoveragePlanId,
       InsuredId,
       sum(Charge),
       sum(Payment),
       sum(Adjustment)
  from CustomRDWExtractServiceFinancialHistory
 where AffiliateId = @AffiliateId
 group by ServiceId,
          AccountingYear,
          AccountingMonth,
          CoveragePlanId,
          InsuredId

if @@error <> 0 goto error

-- Create summary based on the latest extract
insert into #Extract (
       ServiceId,
       AccountingYear,
       AccountingMonth,
       CoveragePlanId,
       InsuredId,
       Charge,
       Payment,
       Adjustment)
select s.ServiceId,
       year(ap.StartDate),
       month(ap.StartDate),
       isnull(cp.DisplayAs, ''STANDARD''),
       ccp.InsuredId,
       sum(case when arl.LedgerType in (4201, 4204) then arl.Amount else 0 end),
       sum(case when arl.LedgerType = 4202 then arl.Amount else 0 end),
       sum(case when arl.LedgerType = 4203 then arl.Amount else 0 end)
  from CustomRDWExtractServicesSent s
       join Charges c on c.ServiceId = s.ServiceId
       join ARLedger arl on arl.ChargeId = c.ChargeId
       join AccountingPeriods ap on ap.AccountingPeriodId = arl.AccountingPeriodId
       left join ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = c.ClientCoveragePlanId
       left join CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId
 where s.AffiliateId = @AffiliateId
   and s.Status in (''CO'', ''CA'', ''NS'')
   and arl.PostedDate <= @ExtractDate
   and isnull(c.RecordDeleted, ''N'') = ''N''
   and isnull(arl.RecordDeleted, ''N'') = ''N''
 group by s.ServiceId,  
          year(ap.StartDate),
          month(ap.StartDate),
          cp.DisplayAs,
          ccp.InsuredId

if @@error <> 0 goto error

-- Offset all entries for accounting months that don''t exist anymore
insert into CustomRDWExtractServiceFinancialHistory (
       AffiliateId,
       ServiceId,
       ExtractDate,
       AccountingYear,
       AccountingMonth,
       CoveragePlanId,
       InsuredId,
       Charge,
       Payment,
       Adjustment)
select @AffiliateId,
       ServiceId,
       @ExtractDate,
       AccountingYear,
       AccountingMonth,
       CoveragePlanId,
       InsuredId,
       -Charge,
       -Payment,
       -Adjustment
  from #Sfh h
 where not exists (select * 
                     from #Extract e
                    where e.ServiceId = h.ServiceId
                      and e.AccountingYear = h.AccountingYear
                      and e.AccountingMonth = h.AccountingMonth
                      and e.CoveragePlanId = h.CoveragePlanId
                      and isnull(e.InsuredId, ''IsNuLl'') = isnull(h.InsuredId, ''IsNuLl''))
 order by ServiceId,
          AccountingYear,
          AccountingMonth,
          CoveragePlanId

if @@error <> 0 goto error
            
-- Insert changes for the existing accounting months
insert into CustomRDWExtractServiceFinancialHistory (
       AffiliateId,
       ServiceId,
       ExtractDate,
       AccountingYear,
       AccountingMonth,
       CoveragePlanId,
       InsuredId,
       Charge,
       Payment,
       Adjustment)
select @AffiliateId,
       h.ServiceId,
       @ExtractDate,
       h.AccountingYear,
       h.AccountingMonth,
       h.CoveragePlanId,
       h.InsuredId,
       -(h.Charge - e.Charge),
       -(h.Payment - e.Payment),
       -(h.Adjustment - e.Adjustment)
  from #Sfh h
       join #Extract e on e.ServiceId = h.ServiceId and
                          e.AccountingYear = h.AccountingYear and
                          e.AccountingMonth = h.AccountingMonth and
                          e.CoveragePlanId = h.CoveragePlanId and
                          isnull(e.InsuredId, ''IsNuLl'') = isnull(h.InsuredId, ''IsNuLl'')
 where h.Charge <> e.Charge
    or h.Payment <> e.Payment
    or h.Adjustment <> e.Adjustment
 order by h.ServiceId,
          h.AccountingYear,
          h.AccountingMonth,
          h.CoveragePlanId

if @@error <> 0 goto error

-- Insert entries for the new accounting months
insert into CustomRDWExtractServiceFinancialHistory (
       AffiliateId,
       ServiceId,
       ExtractDate,
       AccountingYear,
       AccountingMonth,
       CoveragePlanId,
       InsuredId,
       Charge,
       Payment,
       Adjustment)
select @AffiliateId,
       e.ServiceId,
       @ExtractDate,
       e.AccountingYear,
       e.AccountingMonth,
       e.CoveragePlanId,
       e.InsuredId,
       e.Charge,
       e.Payment,
       e.Adjustment
  from #Extract e
 where not exists (select * 
                     from #Sfh h
                    where h.ServiceId = e.ServiceId
                      and h.AccountingYear = e.AccountingYear
                      and h.AccountingMonth = e.AccountingMonth
                      and h.CoveragePlanId = e.CoveragePlanId
                      and isnull(h.InsuredId, ''IsNuLl'') = isnull(e.InsuredId, ''IsNuLl''))
 order by e.ServiceId,
          e.AccountingYear,
          e.AccountingMonth,
          e.CoveragePlanId

if @@error <> 0 goto error

return

error:
' 
END
GO
