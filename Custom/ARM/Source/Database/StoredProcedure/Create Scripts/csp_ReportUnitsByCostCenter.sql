/****** Object:  StoredProcedure [dbo].[csp_ReportUnitsByCostCenter]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportUnitsByCostCenter]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportUnitsByCostCenter]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportUnitsByCostCenter]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_ReportUnitsByCostCenter]
@StartDate   datetime,
@EndDate     datetime
/********************************************************************************
-- Stored Procedure: dbo.csp_ReportUnitsByCostCenter 
--
-- Copyright: 2007 Streamline Healthcate Solutions
--
-- Purpose: Units by cost center report
--
-- Updates:                     		                                
-- Date        Author      Purpose
-- 07.19.2007  SFarber     Created.     
-- 07.07.2009  SFarber     Modified By Coverage Plan logic, modified to use CustomUnitsByCostExcludeProcedureCodes table.
--
*********************************************************************************/
as

declare @Services int
declare @ServicesWithNoUnits int

create table #ClaimLines (
ClaimLineId            int identity not null,
ServiceId              int          null,
CoveragePlanId         int          null,
ServiceUnits           int          null,
BillingCode            varchar(15)  null,
Modifier1              char(2)      null,
Modifier2              char(2)      null,
Modifier3              char(2)      null,
Modifier4              char(2)      null,
RevenueCode            varchar(15)  null,
RevenueCodeDescription varchar(100) null,
ClaimUnits             int          null)	

create table #Report (
ClientId                 int           null,
ServiceId                int           null,
ProgramId                int           null,
ProcedureCodeId          int           null,
DateOfService            datetime      null,
ServiceUnits             int           null,
GLSubaccountId           int           null,
Subaccount               varchar(10)   null,
CoveragePlanIdByCoverage int           null,
CoveragePlanIdByCharge   int           null,
CoveragePlanIdByPayment  int           null,
IsMedicaidByCoverage     char(1)       null,
IsMedicaidByCharge       char(1)       null,
IsMedicaidByPayment      char(1)       null,
IsGFByCoverage           char(1)       null,
IsGFByCharge             char(1)       null,
IsGFByPayment            char(1)       null,
IsABWByCoverage          char(1)       null,
IsABWByCharge            char(1)       null,
IsABWByPayment           char(1)       null,
IsMIChildByCoverage      char(1)       null,
IsMIChildByCharge        char(1)       null,
IsMIChildByPayment       char(1)       null,
IsOtherByCoverage        char(1)       null,
IsOtherByCharge          char(1)       null,
IsOtherByPayment         char(1)       null,
BillingCodeByCoverage    varchar(25)   null,
BillingCodeByCharge      varchar(25)   null,
BillingCodeByPayment     varchar(25)   null,
UnitsByCoverage          decimal(18,2) null,
UnitsByCharge            decimal(18,2) null,
UnitsByPayment           decimal(18,2) null,
Services                 int           null,
ServicesWithNoUnits      int           null,
IsDD                     char(1)       null,
IsChild                  char(1)       null)

create table #Groups (
GroupId     int         identity not null,
Subaccount  varchar(10)          null)

insert into #Report (
       ClientId,
       ServiceId,
       ProgramId,
       ProcedureCodeId,
       DateOfService,
       ServiceUnits,
       IsChild,
       IsDD)      
select s.ClientId,
       s.ServiceId,
       s.ProgramId,
       s.ProcedureCodeId,
       s.DateOfService,
       s.Unit,
       case when dbo.GetAge(c.DOB, s.DateOfService) < 18 then ''Y'' else ''N'' end,
       ''N''
  from Services s
       join Clients c on c.ClientId = s.ClientId
 where s.Billable = ''Y''
   and s.Status = 75 -- Completed
   and s.DateOfService >= @StartDate
   and s.DateOfService < dateadd(dd, 1, @EndDate)
   and isnull(s.RecordDeleted, ''N'') = ''N''
   and exists(select * 
                from Charges c
               where c.ServiceId = s.ServiceId
                 and isnull(c.RecordDeleted, ''N'') = ''N'')
   and not exists(select *
                    from CustomUnitsByCostExcludeProcedureCodes e
                   where e.ProcedureCodeId = s.ProcedureCodeId)



--
-- Determine DD clients
--
update r 
   set IsDD = ''Y''
  from #Report r
 where exists (select *
                 from Documents d 
	                  join DiagnosesIAndII dg on dg.DocumentVersionId = d.CurrentDocumentVersionId
		        where d.ClientId = r.ClientId 
                  and DateDiff(dd, d.EffectiveDate, r.DateOfService) >= 0
                  and isnull(dg.RuleOut, ''N'') = ''N''
	              and (dg.DSMCode like ''317%'' or dg.DSMCode like ''318%'' or dg.DSMCode like ''319%'' or dg.DSMCode like ''299.%'')
                  and isnull(d.RecordDeleted, ''N'') = ''N''
                  and isnull(dg.RecordDeleted, ''N'') = ''N''
                  and not exists (select *
                                    from Documents d2 
                                         join DiagnosesIAndII dg2 on  dg2.DocumentVersionId = d2.CurrentDocumentVersionId
		                           where d2.ClientId = r.ClientId 
                                     and DateDiff(dd, d2.EffectiveDate, r.DateOfService) >= 0
                                     and isnull(dg2.RuleOut, ''N'') = ''N''
                                     and isnull(d2.RecordDeleted, ''N'') = ''N''
                                     and isnull(dg2.RecordDeleted, ''N'') = ''N''
                                     and d2.EffectiveDate > d.EffectiveDate))



--
-- Determine cost centers
--
update r
   set GLSubaccountId = sa.GLSubaccountId,
       Subaccount = sa.Subaccount
  from #Report r
       join CustomGLSubAccountPrograms sap on sap.ProgramId = r.ProgramId
       join CustomGLSubAccounts sa on sa.GLSubAccountId = sap.GLSubAccountId
 where r.IsDD = ''Y''
   and sa.SubAccountType = ''DD''
   and isnull(sa.RecordDeleted, ''N'') = ''N''
   and isnull(sap.RecordDeleted, ''N'') = ''N''

update r
   set GLSubaccountId = sa.GLSubaccountId,
       Subaccount = sa.Subaccount
  from #Report r
       join CustomGLSubAccountPrograms sap on sap.ProgramId = r.ProgramId
       join CustomGLSubAccounts sa on sa.GLSubAccountId = sap.GLSubAccountId
 where r.Subaccount is null
   and r.IsChild = ''Y''
   and sa.SubAccountType = ''MI Child''
   and isnull(sa.RecordDeleted, ''N'') = ''N''
   and isnull(sap.RecordDeleted, ''N'') = ''N''

update r
   set GLSubaccountId = sa.GLSubaccountId,
       Subaccount = sa.Subaccount
  from #Report r
       join CustomGLSubAccountPrograms sap on sap.ProgramId = r.ProgramId
       join CustomGLSubAccounts sa on sa.GLSubAccountId = sap.GLSubAccountId
 where r.Subaccount is null
   and r.IsChild = ''N''
   and sa.SubAccountType = ''MI Adult''
   and isnull(sa.RecordDeleted, ''N'') = ''N''
   and isnull(sap.RecordDeleted, ''N'') = ''N''

update r
   set GLSubaccountId = sa.GLSubaccountId,
       Subaccount = sa.Subaccount
  from #Report r
       join CustomGLSubAccountPrograms sap on sap.ProgramId = r.ProgramId
       join CustomGLSubAccounts sa on sa.GLSubAccountId = sap.GLSubAccountId
 where r.Subaccount is null
   and sa.SubAccountType is null
   and isnull(sa.RecordDeleted, ''N'') = ''N''
   and isnull(sap.RecordDeleted, ''N'') = ''N''



--
-- By Coverage Plan
--

-- Service is Medicaid if there is a Medicaid coverage plan that can be used for it
update r
   set CoveragePlanIdByCoverage = ccp.CoveragePlanId,
       IsMedicaidByCoverage = ''Y''
  from #Report r
       join ClientCoveragePlans ccp on ccp.ClientId = r.ClientId
       join ClientCoverageHistory cch on cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
       join CustomGLAccountCoveragePlans cap on cap.CoveragePlanId = ccp.CoveragePlanId and 
                                                cap.AccountSubtype = ''MEDICAID''
 where r.DateOfService >= cch.StartDate      
   and (r.DateOfService < dateadd(dd, 1, cch.EndDate) or cch.EndDate is null)
   and isnull(ccp.RecordDeleted, ''N'') = ''N''
   and isnull(cch.RecordDeleted, ''N'') = ''N''
   and not exists(select *   
                    from CoveragePlanRules ru  
                         join CoveragePlanRuleVariables v on v.CoveragePlanRuleId = ru.CoveragePlanRuleId  
                   where ru.CoveragePlanId = ccp.CoveragePlanId  
                     and ru.RuleTypeId = 4267  
                     and v.ProcedureCodeId = r.ProcedureCodeId  
                     and isnull(ru.RecordDeleted, ''N'') = ''N''  
                     and isnull(v.RecordDeleted, ''N'') = ''N'')

--  The rest determine based on the first charge instead of the coverage history
--  because IP plans are at the very end of COB order.
update r
   set CoveragePlanIdByCoverage = ccp.CoveragePlanId,
       IsGFByCoverage = case when cap.AccountSubtype = ''GF'' then ''Y'' else ''N'' end,
       IsABWByCoverage = case when cap.AccountSubtype = ''ABW'' then ''Y'' else ''N'' end,
       IsMIChildByCoverage = case when cap.AccountSubtype = ''MICHILD'' then ''Y'' else ''N'' end,
       IsOtherByCoverage = case when cap.CoveragePlanId is null then ''Y'' else ''N'' end
  from #Report r
       join Charges c on c.ServiceId = r.ServiceId
       left join ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = c.ClientCoveragePlanId
       left join CustomGLAccountCoveragePlans cap on cap.CoveragePlanId = ccp.CoveragePlanId and 
                                                     cap.AccountSubtype in (''GF'', ''ABW'', ''MICHILD'') 
 where isnull(r.IsMedicaidByCoverage, ''N'') = ''N''
   and isnull(c.RecordDeleted, ''N'') = ''N''
   and exists(select * 
                from ClientCoverageHistory cch
               where cch.ClientCoveragePlanId = c.ClientCoveragePlanId
                 and r.DateOfService >= cch.StartDate      
                 and (r.DateOfService < dateadd(dd, 1, cch.EndDate) or cch.EndDate is null)
                 and isnull(cch.RecordDeleted, ''N'') = ''N'')
   and not exists(select *
                    from Charges c2
                   where c2.ServiceId = r.ServiceId
                     and isnull(c2.RecordDeleted, ''N'') = ''N''
                     and case when c2.Priority = 0 then 999
                              else c2.Priority end < 
                         case when c.Priority = 0 then 999
                              else c.Priority end)

update r
   set CoveragePlanIdByCoverage = ccp.CoveragePlanId,
       IsGFByCoverage = case when cap.AccountSubtype = ''GF'' then ''Y'' else ''N'' end,
       IsABWByCoverage = case when cap.AccountSubtype = ''ABW'' then ''Y'' else ''N'' end,
       IsMIChildByCoverage = case when cap.AccountSubtype = ''MICHILD'' then ''Y'' else ''N'' end,
       IsOtherByCoverage = case when qhp.CoveragePlanId is null and cap.CoveragePlanId is null then ''Y'' else ''N'' end
  from #Report r
       join ClientCoveragePlans ccp on ccp.ClientId = r.ClientId
       join ClientCoverageHistory cch on cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
       left join CustomQHPCoveragePlans qhp on qhp.CoveragePlanId = ccp.CoveragePlanId
       left join CustomGLAccountCoveragePlans cap on cap.CoveragePlanId = ccp.CoveragePlanId and 
                                                     cap.AccountSubtype in (''GF'', ''ABW'', ''MICHILD'') 
 where isnull(r.IsMedicaidByCoverage, ''N'') = ''N''
   and isnull(IsGFByCoverage, ''N'') = ''N''
   and isnull(IsABWByCoverage, ''N'') = ''N''
   and isnull(IsMIChildByCoverage, ''N'') = ''N''
   and isnull(IsOtherByCoverage, ''N'') = ''N''
   and r.DateOfService >= cch.StartDate      
   and (r.DateOfService < dateadd(dd, 1, cch.EndDate) or cch.EndDate is null)
   and isnull(ccp.RecordDeleted, ''N'') = ''N''
   and isnull(cch.RecordDeleted, ''N'') = ''N''
   and not exists(select *
                    from ClientCoveragePlans ccp2
                         join ClientCoverageHistory cch2 on cch2.ClientCoveragePlanId = ccp2.ClientCoveragePlanId
                   where ccp2.ClientId = r.ClientId
                     and r.DateOfService >= cch2.StartDate      
                     and (r.DateOfService < dateadd(dd, 1, cch2.EndDate) or cch2.EndDate is null)
                     and cch2.COBOrder < cch.COBOrder
                     and isnull(ccp2.RecordDeleted, ''N'') = ''N''
                     and isnull(cch2.RecordDeleted, ''N'') = ''N''
                     and not exists(select *   
                                      from CoveragePlanRules ru  
                                           join CoveragePlanRuleVariables v on v.CoveragePlanRuleId = ru.CoveragePlanRuleId  
                                     where ru.CoveragePlanId = ccp2.CoveragePlanId  
                                       and ru.RuleTypeId = 4267  
                                       and v.ProcedureCodeId = r.ProcedureCodeId  
                                       and isnull(ru.RecordDeleted, ''N'') = ''N''  
                                       and isnull(v.RecordDeleted, ''N'') = ''N''))
   and not exists(select *   
                    from CoveragePlanRules ru  
                         join CoveragePlanRuleVariables v on v.CoveragePlanRuleId = ru.CoveragePlanRuleId  
                   where ru.CoveragePlanId = ccp.CoveragePlanId  
                     and ru.RuleTypeId = 4267  
                     and v.ProcedureCodeId = r.ProcedureCodeId  
                     and isnull(ru.RecordDeleted, ''N'') = ''N''  
                     and isnull(v.RecordDeleted, ''N'') = ''N'') 

update #Report 
   set IsOtherByCoverage = ''Y''
 where isnull(IsMedicaidByCoverage, ''N'') = ''N''
   and isnull(IsGFByCoverage, ''N'') = ''N''
   and isnull(IsABWByCoverage, ''N'') = ''N''
   and isnull(IsMIChildByCoverage, ''N'') = ''N''
   and isnull(IsOtherByCoverage, ''N'') = ''N''
  

--
-- By Charge
--

update r
   set CoveragePlanIdByCharge = ccp.CoveragePlanId,
       IsMedicaidByCharge = case when cap.AccountSubtype = ''MEDICAID'' then ''Y'' else ''N'' end,
       IsGFByCharge = case when cap.AccountSubtype = ''GF'' then ''Y'' else ''N'' end,
       IsABWByCharge = case when cap.AccountSubtype = ''ABW'' then ''Y'' else ''N'' end,
       IsMIChildByCharge = case when cap.AccountSubtype = ''MICHILD'' then ''Y'' else ''N'' end,
       IsOtherByCharge = case when cap.CoveragePlanId is null then ''Y'' else ''N'' end
  from #Report r
       join Charges c on c.ServiceId = r.ServiceId
       left join ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = c.ClientCoveragePlanId
       left join CustomGLAccountCoveragePlans cap on cap.CoveragePlanId = ccp.CoveragePlanId and 
                                                     cap.AccountSubtype in (''MEDICAID'', ''GF'', ''ABW'', ''MICHILD'') 
 where isnull(c.RecordDeleted, ''N'') = ''N''
   and exists(select ''*''
                from ARLedger arl
               where arl.ChargeId = c.ChargeId
                 and isnull(arl.RecordDeleted, ''N'') = ''N''
               group by arl.ChargeId
              having sum(case when arl.LedgerType in (4201, 4204) then amount else 0 end) <> 0 -- Charges, Trasfers
                  or sum(case when arl.LedgerType in (4202) then amount else 0 end) <> 0 -- Payments
                  or sum(case when arl.LedgerType in (4203) then amount else 0 end) <> 0) -- Adjustments
   and not exists(select *
                    from Charges c2
                         left join ClientCoveragePlans ccp2 on ccp2.ClientCoveragePlanId = c2.ClientCoveragePlanId
                         left join CustomGLAccountCoveragePlans cap2 on cap2.CoveragePlanId = ccp2.CoveragePlanId and 
                                                                        cap2.AccountSubtype in (''MEDICAID'', ''GF'', ''ABW'', ''MICHILD'') 
                   where c2.ServiceId = r.ServiceId
                     and isnull(c2.RecordDeleted, ''N'') = ''N''
                     and case when cap2.AccountSubtype = ''MEDICAID'' then -1
                              when c2.Priority = 0 then 999
                              else c2.Priority end < 
                         case when cap.AccountSubtype = ''MEDICAID'' then -1 
                              when c.Priority = 0 then 999
                              else c.Priority end
                     and exists(select ''*''
                                  from ARLedger arl
                                 where arl.ChargeId = c2.ChargeId
                                   and isnull(arl.RecordDeleted, ''N'') = ''N''
                                 group by arl.ChargeId
                                having sum(case when arl.LedgerType in (4201, 4204) then amount else 0 end) <> 0 -- Charges, Trasfers
                                    or sum(case when arl.LedgerType in (4202) then amount else 0 end) <> 0 -- Payments
                                    or sum(case when arl.LedgerType in (4203) then amount else 0 end) <> 0) -- Adjustments
                  )


--
-- By Payment
--

update r
   set CoveragePlanIdByPayment = ccp.CoveragePlanId,
       IsMedicaidByPayment = case when cap.AccountSubtype = ''MEDICAID'' then ''Y'' else ''N'' end,
       IsGFByPayment = case when cap.AccountSubtype = ''GF'' then ''Y'' else ''N'' end,
       IsABWByPayment = case when cap.AccountSubtype = ''ABW'' then ''Y'' else ''N'' end,
       IsMIChildByPayment = case when cap.AccountSubtype = ''MICHILD'' then ''Y'' else ''N'' end,
       IsOtherByPayment = case when cap.CoveragePlanId is null then ''Y'' else ''N'' end
  from #Report r
       join Charges c on c.ServiceId = r.ServiceId
       join (select ChargeId
               from ARLedger 
              where LedgerType = 4202 -- Payment
                and isnull(RecordDeleted, ''N'') = ''N''
              group by ChargeId
             having sum(Amount) < 0) l on l.ChargeId = c.ChargeId
       left join ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = c.ClientCoveragePlanId
       left join CustomGLAccountCoveragePlans cap on cap.CoveragePlanId = ccp.CoveragePlanId and 
                                                     cap.AccountSubtype in (''MEDICAID'', ''GF'', ''ABW'', ''MICHILD'') 
 where isnull(c.RecordDeleted, ''N'') = ''N''
   and not exists(select *
                    from Charges c2
                         join (select ChargeId
                                 from ARLedger 
                                where LedgerType = 4202
                                  and isnull(RecordDeleted, ''N'') = ''N''
                                group by ChargeId
                               having sum(Amount) < 0) l2 on l2.ChargeId = c2.ChargeId
                         left join ClientCoveragePlans ccp2 on ccp2.ClientCoveragePlanId = c2.ClientCoveragePlanId
                         left join CustomGLAccountCoveragePlans cap2 on cap2.CoveragePlanId = ccp2.CoveragePlanId and 
                                                                        cap2.AccountSubtype in (''MEDICAID'', ''GF'', ''ABW'', ''MICHILD'') 
                   where c2.ServiceId = r.ServiceId
                     and isnull(c2.RecordDeleted, ''N'') = ''N''
                     and case when cap2.AccountSubtype = ''MEDICAID'' then -1
                              when c2.Priority = 0 then 999
                              else c2.Priority end < 
                         case when cap.AccountSubtype = ''MEDICAID'' then -1 
                              when c.Priority = 0 then 999
                              else c.Priority end)

--
-- Calculate units
--

insert into #ClaimLines (
       ServiceId,
       CoveragePlanId,
       ServiceUnits)
select ServiceId,
       CoveragePlanIdByCoverage,
       ServiceUnits
  from #Report

insert into #ClaimLines (
       ServiceId,
       CoveragePlanId,
       ServiceUnits)
select ServiceId,
       CoveragePlanIdByCharge,
       ServiceUnits
  from #Report r
 where (IsMedicaidByCharge = ''Y''
    or  IsGFByCharge = ''Y''
    or  IsABWByCharge = ''Y''
    or  IsMIChildByCharge = ''Y''
    or  IsOtherByCharge = ''Y'')
   and not exists(select *
                    from #ClaimLines cl
                   where cl.ServiceId = r.ServiceId
                     and isnull(cl.CoveragePlanId, -999) = isnull(r.CoveragePlanIdByCharge, -999))
   
insert into #ClaimLines (
       ServiceId,
       CoveragePlanId,
       ServiceUnits)
select ServiceId,
       CoveragePlanIdByPayment,
       ServiceUnits
  from #Report r
 where (IsMedicaidByPayment = ''Y''
    or  IsGFByPayment = ''Y''
    or  IsABWByPayment = ''Y''
    or  IsMIChildByPayment = ''Y''
    or  IsOtherByPayment = ''Y'')
   and not exists(select *
                    from #ClaimLines cl
                   where cl.ServiceId = r.ServiceId
                     and isnull(cl.CoveragePlanId, -999) = isnull(r.CoveragePlanIdByPayment, -999))


exec ssp_PMClaimsGetBillingCodes


update r 
   set BillingCodeByCoverage = cl.BillingCode, 
       UnitsByCoverage = cl.ClaimUnits
  from #Report r
       join #ClaimLines cl on cl.ServiceId = r.ServiceId and
                              isnull(cl.CoveragePlanId, -999) = isnull(r.CoveragePlanIdByCoverage, -999)

update r 
   set BillingCodeByCharge = cl.BillingCode, 
       UnitsByCharge = cl.ClaimUnits
  from #Report r
       join #ClaimLines cl on cl.ServiceId = r.ServiceId and
                              isnull(cl.CoveragePlanId, -999) = isnull(r.CoveragePlanIdByCharge, -999)
 where IsMedicaidByCharge = ''Y''
    or IsGFByCharge = ''Y''
    or IsABWByCharge = ''Y''
    or IsMIChildByCharge = ''Y''
    or IsOtherByCharge = ''Y''
    
update r 
   set BillingCodeByPayment = cl.BillingCode, 
       UnitsByPayment = cl.ClaimUnits
  from #Report r
       join #ClaimLines cl on cl.ServiceId = r.ServiceId and
                              isnull(cl.CoveragePlanId, -999) = isnull(r.CoveragePlanIdByPayment, -999)
 where IsMedicaidByPayment = ''Y''
    or IsGFByPayment = ''Y''
    or IsABWByPayment = ''Y''
    or IsMIChildByPayment = ''Y''
    or IsOtherByPayment = ''Y''

select @Services = count(*),
       @ServicesWithNoUnits = sum(case when UnitsByCoverage is null --and UnitsByCharge is null and UnitsByPayment is null
                                       then 1 
                                       else 0 
                                  end)
  from #Report


select p.ProgramName,
       isnull(r.Subaccount, ''Unknown'') as Account,
       max(sa.SubaccountType) as AccountType,
       sum(case when r.IsMedicaidByCoverage = ''Y''  then r.UnitsByCoverage else 0 end) MedicaidUnitsByCoverage,
       sum(case when r.IsMedicaidByCharge = ''Y''  then r.UnitsByCharge else 0 end) MedicaidUnitsByCharge,
       sum(case when r.IsMedicaidByPayment = ''Y''  then r.UnitsByPayment else 0 end) MedicaidUnitsByPayment,
       sum(case when r.IsGFByCoverage = ''Y''  then r.UnitsByCoverage else 0 end) GFUnitsByCoverage,
       sum(case when r.IsGFByCharge = ''Y''  then r.UnitsByCharge else 0 end) GFUnitsByCharge,
       sum(case when r.IsGFByPayment = ''Y''  then r.UnitsByPayment else 0 end) GFUnitsByPayment,
       sum(case when r.IsABWByCoverage = ''Y''  then r.UnitsByCoverage else 0 end) ABWUnitsByCoverage,
       sum(case when r.IsABWByCharge = ''Y''  then r.UnitsByCharge else 0 end) ABWUnitsByCharge,
       sum(case when r.IsABWByPayment = ''Y''  then r.UnitsByPayment else 0 end) ABWUnitsByPayment,
       sum(case when r.IsMIChildByCoverage = ''Y''  then r.UnitsByCoverage else 0 end) MIChildUnitsByCoverage,
       sum(case when r.IsMIChildByCharge = ''Y''  then r.UnitsByCharge else 0 end) MIChildUnitsByCharge,
       sum(case when r.IsMIChildByPayment = ''Y''  then r.UnitsByPayment else 0 end) MIChildUnitsByPayment,
       sum(case when r.IsOtherByCoverage = ''Y''  then r.UnitsByCoverage else 0 end) OtherUnitsByCoverage,
       sum(case when r.IsOtherByCharge = ''Y''  then r.UnitsByCharge else 0 end) OtherUnitsByCharge,
       sum(case when r.IsOtherByPayment = ''Y''  then r.UnitsByPayment else 0 end) OtherUnitsByPayment,
       sum(isnull(r.UnitsByCoverage, 0)) UnitsByCoverage,
       sum(isnull(r.UnitsByCharge, 0)) UnitsByCharge,
       sum(isnull(r.UnitsByPayment, 0)) UnitsByPayment,
       @Services as ServicesCount,
       @ServicesWithNoUnits  as ServicesWithNoUnitsCount
  from #Report r
       join Programs p on p.ProgramId = r.ProgramId
       left join CustomGLsubaccounts sa on sa.GLSubaccountId = r.GLSubaccountId
 group by p.ProgramName,
          r.Subaccount
 order by case when r.Subaccount is null then 1 else 2 end,
          p.ProgramName,
          r.Subaccount
' 
END
GO
