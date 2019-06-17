/****** Object:  StoredProcedure [dbo].[csp_ReportGetERClaimLineErrors]    Script Date: 09/28/2012 10:25:46 ******/
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[csp_ReportGetERClaimLineErrors]')
                    AND type IN ( N'P', N'PC' ) ) 
   DROP PROCEDURE [dbo].[csp_ReportGetERClaimLineErrors]
GO

/****** Object:  StoredProcedure [dbo].[csp_ReportGetERClaimLineErrors]    Script Date: 09/28/2012 10:25:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--[csp_ReportGetERClaimLineErrors] 2

CREATE PROCEDURE [dbo].[csp_ReportGetERClaimLineErrors] @ERFileId INT

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
-- 06.16.2013  T.Remisoski Exlcude outcomes billing codes from the report
-- 12.02.2013  David K	   Removed Outcomes Billing Code Exclusion
-- 02.23.2016  David K     Grouping claim line item errors
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
             WHERE  eb.ERFileId = @ERFileId
                    AND ISNULL(ecli.RecordDeleted, 'N') <> 'Y'
                    AND ISNULL(eb.RecordDeleted, 'N') <> 'Y'
                    
                    GROUP BY Serv.ServiceIds,ecli.ClaimLineItemId
  
  -- Charges with a non-zero balance.
             DECLARE @PayerId INT
             SELECT @PayerId = es.PayerId
             FROM   dbo.ERFiles ef
                    JOIN dbo.ERSenders es
                        ON ef.ERSenderId = es.ERSenderId
             WHERE  ef.ERFileId = @ERFileId

              SELECT ecli.ERClaimLineItemId
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
             GROUP BY ecli.ERClaimLineItemId
                   ,ceclic.ChargeId
                   ,ebp.PaymentId
    
    
             SELECT clic.ERClaimLineItemId
                   ,al2.ChargeId
             INTO   #OutOfBalance
             FROM   #ClaimLineItemCharges clic
                    JOIN dbo.ARLedger al2
                        ON clic.ChargeId = al2.ChargeId
             GROUP BY al2.ChargeId
                   ,clic.ERClaimLineItemId
             HAVING SUM(al2.Amount) <> 0
                                      

             SELECT ecli.ERClaimLineItemId
                   ,STUFF(err.ErrorMessages, 1, 1, '') AS ERMessage
             INTO   #ERClaimLineItemMessages
             FROM   dbo.ERClaimLineItems ecli
                    JOIN dbo.ERBatches eb
                        ON ecli.ERBatchId = eb.ERBatchId
                    CROSS APPLY (
                                  SELECT (  SELECT  mes.ERMessage
                                            FROM    (
                                                      SELECT    ' ' + eclil.ERMessage AS ERMessage
                                                      FROM      dbo.ERClaimLineItemLog eclil
                                                      WHERE     eclil.ERClaimLineItemId = ecli.ERCLaimLineItemId
                                                                AND ERMessageType IN ( 5233, 5235 )
                                                      UNION ALL
                                                      SELECT    ' Charge balance does not equal 0' AS ERMessage
                                                      WHERE     EXISTS ( SELECT 1
                                                                         FROM   #OutOfBalance oob
                                                                         WHERE  oob.ERClaimLineItemId = ecli.ERClaimLineItemId )
                                                    ) mes
                                  FOR       XML PATH('')
                                               ,TYPE).value('.', 'NVARCHAR(MAX)') AS ErrorMessages
                                ) err
             WHERE  eb.ERFileId = @ERFileId
                    AND ISNULL(ecli.RecordDeleted, 'N') <> 'Y'
                    AND ISNULL(eb.RecordDeleted, 'N') <> 'Y'
                    AND ( EXISTS ( SELECT   1
                                   FROM     dbo.ERClaimLineItemLog eclil2
                                   WHERE    eclil2.ERClaimLineItemId = ecli.ERClaimLineItemId
                                            AND ERMessageType IN ( 5233, 5235 ) )
                          OR EXISTS ( SELECT    1
                                      FROM      #OutOfBalance oob2
                                      WHERE     oob2.ERClaimLineItemId = ecli.ERClaimLineItemId )
                        )
            --DELETE FROM #ERClaimLineItemMessages WHERE ISNULL(ERMessage,'') = ''


             SELECT b.ClientName
                   ,b.DateOfService
                   ,b.BillingCode
                   ,b.ChargeAmount
                   ,b.PaidAmount
                   ,b.ClientIdentifier
                   ,b.LineItemControlNumber
                   ,b.PayerClaimNumber
                   ,erbp.CheckNumber
                   ,eclim.ERMessage
                   ,eclis.ServiceIds
                   ,b.AdjustmentGroupCode11
                   ,b.AdjustmentReason11
                   ,b.AdjustmentAmount11
                   ,b.AdjustmentQuantity11
                   ,b.AdjustmentGroupCode12
                   ,b.AdjustmentReason12
                   ,b.AdjustmentAmount12
                   ,b.AdjustmentQuantity12
                   ,b.AdjustmentGroupCode13
                   ,b.AdjustmentReason13
                   ,b.AdjustmentAmount13
                   ,b.AdjustmentQuantity13
                   ,b.AdjustmentGroupCode14
                   ,b.AdjustmentReason14
                   ,b.AdjustmentAmount14
                   ,b.AdjustmentQuantity14
                   ,b.AdjustmentGroupCode21
                   ,b.AdjustmentReason21
                   ,b.AdjustmentAmount21
                   ,b.AdjustmentQuantity21
                   ,b.AdjustmentGroupCode22
                   ,b.AdjustmentReason22
                   ,b.AdjustmentAmount22
                   ,b.AdjustmentQuantity22
                   ,b.AdjustmentGroupCode23
                   ,b.AdjustmentReason23
                   ,b.AdjustmentAmount23
                   ,b.AdjustmentQuantity23
                   ,b.AdjustmentGroupCode24
                   ,b.AdjustmentReason24
                   ,b.AdjustmentAmount24
                   ,b.AdjustmentQuantity24
                   ,b.AdjustmentGroupCode31
                   ,b.AdjustmentReason31
                   ,b.AdjustmentAmount31
                   ,b.AdjustmentQuantity31
                   ,b.AdjustmentQuantity32
                   ,b.AdjustmentGroupCode32
                   ,b.AdjustmentReason32
                   ,b.AdjustmentAmount32
                   ,b.AdjustmentGroupCode33
                   ,b.AdjustmentReason33
                   ,b.AdjustmentAmount33
                   ,b.AdjustmentQuantity33
                   ,b.AdjustmentGroupCode34
                   ,b.AdjustmentReason34
                   ,b.AdjustmentAmount34
                   ,b.AdjustmentQuantity34
                   ,b.AdjustmentGroupCode41
                   ,b.AdjustmentReason41
                   ,b.AdjustmentAmount41
                   ,b.AdjustmentQuantity41
                   ,b.AdjustmentGroupCode42
                   ,b.AdjustmentReason42
                   ,b.AdjustmentAmount42
                   ,b.AdjustmentQuantity42
                   ,b.AdjustmentGroupCode43
                   ,b.AdjustmentReason43
                   ,b.AdjustmentAmount43
                   ,b.AdjustmentQuantity43
                   ,b.AdjustmentGroupCode44
                   ,b.AdjustmentReason44
                   ,b.AdjustmentAmount44
                   ,b.AdjustmentQuantity44
                   ,b.AdjustmentGroupCode51
                   ,b.AdjustmentReason51
                   ,b.AdjustmentAmount51
                   ,b.AdjustmentQuantity51
                   ,b.AdjustmentGroupCode52
                   ,b.AdjustmentReason52
                   ,b.AdjustmentAmount52
                   ,b.AdjustmentQuantity52
                   ,b.AdjustmentGroupCode53
                   ,b.AdjustmentReason53
                   ,b.AdjustmentAmount53
                   ,b.AdjustmentQuantity53
                   ,b.AdjustmentGroupCode54
                   ,b.AdjustmentReason54
                   ,b.AdjustmentAmount54
                   ,b.AdjustmentQuantity54
                   ,CASE WHEN ( b.LineItemControlNumber IS NULL )
                              OR ( EXISTS ( SELECT  1
                                            FROM    dbo.ERClaimLineItemLog a
                                            WHERE   a.ERClaimLineItemId = b.ERClaimLineItemId
                                                    AND ISNULL(a.RecordDeleted, 'N') <> 'Y'
                                                    AND a.ERMessageType = 5235 ) )
                              OR ( erbp.PaymentId IS NULL ) THEN 'Y'
                         ELSE 'N'
                    END AS CouldNotPost
             FROM   ERClaimLineItems b
                    JOIN #ERClaimLineItemMessages eclim
                        ON b.ERClaimLineItemId = eclim.ERClaimLineItemId
                    LEFT JOIN dbo.ERBatchPayments AS erbp
                        ON erbp.ERBatchPaymentId = b.ERBatchPaymentId
                    JOIN ERBatches c
                        ON ( b.ERBatchId = c.ERBatchId )
                    LEFT JOIN #ERClaimLineItemServices eclis
                        ON eclis.ClaimLineItemId = b.ClaimLineItemId
             WHERE  ERFileId = @ERFileId
		

       END


GO


