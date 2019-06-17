if object_id('dbo.ssp_CMDenyClaimLines') is not null 
  drop procedure dbo.ssp_CMDenyClaimLines
go

create procedure dbo.ssp_CMDenyClaimLines
  @ClaimLineId int,
  @UserId int,
  @UserCode varchar(30),
  @DenialReason type_GlobalCode,
  @DenyReasonText varchar(250),
  @CurrentStatus int         
/*********************************************************************                          
-- Stored Procedure: dbo.ssp_CMDenyClaimLines                
-- Copyright: 2005 Provider Claim Management System                
-- Creation Date:  30/10/2008                                      
--                                                                 
-- Purpose: it will deny the Claim Line whose claim line has been passed                
--                                                                                                  
-- Input Parameters:                                    
--                                                                    
-- Modified Date   Modified By       Purpose                
-- 30/10/2008      Sonia Dhamija     Created with reference to Task #1603 as in case claimline is denied record needs to be inserted into ClaimLineDenials              
-- 05.13.2016      SFarber           Added claim bundle logic
-- 05.04.2018      SFarber           Modified to update LastAdjudicationId and LastAdjudicationDate
-- 09.07.2018      SFarber           Modified to update OverridePendedReason
****************************************************************************/
as
 
create table #ClaimLines (
ClaimLineId int,
ClaimedAmount money,
UnitsClaimed decimal(18, 2))

create table #NewAdjudications (
AdjudicationId int,
ClaimLineId int,
CreatedDate datetime)

declare @Status int        
declare @DenialStatus int 
declare @EntryCompleteStatus int
declare @PendedStatus int
declare @ClaimBundleId int
declare @ClaimLineIdDenial int
declare @ClaimLineActivityDeny int
declare @AdjudicationId int
      
set @DenialStatus = 2024 
set @EntryCompleteStatus = 2022 
set @PendedStatus = 2027
set @ClaimLineActivityDeny = 2009      
 
begin try     

  -- Checking Change in the status of claim line if any change raise custom error for concurrency
  select  @Status = cl.Status
  from    ClaimLines cl
  where   cl.ClaimLineId = @ClaimLineId
          and isnull(cl.RecordDeleted, 'N') = 'N'
      
  if @CurrentStatus <> isnull(@Status, -1) 
    begin   
      raiserror ('Claim line has been modified by another user', 16, 1);     
    end 

  -- Determine if claim line is a bundle claim line
  select top 1
          @ClaimBundleId = clb.ClaimBundleId
  from    ClaimLines cl
          join ssv_ClaimLineBundles clb on clb.BundleClaimLineId = cl.ClaimLineId
  where   cl.ClaimLineId = @ClaimLineId
          and clb.ClaimType = 'Bundle'          
 
  insert  into #ClaimLines
          (ClaimLineId,
           ClaimedAmount,
           UnitsClaimed)
		  -- Claim line that is being processed
          select  cl.ClaimLineId,
                  cl.ClaimedAmount,
                  cl.Units
          from    ClaimLines cl
          where   cl.ClaimLineId = @ClaimLineId
          union 
          -- Add all activity claim lines if the claim line is a bundle 
          select  cl.ClaimLineId,
                  cl.ClaimedAmount,
                  cl.Units
          from    ssv_ClaimLineBundles b
                  join ClaimLines cl on cl.ClaimLineId = b.ActivityClaimLineId
          where   b.ClaimBundleId = @ClaimBundleId
                  and cl.Status in (@EntryCompleteStatus, @PendedStatus)
                  and b.ClaimType = 'Activity'

  -- Updating claim line status
  update  cl
  set     Status = @DenialStatus,
          DenialReason = @DenialReason,
		  OverridePendedReason = 'N',
          ModifiedBy = @UserCode,
          ModifiedDate = getdate()
  from    #ClaimLines dcl
          join ClaimLines cl on cl.ClaimLineId = dcl.ClaimLineId
        
  -- Adjudication       
  insert  into Adjudications
          (ClaimLineId,
           Status,
           ClaimedAmount,
           UnitsClaimed,
           DeniedAmount,
           DenialReason,
           UnitsDenied,
           ClaimBundleId,
           CreatedBy,
           CreatedDate,
           ModifiedBy,
           ModifiedDate)
  output  inserted.AdjudicationId,
          inserted.ClaimLineId,
		  inserted.CreatedDate
          into #NewAdjudications (AdjudicationId, ClaimLineId, CreatedDate)
          select  cl.ClaimLineId,
                  @DenialStatus,
                  cl.ClaimedAmount,
                  cl.UnitsClaimed,
                  cl.ClaimedAmount,
                  @DenialReason,
                  cl.UnitsClaimed,
                  @ClaimBundleId,
                  @UserCode,
                  getdate(),
                  @UserCode,
                  getdate()
          from    #ClaimLines cl        

  select  @AdjudicationId = na.AdjudicationId
  from    #NewAdjudications na
  where   na.ClaimLineId = @ClaimLineId

  update  a
  set     BundleAdjudicationId = @AdjudicationId
  from    #NewAdjudications na
          join Adjudications a on a.AdjudicationId = na.AdjudicationId
  where   na.ClaimLineId <> @ClaimLineId

  update  cl
  set     LastAdjudicationId = na.AdjudicationId,
          LastAdjudicationDate = na.CreatedDate
  from    ClaimLines cl
          join #NewAdjudications na on na.ClaimLineId = cl.ClaimLineId
	     
  -- Claim line history        
  insert  into ClaimLineHistory
          (ClaimLineId,
           Activity,
           ActivityDate,
           Status,
           ActivityStaffId,
           ClaimLinePaymentId,
           ClaimLineCreditId,
           AdjudicationId,
           Reason,
           CreatedBy,
           CreatedDate,
           ModifiedBy,
           ModifiedDate)
          select  na.ClaimLineId,
                  @ClaimLineActivityDeny,
                  na.CreatedDate,
                  @DenialStatus,
                  @UserId,
                  null,
                  null,
                  na.AdjudicationId,
                  @DenyReasonText,
                  @UserCode,
                  getdate(),
                  @UserCode,
                  getdate()
          from    #NewAdjudications na
        
  -- Open claims
  delete  oc
  from    #ClaimLines dcl
          join ClaimLines cl on cl.ClaimLineId = dcl.ClaimLineId
          join OpenClaims oc on oc.ClaimLineId = dcl.ClaimLineId
  where   not (cl.ToReAdjudicate = 'Y'
               or cl.NeedsToBeWorked = 'Y')

  -- Handle claim line denials  
  declare cur_ClaimLineDenials cursor
  for
  select  ClaimLineId
  from    #ClaimLines 

  open cur_ClaimLineDenials 
  fetch cur_ClaimLineDenials into @ClaimLineIdDenial 

  while @@fetch_status = 0 
    begin

      exec ssp_CMAdjudicateClaimLineDenials 
        @ClaimLineId = @ClaimLineIdDenial,
        @UserCode = @UserCode

      fetch cur_ClaimLineDenials into @ClaimLineIdDenial 

    end 
  
  close cur_ClaimLineDenials
  deallocate cur_ClaimLineDenials
	    	          

                
end try        
begin catch                                 
  declare @Error varchar(8000)                                  
  set @Error = convert(varchar, error_number()) + '*****' + convert(varchar(4000), error_message()) + '*****' + isnull(convert(varchar, error_procedure()), '[ssp_CMDenyClaimLines]') + '*****' + convert(varchar, error_line()) + '*****' + convert(varchar, error_severity()) + '*****' + convert(varchar, error_state())                                  
                      
  raiserror(@Error, 16, 1);                                  
                                  
end catch      
    
     
 go


