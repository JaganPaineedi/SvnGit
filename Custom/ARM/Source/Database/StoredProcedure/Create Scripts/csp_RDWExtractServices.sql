/****** Object:  StoredProcedure [dbo].[csp_RDWExtractServices]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDWExtractServices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDWExtractServices]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDWExtractServices]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_RDWExtractServices]
@AffiliateId int,
@ExtractDate datetime
/*********************************************************************
-- Stored Procedure: dbo.csp_RDWExtractServices
-- Creation Date:    11/01/06
--
-- Purpose: Extract services
--
-- Updates:
--   Date         Author      Purpose
--   11.01.2007   SFarber     Created.
--   07.05.2007   SFarber     Modified to use ssp_PMClaimsGetBillingCodes.
--   12.14.2007   SFarber     Modified to properly handle exceptions when there is a ledger activity.
--                            for a coverage that is not the coverage history.
--   02.21.2008   SFarber     Modified how the coverage plan ID gets determined when calculating CPT codes and units.
--   04.30.2008   SFarber     Modified to filter out services based on custom rules.
--   01.19.2009   SFarber     Modified to truncate CustomRDWExtractServices.
--   11.19.2009   SFarber     Added call to csp_RDWExtractServicesCustom.
--   12.04.2009   SFarber     Modified to use coverage plan type for capitated plans.
--   04.26.2010   SFarber     Added ProcedureCodeId
--   04.28.2010   SFarber     Added BillingCPTCode.
--   12.16.2010   SFarber     Changed #ClaimLines.ServiceUnits from int to decimal(18, 2)
*********************************************************************/
as

set nocount on
set ansi_warnings off

create table #ServiceCoveragePlans (
ServiceId            int         null,
ChargeId             int         null,
ClientCoveragePlanId int         null,
CopayPriority        int         null,
OtherPayerPriority   int         null,
ExpectedPayment      money       null,
Charge               money       null,
Payment              money       null,
Adjustment           money       null,
BilledDate           datetime    null,
PaymentDate          datetime    null)

create table #ServiceCoveragePlanExceptions (
RecordId             int         identity not null,
ServiceId            int         null,
ChargeId             int         null,
ClientCoveragePlanId int         null,
CopayPriority        int         null)

create table #ServiceOtherPayers (
RecordId             int         identity not null,
ServiceId            int         null,
ClientCoveragePlanId int         null,
OtherPayerPriority   int         null)


create table #ClaimLines (
ClaimLineId            int identity   not null,
ServiceId              int            null,
CoveragePlanId         int            null,
ServiceUnits           decimal(18, 2) null,
BillingCode            varchar(15)    null,
Modifier1              char(2)        null,
Modifier2              char(2)        null,
Modifier3              char(2)        null,
Modifier4              char(2)        null,
RevenueCode            varchar(15)    null,
RevenueCodeDescription varchar(100)   null,
ClaimUnits             int            null,
RecalculateBillingCode char(1)        null)	

create table #ReportingYears (
StartDate    datetime   null)

declare @ResendAll char(1)
declare @ReportingYear datetime
declare @StartDate datetime

select @ResendAll = isnull(ResendAll, ''N''),
       @ReportingYear = ReportingYear,
       @StartDate = RDWStartDate
  from CustomRDWExtractSummary 
 where AffiliateId = @AffiliateId

-- Clean up
truncate table dbo.CustomRDWExtractServices

if @@error <> 0 goto error

-- Retrieve services that should be filtered out from extract
exec csp_RDWExtractServicesCustomFilter @AffiliateId = @AffiliateId

if @@error <> 0 goto error

insert into dbo.CustomRDWExtractServices (
       AffiliateId,
       ServiceId,
       ClientId,
       EpisodeNumber,
       DateOfService,
       EndDateOfService,
       ProcedureCode,
       ProcedureCodeId,
       ProcedureDuration,
       DurationType,
       CSPPClinicId,
       CSPPClinicName,
       CSPPServiceId,
       CSPPServiceName,
       ProgramId,
       ProgramName,
       CSPPProtocolId,
       CSPPProtocolName,
       Status,
	   CancelReason,
       Billable,
       PlaceOfService,
       ClinicianId1,
       ClinicianName1,
       ClinicianDegree1,
       BillingId,
       BillingName,
       SupervisorId,
       SupervisorName,
       AttendingId,
       AttendingName,
       CreatedDate,
       CompletedDate,
       Location,
       Axis1,
       Axis2,
       Axis3,
       CPTCode,
       BillingCPTCode,
       CPTModifier1,
       CPTModifier2,
       CPTModifier3,
       Units,
       ExcludeFromExceptionReport,
       ExtractStatus,
       ErrorStatus)
select @AffiliateId,
       s.ServiceId,
       s.ClientId,
       isnull(c.CurrentEpisodeNumber, 1),
       s.DateOfService,
       s.EndDateOfService,
       pc.DisplayAs,
       s.ProcedureCodeId,
       s.Unit,
       upper(left(gcdt.CodeName, 2)),
       ''GENERAL'',
       ''GENERAL'',
       ''GENERAL'',
       ''GENERAL'',
       pr.ProgramCode,
       pr.ProgramName,
       ''GENERAL'',
       ''GENERAL'',
       case when s.RecordDeleted = ''Y'' 
            then ''ER''
            else case s.Status when 70 then ''SC'' when 71 then ''SH'' when 72 then ''NS'' when 73 then ''CA'' when 75 then ''CO'' else ''ER'' end
       end,
	   cr.CodeName,
       s.Billable,
       l.LocationName,
       s.ClinicianId,
       cl.LastName + '', '' + cl.FirstName,
       gccld.CodeName,
       s.ClinicianId,
       cl.LastName + '', '' + cl.FirstName,
       s.ClinicianId,
       cl.LastName + '', '' + cl.FirstName,
       s.AttendingId,
       acl.LastName + '', '' + acl.FirstName,
       s.CreatedDate,
       case when s.Status = 75 then s.ModifiedDate else null end,
       l.LocationName,
       s.DiagnosisCode1,
       s.DiagnosisCode2,
       s.DiagnosisCode3,
       ss.CPTCode,
       ss.BillingCPTCode,
       ss.CPTModifier1,
       ss.CPTModifier2,
       ss.CPTModifier3,
       ss.Units,
       s.Flag1,
       ''N'',
       ''N''
  from Clients c
       join Services s on s.ClientId = c.ClientId
       join ProcedureCodes pc on pc.ProcedureCodeId = s.ProcedureCodeId    
       join Programs pr on pr.ProgramId = s.ProgramId 
       left join Locations l on l.LocationId = s.LocationId
       left join GlobalCodes gcdt on gcdt.GlobalCodeId = isnull(s.UnitType, pc.EnteredAs)
       left join Staff cl on cl.StaffId = s.ClinicianId
       left join Staff acl on acl.StaffId = s.AttendingId
       left join GlobalCodes gccld on gccld.GlobalCodeId = cl.Degree
       left join CustomRDWExtractServicesSent ss on ss.ServiceId = s.ServiceId
	   left join GlobalCodes cr on cr.GlobalCodeId = s.CancelReason
 where s.DateOfService >= @StartDate
   and s.Status in (70, 71, 72, 73, 75, 76)
   and s.CreatedDate <= @ExtractDate
   and exists(select * 
                from CustomRDWExtractClients ec 
               where ec.ClientId = c.ClientId)
   and not exists(select * 
                    from CustomRDWExtractServicesCustomFilter f
                   where f.ServiceId = s.ServiceId) 

if @@error <> 0 goto error

-- Set episode number
update s
   set EpisodeNumber = c.EpisodeNumber
  from CustomRDWExtractServices s
       join CustomRDWExtractClients c on c.ClientId = s.ClientId and
                                         c.EpisodeOpenDate <= s.DateOfService
 where not exists(select *
                    from CustomRDWExtractClients c2
                   where c2.ClientId = s.ClientId
                     and c2.EpisodeOpenDate <= s.DateOfService
                     and c2.EpisodeNumber > c.EpisodeNumber)

if @@error <> 0 goto error

-- Delete all sent services that have not been acknowledged except the ones
-- that have been already deleted from the PM database or marked as errors.
-- This is needed in case when data was posted to RDW but the acknowledgement
-- process failed.  The deleted and error services will be sent to RDW as errors.
delete from ss
  from CustomRDWExtractServicesSent ss
 where ss.AcknowledgedDate is null
   and exists (select * 
                 from CustomRDWExtractServices s
                where s.ServiceId = ss.ServiceId
                  and s.Status <> ''ER'')

if @@error <> 0 goto error

--
-- Delete sent services that have been moved from final statuses back to Show or Scheduled
--
delete ss
  from CustomRDWExtractServicesSent ss
       join CustomRDWExtractServices s on s.ServiceId = ss.ServiceId
 where s.Status in (''SC'', ''SH'')

if @@error <> 0 goto error

--
-- Calculate financial information
--

-- Coverage plans
insert into #ServiceCoveragePlans (
       ServiceId,
       ChargeId,
       ClientCoveragePlanId,
       CopayPriority,
       ExpectedPayment,
       BilledDate)
select s.ServiceId,
       c.ChargeId,
       ccp.ClientCoveragePlanId,
       min(cch.COBOrder) as COBOrder,
       max(c.ExpectedPayment),
       max(c.LastBilledDate)
  from CustomRDWExtractServices s
       join ClientCoveragePlans ccp on ccp.ClientId = s.ClientId
       join ClientCoverageHistory cch on cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
       left join Charges c on c.ServiceId = s.Serviceid and c.ClientCoveragePlanId = ccp.ClientCoveragePlanId and isnull(c.RecordDeleted, ''N'') = ''N''
 where s.Status <> ''ER''
   and isnull(ccp.RecordDeleted, ''N'') = ''N''
   and isnull(cch.RecordDeleted, ''N'') = ''N''
   and s.DateOfService >= cch.StartDate
   and (s.DateOfService < dateadd(dd, 1, cch.EndDate) or cch.EndDate is null)
   -- These criteria are to work around data issues
   and not exists(select *
                    from ClientCoveragePlans ccp2
                         join ClientCoverageHistory cch2 on cch2.ClientCoveragePlanId = ccp2.ClientCoveragePlanId
                   where ccp2.ClientId = s.ClientId 
                     and ccp2.ClientCoveragePlanId = ccp.ClientCoveragePlanId
                     and isnull(ccp2.RecordDeleted, ''N'') = ''N''
                     and isnull(cch2.RecordDeleted, ''N'') = ''N''
                     and s.DateOfService >= cch2.StartDate
                     and (s.DateOfService < dateadd(dd, 1, cch2.EndDate) or cch2.EndDate is null)
                     and cch2.COBOrder < cch.COBOrder)
   and not exists(select *
                    from ClientCoveragePlans ccp2
                         join ClientCoverageHistory cch2 on cch2.ClientCoveragePlanId = ccp2.ClientCoveragePlanId
                   where ccp2.ClientId = s.ClientId 
                     and isnull(ccp2.RecordDeleted, ''N'') = ''N''
                     and isnull(cch2.RecordDeleted, ''N'') = ''N''
                     and s.DateOfService >= cch2.StartDate
                     and (s.DateOfService < dateadd(dd, 1, cch2.EndDate) or cch2.EndDate is null)
                     and cch2.StartDate > cch.StartDate)
 group by s.ServiceId,
          c.ChargeId,
          ccp.ClientCoveragePlanId
order by s.ServiceId, COBOrder
 
if @@error <> 0 goto error

-- Clients
insert into #ServiceCoveragePlans (
       ServiceId,
       ChargeId,
       ClientCoveragePlanId,
       CopayPriority,
       ExpectedPayment,
       BilledDate)
select s.ServiceId,
       c.ChargeId,
       null,
       0,
       c.ExpectedPayment,
       c.LastBilledDate
  from CustomRDWExtractServices s
       join Charges c on c.ServiceId = s.ServiceId
 where isnull(c.RecordDeleted, ''N'') = ''N''
   and c.Priority = 0

if @@error <> 0 goto error

-- Exceptions: there is a ledger activity for a coverage that is not the coverage history
insert into #ServiceCoveragePlanExceptions (
       ServiceId,
       ChargeId,
       ClientCoveragePlanId)
select s.ServiceId,
       c.ChargeId,
       c.ClientCoveragePlanId
  from CustomRDWExtractServices s
       join Charges c on c.ServiceId = s.ServiceId
 where isnull(c.RecordDeleted, ''N'') = ''N''
   and not exists(select *
                    from #ServiceCoveragePlans scp 
                   where scp.ChargeId = c.ChargeId)
   and exists(select ''*''
                from ARLedger arl
               where arl.ChargeId = c.ChargeId
                 and isnull(arl.RecordDeleted, ''N'') = ''N''
               group by arl.ChargeId
              having sum(case when arl.LedgerType in (4201, 4204) then amount else 0 end) <> 0 -- Charges, Trasfers
                  or sum(case when arl.LedgerType in (4202) then amount else 0 end) <> 0 -- Payments
                  or sum(case when arl.LedgerType in (4203) then amount else 0 end) <> 0) -- Adjustments
 order by s.ServiceId, c.Priority

if @@error <> 0 goto error

update e
   set CopayPriority = e.RecordId - s.FirstRecordId + 1
  from #ServiceCoveragePlanExceptions e
       join (select ServiceId,
                    min(RecordId) as FirstRecordId
               from #ServiceCoveragePlanExceptions
              group by ServiceId) s on s.ServiceId = e.ServiceId

if @@error <> 0 goto error

insert into #ServiceCoveragePlans (
       ServiceId,
       ChargeId,
       ClientCoveragePlanId,
       CopayPriority,
       ExpectedPayment,
       BilledDate)
select scpe.ServiceId,
       scpe.ChargeId,
       scpe.ClientCoveragePlanId,
       scpe.CopayPriority + isnull(scp.CopayPriority, 0),
       c.ExpectedPayment,
       c.LastBilledDate
  from #ServiceCoveragePlanExceptions scpe
       join Charges c on c.ChargeId = scpe.ChargeId
       left join (select ServiceId,
                         max(CopayPriority) as CopayPriority
                    from #ServiceCoveragePlans
                   group by ServiceId) as scp on scp.ServiceId = scpe.ServiceId

if @@error <> 0 goto error

-- Since there are only 6 buckets for other coverage plans,
-- delete plans that don''t have any charges associated with them and with priority less than the first charge
-- if # of other coverage plans exceeds 6
delete from #ServiceCoveragePlans 
  from #ServiceCoveragePlans cp
       join (select ServiceId,
                    min(CopayPriority) as CopayPriority
               from #ServiceCoveragePlans
              where ChargeId is not null
                and CopayPriority <> 0
              group by ServiceId) as fcp on fcp.ServiceId = cp.ServiceId
       join (select scp.ServiceId,
                    count(*) as PlanCount
               from #ServiceCoveragePlans scp
                    join ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = scp.ClientCoveragePlanId
              where scp.CopayPriority <> 0
                and not exists(select *
                                 from CustomRDWExtractCapitatedCoveragePlans capcp 
                                where capcp.CoveragePlanId = ccp.CoveragePlanId
                                  and capcp.CoveragePlanType in (''ABW'', ''GF'', ''MEDICAID'', ''MICHILD''))
              group by scp.ServiceId) as pc on pc.ServiceId = cp.ServiceId
 where cp.ChargeId is null
   and cp.CopayPriority < fcp.CopayPriority
   and pc.PlanCount > 6

if @@error <> 0 goto error

-- If # of other coverage plans still exceeds 6
-- delete all plans that don''t have any charges associated with them
delete from #ServiceCoveragePlans 
  from #ServiceCoveragePlans cp
       join (select scp.ServiceId,
                    count(*) as PlanCount
               from #ServiceCoveragePlans scp
                    join ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = scp.ClientCoveragePlanId
              where scp.CopayPriority <> 0
                and not exists(select *
                                 from CustomRDWExtractCapitatedCoveragePlans capcp 
                                where capcp.CoveragePlanId = ccp.CoveragePlanId
                                  and capcp.CoveragePlanType in (''ABW'', ''GF'', ''MEDICAID'', ''MICHILD''))
              group by scp.ServiceId) as pc on pc.ServiceId = cp.ServiceId
 where cp.ChargeId is null
   and pc.PlanCount > 6

if @@error <> 0 goto error

update scp
   set Charge = arl.Charge,
       Adjustment = arl.Adjustment,
       Payment = arl.Payment,
       PaymentDate = arl.PaymentDate
  from #ServiceCoveragePlans scp
       join (select ChargeId,
                    sum(case when LedgerType in (4201, 4204) then Amount else 0 end) as Charge,
                    sum(case when LedgerType = 4203 then Amount else 0 end) as Adjustment,
                    sum(case when LedgerType = 4202 then Amount else 0 end) as Payment,
                    max(case when LedgerType = 4202 then PostedDate else null end) as PaymentDate
               from ARLedger
              where isnull(RecordDeleted, ''N'') = ''N''
                and PostedDate <= @ExtractDate
              group by ChargeId) as arl on arl.ChargeId = scp.ChargeId

if @@error <> 0 goto error

insert into #ServiceOtherPayers (
       ServiceId,
       ClientCoveragePlanId)
select scp.ServiceId,
       scp.ClientCoveragePlanId
  from #ServiceCoveragePlans scp
       join ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = scp.ClientCoveragePlanId
 where not exists(select *
                    from CustomRDWExtractCapitatedCoveragePlans capcp 
                   where capcp.CoveragePlanId = ccp.CoveragePlanId
                     and capcp.CoveragePlanType in (''ABW'', ''GF'', ''MEDICAID'', ''MICHILD''))
 order by scp.ServiceId,
          scp.CopayPriority

if @@error <> 0 goto error

update sop
   set OtherPayerPriority = sop.RecordId - s.FirstRecordId + 1
  from #ServiceOtherPayers sop
       join (select ServiceId,
                    min(RecordId) as FirstRecordId
               from #ServiceOtherPayers
              group by ServiceId) s on s.ServiceId = sop.ServiceId

if @@error <> 0 goto error

update s
   set MedicaidCoveragePlanId = scp.MedicaidCoveragePlanId,
       MedicaidInsuredId = scp.MedicaidInsuredId,
       MedicaidCopayPriority = scp.MedicaidCopayPriority,
       MedicaidExpectedPayment = case when scp.MedicaidCoveragePlanId is not null then isnull(scp.MedicaidExpectedPayment, 0) else null end,
       MedicaidCharge = case when scp.MedicaidCoveragePlanId is not null then isnull(scp.MedicaidCharge, 0) else null end,
       MedicaidPayment = case when scp.MedicaidCoveragePlanId is not null then isnull(scp.MedicaidPayment, 0) else null end,
       MedicaidAdjustment = case when scp.MedicaidCoveragePlanId is not null then isnull(scp.MedicaidAdjustment, 0) else null end,
       MedicaidBilledDate = scp.MedicaidBilledDate,
       MedicaidPaymentDate = scp.MedicaidPaymentDate,

       GFCoveragePlanId = scp.GFCoveragePlanId,
       GFInsuredId = scp.GFInsuredId,
       GFCopayPriority = scp.GFCopayPriority,
       GFExpectedPayment = case when scp.GFCoveragePlanId is not null then isnull(scp.GFExpectedPayment, 0) else null end,
       GFCharge = case when scp.GFCoveragePlanId is not null then isnull(scp.GFCharge, 0) else null end,
       GFPayment = case when scp.GFCoveragePlanId is not null then isnull(scp.GFPayment, 0) else null end,
       GFAdjustment = case when scp.GFCoveragePlanId is not null then isnull(scp.GFAdjustment, 0) else null end,
       GFBilledDate = scp.GFBilledDate,
       GFPaymentDate = scp.GFPaymentDate,

       MIChildCoveragePlanId = scp.MIChildCoveragePlanId,
       MIChildInsuredId = scp.MIChildInsuredId,
       MIChildCopayPriority = scp.MIChildCopayPriority,
       MIChildExpectedPayment = case when scp.MIChildCoveragePlanId is not null then isnull(scp.MIChildExpectedPayment, 0) else null end,
       MIChildCharge = case when scp.MIChildCoveragePlanId is not null then isnull(scp.MIChildCharge, 0) else null end,
       MIChildPayment = case when scp.MIChildCoveragePlanId is not null then isnull(scp.MIChildPayment, 0) else null end,
       MIChildAdjustment = case when scp.MIChildCoveragePlanId is not null then isnull(scp.MIChildAdjustment, 0) else null end,
       MIChildBilledDate = scp.MIChildBilledDate,
       MIChildPaymentDate = scp.MIChildPaymentDate,

       ABWCoveragePlanId = scp.ABWCoveragePlanId,
       ABWInsuredId = scp.ABWInsuredId,
       ABWCopayPriority = scp.ABWCopayPriority,
       ABWExpectedPayment = case when scp.ABWCoveragePlanId is not null then isnull(scp.ABWExpectedPayment, 0) else null end,
       ABWCharge = case when scp.ABWCoveragePlanId is not null then isnull(scp.ABWCharge, 0) else null end,
       ABWPayment = case when scp.ABWCoveragePlanId is not null then isnull(scp.ABWPayment, 0) else null end,
       ABWAdjustment = case when scp.ABWCoveragePlanId is not null then isnull(scp.ABWAdjustment, 0) else null end,
       ABWBilledDate = scp.ABWBilledDate,
       ABWPaymentDate = scp.ABWPaymentDate,

       OtherPayerCoveragePlanId1 = scp.OtherPayerCoveragePlanId1,
       OtherPayerName1 = scp.OtherPayerName1,
       OtherPayerCopayPriority1 = scp.OtherPayerCopayPriority1,
       OtherPayerInsuredId1 = scp.OtherPayerInsuredId1,
       OtherPayerInsuredName1 = scp.OtherPayerInsuredName1,
       OtherPayerInsuredDOB1 = scp.OtherPayerInsuredDOB1,
       OtherPayerCharge1 = case when scp.OtherPayerCoveragePlanId1 is not null then isnull(scp.OtherPayerCharge1, 0) else null end,
       OtherPayerPayment1 = case when scp.OtherPayerCoveragePlanId1 is not null then isnull(scp.OtherPayerPayment1, 0) else null end,
       OtherPayerAdjustment1 = case when scp.OtherPayerCoveragePlanId1 is not null then isnull(scp.OtherPayerAdjustment1, 0) else null end,
       OtherPayerBilledDate1 = scp.OtherPayerBilledDate1,
       OtherPayerPaymentDate1 = scp.OtherPayerPaymentDate1,

       OtherPayerCoveragePlanId2 = scp.OtherPayerCoveragePlanId2,
       OtherPayerName2 = scp.OtherPayerName2,
       OtherPayerCopayPriority2 = scp.OtherPayerCopayPriority2,
       OtherPayerInsuredId2 = scp.OtherPayerInsuredId2,
       OtherPayerInsuredName2 = scp.OtherPayerInsuredName2,
       OtherPayerInsuredDOB2 = scp.OtherPayerInsuredDOB2,
       OtherPayerCharge2 = case when scp.OtherPayerCoveragePlanId2 is not null then isnull(scp.OtherPayerCharge2, 0) else null end,
       OtherPayerPayment2 = case when scp.OtherPayerCoveragePlanId2 is not null then isnull(scp.OtherPayerPayment2, 0) else null end,
       OtherPayerAdjustment2 = case when scp.OtherPayerCoveragePlanId2 is not null then isnull(scp.OtherPayerAdjustment2, 0) else null end,
       OtherPayerBilledDate2 = scp.OtherPayerBilledDate2,
       OtherPayerPaymentDate2 = scp.OtherPayerPaymentDate2,

       OtherPayerCoveragePlanId3 = scp.OtherPayerCoveragePlanId3,
       OtherPayerName3 = scp.OtherPayerName3,
       OtherPayerCopayPriority3 = scp.OtherPayerCopayPriority3,
       OtherPayerInsuredId3 = scp.OtherPayerInsuredId3,
       OtherPayerInsuredName3 = scp.OtherPayerInsuredName3,
       OtherPayerInsuredDOB3 = scp.OtherPayerInsuredDOB3,
       OtherPayerCharge3 = case when scp.OtherPayerCoveragePlanId3 is not null then isnull(scp.OtherPayerCharge3, 0) else null end,
       OtherPayerPayment3 = case when scp.OtherPayerCoveragePlanId3 is not null then isnull(scp.OtherPayerPayment3, 0) else null end,
       OtherPayerAdjustment3 = case when scp.OtherPayerCoveragePlanId3 is not null then isnull(scp.OtherPayerAdjustment3, 0) else null end,
       OtherPayerBilledDate3 = scp.OtherPayerBilledDate3,
       OtherPayerPaymentDate3 = scp.OtherPayerPaymentDate3,

       OtherPayerCoveragePlanId4 = scp.OtherPayerCoveragePlanId4,
       OtherPayerName4 = scp.OtherPayerName4,
       OtherPayerCopayPriority4 = scp.OtherPayerCopayPriority4,
       OtherPayerInsuredId4 = scp.OtherPayerInsuredId4,
       OtherPayerInsuredName4 = scp.OtherPayerInsuredName4,
       OtherPayerInsuredDOB4 = scp.OtherPayerInsuredDOB4,
       OtherPayerCharge4 = case when scp.OtherPayerCoveragePlanId4 is not null then isnull(scp.OtherPayerCharge4, 0) else null end,
       OtherPayerPayment4 = case when scp.OtherPayerCoveragePlanId4 is not null then isnull(scp.OtherPayerPayment4, 0) else null end,
       OtherPayerAdjustment4 = case when scp.OtherPayerCoveragePlanId4 is not null then isnull(scp.OtherPayerAdjustment4, 0) else null end,
       OtherPayerBilledDate4 = scp.OtherPayerBilledDate4,
       OtherPayerPaymentDate4 = scp.OtherPayerPaymentDate4,

       OtherPayerCoveragePlanId5 = scp.OtherPayerCoveragePlanId5,
       OtherPayerName5 = scp.OtherPayerName5,
       OtherPayerCopayPriority5 = scp.OtherPayerCopayPriority5,
       OtherPayerInsuredId5 = scp.OtherPayerInsuredId5,
       OtherPayerInsuredName5 = scp.OtherPayerInsuredName5,
       OtherPayerInsuredDOB5 = scp.OtherPayerInsuredDOB5,
       OtherPayerCharge5 = case when scp.OtherPayerCoveragePlanId5 is not null then isnull(scp.OtherPayerCharge5, 0) else null end,
       OtherPayerPayment5 = case when scp.OtherPayerCoveragePlanId5 is not null then isnull(scp.OtherPayerPayment5, 0) else null end,
       OtherPayerAdjustment5 = case when scp.OtherPayerCoveragePlanId5 is not null then isnull(scp.OtherPayerAdjustment5, 0) else null end,
       OtherPayerBilledDate5 = scp.OtherPayerBilledDate5,
       OtherPayerPaymentDate5 = scp.OtherPayerPaymentDate5,

       OtherPayerCoveragePlanId6 = scp.OtherPayerCoveragePlanId6,
       OtherPayerName6 = scp.OtherPayerName6,
       OtherPayerCopayPriority6 = scp.OtherPayerCopayPriority6,
       OtherPayerInsuredId6 = scp.OtherPayerInsuredId6,
       OtherPayerInsuredName6 = scp.OtherPayerInsuredName6,
       OtherPayerInsuredDOB6 = scp.OtherPayerInsuredDOB6,
       OtherPayerCharge6 = case when scp.OtherPayerCoveragePlanId6 is not null then isnull(scp.OtherPayerCharge6, 0) else null end,
       OtherPayerPayment6 = case when scp.OtherPayerCoveragePlanId6 is not null then isnull(scp.OtherPayerPayment6, 0) else null end,
       OtherPayerAdjustment6 = case when scp.OtherPayerCoveragePlanId6 is not null then isnull(scp.OtherPayerAdjustment6, 0) else null end,
       OtherPayerBilledDate6 = scp.OtherPayerBilledDate6,
       OtherPayerPaymentDate6 = scp.OtherPayerPaymentDate6,

       ClientExpectedPayment = case when scp.ClientCoveragePlanId is not null then isnull(scp.ClientExpectedPayment, 0) else null end,
       ClientCharge = case when scp.ClientCoveragePlanId is not null then isnull(scp.ClientCharge, 0) else null end,
       ClientPayment = case when scp.ClientCoveragePlanId is not null then isnull(scp.ClientPayment, 0) else null end,
       ClientAdjustment = case when scp.ClientCoveragePlanId is not null then isnull(scp.ClientAdjustment, 0) else null end,
       ClientBilledDate = scp.ClientBilledDate,
       ClientPaymentDate = scp.ClientPaymentDate,

       Charge = isnull(scp.MedicaidCharge, 0) + isnull(scp.GFCharge, 0) + isnull(scp.ABWCharge, 0) + isnull(scp.MIChildCharge, 0) +
                isnull(scp.OtherPayerCharge1, 0) + isnull(scp.OtherPayerCharge2, 0) + isnull(scp.OtherPayerCharge3, 0) +
                isnull(scp.OtherPayerCharge4, 0) + isnull(scp.OtherPayerCharge5, 0) + isnull(scp.OtherPayerCharge6, 0) +
                isnull(scp.ClientCharge, 0)

  from CustomRDWExtractServices s
       join (select scp.ServiceId,
                    max(case when capcp.CoveragePlanType = ''MEDICAID'' then cp.DisplayAs else null end) as MedicaidCoveragePlanId,
                    max(case when capcp.CoveragePlanType = ''MEDICAID'' then ccp.InsuredId else null end) as MedicaidInsuredId,
                    max(case when capcp.CoveragePlanType = ''MEDICAID'' then scp.CopayPriority else null end) as MedicaidCopayPriority,
                    sum(case when capcp.CoveragePlanType = ''MEDICAID'' then scp.ExpectedPayment else null end) as MedicaidExpectedPayment,
                    sum(case when capcp.CoveragePlanType = ''MEDICAID'' then scp.Charge else null end) as MedicaidCharge,
                    sum(case when capcp.CoveragePlanType = ''MEDICAID'' then scp.Payment else null end) as MedicaidPayment,
                    sum(case when capcp.CoveragePlanType = ''MEDICAID'' then scp.Adjustment else null end) as MedicaidAdjustment,
                    max(case when capcp.CoveragePlanType = ''MEDICAID'' then scp.BilledDate else null end) as MedicaidBilledDate,
                    max(case when capcp.CoveragePlanType = ''MEDICAID'' then scp.PaymentDate else null end) as MedicaidPaymentDate,

                    max(case when capcp.CoveragePlanType = ''GF'' then cp.DisplayAs else null end) as GFCoveragePlanId,
                    max(case when capcp.CoveragePlanType = ''GF'' then ccp.InsuredId else null end) as GFInsuredId,
                    max(case when capcp.CoveragePlanType = ''GF'' then scp.CopayPriority else null end) as GFCopayPriority,
                    max(case when capcp.CoveragePlanType = ''GF'' then scp.ExpectedPayment else null end) as GFExpectedPayment,
                    sum(case when capcp.CoveragePlanType = ''GF'' then scp.Charge else null end) as GFCharge,
                    sum(case when capcp.CoveragePlanType = ''GF'' then scp.Payment else null end) as GFPayment,
                    sum(case when capcp.CoveragePlanType = ''GF'' then scp.Adjustment else null end) as GFAdjustment,
                    max(case when capcp.CoveragePlanType = ''GF'' then scp.BilledDate else null end) as GFBilledDate,
                    max(case when capcp.CoveragePlanType = ''GF'' then scp.PaymentDate else null end) as GFPaymentDate,

                    max(case when capcp.CoveragePlanType = ''MICHILD'' then cp.DisplayAs else null end) as MIChildCoveragePlanId,
                    max(case when capcp.CoveragePlanType = ''MICHILD'' then ccp.InsuredId else null end) as MIChildInsuredId,
                    max(case when capcp.CoveragePlanType = ''MICHILD'' then scp.CopayPriority else null end) as MIChildCopayPriority,
                    max(case when capcp.CoveragePlanType = ''MICHILD'' then scp.ExpectedPayment else null end) as MIChildExpectedPayment,
                    sum(case when capcp.CoveragePlanType = ''MICHILD'' then scp.Charge else null end) as MIChildCharge,
                    sum(case when capcp.CoveragePlanType = ''MICHILD'' then scp.Payment else null end) as MIChildPayment,
                    sum(case when capcp.CoveragePlanType = ''MICHILD'' then scp.Adjustment else null end) as MIChildAdjustment,
                    max(case when capcp.CoveragePlanType = ''MICHILD'' then scp.BilledDate else null end) as MIChildBilledDate,
                    max(case when capcp.CoveragePlanType = ''MICHILD'' then scp.PaymentDate else null end) as MIChildPaymentDate,

                    max(case when capcp.CoveragePlanType = ''ABW'' then cp.DisplayAs else null end) as ABWCoveragePlanId,
                    max(case when capcp.CoveragePlanType = ''ABW'' then ccp.InsuredId else null end) as ABWInsuredId,
                    max(case when capcp.CoveragePlanType = ''ABW'' then scp.CopayPriority else null end) as ABWCopayPriority,
                    max(case when capcp.CoveragePlanType = ''ABW'' then scp.ExpectedPayment else null end) as ABWExpectedPayment,
                    sum(case when capcp.CoveragePlanType = ''ABW'' then scp.Charge else null end) as ABWCharge,
                    sum(case when capcp.CoveragePlanType = ''ABW'' then scp.Payment else null end) as ABWPayment,
                    sum(case when capcp.CoveragePlanType = ''ABW'' then scp.Adjustment else null end) as ABWAdjustment,
                    max(case when capcp.CoveragePlanType = ''ABW'' then scp.BilledDate else null end) as ABWBilledDate,
                    max(case when capcp.CoveragePlanType = ''ABW'' then scp.PaymentDate else null end) as ABWPaymentDate,

                    max(case when sop.OtherPayerPriority = 1 then cp.DisplayAs else null end) as OtherPayerCoveragePlanId1,
                    max(case when sop.OtherPayerPriority = 1 then cp.CoveragePlanName else null end) as OtherPayerName1,
                    max(case when sop.OtherPayerPriority = 1 then scp.CopayPriority else null end) as OtherPayerCopayPriority1,
                    max(case when sop.OtherPayerPriority = 1 then ccp.InsuredId else null end) as OtherPayerInsuredId1,
                    max(case when sop.OtherPayerPriority = 1 then case when ccp.ClientIsSubscriber = ''Y'' then c.LastName + '', '' + c.FirstName else cc.LastName + '', '' + cc.FirstName end else null end) OtherPayerInsuredName1,
                    max(case when sop.OtherPayerPriority = 1 then case when ccp.ClientIsSubscriber = ''Y'' then c.DOB else cc.DOB end else null end) OtherPayerInsuredDOB1,
                    sum(case when sop.OtherPayerPriority = 1 then scp.Charge else null end) as OtherPayerCharge1,
                    sum(case when sop.OtherPayerPriority = 1 then scp.Payment else null end) as OtherPayerPayment1,
                    sum(case when sop.OtherPayerPriority = 1 then scp.Adjustment else null end) as OtherPayerAdjustment1,
                    max(case when sop.OtherPayerPriority = 1 then scp.BilledDate else null end) as OtherPayerBilledDate1,
                    max(case when sop.OtherPayerPriority = 1 then scp.PaymentDate else null end) as OtherPayerPaymentDate1,

                    max(case when sop.OtherPayerPriority = 2 then cp.DisplayAs else null end) as OtherPayerCoveragePlanId2,
                    max(case when sop.OtherPayerPriority = 2 then cp.CoveragePlanName else null end) as OtherPayerName2,
                    max(case when sop.OtherPayerPriority = 2 then scp.CopayPriority else null end) as OtherPayerCopayPriority2,
                    max(case when sop.OtherPayerPriority = 2 then ccp.InsuredId else null end) as OtherPayerInsuredId2,
                    max(case when sop.OtherPayerPriority = 2 then case when ccp.ClientIsSubscriber = ''Y'' then c.LastName + '', '' + c.FirstName else cc.LastName + '', '' + cc.FirstName end else null end) OtherPayerInsuredName2,
                    max(case when sop.OtherPayerPriority = 2 then case when ccp.ClientIsSubscriber = ''Y'' then c.DOB else cc.DOB end else null end) OtherPayerInsuredDOB2,
                    sum(case when sop.OtherPayerPriority = 2 then scp.Charge else null end) as OtherPayerCharge2,
                    sum(case when sop.OtherPayerPriority = 2 then scp.Payment else null end) as OtherPayerPayment2,
                    sum(case when sop.OtherPayerPriority = 2 then scp.Adjustment else null end) as OtherPayerAdjustment2,
                    max(case when sop.OtherPayerPriority = 2 then scp.BilledDate else null end) as OtherPayerBilledDate2,
                    max(case when sop.OtherPayerPriority = 2 then scp.PaymentDate else null end) as OtherPayerPaymentDate2,

                    max(case when sop.OtherPayerPriority = 3 then cp.DisplayAs else null end) as OtherPayerCoveragePlanId3,
                    max(case when sop.OtherPayerPriority = 3 then cp.CoveragePlanName else null end) as OtherPayerName3,
                    max(case when sop.OtherPayerPriority = 3 then scp.CopayPriority else null end) as OtherPayerCopayPriority3,
                    max(case when sop.OtherPayerPriority = 3 then ccp.InsuredId else null end) as OtherPayerInsuredId3,
                    max(case when sop.OtherPayerPriority = 3 then case when ccp.ClientIsSubscriber = ''Y'' then c.LastName + '', '' + c.FirstName else cc.LastName + '', '' + cc.FirstName end else null end) OtherPayerInsuredName3,
                    max(case when sop.OtherPayerPriority = 3 then case when ccp.ClientIsSubscriber = ''Y'' then c.DOB else cc.DOB end else null end) OtherPayerInsuredDOB3,
                    sum(case when sop.OtherPayerPriority = 3 then scp.Charge else null end) as OtherPayerCharge3,
                    sum(case when sop.OtherPayerPriority = 3 then scp.Payment else null end) as OtherPayerPayment3,
                    sum(case when sop.OtherPayerPriority = 3 then scp.Adjustment else null end) as OtherPayerAdjustment3,
                    max(case when sop.OtherPayerPriority = 3 then scp.BilledDate else null end) as OtherPayerBilledDate3,
                    max(case when sop.OtherPayerPriority = 3 then scp.PaymentDate else null end) as OtherPayerPaymentDate3,

                    max(case when sop.OtherPayerPriority = 4 then cp.DisplayAs else null end) as OtherPayerCoveragePlanId4,
                    max(case when sop.OtherPayerPriority = 4 then cp.CoveragePlanName else null end) as OtherPayerName4,
                    max(case when sop.OtherPayerPriority = 4 then scp.CopayPriority else null end) as OtherPayerCopayPriority4,
                    max(case when sop.OtherPayerPriority = 4 then ccp.InsuredId else null end) as OtherPayerInsuredId4,
                    max(case when sop.OtherPayerPriority = 4 then case when ccp.ClientIsSubscriber = ''Y'' then c.LastName + '', '' + c.FirstName else cc.LastName + '', '' + cc.FirstName end else null end) OtherPayerInsuredName4,
                    max(case when sop.OtherPayerPriority = 4 then case when ccp.ClientIsSubscriber = ''Y'' then c.DOB else cc.DOB end else null end) OtherPayerInsuredDOB4,
                    sum(case when sop.OtherPayerPriority = 4 then scp.Charge else null end) as OtherPayerCharge4,
                    sum(case when sop.OtherPayerPriority = 4 then scp.Payment else null end) as OtherPayerPayment4,
                    sum(case when sop.OtherPayerPriority = 4 then scp.Adjustment else null end) as OtherPayerAdjustment4,
                    max(case when sop.OtherPayerPriority = 4 then scp.BilledDate else null end) as OtherPayerBilledDate4,
                    max(case when sop.OtherPayerPriority = 4 then scp.PaymentDate else null end) as OtherPayerPaymentDate4,

                    max(case when sop.OtherPayerPriority = 5 then cp.DisplayAs else null end) as OtherPayerCoveragePlanId5,
                    max(case when sop.OtherPayerPriority = 5 then cp.CoveragePlanName else null end) as OtherPayerName5,
                    max(case when sop.OtherPayerPriority = 5 then scp.CopayPriority else null end) as OtherPayerCopayPriority5,
                    max(case when sop.OtherPayerPriority = 5 then ccp.InsuredId else null end) as OtherPayerInsuredId5,
                    max(case when sop.OtherPayerPriority = 5 then case when ccp.ClientIsSubscriber = ''Y'' then c.LastName + '', '' + c.FirstName else cc.LastName + '', '' + cc.FirstName end else null end) OtherPayerInsuredName5,
                    max(case when sop.OtherPayerPriority = 5 then case when ccp.ClientIsSubscriber = ''Y'' then c.DOB else cc.DOB end else null end) OtherPayerInsuredDOB5,
                    sum(case when sop.OtherPayerPriority = 5 then scp.Charge else null end) as OtherPayerCharge5,
                    sum(case when sop.OtherPayerPriority = 5 then scp.Payment else null end) as OtherPayerPayment5,
                    sum(case when sop.OtherPayerPriority = 5 then scp.Adjustment else null end) as OtherPayerAdjustment5,
                    max(case when sop.OtherPayerPriority = 5 then scp.BilledDate else null end) as OtherPayerBilledDate5,
                    max(case when sop.OtherPayerPriority = 5 then scp.PaymentDate else null end) as OtherPayerPaymentDate5,

                    max(case when sop.OtherPayerPriority = 6 then cp.DisplayAs else null end) as OtherPayerCoveragePlanId6,
                    max(case when sop.OtherPayerPriority = 6 then cp.CoveragePlanName else null end) as OtherPayerName6,
                    max(case when sop.OtherPayerPriority = 6 then scp.CopayPriority else null end) as OtherPayerCopayPriority6,
                    max(case when sop.OtherPayerPriority = 6 then ccp.InsuredId else null end) as OtherPayerInsuredId6,
                    max(case when sop.OtherPayerPriority = 6 then case when ccp.ClientIsSubscriber = ''Y'' then c.LastName + '', '' + c.FirstName else cc.LastName + '', '' + cc.FirstName end else null end) OtherPayerInsuredName6,
                    max(case when sop.OtherPayerPriority = 6 then case when ccp.ClientIsSubscriber = ''Y'' then c.DOB else cc.DOB end else null end) OtherPayerInsuredDOB6,
                    sum(case when sop.OtherPayerPriority = 6 then scp.Charge else null end) as OtherPayerCharge6,
                    sum(case when sop.OtherPayerPriority = 6 then scp.Payment else null end) as OtherPayerPayment6,
                    sum(case when sop.OtherPayerPriority = 6 then scp.Adjustment else null end) as OtherPayerAdjustment6,
                    max(case when sop.OtherPayerPriority = 6 then scp.BilledDate else null end) as OtherPayerBilledDate6,
                    max(case when sop.OtherPayerPriority = 6 then scp.PaymentDate else null end) as OtherPayerPaymentDate6,

                    max(case when scp.CopayPriority = 0 then ''CLIENT'' else null end) as ClientCoveragePlanId,
                    max(case when scp.CopayPriority = 0 then scp.ExpectedPayment else null end) as ClientExpectedPayment,
                    sum(case when scp.CopayPriority = 0 then scp.Charge else null end) as ClientCharge,
                    sum(case when scp.CopayPriority = 0 then scp.Payment else null end) as ClientPayment,
                    sum(case when scp.CopayPriority = 0 then scp.Adjustment else null end) as ClientAdjustment,
                    max(case when scp.CopayPriority = 0 then scp.BilledDate else null end) as ClientBilledDate,
                    max(case when scp.CopayPriority = 0 then scp.PaymentDate else null end) as ClientPaymentDate

               from #ServiceCoveragePlans scp
                    left join ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = scp.ClientCoveragePlanId
                    left join CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId
                    left join CustomRDWExtractCapitatedCoveragePlans capcp on capcp.CoveragePlanId = cp.CoveragePlanId and capcp.CoveragePlanType in (''ABW'', ''GF'', ''MEDICAID'', ''MICHILD'')
                    left join #ServiceOtherPayers sop on sop.ServiceId = scp.ServiceId and sop.ClientCoveragePlanId = scp.ClientCoveragePlanId
                    left join Clients c on c.ClientId = ccp.ClientId
                    left join ClientContacts cc on cc.ClientContactId = ccp.SubscriberContactId
              group by scp.ServiceId) as scp on scp.ServiceId = s.ServiceId          
                  
if @@error <> 0 goto error

--
-- Calculate billing codes and units
--

-- Fiscal years that need to be recalculated
insert into #ReportingYears (StartDate) values (@ReportingYear)

if @@error <> 0 goto error

if datediff(mm, @ReportingYear, getdate()) >= 12
begin
  insert into #ReportingYears (StartDate)
  select dateadd(yy, floor(datediff(mm, @ReportingYear, getdate())/12), @ReportingYear)

  if @@error <> 0 goto error
end  

-- Services that need to be recalculated
insert into #ClaimLines (
       ServiceId)
select ServiceId
  from CustomRDWExtractServices s
 where s.Billable = ''Y''
   and s.Status <> ''ER''
   and exists(select *
                from #ReportingYears ry
               where s.DateOfService >= ry.StartDate
                 and s.DateOfService < dateadd(yy, 1, ry.StartDate))

if @@error <> 0 goto error

insert into #ClaimLines (
       ServiceId)
select ServiceId
  from CustomRDWExtractServices s
 where s.Billable = ''Y''
   and s.Status <> ''ER''
   and not exists(select *
                    from CustomRDWExtractServicesSent ss
                   where ss.ServiceId = s.ServiceId)
   and not exists(select *
                    from #ClaimLines cl
                   where cl.ServiceId = s.ServiceId)

if @@error <> 0 goto error

update cl
   set ServiceUnits = s.Unit
  from #ClaimLines cl
       join Services s on s.ServiceId = cl.ServiceId

if @@error <> 0 goto error

-- if client has Medicaid, set coverage to Medicaid regardless if there is a charge for it
update cl
   set CoveragePlanId = ccp.CoveragePlanId
  from #ClaimLines cl
       join #ServiceCoveragePlans scp on scp.ServiceId = cl.ServiceId
       join ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = scp.ClientCoveragePlanId
       join CustomRDWExtractCapitatedCoveragePlans capcp on capcp.CoveragePlanId = ccp.CoveragePlanId
 where capcp.CoveragePlanType = ''MEDICAID''

if @@error <> 0 goto error

update cl
   set CoveragePlanId = ccp.CoveragePlanId
  from #ClaimLines cl
       join Charges c on c.ServiceId = cl.ServiceId
       join ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = c.ClientCoveragePlanId
 where cl.CoveragePlanid is null
   and isnull(c.RecordDeleted, ''N'') = ''N'' 
   and exists(select ''*''
                from ARLedger arl
               where arl.ChargeId = c.ChargeId
                 and arl.LedgerType in (4201, 4204) -- Charges, Trasfers
                 and isnull(arl.RecordDeleted, ''N'') = ''N''
               group by arl.ChargeId
              having sum(arl.Amount) <> 0)
   and not exists(select *
                    from Charges c2
                   where c2.ServiceId = cl.ServiceId
                     and isnull(c2.RecordDeleted, ''N'') = ''N''
                     and case when c2.Priority = 0 then 100 else c2.Priority end < case when c.Priority = 0 then 100 else c.Priority end
                     and exists(select ''*''
                                  from ARLedger arl2
                                 where arl2.ChargeId = c2.ChargeId
                                   and arl2.LedgerType in (4201, 4204) -- Charges, Trasfers
                                   and isnull(arl2.RecordDeleted, ''N'') = ''N''
                                 group by arl2.ChargeId
                                having sum(arl2.Amount) <> 0))

if @@error <> 0 goto error

update cl
   set CoveragePlanId = ccp.CoveragePlanId
  from #ClaimLines cl
       join #ServiceCoveragePlans scp on scp.ServiceId = cl.ServiceId
       join ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = scp.ClientCoveragePlanId
 where cl.CoveragePlanId is null 
   and not exists(select * 
                    from #ServiceCoveragePlans scp2
                   where scp2.ServiceId = cl.ServiceId
                     and case when scp2.CopayPriority = 0 then 100 else scp2.CopayPriority end < 
                         case when scp.CopayPriority  = 0 then 100 else scp.CopayPriority  end)

if @@error <> 0 goto error

-- Calculate cpt codes and units
exec ssp_PMClaimsGetBillingCodes

if @@error <> 0 goto error

update s
   set CPTCode = cl.BillingCode,
       BillingCPTCode = cl.BillingCode,
       CPTModifier1 = cl.Modifier1,
       CPTModifier2 = cl.Modifier2,
       CPTModifier3 = cl.Modifier3,
       Units = cl.ClaimUnits
  from CustomRDWExtractServices s
       join #ClaimLines cl on s.ServiceId = cl.ServiceId

if @@error <> 0 goto error

update s
   set CPTCode = ''XXXXX'',
       BillingCPTCode = ''XXXXX'',
       CPTModifier1 = null,
       CPTModifier2 = null,
       CPTModifier3 = null,
       Units = 0
  from CustomRDWExtractServices s
 where CPTCode is null

if @@error <> 0 goto error

--
-- Calculate billing cpt codes that could different from cpt codes
--

update cl
   set RecalculateBillingCode = ''Y'',
       CoveragePlanId = arl.CoveragePlanId,
       BillingCode = null,
       Modifier1 = null,
       Modifier2 = null,
       Modifier3 = null,
       ClaimUnits = null
  from #ClaimLines cl
       join Services s on s.ServiceId = cl.ServiceId
       join Charges c on c.ServiceId = s.ServiceId
       join ARLedger arl on arl.ChargeId = c.ChargeId and arl.LedgerType = 4201
 where isnull(cl.CoveragePlanId, 0) <> isnull(arl.CoveragePlanId, 0)
   and isnull(c.RecordDeleted, ''N'') = ''N''
   and isnull(arl.RecordDeleted, ''N'') = ''N''

if @@error <> 0 goto error

delete from #ClaimLines where isnull(RecalculateBillingCode, ''N'') <> ''Y''

if @@error <> 0 goto error

exec ssp_PMClaimsGetBillingCodes

if @@error <> 0 goto error

update s
   set BillingCPTCode = isnull(cl.BillingCode, ''XXXXX'')
  from CustomRDWExtractServices s
       join #ClaimLines cl on s.ServiceId = cl.ServiceId
 
if @@error <> 0 goto error

--
-- Get service error
--
update s
   set ServiceError = se.ErrorMessage
  from CustomRDWExtractServices s
       join ServiceErrors se on se.ServiceId = s.ServiceId
 where se.ErrorSeverity = ''E''
   and isnull(se.RecordDeleted, ''N'') = ''N''
   and not exists(select *
                    from ServiceErrors se2
                   where se2.ServiceId = s.ServiceId
                     and se2.ErrorSeverity = ''E''
                     and isnull(se2.RecordDeleted, ''N'') = ''N''
                     and se2.ServiceErrorId < se.ServiceErrorId)

if @@error <> 0 goto error

--
-- Custom processing
--
exec csp_RDWExtractServicesCustom @AffiliateId = @AffiliateId

if @@error <> 0 goto error

--
-- Check for Changes
--

update s
   set ExtractStatus = ''U'' -- updated (''N''ew by default)
  from CustomRDWExtractServices s
       join CustomRDWExtractServicesSent ss on ss.ServiceId = s.ServiceId
 where s.Status in (''CO'', ''CA'', ''NS'')
   and (@ResendAll = ''Y''
    or  isnull(s.ClientId, ''ISNULL'') <> isnull(ss.ClientId, ''ISNULL'')
    or  isnull(s.EpisodeNumber, ''ISNULL'') <> isnull(ss.EpisodeNumber, ''ISNULL'')
    or 	isnull(s.ClinicianId1, ''ISNULL'') <> isnull(ss.ClinicianId1, ''ISNULL'')
    or	isnull(s.ClinicianName1, ''ISNULL'') <> isnull(ss.ClinicianName1, ''ISNULL'')
    or  isnull(s.ClinicianDegree1, ''ISNULL'') <> isnull(ss.ClinicianDegree1, ''ISNULL'')
    or	isnull(s.BillingId, ''ISNULL'') <> isnull(ss.BillingId, ''ISNULL'')
    or	isnull(s.BillingName, ''ISNULL'') <> isnull(ss.BillingName, ''ISNULL'')
    or	isnull(s.SupervisorId, ''ISNULL'') <> isnull(ss.SupervisorId, ''ISNULL'')
    or	isnull(s.SupervisorName, ''ISNULL'') <> isnull(ss.SupervisorName, ''ISNULL'')
    or  isnull(s.AttendingId, ''ISNULL'') <> isnull(ss.AttendingId, ''ISNULL'')
    or  isnull(s.AttendingName, ''ISNULL'') <> isnull(ss.AttendingName, ''ISNULL'')
    or  isnull(s.ProgramId, ''ISNULL'') <> isnull(ss.ProgramId, ''ISNULL'')
    or	isnull(s.ProgramName, ''ISNULL'') <> isnull(ss.ProgramName, ''ISNULL'')
    or	isnull(s.Status, ''ISNULL'') <> isnull(ss.Status, ''ISNULL'')
    or  isnull(s.Axis1, ''ISNULL'') <> isnull(ss.Axis1, ''ISNULL'')
    or  isnull(s.Axis2, ''ISNULL'') <> isnull(ss.Axis2, ''ISNULL'')
    or  isnull(s.Axis3, ''ISNULL'') <> isnull(ss.Axis3, ''ISNULL'')
    or  isnull(s.Axis4, ''ISNULL'') <> isnull(ss.Axis4, ''ISNULL'')
    or	isnull(s.Billable, ''ISNULL'') <> isnull(ss.Billable, ''ISNULL'')
    or  isnull(s.PlaceOfService, ''ISNULL'') <> isnull(ss.PlaceOfService, ''ISNULL'')
    or  isnull(s.Location, ''ISNULL'') <> isnull(ss.Location, ''ISNULL'')
    or  isnull(s.ProcedureCode, ''ISNULL'') <> isnull(ss.ProcedureCode, ''ISNULL'')
    or  isnull(s.ProcedureCodeId, 0) <> isnull(ss.ProcedureCodeId, 0)
    or  isnull(s.ProcedureDuration, 0) <> isnull(ss.ProcedureDuration, 0)
    or  isnull(s.DurationType, ''ISNULL'') <> isnull(ss.DurationType, ''ISNULL'')
    or  isnull(s.DateOfService, ''1/1/1900'') <> isnull(ss.DateOfService, ''1/1/1900'')
    or  isnull(s.EndDateOfService, ''1/1/1900'') <> isnull(ss.EndDateOfService, ''1/1/1900'')
    or	isnull(s.CreatedDate, ''1/1/1900'') <> isnull(ss.CreatedDate, ''1/1/1900'')
    or  isnull(s.CompletedDate, ''1/1/1900'') <> isnull(ss.CompletedDate, ''1/1/1900'')
    or	isnull(s.ExcludeFromExceptionReport, ''ISNULL'') <> isnull(ss.ExcludeFromExceptionReport, ''ISNULL'')

    or  isnull(s.CPTCode, ''ISNULL'') <> isnull(ss.CPTCode, ''ISNULL'')
    or  isnull(s.BillingCPTCode, ''ISNULL'') <> isnull(ss.BillingCPTCode, ''ISNULL'')
    or  isnull(s.CPTModifier1, ''ISNULL'') <> isnull(ss.CPTModifier1, ''ISNULL'')
    or  isnull(s.CPTModifier2, ''ISNULL'') <> isnull(ss.CPTModifier2, ''ISNULL'')
    or  isnull(s.CPTModifier3, ''ISNULL'') <> isnull(ss.CPTModifier3, ''ISNULL'')
    or  isnull(s.Units, 0) <> isnull(ss.Units, 0)

    or  isnull(s.MedicaidCoveragePlanId, ''ISNULL'') <> isnull(ss.MedicaidCoveragePlanId, ''ISNULL'')
    or  isnull(s.MedicaidInsuredId, ''ISNULL'') <> isnull(ss.MedicaidInsuredId, ''ISNULL'')
    or  isnull(s.MedicaidAuthorizationNumber, ''ISNULL'') <> isnull(ss.MedicaidAuthorizationNumber, ''ISNULL'')
    or  isnull(s.MedicaidCopayPriority, 0) <> isnull(ss.MedicaidCopayPriority, 0)
    or  isnull(s.MedicaidExpectedPayment, 0) <> isnull(ss.MedicaidExpectedPayment, 0)
    or  isnull(s.MedicaidCharge, 0) <> isnull(ss.MedicaidCharge, 0)
    or  isnull(s.MedicaidPayment, 0) <> isnull(ss.MedicaidPayment, 0)
    or  isnull(s.MedicaidAdjustment, 0) <> isnull(ss.MedicaidAdjustment, 0)
    or  isnull(s.MedicaidBilledDate, ''1/1/1900'') <> isnull(ss.MedicaidBilledDate, ''1/1/1900'')
    or  isnull(s.MedicaidPaymentDate, ''1/1/1900'') <> isnull(ss.MedicaidPaymentDate, ''1/1/1900'')

    or  isnull(s.GFCoveragePlanId, ''ISNULL'') <> isnull(ss.GFCoveragePlanId, ''ISNULL'')
    or  isnull(s.GFInsuredId, ''ISNULL'') <> isnull(ss.GFInsuredId, ''ISNULL'')
    or  isnull(s.GFAuthorizationNumber, ''ISNULL'') <> isnull(ss.GFAuthorizationNumber, ''ISNULL'')
    or  isnull(s.GFCopayPriority, 0) <> isnull(ss.GFCopayPriority, 0)
    or  isnull(s.GFExpectedPayment, 0) <> isnull(ss.GFExpectedPayment, 0)
    or  isnull(s.GFCharge, 0) <> isnull(ss.GFCharge, 0)
    or  isnull(s.GFPayment, 0) <> isnull(ss.GFPayment, 0)
    or  isnull(s.GFAdjustment, 0) <> isnull(ss.GFAdjustment, 0)
    or  isnull(s.GFBilledDate, ''1/1/1900'') <> isnull(ss.GFBilledDate, ''1/1/1900'')
    or  isnull(s.GFPaymentDate, ''1/1/1900'') <> isnull(ss.GFPaymentDate, ''1/1/1900'')

    or  isnull(s.ABWCoveragePlanId, ''ISNULL'') <> isnull(ss.ABWCoveragePlanId, ''ISNULL'')
    or  isnull(s.ABWInsuredId, ''ISNULL'') <> isnull(ss.ABWInsuredId, ''ISNULL'')
    or  isnull(s.ABWAuthorizationNumber, ''ISNULL'') <> isnull(ss.ABWAuthorizationNumber, ''ISNULL'')
    or  isnull(s.ABWCopayPriority, 0) <> isnull(ss.ABWCopayPriority, 0)
    or  isnull(s.ABWExpectedPayment, 0) <> isnull(ss.ABWExpectedPayment, 0)
    or  isnull(s.ABWCharge, 0) <> isnull(ss.ABWCharge, 0)
    or  isnull(s.ABWPayment, 0) <> isnull(ss.ABWPayment, 0)
    or  isnull(s.ABWAdjustment, 0) <> isnull(ss.ABWAdjustment, 0)
    or  isnull(s.ABWBilledDate, ''1/1/1900'') <> isnull(ss.ABWBilledDate, ''1/1/1900'')
    or  isnull(s.ABWPaymentDate, ''1/1/1900'') <> isnull(ss.ABWPaymentDate, ''1/1/1900'')

    or  isnull(s.MIChildCoveragePlanId, ''ISNULL'') <> isnull(ss.MIChildCoveragePlanId, ''ISNULL'')
    or  isnull(s.MIChildInsuredId, ''ISNULL'') <> isnull(ss.MIChildInsuredId, ''ISNULL'')
    or  isnull(s.MIChildAuthorizationNumber, ''ISNULL'') <> isnull(ss.MIChildAuthorizationNumber, ''ISNULL'')
    or  isnull(s.MIChildCopayPriority, 0) <> isnull(ss.MIChildCopayPriority, 0)
    or  isnull(s.MIChildExpectedPayment, 0) <> isnull(ss.MIChildExpectedPayment, 0)
    or  isnull(s.MIChildCharge, 0) <> isnull(ss.MIChildCharge, 0)
    or  isnull(s.MIChildPayment, 0) <> isnull(ss.MIChildPayment, 0)
    or  isnull(s.MIChildAdjustment, 0) <> isnull(ss.MIChildAdjustment, 0)
    or  isnull(s.MIChildBilledDate, ''1/1/1900'') <> isnull(ss.MIChildBilledDate, ''1/1/1900'')
    or  isnull(s.MIChildPaymentDate, ''1/1/1900'') <> isnull(ss.MIChildPaymentDate, ''1/1/1900'')

    or  isnull(s.OtherPayerCoveragePlanId1, ''ISNULL'') <> isnull(ss.OtherPayerCoveragePlanId1, ''ISNULL'')
    or  isnull(s.OtherPayerName1, ''ISNULL'') <> isnull(ss.OtherPayerName1, ''ISNULL'')
    or  isnull(s.OtherPayerCopayPriority1, 0) <> isnull(ss.OtherPayerCopayPriority1, 0)
    or  isnull(s.OtherPayerInsuredId1, ''ISNULL'') <> isnull(ss.OtherPayerInsuredId1, ''ISNULL'')
    or  isnull(s.OtherPayerInsuredName1, ''ISNULL'') <> isnull(ss.OtherPayerInsuredName1, ''ISNULL'')
    or  isnull(s.OtherPayerInsuredDOB1, ''1/1/1900'') <> isnull(ss.OtherPayerInsuredDOB1, ''1/1/1900'')
    or  isnull(s.OtherPayerCharge1, 0) <> isnull(ss.OtherPayerCharge1, 0)
    or  isnull(s.OtherPayerPayment1, 0) <> isnull(ss.OtherPayerPayment1, 0)
    or  isnull(s.OtherPayerAdjustment1, 0) <> isnull(ss.OtherPayerAdjustment1, 0)
    or  isnull(s.OtherPayerBilledDate1, ''1/1/1900'') <> isnull(ss.OtherPayerBilledDate1, ''1/1/1900'')
    or  isnull(s.OtherPayerPaymentDate1, ''1/1/1900'') <> isnull(ss.OtherPayerPaymentDate1, ''1/1/1900'')

    or  isnull(s.OtherPayerCoveragePlanId2, ''ISNULL'') <> isnull(ss.OtherPayerCoveragePlanId2, ''ISNULL'')
    or  isnull(s.OtherPayerName2, ''ISNULL'') <> isnull(ss.OtherPayerName2, ''ISNULL'')
    or  isnull(s.OtherPayerCopayPriority2, 0) <> isnull(ss.OtherPayerCopayPriority2, 0)
    or  isnull(s.OtherPayerInsuredId2, ''ISNULL'') <> isnull(ss.OtherPayerInsuredId2, ''ISNULL'')
    or  isnull(s.OtherPayerInsuredName2, ''ISNULL'') <> isnull(ss.OtherPayerInsuredName2, ''ISNULL'')
    or  isnull(s.OtherPayerInsuredDOB2, ''1/1/1900'') <> isnull(ss.OtherPayerInsuredDOB2, ''1/1/1900'')
    or  isnull(s.OtherPayerCharge2, 0) <> isnull(ss.OtherPayerCharge2, 0)
    or  isnull(s.OtherPayerPayment2, 0) <> isnull(ss.OtherPayerPayment2, 0)
    or  isnull(s.OtherPayerAdjustment2, 0) <> isnull(ss.OtherPayerAdjustment2, 0)
    or  isnull(s.OtherPayerBilledDate2, ''1/1/1900'') <> isnull(ss.OtherPayerBilledDate2, ''1/1/1900'')
    or  isnull(s.OtherPayerPaymentDate2, ''1/1/1900'') <> isnull(ss.OtherPayerPaymentDate2, ''1/1/1900'')

    or  isnull(s.OtherPayerCoveragePlanId3, ''ISNULL'') <> isnull(ss.OtherPayerCoveragePlanId3, ''ISNULL'')
    or  isnull(s.OtherPayerName3, ''ISNULL'') <> isnull(ss.OtherPayerName3, ''ISNULL'')
    or  isnull(s.OtherPayerCopayPriority3, 0) <> isnull(ss.OtherPayerCopayPriority3, 0)
    or  isnull(s.OtherPayerInsuredId3, ''ISNULL'') <> isnull(ss.OtherPayerInsuredId3, ''ISNULL'')
    or  isnull(s.OtherPayerInsuredName3, ''ISNULL'') <> isnull(ss.OtherPayerInsuredName3, ''ISNULL'')
    or  isnull(s.OtherPayerInsuredDOB3, ''1/1/1900'') <> isnull(ss.OtherPayerInsuredDOB3, ''1/1/1900'')
    or  isnull(s.OtherPayerCharge3, 0) <> isnull(ss.OtherPayerCharge3, 0)
    or  isnull(s.OtherPayerPayment3, 0) <> isnull(ss.OtherPayerPayment3, 0)
    or  isnull(s.OtherPayerAdjustment3, 0) <> isnull(ss.OtherPayerAdjustment3, 0)
    or  isnull(s.OtherPayerBilledDate3, ''1/1/1900'') <> isnull(ss.OtherPayerBilledDate3, ''1/1/1900'')
    or  isnull(s.OtherPayerPaymentDate3, ''1/1/1900'') <> isnull(ss.OtherPayerPaymentDate3, ''1/1/1900'')

    or  isnull(s.OtherPayerCoveragePlanId4, ''ISNULL'') <> isnull(ss.OtherPayerCoveragePlanId4, ''ISNULL'')
    or  isnull(s.OtherPayerName4, ''ISNULL'') <> isnull(ss.OtherPayerName4, ''ISNULL'')
    or  isnull(s.OtherPayerCopayPriority4, 0) <> isnull(ss.OtherPayerCopayPriority4, 0)
    or  isnull(s.OtherPayerInsuredId4, ''ISNULL'') <> isnull(ss.OtherPayerInsuredId4, ''ISNULL'')
    or  isnull(s.OtherPayerInsuredName4, ''ISNULL'') <> isnull(ss.OtherPayerInsuredName4, ''ISNULL'')
    or  isnull(s.OtherPayerInsuredDOB4, ''1/1/1900'') <> isnull(ss.OtherPayerInsuredDOB4, ''1/1/1900'')
    or  isnull(s.OtherPayerCharge4, 0) <> isnull(ss.OtherPayerCharge4, 0)
    or  isnull(s.OtherPayerPayment4, 0) <> isnull(ss.OtherPayerPayment4, 0)
    or  isnull(s.OtherPayerAdjustment4, 0) <> isnull(ss.OtherPayerAdjustment4, 0)
    or  isnull(s.OtherPayerBilledDate4, ''1/1/1900'') <> isnull(ss.OtherPayerBilledDate4, ''1/1/1900'')
    or  isnull(s.OtherPayerPaymentDate4, ''1/1/1900'') <> isnull(ss.OtherPayerPaymentDate4, ''1/1/1900'')

    or  isnull(s.OtherPayerCoveragePlanId5, ''ISNULL'') <> isnull(ss.OtherPayerCoveragePlanId5, ''ISNULL'')
    or  isnull(s.OtherPayerName5, ''ISNULL'') <> isnull(ss.OtherPayerName5, ''ISNULL'')
    or  isnull(s.OtherPayerCopayPriority5, 0) <> isnull(ss.OtherPayerCopayPriority5, 0)
    or  isnull(s.OtherPayerInsuredId5, ''ISNULL'') <> isnull(ss.OtherPayerInsuredId5, ''ISNULL'')
    or  isnull(s.OtherPayerInsuredName5, ''ISNULL'') <> isnull(ss.OtherPayerInsuredName5, ''ISNULL'')
    or  isnull(s.OtherPayerInsuredDOB5, ''1/1/1900'') <> isnull(ss.OtherPayerInsuredDOB5, ''1/1/1900'')
    or  isnull(s.OtherPayerCharge5, 0) <> isnull(ss.OtherPayerCharge5, 0)
    or  isnull(s.OtherPayerPayment5, 0) <> isnull(ss.OtherPayerPayment5, 0)
    or  isnull(s.OtherPayerAdjustment5, 0) <> isnull(ss.OtherPayerAdjustment5, 0)
    or  isnull(s.OtherPayerBilledDate5, ''1/1/1900'') <> isnull(ss.OtherPayerBilledDate5, ''1/1/1900'')
    or  isnull(s.OtherPayerPaymentDate5, ''1/1/1900'') <> isnull(ss.OtherPayerPaymentDate5, ''1/1/1900'')

    or  isnull(s.OtherPayerCoveragePlanId6, ''ISNULL'') <> isnull(ss.OtherPayerCoveragePlanId6, ''ISNULL'')
    or  isnull(s.OtherPayerName6, ''ISNULL'') <> isnull(ss.OtherPayerName6, ''ISNULL'')
    or  isnull(s.OtherPayerCopayPriority6, 0) <> isnull(ss.OtherPayerCopayPriority6, 0)
    or  isnull(s.OtherPayerInsuredId6, ''ISNULL'') <> isnull(ss.OtherPayerInsuredId6, ''ISNULL'')
    or  isnull(s.OtherPayerInsuredName6, ''ISNULL'') <> isnull(ss.OtherPayerInsuredName6, ''ISNULL'')
    or  isnull(s.OtherPayerInsuredDOB6, ''1/1/1900'') <> isnull(ss.OtherPayerInsuredDOB6, ''1/1/1900'')
    or  isnull(s.OtherPayerCharge6, 0) <> isnull(ss.OtherPayerCharge6, 0)
    or  isnull(s.OtherPayerPayment6, 0) <> isnull(ss.OtherPayerPayment6, 0)
    or  isnull(s.OtherPayerAdjustment6, 0) <> isnull(ss.OtherPayerAdjustment6, 0)
    or  isnull(s.OtherPayerBilledDate6, ''1/1/1900'') <> isnull(ss.OtherPayerBilledDate6, ''1/1/1900'')
    or  isnull(s.OtherPayerPaymentDate6, ''1/1/1900'') <> isnull(ss.OtherPayerPaymentDate6, ''1/1/1900'')

    or  isnull(s.ClientExpectedPayment, 0) <> isnull(ss.ClientExpectedPayment, 0)
    or  isnull(s.ClientCharge, 0) <> isnull(ss.ClientCharge, 0)
    or  isnull(s.ClientPayment, 0) <> isnull(ss.ClientPayment, 0)
    or  isnull(s.ClientAdjustment, 0) <> isnull(ss.ClientAdjustment, 0)
    or  isnull(s.ClientBilledDate, ''1/1/1900'') <> isnull(ss.ClientBilledDate, ''1/1/1900'')
    or  isnull(s.ClientPaymentDate, ''1/1/1900'') <> isnull(ss.ClientPaymentDate, ''1/1/1900'')

    or  isnull(s.Charge, 0) <> isnull(ss.Charge, 0)
    
    or  isnull(s.ServiceError, '''') <> isnull(ss.ServiceError, ''''))

if @@error <> 0 goto error

--
-- Reset previous errors to be (possibly) resent
--
update s
   set ExtractStatus = ''R'' -- resend
  from CustomRDWExtractServices s
       join CustomRDWExtractServicesSent ss on ss.ServiceId = s.ServiceId
 where ss.ErrorStatus = ''Y''
   and s.ExtractStatus <> ''U''
   and s.Status in (''CO'', ''CA'', ''NS'')

if @@error <> 0 goto error

--
-- Mark deletions
--
update s
   set ExtractStatus = ''D'' -- Deleted
  from CustomRDWExtractServices s
       join CustomRDWExtractServicesSent ss on ss.ServiceId = s.ServiceId
 where s.Status = ''ER''	-- deleted due to error
   and (ss.ExtractStatus <> ''D'' or ss.AcknowledgedDate is null)

if @@error <> 0 goto error

--
-- Handle outright deletions of services
--
insert into CustomRDWExtractServices (
       AffiliateId,
       ServiceId, 
       ExtractStatus, 
       ErrorStatus, 
       ClientId, 
       EpisodeNumber,
       DateOfService, 
       EndDateOfService,
       CreatedDate, 
       CompletedDate, 
       Status, 
       ProcedureCode, 
       ProcedureCodeId,
       ProcedureDuration, 
       DurationType, 
       CPTCode,
       BillingCPTCode,
       CPTModifier1,
       CPTModifier2,
       CPTModifier3, 
       Units, 
       ClinicianId1, 
       ClinicianName1, 
       ClinicianDegree1,
       ClinicianId2, 
       ClinicianName2, 
       ClinicianId3, 
       ClinicianName3, 
       ClinicianId4, 
       ClinicianName4, 
       BillingId, 
       BillingName, 
       SupervisorId, 
       SupervisorName, 
       AttendingId, 
       AttendingName, 
       CSPPClinicId, 
       CSPPClinicName, 
       CSPPServiceId, 
       CSPPServiceName, 
       ProgramId, 
       ProgramName, 
       CSPPProtocolId, 
       CSPPProtocolName, 
       Axis1, 
       Axis2, 
       Axis3, 
       Axis4, 
       Charge, 
       Billable, 
       PlaceOfService, 
       Location, 
       MedicaidCoveragePlanId, 
       MedicaidInsuredId, 
       MedicaidAuthorizationNumber, 
       MedicaidCopayPriority, 
       MedicaidExpectedPayment, 
       MedicaidCharge, 
       MedicaidPayment, 
       MedicaidAdjustment, 
       MedicaidBilledDate, 
       MedicaidPaymentDate, 
       GFCoveragePlanId, 
       GFInsuredId, 
       GFAuthorizationNumber,
       GFCopayPriority, 
       GFExpectedPayment,
       GFCharge, 
       GFPayment, 
       GFAdjustment, 
       GFBilledDate, 
       GFPaymentDate, 
       MIChildCoveragePlanId, 
       MIChildInsuredId, 
       MIChildAuthorizationNumber,
       MIChildCopayPriority,
       MIChildExpectedPayment, 
       MIChildCharge, 
       MIChildPayment, 
       MIChildAdjustment, 
       MIChildBilledDate, 
       MIChildPaymentDate, 
       ABWCoveragePlanId, 
       ABWInsuredId, 
       ABWAuthorizationNumber, 
       ABWCopayPriority, 
       ABWExpectedPayment, 
       ABWCharge, 
       ABWPayment, 
       ABWAdjustment, 
       ABWBilledDate, 
       ABWPaymentDate, 
       OtherPayerCoveragePlanId1, 
       OtherPayerName1, 
       OtherPayerCopayPriority1, 
       OtherPayerInsuredId1,
       OtherPayerInsuredName1, 
       OtherPayerInsuredDOB1, 
       OtherPayerCharge1, 
       OtherPayerPayment1, 
       OtherPayerAdjustment1,
       OtherPayerPaymentDate1,
       OtherPayerBilledDate1, 
       OtherPayerCoveragePlanId2, 
       OtherPayerName2, 
       OtherPayerCopayPriority2, 
       OtherPayerInsuredId2, 
       OtherPayerInsuredName2, 
       OtherPayerInsuredDOB2, 
       OtherPayerCharge2, 
       OtherPayerPayment2, 
       OtherPayerAdjustment2, 
       OtherPayerPaymentDate2, 
       OtherPayerBilledDate2, 
       OtherPayerCoveragePlanId3, 
       OtherPayerName3, 
       OtherPayerCopayPriority3,
       OtherPayerInsuredId3,
       OtherPayerInsuredName3, 
       OtherPayerInsuredDOB3,
       OtherPayerCharge3, 
       OtherPayerPayment3, 
       OtherPayerAdjustment3, 
       OtherPayerPaymentDate3,
       OtherPayerBilledDate3,
       OtherPayerCoveragePlanId4, 
       OtherPayerName4, 
       OtherPayerCopayPriority4, 
       OtherPayerInsuredId4, 
       OtherPayerInsuredName4, 
       OtherPayerInsuredDOB4, 
       OtherPayerCharge4,
       OtherPayerPayment4, 
       OtherPayerAdjustment4, 
       OtherPayerPaymentDate4, 
       OtherPayerBilledDate4,
       OtherPayerCoveragePlanId5,
       OtherPayerName5,
       OtherPayerCopayPriority5,
       OtherPayerInsuredId5,
       OtherPayerInsuredName5,
       OtherPayerInsuredDOB5,
       OtherPayerCharge5,
       OtherPayerPayment5, 
       OtherPayerAdjustment5,
       OtherPayerPaymentDate5, 
       OtherPayerBilledDate5,
       OtherPayerCoveragePlanId6,
       OtherPayerName6,
       OtherPayerCopayPriority6,
       OtherPayerInsuredId6, 
       OtherPayerInsuredName6, 
       OtherPayerInsuredDOB6, 
       OtherPayerCharge6, 
       OtherPayerPayment6,
       OtherPayerAdjustment6, 
       OtherPayerPaymentDate6, 
       OtherPayerBilledDate6, 
       ClientExpectedPayment, 
       ClientCharge, 
       ClientPayment, 
       ClientAdjustment,
       ClientBilledDate, 
       ClientPaymentDate, 
       ExcludeFromExceptionReport,
       ServiceError)
select AffiliateId,
       ServiceId, 
       ''D'', 
       ErrorStatus, 
       ClientId, 
       EpisodeNumber,
       DateOfService, 
       EndDateOfService,
       CreatedDate, 
       CompletedDate, 
       ''ER'', 
       ProcedureCode, 
       ProcedureCodeId,
       ProcedureDuration, 
       DurationType, 
       CPTCode, 
       BillingCPTCode,
       CPTModifier1,
       CPTModifier2,
       CPTModifier3, 
       Units, 
       ClinicianId1, 
       ClinicianName1, 
       ClinicianDegree1,
       ClinicianId2, 
       ClinicianName2, 
       ClinicianId3, 
       ClinicianName3, 
       ClinicianId4, 
       ClinicianName4, 
       BillingId, 
       BillingName, 
       SupervisorId, 
       SupervisorName, 
       AttendingId, 
       AttendingName, 
       CSPPClinicId, 
       CSPPClinicName, 
       CSPPServiceId, 
       CSPPServiceName, 
       ProgramId, 
       ProgramName, 
       CSPPProtocolId, 
       CSPPProtocolName, 
       Axis1, 
       Axis2, 
       Axis3, 
       Axis4, 
       Charge, 
       Billable, 
       PlaceOfService, 
       Location, 
       MedicaidCoveragePlanId, 
       MedicaidInsuredId, 
       MedicaidAuthorizationNumber, 
       MedicaidCopayPriority, 
       MedicaidExpectedPayment, 
       MedicaidCharge, 
       MedicaidPayment, 
       MedicaidAdjustment, 
       MedicaidBilledDate, 
       MedicaidPaymentDate, 
       GFCoveragePlanId, 
       GFInsuredId, 
       GFAuthorizationNumber,
       GFCopayPriority, 
       GFExpectedPayment,
       GFCharge, 
       GFPayment, 
       GFAdjustment, 
       GFBilledDate, 
       GFPaymentDate, 
       MIChildCoveragePlanId, 
       MIChildInsuredId, 
       MIChildAuthorizationNumber,
       MIChildCopayPriority,
       MIChildExpectedPayment, 
       MIChildCharge, 
       MIChildPayment, 
       MIChildAdjustment, 
       MIChildBilledDate, 
       MIChildPaymentDate, 
       ABWCoveragePlanId, 
       ABWInsuredId, 
       ABWAuthorizationNumber, 
       ABWCopayPriority, 
       ABWExpectedPayment, 
       ABWCharge, 
       ABWPayment, 
       ABWAdjustment, 
       ABWBilledDate, 
       ABWPaymentDate, 
       OtherPayerCoveragePlanId1, 
       OtherPayerName1, 
       OtherPayerCopayPriority1, 
       OtherPayerInsuredId1,
       OtherPayerInsuredName1, 
       OtherPayerInsuredDOB1, 
       OtherPayerCharge1, 
       OtherPayerPayment1, 
       OtherPayerAdjustment1,
       OtherPayerPaymentDate1,
       OtherPayerBilledDate1, 
       OtherPayerCoveragePlanId2, 
       OtherPayerName2, 
       OtherPayerCopayPriority2, 
       OtherPayerInsuredId2, 
       OtherPayerInsuredName2, 
       OtherPayerInsuredDOB2, 
       OtherPayerCharge2, 
       OtherPayerPayment2, 
       OtherPayerAdjustment2, 
       OtherPayerPaymentDate2, 
       OtherPayerBilledDate2, 
       OtherPayerCoveragePlanId3, 
       OtherPayerName3, 
       OtherPayerCopayPriority3,
       OtherPayerInsuredId3,
       OtherPayerInsuredName3, 
       OtherPayerInsuredDOB3,
       OtherPayerCharge3, 
       OtherPayerPayment3, 
       OtherPayerAdjustment3, 
       OtherPayerPaymentDate3,
       OtherPayerBilledDate3,
       OtherPayerCoveragePlanId4, 
       OtherPayerName4, 
       OtherPayerCopayPriority4, 
       OtherPayerInsuredId4, 
       OtherPayerInsuredName4, 
       OtherPayerInsuredDOB4, 
       OtherPayerCharge4,
       OtherPayerPayment4, 
       OtherPayerAdjustment4, 
       OtherPayerPaymentDate4, 
       OtherPayerBilledDate4,
       OtherPayerCoveragePlanId5,
       OtherPayerName5,
       OtherPayerCopayPriority5,
       OtherPayerInsuredId5,
       OtherPayerInsuredName5,
       OtherPayerInsuredDOB5,
       OtherPayerCharge5,
       OtherPayerPayment5, 
       OtherPayerAdjustment5,
       OtherPayerPaymentDate5, 
       OtherPayerBilledDate5,
       OtherPayerCoveragePlanId6,
       OtherPayerName6,
       OtherPayerCopayPriority6,
       OtherPayerInsuredId6, 
       OtherPayerInsuredName6, 
       OtherPayerInsuredDOB6, 
       OtherPayerCharge6, 
       OtherPayerPayment6,
       OtherPayerAdjustment6, 
       OtherPayerPaymentDate6, 
       OtherPayerBilledDate6, 
       ClientExpectedPayment, 
       ClientCharge, 
       ClientPayment, 
       ClientAdjustment,
       ClientBilledDate, 
       ClientPaymentDate, 
       ExcludeFromExceptionReport,
       ServiceError
  from CustomRDWExtractServicesSent ss
 where (ss.ExtractStatus <> ''D'' or ss.AcknowledgedDate is null)
   and not exists(select *
                    from CustomRDWExtractServices s
                   where s.ServiceId = ss.ServiceId)

if @@error <> 0 goto error

--
-- DELETE what has already been sent
--
delete from s
  from CustomRDWExtractServices s
       join CustomRDWExtractServicesSent ss on ss.ServiceId = s.ServiceId
 where s.Status in (''CO'', ''ER'', ''CA'', ''NS'')
   and s.ExtractStatus = ''N'' -- was already sent and not marked as an update, resend or delete

if @@error <> 0 goto error

--
-- DELETE ''ER'' transactions that were never sent (no reason to send them)
--
delete from s
  from CustomRDWExtractServices s
 where s.Status = ''ER''
   and s.ExtractStatus = ''N'' -- was never sent and not marked as an update or delete

if @@error <> 0 goto error

--
-- Delete services that will be sent
--
delete from ss
  from CustomRDWExtractServicesSent ss
       join CustomRDWExtractServices s on s.ServiceId = ss.ServiceId

if @@error <> 0 goto error

--
-- Create the new services sent records
--
insert into CustomRDWExtractServicesSent (
       AffiliateId,
       ServiceId, 
       ExtractStatus, 
       ErrorStatus, 
       ClientId, 
       EpisodeNumber,
       DateOfService, 
       EndDateOfService,
       CreatedDate, 
       CompletedDate, 
       Status, 
	   CancelReason,
       ProcedureCode, 
       ProcedureCodeId,
       ProcedureDuration, 
       DurationType, 
       CPTCode, 
       BillingCPTCode,
       CPTModifier1,
       CPTModifier2,
       CPTModifier3, 
       Units, 
       ClinicianId1, 
       ClinicianName1, 
       ClinicianDegree1,
       ClinicianId2, 
       ClinicianName2, 
       ClinicianId3, 
       ClinicianName3, 
       ClinicianId4, 
       ClinicianName4, 
       BillingId, 
       BillingName, 
       SupervisorId, 
       SupervisorName, 
       AttendingId, 
       AttendingName, 
       CSPPClinicId, 
       CSPPClinicName, 
       CSPPServiceId, 
       CSPPServiceName, 
       ProgramId, 
       ProgramName, 
       CSPPProtocolId, 
       CSPPProtocolName, 
       Axis1, 
       Axis2, 
       Axis3, 
       Axis4, 
       Charge, 
       Billable, 
       PlaceOfService, 
       Location, 
       MedicaidCoveragePlanId, 
       MedicaidInsuredId, 
       MedicaidAuthorizationNumber, 
       MedicaidCopayPriority, 
       MedicaidExpectedPayment, 
       MedicaidCharge, 
       MedicaidPayment, 
       MedicaidAdjustment, 
       MedicaidBilledDate, 
       MedicaidPaymentDate, 
       GFCoveragePlanId, 
       GFInsuredId, 
       GFAuthorizationNumber,
       GFCopayPriority, 
       GFExpectedPayment,
       GFCharge, 
       GFPayment, 
       GFAdjustment, 
       GFBilledDate, 
       GFPaymentDate, 
       MIChildCoveragePlanId, 
       MIChildInsuredId, 
       MIChildAuthorizationNumber,
       MIChildCopayPriority,
       MIChildExpectedPayment, 
       MIChildCharge, 
       MIChildPayment, 
       MIChildAdjustment, 
       MIChildBilledDate, 
       MIChildPaymentDate, 
       ABWCoveragePlanId, 
       ABWInsuredId, 
       ABWAuthorizationNumber, 
       ABWCopayPriority, 
       ABWExpectedPayment, 
       ABWCharge, 
       ABWPayment, 
       ABWAdjustment, 
       ABWBilledDate, 
       ABWPaymentDate, 
       OtherPayerCoveragePlanId1, 
       OtherPayerName1, 
       OtherPayerCopayPriority1, 
       OtherPayerInsuredId1,
       OtherPayerInsuredName1, 
       OtherPayerInsuredDOB1, 
       OtherPayerCharge1, 
       OtherPayerPayment1, 
       OtherPayerAdjustment1,
       OtherPayerPaymentDate1,
       OtherPayerBilledDate1, 
       OtherPayerCoveragePlanId2, 
       OtherPayerName2, 
       OtherPayerCopayPriority2, 
       OtherPayerInsuredId2, 
       OtherPayerInsuredName2, 
       OtherPayerInsuredDOB2, 
       OtherPayerCharge2, 
       OtherPayerPayment2, 
       OtherPayerAdjustment2, 
       OtherPayerPaymentDate2, 
       OtherPayerBilledDate2, 
       OtherPayerCoveragePlanId3, 
       OtherPayerName3, 
       OtherPayerCopayPriority3,
       OtherPayerInsuredId3,
       OtherPayerInsuredName3, 
       OtherPayerInsuredDOB3,
       OtherPayerCharge3, 
       OtherPayerPayment3, 
       OtherPayerAdjustment3, 
       OtherPayerPaymentDate3,
       OtherPayerBilledDate3,
       OtherPayerCoveragePlanId4, 
       OtherPayerName4, 
       OtherPayerCopayPriority4, 
       OtherPayerInsuredId4, 
       OtherPayerInsuredName4, 
       OtherPayerInsuredDOB4, 
       OtherPayerCharge4,
       OtherPayerPayment4, 
       OtherPayerAdjustment4, 
       OtherPayerPaymentDate4, 
       OtherPayerBilledDate4,
       OtherPayerCoveragePlanId5,
       OtherPayerName5,
       OtherPayerCopayPriority5,
       OtherPayerInsuredId5,
       OtherPayerInsuredName5,
       OtherPayerInsuredDOB5,
       OtherPayerCharge5,
       OtherPayerPayment5, 
       OtherPayerAdjustment5,
       OtherPayerPaymentDate5, 
       OtherPayerBilledDate5,
       OtherPayerCoveragePlanId6,
       OtherPayerName6,
       OtherPayerCopayPriority6,
       OtherPayerInsuredId6, 
       OtherPayerInsuredName6, 
       OtherPayerInsuredDOB6, 
       OtherPayerCharge6, 
       OtherPayerPayment6,
       OtherPayerAdjustment6, 
       OtherPayerPaymentDate6, 
       OtherPayerBilledDate6, 
       ClientExpectedPayment, 
       ClientCharge, 
       ClientPayment, 
       ClientAdjustment,
       ClientBilledDate, 
       ClientPaymentDate, 
       ExcludeFromExceptionReport,
       ServiceError,
       SentDate,
       AcknowledgedDate)
select AffiliateId,
       ServiceId, 
       ExtractStatus, 
       ErrorStatus, 
       ClientId, 
       EpisodeNumber,
       DateOfService, 
       EndDateOfService,
       CreatedDate, 
       CompletedDate, 
       Status, 
	   CancelReason,
       ProcedureCode, 
       ProcedureCodeId,
       ProcedureDuration, 
       DurationType, 
       CPTCode, 
       BillingCPTCode,
       CPTModifier1,
       CPTModifier2,
       CPTModifier3, 
       Units, 
       ClinicianId1, 
       ClinicianName1, 
       ClinicianDegree1,
       ClinicianId2, 
       ClinicianName2, 
       ClinicianId3, 
       ClinicianName3, 
       ClinicianId4, 
       ClinicianName4, 
       BillingId, 
       BillingName, 
       SupervisorId, 
       SupervisorName, 
       AttendingId, 
       AttendingName, 
       CSPPClinicId, 
       CSPPClinicName, 
       CSPPServiceId, 
       CSPPServiceName, 
       ProgramId, 
       ProgramName, 
       CSPPProtocolId, 
       CSPPProtocolName, 
       Axis1, 
       Axis2, 
       Axis3, 
       Axis4, 
       Charge, 
       Billable, 
       PlaceOfService, 
       Location, 
       MedicaidCoveragePlanId, 
       MedicaidInsuredId, 
       MedicaidAuthorizationNumber, 
       MedicaidCopayPriority, 
       MedicaidExpectedPayment, 
       MedicaidCharge, 
       MedicaidPayment, 
       MedicaidAdjustment, 
       MedicaidBilledDate, 
       MedicaidPaymentDate, 
       GFCoveragePlanId, 
       GFInsuredId, 
       GFAuthorizationNumber,
       GFCopayPriority, 
       GFExpectedPayment,
       GFCharge, 
       GFPayment, 
       GFAdjustment, 
       GFBilledDate, 
       GFPaymentDate, 
       MIChildCoveragePlanId, 
       MIChildInsuredId, 
       MIChildAuthorizationNumber,
       MIChildCopayPriority,
       MIChildExpectedPayment, 
       MIChildCharge, 
       MIChildPayment, 
       MIChildAdjustment, 
       MIChildBilledDate, 
       MIChildPaymentDate, 
       ABWCoveragePlanId, 
       ABWInsuredId, 
       ABWAuthorizationNumber, 
       ABWCopayPriority, 
       ABWExpectedPayment, 
       ABWCharge, 
       ABWPayment, 
       ABWAdjustment, 
       ABWBilledDate, 
       ABWPaymentDate, 
       OtherPayerCoveragePlanId1, 
       OtherPayerName1, 
       OtherPayerCopayPriority1, 
       OtherPayerInsuredId1,
       OtherPayerInsuredName1, 
       OtherPayerInsuredDOB1, 
       OtherPayerCharge1, 
       OtherPayerPayment1, 
       OtherPayerAdjustment1,
       OtherPayerPaymentDate1,
       OtherPayerBilledDate1, 
       OtherPayerCoveragePlanId2, 
       OtherPayerName2, 
       OtherPayerCopayPriority2, 
       OtherPayerInsuredId2, 
       OtherPayerInsuredName2, 
       OtherPayerInsuredDOB2, 
       OtherPayerCharge2, 
       OtherPayerPayment2, 
       OtherPayerAdjustment2, 
       OtherPayerPaymentDate2, 
       OtherPayerBilledDate2, 
       OtherPayerCoveragePlanId3, 
       OtherPayerName3, 
       OtherPayerCopayPriority3,
       OtherPayerInsuredId3,
       OtherPayerInsuredName3, 
       OtherPayerInsuredDOB3,
       OtherPayerCharge3, 
       OtherPayerPayment3, 
       OtherPayerAdjustment3, 
       OtherPayerPaymentDate3,
       OtherPayerBilledDate3,
       OtherPayerCoveragePlanId4, 
       OtherPayerName4, 
       OtherPayerCopayPriority4, 
       OtherPayerInsuredId4, 
       OtherPayerInsuredName4, 
       OtherPayerInsuredDOB4, 
       OtherPayerCharge4,
       OtherPayerPayment4, 
       OtherPayerAdjustment4, 
       OtherPayerPaymentDate4, 
       OtherPayerBilledDate4,
       OtherPayerCoveragePlanId5,
       OtherPayerName5,
       OtherPayerCopayPriority5,
       OtherPayerInsuredId5,
       OtherPayerInsuredName5,
       OtherPayerInsuredDOB5,
       OtherPayerCharge5,
       OtherPayerPayment5, 
       OtherPayerAdjustment5,
       OtherPayerPaymentDate5, 
       OtherPayerBilledDate5,
       OtherPayerCoveragePlanId6,
       OtherPayerName6,
       OtherPayerCopayPriority6,
       OtherPayerInsuredId6, 
       OtherPayerInsuredName6, 
       OtherPayerInsuredDOB6, 
       OtherPayerCharge6, 
       OtherPayerPayment6,
       OtherPayerAdjustment6, 
       OtherPayerPaymentDate6, 
       OtherPayerBilledDate6, 
       ClientExpectedPayment, 
       ClientCharge, 
       ClientPayment, 
       ClientAdjustment,
       ClientBilledDate, 
       ClientPaymentDate, 
       ExcludeFromExceptionReport,
       ServiceError,
       @ExtractDate,
       null
  from CustomRDWExtractServices
 where (Status in (''CO'', ''CA'', ''NS'') and ExtractStatus = ''N'')
    or (ExtractStatus in (''U'', ''D'', ''R''))

if @@error <> 0 goto error

return

error:

exec csp_RDWExtractError @AffiliateId = @AffiliateId, @ErrorText = ''Failed to execute csp_RDWExtractServices''
' 
END
GO
