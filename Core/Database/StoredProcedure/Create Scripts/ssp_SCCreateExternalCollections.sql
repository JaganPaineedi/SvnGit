IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCCreateExternalCollections]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCCreateExternalCollections]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCCreateExternalCollections] @UserCode VARCHAR(30)  
 ,@ChargeIds VARCHAR(max)  
 ,@CreateAdjustment CHAR(1)  
 ,@AdjustmentCode INT  
 ,@CollectionsAgency INT  
 /********************************************************************************              
-- Stored Procedure: dbo.ssp_SCCreateExternalCollections                
-- Purpose: To Create External Collections               
-- Copyright: Streamline Healthcate Solutions           
--              
-- Updates:                                                                     
-- Date   Author  Purpose              
-- 07 Feb 2017             
*********************************************************************************/  
AS  
BEGIN  
 BEGIN TRY  
  CREATE TABLE #ChargeList (ChargeId INT)  
  
  IF @AdjustmentCode = 0
  SET @AdjustmentCode = NULL
  
  IF @CollectionsAgency = 0
  SET @CollectionsAgency = NULL
  
  INSERT INTO #ChargeList  
  SELECT item  
  FROM [dbo].fnSplit(@ChargeIds, ',')  
  
  DECLARE @ChargeId INT  
  DECLARE @ClientId INT  
  DECLARE @ServiceId INT  
  DECLARE @DateOfService DATETIME  
  DECLARE @FinancialActivityId INT  
  DECLARE @FinancialActivityLineId INT  
  DECLARE @Charge MONEY  
  DECLARE @ExternalCollectionId INT  
  
  DECLARE Charges_cursor CURSOR  
  FOR  
  SELECT ChargeId  
  FROM #ChargeList  
  
  OPEN Charges_cursor  
  
  FETCH NEXT  
  FROM Charges_cursor  
  INTO @ChargeId  
  
  WHILE @@FETCH_STATUS = 0  
  BEGIN  
   SELECT @ChargeId = CR.ChargeId  
    ,@ClientId = C.ClientId  
    ,@ServiceId = S.ServiceId  
    ,@DateOfService = S.DateOfService  
    ,@Charge = S.Charge  
   FROM Services S  
   INNER JOIN Clients C ON C.ClientId = S.ClientId  
   INNER JOIN Charges CR ON CR.ServiceId = S.ServiceId  
   WHERE CR.ChargeId = @ChargeId  
    AND ISNULL(CR.RecordDeleted, 'N') = 'N'  
    AND ISNULL(S.RecordDeleted, 'N') = 'N'  
    AND ISNULL(C.RecordDeleted, 'N') = 'N'  
  
   IF NOT EXISTS (  
     SELECT 1  
     FROM ExternalCollectionCharges  
     WHERE ChargeId = @ChargeId  
      AND ISNULL(RecordDeleted, 'N') = 'N'  
     )  
   BEGIN  
    UPDATE Charges  
    SET ExternalCollectionStatus = (  
      SELECT GlobalCodeId  
      FROM GlobalCOdes  
      WHERE Category = 'ExtCollectionStatus'  
       AND Code = 'Added to External Collections'  
      )  
    WHERE ChargeId = @ChargeId  
  
    UPDATE Clients  
    SET ExternalCollections = 'Y'  
    WHERE ClientId = @ClientId  
    
    IF @CreateAdjustment<>'N'
    BEGIN
  
		INSERT INTO FinancialActivities (  
		 ClientId  
		 ,CreatedBy  
		 ,CreatedDate  
		 ,ActivityType  
		 ,ModifiedBy  
		 ,ModifiedDate  
		 )  
		VALUES (  
		 @ClientId  
		 ,@UserCode  
		 ,GETDATE()  
		 ,4326  
		 ,@UserCode  
		 ,GETDATE()  
		 )  
	  
		SELECT @FinancialActivityId = SCOPE_IDENTITY()  
	  
		EXEC ssp_PMPaymentAdjustmentPost @UserCode = @UserCode  
		 ,@FinancialActivityId = @FinancialActivityId  
		 ,@PaymentId = NULL  
		 ,@FinancialActivityLineId = NULL  
		 ,@ChargeId = @ChargeId  
		 ,@ServiceId = @ServiceId  
		 ,@DateOfService = @DateOfService  
		 ,@ClientId = @ClientId  
		 ,@CoveragePlanId = NULL  
		 ,@PostedAccountingPeriodId = NULL  
		 ,@Flagged = N'N'  
		 ,@Comment = N''  
		 ,@Payment = NULL  
		 ,@Adjustment1 = @Charge  
		 ,@AdjustmentCode1 = @AdjustmentCode  
		 ,@Adjustment2 = NULL  
		 ,@AdjustmentCode2 = - 1  
		 ,@Adjustment3 = NULL  
		 ,@AdjustmentCode3 = - 1  
		 ,@Adjustment4 = NULL  
		 ,@AdjustmentCode4 = - 1  
		 ,@Transfer1 = N'0'  
		 ,@TransferTo1 = NULL  
		 ,@TransferCode1 = 50430  
		 ,@DoNotBill1 = N'N'  
		 ,@Transfer2 = NULL  
		 ,@TransferTo2 = NULL  
		 ,@TransferCode2 = - 1  
		 ,@DoNotBill2 = N'N'  
		 ,@Transfer3 = NULL  
		 ,@TransferTo3 = NULL  
		 ,@TransferCode3 = - 1  
		 ,@DoNotBill3 = N'N'  
		 ,@Transfer4 = NULL  
		 ,@TransferTo4 = NULL  
		 ,@TransferCode4 = - 1  
		 ,@DoNotBill4 = NULL  
    
    END 
  
    IF NOT EXISTS (  
      SELECT 1  
      FROM ExternalCollections  
      WHERE CollectionAgencyId = @CollectionsAgency  
       AND CreateAdjustment = @CreateAdjustment  
       AND AdjustmentCode = @AdjustmentCode  
       AND ISNULL(RecordDeleted,'N')<>'Y'
      )  
    BEGIN  
     INSERT INTO ExternalCollections (  
      CreatedBy  
      ,CreatedDate  
      ,CollectionAgencyId  
      ,CreateAdjustment  
      ,AdjustmentCode  
      )  
     VALUES (  
      @UserCode  
      ,GETDATE()  
      ,@CollectionsAgency  
      ,@CreateAdjustment  
      ,@AdjustmentCode  
      )  
  
     SELECT @ExternalCollectionId = SCOPE_IDENTITY()  
    END  
     
   IF @ExternalCollectionId IS NULL  
   BEGIN  
    SELECT TOP 1 @ExternalCollectionId = ExternalCollectionId FROM ExternalCollections WHERE CollectionAgencyId = @CollectionsAgency  
       AND CreateAdjustment = @CreateAdjustment  
       AND AdjustmentCode = @AdjustmentCode AND ISNULL(RecordDeleted,'N')<>'Y' ORDER BY ExternalCollectionId DESC   
   END  
  
    SELECT TOP 1 @FinancialActivityLineId = FinancialActivityLineId  
    FROM FinancialActivityLines  
    WHERE FinancialActivityId = @FinancialActivityId 
    AND ISNULL(RecordDeleted,'N')<>'Y'
    ORDER BY 1 DESC 
  
    IF (ISNULL(@ExternalCollectionId, 0) > 0)  
    BEGIN  
     INSERT INTO ExternalCollectionCharges (  
      CreatedBy  
      ,CreatedDate  
      ,ExternalCollectionId  
      ,FinancialActivityLineId  
      ,ChargeId  
      )  
     VALUES (  
      @UserCode  
      ,GETDATE()  
      ,@ExternalCollectionId  
      ,@FinancialActivityLineId  
      ,@ChargeId  
      )  
    END  
   END  
  
   FETCH NEXT  
   FROM Charges_cursor  
   INTO @ChargeId  
  END  
  
  CLOSE Charges_cursor  
  
  DEALLOCATE Charges_cursor  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @error VARCHAR(8000)  
  
  SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCCreateExternalCollections') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @error  
    ,-- Message text.          
    16  
    ,-- Severity.          
    1 -- State.          
    );  
 END CATCH  
END  
GO


