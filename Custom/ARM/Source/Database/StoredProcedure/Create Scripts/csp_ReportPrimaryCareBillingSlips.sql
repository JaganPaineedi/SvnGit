/****** Object:  StoredProcedure [dbo].[csp_ReportPrimaryCareBillingSlips]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportPrimaryCareBillingSlips]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportPrimaryCareBillingSlips]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportPrimaryCareBillingSlips]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_ReportPrimaryCareBillingSlips]
/*********************************************************************/
/* Stored Procedure: dbo.csp_ReportPrimaryCareBillingSlips			*/
/* Creation Date:    7/21/11                                        */
/*                                                                   */
/* Purpose:           */
/*                                                                   */
/* Input Parameters:												*/
/*		@StartDate - start date for service selection				                               */
/*		@EndDate -	end date for service selection				                                   */
/*		@StaffId -	null for all staff or a value for individual.				                   */
/*		@ClientId - null for all clients or a value for one client.			                       */
/*		@LocationId - Can be used to limit results to a single location.			               */
/*		@ProgramId - Currently, there is only one PC program.  May be more in the future.		   */
/*                                                                   */
/* Output Parameters:                                                */
/*                                                                   */
/* Return Status:                                                    */
/*                                                                   */
/* Called By:       */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/* Updates:                                                          */
/*   Date     Author       Purpose                                    */
/* 07/21/12   T. Remisoski	  Created                                    */
/*********************************************************************/
	@StartDate datetime,
	@EndDate datetime,
	@StaffId int = null,
	@ClientId int = null,
	-- including the following 2 parameters so Harbor can expand to other areas as needed without rewriting the proc
	@LocationId int = null,
	@ProgramId int = null	-- Primary care
as
--set transaction isolation level read uncommitted
begin try

if @ProgramId is null set @ProgramId = 33	-- Primary care

declare @results table (
	ServiceId int,
	ClientId int,
	ClientName varchar(250),
	ClientBalance money,
	ClientHomePhone varchar(30),
	ClientDOB datetime,
	AuthStartDate datetime,
	AuthEndDate datetime,
	AuthTotalUnits decimal(10,2),
	AuthUsedUnits decimal(10,2),
	AuthPendingUnits decimal(10,2),
	DateOfService datetime,
	ClinicianName varchar(250),
	CoverageList varchar(MAX),
	IntakeMessage varchar(100),
	DiagnosisDocVersion int,
	ICDCode01 varchar(6),
	ICDDesc01 varchar(1000),
	ICDCode02 varchar(6),
	ICDDesc02 varchar(1000),
	ICDCode03 varchar(6),
	ICDDesc03 varchar(1000),
	ICDCode04 varchar(6),
	ICDDesc04 varchar(1000),
	ICDCode05 varchar(6),
	ICDDesc05 varchar(1000),
	ICDCode06 varchar(6),
	ICDDesc06 varchar(1000),
	ICDCode07 varchar(6),
	ICDDesc07 varchar(1000),
	ICDCode08 varchar(6),
	ICDDesc08 varchar(1000)
)
-- Find all scheduled appointments in the primary care program that fall between the given dates
insert into @results
        (
         ServiceId,
         ClientId,
         ClientName,
         ClientBalance,
         ClientDOB,
         DateOfService,
         ClinicianName
        )
select s.ServiceId,
s.ClientId, 
ISNULL(c.FirstName, '''') + '' '' + ISNULL(c.LastName, ''''),
c.CurrentBalance,
c.DOB,
s.DateOfService,
ISNULL(st.FirstName, '''') + '' '' + ISNULL(st.LastName, '''')
from dbo.Services as s
join dbo.Clients as c on c.ClientId = s.ClientId
join dbo.Staff as st on st.StaffId = s.ClinicianId
where s.ProgramId = @ProgramId
and DATEDIFF(DAY, s.DateOfService, @StartDate) <= 0
and DATEDIFF(DAY, s.DateOfService, @endDate) >= 0
and s.Status in (70, 71)	-- scheduled, show
and ((s.ClinicianId = @StaffId) or (@StaffId is null))
and ((s.ClientId = @ClientId) or (@ClientId is null))
and ((s.LocationId = @LocationId) or (@LocationId is null))
and ISNULL(s.RecordDeleted, ''N'') <> ''Y''
and ISNULL(c.RecordDeleted, ''N'') <> ''Y''
and ISNULL(st.RecordDeleted, ''N'') <> ''Y''
-- let''s try to have reporting services sort the results...

update r set 
	IntakeMessage = ''***** NEW INTAKE PAPERWORK REQUIRED *****''
from @results as r
where not exists (
	select *
	from dbo.Services as s
	where s.ClientId = r.ClientId
	and s.ProgramId = @ProgramId
	and s.Status in (71,75)	-- show, complete
	and DATEDIFF(DAY, s.DateOfService, r.DateOfService) between 1 and 365
	and ISNULL(s.RecordDeleted, ''N'') <> ''Y''
)
-- get the first home phone number
update r set
	ClientHomePhone = cp.PhoneNumber
from @results as r
join dbo.ClientPhones as cp on cp.ClientId = r.ClientId
where cp.PhoneType in (30, 32)
and ISNULL(cp.DoNotContact, ''N'') <> ''Y''
and ISNULL(cp.RecordDeleted, ''N'') <> ''Y''
and not exists (
	select *
	from dbo.ClientPhones as cp2
	where cp2.ClientId = cp.ClientId
	and cp2.PhoneType in (30,32)
	and ISNULL(cp2.DoNotContact, ''N'') <> ''Y''
	and ((cp2.PhoneType < cp.PhoneType)
		or (cp2.PhoneType = cp.PhoneType and cp2.ClientPhoneId < cp.ClientPhoneId)
	)
	and ISNULL(cp2.RecordDeleted, ''N'') <> ''Y''
)

-- get current coverage information
;with cteCov (ClientId, CoveragePlans, PlanLevel) as
(
	select r.ClientId, CAST(cp.CoveragePlanName as varchar(MAX)), cch.COBOrder
	from @results as r
	join dbo.ClientCoveragePlans as ccp on ccp.ClientId = r.ClientId
	join dbo.CoveragePlans as cp on cp.CoveragePlanId = ccp.CoveragePlanId
	join dbo.CoveragePlanServiceAreas as ccpsa on ccpsa.CoveragePlanId = ccp.CoveragePlanId
	join dbo.ClientCoverageHistory as cch on cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
	where DATEDIFF(DAY, cch.StartDate, r.DateOfService) >= 0
	and ((DATEDIFF(DAY, cch.EndDate, r.DateOfService) <= 0) or (cch.EndDate is null))
	and cch.COBOrder = 1
	and ccpsa.ServiceAreaId = 4	-- Other
	and ISNULL(ccp.RecordDeleted, ''N'') <> ''Y''
	and ISNULL(cp.RecordDeleted, ''N'') <> ''Y''
	and ISNULL(cch.RecordDeleted, ''N'') <> ''Y''
	union all
	select r.ClientId, cte.CoveragePlans + '', '' + CAST(cp.CoveragePlanName as varchar(MAX)), cch.COBOrder
	from @results as r
	join dbo.ClientCoveragePlans as ccp on ccp.ClientId = r.ClientId
	join dbo.CoveragePlans as cp on cp.CoveragePlanId = ccp.CoveragePlanId
	join dbo.ClientCoverageHistory as cch on cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
	join dbo.CoveragePlanServiceAreas as ccpsa on ccpsa.CoveragePlanId = ccp.CoveragePlanId
	join cteCov as cte on cte.ClientId = r.ClientId and cte.PlanLevel < cch.COBOrder
	where DATEDIFF(DAY, cch.StartDate, r.DateOfService) >= 0
	and ((DATEDIFF(DAY, cch.EndDate, r.DateOfService) <= 0) or (cch.EndDate is null))
	and cch.COBOrder > 1
	and ccpsa.ServiceAreaId = 4	-- Other
	and ISNULL(ccp.RecordDeleted, ''N'') <> ''Y''
	and ISNULL(cp.RecordDeleted, ''N'') <> ''Y''
	and ISNULL(cch.RecordDeleted, ''N'') <> ''Y''
)
update r set
	CoverageList = z.CoveragePlans
from @results as r
join (
	select ClientId, CoveragePlans, ROW_NUMBER() over(partition by ClientId order by PlanLevel desc) as MaxPlanLevel
	from cteCov
) as z on z.ClientId = r.ClientId and z.MaxPlanLevel = 1

-- get diagnosis info
update r set
	DiagnosisDocVersion = d.CurrentDocumentVersionId
from @results as r
join dbo.Documents as d on d.ClientId = r.ClientId
where d.DocumentCodeId = 5
and d.Status = 22
and not exists (
	select *
	from dbo.Documents as d2
	where d2.ClientId = d.ClientId
	and d.Status = 22
	and d2.DocumentCodeId = d.DocumentCodeId
	and ((d2.EffectiveDate > d.EffectiveDate)
		or (d2.EffectiveDate = d.EffectiveDate and d2.DocumentId > d.DocumentId)
	)
	and ISNULL(d2.RecordDeleted, ''N'') <> ''Y''
)
and ISNULL(d.RecordDeleted, ''N'') <> ''Y''

;with cteDx (ClientId, ServiceId, ICDCode, ICDDescription, ICDOrder) as
(
	select r.ClientId, r.ServiceId, dx.ICDCode, icd.ICDDescription, ROW_NUMBER() over (partition by r.ServiceId, r.ClientId order by dx.ICDCode) as ICDOrder
	from @results as r
	join dbo.DiagnosesIIICodes as dx on dx.DocumentVersionId = r.DiagnosisDocVersion
	join dbo.DiagnosisICDCodes as icd on icd.ICDCode = dx.ICDCode
	where ISNULL(dx.RecordDeleted, ''N'') <> ''Y''
)
update r set
	ICDCode01 = dxe.ICDCode,
	ICDDesc01 = dxe.ICDDescription,
	ICDCode02 = dxe2.ICDCode,
	ICDDesc02 = dxe2.ICDDescription,
	ICDCode03 = dxe3.ICDCode,
	ICDDesc03 = dxe3.ICDDescription,
	ICDCode04 = dxe4.ICDCode,
	ICDDesc04 = dxe4.ICDDescription,
	ICDCode05 = dxe5.ICDCode,
	ICDDesc05 = dxe5.ICDDescription,
	ICDCode06 = dxe6.ICDCode,
	ICDDesc06 = dxe6.ICDDescription,
	ICDCode07 = dxe7.ICDCode,
	ICDDesc07 = dxe7.ICDDescription,
	ICDCode08 = dxe8.ICDCode,
	ICDDesc08 = dxe8.ICDDescription
from @results as r
LEFT join cteDx as dxe on dxe.ClientId = r.clientid and dxe.ServiceId = r.ServiceId and dxe.ICDOrder = 1
LEFT join cteDx as dxe2 on dxe2.ClientId = r.clientid and dxe2.ServiceId = r.ServiceId and dxe2.ICDOrder = 2
LEFT join cteDx as dxe3 on dxe3.ClientId = r.clientid and dxe3.ServiceId = r.ServiceId and dxe3.ICDOrder = 3
LEFT join cteDx as dxe4 on dxe4.ClientId = r.clientid and dxe4.ServiceId = r.ServiceId and dxe4.ICDOrder = 4
LEFT join cteDx as dxe5 on dxe5.ClientId = r.clientid and dxe5.ServiceId = r.ServiceId and dxe5.ICDOrder = 5
LEFT join cteDx as dxe6 on dxe6.ClientId = r.clientid and dxe6.ServiceId = r.ServiceId and dxe6.ICDOrder = 6
LEFT join cteDx as dxe7 on dxe7.ClientId = r.clientid and dxe7.ServiceId = r.ServiceId and dxe7.ICDOrder = 7
LEFT join cteDx as dxe8 on dxe8.ClientId = r.clientid and dxe8.ServiceId = r.ServiceId and dxe8.ICDOrder = 8

-- finally, authorizations
update r set
	AuthStartDate = auth.StartDate,
	AuthEndDate = auth.EndDate,
	AuthTotalUnits = auth.TotalUnits,
	AuthUsedUnits = auth.UnitsUsed,
	AuthPendingUnits = auth.TotalUnits - ISNULL(auth.UnitsUsed, 0.0)
from @results as r
join (
	select top 1 szAuth.ServiceId, szAuth.AuthorizationId
	from dbo.ServiceAuthorizations as szAuth
	join @results as r2 on r2.ServiceId = szAuth.ServiceId
) as sAuth on sAuth.ServiceId = r.serviceId
join dbo.Authorizations as auth on auth.AuthorizationId = sAuth.AuthorizationId

select * from @results

end try
begin catch
if @@TRANCOUNT > 0 rollback tran
declare @error_message nvarchar(4000)
set @error_message = ERROR_MESSAGE()
raiserror (@error_message, 16, 1)
end catch


' 
END
GO
