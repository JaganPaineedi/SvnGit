/****** Object:  StoredProcedure [dbo].[ssp_PMDELETEClientLedgerEntries]    Script Date: 6/6/2018 11:19:41 AM ******/
DROP PROCEDURE [dbo].[ssp_PMDELETEClientLedgerEntries]
GO

/****** Object:  StoredProcedure [dbo].[ssp_PMDELETEClientLedgerEntries]    Script Date: 6/6/2018 11:19:41 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_PMDELETEClientLedgerEntries]     
/******************************************************************************   
** File: ssp_PMDELETEClientLedgerEntries.sql  
** Name: ssp_PMDELETEClientLedgerEntries  
** Desc:    
**   
**   
** This template can be customized:   
**   
** Return values: Filter Values -  Delete Ledger Entries  
**   
** Called by:   
**   
** Parameters:   
** Input Output   
** ---------- -----------   
** N/A   Dropdown values  
** Auth: Mary Suma  
** Date: 07/29/2011  
*******************************************************************************  
** Change History   
*******************************************************************************   
*******************************************************************************   
   Date:    Author:    Description:   
   07/29/2011  Mary Suma   Delete Ledger Entries  
   08/18/2011  Mary Suma   Modified ErrorCorrection to Y to filter   the Grid Data
							Updated CLient Balance,DELETE entries from Open Charges 
   11/23/2011  Mary Suma   Marked as Error as Y for Deleting Ledger  
   07/02/2012  Mary Suma   Corrected UnpostedAmount and ClientBalance 
   07/21/2016  Dknewtson  Included call to ssp_SCReacalculateChargePriorities, Added System Configuration Key RecalculateChargePriorityWhenPostingToARLedger controlling call to ssp_SCRecalculateChargePriorities
   08/17/2016  Deej			Changed the code to use Current Accounting period Id
   10/24/2016  T.Remisoski  Check @PostedAccountingPeriodId parameter against AccountingPeriods table
					   Only use current accounting period if Accounting Period is closed.
   06/06/2018 Robert Caffrey -- Added logic to use Accounting Period originally posted for the Reversing entry Logic - SpringRiver SGL #248
--------    --------    ---------------   
***************************************************************************************************************************************************   
***************************************************************************************************************************************************/       
  
@FinancialActivityLineId INT ,  
@UserCode VARCHAR(30),  
@PostedAccountingPeriodId INT,  
@ClientId  INT,  
@PaymentId  INT,  
@ChargeId  INT  
     
AS       
DECLARE @FinancialActivityVersion INT           
DECLARE @CurrentDate datetime    
DECLARE @Comment VARCHAR  
  
BEGIN                                                                
 BEGIN TRY        
 BEGIN TRANSACTION DeleteLedgerEntry  
    
 SELECT @CurrentDate = getdate()      
 SET @Comment = 'Deleted this entry FROM Ledger Entries'  
 -- Get Financial Activity Version            
 SELECT   
  @FinancialActivityVersion = CurrentVersion            
 FROM   
  FinancialActivityLines             
 WHERE   
  FinancialActivityLineId = @FinancialActivityLineId            
     --Accounting Period is retrieved same as Corrections   
     -- Please clarify   since this is a mANDatory field  
     
          
     
        -- Client Balance Change            
  DECLARE @ClientBalanceChange  money            
            
  -- Only include error correction AND new ledgers (non payment)            
  -- to compute the change in client balance            
  SELECT @ClientBalanceChange = -sum(Amount)            
  FROM ARLedger             
  WHERE FinancialActivityLineId = @FinancialActivityLineId            
  AND FinancialActivityVersion in (@FinancialActivityVersion)            
  AND CoveragePlanId is null            
  AND LedgerType <> 4202 -- Exclude Payment            
  AND ISNULL(MarkedAsError,'N') = 'N'            
            
  
  IF ISNULL(@ClientBalanceChange,0) <> 0            
  BEGIN            
   UPDATE Clients            
   SET CurrentBalance = ISNULL(CurrentBalance,0) + ISNULL(@ClientBalanceChange,0)            
   WHERE ClientId = @ClientId           
  END    
  
  
 -- SET ARLedger entries for current version to MarkedAsError            
  UPDATE   
  ARLedger            
  SET   
  MarkedAsError = 'Y', ModifiedBy = @UserCode, ModifiedDate = @CurrentDate            
  WHERE   
  FinancialActivityLineId = @FinancialActivityLineId            
  AND   
  FinancialActivityVersion = @FinancialActivityVersion            
  
 --
 -- T.Remisoski - 10/24/2016 - If @PostedAccountingPeriodId is not open, use the next open period nearest to today (@CurrentDate).
 --
  if not exists (
    select *
    from AccountingPeriods as ap
    where ap.AccountingPeriodId = @PostedAccountingPeriodId
	   and ap.OpenPeriod = 'Y'
	   and isnull(RecordDeleted, 'N') = 'N'
    )
  begin
    set @PostedAccountingPeriodId = null

    SELECT TOP 1 @PostedAccountingPeriodId = ap.AccountingPeriodId
    FROM AccountingPeriods AS ap
    WHERE DATEDIFF(DAY, ap.EndDate, @CurrentDate) <= 0
    AND ap.OpenPeriod = 'Y'
    AND ISNULL(ap.RecordDeleted, 'N') = 'N'
    ORDER BY ap.EndDate
  END

  -- if no eligble period, raise an error
  if @PostedAccountingPeriodId is null
  begin
    raiserror('No open accounting period exists.', 16, 1)
  end
       
 -- Insert reversing entries in ARLedger             
  INSERT INTO   
   ARLedger            
   (ChargeId, 
   FinancialActivityLineId, 
   FinancialActivityVersion,             
   LedgerType, 
   Amount, 
   PaymentId, 
   AdjustmentCode, 
   AccountingPeriodId,
   PostedDate,             
   ClientId, 
   CoveragePlanId, 
   DateOfService, 
   ErrorCorrection,             
   CreatedBy, 
   CreatedDate, 
   ModifiedBy, 
   ModifiedDate,
   MarkedAsError)            
  SELECT   
   ChargeId,
   FinancialActivityLineId, 
   FinancialActivityVersion,             
   LedgerType, 
   -Amount, 
   PaymentId, 
   AdjustmentCode, 
   CASE WHEN ap.OpenPeriod = 'Y' THEN ap.AccountingPeriodId
			ELSE @PostedAccountingPeriodId end,             
   @CurrentDate, 
   ClientId, 
   CoveragePlanId, 
   DateOfService, 
   'Y', --Error Correction is 'N' in case of Deletion FROM LedgerEntries  
   @UserCode, 
   @CurrentDate, 
   @UserCode, 
   @CurrentDate   ,
   'Y'         
  FROM  
  ARLedger 
  JOIN dbo.AccountingPeriods ap ON ap.AccountingPeriodId = ARLedger.AccountingPeriodId           
  WHERE   
  FinancialActivityLineId = @FinancialActivityLineId            
  AND   
  FinancialActivityVersion = @FinancialActivityVersion            
            
          
     IF @@ROWCOUNT > 0  
     BEGIN  
   -- Increment the FinancialActivityVersion for new entries            
   SET @FinancialActivityVersion = @FinancialActivityVersion + 1            
   
   UPDATE   
     FinancialActivityLines            
   SET CurrentVersion = @FinancialActivityVersion, Flagged = NULL,             
     --Comment = @Comment,   
     ModifiedBy = @UserCode, ModifiedDate = @CurrentDate            
   WHERE   
    FinancialActivityLineId  = @FinancialActivityLineId            
        
          
   
   --Insert New record into ARLedger with PAyment as 0. To make this same as corrections logic, while retrievign records  
   --in posting payments.  
   -- This needs to be commented based on Javed's Comment  
     
    --insert into ARLedger            
    --(ChargeId, FinancialActivityLineId, FinancialActivityVersion,           
    --LedgerType, Amount, PaymentId, AdjustmentCode, AccountingPeriodId, PostedDate,             
    --ClientId, CoveragePlanId, DateOfService,              
    --CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)            
    --values (@ChargeId, @FinancialActivityLineId, @FinancialActivityVersion,             
    --4202, 0, @PaymentId, null, @PostedAccountingPeriodId,             
    --@CurrentDate, @ClientId, null, @CurrentDate,              
    --@UserCode, @CurrentDate, @UserCode, @CurrentDate)            
   
    --Recalculate Payments.Unposted Amount   
        declare @OriginalPayment money     
        --if @FinancialActivityVersion > 1            
   begin            
    select @OriginalPayment = Amount            
    from ARLedger            
    where FinancialActivityLineId = @FinancialActivityLineId            
    and FinancialActivityVersion = @FinancialActivityVersion - 1            
    and ChargeId = @ChargeId            
    and isnull(MarkedAsError,'N') = 'Y'            
    and PaymentId = @PaymentId    -- Bhupinder Bajwa REF Task # 325           
               
     
   end      
  if isnull(@OriginalPayment,0) <> 0             
  begin           
          
   update Payments            
   set UnpostedAmount = UnpostedAmount  + isnull(@OriginalPayment, 0),            
   ModifiedBy = @UserCode, ModifiedDate = @CurrentDate            
   where Paymentid = @PaymentId            
              
  end    

  -- recalculate charge priorities

   IF ISNULL((
               SELECT   dbo.ssf_GetSystemConfigurationKeyValue('RecalculateChargePriorityWhenPostingToARLedger')
             ), 'N') = 'Y' 
      BEGIN
            DECLARE @ServiceId INT 
      
            SELECT  @ServiceId = c.ServiceId
            FROM    dbo.Charges c
            WHERE   ChargeId = @ChargeId 

            EXEC dbo.ssp_SCRecalculateChargePriorities @ServiceId = @ServiceId, -- int
                @UserCode = @UserCode -- varchar(30)
       
      END
   
         -- Recalculate Open Charges      
   -- DELETE Open Charges for Updated charges     
   
            
  DELETE b            
  FROM ARLedger a            
  JOIN OpenCharges b ON (a.ChargeId = b.ChargeId)            
  WHERE a.FinancialActivityLineId = @FinancialActivityLineId            
  AND a.FinancialActivityVersion IN (@FinancialActivityVersion,            
  @FinancialActivityVersion-1)               
        
      -- Create Open Charges for updated charges            
  INSERT INTO OpenCharges            
   (ChargeId, Balance, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)            
   SELECT a.ChargeId, SUM(a.Amount), @UserCode, @CurrentDate, @UserCode, @CurrentDate            
   FROM ARledger a             
  WHERE EXISTS             
  (SELECT *             
  FROM ARLedger b             
  WHERE b.FinancialActivityLineId = @FinancialActivityLineId            
  AND b.FinancialActivityVersion IN (@FinancialActivityVersion,            
  @FinancialActivityVersion-1)            
  AND a.ChargeId = b.ChargeId)            
  GROUP BY a.ChargeId            
  HAVING SUM(a.Amount) <> 0        
  
          
       END    
         
        IF @@ERROR = 0  
  BEGIN  
   COMMIT TRANSACTION DeleteLedgerEntry  
  END  
  ELSE  
  BEGIN  
   ROLLBACK TRANSACTION DeleteLedgerEntry  
  END       
    
 END TRY  
   
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)         
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                              
   + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_PMDELETEClientLedgerEntries')                                                                                               
   + '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                                
   + '*****' + CONVERT(VARCHAR,ERROR_STATE())  
  RAISERROR  
  (  
   @Error, -- Message text.  
   16,  -- Severity.  
   1  -- State.  
  );  
 END CATCH  
END  
  
  
GO


