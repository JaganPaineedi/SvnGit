IF OBJECT_ID('csp_ReportGetERClaimLinesUnposted') IS NOT NULL 
   DROP PROCEDURE csp_ReportGetERClaimLinesUnposted
GO

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

--[csp_ReportGetERClaimLineErrors] 2

CREATE PROCEDURE [dbo].csp_ReportGetERClaimLinesUnposted @ERFileId INT

/********************************************************************************
-- Stored Procedure: csp_ReportGetERClaimLinesUnposted
--
-- Copyright: 2016 Streamline Healthcate Solutions
--
-- Purpose: used to identify unposted dollars from payments.
--
-- Updates:                     		                                
-- Date        Author      Purpose
-- 02.04.2016  dknewtson   Created
*********************************************************************************/
AS 
       BEGIN
                    SELECT  ecli.ClaimLineItemId
                           ,STUFF(serv.ServiceIds, 1, 2, '') AS ServiceIds
                    INTO    #ERClaimLineItemServices
                    FROM    dbo.ERClaimLineItems ecli
                            JOIN dbo.ERBatches eb
                                ON ecli.ERBatchId = eb.ERBatchId
                            CROSS APPLY (
                                          SELECT (  SELECT  ', ' + CAST(s.ServiceId AS VARCHAR)
                                                    FROM    dbo.Services s
                                                    WHERE   EXISTS ( SELECT 1
                                                                     FROM   Charges c
                                                                            JOIN ClaimLineItemCharges clic
                                                                                ON clic.ChargeId = c.ChargeId
                                                                                   AND clic.ClaimLineItemId = ecli.ClaimLineItemId
                                                                     WHERE  c.ServiceId = s.ServiceId
                                                                            AND ISNULL(s.RecordDeleted, 'N') <> 'Y'
                                                                            AND ISNULL(c.RecordDeleted, 'N') <> 'Y'
                                                                            AND ISNULL(clic.RecordDeleted, 'N') <> 'Y' )
                                                    ORDER BY s.ServiceId
                                          FOR       XML PATH('')
                                                       ,TYPE).value('.', 'NVARCHAR(MAX)') AS ServiceIds
                                        ) serv
                    WHERE   eb.ERFileId = @ERFileId
                            AND ISNULL(ecli.RecordDeleted, 'N') <> 'Y'
                            AND ISNULL(eb.RecordDeleted, 'N') <> 'Y'

             SELECT ecli.ERClaimLineItemId
                   ,STUFF(err.ErrorMessages, 1, 1, '') AS ERMessage
             INTO   #ERClaimLineItemMessages
             FROM   dbo.ERClaimLineItems ecli
                    JOIN dbo.ERBatches eb
                        ON ecli.ERBatchId = eb.ERBatchId
                    CROSS APPLY (
                                  SELECT (  SELECT  ' ' + eclil.ERMessage
                                            FROM    dbo.ERClaimLineItemLog eclil
                                            WHERE   eclil.ERClaimLineItemId = ecli.ERCLaimLineItemId
                                                    AND ERMessageType IN ( 5233, 5235 )
                                            ORDER BY eclil.ERClaimLineItemLogId
                                  FOR       XML PATH('')
                                               ,TYPE).value('.', 'NVARCHAR(MAX)') AS ErrorMessages
                                ) err
             WHERE  eb.ERFileId = @ERFileId
                    AND ISNULL(ecli.RecordDeleted, 'N') <> 'Y'
                    AND ISNULL(eb.RecordDeleted, 'N') <> 'Y'
                    AND EXISTS ( SELECT 1
                                 FROM   dbo.ERClaimLineItemLog eclil2
                                 WHERE  eclil2.ERClaimLineItemId = ecli.ERClaimLineItemId
                                        AND ERMessageType IN ( 5233, 5235 ) )


             DECLARE @PayerId INT
             SELECT @PayerId = es.PayerId
             FROM   dbo.ERFiles ef
                    JOIN dbo.ERSenders es
                        ON ef.ERSenderId = es.ERSenderId
             WHERE  ef.ERFileId = @ERFileId

             SELECT ecli.ClaimLineItemId
                   ,ceclic.ChargeId
                   ,ebp.PaymentId
             INTO   #ClaimLineItemCharges
             FROM   dbo.ERClaimLineItems ecli
                    JOIN dbo.ERBatchPayments ebp
                        ON ecli.ERBatchPaymentId = ebp.ERBatchPaymentId
                    JOIN dbo.ERBatches eb
                        ON ebp.ERBatchId = eb.ERBatchId
                    JOIN dbo.CustomERClaimLineItemCharges ceclic
                        ON ecli.ERClaimLineItemId = ceclic.ERClaimLineItemId
             WHERE  eb.ERFileId = @ERFileId
                    AND ECLI.ClaimLineItemId IS NOT NULL
                    AND ISNULL(ecli.RecordDeleted, 'N') <> 'Y'
             GROUP BY ecli.ClaimLineItemId
                   ,ceclic.ChargeId
                   ,ebp.PaymentId
                   
             SELECT clic.ClaimLineItemId
                   ,( ISNULL(SUM(al.Amount), 0.00) * -1 ) / CASE WHEN ISNULL(num.numcharges,0) > 0 THEN num.numcharges ELSE 1 END AS SCPaid
             INTO   #ClaimLinePayments
             FROM   #ClaimLineItemCharges clic
                    JOIN dbo.ARLedger al
                        ON clic.ChargeId = al.ChargeId
                           --AND al.PaymentId = clic.PaymentId
                           AND al.LedgerType = 4202
                           AND ISNULL(al.RecordDeleted, 'N') <> 'Y'
                    CROSS APPLY (
                                  SELECT    COUNT(DISTINCT clic.ClaimLineItemId) AS numcharges
                                  FROM      #ClaimLineItemCharges clic
                                             JOIN dbo.ERClaimLineItems ecli ON clic.ClaimLineItemId = ecli.ClaimLineItemId
                                             JOIN dbo.ERBatches eb ON ecli.ERBatchId = eb.ERBatchId
                                             AND eb.ERFileId = @ERFileId
                                  WHERE     clic.ChargeId = al.ChargeId
                                            AND ecli.PaidAmount <> 0.00
                                ) num
             GROUP BY clic.ClaimLineItemId
                   ,num.numcharges
--SELECT  ecli.ERClaimLineItemId
--       ,ISNULL(SUM(eclia.AdjustmentAmount), 0.00) * -1 AS TotalAdjustments
--INTO    #ClaimLineAdjustments
--FROM    dbo.ERClaimLineItems ecli
--        JOIN dbo.ERClaimLineItemAdjustments eclia
--            ON ecli.ERClaimLineItemId = eclia.ERClaimLineItemId
--               AND ISNULL(eclia.RecordDeleted, 'N') <> 'Y'
--GROUP BY ecli.ERClaimLineItemId

            -- the client's current charge ignoring payments/adjustments
             --SELECT clic.ClaimLineItemId
             --      ,ISNULL(SUM(al.Amount), 0.00) AS PatientResponsibility
             --INTO   #ClaimLinePatientResponsibility
             --FROM   #ClaimLineItemCharges clic
             --       JOIN Charges c
             --           ON clic.ChargeId = c.ChargeId
             --       JOIN dbo.Charges c2
             --           ON c.ServiceId = c2.ServiceId
             --              AND c2.ClientCoveragePlanId IS NULL
             --       JOIN dbo.ARLedger al
             --           ON al.ChargeId = c2.ChargeId
             --              AND ISNULL(al.RecordDeleted, 'N') <> 'Y'
             --              AND al.LedgerType IN ( 4204, 4201 )
             --GROUP BY clic.ClaimLineItemId                     

             SELECT b.CheckNumber
                   ,c.ClientIdentifier
                   ,c.LineItemControlNumber
                   ,c.PayerClaimNumber
                   ,c.ClientName
                   ,c.BillingCode
                   ,c.DateOfService
                   ,c.ChargeAmount AS ChargeAmount
                   ,c.PaidAmount AS PaidAmount
                   ,ISNULL(clp.SCPaid, 0.00) AS [SC Amount]
                   --,ISNULL(clpr.PatientResponsibility, 0.00) AS PatientResponsibility
                   ,ISNULL(eclim.ERMessage,'Payment may have been reversed.') AS ERMessage
                   ,eclis.ServiceIds
                   ,c.AdjustmentGroupCode11
                   ,c.AdjustmentReason11
                   ,c.AdjustmentAmount11
                   ,c.AdjustmentQuantity11
                   ,c.AdjustmentGroupCode12
                   ,c.AdjustmentReason12
                   ,c.AdjustmentAmount12
                   ,c.AdjustmentQuantity12
                   ,c.AdjustmentGroupCode13
                   ,c.AdjustmentReason13
                   ,c.AdjustmentAmount13
                   ,c.AdjustmentQuantity13
                   ,c.AdjustmentGroupCode14
                   ,c.AdjustmentReason14
                   ,c.AdjustmentAmount14
                   ,c.AdjustmentQuantity14
                   ,c.AdjustmentGroupCode21
                   ,c.AdjustmentReason21
                   ,c.AdjustmentAmount21
                   ,c.AdjustmentQuantity21
                   ,c.AdjustmentGroupCode22
                   ,c.AdjustmentReason22
                   ,c.AdjustmentAmount22
                   ,c.AdjustmentQuantity22
                   ,c.AdjustmentGroupCode23
                   ,c.AdjustmentReason23
                   ,c.AdjustmentAmount23
                   ,c.AdjustmentQuantity23
                   ,c.AdjustmentGroupCode24
                   ,c.AdjustmentReason24
                   ,c.AdjustmentAmount24
                   ,c.AdjustmentQuantity24
                   ,c.AdjustmentGroupCode31
                   ,c.AdjustmentReason31
                   ,c.AdjustmentAmount31
                   ,c.AdjustmentQuantity31
                   ,c.AdjustmentQuantity32
                   ,c.AdjustmentGroupCode32
                   ,c.AdjustmentReason32
                   ,c.AdjustmentAmount32
                   ,c.AdjustmentGroupCode33
                   ,c.AdjustmentReason33
                   ,c.AdjustmentAmount33
                   ,c.AdjustmentQuantity33
                   ,c.AdjustmentGroupCode34
                   ,c.AdjustmentReason34
                   ,c.AdjustmentAmount34
                   ,c.AdjustmentQuantity34
                   ,c.AdjustmentGroupCode41
                   ,c.AdjustmentReason41
                   ,c.AdjustmentAmount41
                   ,c.AdjustmentQuantity41
                   ,c.AdjustmentGroupCode42
                   ,c.AdjustmentReason42
                   ,c.AdjustmentAmount42
                   ,c.AdjustmentQuantity42
                   ,c.AdjustmentGroupCode43
                   ,c.AdjustmentReason43
                   ,c.AdjustmentAmount43
                   ,c.AdjustmentQuantity43
                   ,c.AdjustmentGroupCode44
                   ,c.AdjustmentReason44
                   ,c.AdjustmentAmount44
                   ,c.AdjustmentQuantity44
                   ,c.AdjustmentGroupCode51
                   ,c.AdjustmentReason51
                   ,c.AdjustmentAmount51
                   ,c.AdjustmentQuantity51
                   ,c.AdjustmentGroupCode52
                   ,c.AdjustmentReason52
                   ,c.AdjustmentAmount52
                   ,c.AdjustmentQuantity52
                   ,c.AdjustmentGroupCode53
                   ,c.AdjustmentReason53
                   ,c.AdjustmentAmount53
                   ,c.AdjustmentQuantity53
                   ,c.AdjustmentGroupCode54
                   ,c.AdjustmentReason54
                   ,c.AdjustmentAmount54
                   ,c.AdjustmentQuantity54
             FROM   ERBatches a
                    JOIN ERBatchPayments b
                        ON ( a.ERBatchId = b.ERBatchId )
                           AND ISNULL(b.RecordDeleted, 'N') = 'N'
                    JOIN ERClaimLineItems c
                        ON ( b.ERBatchPaymentId = c.ERBatchPaymentId )
                           AND ISNULL(c.RecordDeleted, 'N') = 'N'
                    JOIN dbo.ERFiles AS f
                        ON f.ERFileId = a.ERFileId
                           AND ISNULL(f.RecordDeleted, 'N') = 'N'
                    LEFT JOIN #ClaimLinePayments clp
                        ON c.ClaimLineItemId = clp.ClaimLineItemId
                    --LEFT JOIN #ClaimLinePatientResponsibility clpr
                    --    ON c.ClaimLineItemId = clpr.ClaimLineItemId
                    LEFT JOIN #ERClaimLineItemMessages eclim ON eclim.ERClaimLineItemId = c.ERClaimLineItemId
                    LEFT JOIN #ERClaimLineItemServices eclis ON eclis.ClaimLineItemId = c.ClaimLineItemId
             WHERE  a.ERFileId = @ERFileId
                    AND PaidAmount > ISNULL(clp.SCPaid, 0.00) 
--and b.PaymentId is null
		-- do not include outcomes measures data
ORDER BY            b.CheckNumber
                   ,c.ClientName
                   ,CASE WHEN c.ClientIdentifier LIKE '%-%'
                         THEN LEFT(c.ClientIdentifier, CHARINDEX('-', c.ClientIdentifier))
                         ELSE c.ClientIdentifier
                    END
                   ,c.DateOfService
                   ,c.BillingCode
                   ,c.ERClaimLineItemId


       END


