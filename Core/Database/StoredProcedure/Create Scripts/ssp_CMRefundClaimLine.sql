if object_id('dbo.ssp_CMRefundClaimLine') is not null 
  drop procedure dbo.ssp_CMRefundClaimLine
go  

create procedure dbo.ssp_CMRefundClaimLine 
@ClaimLineId int,
@ProviderRefundId int,
@RefundAmount money,
@UserCode varchar(20)
/*********************************************************************            
-- Stored Procedure: dbo.ssp_CMRefundClaimLine  
-- Copyright: Streamline Healthcare Solutions
--                                                   
-- Purpose: applies provider refund to a claim line
--                                                      
-- Modified Date    Modified By     Purpose  
-- 04.29.2015       SFarber         Created.  
-- 07.15.2015       SFarber         Added code to insert into ClaimLineHistory.
****************************************************************************/       
as

declare @ClaimLineCreditId int
declare @StaffId int
declare @Status int

select top 1 @StaffId = s.StaffId from Staff s where s.UserCode = @UserCode and s.Active = 'Y' and isnull(s.RecordDeleted, 'N') = 'N'
select @Status = cl.Status from ClaimLines cl where cl.ClaimLineId = @ClaimLineId

insert into ClaimLineCredits (ClaimLineId, Amount, ProviderRefundId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
values (@ClaimLineId, @RefundAmount, @ProviderRefundId, @UserCode, getdate(), @UserCode, getdate())

set @ClaimLineCreditId = scope_identity()

update pr
   set BalanceAmount = isnull(pr.BalanceAmount, 0) - @RefundAmount,
       ModifiedBy = @UserCode,
       ModifiedDate = getdate()
  from ProviderRefunds pr
 where pr.ProviderRefundId = @ProviderRefundId
  
update cl
   set PayableAmount = isnull(cl.PayableAmount, 0) + @RefundAmount,
       PaidAmount = isnull(cl.PaidAmount, 0) - @RefundAmount,
       ModifiedBy = @UserCode,
       ModifiedDate = getdate()
  from ClaimLines cl
 where cl.ClaimLineId = @ClaimLineId 

insert into ClaimLineHistory (
       ClaimLineId, 
       ClaimLineCreditId, 
       ActivityStaffId, 
       Activity, 
       ActivityDate,
       Status,
       CreatedBy,
       CreatedDate,
       ModifiedBy,
       ModifiedDate)
values (
       @ClaimLineId, 
       @ClaimLineCreditId, 
       @StaffId, 
       2006, -- Refund
       getdate(),
       @Status,
       @UserCode, 
       getdate(), 
       @UserCode, 
       getdate())       
        
return 

go
     