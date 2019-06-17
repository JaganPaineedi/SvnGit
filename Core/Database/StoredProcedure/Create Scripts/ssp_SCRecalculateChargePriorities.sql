if object_id('dbo.ssp_SCRecalculateChargePriorities') is not null 
  drop procedure dbo.ssp_SCRecalculateChargePriorities
go

create procedure dbo.ssp_SCRecalculateChargePriorities
  @ServiceId int,
  @UserCode varchar(30)
/*********************************************************************                
-- Stored Procedure: dbo.ssp_SCRecalculateChargePriorities                
--                
-- Copyright: Streamline Healthcare Solutions                
--                
-- Purpose: Recalculates charge priorities for the service                
--                
-- Updates:                 
--  Date         Author    Purpose                
-- 09.03.2015    SFarber   Created.             
-- 08.04.2016	 Dknewtson Modified rule from "If Charge Amount <= 0 [...] move charge to the end of the queue" to "If certain Charge error(s) exists [...]"
-- 01.18.2018	 Dknewtson Implementing recode for charge errors
-- 10.04.2018	 mraymond  Added new recode for Charge Errors that need to keep same priority: 
**********************************************************************/
as 
declare @ServiceAreaId int
declare @DateOfService datetime

select  @ServiceAreaId = p.ServiceAreaId,
        @DateOfService = s.DateOfService
from    Services s
        join Programs p on p.ProgramId = s.ProgramId
where   s.ServiceId = @ServiceId;

-- Calculate charge priorities based on coverage COB order
-- If Charge error of certain types exist or coverage is not in the history anymore, move charge to the end of the queue
with  CTE_COBOrders
        as (select  c.ChargeId,
                    case when max(cch.COBOrder) > 0 then case WHEN NOT EXISTS (SELECT 1 
																				 FROM dbo.ChargeErrors AS ce 
																					JOIN dbo.ssf_RecodeValuesCurrent('CascadePayerChargeErrors') AS rel ON ce.ErrorType = rel.IntegerCodeId
																				 WHERE ce.ChargeId = c.ChargeId
																				 AND ce.ErrorType NOT IN (SELECT IntegerCodeId FROM Recodes R
																										  JOIN RecodeCategories RC on RC.RecodeCategoryId = R.RecodeCategoryId 
																										  WHERE RC.CategoryCode = 'CascadePayerChargeErrorsKeepPriority')
																			  ) then max(cch.COBOrder)
                                                              else 1000 + max(cch.COBOrder)
                                                         end
                         else 2000 + max(c.priority)
                    end as COBOrder
            from    Services s
                    join Charges c on c.ServiceId = s.ServiceId
                    --join dbo.ARLedger a on a.ChargeId = c.ChargeId
                    join dbo.ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = c.ClientCoveragePlanId
                    left join ClientCoverageHistory cch on cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
                                                           and cch.ServiceAreaId = @ServiceAreaId
                                                           and cch.StartDate <= @DateOfService
                                                           and (cch.EndDate is null
                                                                or dateadd(day, 1, cch.EndDate) > @DateOfService)
                                                           and isnull(cch.RecordDeleted, 'N') = 'N'
            where   s.ServiceId = @ServiceId
                    --and a.LedgerType in (4201, 4204)
                    and isnull(c.RecordDeleted, 'N') = 'N'
                    --and isnull(a.RecordDeleted, 'N') = 'N'
            group by c.ChargeId),
      CTE_Priorities
        as (select  ChargeId,
                    row_number() over (order by COBOrder) as Priority
            from    CTE_COBOrders)
  update  c
  set     Priority = cp.Priority,
          ModifiedBy = @UserCode,
          ModifiedDate = getdate()
  from    Charges c
          join CTE_Priorities cp on cp.ChargeId = c.ChargeId
  where   c.Priority <> cp.priority
    
return

go
