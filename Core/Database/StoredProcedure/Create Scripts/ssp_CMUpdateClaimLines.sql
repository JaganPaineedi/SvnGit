
if object_id('dbo.ssp_CMUpdateClaimLines') is not null 
  Drop procedure dbo.ssp_CMUpdateClaimLines
go



Create procedure dbo.ssp_CMUpdateClaimLines (
  @ClaimlinesForPayment  ClaimlinesForPayment ReadOnly,
  @StaffId int,  
  @StaffCode varchar(30),
  @CheckNumber int,  
  @CheckId int)  
/*********************************************************************            
-- Stored Procedure: dbo.ssp_CMUpdateClaimLines  
-- Copyright: 2005 Provider Claim Management System  
-- Creation Date:  1/2/2005                        
--                                                   
-- Purpose: processes claim line payments during check printing
--                                                                                    
-- Modified Date   Modified By       Purpose 
-- 01.02.2005      Vikrant Tiwari    Created             
-- 08.04.2014      Manju P			 Moved for CM To SC Task #25
-- 02.25.2015      Shruthi.S         Added logic to imrpove the performance of Pritn Checks.Ref #519 Env Issues.
-- 04.10.2015      SFarber           Fixed multiple issues.
-- 22.Apr.2015	   Rohith Uppin		 fnSplitCM Reverted back to fnSplit as Input parameter in fnSplit is modified to Max size. #571 CM to SC issues.
-- 11.Dec.2017	   Kiran Kumar		 Changed the paramter to accept table type 
****************************************************************************/
as 

create table #ClaimLinePayments (
ClaimLineId int,
ClaimLinePaymentId int)


declare @StatusApproved int
declare @StatusPartiallyApproved int 
 
select  @StatusApproved = 2023,
        @StatusPartiallyApproved = 2025  

declare @ErrorMessage nvarchar(max)

if exists ( select  '*'
            from    ClaimLines cl
                    join @ClaimlinesForPayment clt on clt.ClaimLineID = cl.ClaimLineId
            where   (cl.Status not in (@StatusApproved, @StatusPartiallyApproved)
                     or cl.RecordDeleted = 'Y') ) 
  begin
    set @ErrorMessage = (select dbo.Ssf_GetMesageByMessageCode(29, 'OTHERMODIFYDATACLAIMLINE_SSP', '[Data has been modified by another user for claimlines #')) 
    raiserror  (20100,-1,-1,  @ErrorMessage)
    return
  end

Update  cl
set     status = 2026,
        ModifiedBy = @StaffCode,
        ModifiedDate = getdate(),
        PaidAmount = isnull(PaidAmount, 0) + isnull(PayableAmount, 0),
        PayableAmount = 0,
        Needstobeworked = 'N'
from    ClaimLines cl
        join @ClaimlinesForPayment clt on clt.ClaimLineId = cl.ClaimLineId
        
insert  into ClaimLinePayments
        (ClaimLineId,
         CheckId,
         Amount,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate)
output  inserted.ClaimLineId, inserted.ClaimLinePaymentId into #ClaimLinePayments (ClaimLineId, ClaimLinePaymentId)
        select  ClaimLineID,
                @CheckId,
                Amount,
                @StaffCode,
                getdate(),
                @StaffCode,
                getdate()
        from    @ClaimlinesForPayment

insert  into ClaimLineHistory
        (ClaimLineId,
         Activity,
         ActivityDate,
         [Status],
         ActivityStaffId,
         ClaimLinePaymentId,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate)
        select  clp.ClaimLineId,
                2003,
                getdate(),
                2026,
                @StaffId,
                clp.ClaimLinePaymentId,
                @StaffCode,
                getdate(),
                @StaffCode,
                getdate()
        from    #ClaimLinePayments clp
  

insert  into CheckAdjudications
        (CheckId,
         AdjudicationId,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate)
        select  @CheckId,
                a.AdjudicationId,
                @StaffCode,
                getdate(),
                @StaffCode,
                getdate()
        from    @ClaimlinesForPayment cl
                join Adjudications a on a.ClaimLineId = cl.ClaimLineID
        where   isnull(a.RecordDeleted, 'N') = 'N'
                and not exists ( select *
                                 from   Adjudications a2
                                 where  a2.ClaimLineId = cl.ClaimLineID
                                        and isnull(a2.RecordDeleted, 'N') = 'N'
                                        and a2.AdjudicationId > a.AdjudicationId )


delete  op
from    OpenClaims op
        join @ClaimlinesForPayment cl on cl.ClaimLineID = op.ClaimLineId


return

go
