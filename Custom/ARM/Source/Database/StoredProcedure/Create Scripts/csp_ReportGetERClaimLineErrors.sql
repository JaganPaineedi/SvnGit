/****** Object:  StoredProcedure [dbo].[csp_ReportGetERClaimLineErrors]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportGetERClaimLineErrors]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportGetERClaimLineErrors]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportGetERClaimLineErrors]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
--[csp_ReportGetERClaimLineErrors] 2

create procedure [dbo].[csp_ReportGetERClaimLineErrors]  
@ERFileId int

/********************************************************************************
-- Stored Procedure: csp_ReportGetERClaimLineErrors
--
-- Copyright: 2007 Streamline Healthcate Solutions
--
-- Purpose: used for ClaimLine Errors
--
-- Updates:                     		                                
-- Date        Author      Purpose
-- 08.27.2012  MSuma       Created.      
--
*********************************************************************************/

AS
BEGIN
		select 
			b.ClientName, 
			b.DateOfService, 
			b.BillingCode, 
			b.ChargeAmount,
			b.PaidAmount,
			b.ClientIdentifier, 
			b.LineItemControlNumber, 
			b.PayerClaimNumber, 
			a.ERMessage,
			b.AdjustmentGroupCode11,
			b.AdjustmentReason11,
			b.AdjustmentAmount11,
			b.AdjustmentQuantity11,
			b.AdjustmentGroupCode12,
			b.AdjustmentReason12,
			b.AdjustmentAmount12,
			b.AdjustmentQuantity12,
			b.AdjustmentGroupCode13,
			b.AdjustmentReason13,
			b.AdjustmentAmount13,
			b.AdjustmentQuantity13,
			b.AdjustmentGroupCode14,
			b.AdjustmentReason14,
			b.AdjustmentAmount14,
			b.AdjustmentQuantity14,
			b.AdjustmentGroupCode21,
			b.AdjustmentReason21,
			b.AdjustmentAmount21,
			b.AdjustmentQuantity21,
			b.AdjustmentGroupCode22,
			b.AdjustmentReason22,
			b.AdjustmentAmount22,
			b.AdjustmentQuantity22,
			b.AdjustmentGroupCode23,
			b.AdjustmentReason23,
			b.AdjustmentAmount23,
			b.AdjustmentQuantity23,
			b.AdjustmentGroupCode24,
			b.AdjustmentReason24,
			b.AdjustmentAmount24,
			b.AdjustmentQuantity24,
			b.AdjustmentGroupCode31,
			b.AdjustmentReason31,
			b.AdjustmentAmount31,
			b.AdjustmentQuantity31,
			b.AdjustmentQuantity32,
			b.AdjustmentGroupCode32,
			b.AdjustmentReason32,
			b.AdjustmentAmount32,
			b.AdjustmentGroupCode33,
			b.AdjustmentReason33,
			b.AdjustmentAmount33,
			b.AdjustmentQuantity33,
			b.AdjustmentGroupCode34,
			b.AdjustmentReason34,
			b.AdjustmentAmount34,
			b.AdjustmentQuantity34,
			b.AdjustmentGroupCode41,
			b.AdjustmentReason41,
			b.AdjustmentAmount41,
			b.AdjustmentQuantity41,
			b.AdjustmentGroupCode42,
			b.AdjustmentReason42,
			b.AdjustmentAmount42,
			b.AdjustmentQuantity42,
			b.AdjustmentGroupCode43,
			b.AdjustmentReason43,
			b.AdjustmentAmount43,
			b.AdjustmentQuantity43,
			b.AdjustmentGroupCode44,
			b.AdjustmentReason44,
			b.AdjustmentAmount44,
			b.AdjustmentQuantity44,
			b.AdjustmentGroupCode51,
			b.AdjustmentReason51,
			b.AdjustmentAmount51,
			b.AdjustmentQuantity51,
			b.AdjustmentGroupCode52,
			b.AdjustmentReason52,
			b.AdjustmentAmount52,
			b.AdjustmentQuantity52,
			b.AdjustmentGroupCode53,
			b.AdjustmentReason53,
			b.AdjustmentAmount53,
			b.AdjustmentQuantity53,
			b.AdjustmentGroupCode54,
			b.AdjustmentReason54,
			b.AdjustmentAmount54,
			b.AdjustmentQuantity54,
			case when (b.LineItemControlNumber is null) or (a.ERMessageType = 5235) or (erbp.PaymentId is null) then ''Y'' else ''N'' end as CouldNotPost
		from ERClaimLineItemLog a
		JOIN ERClaimLineItems b ON (a.ERClaimLineItemId = b.ERClaimLineItemId)
		LEFT join dbo.ERBatchPayments as erbp on erbp.ERBatchPaymentId = b.ERBatchPaymentId
		JOIN ERBatches c ON (b.ERBatchId = c.ERBatchId)
		where ERFileId = @ERFileId
		and ERMessageType in (5233, 5235)
		and not exists (
			select * from dbo.ERClaimLineItemLog as a2
			where a2.ERClaimLineItemId = a.ERClaimLineItemId
			and a2.ERMessage = a.ERMessage
			and a2.ERMessageType = a.ERMessageType
			and a2.CreatedDate > a.CreatedDate
			and ISNULL(a2.RecordDeleted, ''N'') <> ''Y''
		) 



END


' 
END
GO
