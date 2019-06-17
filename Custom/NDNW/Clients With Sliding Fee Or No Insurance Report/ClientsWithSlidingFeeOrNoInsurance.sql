IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'csp_RDLClientSlidingFeeOrNoInsurance')
                    AND type IN ( N'P', N'PC' ) )
                    
                   BEGIN
                   DROP PROCEDURE csp_RDLClientSlidingFeeOrNoInsurance
                   END 
                   
                   go
                   
CREATE PROCEDURE csp_RDLClientSlidingFeeOrNoInsurance

AS 
begin

;with cteClientFees as (
select ccf.ClientId, ccf.StartDate, ccf.EndDate, ccf.StandardRatePercentage, ccf.Rate
from CustomClientFees as ccf
where isnull(ccf.RecordDeleted, 'N') = 'N'
),
cteClientsNoIns as (
	select *
	from Clients as c
	where not exists (
		select *
		from ClientCoveragePlans as ccp
		join ClientCoverageHistory as cch on cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
		where ccp.ClientId = c.ClientId
		and datediff(day, cch.StartDate, getdate()) >= 0
		and ((cch.EndDate is null) or (datediff(day, cch.EndDate, getdate()) <= 0))
		and isnull(ccp.RecordDeleted, 'N') = 'N'
		and isnull(cch.RecordDeleted, 'N') = 'N'
	)
),
cteClientsPrimaryEnrollment as (
	select c.ClientId, max(pg.ProgramName) as ProgramName
	from Clients as c
	join ClientPrograms as cp on cp.ClientId = c.ClientId
	join Programs as pg on pg.ProgramId = cp.ProgramId
	where cp.Status <> 5
	and cp.PrimaryAssignment = 'Y'
	and isnull(cp.RecordDeleted, 'N') = 'N'
	and isnull(c.RecordDeleted, 'N') = 'N'
	group by c.ClientId
),
cteLastDateOfService as (
	select ClientId, max(DateOfService) as DateOfService
	from Services
	where Status in (71, 75)
	and isnull(RecordDeleted, 'N') = 'N'
	group by ClientId
),
cteClientsFees2 as (
	select c.ClientId, c.LastName, c.FirstName, case when n.ClientId is null then 'Y' else 'N' end as HasCurrentInsurance, f.StartDate, f.EndDate, f.StandardRatePercentage, f.Rate
	from Clients as c
	join cteClientFees as f on f.ClientId = c.ClientId
	left join cteClientsNoIns as n on n.ClientId = c.ClientId
	where c.Active = 'Y'
	and isnull(c.RecordDeleted, 'N') = 'N'
	union
	select c.ClientId, c.LastName, c.FirstName, case when n.ClientId is null then 'Y' else 'N' end as HasCurrentInsurance, f.StartDate, f.EndDate, f.StandardRatePercentage, f.Rate
	from Clients as c
	join cteClientsNoIns as n on n.ClientId = c.ClientId
	left join cteClientFees as f on f.ClientId = c.ClientId
	where c.Active = 'Y'
	and isnull(c.RecordDeleted, 'N') = 'N'
)
select cf.ClientId,cf.LastName,cf.FirstName,cf.HasCurrentInsurance,cf.StartDate,cf.EndDate,cf.StandardRatePercentage,cf.Rate, e.ProgramName, dos.DateOfService as MostRecentShowCompleteService
from cteClientsFees2 as cf
left join cteClientsPrimaryEnrollment as e on e.ClientId = cf.ClientId
left join cteLastDateOfService as dos on dos.ClientId = cf.ClientId
--select * from ClientCoveragePlans where clientid = 184

END

GO