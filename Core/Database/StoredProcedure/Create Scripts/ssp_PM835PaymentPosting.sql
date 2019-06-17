IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_PM835PaymentPosting]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [dbo].[ssp_PM835PaymentPosting]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[ssp_PM835PaymentPosting]
    @UserId INT ,
    @ERFileId INT
AS /*********************************************************************/      
/* Stored Procedure: ssp_835_payment_posting                   */      
/* Creation Date:    8/07/01                                         */      
/*                                                                   */      
/* Purpose:                 */      
/*                                                                   */ /* Input Parameters:           */      
/*                                                                   */      
/* Output Parameters:                                                */      
/*                                                                   */      
/* Return Status:                                                    */      
/*                                                                   */      
/* Called By:        SQL Server task scheduler        */      
/*                                                                   */      
/* Calls:                                                            */      
/*                                                                   */      
/* Data Modifications:                                               */      
/*                                                                   */      
/* Updates:                                                          */      
/*   Date  Author      Purpose                                    */      
/*  8/07/01  JHB   Created                                    */      
/*  1/16/04  JHB   Modified to post refunds from current payment */      
/*  04/04/12 MSuma  Modified Custom table to core  */    
/*  04/09/12 MSuma  Modified ERErrorType */    
--  06/15/12 MSuma  RTRIM(@CheckNumber) to avoid concurrency error 
/*  08/15/16 NJain	Removed the adjustments validation. 835 Process now posts adjustments */
/*  09/22/16 NJain	Added functionality to create payments by Payer using ERFileToPayerMapping	*/
/*  10/10/16 MJensen	Corrected error code in output to ERClaimLineItemLog */
/*  10/13/16 NJain	Updated to only match on ERPayerIdentifier when its set up*/
/*  12/30/16 jcarlson Camino Support Go Live 11.3
				  When creating payments by payer
				  Fixed bug where we were checking to see if the key "CREATE835PAYMENTSBYPAYER" 
				  was set to N instead of Y
				  This could cause the system to try and create a payment record with no Amount value ( error out )*/
/*	01/20/16 NJain	Bradford SGL #307 - Updated to get Check Number from ERBatches for Payments by Payer	 */				  
/*	04/13/17 MJensen	Thresholds Support #906 Updated to get Check Number from ERBatches */
/*  01/03/18 Veena      Changed the result message to Processed Successfully instead of no. of lines processed and Error message correction  Key Point - Support Go Live #1144   */
/*  11/17/2018 Dknewtson Removing code to prevent posting payments to errored services - Journey - Support Go Live #351*/
/*  04/04/17 Dknewtson Adding refunds for 835 CORE process when posting payments by payer.*/
/*  04/05/17 NJain	Updated to Drop table #TotalRefund. This is referenced in scsps also */
/*  03/21/2018 Dknewtson The payer on the billed charge won't neccesarily be the payer remitting. Key Point - Support Go live #1144.4 */
/*********************************************************************/      

    DECLARE @ExecuteCoreCode CHAR(1) = 'Y'
    IF OBJECT_ID('scsp_PM835PaymentPosting') IS NOT NULL
        BEGIN
            EXEC scsp_PM835PaymentPosting @UserId, @ERFileId, @ExecuteCoreCode OUTPUT
            IF @ExecuteCoreCode = 'N'
                RETURN
        END
      
    DECLARE @ERBatchId INT      
    DECLARE @ClaimLineItemId INT      
    DECLARE @CheckNumber VARCHAR(30)      
    DECLARE @CheckDate DATETIME      
    DECLARE @Amount DECIMAL(10, 2)      
    DECLARE @TotalExpected DECIMAL(10, 2)      
    DECLARE @TotalClaimPayments DECIMAL(10, 2)      
    DECLARE @PaymentAmount DECIMAL(10, 2)      
    DECLARE @PostedAmount DECIMAL(10, 2)      
    DECLARE @ExpectedSoFar DECIMAL(10, 2)      
    DECLARE @ErrorNo INT      
    DECLARE @CoveragePlanId CHAR(10) 
    DECLARE @ErrorNumber int
    DECLARE @ErrorMessage varchar(255)     
--declare @hosp_status_code char(2)      
    DECLARE @ChargeId CHAR(10)      
    DECLARE @billing_ledger_no CHAR(10)      
    DECLARE @Status CHAR(10)      
    DECLARE @PaymentId INT      
    DECLARE @PayerId INT
    DECLARE @OriginalPaymentId INT      
    DECLARE @ClientId CHAR(10)      
    DECLARE @EpisodeNumber CHAR(3)      
    DECLARE @LastClaimLineItemId INT      
    DECLARE @LastPaymentId INT      
    DECLARE @LastClaimLineItemOk CHAR(1)      
    DECLARE @PaidAmount DECIMAL(10, 2)      
    DECLARE @ClientIdentifier CHAR(10)      
    DECLARE @SeviceFromDate DATETIME      
    DECLARE @charge_Amount DECIMAL(10, 2)      
    DECLARE @DateCreated DATETIME      
    DECLARE @FailedCount INT      
    DECLARE @TotalImport INT      
    DECLARE @ExpectedPayment DECIMAL(10, 2)      
    DECLARE @ClaimLineItemBalance DECIMAL(10, 2)      
    DECLARE @TransferAmount DECIMAL(10, 2)      
    DECLARE @AdjustmentAmount DECIMAL(10, 2)      
    DECLARE @StandardBillingTransactionNo CHAR(10)      
    DECLARE @BLType CHAR(2)      
    DECLARE @CheckNo VARCHAR(30)      
    DECLARE @RefundId INT      
    DECLARE @CurrentDate DATE      
    DECLARE @DenialCode CHAR(10)       
    DECLARE @BeginOldErrorRecords INT      
    DECLARE @EndOldErrorRecords INT      
    DECLARE @Result VARCHAR(1000)      
    DECLARE @OldErrorRecords INT       
    DECLARE @NewRecords INT       
    DECLARE @NewErrorRecords INT       
    DECLARE @CheckNumber2 VARCHAR(30)      
    DECLARE @PaymentId2 INT      
    DECLARE @CheckDate2 DATETIME      
    DECLARE @UserCode VARCHAR(50)      
    DECLARE @PaymentMethod INT      
    DECLARE @PaymentSource INT      
      
      
/*  LOOK INTO --CREATE Config Table      
      
*/      
    SET @PaymentMethod = 4362      
    SET @PaymentSource = 1009237 --SYSTEM FOR NOW... HARDCODED FOR HARBOR AVOSS 08.16.2012      
/*  LOOK INTO --CREATE Config Table      
  select * from globalCodes where category='paymentSource'    
*/      
      
      
      
    CREATE TABLE #temp2 ( result TEXT NULL )      
      
    CREATE TABLE #payments
        (
          ERBatchId INT NOT NULL ,
          ERClaimLineItemId INT NULL ,
          ClaimLineItemId INT NULL ,
          CoveragePlanId INT NULL ,
          PayerId INT NULL ,
          CheckNumber CHAR(30) NULL ,
          CheckDate DATETIME NULL ,
          Amount DECIMAL(18, 2) NOT NULL
        )      
  
  
/*      
create table #payment      
(ERBatchId int not null,      
CoveragePlanId int null,      
--hosp_status_code char(10) not null, srf      
CheckNumber char(30) null,      
CheckDate datetime null,      
Amount decimal(18,2) not null)      
*/  
      
    CREATE TABLE #batches
        (
          ERBatchId INT NOT NULL ,
          SenderBatchId VARCHAR(30) NULL
        )      
      
    SELECT  @TotalImport = COUNT(*)
    FROM    ERClaimLineItems a
            JOIN ERBatches b ON b.ERBatchId = a.ERBatchId
    WHERE   b.ERFileId = @ERFileId
            AND ISNULL(a.RecordDeleted, 'N') = 'N'
            AND ISNULL(b.RecordDeleted, 'N') = 'N'       
      
    SELECT  @UserCode = UserCode
    FROM    Staff
    WHERE   StaffId = @UserId      
      
      
-- Determine the Coverage Plans for line item numbers      
    SELECT  @NewRecords = ISNULL(COUNT(*), 0)
    FROM    ERClaimLineItems a
            JOIN ERBatches b ON b.ERBatchId = a.ERBatchId
    WHERE   b.ERFileId = @ERFileId
            AND ISNULL(a.Processed, 'N') = 'N'
            AND ISNULL(a.RecordDeleted, 'N') = 'N'
            AND ISNULL(b.RecordDeleted, 'N') = 'N'     
      
      
    IF @@error <> 0
        GOTO rollback_tran      
      
-- List new batches      
    INSERT  INTO #batches
            ( ERBatchId ,
              SenderBatchId
            )
            SELECT  a.ERBatchId ,
                    a.SenderBatchId --srf ??      
            FROM    ERBatches a
            WHERE   a.ERFileId = @ERFileId  
/*   
and not exists      
(select * from ElectronicRemittancePaymentLog b      
where a.ERBatchId <= b.ERBatchId)      
and isnull(a.RecordDeleted, 'N')= 'N'      
*/  
  
    IF @@error <> 0
        GOTO rollback_tran      
	

-- Go over each Check	
    DECLARE cur_ERBatches CURSOR
    FOR
        SELECT  ERBatchId
        FROM    #batches
	
	        
    IF @@error <> 0
        GOTO rollback_tran  
        
    OPEN cur_ERBatches
        
    IF @@error <> 0
        GOTO rollback_tran  
        
    FETCH cur_ERBatches INTO @ERBatchId
        
    IF @@error <> 0
        GOTO rollback_tran  
        
    WHILE @@FETCH_STATUS = 0
        BEGIN
        
            BEGIN TRAN
        
            SET @CurrentDate = CAST(GETDATE() AS DATE) 
         
        
        --1. Check if the system config key is set to Y, ERPayer exists in the mapping table and there is only one Payer mapped to the ERPayer OR there is a Payer defined in ERSenders table then create a check by Payer
            IF ( ( EXISTS ( SELECT  *
                            FROM    dbo.SystemConfigurationKeys
                            WHERE   [Key] = 'CREATE835PAYMENTSBYPAYER'
                                    AND ISNULL(Value, 'N') = 'Y' )
                   AND EXISTS ( SELECT  1
                                FROM    dbo.ERBatches a
                                        JOIN dbo.ERFileToPayerMapping b ON b.ERPayerName = a.ERPayerName
                                                                           AND ( ( ISNULL(b.ERPayerIdentifier, '') = ISNULL(a.ERPayerIdentifier, '')
                                                                                   AND ISNULL(b.ERPayerIdentifier, '') <> ''
                                                                                 )
                                                                                 OR ISNULL(b.ERPayerIdentifier, '') = ''
                                                                               )
                                WHERE   ISNULL(a.ERPayerName, '') <> ''
                                        AND b.PayerId IS NOT NULL
                                        AND ISNULL(b.RecordDeleted, 'N') = 'N'
                                        AND a.ERBatchId = @ERBatchId
                                GROUP BY a.ERBatchId
                                HAVING  COUNT(DISTINCT b.PayerId) = 1 )
                 )
                 OR ( EXISTS ( SELECT   1
                               FROM     dbo.ERBatches a
                                        JOIN dbo.ERFiles b ON b.ERFileId = a.ERFileId
                                        JOIN dbo.ERSenders c ON c.ERSenderId = b.ERSenderId
                               WHERE    a.ERBatchId = @ERBatchId
                                        AND c.PayerId IS NOT NULL )
                      AND EXISTS ( SELECT   *
                                   FROM     dbo.SystemConfigurationKeys
                                   WHERE    [Key] = 'CREATE835PAYMENTSBYPAYER'
                                            AND ISNULL(Value, 'N') = 'Y' )
                    )
               )
                BEGIN
        
                    DECLARE @FinancialActivityId INT      
			
                    SELECT  @PayerId = b.PayerId ,
                            @Amount = a.CheckAmount ,
                            @CheckNumber = a.CheckNumber
                    FROM    dbo.ERBatches a
                            JOIN dbo.ERFileToPayerMapping b ON b.ERPayerName = a.ERPayerName
                                                               AND ( ( ISNULL(b.ERPayerIdentifier, '') = ISNULL(a.ERPayerIdentifier, '')
                                                                       AND ISNULL(b.ERPayerIdentifier, '') <> ''
                                                                     )
                                                                     OR ISNULL(b.ERPayerIdentifier, '') = ''
                                                                   )
                    WHERE   ISNULL(a.ERPayerName, '') <> ''
                            AND b.PayerId IS NOT NULL
                            AND ISNULL(b.RecordDeleted, 'N') = 'N'
                            AND a.ERBatchId = @ERBatchId
                            AND EXISTS ( SELECT *
                                         FROM   dbo.SystemConfigurationKeys
                                         WHERE  [Key] = 'CREATE835PAYMENTSBYPAYER'
                                                AND ISNULL(Value, 'N') = 'Y' )
                                    
                                    
                                    
                    SELECT  @PayerId = c.PayerId ,
                            @Amount = a.CheckAmount ,
							@CheckNumber = a.CheckNumber
                    FROM    dbo.ERBatches a
                            JOIN dbo.ERFiles b ON b.ERFileId = a.ERFileId
                            JOIN dbo.ERSenders c ON c.ERSenderId = b.ERSenderId
                    WHERE   a.ERBatchId = @ERBatchId
                            AND c.PayerId IS NOT NULL
                            AND EXISTS ( SELECT *
                                         FROM   dbo.SystemConfigurationKeys
                                         WHERE  [Key] = 'CREATE835PAYMENTSBYPAYER'
                                                AND ISNULL(Value, 'N') = 'Y' ) --jcarlson 12/30/16 change from N to Y
                                    
			
			
                    INSERT  INTO FinancialActivities
                            ( PayerId ,
                              CoveragePlanId ,
                              ClientId ,
                              ActivityType ,
                              CreatedBy ,
                              CreatedDate ,
                              ModifiedBy ,
                              ModifiedDate
                            )
                    VALUES  ( @PayerId ,
                              NULL ,
                              NULL ,
                              4323 ,
                              @UserCode ,
                              GETDATE() ,
                              @UserCode ,
                              GETDATE()
                            )
                    

                    SET @FinancialActivityId = @@Identity      
      
                    IF @FinancialActivityId <= 0
                        BEGIN      
                            ROLLBACK TRANSACTION      
                            select  @ErrorNumber = 30001,@ErrorMessage = 'Invalid Financial Activity (Payment) ID'
                            GOTO error      
                        END      
      
      
                    INSERT  INTO Payments
                            ( FinancialActivityId ,
                              PayerId ,
                              CoveragePlanId ,
                              DateReceived ,
                              NameIfNotClient ,
                              ElectronicPayment ,
                              PaymentMethod ,
                              ReferenceNumber ,
                              Amount ,
                              PaymentSource ,
                              UnpostedAmount ,
                              CreatedBy ,
                              CreatedDate ,
                              ModifiedBy ,
                              ModifiedDate
                            )
                    VALUES  ( @FinancialActivityId ,
                              @PayerId ,
                              NULL ,
                              GETDATE() ,
                              NULL ,
                              'Y' ,
                              @PaymentMethod ,
                              RTRIM(@CheckNumber) ,
                              @Amount ,
                              @PaymentSource ,
                              @Amount ,
                              @UserCode ,
                              GETDATE() ,
                              @UserCode ,
                              GETDATE()
                            )      
        
      
                    SELECT  @PaymentId = @@identity      
      
                    IF @PaymentId <= 0
                        BEGIN      
                            ROLLBACK TRANSACTION      
                            select  @ErrorNumber = 30001,@ErrorMessage = 'Invalid Payment ID' 
                            GOTO error      
                        END      
					DECLARE @PLBPositive INT

					SELECT  @PLBPositive = gc.GlobalCodeId
					FROM    dbo.GlobalCodes AS gc
					WHERE   gc.Category = 'REFUNDTYPE'
							AND gc.CodeName = 'PLB: Provider Level Adjustments (Positive)'
					DECLARE @PLBNegative INT

					SELECT  @PLBNegative = gc.GlobalCodeId
					FROM    dbo.GlobalCodes AS gc
					WHERE   gc.Category = 'REFUNDTYPE'
							AND gc.CodeName = 'PLB: Provider Level Adjustments (Negative)'


					IF OBJECT_ID('tempdb..#Refunds') IS NOT NULL
						DROP TABLE #Refunds
					CREATE TABLE #Refunds
					   (
						  RefundId INT
						  ,ERBatchId INT
						  ,PaymentId INT    
					   )

					INSERT  INTO dbo.Refunds
							( 
							 CreatedBy
							,CreatedDate
							,ModifiedBy
							,ModifiedDate
							,DeletedBy
							,PaymentId
							,Correction
							,Amount
							,RefundDate
							,Comment
							,RefundType
							,RowIdentifier
							)
					OUTPUT  INSERTED.RefundId
						   ,INSERTED.DeletedBy
						   ,INSERTED.PaymentId
							INTO #Refunds ( RefundId, ERBatchId, PaymentId )
							SELECT  @UserCode -- CreatedBy - type_CurrentUser
								   ,GETDATE()-- CreatedDate - type_CurrentDatetime
								   ,@UserCode-- ModifiedBy - type_CurrentUser
								   ,GETDATE()-- ModifiedDate - type_CurrentDatetime
								   ,ebpa.ERBatchId-- DeletedBy - type_UserId
								   ,@PaymentId-- PaymentId - int
								   ,NULL-- Correction - type_YOrN
								   ,-ebpa.AdjustmentAmount1-- Amount - money
								   ,GETDATE()-- RefundDate - datetime
								   ,ebpa.AdjustmentIdentifier1-- Comment - type_Comment
								   ,CASE WHEN ebpa.AdjustmentAmount1 > 0 THEN @PLBPositive ELSE @PLBNegative END-- RefundType - type_GlobalCode -- null for now, it should be changed later.
								   ,NEWID()-- RowIdentifier - type_GUID
							FROM    dbo.ERBatchProviderAdjustments ebpa
							WHERE   ebpa.AdjustmentAmount1 IS NOT NULL
									AND ebpa.ERBatchId = @ERBatchId


					INSERT  INTO dbo.Refunds
							( 
							 CreatedBy
							,CreatedDate
							,ModifiedBy
							,ModifiedDate
							,DeletedBy
							,PaymentId
							,Correction
							,Amount
							,RefundDate
							,Comment
							,RefundType
							,RowIdentifier
							)
					OUTPUT  INSERTED.RefundId
						   ,INSERTED.DeletedBy
						   ,INSERTED.PaymentId
							INTO #Refunds ( RefundId, ERBatchId, PaymentId )
							SELECT  @UserCode -- CreatedBy - type_CurrentUser
								   ,GETDATE()-- CreatedDate - type_CurrentDatetime
								   ,@UserCode-- ModifiedBy - type_CurrentUser
								   ,GETDATE()-- ModifiedDate - type_CurrentDatetime
								   ,ebpa.ERBatchId-- DeletedBy - type_UserId
								   ,@PaymentId-- PaymentId - int
								   ,NULL-- Correction - type_YOrN
								   ,-ebpa.AdjustmentAmount2-- Amount - money
								   ,GETDATE()-- RefundDate - datetime
								   ,ebpa.AdjustmentIdentifier2-- Comment - type_Comment
								   ,CASE WHEN ebpa.AdjustmentAmount2 > 0 THEN @PLBPositive ELSE @PLBNegative END-- RefundType - type_GlobalCode -- null for now, it should be changed later.
								   ,NEWID()-- RowIdentifier - type_GUID
							FROM    dbo.ERBatchProviderAdjustments ebpa
							WHERE   ebpa.AdjustmentAmount2 IS NOT NULL
									AND ebpa.ERBatchId = @ERBatchId

					INSERT  INTO dbo.Refunds
							( 
							 CreatedBy
							,CreatedDate
							,ModifiedBy
							,ModifiedDate
							,DeletedBy
							,PaymentId
							,Correction
							,Amount
							,RefundDate
							,Comment
							,RefundType
							,RowIdentifier
							)
					OUTPUT  INSERTED.RefundId
						   ,INSERTED.DeletedBy
						   ,INSERTED.PaymentId
							INTO #Refunds ( RefundId, ERBatchId, PaymentId )
							SELECT  @UserCode -- CreatedBy - type_CurrentUser
								   ,GETDATE()-- CreatedDate - type_CurrentDatetime
								   ,@UserCode-- ModifiedBy - type_CurrentUser
								   ,GETDATE()-- ModifiedDate - type_CurrentDatetime
								   ,ebpa.ERBatchId-- DeletedBy - type_UserId
								   ,@PaymentId-- PaymentId - int
								   ,NULL-- Correction - type_YOrN
								   ,-ebpa.AdjustmentAmount3-- Amount - money
								   ,GETDATE()-- RefundDate - datetime
								   ,ebpa.AdjustmentIdentifier3-- Comment - type_Comment
								   ,CASE WHEN ebpa.AdjustmentAmount3 > 0 THEN @PLBPositive ELSE @PLBNegative END-- RefundType - type_GlobalCode -- null for now, it should be changed later.
								   ,NEWID()-- RowIdentifier - type_GUID
							FROM    dbo.ERBatchProviderAdjustments ebpa
							WHERE   ebpa.AdjustmentAmount3 IS NOT NULL
									AND ebpa.ERBatchId = @ERBatchId
  
					INSERT  INTO dbo.Refunds
							( 
							 CreatedBy
							,CreatedDate
							,ModifiedBy
							,ModifiedDate
							,DeletedBy
							,PaymentId
							,Correction
							,Amount
							,RefundDate
							,Comment
							,RefundType
							,RowIdentifier
							)
					OUTPUT  INSERTED.RefundId
						   ,INSERTED.DeletedBy
						   ,INSERTED.PaymentId
							INTO #Refunds ( RefundId, ERBatchId, PaymentId )
							SELECT  @UserCode -- CreatedBy - type_CurrentUser
								   ,GETDATE()-- CreatedDate - type_CurrentDatetime
								   ,@UserCode-- ModifiedBy - type_CurrentUser
								   ,GETDATE()-- ModifiedDate - type_CurrentDatetime
								   ,ebpa.ERBatchId-- DeletedBy - type_UserId
								   ,@PaymentId-- PaymentId - int
								   ,NULL-- Correction - type_YOrN
								   ,-ebpa.AdjustmentAmount4-- Amount - money
								   ,GETDATE()-- RefundDate - datetime
								   ,ebpa.AdjustmentIdentifier4-- Comment - type_Comment
								   ,CASE WHEN ebpa.AdjustmentAmount4 > 0 THEN @PLBPositive ELSE @PLBNegative END-- RefundType - type_GlobalCode -- null for now, it should be changed later.
								   ,NEWID()-- RowIdentifier - type_GUID
							FROM    dbo.ERBatchProviderAdjustments ebpa
							WHERE   ebpa.AdjustmentAmount4 IS NOT NULL        
									AND ebpa.ERBatchId = @ERBatchId

					INSERT  INTO dbo.Refunds
							( 
							 CreatedBy
							,CreatedDate
							,ModifiedBy
							,ModifiedDate
							,DeletedBy
							,PaymentId
							,Correction
							,Amount
							,RefundDate
							,Comment
							,RefundType
							,RowIdentifier
							)
					OUTPUT  INSERTED.RefundId
						   ,INSERTED.DeletedBy
						   ,INSERTED.PaymentId
							INTO #Refunds ( RefundId, ERBatchId, PaymentId )
							SELECT  @UserCode -- CreatedBy - type_CurrentUser
								   ,GETDATE()-- CreatedDate - type_CurrentDatetime
								   ,@UserCode-- ModifiedBy - type_CurrentUser
								   ,GETDATE()-- ModifiedDate - type_CurrentDatetime
								   ,ebpa.ERBatchId-- DeletedBy - type_UserId
								   ,@PaymentId-- PaymentId - int
								   ,NULL-- Correction - type_YOrN
								   ,-ebpa.AdjustmentAmount5-- Amount - money
								   ,GETDATE()-- RefundDate - datetime
								   ,ebpa.AdjustmentIdentifier5-- Comment - type_Comment
								   ,CASE WHEN ebpa.AdjustmentAmount5 > 0 THEN @PLBPositive ELSE @PLBNegative END-- RefundType - type_GlobalCode -- null for now, it should be changed later.
								   ,NEWID()-- RowIdentifier - type_GUID
							FROM    dbo.ERBatchProviderAdjustments ebpa
							WHERE   ebpa.AdjustmentAmount5 IS NOT NULL
									AND ebpa.ERBatchId = @ERBatchId

					INSERT  INTO dbo.Refunds
							( 
							 CreatedBy
							,CreatedDate
							,ModifiedBy
							,ModifiedDate
							,DeletedBy
							,PaymentId
							,Correction
							,Amount
							,RefundDate
							,Comment
							,RefundType
							,RowIdentifier
							)
					OUTPUT  INSERTED.RefundId
						   ,INSERTED.DeletedBy
						   ,INSERTED.PaymentId
							INTO #Refunds ( RefundId, ERBatchId, PaymentId )
							SELECT  @UserCode -- CreatedBy - type_CurrentUser
								   ,GETDATE()-- CreatedDate - type_CurrentDatetime
								   ,@UserCode-- ModifiedBy - type_CurrentUser
								   ,GETDATE()-- ModifiedDate - type_CurrentDatetime
								   ,ebpa.ERBatchId-- DeletedBy - type_UserId
								   ,@PaymentId-- PaymentId - int
								   ,NULL-- Correction - type_YOrN
								   ,-ebpa.AdjustmentAmount6-- Amount - money
								   ,GETDATE()-- RefundDate - datetime
								   ,ebpa.AdjustmentIdentifier6-- Comment - type_Comment
								   ,CASE WHEN ebpa.AdjustmentAmount6 > 0 THEN @PLBPositive ELSE @PLBNegative END-- RefundType - type_GlobalCode -- null for now, it should be changed later.
								   ,NEWID()-- RowIdentifier - type_GUID
							FROM    dbo.ERBatchProviderAdjustments ebpa
							WHERE   ebpa.AdjustmentAmount6 IS NOT NULL
									AND ebpa.ERBatchId = @ERBatchId


					UPDATE  r
					SET     DeletedBy = NULL
					FROM    dbo.Refunds r
							JOIN #Refunds r2
								ON r.RefundId = r2.RefundId


					SELECT  SUM(r2.Amount) AS Amount
						   ,r2.PaymentId
					INTO    #TotalRefund
					FROM    #Refunds r
							JOIN dbo.Refunds r2
								ON r2.RefundId = r.RefundId
					GROUP BY r2.PaymentId

					UPDATE  p
					SET     UnpostedAmount = UnpostedAmount - tr.Amount
					FROM    Payments p
							JOIN #TotalRefund tr
								ON p.PaymentId = tr.PaymentId

        
                    INSERT  INTO ERBatchPayments
                            ( ERBatchId ,
                              PayerId ,
                              PaymentId ,
                              CoveragePlanId ,
                              CheckNumber ,
                              CheckDate ,
                              Amount ,
                              DateCreated
                            )
                    VALUES  ( @ERBatchId ,
                              @PayerId ,
                              @PaymentId ,
                              NULL ,
                              @CheckNumber ,
                              @CheckDate ,
                              @Amount ,
                              @CurrentDate
                            )      
      
					DROP TABLE #TotalRefund
  
                    IF @@error <> 0
                        GOTO rollback_tran      
				
                END
        
        
        
        -- 2. If #1 is not true, execute standard logic, one check at a time
            ELSE
                BEGIN 
					
                    --TRUNCATE TABLE #payments
					
                    IF @@error <> 0
                        GOTO rollback_tran  
					
                    INSERT  INTO #payments
                            ( ERBatchId ,
                              ERClaimLineItemId ,
                              ClaimLineItemId ,
                              CoveragePlanId ,
                              CheckNumber ,
                              CheckDate ,
                              Amount
                            )
                            SELECT  b.ERBatchId ,
                                    a.ERClaimLineItemId ,
                                    a.ClaimLineItemId ,
                                    e.CoveragePlanId ,
                                    erb.CheckNumber ,
                                    erb.CheckDate ,
                                    SUM(a.PaidAmount)
                            FROM    ERClaimLineItems a
                                    JOIN #batches b ON ( a.ERBatchId = b.ERBatchId )
                                    JOIN ERBatches erb ON ( b.ERBatchId = erb.ERBatchId )
                                    LEFT JOIN ClaimLineItemCharges c ON ( a.ClaimLineItemId = c.ClaimLineItemId )
                                    LEFT JOIN Charges d ON ( c.ChargeId = d.ChargeId )
                                    LEFT JOIN ClientCoveragePlans e ON e.ClientCoveragePlanId = d.ClientCoveragePlanId
                            WHERE   NOT EXISTS ( SELECT *
                                                 FROM   ERBatchPayments erbp
                                                 WHERE  erbp.ERBatchId = erb.ERBatchId
                                                        AND ISNULL(e.CoveragePlanId, -1) = ISNULL(erbp.CoveragePlanId, -1) )  
-- Pick only one record from ClaimLineItemCharges  
                                    AND NOT EXISTS ( SELECT *
                                                     FROM   ClaimLineItemCharges c2
                                                     WHERE  c.ClaimLineItemId = c2.ClaimLineItemId
                                                            AND c.ChargeId < c2.ChargeId )
                                    AND b.ERBatchId = @ERBatchId
                            GROUP BY b.ERBatchId ,
                                    a.ERClaimLineItemId ,
                                    a.ClaimLineItemId ,
                                    e.CoveragePlanId ,
                                    erb.CheckNumber ,
                                    erb.CheckDate  
      
                    IF @@error <> 0
                        GOTO rollback_tran      
        
        -- Insert Payment that cannot be mapped to coverage plan  
                    INSERT  INTO ERBatchPayments
                            ( ERBatchId ,
                              PaymentId ,
                              CoveragePlanId ,
                              CheckNumber ,
                              CheckDate ,
                              DateCreated ,
                              Amount
                            )
                            SELECT  ERBatchId ,
                                    NULL ,
                                    NULL ,
                                    CheckNumber ,
                                    CheckDate ,
                                    @CurrentDate ,
                                    SUM(Amount)
                            FROM    #payments a
                            WHERE   a.CoveragePlanId IS NULL
                                    AND NOT EXISTS ( SELECT *
                                                     FROM   ERBatchPayments erbp
                                                     WHERE  a.ERBatchId = erbp.ERBatchId
                                                            AND erbp.CoveragePlanId IS NULL )
                                    AND a.ERBatchId = @ERBatchId
                            GROUP BY ERBatchId ,
                                    CheckNumber ,
                                    CheckDate   
  
                    IF @@error <> 0
                        GOTO rollback_tran  
					
					
					
                    DECLARE cur_payment CURSOR
                    FOR
                        SELECT  ERBatchId ,
                                CoveragePlanId ,
                                CheckNumber ,
                                CheckDate ,
                                SUM(Amount)
                        FROM    #payments a
                        WHERE   a.CoveragePlanId IS NOT NULL
                                AND a.ERBatchId = @ERBatchId
                                AND NOT EXISTS ( SELECT *
                                                 FROM   ERBatchPayments erbp
                                                 WHERE  a.ERBatchId = erbp.ERBatchId
                                                        AND erbp.CoveragePlanId = a.CoveragePlanId )
                        GROUP BY ERBatchId ,
                                CoveragePlanId ,
                                CheckNumber ,
                                CheckDate  
      
                    IF @@error <> 0
                        GOTO rollback_tran      
      
                    OPEN cur_payment      
      
                    IF @@error <> 0
                        GOTO rollback_tran      
      
                    FETCH cur_payment INTO @ERBatchId, @CoveragePlanId, @CheckNumber, @CheckDate, @Amount      
      
                    IF @@error <> 0
                        GOTO rollback_tran      
      
                    WHILE @@fetch_status = 0
                        BEGIN      
      
                            INSERT  INTO FinancialActivities
                                    ( PayerId ,
                                      CoveragePlanId ,
                                      ClientId ,
                                      ActivityType ,
                                      CreatedBy ,
                                      CreatedDate ,
                                      ModifiedBy ,
                                      ModifiedDate
                                    )
                            VALUES  ( NULL ,
                                      @CoveragePlanId ,
                                      NULL ,
                                      4323 ,
                                      @UserCode ,
                                      GETDATE() ,
                                      @UserCode ,
                                      GETDATE()
                                    )       
      
                            SET @FinancialActivityId = @@Identity      
      
                            IF @FinancialActivityId <= 0
                                BEGIN      
                                    ROLLBACK TRANSACTION      
                                    select  @ErrorNumber = 30001,@ErrorMessage = 'Invalid Financial Activity (Payment) ID'   
                                    GOTO error      
                                END      
      
      
                            INSERT  INTO Payments
                                    ( FinancialActivityId ,
                                      CoveragePlanId ,
                                      DateReceived ,
                                      NameIfNotClient ,
                                      ElectronicPayment ,
                                      PaymentMethod ,
                                      ReferenceNumber ,
                                      Amount ,
                                      PaymentSource ,
                                      UnpostedAmount ,
                                      CreatedBy ,
                                      CreatedDate ,
                                      ModifiedBy ,
                                      ModifiedDate
                                    )
                            VALUES  ( @FinancialActivityId ,
                                      @CoveragePlanId ,
                                      GETDATE() ,
                                      NULL ,
                                      'Y' ,
                                      @PaymentMethod ,
                                      RTRIM(@CheckNumber) ,
                                      @Amount ,
                                      @PaymentSource ,
                                      @Amount ,
                                      @UserCode ,
                                      GETDATE() ,
                                      @UserCode ,
                                      GETDATE()
                                    )      
        
      
                            SELECT  @PaymentId = @@identity      
      
                            IF @PaymentId <= 0
                                BEGIN      
                                    ROLLBACK TRANSACTION      
                                    select  @ErrorNumber = 30001,@ErrorMessage = 'Invalid Payment ID'      
                                    GOTO error      
                                END      
 

        
                            INSERT  INTO ERBatchPayments
                                    ( ERBatchId ,
                                      PaymentId ,
                                      CoveragePlanId ,
                                      CheckNumber ,
                                      CheckDate ,
                                      Amount ,
                                      DateCreated
                                    )
                            VALUES  ( @ERBatchId ,
                                      @PaymentId ,
                                      @CoveragePlanId ,
                                      @CheckNumber ,
                                      @CheckDate ,
                                      @Amount ,
                                      @CurrentDate
                                    )      
      
           
  
                            IF @@error <> 0
                                GOTO rollback_tran      
      
      
                            FETCH cur_payment INTO @ERBatchId, @CoveragePlanId, @CheckNumber, @CheckDate, @Amount      
      
                            IF @@error <> 0
                                GOTO rollback_tran      
      
                        END      
      
                    CLOSE cur_payment      
      
                    IF @@error <> 0
                        GOTO rollback_tran      
      
                    DEALLOCATE cur_payment      
      
                    IF @@error <> 0
                        GOTO rollback_tran    
											
        
                END 
       
            COMMIT TRAN -- create payments   
        
            IF @@error <> 0
                GOTO rollback_tran  
        
        
        --PRINT @ERBatchId
        
            FETCH cur_ERBatches INTO @ERBatchId
        
            IF @@error <> 0
                GOTO rollback_tran  
        
        
        
        END
        
    CLOSE cur_ERBatches
        
    IF @@error <> 0
        GOTO rollback_tran  
        
    DEALLOCATE cur_ERBatches
        
    IF @@error <> 0
        GOTO rollback_tran  
        
        

	
    IF @@error <> 0
        GOTO rollback_tran 


  
  
    UPDATE  a
    SET     ERBatchPaymentId = erbp.ERbatchPaymentId
    FROM    ERClaimLineItems a
            JOIN #batches b ON ( a.ERBatchId = b.ERBatchId )
            JOIN ERBatches erb ON ( b.ERBatchId = erb.ERBatchId )
            JOIN ERBatchPayments erbp ON ( erb.ERBatchId = erbp.ERBatchId )
            LEFT JOIN ClaimLineItemCharges c ON ( a.ClaimLineItemId = c.ClaimLineItemId )
            LEFT JOIN Charges d ON ( c.ChargeId = d.ChargeId )
            LEFT JOIN ClientCoveragePlans e ON e.ClientCoveragePlanId = d.ClientCoveragePlanId
            LEFT JOIN dbo.CoveragePlans f ON f.CoveragePlanId = e.CoveragePlanId
    WHERE   ( ISNULL(erbp.CoveragePlanId, -1) = ISNULL(e.CoveragePlanId, -1)
              OR erbp.PayerId IS NOT NULL 
            )
  
    IF @@error <> 0
        GOTO rollback_tran        
    
      
  
--delete from #batches  SRF Removed so that only select batches are processed      
      
    IF @@error <> 0
        RETURN      
      
-- Delete entries from log table for transactions that were not processed       
    DELETE  a
    FROM    ERClaimLineItemLog a
            JOIN ERClaimLineItems b ON ( a.ERClaimLineItemId = b.ERClaimLineItemId )
            JOIN #batches c ON c.ERBatchId = b.ERBatchId
    WHERE   b.ClaimLineItemId IS NOT NULL
            AND ISNULL(b.Processed, 'N') = 'N'
            AND ISNULL(a.RecordDeleted, 'N') = 'N'      
      
    IF @@error <> 0
        RETURN      
      


-- Post payments one batch at a time      
    IF CURSOR_STATUS('global', 'cur_batch2') >= -1
        BEGIN    
            CLOSE cur_batch2    
            DEALLOCATE cur_batch2    
        END    
      
    DECLARE cur_batch2 CURSOR
    FOR
        SELECT  b.ERBatchId ,
                b.PaymentId
        FROM    #Batches a
                JOIN ERBatchPayments b ON ( a.ERBatchId = b.ERBatchId )
        WHERE   b.PaymentId IS NOT NULL
        ORDER BY a.ERBatchId      
      
    IF @@error <> 0
        GOTO error      
      
    OPEN cur_batch2      
      
    IF @@error <> 0
        GOTO error      
      
    FETCH cur_batch2 INTO @ERBatchId, @PaymentId  
      
    IF @@error <> 0
        GOTO error      
      
    WHILE @@fetch_status = 0
        BEGIN      
      
            EXEC ssp_PM835PostBatch @ERBatchId, @PaymentId    
            --SELECT  'Post Batch Disabled'	
			
       
            IF @@error <> 0
                GOTO error      
      
            FETCH cur_batch2 INTO @ERBatchId, @PaymentId  
    
      
            IF @@error <> 0
                GOTO error      
        END      
      
    CLOSE cur_batch2      
      
    DEALLOCATE cur_batch2      
     --  modified by Veena on 01/03/18 - Changed the result message to Processed Successfully instead of no. of lines processed  Key Point - Support Go Live #1144  
    SELECT  @Result = 'Processed Successfully' + CHAR(13) + CHAR(10)      
      
    INSERT  INTO #temp2
            ( result )
    VALUES  ( @Result )      
      
    SELECT  result
    FROM    #temp2      
      
      --Set File to Processed      
    UPDATE  ERFiles
    SET     Processed = 'Y'
    WHERE   ERFileId = @ERFileId 
    
      
    RETURN      
      
    rollback_tran:      
      
    ROLLBACK TRAN      
      
    error:      
  
    set @ErrorMessage = @ErrorMessage + ', Error Number: %d'
    RAISERROR(@ErrorMessage, 16, 1, @ErrorNumber ) 
    SELECT  @Result = 'Process failed due to SQL Error. Please ask system administrator to execute ssp_835_payment_posting from SQL Query Analyzer.'      
      
    INSERT  INTO #temp2
            ( result )
    VALUES  ( @Result )      
      
    SELECT  result
    FROM    #temp2      
      
    RETURN 

GO
