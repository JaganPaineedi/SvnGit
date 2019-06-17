if object_id('ssp_ReportServicesWithProcedureRateErrors', 'P') is not null
	drop procedure ssp_ReportServicesWithProcedureRateErrors
go

create procedure ssp_ReportServicesWithProcedureRateErrors
/*==============================================================================*/
/*																				*/
/* Procedure: ssp_ReportServicesWithProcedureRateErrors							*/
/*																				*/
/* Purpose: Display all show services that cannot be completed due to no		*/
/*			"No procedure rate found" errors.  For each service, show the		*/
/*			possible rates that might be used for the service along with all	*/
/*			of the matching and non-matching attributes.  This will guide users	*/
/*			to make corrections to existing rates or create new rates as		*/
/*			needed.																*/
/*																				*/
/* Parameters:																	*/
/*			@DateOfServiceStart - datetime - Include on services starting on or	*/
/*											after this date						*/
/*																				*/
/*																				*/
/*			@DateOfServiceEnd - datetime - Include on services starting on or	*/
/*											before this date					*/
/*																				*/
/* Revision History:															*/
/* 07-DEC-2015 - T.Remisoski - Created.											*/
/*																				*/
/*==============================================================================*/

	@DateOfServiceStart datetime,
	@DateOfServiceEnd datetime
as

select 
case when pr.ProcedureRateId is not null and (
		( 0 = (select count(*) from ProcedureRateStaff as prs where prs.ProcedureRateId = pr.ProcedureRateId and isnull(prs.RecordDeleted, 'N') = 'N') ) 
		or
		( 0 < (select count(*) from ProcedureRateStaff as prs where prs.ProcedureRateId = pr.ProcedureRateId and prs.StaffId = sv.ClinicianId and isnull(prs.RecordDeleted, 'N') = 'N') ) 
	) then 1 else 0 end as STaffMatch,
case when pr.ProcedureRateId is not null and (
		( 0 = (select count(*) from ProcedureRatePrograms as prs where prs.ProcedureRateId = pr.ProcedureRateId and isnull(prs.RecordDeleted, 'N') = 'N') ) 
		or
		( 0 < (select count(*) from ProcedureRatePrograms as prs where prs.ProcedureRateId = pr.ProcedureRateId and prs.ProgramId = sv.ProgramId and isnull(prs.RecordDeleted, 'N') = 'N') ) 
	) then 1 else 0 end as ProgramMatch,
case when pr.ProcedureRateId is not null and (
		( 0 = (select count(*) from ProcedureRateServiceAreas as prs where prs.ProcedureRateId = pr.ProcedureRateId and isnull(prs.RecordDeleted, 'N') = 'N') ) 
		or
		( 0 < (select count(*) from ProcedureRateServiceAreas as prs 
				join Programs as pg on pg.ServiceAreaId = prs.ServiceAreaId where prs.ProcedureRateId = pr.ProcedureRateId and pg.ProgramId = sv.ProgramId and isnull(prs.RecordDeleted, 'N') = 'N') ) 
	) then 1 else 0 end as ServiceAreaMatch,
case when pr.ProcedureRateId is not null and (
		( 0 = (select count(*) from ProcedureRateLocations as prs where prs.ProcedureRateId = pr.ProcedureRateId and isnull(prs.RecordDeleted, 'N') = 'N') ) 
		or
		( 0 < (select count(*) from ProcedureRateLocations as prs where prs.ProcedureRateId = pr.ProcedureRateId and prs.LocationId = sv.LocationId and isnull(prs.RecordDeleted, 'N') = 'N') ) 
	) then 1 else 0 end as LocationMatch,
case when pr.ProcedureRateId is not null and (
		( 0 = (select count(*) from ProcedureRateDegrees as prs where prs.ProcedureRateId = pr.ProcedureRateId and isnull(prs.RecordDeleted, 'N') = 'N') ) 
		or
		( 0 < (select count(*) from ProcedureRateDegrees as prs 
							   join Staff as st on st.Degree = prs.Degree where prs.ProcedureRateId = pr.ProcedureRateId and st.StaffId = sv.ClinicianId and isnull(prs.RecordDeleted, 'N') = 'N') ) 
	) then 1 else 0 end as DegreeMatch,
case when pr.ProcedureRateId is not null and (
		( 0 = (select count(*) from ProcedureRatePlacesOfServices as prs where prs.ProcedureRateId = pr.ProcedureRateId and isnull(prs.RecordDeleted, 'N') = 'N') ) 
		or
		( 0 < (select count(*) from ProcedureRatePlacesOfServices as prs 
							   join Locations as l on l.PlaceOfService = prs.PlaceOfServieId where prs.ProcedureRateId = pr.ProcedureRateId and l.LocationId = sv.LocationId and isnull(prs.RecordDeleted, 'N') = 'N') ) 
	) then 1 else 0 end as PlaceOfServiceMatch,

sv.ClientId,
sv.ServiceId,
sv.DateOfService, pc.DisplayAs as ProcedureCode, 
pg.ProgramCode,
l.LocationName,
st.LastName + ', ' + st.FirstName as ClinicianName,
sv.Unit,
case when pr.ProcedureRateId is not null then 'Candidate Rate Found' else 'No rates found.  Check Service Date and Units' end as ProcedureRateStatus,
pr.FromDate as PRFromDate, pr.ToDate as PRToDate, pr.Amount as Charge, dbo.ssf_GetGlobalCodeNameById(pr.ChargeType) as PRChargeType,
pr.FromUnit, pr.ToUnit,
isnull(pr.BillingCode, '') + isnull('-' + pr.Modifier1, '') + isnull(':' + pr.Modifier2, '') + isnull(':' + pr.Modifier3, '') + isnull(':' + pr.Modifier4, '') as BillingCode
from Services as sv
join ProcedureCodes as pc on pc.ProcedureCodeId = sv.ProcedureCodeId
join Programs as pg on pg.ProgramId = sv.ProgramId
join Locations as l on l.LocationId = sv.LocationId
join ServiceAreas as sar on sar.ServiceAreaId = pg.ServiceAreaId
join GlobalCodes as gcp on gcp.GlobalCodeId = l.PlaceOfService
join Staff as st on st.StaffId = sv.ClinicianId
join ServiceErrors as se on se.ServiceId = sv.ServiceId and se.ErrorMessage = 'Unable to find a matching rate for the selected procedure.'
left join ProcedureRates as pr on pr.ProcedureCodeId = sv.ProcedureCodeId
	and sv.DateOfService >= pr.FromDate
	and pr.CoveragePlanId is null
	and ( (pr.ToDate is null) or (sv.DateOfService <= pr.ToDate) )
	and sv.Unit >= pr.FromUnit
	and ((pr.ToUnit is null) or (sv.Unit <= pr.ToUnit))
	and isnull(pr.RecordDeleted, 'N') = 'N'
where sv.Status = 71
and datediff(day, @DateOfServiceStart, sv.DateOfService) >= 0
and datediff(day, @DateOfServiceEnd, sv.DateOfService) <= 0
and isnull(sv.RecordDeleted, 'N') = 'N'

go

--exec ssp_ReportServicesWithProcedureRateErrors '10/1/2013', '10/24/2015'
go
