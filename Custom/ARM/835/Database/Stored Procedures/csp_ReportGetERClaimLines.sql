IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   OBJECT_ID = OBJECT_ID(N'[dbo].[csp_ReportGetERClaimLines]')
                    AND TYPE IN ( N'P', N'PC' ) ) 
   DROP PROCEDURE [dbo].[csp_ReportGetERClaimLines]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_ReportGetERClaimLines]  
/******************************************************************************        
**   
**  Name: csp_ReportGetERClaimLines        
**  Desc:         
**  Report of claim line information      
**        
**  Return values:        
**         
**  Called by:   My Reports and used as a subreport
**                      
**  Parameters:   csp_ReportGetERFileSummary @ERFileId
**        
**  Auth:         
**  Date:         
*******************************************************************************        
**  Change History        
*******************************************************************************        
**  Date:     Author:		Description:        
** 9/27/2012  TER			Created    
-- 06.16.2013  T.Remisoski	Exlcude outcomes billing codes from the report
-- 12.02.2013  David K		Removed Outcomes billing code exclusion for standardization
-- 12.04.2015	 Jcarlson		Added in SC Posted Amount,ClientCoPay,Adjustments fields
*******************************************************************************/ @ERFileId INT
AS 
       BEGIN
--DECLARE @ProcessedStatus CHAR(1)
--select @ProcessedStatus=ISNULL(Processed,'N') from ERFiles where ERFileId = @ERFileId 
--IF @ProcessedStatus ='N'
--	EXEC csp_ReportGetERClaimLines @ERFileId,@UserId
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

             SELECT ecli.ERClaimLineItemId
                   ,ISNULL(SUM(eclia.AdjustmentAmount), 0.00) * -1 AS TotalAdjustments
             INTO   #ClaimLineAdjustments
             FROM   dbo.ERClaimLineItems ecli
                    JOIN dbo.ERClaimLineItemAdjustments eclia ON ecli.ERClaimLineItemId = eclia.ERClaimLineItemId
                     AND ISNULL(eclia.RecordDeleted,'N') <> 'Y'
             GROUP BY ecli.ERClaimLineItemId

            -- the client's current charge ignoring payments/adjustments
             SELECT clic.ClaimLineItemId
                   ,ISNULL(SUM(al.Amount), 0.00) AS PatientResponsibility
             INTO   #ClaimLinePatientResponsibility
             FROM   #ClaimLineItemCharges clic
                    JOIN Charges c
                        ON clic.ChargeId = c.ChargeId
                    JOIN dbo.Charges c2
                        ON c.ServiceId = c2.ServiceId
                           AND c2.ClientCoveragePlanId IS NULL
                    JOIN dbo.ARLedger al
                        ON al.ChargeId = c2.ChargeId
                           AND ISNULL(al.RecordDeleted, 'N') <> 'Y'
                           AND al.LedgerType IN ( 4204, 4201 )
             GROUP BY clic.ClaimLineItemId                     

             SELECT a.ERBatchId
                   ,b.CheckDate
                   ,c.ClientIdentifier
                   ,c.ClientName
                   ,c.BillingCode
                   ,c.DateOfService
                   ,c.ChargeAmount AS ChargeAmount
                   ,c.PaidAmount AS PaidAmount
                   ,f.[FileName]
                   ,f.ImportDate
                   ,f.ERFileId
                   ,b.PaymentId
                   ,ISNULL(clp.SCPaid, 0.00) AS [SC Amount]
                   ,ISNULL(cla.TotalAdjustments, 0.00) AS TotalAdjustments
                   ,ISNULL(clpr.PatientResponsibility, 0.00) AS PatientResponsibility
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
                    LEFT JOIN #ClaimLineAdjustments cla
                        ON c.ERClaimLineItemId = cla.ERClaimLineItemId
                    LEFT JOIN #ClaimLinePatientResponsibility clpr
                        ON c.ClaimLineItemId = clpr.ClaimLineItemId
             WHERE  a.ERFileId = @ERFileId
--and b.PaymentId is null
		-- do not include outcomes measures data
             ORDER BY a.ERBatchId
                   ,a.CheckDate
                   ,c.ClientName
                   ,CASE WHEN c.ClientIdentifier LIKE '%-%' THEN RIGHT(c.ClientIdentifier,CHARINDEX('-',c.ClientIdentifier)) ELSE c.ClientIdentifier END
                   ,c.DateOfService
                   ,c.ERClaimLineItemId

       END

GO