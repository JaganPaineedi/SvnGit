if object_id('dbo.ssf_GetAddOnClaimLines') is not null
  drop function dbo.ssf_GetAddOnClaimLines
go

create function dbo.ssf_GetAddOnClaimLines (@ClaimLineId int)
returns table
/*********************************************************************              
-- Function: dbo.ssf_GetAddOnClaimLines    
--
-- Copyright: Streamline Healthcare Solutions    
--                                                     
-- Purpose: Returns corresponding add-on claim lines from the same claim
--                                                                                      
-- Modified Date    Modified By  Purpose    
-- 11.01.2017       SFarber      Created.
****************************************************************************/
  as
return
  (-- Get all add-on codes 
   with AddOnCodes(BillingCodeId)
          as (
		      -- Anchor definition          
              select  bcaoc.AddOnBillingCodeId
              from    ClaimLines cl
                      join dbo.BillingCodes bc on bc.BillingCodeId = cl.BillingCodeId
                      join dbo.BillingCodeAddOnCodes bcaoc on bcaoc.BillingCodeId = bc.BillingCodeId
              where   cl.ClaimLineId = @ClaimLineId
                      and isnull(bc.AddOnCodeGroupName, '') <> ''
                      and isnull(bcaoc.RecordDeleted, 'N') = 'N'
              union all
		      -- Recursive definition          
              select  bcaoc.AddOnBillingCodeId
              from    AddOnCodes aoc
                      join dbo.BillingCodes bc on bc.BillingCodeId = aoc.BillingCodeId
                      join BillingCodeAddOnCodes bcaoc on bcaoc.BillingCodeId = aoc.BillingCodeId
              where   isnull(bc.AddOnCodeGroupName, '') <> ''
                      and isnull(bcaoc.RecordDeleted, 'N') = 'N')
  select  distinct
          cla.ClaimLineId
  from    ClaimLines cl
          join Claims c on cl.ClaimId = c.ClaimId
          join ClaimLines cla on cla.ClaimId = c.ClaimId
          join AddOnCodes aoc on aoc.BillingCodeId = cla.BillingCodeId
  where   cl.ClaimLineId = @ClaimLineId
          and cla.FromDate = cl.FromDate
          and cla.PlaceOfService = cl.PlaceOfService
          and isnull(isnull(cla.RenderingProviderId, c.RenderingProviderId), -1) = isnull(isnull(cl.RenderingProviderId, c.RenderingProviderId), -1)
          and isnull(cla.RecordDeleted, 'N') = 'N')
go




