if object_id('dbo.ssp_SetChargeReadyToBill') is not null
  drop procedure dbo.ssp_SetChargeReadyToBill
go
  
create procedure dbo.ssp_SetChargeReadyToBill
  @CurrentUser varchar(30), 
  @ProcessOnlyNewCharges char(1) = 'N'
/*********************************************************************  
-- Stored Procedure: dbo.ssp_SetChargeReadyToBill  
--  
-- Copyright: Streamline Healthcare Solutions  
-- Creation Date:  10.06.2006  
--  
-- Purpose: Sets ReadyToBill flag for charges  
--  
-- Data Modifications:  
--  
-- Updates:   
--  Date         Author       Purpose  
-- 10.06.2006    SFarber      Created.  
-- 12.08.2006    SFarber      Modified to cascade the charge.  
-- 07.09.2012    vishant      Implemented message code functionality
-- 06.21.2013    SFarber      Added call to scsp_SetChargeReadyToBill
-- 08.29.2015    SFarber      Added code to cascade for 4560 - Non-billable primary diagnosis code
-- 11.25.2015    SFarber      Added @ProcessOnlyNewCharges argument
-- 01.18.2018	 Dknewtson    Implementing cascade charge error recode.
**********************************************************************/
as 
set nocount on
  
declare @ErrorNo int  
declare @ErrorMessage varchar(max) 
declare @ChargeId int
declare @Balance money
declare @CurrentDate datetime
declare @ReadyToBillFailed char(1)

declare @ReadyToBillBatchId int
  
create table #Errors (
ErrorType int null,
ErrorDescription varchar(1000) null)  
  
create table #Charges (
ChargeId int not null,
Balance money null)  

set @CurrentDate = getdate()

insert  into ReadyToBillBatches
        (RunDate,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate)
values  (convert(datetime, convert(varchar, @CurrentDate, 101)),
         @CurrentUser,
         @CurrentDate,
         @CurrentUser,
         @CurrentDate) 

set @ReadyToBillBatchId = @@Identity

if @ReadyToBillBatchId < 0 
  begin
    select  @ErrorMessage = dbo.Ssf_GetMesageByMessageCode(29, 'INVALIDBILLBATCHID_SSP', 'Invalid Ready to Bill Batch Id')
    RAISERROR (@ErrorMessage,16,1)
    goto error
  end

-- Get all open charges with ReadyToBill not set  
insert  into #Charges
        (ChargeId,
         Balance)
        select  c.ChargeId,
                oc.Balance
        from    Charges c
                join OpenCharges oc on oc.ChargeId = c.ChargeId
        where   isnull(c.ReadyToBill, 'N') = 'N'
                and (isnull(@ProcessOnlyNewCharges, 'N') = 'N'
                     or (@ProcessOnlyNewCharges = 'Y'
                         and not exists ( select  *
                                          from    dbo.ChargeErrors ce
                                          where   ce.ChargeId = c.ChargeId )))
  
declare cur_ReadyToBill cursor for
select  ChargeId,
        Balance
from    #Charges
order by ChargeId

if @@error <> 0 
  goto error

open cur_ReadyToBill

if @@error <> 0 
  goto error

fetch cur_ReadyToBill into @ChargeId, @Balance  

if @@error <> 0 
  goto error

while @@fetch_status = 0 
  begin  
  
    delete  from #Errors  
  
    if @@error <> 0 
      goto error

    -- Check coverage plan rules  
    insert  into #Errors
            (ErrorType,
             ErrorDescription)
            exec dbo.ssp_CheckCoveragePlanRules 
              @ChargeId = @ChargeId  
  
    if @@error <> 0 
      begin  
        select  @ErrorNo = 50010,
                @ErrorMessage = dbo.Ssf_GetMesageByMessageCode(29, 'FAILEDEXC_ssp_CheckCoveragePlanRules_SSP', 'Failed to execute ssp_CheckCoveragePlanRules SP.')  
        goto error  
      end 

    if object_id('dbo.scsp_SetChargeReadyToBill', 'P') is not null
    begin  
      exec dbo.scsp_SetChargeReadyToBill @ChargeId = @ChargeId  

      if @@error <> 0 
        begin  
          select  @ErrorNo = 50015,
                  @ErrorMessage = 'Failed to execute scsp_SetChargeReadyToBill SP.'
          goto error  
        end 
    end
    
    if exists ( select  *
                from    #Errors ) 
      set @ReadyToBillFailed = 'Y' 
    else 
      set @ReadyToBillFailed = 'N'
  
    begin tran  

    if @ReadyToBillFailed = 'N' 
      begin
        insert  into ReadyToBillBatchCharges
                (ReadyToBillBatchId,
                 ChargeId,
                 Balance,
                 CreatedBy,
                 CreatedDate,
                 ModifiedBy,
                 ModifiedDate)
        values  (@ReadyToBillBatchId,
                 @ChargeId,
                 @Balance,
                 @CurrentUser,
                 @CurrentDate,
                 @CurrentUser,
                 @CurrentDate)

        if @@error <> 0 
          goto error
      end
			
    update  ReadyToBillBatches
    set     NumberOfCharges = isnull(NumberOfCharges, 0) + 1,
            TotalBalance = isnull(TotalBalance, 0) + isnull(@Balance, 0),
            ReadyToBillCharges = case when @ReadyToBillFailed = 'N' then isnull(ReadyToBillCharges, 0) + 1
                                      else ReadyToBillCharges
                                 end,
            ReadyToBillBalance = case when @ReadyToBillFailed = 'N' then isnull(ReadyToBillBalance, 0) + isnull(@Balance, 0)
                                      else ReadyToBillBalance
                                 end,
            ModifiedDate = getdate()
    where   ReadyToBillBatchId = @ReadyToBillBatchId

    if @@error <> 0 
      goto error

    -- Delete all previous errors  
    delete  from ChargeErrors
    where   ChargeId = @ChargeId  
  
    if @@error <> 0 
      begin  
        select  @ErrorNo = 50020,
                @ErrorMessage = dbo.Ssf_GetMesageByMessageCode(29, 'FAILUPDATECHARGEERRORS_SSP', 'Failed to update ChargeErrors.')  
        goto error  
      end  
  
    -- If any rule failed, insert into ChargeErrors else set ReadyToBill to 'Y'  
    if exists ( select  *
                from    #Errors ) 
      begin  
        insert  into ChargeErrors
                (ChargeId,
                 ErrorType,
                 ErrorDescription)
                select  @ChargeId,
                        ErrorType,
                        ErrorDescription
                from    #Errors  
  
        if @@error <> 0 
          begin  
            select  @ErrorNo = 50030,
                    @ErrorMessage = dbo.Ssf_GetMesageByMessageCode(29, 'FAILINSERTCHARGEERRORS_SSP', 'Failed to insert into ChargeErrors.')  
            goto error  
          end   
  
        --  
        -- Cases when a charge needs to be cascaded down to the next payer:  
        --  4554 - Not billable if previous payer is Medicare and it will deny the charge becaue of unauthorized clinician  
        --  4546 - These codes are not billable to this plan  
        --  4549 - Only these clinicians may provide billable services for these codes  
        --  4558 - Deductible met after service date   
	    --  4560 - Non-billable primary diagnosis code
        --  
        if exists ( select  *
                    from    #Errors ce
					JOIN dbo.ssf_RecodeValuesCurrent('CascadePayerChargeErrors') AS rel ON ce.ErrorType = rel.IntegerCodeId )
          and @Balance > 0 
          begin   
            exec ssp_PMTransferChargeToNextPayer @CurrentUser = @CurrentUser, @ChargeId = @ChargeId  
  
            if @@error <> 0 
              begin  
                select  @ErrorNo = 50040,
                        @ErrorMessage = dbo.Ssf_GetMesageByMessageCode(29, 'FAILEDEXC_ssp_PMTransferChargeToNextPayer_SSP', 'Failed to execute ssp_PMTransferChargeToNextPayer.')  
                goto error  
              end   

            insert  into ReadyToBillBatchCharges
                    (ReadyToBillBatchId,
                     ChargeId,
                     Balance,
                     ChargeTransferred,
                     CreatedBy,
                     CreatedDate,
                     ModifiedBy,
                     ModifiedDate)
            values  (@ReadyToBillBatchId,
                     @ChargeId,
                     @Balance,
                     'Y',
                     @CurrentUser,
                     @CurrentDate,
                     @CurrentUser,
                     @CurrentDate)

            if @@error <> 0 
              goto error

          end   
      end  
    else 
      begin  
        update  Charges
        set     ReadyToBill = 'Y',
                ModifiedBy = 'READYTOBILL',
                ModifiedDate = getdate()
        where   ChargeId = @ChargeId  
  
        if @@error <> 0 
          begin  
            select  @ErrorNo = 50050,
                    @ErrorMessage = dbo.Ssf_GetMesageByMessageCode(29, 'FAILUPDATECHARGES_SSP', 'Failed to update Charges.')  
            goto error  
          end   
      end  
  
    commit tran  
  
    fetch cur_ReadyToBill into @ChargeId, @Balance  

    if @@error <> 0 
      goto error

  end  

close cur_ReadyToBill

if @@error <> 0 
  goto error

deallocate cur_ReadyToBill
  
if @@error <> 0 
  goto error

return  
  
  
error:  
  
if @@trancount > 0 
  rollback tran  
  
RAISERROR (@ErrorNo,@ErrorMessage,1)

go
