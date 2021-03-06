/****** Object:  StoredProcedure [dbo].[csp_ReportServiceUtilization]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportServiceUtilization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportServiceUtilization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportServiceUtilization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create procedure [dbo].[csp_ReportServiceUtilization]
@StartDate   datetime,
@EndDate     datetime
/********************************************************************************
-- Stored Procedure: dbo.csp_ReportServiceUtilization 
--
-- Copyright: 2008 Streamline Healthcate Solutions
--
-- Purpose: Service Utilization report
--
-- Updates:                     		                                
-- Date        Author      Purpose
-- 01.24.2008  SFarber     Created.     
--
*********************************************************************************/
as

--declare @StartDate   datetime, @EndDate     datetime
--select @StartDate = ''10/1/2007'', @EndDate = ''1/31/2008''

create table #ClaimLines (
ClaimLineId            int identity not null,
ServiceId              int          null,
CoveragePlanId         int          null,
ServiceUnits           decimal(18,2)null,
BillingCode            varchar(15)  null,
Modifier1              char(2)      null,
Modifier2              char(2)      null,
Modifier3              char(2)      null,
Modifier4              char(2)      null,
RevenueCode            varchar(15)  null,
RevenueCodeDescription varchar(100) null,
ClaimUnits             int          null,
Priority               int          null)	

create table #Services (
ServiceId              int          null,
ClientId               int          null,
ProcedureCodeId        int          null,
ProgramId              int          null,
DateOfService          datetime     null,
UnitType               int          null,
ServiceUnits           decimal(18,2)null,
Units                  decimal(18,2)null,
ClinicianId            int          null,
DiagnosisCode1         char(6)      null,
DiagnosisCode2         char(6)      null,
DiagnosisCode3         char(6)      null,
Charge                 money        null)

create table #Charges (
ChargeId               int          null,
ServiceId              int          null,
CoveragePlanId         int          null,
Priority               int          null,
Units                  decimal(18,2)null,
Charge                 money        null,
Payment                money        null)

create table #ReportDetail (
GroupId          int              null,
ServiceId        int              null,
ProgramId        int              null,
ClinicianId      int              null,
ClientId         int              null,
UnitType         varchar(50)      null,
Units            decimal(18, 2)   null,
CoveragePlanName varchar(50)      null,
Charge           money            null,
Payment          money            null,
DaysInProgram    int              null)

create table #ReportGroup (
GroupId          int              null,
ProgramId        int              null,
ClinicianId      int              null,
ClientId         int              null,
Diagnosis        varchar(1000)    null,
UnitType         varchar(50)      null,
Units            decimal(18, 2)   null,
CoveragePlanName varchar(50)      null,
Charge           money            null,
Payment          money            null,
DaysInProgram    int              null)

insert into #Services (
       ServiceId,
       ClientId,
       ProcedureCodeId,
       ProgramId,
       DateOfService,
       UnitType,
       ServiceUnits,
       Units,
       ClinicianId,
       DiagnosisCode1,
       DiagnosisCode2,
       DiagnosisCode3,
       Charge)
select s.ServiceId,
       s.ClientId,
       s.ProcedureCodeId,
       s.ProgramId,
       s.DateOfService,
       s.UnitType,
       s.Unit,
       0,
       s.ClinicianId,
       s.DiagnosisCode1,
       s.DiagnosisCode2,
       s.DiagnosisCode3,
       s.Charge
  from Services s
 where s.Billable = ''Y''
   and s.Status = 75 -- Completed
   and s.DateOfService >= @StartDate
   and s.DateOfService < dateadd(dd, 1, @EndDate)
   and isnull(s.RecordDeleted, ''N'') = ''N''
   and exists(select * 
                from Charges c
               where c.ServiceId = s.ServiceId
                 and isnull(c.RecordDeleted, ''N'') = ''N'')

insert into #Charges (
       ChargeId,
       ServiceId,
       CoveragePlanId,
       Priority,
       Charge,
       Payment)
select c.ChargeId,
       s.ServiceId,
       isnull(ccp.CoveragePlanId, arl.CoveragePlanId),
       case when isnull(c.Priority, 0) = 0 then 99999 else c.Priority end,
       arl.Charge,
       arl.Payment
  from #Services s
       join Charges c on c.ServiceId = s.ServiceId
       left join ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = c.ClientCoveragePlanId
       join (select ChargeId,
                    max(CoveragePlanId)as CoveragePlanId,
                    sum(case when LedgerType in (4201, 4204) then Amount else 0 end) as Charge,
                    sum(case when LedgerType = 4202 then Amount else 0 end) as Payment
               from ARLedger
              where isnull(RecordDeleted, ''N'') = ''N''
              group by ChargeId) as arl on arl.ChargeId = c.ChargeId
 where (isnull(arl.Charge, 0) <> 0  or isnull(arl.Payment, 0) <> 0)
   and isnull(c.RecordDeleted, ''N'') = ''N''


--
-- Calculate units
--

insert into #ClaimLines (
       ServiceId,
       CoveragePlanId,
       ServiceUnits,
       Priority)
select s.ServiceId,
       c.CoveragePlanId,
       s.ServiceUnits,
       isnull(c.Priority, 99999)
  from #Services s
       left join #Charges c on c.ServiceId = s.ServiceId

exec ssp_PMClaimsGetBillingCodes

update s 
   set Units = cl.ClaimUnits
  from #Services s
       join #ClaimLines cl on cl.ServiceId = s.ServiceId
 where not exists(select *
                    from #ClaimLines cl2
                   where cl2.ServiceId = s.ServiceId
                     and cl2.Priority > cl.Priority)

update c
   set Units = case when s.Charge = 0 then 0 else (s.Units * c.Charge) / s.Charge end
  from #Charges c
       join #Services s on s.ServiceId = c.ServiceId

--
-- Calculate report 
--

insert into #ReportDetail (
       ServiceId,
       ProgramId,
       ClinicianId,
       ClientId,
       UnitType,
       Units,
       CoveragePlanName,
       Charge,
       Payment,
       DaysInProgram)
select s.ServiceId,
       s.ProgramId,
       s.ClinicianId,
       s.ClientId,
       convert(varchar, convert(int, case when s.Units = 0 then s.ServiceUnits else s.ServiceUnits/s.Units end)) + '' '' + 
       isnull(gc.CodeName, ''Unknown'') as UnitType,
       isnull(c.Units, s.Units) as Units,
       case when c.ChargeId is not null then isnull(cp.DisplayAs, ''Self'') else null end as CoveragePlanName,
       isnull(c.Charge, 0) as Charge,
       isnull(c.Payment, 0) as Payment,
       datediff(dd, clp.EnrolledDate, isnull(clp.DischargedDate, getdate())) as DaysInProgram
  from #Services s
       left join #Charges c on c.ServiceId = s.ServiceId
       left join GlobalCodes gc on gc.GlobalCodeId = s.UnitType
       left join CoveragePlans cp on cp.CoveragePlanId = c.CoveragePlanId
       left join ClientPrograms clp on clp.ClientId = s.ClientId and clp.ProgramId = s.ProgramId and 
                                       clp.EnrolledDate <= s.DateOfService and 
                                       (s.DateOfService < dateadd(dd, 1, clp.DischargedDate) or clp.DischargedDate is null) and
                                       isnull(clp.RecordDeleted, ''N'') = ''N''
order by s.ProgramId,
         s.ClinicianId,
         s.ClientId,
         UnitType,
         CoveragePlanName,
         s.ServiceId

update rd
   set GroupId = rg.GroupId
  from #ReportDetail rd
       join (select ProgramId,
                    ClinicianId,
                    ClientId,
                    UnitType,
                    CoveragePlanName,
                    min(ServiceId) as GroupId
               from #ReportDetail 
              group by ProgramId,
                       ClinicianId,
                       ClientId,
                       UnitType,
                       CoveragePlanName) as rg on rg.ProgramId = rd.ProgramId and
                                                  rg.ClinicianId = rd.ClinicianId and
                                                  rg.ClientId = rd.ClientId and
                                                  rg.UnitType = rd.UnitType and
                                                  isnull(rg.CoveragePlanName, ''IsNuLl'') = isnull(rd.CoveragePlanName, ''IsNuLl'')

insert into #ReportGroup (
       GroupId,
       ProgramId,
       ClinicianId,
       ClientId,
       UnitType,
       Units,
       CoveragePlanName,
       Charge,
       Payment,
       DaysInProgram)
select GroupId,
       max(ProgramId),
       max(ClinicianId),
       max(ClientId),
       max(UnitType),
       sum(Units),
       max(CoveragePlanName),
       sum(Charge),
       sum(Payment),
       max(DaysInProgram)
  from #ReportDetail
 group by GroupId

--
-- Set diagnosis
-- 

while exists(select ''*'' 
               from #Services s
                    join #ReportDetail rd on rd.ServiceId = s.ServiceId
                    join #ReportGroup rg on rg.GroupId = rd.GroupId           
              where (charindex('', '' + DiagnosisCode1 + '', '', '', '' + isnull(rg.Diagnosis, '''') + '', '') = 0 and len(s.DiagnosisCode1) > 0)
                 or (charindex('', '' + DiagnosisCode2 + '', '', '', '' + isnull(rg.Diagnosis, '''') + '', '') = 0 and len(s.DiagnosisCode2) > 0)
                 or (charindex('', '' + DiagnosisCode3 + '', '', '', '' + isnull(rg.Diagnosis, '''') + '', '') = 0 and len(s.DiagnosisCode3) > 0))

begin
  update rg
     set Diagnosis = case when rg.Diagnosis is null then '''' else rg.Diagnosis + '', '' end + s.DiagnosisCode1
    from #Services s
         join #ReportDetail rd on rd.ServiceId = s.ServiceId
         join #ReportGroup rg on rg.GroupId = rd.GroupId           
   where charindex('', '' + DiagnosisCode1 + '', '', '', '' + isnull(rg.Diagnosis, '''') + '', '') = 0
     and len(s.DiagnosisCode1) > 0

  update rg
     set Diagnosis = case when rg.Diagnosis is null then '''' else rg.Diagnosis + '', '' end + s.DiagnosisCode2
    from #Services s
         join #ReportDetail rd on rd.ServiceId = s.ServiceId
         join #ReportGroup rg on rg.GroupId = rd.GroupId           
   where charindex('', '' + DiagnosisCode2 + '', '', '', '' + isnull(rg.Diagnosis, '''') + '', '') = 0
     and len(s.DiagnosisCode2) > 0

  update rg
     set Diagnosis = case when rg.Diagnosis is null then '''' else rg.Diagnosis + '', '' end + s.DiagnosisCode3
    from #Services s
         join #ReportDetail rd on rd.ServiceId = s.ServiceId
         join #ReportGroup rg on rg.GroupId = rd.GroupId           
   where charindex('', '' + DiagnosisCode3 + '', '', '', '' + isnull(rg.Diagnosis, '''') + '', '') = 0
     and len(s.DiagnosisCode3) > 0
end 

--
-- Final selelct
--

select rg.ProgramId,
       p.ProgramName,
       rg.ClinicianId,
       s.LastName + '', '' + s.FirstName as ClinicianName,
       rg.ClientId,
       c.LastName + '', '' + c.FirstName as ClientName,
       rg.Diagnosis,
       rg.UnitType,
       rg.Units,
       rg.CoveragePlanName,
       rg.Charge,
       rg.Payment,
       rg.DaysInProgram
  from #ReportGroup rg
       join Programs p on p.ProgramId = rg.ProgramId
       join Staff s on s.StaffId = rg.ClinicianId
       join Clients c on c.ClientId = rg.ClientId
 order by p.ProgramName,
          ClinicianName,
          ClientName
' 
END
GO
