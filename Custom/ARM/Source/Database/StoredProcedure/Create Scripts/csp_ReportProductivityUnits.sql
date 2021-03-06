
/****** Object:  StoredProcedure [dbo].[CSP_REPORTPRODUCTIVITY]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportProductivityUnits]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportProductivityUnits]  -- '01/01/2018', '01/02/2018'
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_ReportProductivityUnits]
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
(ProgramName   varchar(150) null,  
 ClinicianId int null,  
 ClinicianName varchar(200) null,  
 ClientId int null,
 ClientName varchar(200) null,
 ProcedureCodeName varchar(200) null,
 DisplayAs varchar(200) null,
 DateOfService DateTime null,
 Unit int NULL)
 
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
 left outer join ProcedureRatePrograms PRP on PR.ProcedureRateId=PRP.ProcedureRateId AND isnull(PRP.RecordDeleted,'N') ='N' 
 left outer join ProcedureRateLocations PRL on PR.ProcedureRateId=PRL.ProcedureRateId AND isnull(PRL.RecordDeleted,'N') ='N'
 left outer join ProcedureRateDegrees PRD on PR.ProcedureRateId=PRD.ProcedureRateId AND isnull(PRD.RecordDeleted,'N') ='N' 
 left outer join ProcedureRateStaff PRS on PR.ProcedureRateId=PRS.ProcedureRateId AND isnull(PRS.RecordDeleted,'N') ='N' 
 left outer join ProcedureRateBillingCodes PRBC on PR.ProcedureRateId=PRBC.ProcedureRateId AND isnull(PRBC.RecordDeleted,'N') ='N' 
 where isnull(PR.RecordDeleted,'N') ='N' AND  
	PR.FromDate<= S.DateOfService And  
	(dateadd(dd, 1, PR.ToDate) > S.DateOfService  or PR.ToDate is NULL)And  
	(PRP.programId= S.ProgramId or PR.ProgramGroupName is Null) and  
	(PRL.LocationId= S.LocationId or PR.LocationGroupName is NULL) and  
	(PRD.Degree= ST.Degree or PR.DegreeGroupName is NULL) and   
	(PR.ClientId= S.ClientId or PR.ClientId is NULL) and  
	(PRS.StaffId= S.ClinicianId or PR.StaffGroupName is NULL) and 
	--Msood 07/23/2018
	((PR.ChargeType = 6761 and s.Unit >= PR.FromUnit --'Per of Category ChargeType'
	or (PR.ChargeType = 6762 and  s.Unit=PR.FromUnit)  -- For Exactly of Category ChargeType
	or (PR.ChargeType = 6763  and s.Unit >= PR.FromUnit and s.Unit <= PR.ToUnit) -- Range of Category ChargeType
	) and  
	(PR.Advanced <> 'Y' or (s.Unit >= PRBC.FromUnit and s.Unit <= PRBC.ToUnit))  
	and (s.FaceToFace = 'Y' Or s.BillableMarkedNB = 'Y')  )
  
   
Insert into #Productivity  
(ProgramName,  
 ClinicianId,  
 ClinicianName,  
 ClientId,  
 ClientName,  
 ProcedureCodeName,  
 DisplayAs,  
 DateOfService ,  
 Unit )  
  
 select (Select ProgramName from Programs where ProgramId =S.ProgramId) as ProgramName,  
 s.ClinicianId,   
 st.LastName + ', '+ st.FirstName as ClinicianName,  
 s.ClientId,   
 c.FirstName +' ' + c.LastName as ClientName,
 (select DisplayAs from ProcedureCodes where ProcedureCodeId=s.ProcedureCodeId) as ProcedureCodeName,  
 pc.DisplayAs,  
 s.DateOfService,
 s.Unit
FROM #Services s  
        Join Programs p on p.ProgramId = s.ProgramId AND isnull(p.RecordDeleted, 'N') = 'N'   
		Join Staff st on st.StaffId = s.ClinicianId AND isnull(st.RecordDeleted, 'N') = 'N'  
		Join Clients c on c.ClientId = s.ClientId and isnull(st.RecordDeleted, 'N') = 'N'  
		Join ProcedureCodes pc on pc.ProcedureCodeId = s.ProcedureCodeId AND isnull(pc.RecordDeleted, 'N') = 'N'   
		order by 
		st.LastName + ', '+ st.FirstName  
   
     
  
Select ProgramName ,  
 ClinicianId,
 ClinicianName, 
 ClientId,
 ClientName,
 ProcedureCodeName,
  DisplayAs,  
 DateOfService,
 Unit
 From #Productivity  
 Order By    
 ClinicianName   

   
drop table #Services  
drop table #Productivity  