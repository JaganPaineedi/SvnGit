/****** Object:  StoredProcedure [dbo].[ssp_SCAutoPaymentPosting]    Script Date: 10/13/2016 08:55:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[ssp_SCAutoPaymentPosting]
    @PaymentId INT = NULL ,
    @UserCode VARCHAR(30) = NULL
AS /*********************************************************************/ 
/* Stored Procedure: dbo.ssp_SCAutoPaymentPosting            */ 
/* Creation Date:    15/July/2014                */ 
/* Purpose:  Auto payment posting for TypeOfPosting =Oldest Balance First and can be called in SQL job  */ 
/*    Exec ssp_SCAutoPaymentPosting                                          */
/* Input Parameters:                           */ 
/*  Date			Author			Purpose              */ 
/* 15/July/2014		Gautam			Created    task #135 ,Automatically Post Payments,Philhaven Development           */ 
/* 13/May/2015     	Gautam          Added code for Client Balalnce and  the Order for Posting,Task#292, Allegan 3.5 Implementation				*/
/* 16/Dec/2015       Dknewtson      What: Updating the #Balance table's balance for the charge/service record after posting.
                                    Why:  Process did not identify it had already paid for the charge/service so continued posting subsequent payments to the charge/service.*/
/* 11/Feb/2015       Dknewtson      What: Did the above for Copayments.
                                    Why:  Same reason*/
/* 13/Oct/2016		 Njain			If there is copay allocated and Service is still in Scheduled/Show status, then do not apply that to other services */                                  
/* 28/Feb/2017		 NJain			Added parameter @PaymentToPost
									In the #ServiceCursor cursor, added Order By CopaymentId DESC as the first criteria
									Philhaven Support #155
*/  
  /*********************************************************************/ 
    BEGIN 
        DECLARE @PostedAccountingPeriodId INT
        DECLARE @ClientId INT 
        DECLARE @Charge MONEY 
        DECLARE @UnPostedAmount MONEY  
        DECLARE @CopaymentAmount MONEY 
        DECLARE @CopaymentId INT           
        DECLARE @CurrentDate DATETIME            
        DECLARE @FinancialActivityId INT
        DECLARE @DateOfService DATETIME
        DECLARE @ChargeId INT
        DECLARE @CopayChargeId INT
        DECLARE @Balance MONEY
        DECLARE @ServiceId INT
        DECLARE @SelectedPaymentId INT
        DECLARE @PaymentToPost MONEY
        
	
        BEGIN TRY
            SELECT  @CurrentDate = GETDATE()
            SELECT  @UserCode = ISNULL(@UserCode, 'AutoPaymentPosting')
            CREATE TABLE #Balance
                (
                  ServiceId INT ,
                  ClientId INT ,
                  DateOfService DATETIME ,
                  Charge MONEY ,
                  ChargeId INT ,
                  Balance MONEY ,
                  CopayAmount MONEY ,
                  CopaymentId INT ,
                  PaymentId INT
                )                
		
            CREATE TABLE #Payment
                (
                  PaymentId INT ,
                  ClientId INT ,
                  UnPostedAmount MONEY ,
                  FinancialActivityId INT
                )  
			-- Select Payment details based on Input parameter or all Unposted payment for night job                              
            INSERT  INTO #Payment
                    SELECT  P.PaymentId ,
                            P.ClientId ,
                            ISNULL(P.UnpostedAmount, 0) ,
                            P.FinancialActivityId --,@CopaymentAmount = ISNULL(CopaymentAmount,0)
                    FROM    Payments P
                            JOIN FinancialActivities FA ON P.FinancialActivityId = FA.FinancialActivityId
                                                           AND P.ClientId = FA.ClientId
                                                           AND ISNULL(FA.RecordDeleted, 'N') = 'N'
                    WHERE   ( P.PaymentId = @PaymentId
                              OR @PaymentId IS NULL
                            )
                            AND FA.ActivityType = 4325
                            AND ISNULL(P.UnpostedAmount, 0) > 0
                            AND ISNULL(P.RecordDeleted, 'N') = 'N'
                            AND P.TypeOfPosting = 8711 ---Oldest Balance First
                    ORDER BY P.PaymentId
                    
                    
                 
   -- If there is copay allocated and Service is still in Scheduled/Show status, then remove that from the unposted amount
            UPDATE  a
            SET     UnPostedAmount = ISNULL(UnPostedAmount, 0) - ISNULL(( SELECT    SUM(ISNULL(pc.Copayment, 0))
                                                                          FROM      dbo.PaymentCopayments pc
                                                                                    JOIN dbo.Services s ON s.ServiceId = pc.ServiceId
                                                                          WHERE     pc.PaymentId = a.PaymentId
                                                                                    AND s.Status IN ( 70, 71 )
                                                                                    AND ISNULL(pc.Applied, 'N') = 'N'
                                                                                    AND ISNULL(s.RecordDeleted, 'N') = 'N'
                                                                                    AND ISNULL(pc.RecordDeleted, 'N') = 'N'
                                                                          GROUP BY  pc.PaymentId
                                                                        ), 0)
            FROM    #Payment a 
                    
                    
                    
				--4325 FINANCIALACTIVITY   	Client Payment
				
				--Update P
				--Set P.UnPostedAmount =P.UnPostedAmount - PayData.CopayAmount
				--From #Payment P Join ( Select PC1.PaymentId ,Sum(Isnull(PC1.Copayment,0)) CopayAmount From PaymentCopayments PC1 Join #Payment P1
				--						On PC1.PaymentId=P1.PaymentId Where  ISNULL(PC1.RecordDeleted, 'N') = 'N' And ISnull(PC1.Applied,'N')='N'
				--						Group by PC1.PaymentId ) PayData On P.PaymentId=PayData.PaymentId
										
		-- Select services related to ClientID in Payments table where Balance >0 in OpenCharges		
            INSERT  INTO #Balance
                    SELECT  S.ServiceId ,
                            C.ClientId ,
                            S.DateOfService ,
                            S.Charge ,
                            Ch.ChargeId ,
                            0 ,
                            ISNULL(PC.Copayment, 0) ,
                            PC.PaymentCopaymentId ,
                            P.PaymentId
                    FROM    OpenCharges OC
                            JOIN Charges Ch ON ( Ch.ChargeId = OC.ChargeId )
                                               AND ISNULL(Ch.RecordDeleted, 'N') = 'N'
                            JOIN Services S ON Ch.ServiceId = S.ServiceId
                                               AND ISNULL(S.RecordDeleted, 'N') = 'N'
                            JOIN #Payment P ON S.ClientId = P.ClientId
                            JOIN Clients C ON S.ClientId = C.ClientId
                            LEFT JOIN PaymentCopayments PC ON PC.ServiceId = S.ServiceId
                                                              AND PC.PaymentId = P.PaymentId
                                                              AND ISNULL(PC.Applied, 'N') = 'N'
                                                              AND ISNULL(PC.RecordDeleted, 'N') = 'N'
                                                              AND Ch.ClientCoveragePlanId IS NULL
                    WHERE   S.Status <> 76
                            AND OC.Balance > 0
                    ORDER BY S.DateOfService DESC
	
            UPDATE  b
            SET     b.Balance = l.ClientBal
            FROM    #Balance b
                    INNER JOIN ( SELECT OpenCharges.Balance AS [ClientBal] ,
                                        Charges.ChargeId
                                 FROM   Services
                                        LEFT JOIN Charges ON Services.ServiceId = Charges.ServiceId
                                        LEFT JOIN OpenCharges ON OpenCharges.ChargeID = Charges.ChargeId
                                 WHERE  Charges.priority = 0
                                        AND OpenCharges.Balance > 0
                                        AND ( ( Services.RecordDeleted = 'N' )
                                              OR ( Services.RecordDeleted IS NULL )
                                            )
                                        AND ( ( Charges.RecordDeleted = 'N' )
                                              OR ( Charges.RecordDeleted IS NULL )
                                            )
                                        AND ( ( OpenCharges.RecordDeleted = 'N' )
                                              OR ( OpenCharges.RecordDeleted IS NULL )
                                            )
                               ) l ON l.ChargeId = b.ChargeId   
   --       Select @ClientId = ClientId, @ProcedureCodeId = ProcedureCodeId, @DateOfService = DateOfService, @EndDate = EndDateOfService, @ClinicianId = ClinicianId,        
			--@ChargeAmount = nullif(Charge,0),@ProcedureRateId = ProcedureRateId  from Services where ServiceId=@ServiceId  
              
            SELECT  @PostedAccountingPeriodId = AccountingPeriodId
            FROM    AccountingPeriods
            WHERE   StartDate <= @CurrentDate
                    AND DATEADD(dd, 1, EndDate) > @CurrentDate  
		
            DECLARE #PaymentCursor CURSOR FAST_FORWARD
            FOR
                SELECT  PaymentId ,
                        ClientId ,
                        UnPostedAmount ,
                        FinancialActivityId
                FROM    #Payment p
                ORDER BY CASE WHEN EXISTS ( SELECT  1
                                            FROM    #Balance b
                                            WHERE   b.PaymentId = p.PaymentId
                                                    AND b.CopayAmount > 0 ) THEN 1
                              ELSE 2
                         END ASC
				
            OPEN #PaymentCursor 

            FETCH #PaymentCursor INTO @SelectedPaymentId, @ClientId, @UnPostedAmount, @FinancialActivityId
            WHILE @@fetch_status = 0
                BEGIN	
                    DECLARE #ServiceCursor CURSOR FAST_FORWARD
                    FOR
                        SELECT  ServiceId ,
                                ClientId ,
                                DateOfService ,
                                Charge ,
                                ChargeId ,
                                Balance ,
                                CopayAmount ,
                                CopaymentId ,
                                CopayAmount AS PaymentToPost
                        FROM    #Balance
                        WHERE   PaymentId = @SelectedPaymentId
                                AND ( Balance > 0
                                      OR CopayAmount > 0
                                    )
                        ORDER BY CopaymentId DESC ,
                                DateOfService ASC ,
                                CopayAmount DESC
				
                    OPEN #ServiceCursor 
                    FETCH #ServiceCursor INTO @ServiceId, @ClientId, @DateOfService, @Charge, @ChargeId, @Balance, @CopaymentAmount, @CopaymentId, @PaymentToPost
                    WHILE ( @@fetch_status = 0 )
                        AND ( @UnPostedAmount > 0 )
                        BEGIN
                            IF @CopaymentAmount > 0 
								-- Post CoPay amount first
                                BEGIN	
							-- Check  if a Charges record exists for the client and Copay was not posted against that
                                    IF EXISTS ( SELECT  1
                                                FROM    Charges
                                                WHERE   ServiceId = @ServiceId
                                                        AND ClientCoveragePlanId IS NULL
                                                        AND ISNULL(RecordDeleted, 'N') = 'N' )
                                        AND NOT EXISTS ( SELECT 1
                                                         FROM   ARLedger
                                                         WHERE  ChargeId = @ChargeId
                                                                AND CoveragePlanId IS NULL
                                                                AND LedgerType = 4204
                                                                AND PaymentId = @SelectedPaymentId
                                                                AND ISNULL(RecordDeleted, 'N') = 'N' )
                                        BEGIN		
									-- Get the charge details for Copay entry					 				 
                                            SELECT  @DateOfService = S.DateOfService ,
                                                    @CopayChargeId = Ch.ChargeId
                                            FROM    Services S
                                                    JOIN Charges Ch ON Ch.ServiceId = S.ServiceId
                                                                       AND ISNULL(S.RecordDeleted, 'N') = 'N'
                                                                       AND ISNULL(Ch.RecordDeleted, 'N') = 'N'
                                            WHERE   S.ServiceId = @ServiceId
                                                    AND Ch.ClientCoveragePlanId IS NULL
									
                                            EXEC ssp_PMPaymentAdjustmentPost @UserCode, @FinancialActivityId, @SelectedPaymentId, NULL, @CopayChargeId, @ServiceId, @DateOfService, @ClientId, NULL, @PostedAccountingPeriodId, NULL, NULL, @PaymentToPost
									-- Set Applied after posting
                                            UPDATE  PC1
                                            SET     PC1.Applied = 'Y'
                                            FROM    PaymentCopayments PC1
                                            WHERE   PC1.PaymentCopaymentId = @CopaymentId

                        -- need to let subsequent runs of the payments cursor know this service/charge no longer has a balance
                                            UPDATE  B
                                            SET     B.Balance = B.Balance - @CopaymentAmount
                                            FROM    #Balance B
                                            WHERE   B.ServiceId = @ServiceId
                                                    AND B.ChargeId = @CopayChargeId
											
                                            SET @UnPostedAmount = @UnPostedAmount - @PaymentToPost
                                        END
                                END
                            ELSE
                                BEGIN	
                                    IF @UnPostedAmount > 0
                                        BEGIN
                                            IF @UnPostedAmount < @Balance
                                                BEGIN
										-- If UnPostedAmount < Balance then this serviceId will be Adjusted by next Payments if available
                                                    SET @Balance = @UnPostedAmount
                                                END
									
                                            EXEC ssp_PMPaymentAdjustmentPost @UserCode, @FinancialActivityId, @SelectedPaymentId, NULL, @ChargeId, @ServiceId, @DateOfService, @ClientId, NULL, @PostedAccountingPeriodId, NULL, NULL, @Balance
								
                        -- need to let subsequent runs of the payments cursor know this service/charge no longer has a balance
                                            UPDATE  B
                                            SET     B.Balance = B.Balance - @Balance
                                            FROM    #Balance B
                                            WHERE   B.ServiceId = @ServiceId
                                                    AND B.ChargeId = @ChargeId
										
                                            SET @UnPostedAmount = @UnPostedAmount - @Balance
                                        END
                                END
                            FETCH #ServiceCursor INTO @ServiceId, @ClientId, @DateOfService, @Charge, @ChargeId, @Balance, @CopaymentAmount, @CopaymentId, @PaymentToPost
                        END  -- Fetch

                    CLOSE #ServiceCursor
                    DEALLOCATE #ServiceCursor
                    FETCH #PaymentCursor INTO @SelectedPaymentId, @ClientId, @UnPostedAmount, @FinancialActivityId
                END  -- Fetch

            CLOSE #PaymentCursor
            DEALLOCATE #PaymentCursor
		-- To display UnpostedAmount to link on Payment/Adjustment screen
            IF @PaymentId IS NOT NULL
                BEGIN
                    SELECT  UnpostedAmount
                    FROM    Payments
                    WHERE   PaymentId = @PaymentId                  
                END
		
		
        END TRY 

        BEGIN CATCH 
            DECLARE @Error VARCHAR(MAX) 
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCAutoPaymentPosting') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE()) 

            RAISERROR ( @Error, 
                      -- Message text.                                                                                 
                      16, 
                      -- Severity.                                                                                 
                      1 
          -- State.                                                                                 
          ); 
        END CATCH 
    END 


GO
