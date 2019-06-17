IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'ssp_PMClientAccountPaymentHistory')
                    AND type IN ( N'P', N'PC' ) )
    BEGIN 
        DROP PROCEDURE ssp_PMClientAccountPaymentHistory; 
    END;
                    GO

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

CREATE PROCEDURE [dbo].[ssp_PMClientAccountPaymentHistory]
    @ClientID INT ,
    @IsClient CHAR(1) ,
    @SortExpression VARCHAR(100) ,
    @Dates INT
AS /****************************************************************************** 
** File: ssp_PMClientAccountPaymentHistory.sql
** Name: ssp_PMClientAccountPaymentHistory
** Desc:  
** 
** 
** This template can be customized: 
** 
** Return values: Filter Values - Client Accoutns tab
** 
** Called by: 
** 
** Parameters: 
** Input Output 
** ---------- ----------- 
** N/A   Dropdown values
** Auth: Mary Suma
** Date: 14/06/2011
******************************************************************************* 
** Change History 
******************************************************************************* 
** Date: 			Author: 			Description: 
** 14/06/2011		Mary Suma			Query to return Client Account Details
-------- 			-------- 			--------------- 
** 11/14/2016       jcarlson			only 1 line needs to be displayed per payment, moved to 4.x svn thread
** 01/03/2016	     jcarlson			merge in Tom's recommended changes
								when finding payments by payer constrain by client id in the clientcoverageplan table instead of arledger
** 01/19/2017		NJain				Updated to do ABS after summing the payment ledgers. SUM(ABS(ar.Amount)) changed to ABS(SUM((ar.Amount)))	
** 03/28/2017		NJain				Updated to reverse the sign of Payment Amount retrieved from ARLedger. Posted Payments should display positive on the UI. Take backs should display	as negative	Bradford SGL #373	
** 12/28/2017		Neelima				Updated the Payer to VARCHAR(max) since its throwing string error when opening ClientAccounts banner KCMHSAS - Support #914					
*******************************************************************************/

    DECLARE @FromDate DATETIME;
    BEGIN                                                              
        BEGIN TRY

            SET @SortExpression = RTRIM(LTRIM(@SortExpression));
            IF ISNULL(@SortExpression, '') = ''
                SET @SortExpression = 'Payer';
		
            CREATE TABLE #ResultSet
                (
                  RowNumber INT ,                                                  
			--PageNumber				INT,
                  PaymentId INT ,
                  FinancialActivityId INT ,
                  PayerId INT ,
                  CoveragePlanId INT ,
                  ClientID INT ,
                  Payer VARCHAR(max) ,  --Modified by Neelima
                  DateReceived DATETIME ,
                  Amount MONEY ,
                  UnpostedAmount MONEY ,
                  ReferenceNumber VARCHAR(50) ,
                  SessionId VARCHAR(50) ,
                  InstanceId INT ,
                  RecordDeleted CHAR(1)
                );    
		     
            IF @Dates = 1
                SET @FromDate = NULL;
            ELSE
                SET @FromDate = DATEADD(dd, CASE @Dates
                                              WHEN 2 THEN -30
                                              WHEN 3 THEN -60
                                              WHEN 4 THEN -90
                                            END, CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101)));     
			
            INSERT  INTO #ResultSet
                    ( PaymentId ,
                      FinancialActivityId ,
                      PayerId ,
                      CoveragePlanId ,
                      ClientID ,
                      Payer ,
                      DateReceived ,
                      Amount ,
                      UnpostedAmount ,
                      ReferenceNumber ,
                      RecordDeleted
		            )
                    SELECT  PY.PaymentId ,
                            PY.FinancialActivityId ,
                            PY.PayerId ,
                            PY.CoveragePlanId ,
                            PY.ClientId ,
                            RTRIM(cp.DisplayAs) + ' ' + ISNULL(ccp.InsuredId, '') AS Payer ,
                            PY.DateReceived ,
                            -( SUM(( ar.Amount )) ) AS Amount ,
                            PY.UnpostedAmount AS UnpostedAmount ,
                            PY.ReferenceNumber ,
                            PY.RecordDeleted
                    FROM    Payments PY
                            JOIN ARLedger AS ar ON ar.PaymentId = PY.PaymentId
                            JOIN Charges AS c ON c.ChargeId = ar.ChargeId
                            JOIN ClientCoveragePlans AS ccp ON c.ClientCoveragePlanId = ccp.ClientCoveragePlanId
                            JOIN CoveragePlans cp ON ccp.CoveragePlanId = cp.CoveragePlanId
                    WHERE   ISNULL(PY.RecordDeleted, 'N') = 'N'
                            AND ( @FromDate IS NULL
                                  OR PY.DateReceived >= @FromDate
                                )
                            AND ccp.ClientId = @ClientID
                            AND ISNULL(cp.Capitated, 'N') = 'N'
                    GROUP BY PY.PaymentId ,
                            PY.FinancialActivityId ,
                            PY.PayerId ,
                            PY.CoveragePlanId ,
                            PY.ClientId ,
                            RTRIM(cp.DisplayAs) + ' ' + ISNULL(ccp.InsuredId, '') ,
                            PY.DateReceived ,
                            PY.UnpostedAmount ,
                            PY.ReferenceNumber ,
                            PY.RecordDeleted
                    UNION ALL
                    SELECT  py.PaymentId ,
                            py.FinancialActivityId ,
                            py.PayerId ,
                            py.CoveragePlanId ,
                            py.ClientId ,
                            'Client' AS Payer ,
                            py.DateReceived ,
                            py.Amount AS Amount ,
                            py.UnpostedAmount AS UnpostedAmount ,
                            py.ReferenceNumber ,
                            py.RecordDeleted
                    FROM    Payments py
                    WHERE   ISNULL(py.RecordDeleted, 'N') = 'N'
                            AND py.ClientId = @ClientID
                            AND ( @FromDate IS NULL
                                  OR py.DateReceived >= @FromDate
                                )
                    ORDER BY Payer;  
		  
            UPDATE  d
            SET     RowNumber = rn.RowNumber                         
				--,PageNumber = (rn.RowNumber/@PageSize) + CASE WHEN rn.RowNumber % @PageSize = 0 THEN 0 ELSE 1 END                                        
            FROM    #ResultSet d
                    JOIN ( SELECT   PaymentId ,
                                    ROW_NUMBER() OVER ( ORDER BY CASE WHEN @SortExpression = 'Payer' THEN Payer
                                                                 END, CASE WHEN @SortExpression = 'Payer desc' THEN Payer
                                                                      END DESC, CASE WHEN @SortExpression = 'DateReceived' THEN DateReceived
                                                                                END, CASE WHEN @SortExpression = 'DateReceived desc' THEN DateReceived
                                                                                     END DESC, CASE WHEN @SortExpression = 'Amount' THEN Amount
                                                                                               END, CASE WHEN @SortExpression = 'Amount desc' THEN Amount
                                                                                                    END DESC, CASE WHEN @SortExpression = 'UnpostedAmount' THEN UnpostedAmount
                                                                                                              END, CASE WHEN @SortExpression = 'UnpostedAmount desc' THEN UnpostedAmount
                                                                                                                   END DESC, CASE WHEN @SortExpression = 'ReferenceNumber' THEN ReferenceNumber
                                                                                                                             END, CASE WHEN @SortExpression = 'ReferenceNumber desc' THEN ReferenceNumber
                                                                                                                                  END DESC, PaymentId ) AS RowNumber
                           FROM     #ResultSet
                         ) rn ON rn.PaymentId = d.PaymentId; 
		
            SELECT  ISNULL(MAX(RowNumber), 0) AS NumberOfRows
            FROM    #ResultSet;                                        
		
            IF ( ISNULL(@IsClient, 'N') = 'N' )
                SELECT  PaymentId ,
                        FinancialActivityId ,
                        Payer ,
                        DateReceived ,
                        Amount ,
                        ReferenceNumber ,
                        UnpostedAmount ,
                        RecordDeleted
                FROM    #ResultSet a
                ORDER BY RowNumber;
            ELSE
                SELECT  PaymentId ,
                        FinancialActivityId ,
                        Payer ,
                        DateReceived ,
                        Amount ,
                        ReferenceNumber ,
                        UnpostedAmount ,
                        RecordDeleted
                FROM    #ResultSet a
                WHERE   Payer = 'Client'
                ORDER BY RowNumber;
	
        END TRY
	
        BEGIN CATCH
            DECLARE @Error VARCHAR(8000);       
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_PMClientAccountPaymentHistory') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());
            RAISERROR
		(
			@Error, -- Message text.
			16,		-- Severity.
			1		-- State.
		);
        END CATCH;
    END;

GO

