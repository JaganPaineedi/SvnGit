if object_id('dbo.ssp_CMUpdateApproveClaimDetails') is not null
  drop procedure dbo.ssp_CMUpdateApproveClaimDetails
go

create procedure dbo.ssp_CMUpdateApproveClaimDetails
@ClaimLineId int,
@ApproveAmount money,
@ApproveReason int,
@PartialDenialReason int,
@StaffId int,
@StaffLastName varchar(20)
/*********************************************************************          
-- Stored Procedure: dbo.ssp_CMUpdateApproveClaimDetails
-- Copyright: 2005 Streamline Healthcare Solutions,  LLC 
-- Creation Date:  12/15/2005                      
--                                                 
-- Purpose: used to update the values in the DB from Mannual approve claim screen
--                                                                                  
-- Input Parameters:  @ClaimLineId int
--                                                    
-- Modified Date    Modified By       Purpose
-- 12.15.2005       Gursharan         Created.
-- 05.29.2008       SFarber           Redesigned.
****************************************************************************/           
as

-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- The logic was moved to the ssp_ManuallyApprovedClaimLine stored procedure
-- Do not drop this sp because it is still being called by the client
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

return

go

