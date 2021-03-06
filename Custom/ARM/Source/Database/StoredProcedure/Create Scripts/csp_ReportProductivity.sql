
/****** Object:  StoredProcedure [dbo].[CSP_REPORTPRODUCTIVITY]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportProductivity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CSP_REPORTPRODUCTIVITY] 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_ReportProductivity]
@StartDate datetime = null,
@EndDate   datetime = null

as

/* ===========================================================
Author:		
Create date: 
Description:	
======= History =============================================
07/23/2018	Msood		What: Changed the Hardcoded values 'P/R/E' to GlobalCodeId for Category ChargeType
						Why: A Renewed Mind - Support Task#942
07/24/2018	Msood		What: Changed the Hardcoded values 'A to GlobalCodeId for Category ChargeType
						Why: A Renewed Mind - Support Task#942
===========================================================  */
Create Table #Services  
(ServiceId  int null,  
 ClientId int null,  
 ClinicianId int null,  
 DateOfService  DateTime null,  
 ProcedureCodeId int null,  
 Unit  int null,  
 Status  int null,  
 ChargeExists char(1) null,  
 ProgramId int null,  
 LocationID int null,  
 Billable char(1) null,  
 PrimaryCoverage int null,  
 BillableUnits int null,  
 FaceToFace char(1) null,  
 NonFaceToFace char(1) null,  
 BillableMarkedNB char(1) null)  
  
Create Table #Productivity  
(Team   varchar(150) null,  
 ClinicianId int null,  
 ClinicianName varchar(200) null,  
 MonthNo int null,  
 MonthName varchar(50)  null,  
 ProcedureCodeId int null,  
 DisplayAs varchar(100) null,  
 LastFYBServices int null,  
 ThisFYBServices int null,  
 LastFYNBServices int null,  
 ThisFYNBServices int null,  
 LastFYBUnits  int null,  
 ThisFYBUnits  int null,  
 LastFYNBUnits  int null,  
 ThisFYNBUnits  int null)  
     
 
--Insertt get initial service data  
  
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
 Where s.status in (75) --Complete  
  AND isnull(s.RecordDeleted, 'N') = 'N'   
  and ((s.DateOfService >= DateAdd(yy, -1, @StartDate) and s.DateOfService < DateAdd(dd, 1, DateAdd(yy, -1, @EndDate)))  
    or  (s.DateOfService >= @StartDate and s.DateOfService < DateAdd(dd, 1, @EndDate)))  
 
  
-- Update Service With Primary Charge Coverage for Billable Service  
  
 Update s  
 Set PrimaryCoverage = ar.CoveragePlanId,  
 ChargeExists = 'Y',  
 FaceToFace = 'Y'  
 From #Services s  
 Join Charges ch on s.ServiceId = ch.ServiceId and isnull(ch.RecordDeleted, 'N') = 'N'  
 Join Arledger ar on ar.ChargeId = ch.ChargeId and LedgerType = 4201 and isnull(ar.RecordDeleted, 'N') = 'N'  
-- Left Join ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = ar.ClientCoveragePlanId and isnull(ar.RecordDeleted, 'N') = 'N'  
-- Left Join CoveragePlans cp on cp.CoveragePlanId = ar.CoveragePlanId  
 Join ProcedureCodes pc on pc.ProcedureCodeId = s.ProcedureCodeId  
 where s.Billable = 'Y' and isnull(pc.NotBillable, 'N') = 'N'   
 and s.ProcedureCodeId not in (select procedureCodeId from CustomReportProductivityNonBillable)  
  
  
-- Update Service With Primary Charge Coverage for Non Billable Service  
  
 Update s  
 Set PrimaryCoverage = NULL,  
 ChargeExists = 'N',  
 BillableMarkedNB = 'Y'  
 From #Services s  
 Join ProcedureCodes pc on pc.ProcedureCodeId = s.ProcedureCodeId  
 where s.Billable = 'N' and isnull(pc.NotBillable, 'N') = 'N'   
 and s.ProcedureCodeId not in (select procedureCodeId from CustomReportProductivityNonBillable)  
 
  
-- Update Service for Non Billable Service  
  
 Update s  
 Set PrimaryCoverage = NULL,  
 ChargeExists = 'N',  
 NonFaceToFace = 'Y'  
 From #Services s  
 Join ProcedureCodes pc on pc.ProcedureCodeId = s.ProcedureCodeId  
 where (isnull(pc.NotBillable, 'N') = 'Y'   
 or s.ProcedureCodeId in (select procedureCodeId from CustomReportProductivityNonBillable))  

  
-- Update Units for Billable Services  
   
 Update s  
 set BillableUnits = case when PR.BillingCodeUnitType  = 6761 --Msood Removed HardCoded 'A' and Changed the value with GlobalCodeId for Per of Category ChargeType
 then PR.BillingCodeClaimUnits else  
 convert(int, s.Unit/PR.BillingCodeUnits) * PR.BillingCodeClaimUnits end  
 From #Services s  
 JOIN Staff ST ON (S.ClinicianId = ST.StaffId)  
 JOIN procedurerates PR ON (S.ProcedureCodeId = PR.ProcedureCodeId)  
-- and isnull(s.PrimaryCoverage, 0) = isnull(PR.CoveragePlanId,0))  
 left outer join ProcedureRatePrograms PRP on PR.ProcedureRateId=PRP.ProcedureRateId  left outer join ProcedureRateLocations PRL on PR.ProcedureRateId=PRL.ProcedureRateId  
 left outer join ProcedureRateDegrees PRD on PR.ProcedureRateId=PRD.ProcedureRateId  
 left outer join ProcedureRateStaff PRS on PR.ProcedureRateId=PRS.ProcedureRateId  
 left outer join ProcedureRateBillingCodes PRBC on PR.ProcedureRateId=PRBC.ProcedureRateId  
 where isnull(PR.RecordDeleted,'N') ='N' AND  
 isnull(PRP.RecordDeleted,'N') ='N' AND  
 isnull(PRL.RecordDeleted,'N') ='N' AND  
 isnull(PRD.RecordDeleted,'N') ='N' AND  
 isnull(PRS.RecordDeleted,'N') ='N' AND  
 isnull(PRBC.RecordDeleted,'N') ='N' AND  
 PR.FromDate<= S.DateOfService And  
 (dateadd(dd, 1, PR.ToDate) > S.DateOfService  or PR.ToDate is NULL)And  
 (PRP.programId= S.ProgramId or PR.ProgramGroupName is Null) and  
 (PRL.LocationId= S.LocationId or PR.LocationGroupName is NULL) and  
 (PRD.Degree= ST.Degree or PR.DegreeGroupName is NULL) and   
 (PR.ClientId= S.ClientId or PR.ClientId is NULL) and  
 (PRS.StaffId= S.ClinicianId or PR.StaffGroupName is NULL) and 
 --Msood 07/23/2018
 ((PR.ChargeType = 6761 and s.Unit >= PR.FromUnit --'Per of Category ChargeType'
--((PR.ChargeType = 'P' and s.Unit >= PR.FromUnit   
 /*and convert(int, s.Unit*100)%convert(int, PR.FromUnit*100) = 0*/)  
 or (PR.ChargeType = 6762 and  s.Unit=PR.FromUnit)  -- For Exactly of Category ChargeType
--  or (PR.ChargeType = 'E' and  s.Unit=PR.FromUnit)  
 or (PR.ChargeType = 6763  and s.Unit >= PR.FromUnit and s.Unit <= PR.ToUnit) -- Range of Category ChargeType
  --or (PR.ChargeType = 'R' and s.Unit >= PR.FromUnit and s.Unit <= PR.ToUnit)  
  ) and  
 (PR.Advanced <> 'Y' or (s.Unit >= PRBC.FromUnit and s.Unit <= PRBC.ToUnit))  
 and (s.FaceToFace = 'Y' Or s.BillableMarkedNB = 'Y')  
  
  
-- Update Units for Non Billable Services  
 Update s  
 Set BillableUnits = case when nb.EncounterUnit = 'E' then nb.Units   
       when nb.EncounterUnit = 'U' then   
    convert(int, s.Unit/nb.Units) * 1  
       else 1 end  
 From #Services s  
 Left Join CustomReportProductivityNonBillable nb on nb.ProcedureCodeId = s.ProcedureCodeId and isnull(nb.RecordDeleted, 'N') = 'N'  
 Where s.NonFaceToFace = 'Y'  
   
-- Update Units FPE encouners to 15 minute units for productivity  
 Update s  
 Set BillableUnits = Unit / 15   
 From #Services s  
 Where s.ProcedureCodeId in (199, 200, 201, 202)  
  
  
Insert into #Productivity  
(Team ,  
 ClinicianId,  
 ClinicianName,  
 MonthNo,  
 MonthName,  
 ProcedureCodeId,  
 DisplayAs,  
 LastFYBServices,  
 ThisFYBServices,  
 LastFYNBServices,  
 ThisFYNBServices,  
 LastFYBUnits ,  
 ThisFYBUnits ,  
 LastFYNBUnits ,  
 ThisFYNBUnits )  
  
  
 select isnull(gc.CodeName, 'Unknown') as Team,  
 s.ClinicianId,   
 st.LastName + ', '+ st.FirstName as ClinicianName,  
 DateDiff(mm, DateAdd(yy, -1, @StartDate), s.DateOfService) % 12 + 1 as MonthNo,  
 DateName(mm, DateAdd(mm, (DateDiff(mm, DateAdd(yy, -1, @StartDate), s.DateOfService) % 12 + 1) -1, @startdate)) As MonthName,  
        s.ProcedureCodeId,  
 pc.DisplayAs,  
 sum(case when s.FaceToFace = 'Y' and s.DateOfService < @StartDate then 1 else 0 end) as LastFYBServices,  
  
 sum(case when s.FaceToFace = 'Y' and s.DateOfService >= @StartDate then 1 else 0 end) as ThisFYBServices,  
  
 sum(case when (s.NonFaceToFace = 'Y' or BillableMarkedNB = 'Y') and s.DateOfService < @StartDate then 1 else 0 end) as LastFYNBServices,  
  
 sum(case when (s.NonFaceToFace = 'Y' or BillableMarkedNB = 'Y') and s.DateOfService >= @StartDate then 1 else 0 end) as ThisFYNBServices,  
  
 sum(case when s.FaceToFace = 'Y'  
   and s.DateOfService < @StartDate then BillableUnits else 0 end) as LastFYBUnits,  
  
 sum(case when s.FaceToFace = 'Y'  
   and s.DateOfService >= @StartDate then BillableUnits else 0 end) as ThisFYBUnits,  
  
 sum(case when (s.NonFaceToFace = 'Y' or BillableMarkedNB = 'Y')  
   and s.DateOfService < @StartDate then BillableUnits else 0 end) as LastFYNBUnits,  
  
 sum(case when (s.NonFaceToFace = 'Y' or BillableMarkedNB = 'Y')  
   and s.DateOfService >= @StartDate then BillableUnits else 0 end) as ThisFYNBUnits  
   
        FROM #Services s  
        Join Programs p on p.ProgramId = s.ProgramId AND isnull(p.RecordDeleted, 'N') = 'N'   
 Left Join GlobalCodes gc on gc.GlobalCodeId = p.ProgramType AND isnull(gc.RecordDeleted, 'N') = 'N'   
 Join Staff st on st.StaffId = s.ClinicianId AND isnull(st.RecordDeleted, 'N') = 'N'   
 Join ProcedureCodes pc on pc.ProcedureCodeId = s.ProcedureCodeId AND isnull(pc.RecordDeleted, 'N') = 'N'   
 Group By isnull(gc.CodeName, 'Unknown'),  
 s.ClinicianId,   
 st.LastName + ', '+ st.FirstName,  
 DateDiff(mm, DateAdd(yy, -1, @StartDate), s.DateOfService) % 12 + 1,  
 DateName(mm, DateAdd(mm, (DateDiff(mm, DateAdd(yy, -1, @StartDate), s.DateOfService) % 12 + 1) -1, @startdate)),  
 s.ProcedureCodeId,  
 pc.DisplayAs  
 order by isnull(gc.CodeName, 'Unknown'),  
 st.LastName + ', '+ st.FirstName ,  
 DateDiff(mm, DateAdd(yy, -1, @StartDate), s.DateOfService) % 12 + 1   
   
  
  
-- Insert for Team Totals  
 Insert into #Productivity  
 (Team ,  
  ClinicianId,  
  ClinicianName,  
  MonthNo,  
  MonthName,  
  DisplayAs,  
  LastFYBServices,  
  ThisFYBServices,  
  LastFYNBServices,  
  ThisFYNBServices,  
  LastFYBUnits ,  
  ThisFYBUnits ,  
  LastFYNBUnits ,  
  ThisFYNBUnits )  
 Select   
   Team ,  
  0,  
  Team + ' Team',  
  MonthNo,  
  MonthName,  
  DisplayAs,  
  Sum(LastFYBServices),  
  Sum(ThisFYBServices),  
  Sum(LastFYNBServices),  
  Sum(ThisFYNBServices),  
  Sum(LastFYBUnits) ,  
  Sum(ThisFYBUnits) ,  
  Sum(LastFYNBUnits) ,  
  Sum(ThisFYNBUnits )  
 From #Productivity  
 Group By Team ,  
  ClinicianName,  
  MonthNo,  
  MonthName,  
  DisplayAs  

  
  
Select Team ,  
 ClinicianId,  
 ClinicianName,  
 MonthNo,  
 MonthName,  
 DisplayAs,  
 LastFYBServices,  
 ThisFYBServices,  
 LastFYNBServices,  
 ThisFYNBServices,  
 LastFYBUnits ,  
 ThisFYBUnits ,  
 LastFYNBUnits ,  
 ThisFYNBUnits   
 From #Productivity  
 Order By    
 Team ,  
 Case When ClinicianId = 0 then 0 else 1 end,  
 ClinicianName,  
 MonthNo,  
 DisplayAs  
  
drop table #Services  
drop table #Productivity  