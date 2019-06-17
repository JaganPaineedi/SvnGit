if OBJECT_ID('dbo.ssp_CMGetNegativeClaimLines') is not null
  drop procedure dbo.ssp_CMGetNegativeClaimLines
go

create procedure dbo.ssp_CMGetNegativeClaimLines
@ProviderId int,
@InsurerId int  
/***********************************************************************                       
-- Stored Procedure: dbo.ssp_GetNegativeClaimLines  
-- Copyright: 2005 Provider Claim Management System 
-- Creation Date:  3/8/2006                         
--                                                  
-- Purpose: Used to get all the claimlines which has -ve payable amount
--
--
-- Updates:
--  Date       	  Author       Purpose
-- 3/08/2006      Vikrant      Created
-- 6/28/2006      SFarber      Modified to exclude open claims
-- 7/06/2006      Vikrant      Modified to get -ve amount of provider
--                             associated with the Insurer 
-- 7/12/2006      SFarber      Modified to select only adjudicated CL
-- 03/07/2017	  kkumar       Modified to allow checks for claims with 0 Payable Amount
-- 04/21/2017	  kkumar       Modified to exclude claims with 0 Payable Amount
***********************************************************************/                     
as
begin
  select cl.ClaimLineId, 
         cl.Status,
         cl.PayableAmount 
    from Sites s
         join Claims c on c.SiteId = s.SiteId
         join ClaimLines cl on cl.ClaimId = c.ClaimId
   where s.ProviderId = @ProviderId 
     and c.InsurerId = @InsurerId
     and cl.PayableAmount < 0 
     and cl.Status in (	2024, -- Denied
						2028, --Void
						2026) --Paid
     and IsNull(cl.NeedsToBeWorked, 'N') = 'N'
     and IsNull(s.RecordDeleted,'N')='N'
     and IsNull(c.RecordDeleted,'N') = 'N'	
     and IsNull(cl.RecordDeleted,'N') = 'N'

   if (@@error!=0)                      
   begin                      
     raiserror 20006  'ssp_GetNegativeClaimLines: An Error Occured'                      
     return                      
   end
end

go