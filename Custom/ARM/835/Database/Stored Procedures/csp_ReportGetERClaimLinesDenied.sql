IF OBJECT_ID('csp_ReportGetERClaimLinesDenied') IS NOT NULL
   DROP PROCEDURE csp_ReportGetERClaimLinesDenied
GO

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

--[csp_ReportGetERClaimLineErrors] 2

create procedure [dbo].csp_ReportGetERClaimLinesDenied  
@ERFileId int

/********************************************************************************
-- Stored Procedure: csp_ReportGetERClaimLinesDenied
--
-- Copyright: 2016 Streamline Healthcate Solutions
--
-- Purpose: used for denied claims
--
-- Updates:                     		                                
-- Date        Author      Purpose
-- 02.02.2016  dknewtson   Created
*********************************************************************************/

AS
BEGIN

             SELECT ecli.ClaimLineItemId
                   ,STUFF(serv.ServiceIds, 1, 2, '') AS ServiceIds
             INTO   #ERClaimLineItemServices
             FROM   dbo.ERClaimLineItems ecli
                    JOIN dbo.ERBatches eb
                        ON ecli.ERBatchId = eb.ERBatchId
                    CROSS APPLY (
                                  SELECT (  SELECT  ', ' + CAST(s.ServiceId AS VARCHAR)
                                            FROM    dbo.Services s
                                            WHERE EXISTS (SELECT 1 FROM Charges c 
                                            JOIN ClaimLineItemCharges clic ON clic.ChargeId = c.ChargeId
                                                                             AND clic.ClaimLineItemId = ecli.ClaimLineItemId
                                                     WHERE c.ServiceId = s.ServiceId
                                                           AND ISNULL(s.RecordDeleted,'N') <> 'Y'
                                                           AND ISNULL(c.RecordDeleted,'N') <> 'Y'
                                                           AND ISNULL(clic.RecordDeleted,'N') <> 'Y')
                                            ORDER BY s.ServiceId
                                  FOR       XML PATH('')
                                               ,TYPE).value('.', 'NVARCHAR(MAX)') AS ServiceIds
                                ) serv
             WHERE  eb.ERFileId = @ERFileId
                    AND ISNULL(ecli.RecordDeleted, 'N') <> 'Y'
                    AND ISNULL(eb.RecordDeleted, 'N') <> 'Y'
                    
                   GROUP BY Serv.ServiceIds,ecli.ClaimLineItemId


		select 
			b.ClientName, 
			b.DateOfService, 
			b.BillingCode, 
			b.ChargeAmount,
			b.PaidAmount,
			b.ClientIdentifier, 
			b.LineItemControlNumber, 
			b.PayerClaimNumber,
         erbp.CheckNumber,
         eclis.ServiceIds,
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
			b.AdjustmentQuantity54
		from ERClaimLineItems b 
		LEFT join dbo.ERBatchPayments as erbp on erbp.ERBatchPaymentId = b.ERBatchPaymentId
		JOIN ERBatches c ON (b.ERBatchId = c.ERBatchId)
      LEFT JOIN #ERClaimLineItemServices eclis ON eclis.ClaimLineItemId = b.ClaimLineItemId
		where ERFileId = @ERFileId
      AND b.PaidAmount = 0.00
      --AND NOT EXISTS (SELECT 1 FROM dbo.ERClaimLineItems ecli 
      --                              JOIN ERBatches eb ON (eb.ERBatchId = ecli.ERBatchId)
      --                                       AND eb.ERFileId = @ERFileId
      --                         WHERE b.ClaimLineItemId = ecli.ClaimLineItemId
      --                              AND ecli.ERClaimLineItemId <> b.ERClaimLineItemId
      --                              AND ISNULL(ecli.RecordDeleted,'N') <> 'Y'
      --                              AND ecli.PaidAmount > 0.00
      --               )


END


GO
