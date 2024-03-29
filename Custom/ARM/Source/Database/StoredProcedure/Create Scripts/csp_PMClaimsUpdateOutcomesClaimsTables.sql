/****** Object:  StoredProcedure [dbo].[csp_PMClaimsUpdateOutcomesClaimsTables]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PMClaimsUpdateOutcomesClaimsTables]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PMClaimsUpdateOutcomesClaimsTables]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PMClaimsUpdateOutcomesClaimsTables]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create proc [dbo].[csp_PMClaimsUpdateOutcomesClaimsTables] 
@CurrentUser varchar(30), @ClaimBatchId int
as
/*********************************************************************/
/* Stored Procedure: dbo.ssp_PMClaimsUpdateClaimsTables                         */
/* Creation Date:    9/25/06                                         */
/*                                                                   */
/* Purpose:           */
/*                                                                   *//* Input Parameters:						     */
/*                                                                   */
/* Output Parameters:                                                */
/*                                                                   */
/* Return Status:                                                    */
/*                                                                   */
/* Called By:       */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/* Updates:                                                          */
/*   Date     Author      Purpose                                    */
/*  9/25/06   JHB	  Created                                    */
/*********************************************************************/

declare @CurrentDate datetime

set @CurrentDate = getdate()

if @@error <> 0 goto error

delete b
from ClaimLineItemGroups a
JOIN ClaimLIneItems b ON (a.ClaimLineItemGroupId = b.ClaimLineItemGroupId)
where a.ClaimBatchId = @ClaimBatchId

if @@error <> 0 goto error

delete a
from ClaimLineItemGroups a
where a.ClaimBatchId = @ClaimBatchId

if @@error <> 0 goto error

-- Update Claims tables
-- One record for each claim 
insert into ClaimLineItemGroups
(ClaimBatchId, ClientId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, DeletedBy)
select distinct @ClaimBatchId, ClientId, @CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate, 
convert(varchar, ClaimLineId)
from #ClaimLines

if @@error <> 0 goto error

-- One record for each line item (same as number of claims in case of 837)
insert into ClaimLineItems
(ClaimLineItemGroupId, BillingCode, Modifier1, Modifier2, Modifier3, Modifier4, RevenueCode,
RevenueCodeDescription, Units,  DateOfService, ChargeAmount, 
CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, DeletedBy)
select b.ClaimLineItemGroupId, a.BillingCode, a.Modifier1, a.Modifier2, a.Modifier3, a.Modifier4, 
a.RevenueCode, a.RevenueCodeDescription, a.ClaimUnits,  a.DateOfService, a.ChargeAmount,
@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate, b.DeletedBy
from #ClaimLines a
JOIN ClaimLineItemGroups b ON (convert(varchar,a.ClaimLineId) = b.DeletedBy)
where b.ClaimBatchId = @ClaimBatchId

if @@error <> 0 goto error

update a
set LineItemControlNumber = c.ClaimLineItemId
from #ClaimLines a
JOIN ClaimLineItemGroups b ON (convert(varchar,a.ClaimLineId) = b.DeletedBy)
JOIN ClaimLineItems c ON (b.ClaimLineItemGroupId = c.ClaimLineItemGroupId)
where b.ClaimBatchId = @ClaimBatchId

if @@error <> 0 goto error

update c
set DeletedBy = null
from ClaimLineItemGroups b 
JOIN ClaimLineItems c ON (b.ClaimLineItemGroupId = c.ClaimLineItemGroupId)
where b.ClaimBatchId = @ClaimBatchId

if @@error <> 0 goto error

update b
set DeletedBy = null
from ClaimLineItemGroups b 
where b.ClaimBatchId = @ClaimBatchId

if @@error <> 0 goto error


update c
set BilledDate = GETDATE()
from  #ClaimLines a
JOIN #Charges b ON (a.ClaimLineId = b.ClaimLineId)
JOIN dbo.CustomOutcomesBillingCharges  c ON (b.ChargeId = c.OutcomesBillingChargeId)

if @@error <> 0 goto error

error:
' 
END
GO
