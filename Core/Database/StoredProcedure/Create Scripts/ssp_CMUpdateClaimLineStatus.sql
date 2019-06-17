if object_id('dbo.ssp_CMUpdateClaimLineStatus') is not null
  drop procedure dbo.ssp_CMUpdateClaimLineStatus
go
 
create  procedure dbo.ssp_CMUpdateClaimLineStatus
  @ClaimLineId int,
  @Status int,
  @ActivityId int,
  @UserCode varchar(30)
/*********************************************************************                   
-- Stored Procedure: dbo.ssp_UpdateClaimLineStatus                    
--  Creation Date:  07/03/2006               
--                   
-- Purpose: update claimLine Status, Insert Record in ClaimLineHistory table & Recalculate & update TotalCharge, BalanceDue in case Status is Void                  
--             
--  Updates:                     
--   Date        Author      Purpose                     
--  10/10/2014   Shruthi.S   Pulled it from 3.5x and modified it to suit SC 4.0x also changed ActivityUserId to ActivitySatffId.Ref #25 CM to SC.  
--  10.28.2017   SFarber     Added code to void add-on claim lines.                
*********************************************************************/
as
declare @GCActivity int = 2010 -- Void
declare @ClaimLineCharge money    
declare @UserId int 
declare @ClaimId int

create table #ClaimLines (ClaimLineId int)

begin try
    
  begin tran    
   
  -- Get UserId of the User     
  select top 1
          @UserId = StaffId
  from    Staff
  where   UserCode = @UserCode
          and isnull(RecordDeleted, 'N') = 'N' -- Code Added by Dinesh    
    
  select  @ClaimId = ClaimId
  from    ClaimLines
  where   ClaimLineId = @ClaimLineId

  insert  into #ClaimLines
          (ClaimLineId)
  values  (@ClaimLineId)

  -- Update status of ClaimLine    
  -- changed on 07/04/2006 as per David comments (set NeedsToBeWorked, ToReadjudicate & DoNotAdjudicate to 'N' in case ClaimLineStatus is set to Void)    
  if @GCActivity = @ActivityId  -- Void activity
    begin 
	  -- Void Add-On claim lines 
      insert  into #ClaimLines
              (ClaimLineId)
      select  cla.ClaimLineId
      from    dbo.ssf_GetAddOnClaimLines(@ClaimLineId) cla
	          join ClaimLines cl on cl.ClaimLineId = cla.ClaimLineId
			  join Claims c on c.ClaimId = cl.ClaimId
      where   cl.Status in (2021, 2022) -- Entry Incomplete, Entry Complete
              and exists ( select *
                           from   AdjudicationRules ar
                           where  ar.RuleTypeId in (2586, 2587) -- void only if Add-On rules are active
                                  and ar.Active = 'Y'
                                  and (ar.StartDate <= getdate()
                                       or ar.StartDate is null)
                                  and (dateadd(dd, 1, ar.EndDate) > getdate()
                                       or ar.EndDate is null)
                                  and isnull(ar.RecordDeleted, 'N') = 'N'
                                  and (ar.AllInsurers = 'Y'
                                       or exists ( select *
                                                   from   AdjudicationRuleInsurers ari
                                                   where  ari.AdjudicationRuleId = ar.AdjudicationRuleId
                                                          and ari.InsurerId = c.InsurerId
                                                          and isnull(ari.RecordDeleted, 'N') = 'N' )) )
	    
      update  cl
      set     Status = @Status,
              DoNotAdjudicate = 'N',
              NeedsToBeWorked = 'N',
              ToReadjudicate = 'N',
              ModifiedBy = @UserCode,
              ModifiedDate = getdate()
      from    #ClaimLines clv
              join ClaimLines cl on cl.ClaimLineId = clv.ClaimLineId
  
    end    
  else
    begin     
      update  ClaimLines
      set     Status = @Status,
              ModifiedBy = @UserCode,
              ModifiedDate = getdate()
      where   ClaimLineId = @ClaimLineId
    end    
     
  -- Insert Row into ClaimLineHistory    
  insert  into ClaimLineHistory
          (ClaimLineId,
           Activity,
           ActivityDate,
           Status,
           ActivityStaffId,
           CreatedBy,
           CreatedDate,
           ModifiedBy,
           ModifiedDate)
  select  cl.ClaimLineId,
          @ActivityId,
          getdate(),
          @Status,
          @UserId,
          @UserCode,
          getdate(),
          @UserCode,
          getdate()
  from    #ClaimLines cl
    
  -- Recalculate TotalCharge, BalanceDue & Update it in Claims table in case Activity is Void    
  if @GCActivity = @ActivityId
    begin    
      select  @ClaimLineCharge = sum(cl.Charge)
      from    #ClaimLines clv
              join ClaimLines cl on cl.ClaimLineId = clv.ClaimLineId
    
    
      update  Claims
      set     TotalCharge = TotalCharge - @ClaimLineCharge,
              BalanceDue = case when AmountPaid > 0
                                     or AmountPaid is not null then (TotalCharge - @ClaimLineCharge) - AmountPaid
                                else BalanceDue
                           end
      where   ClaimId = @ClaimId    
    
    
    end    
    
  commit tran    

  return(0)    

end try
begin catch

  if @@trancount > 0
    rollback tran

  declare @ErrorMessage varchar(max)
  declare @ErrorNumber int
  declare @ErrorSeverity int
  declare @ErrorState int
  declare @ErrorLine int
  declare @ErrorProcedure varchar(200)

  select  @ErrorNumber = error_number(),
          @ErrorSeverity = error_severity(),
          @ErrorState = error_state(),
          @ErrorLine = error_line(),
          @ErrorProcedure = isnull(error_procedure(), '-')

  select  @ErrorMessage = 'Error %d, Level %d, State %d, Procedure %s, Line %d, ' + 'Message: ' + error_message()
 
  raiserror(@ErrorMessage, @ErrorSeverity, 1, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine)

  return(1)

end catch

go
