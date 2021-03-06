if object_id('dbo.csp_CheckWarnings') is not null
  drop procedure dbo.csp_CheckWarnings
go

create procedure dbo.csp_CheckWarnings
  @ClientId int,
  @ServiceId int,
  @ProcedureCodeId int,
  @ClinicianId int,
  @StartDate datetime,
  @EndDate datetime,
  @Attending varchar(10),
  @DSMCode1 varchar(30),
  @DSMCode2 varchar(30),
  @DSMCode3 varchar(30),
  @ServiceCompletionStatus varchar(10),
  @ProgramId int,
  @LocationId int,
  @Degree int,
  @UnitValue decimal(9, 2),
  @Count int,
  @ServiceAlreadyCompleted char(1),
  @Billable char(1),
  @DoesNotRequireStaffForService char(1),
  @PreviousStatus int
/*********************************************************************                
-- Stored Procedure: dbo.csp_CheckWarnings                
--                
-- Copyright: Streamline Healthcare Solutions                
-- Creation Date:  06.21.2013                
--                
-- Purpose: checks custom warnings for the service, while completing the service.           
--                
-- Data Modifications:                
--                
-- Updates:                 
--  Date         Author    Purpose                
-- 06.21.2006    SFarber   Created. 
--  OCT-07-2014  Akwinass  Passing null value for parameters @DSMCode1,@DSMCode2,@DSMCode3 (Task #134 in Engineering Improvement Initiatives- NBL(I))  
-- 1/8/2015      jcarlson  do not allow a service to complete if the dos is after 10/1 and they do not have a dsmv diagnosis
-- 4/17/2017     MD        Added validation 'Must have a signed note before completing a service' for Non Billabe Service if  Requires Signed Note rule exists w.r.t New Directions - Support Go Live #622
-- 09.17.2018    SFarber   Modified to switch authorization required errors for secondary payers from errors to warnings.
-- 2/14/2019	MJensen	   Remove auth required warning for plan Trillium if date of service prior to 2/1/2019.		NDNW Enhancements #952
         
**********************************************************************/
as 

	DECLARE @TrilliumPlanId INT = 316;-- applies only to Trillium coverage plan
	DECLARE @AuthBeginDate DATE = '20190201';-- Auth requirement starts on 1 FEB 2019

--  
-- Call csp_CheckWarnings if exists. 
-- This is needed since it used to be called directly from ssp_CheckWarnings.
-- It should be removed or revised for a new customer implementation. 
--

--
-- Check for client enrollment in the program on the date of service.
--
insert  into ServiceErrors
        (ServiceId,
         CoveragePlanId,
         ErrorType,
         ErrorSeverity,
         ErrorMessage)
select  sv.ServiceId,
        null,
        gc.GlobalCodeId,
        'E',
        'Client Not Enrolled in Program on Date of Service'
from    Services as sv
        cross join GlobalCodes as gc
where   sv.ServiceId = @ServiceId
        and gc.Category = 'SERVICEERRORTYPE'
        and gc.CodeName = 'Client Not Enrolled in Program on Date of Service'
        and isnull(gc.RecordDeleted, 'N') = 'N'
        and not exists ( select *
                         from   ClientPrograms as cpg
                         where  cpg.ClientId = sv.ClientId
                                and cpg.ProgramId = sv.ProgramId
                                and datediff(day, sv.DateOfService, cpg.EnrolledDate) <= 0
                                and ((cpg.DischargedDate is null)
                                     or (datediff(day, sv.DateOfService, cpg.DischargedDate) >= 0))
                                and isnull(cpg.RecordDeleted, 'N') = 'N' )

--
-- Do not allow procedure to complete if procedure / program is not configured.
--
insert  into ServiceErrors
        (ServiceId,
         CoveragePlanId,
         ErrorType,
         ErrorSeverity,
         ErrorMessage)
select  sv.ServiceId,
        null,
        gc.GlobalCodeId,
        'E',
        'Program is not configured to allow this procedure code.  Please review procedure code configuration.'
from    Services as sv
        cross join GlobalCodes as gc
where   sv.ServiceId = @ServiceId
        and gc.Category = 'SERVICEERRORTYPE'
        and gc.CodeName = 'Program is not configured to allow this procedure code.  Please review procedure code configuration.'
        and isnull(gc.RecordDeleted, 'N') = 'N'
        and not exists ( select *
                         from   ProcedureCodes as pc
                         where  pc.ProcedureCodeId = sv.ProcedureCodeId
                                and pc.AllowAllPrograms = 'Y'
                                and isnull(pc.RecordDeleted, 'N') = 'N' )
        and not exists ( select *
                         from   ProgramProcedures as pp
                         where  pp.ProgramId = sv.ProgramId
                                and pp.ProcedureCodeId = sv.ProcedureCodeId
                                and isnull(pp.RecordDeleted, 'N') = 'N' )
-- 
-- ICD10 diagnosis code is required starting 10/1/2015
--
declare @DSMCode varchar(20)
declare @ICD10Code varchar(20)
declare @ICD9Code varchar(20)
declare @ICD10StartDate date = '10/1/2015'
declare @DateOfService date = convert(date, @StartDate)

-- Get primary diagnosis codes
;
with  CTE_ServiceDiagnosis
        as (select  sd.DSMCode,
                    sd.ICD10Code,
                    sd.ICD9Code,
                    row_number() over (order by isnull(sd.[Order], 100), sd.ServiceDiagnosisId) as DiagnosisOrder
            from    ServiceDiagnosis sd
            where   sd.ServiceId = @ServiceId
                    and (sd.DSMCode is not null
                         or sd.ICD9Code is not null
                         or sd.ICD10Code is not null)
                    and isnull(sd.RecordDeleted, 'N') = 'N')
  select  @DSMCode = sd.DSMCode,
          @ICD10Code = sd.ICD10Code,
          @ICD9Code = sd.ICD9Code
  from    CTE_ServiceDiagnosis sd
  where   sd.DiagnosisOrder = 1
        
if @Billable = 'Y'
  and @ServiceAlreadyCompleted = 'N'
  and @ServiceCompletionStatus = 'Completed'
  and @DateOfService >= @ICD10StartDate
  and @ICD10Code is null
  begin

    insert  into dbo.ServiceErrors
            (ServiceId,
             ErrorType,
             ErrorMessage)
    select  @ServiceId,
            GlobalCodeId,
            CodeName
    from    dbo.GlobalCodes
    where   Category = 'SERVICEERRORTYPE'
            and CodeName = 'ICD10 diagnosis code is required starting 10/1/2015'
            and isnull(RecordDeleted, 'N') = 'N'
  end
        
    
--Must have a signed note before completing a service for Non Billabe Service if  Requires Signed Note rule exists  
declare @AssociatedNoteId int    
declare @RequiresSignedNote char(1)
select  @RequiresSignedNote = RequiresSignedNote,
        @AssociatedNoteId = AssociatedNoteId
from    ProcedureCodes
where   ProcedureCodeId = @ProcedureCodeId
        and isnull(RecordDeleted, 'N') <> 'Y'
    
if @AssociatedNoteId > 0
  and @Billable = 'N'
  and @RequiresSignedNote = 'Y'
  and @ServiceCompletionStatus = 'Completed'
  begin    
    if not exists ( select  *
                    from    Documents
                    where   ServiceId = @ServiceId
                            and Status = 22
                            and CurrentVersionStatus = 22
                            and isnull(RecordDeleted, 'N') <> 'Y' )
      begin    
        insert  into ServiceErrors
                (ServiceId,
                 ErrorType,
                 ErrorMessage)
        values  (@ServiceId,
                 4402,
                 'Must have a signed note before completing a service.')    
      end
  end  

---
--	Remove auth errors for Trillium auths before start date
---              
DELETE SE
FROM ServiceErrors se
JOIN Services s ON s.ServiceId = se.ServiceId
JOIN Programs p ON p.ProgramId = s.ProgramId
WHERE se.ErrorType IN (
		4406
		,4407
		,4408
		,4409
		)
	AND s.DateOfService < @AuthBeginDate
	AND @TrilliumPlanId = (
		SELECT TOP 1 ccp.CoveragePlanId
		FROM ClientCoveragePlans ccp
		JOIN ClientCoverageHistory cch ON cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
		WHERE ccp.ClientId = s.ClientId
			AND Isnull(ccp.RecordDeleted, 'N') = 'N'
			AND s.DateOfService >= cch.StartDate
			AND (
				CAST(s.DateOfService AS DATE) <= cch.EndDate
				OR cch.EndDate IS NULL
				)
			AND cch.ServiceAreaId = p.ServiceAreaId
			AND Isnull(cch.RecordDeleted, 'N') = 'N'
		ORDER BY cch.COBOrder
		)

 
--
-- Switch authorization required errors to warnings for secondary payers
--	          

declare @NextClientCoveragePlanId int 
declare @ServiceErrorMessage varchar(100)

-- Find primary payer
exec ssp_PMGetNextBillablePayer @ClientId = @ClientId, @ServiceId = @ServiceId, @DateOfService = @StartDate, @ProcedureCodeId = @ProcedureCodeId, @ClinicianId = @ClinicianId, @ClientCoveragePlanId = null, @NextClientCoveragePlanId = @NextClientCoveragePlanId output    
 
select  @ServiceErrorMessage = 'for ' + cp.DisplayAs + '-' + isnull(ccp.InsuredId, '')
from    ClientCoveragePlans ccp
        join CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId
where   ccp.ClientCoveragePlanId = @NextClientCoveragePlanId
 
-- Switch all authorization required errors not related to the primary payer to warnings
update  se
set     se.ErrorSeverity = 'W'
from    dbo.ServiceErrors se
where   se.ServiceId = @ServiceId
        and se.ErrorType in (4406, 4407)
        and se.ErrorMessage not like '%' + @ServiceErrorMessage + '%'


return 0

go

