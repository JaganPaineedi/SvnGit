/****** Object:  StoredProcedure [dbo].[csp_ReportExpectedPaymentAdjustmentErrors]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportExpectedPaymentAdjustmentErrors]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportExpectedPaymentAdjustmentErrors]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportExpectedPaymentAdjustmentErrors]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_ReportExpectedPaymentAdjustmentErrors] as
/******************************************************************************
**
**  Name: csp_ReportExpectedPaymentAdjustmentErrors
**  Desc:
**  Show any errors for billing code/modifier combinations that could not be
**  found.
**
**  Return values:
**
**  Called by:   ServiceDetails.cs
**
**  Parameters:   csp_AdjustmentExpectedPayments @AdjustmentCode = 1000254
**
**  Auth:
**  Date:
*******************************************************************************
**  Change History
*******************************************************************************
**  Date:     Author:   Description:
** 10/1/2012 TER	  Created
*******************************************************************************/
-- harbor custom report to review custom expected payment errors
select e.BillingCode, e.Modifier1, e.Modifier2, e.Modifier3, e.Modifier4, MAX(cli.CreatedDate) as LastBilledDate, COUNT(*) as NumberOfClaimLines
from CustomExpectedPaymentAdjustmentErrors as e
join dbo.ClaimLineItems as cli on cli.ClaimLineItemId = e.ClaimLineItemId
group by e.BillingCode, e.Modifier1, e.Modifier2, e.Modifier3, e.Modifier4
order by 1, 2, 3, 4, 5

' 
END
GO
