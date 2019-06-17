/****** Object:  StoredProcedure [dbo].[ssp_CMGetRefundChecksInformation]    Script Date: 10/13/2014 20:15:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMGetRefundChecksInformation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CMGetRefundChecksInformation]
GO

/****** Object:  StoredProcedure [dbo].[ssp_CMGetRefundChecksInformation]    Script Date: 10/13/2014 20:15:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
------------------------------------------------------------------------------------------------
--Author : Shruthi.S
--Date   : 14/01/2015
--Purpose :Added $ for amount.Ref #312 Env Issues.
------------------------------------------------------------------------------------------------
--	Updates
------------------------------------------------------------------------------------------------
--	DATE		Author			Purpose
------------------------------------------------------------------------------------------------
--	14.May.2015	Rohith Uppin	DataType of columns modified. Task#341 SWMBH Support.	
--  19.May.2015 Rohith Uppin	Amount column round off to 2 decimal values.
-- =============================================================================================

CREATE PROCEDURE [dbo].[ssp_CMGetRefundChecksInformation] 
(
	 @ProviderRefundId int,
	 @ProviderId int,
	 @InsurerId int,
	 @TaxId varchar(100)
)
AS
BEGIN
    SELECT
      ProviderRefundId,
      InsurerId,
      ProviderId,
      TaxIdType,
      TaxId,
      DateOfRefund,
      CheckNumber,
      CheckDate,
      cast(Amount as decimal(19,2)) as Amount,
      BalanceAmount,
     '$' + CONVERT(VARCHAR, BalanceAmount, 10) AS BalanceAmountStr,
      ReturnedCheckId,
      InsurerBankAccountId,
      RowIdentifier,
      CreatedBy,
      CreatedDate,
      ModifiedBy,
      ModifiedDate,
      RecordDeleted,
      DeletedDate,
      DeletedBy,
     (SELECT ProviderName from Providers WHERE ProviderId=D.ProviderId) AS ProviderName
       FROM ProviderRefunds D
       WHERE ProviderRefundId = @ProviderRefundId
    AND ISNULL(RecordDeleted, 'N') = 'N'
     
    SELECT [ClaimLineCreditId]
      ,[ClaimLineId]
      ,[CheckId]
      ,[Amount]
      ,[ProviderRefundId]
      ,[RowIdentifier]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedDate]
      ,[DeletedBy]
  FROM [ClaimLineCredits] WHERE [ProviderRefundId]=@ProviderRefundId AND (ISNULL(RecordDeleted, 'N') = 'N')

    --SELECT [InsurerBankAccountId]
    --  ,[InsurerId]
    --  ,[BankAccountName]
    --  ,[BankName]
    --  ,[BankAccountNumber]
    --  ,[LastCheckNumber]
    --  ,[CheckType]
    --  ,[CheckPrinterLocation]
    --  ,[Active]
    --  ,[FromDate]
    --  ,[ToDate]
    --  ,[Signer1]
    --  ,[Signer2]
    --  ,[RowIdentifier]
    --  ,[CreatedBy]
    --  ,[CreatedDate]
    --  ,[ModifiedBy]
    --  ,[ModifiedDate]
    --  ,[RecordDeleted]
    --  ,[DeletedDate]
    --  ,[DeletedBy]
    --FROM [InsurerBankAccounts] WHERE (ISNULL(RecordDeleted, 'N') = 'N') AND (Active = 'Y')
    
    SELECT 0 AS DataGridCheckBox, 
          CONVERT(VARCHAR(10), ClaimLines.ToDate,101) AS DOS,
           ClaimLines.ClaimLineId, 
           CAST(ClaimLines.Units AS decimal(18, 0)) AS Units,   
           '' AS EmptyUnitColumn, 
           ABS(ClaimLines.PayableAmount) AS PayableAmount, 
           '' AS EmptyAmountColumn, 0.0 AS AmountApplied, Sites.PayableName,   
           (select top 1 lastCheckNumber from  InsurerBankAccounts iba
				join Insurers i on i.InsurerId =  iba.InsurerId 
				where iba.InsurerId=@InsurerId and IsNull(iba.RecordDeleted,'N') <> ' Y' and iba.Active='Y'
				and (iba.InsurerbankAccountId = (select DefaultbankAccountId from Insurers 
                where InsurerId = @InsurerId and IsNull(RecordDeleted,'N') <> ' Y')
				OR i.DefaultBankAccountId is null)) as LastCheckNumber,
				BillingCodes.BillingCode ,
				ClaimLines.RecordDeleted 
     FROM   GlobalCodes INNER JOIN  
                      BillingCodes ON GlobalCodes.GlobalCodeId = BillingCodes.UnitType RIGHT OUTER JOIN  
                      Claims INNER JOIN  
                      ClaimLines ON Claims.ClaimId = ClaimLines.ClaimId INNER JOIN  
                      Sites ON Claims.SiteId = Sites.SiteId INNER JOIN  
                      Insurers ON Claims.InsurerId = Insurers.InsurerId ON BillingCodes.BillingCodeId = ClaimLines.BillingCodeId  
     WHERE     (ClaimLines.PayableAmount < 0) AND (Sites.ProviderId = @ProviderId) AND 
               (ISNULL(Claims.RecordDeleted, 'N') = 'N') AND (ISNULL(ClaimLines.RecordDeleted,'N') = 'N') AND 
               (Claims.InsurerId = @InsurerId) AND (ISNULL(Sites.RecordDeleted, 'N') = 'N') AND (ISNULL(Insurers.RecordDeleted, 'N') = 'N') AND   
               (Insurers.Active = 'Y') AND (Sites.TaxID = @TaxId)  
               AND NOT EXISTS (SELECT ClaimLineId FROM ClaimLineCredits WHERE ProviderRefundId=@ProviderRefundId AND ClaimLines.ClaimLineId=ClaimLineId)
     ORDER BY ClaimLines.ClaimLineId DESC
    

    
    SELECT  ClaimLineCredits.ClaimLineId, 
		    CONVERT(VARCHAR(10), ClaimLines.ToDate, 101) AS DOS,		    
		    CAST(ClaimLines.Units AS decimal(18, 0)) AS Units,               
            CAST(ClaimLineCredits.Amount AS decimal(18, 2)) AS 'PayableAmount',
            BillingCodes.BillingCode,'' as EmptyUnit              
	FROM   ClaimLineCredits INNER JOIN    
	       ClaimLines ON ClaimLineCredits.ClaimLineId = ClaimLines.ClaimLineId LEFT OUTER JOIN              
           BillingCodes ON ClaimLines.BillingCodeId = BillingCodes.BillingCodeId RIGHT OUTER JOIN              
           ProviderRefunds ON ClaimLineCredits.ProviderRefundId = ProviderRefunds.ProviderRefundId              
    WHERE (ClaimLineCredits.ProviderRefundId = @ProviderRefundId) AND (ISNULL(ProviderRefunds.RecordDeleted, 'N') = 'N')            
    AND (ISNULL(ClaimLineCredits.RecordDeleted, 'N')= 'N') AND (ISNULL(ClaimLines.RecordDeleted, 'N') = 'N')             
    AND (ISNULL(BillingCodes.RecordDeleted, 'N') = 'N')   
    
    
    	SELECT  Providers.ProviderName, 
		ins.InsurerName, 
		ProviderRefunds.TaxId,
		convert(varchar,ProviderRefunds.DateOfRefund,101) as DateOfRefund,
		convert(varchar, ProviderRefunds.CheckDate,101) as CheckDate,                 
        ProviderRefunds.CheckNumber,
        cast(ProviderRefunds.Amount as decimal(18,2)) as Amount,
        case when cast(ProviderRefunds.BalanceAmount as decimal(18,2))=.00 Then 0 Else cast(ProviderRefunds.BalanceAmount as decimal(18,2)) End as BalanceAmount ,                 
                  cast(ProviderRefunds.Amount - ProviderRefunds.BalanceAmount as decimal(18,2)) AS 'Amount Selected', Checks.CheckNumber as ReturnCheckNumber, Providers.ProviderId,                 
        ins.InsurerId,
        ProviderRefunds.ReturnedCheckId,
        ProviderRefunds.ProviderRefundId,    
	    (select top 1 lastCheckNumber from  InsurerBankAccounts iba join Insurers i on i.InsurerId =  iba.InsurerId     
			   where iba.InsurerId = ins.InsurerId and IsNull(iba.RecordDeleted,'N') <> ' Y' and iba.Active='Y'    
			   and (iba.InsurerbankAccountId = (select DefaultbankAccountId from Insurers  where InsurerId = ins.InsurerId and IsNull(RecordDeleted,'N') <> ' Y')    
			   OR i.DefaultBankAccountId is null)) as LastCheckNumber,    
		Sites.PayableName,Sites.TaxIDType  
		        
FROM    ProviderRefunds INNER JOIN          
        Providers ON ProviderRefunds.ProviderId = Providers.ProviderId INNER JOIN          
        Insurers ins ON ProviderRefunds.InsurerId = ins.InsurerId INNER JOIN          
        Sites ON Providers.PrimarySiteId = Sites.SiteId AND Providers.ProviderId = Sites.ProviderId LEFT OUTER JOIN          
        Checks ON ProviderRefunds.ReturnedCheckId = Checks.CheckId LEFT OUTER JOIN          
        ClaimLineCredits ON ProviderRefunds.ProviderRefundId = ClaimLineCredits.ProviderRefundId          
WHERE   (ProviderRefunds.ProviderRefundId =  @ProviderRefundId) 
		AND (ISNULL(ProviderRefunds.RecordDeleted, 'N') = 'N')
	    AND (Providers.Active = 'Y') 
	    AND (ISNULL(Providers.RecordDeleted, 'N') = 'N') AND (ins.Active = 'Y') AND (ISNULL(ProviderRefunds.RecordDeleted, 'N') = 'N')
	    AND (ISNULL(ins.RecordDeleted, 'N') = 'N') AND (ISNULL(Checks.RecordDeleted, 'N') = 'N') AND (ISNULL(ClaimLineCredits.RecordDeleted, 'N') = 'N') and (Isnull(Sites.RecordDeleted,'N')='N')  
    
    
    
IF (@@error!=0)  
	BEGIN  RAISERROR  20006  'ssp_GetRefundChecksInformation: An Error Occured'  
	  RETURN END     
END




GO


