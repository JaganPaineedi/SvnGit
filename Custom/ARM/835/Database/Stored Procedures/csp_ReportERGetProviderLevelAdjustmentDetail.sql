IF OBJECT_ID('csp_ReportERGetProviderLevelAdjustmentDetail') IS NOT NULL 
   DROP PROCEDURE csp_ReportERGetProviderLevelAdjustmentDetail
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE csp_ReportERGetProviderLevelAdjustmentDetail @ERFileId INT
AS 
       BEGIN 
/**************************************************************************************
   Procedure: csp_ReportERGetProviderLevelAdjustmentDetail
   
   Streamline Healthcare Solutions, LLC Copyright 2015

   Purpose: Identify all Provider level Adjustments that are included in a check

   Parameters: 
      @ERFileId - INT - ERFileId from ERFile table

   Output: 
      ERBatchProviderAdjustmentId - INT - Identifier from ERBatchProviderAdjusments
      ERBatchId - INT - Identifier from ERBatches
      CheckNumber - Varchar(30) - the check number from 835 (BPR segment)
      CheckAmount - type_Money - check amount from 835 (BPR Segment)
      SCAmount - type_Money - Sum of payments from Payment table for the ERBatch
      AdjustmentAmount - Amount of the provider level adjustment
      AdjustmentIdentifier - identifier element included from PLB segment

   Called By: Report RDLGetERProviderLevelAdjustments
*****************************************************************************************
   Revision History:
   09-DEC-2015 - Dknewtson - Created

*****************************************************************************************/

            
             SELECT ERBatchProviderAdjustmentId
                   ,ERBatchId
                   ,AdjustmentAmount
                   ,AdjustmentType1
                   ,AdjustmentIdentifier
                   ,AdjustmentType2
             INTO   #PLAdjusments
             FROM   (
                      SELECT    ebpa.ERBatchProviderAdjustmentId
                               ,ebpa.ERBatchId
                               ,ebpa.AdjustmentIdentifier1
                               ,ebpa.AdjustmentAmount1
                               ,ebpa.AdjustmentIdentifier2
                               ,ebpa.AdjustmentAmount2
                               ,ebpa.AdjustmentIdentifier3
                               ,ebpa.AdjustmentAmount3
                               ,ebpa.AdjustmentIdentifier4
                               ,ebpa.AdjustmentAmount4
                               ,ebpa.AdjustmentIdentifier5
                               ,ebpa.AdjustmentAmount5
                               ,ebpa.AdjustmentIdentifier6
                               ,ebpa.AdjustmentAmount6
                      FROM      ERBatchProviderAdjustments ebpa
                                JOIN dbo.ERBatches eb
                                    ON ebpa.ERBatchId = eb.ERBatchId
                                JOIN dbo.ERFiles ef
                                    ON ef.ERFileId = eb.ERFileId
                                       AND ISNULL(ef.RecordDeleted, 'N') <> 'Y'
                      WHERE     ISNULL(eb.RecordDeleted, 'N') <> 'Y'
                                AND ef.ERFileId = @ERFileId
                    ) p UNPIVOT ( AdjustmentAmount FOR AdjustmentType1 IN ( AdjustmentAmount1, AdjustmentAmount2,
                                                                            AdjustmentAmount3, AdjustmentAmount4,
                                                                            AdjustmentAmount5, AdjustmentAmount6 ) ) AS adjustments
                    UNPIVOT ( AdjustmentIdentifier FOR AdjustmentType2 IN ( AdjustmentIdentifier1, AdjustmentIdentifier2,
                                                                            AdjustmentIdentifier3, AdjustmentIdentifier4,
                                                                            AdjustmentIdentifier5, AdjustmentIdentifier6 ) ) AS AdjustmentId
        
             DELETE FROM #PLAdjusments
             WHERE  RIGHT(AdjustmentType1, 1) <> RIGHT(AdjustmentType2, 1)


             SELECT NULL AS ERBatchProviderAdjustmentId
                   ,eb.ERBatchId
                   ,eb.CheckNumber
                   ,eb.CheckAmount
                   ,CAST(ISNULL(SUM(p.Amount),'0.00') AS MONEY) AS SCAmount
                   ,CAST(ISNULL(SUM(p.Amount-p.UnpostedAmount),'0.00') AS MONEY) AS SCAmountPosted
                   ,CAST('0.00' AS MONEY) AS AdjustmentAmount
                   ,'No Provider Adjustments Included' AS AdjustmentIdentifier
             FROM   dbo.ERBatches eb
                    JOIN dbo.ERBatchPayments ebp
                        ON eb.ERBatchId = ebp.ERBatchId
                           AND ISNULL(ebp.RecordDeleted, 'N') <> 'Y'
                    LEFT JOIN dbo.Payments p
                        ON ebp.PaymentId = p.PaymentId
                           AND ISNULL(p.RecordDeleted, 'N') <> 'Y'
             WHERE  ISNULL(eb.RecordDeleted, 'N') <> 'Y'
                    AND NOT EXISTS ( SELECT 1
                                     FROM   #PLAdjusments pa
                                     WHERE  pa.ERBatchId = eb.ERBatchId )
                    AND eb.ERFileId = @ERFileId
             GROUP BY 
                   eb.ERBatchId
                   ,eb.CheckNumber
                   ,eb.CheckAmount
             UNION ALL
             SELECT pa.ERBatchProviderAdjustmentId
                   ,pa.ERBatchId
                   ,eb.CheckNumber
                   ,eb.CheckAmount
                   ,CAST(ISNULL(SUM(p.Amount),'0.00') AS MONEY) AS SCAmount
                   ,CAST(ISNULL(SUM(p.Amount-p.UnpostedAmount),'0.00') AS MONEY) AS SCAmountPosted
                   ,pa.AdjustmentAmount
                   ,pa.AdjustmentIdentifier
             FROM   #PLAdjusments pa
                    JOIN dbo.ERBatches eb
                        ON pa.ERBatchId = eb.ERBatchId
                    JOIN dbo.ERBatchPayments ebp
                        ON eb.ERBatchId = ebp.ERBatchId
                           AND ISNULL(ebp.RecordDeleted, 'N') <> 'Y'
                    LEFT JOIN dbo.Payments p
                        ON ebp.PaymentId = p.PaymentId
                           AND ISNULL(p.RecordDeleted, 'N') <> 'Y'
             GROUP BY pa.ERBatchProviderAdjustmentId
                   ,pa.ERBatchId
                   ,eb.CheckNumber
                   ,eb.CheckAmount
                   ,pa.AdjustmentAmount
                   ,pa.AdjustmentType1
                   ,pa.AdjustmentIdentifier


             DROP TABLE #PLAdjusments

       END