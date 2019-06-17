if object_id('dbo.ssp_CMUpdateClaimLineCredits') is not null
  drop procedure dbo.ssp_CMUpdateClaimLineCredits
go


create procedure dbo.ssp_CMUpdateClaimLineCredits
  @ClaimlinesForCredit ClaimlinesForPayment ReadOnly,
  @CheckId int,
  @StaffCode varchar(100),
  @StaffId int
/*********************************************************************            
-- Stored Procedure: dbo.ssp_UpdateClaimLineCredits  
-- Copyright: 2005 Provider Claim Management System  
-- Creation Date:  3/8/2006                        
--                                                   
-- Purpose: processes claim line credits during check printing
--                                                                                    
-- Modified Date   Modified By       Purpose 
-- 03.08.2006      Vikrant Tiwari    Created             
-- 08.04.2014      Manju P			 Moved for CM To SC Task #25
-- 02.25.2015      Shruthi.S         Added logic to imrpove the performance of Pritn Checks.Ref #519 Env Issues.
-- 04.10.2015      SFarber           Fixed multiple issues.
-- 22.Apr.2015	   Rohith Uppin		 fnSplitCM Reverted back to fnSplit as Input parameter in fnSplit is modified to Max size. #571 CM to SC issues.
-- 05.04.2017      SFarber           Modified to insert one credit record per claim line.  Fixed issues with Paid and Payable amounts incorrectly set when partial credit is taken.
-- 11.Dec.2017	   Kiran Kumar		 Changed the paramter to accept table type 
****************************************************************************/
as
create table #ClaimLineCredits (ClaimLineId int,
                                ClaimLineCreditId int)

create table #ClaimLines (ClaimLineId int,
                          CreditAmount money,
                          Status int)



insert  into #ClaimLines
        (ClaimLineId,
         CreditAmount,
         Status)
select  clt.ClaimLineId,
        sum(clt.Amount),
        max(clt.Status)
from    @ClaimlinesForCredit clt
group by clt.ClaimLineId

update  cl
set     Status = clt.Status,
        ModifiedBy = @StaffCode,
        ModifiedDate = getdate(),
        PaidAmount = isnull(cl.PaidAmount, 0) - isnull(clt.CreditAmount, 0),
        PayableAmount = isnull(cl.PayableAmount, 0) + isnull(clt.CreditAmount, 0),
        NeedsToBeWorked = case when (cl.Status = 2026) then 'N'
                               else NeedsToBeWorked
                          end
from    ClaimLines cl
        join #ClaimLines clt on clt.ClaimLineId = cl.ClaimLineId


insert  into ClaimLineCredits
        (ClaimLineId,
         CheckId,
         Amount,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate)
output  inserted.ClaimLineId,
        inserted.ClaimLineCreditId
        into #ClaimLineCredits (ClaimLineId, ClaimLineCreditId)
select  ClaimLineId,
        @CheckId,
        CreditAmount,
        @StaffCode,
        getdate(),
        @StaffCode,
        getdate()
from    #ClaimLines


insert  into ClaimLineHistory
        (ClaimLineId,
         Activity,
         ActivityDate,
         Status,
         ActivityStaffId,
         ClaimLineCreditId,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate)
select  clc.ClaimLineId,
        2005,
        getdate(),
        cl.Status,
        @StaffId,
        clc.ClaimLineCreditId,
        @StaffCode,
        getdate(),
        @StaffCode,
        getdate()
from    #ClaimLineCredits clc
        join #ClaimLines cl on cl.ClaimLineId = clc.ClaimLineId


delete  op
from    OpenClaims op
        join #ClaimLines cl on cl.ClaimLineId = op.ClaimLineId
where   cl.Status = 2026
  
return

go
