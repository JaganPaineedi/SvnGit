/****** Object:  StoredProcedure [dbo].[ssp_CMGetCheckDetails]    Script Date: 10/13/2014 21:37:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMGetCheckDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CMGetCheckDetails]
GO

/****** Object:  StoredProcedure [dbo].[ssp_CMGetCheckDetails]    Script Date: 10/13/2014 21:37:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--------------------------------------------
--Modified :Shruthi.S
--Date     :14/01/2015
--Purpose : Added nextavailabel chekc number logic .Ref #312 Env Issues.
--Modified by Shruthi.S - Modified Next available check number as per 3.5x.#312 Env Issues.
--Modified by SuryaBalan - Modified to 4 decimal points to Decimal Points #478 CM Env Issues.
--Shruthi.S 23/02/2015 Modified to avoid conflicting error in one scenario for returnchecknumber.Fixed latent issue.Also added new field Insurerbankaccountname.Ref #477 Env Issues.
/*  21 Oct 2015	Revathi				what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  */ 
/* 									why:task #609, Network180 Customization  */ 
/* 3 August 2017 PradeepT           What:Modified the logic for next available checknumber based on insurer bank account and increment 1 from last check number*/
/*                                  Why:KCMHSAS - Support-#900.88, It was showing wrong available check number e.g.If checkid=1 has checknumber=101,CheckId=2 Has checknumber=102 then on detailpage for checkid=1 shows availablechecknumber as 102 while it should be 103. */
-------------------------------------------

CREATE  PROCEDURE [dbo].[ssp_CMGetCheckDetails] --@CheckId=0,@InsurerId=4,@ProviderRefundId=84
@InsurerId INT, 
@CheckId INT,               
@ProviderRefundId INT        
AS    

CREATE TABLE #TEMP
(
	InsurerId INT,
	ProviderId INT,
	TaxId VARCHAR(9),
	TaxIdType VARCHAR(1),
	PayeeName VARCHAR(100),
	CheckNumber INT,
	Amount DECIMAL,	
	ReturnCheckNumber INT,
	InsurerName VARCHAR(100),
	NextAvailabelCheckNumber int,
	InsurerBankAccountName varchar(100)
	
)

--Logic to get the next available check number.

declare @NextAvailabelCheckNumber INT
set @NextAvailabelCheckNumber =0

----PradeepT, 3 August 2017
Select @NextAvailabelCheckNumber  =iba.LastCheckNumber from InsurerBankAccounts iba       
 join Checks c on c.InsurerBankAccountId = iba.InsurerBankAccountId       
 where c.CheckId = @CheckId

       
If  (isnull(@NextAvailabelCheckNumber,0) = 0)
begin
set @NextAvailabelCheckNumber = 1
end
else
begin
set @NextAvailabelCheckNumber = @NextAvailabelCheckNumber + 1
end

INSERT INTO #TEMP(InsurerId,ProviderId,TaxId,TaxIdType,PayeeName,CheckNumber,Amount,ReturnCheckNumber,InsurerName,NextAvailabelCheckNumber,InsurerBankAccountName)
(SELECT    TOP 1 ins.InsurerId,			
            Providers.ProviderId,
            ProviderRefunds.TaxId,
            Sites.TaxIDType,
            Sites.PayableName,
				(SELECT TOP 1 lastCheckNumber from  InsurerBankAccounts iba join Insurers i ON i.InsurerId =  iba.InsurerId     
				 WHERE iba.InsurerId = ins.InsurerId and IsNull(iba.RecordDeleted,'N') <> ' Y' and iba.Active='Y'    
				 and (iba.InsurerbankAccountId = (SELECT DefaultbankAccountId FROM Insurers WHERE InsurerId = ins.InsurerId and IsNull(RecordDeleted,'N') <> ' Y')    
			     OR i.DefaultBankAccountId is null)) AS LastCheckNumber,
            cast(ProviderRefunds.Amount AS DECIMAL(18,2)) AS Amount,
            Checks.CheckNumber AS ReturnCheckNumber,          
            ins.InsurerName,
            @NextAvailabelCheckNumber as NextAvailabelCheckNumber,
            (SELECT TOP 1 BankAccountName from InsurerBankAccounts where InsurerId=@InsurerId)AS InsurerBankAccountName		       
  FROM         ProviderRefunds INNER JOIN          
                      Providers ON ProviderRefunds.ProviderId = Providers.ProviderId INNER JOIN          
                      Insurers ins ON ProviderRefunds.InsurerId = ins.InsurerId INNER JOIN          
                      Sites ON Providers.PrimarySiteId = Sites.SiteId AND Providers.ProviderId = Sites.ProviderId LEFT OUTER JOIN          
                      Checks ON ProviderRefunds.ReturnedCheckId = Checks.CheckId LEFT OUTER JOIN          
                      ClaimLineCredits ON ProviderRefunds.ProviderRefundId = ClaimLineCredits.ProviderRefundId          
  WHERE     (ProviderRefunds.ProviderRefundId = @ProviderRefundId) AND (ISNULL(ProviderRefunds.RecordDeleted, 'N') = 'N') AND (Providers.Active = 'Y') AND           
                      (ISNULL(Providers.RecordDeleted, 'N') = 'N') AND (ins.Active = 'Y') AND (ISNULL(ProviderRefunds.RecordDeleted, 'N') = 'N') AND           
                     (ISNULL(ins.RecordDeleted, 'N') = 'N') AND (ISNULL(Checks.RecordDeleted, 'N') = 'N') AND (ISNULL(ClaimLineCredits.RecordDeleted, 'N') = 'N') and (Isnull(Sites.RecordDeleted,'N')='N') )         

IF @CheckId=0
	BEGIN
		 SELECT -1 AS CheckId,
		 T.InsurerId,
		 (SELECT TOP 1 InsurerBankAccountId from InsurerBankAccounts where InsurerId=@InsurerId)AS InsurerBankAccountId,
		 T.ProviderId,
		 T.TaxId,
		 T.TaxIdType,
		 T.PayeeName,
		 T.CheckNumber,
		 SYSDATETIME() AS CheckDate,
		 T.Amount,
		 'N' AS Voided,
		 '' AS CreatedBy,
		 getdate() AS CreatedDate,
		 '' AS ModifiedBy,
		 getdate() AS ModifiedDate,		
		 @ProviderRefundId AS ProviderRefundId,
		 T.ReturnCheckNumber,		 
		 T.InsurerName,
		 T.NextAvailabelCheckNumber as NextAvailabelCheckNumber,
		 (SELECT TOP 1 BankAccountName from InsurerBankAccounts where InsurerId=@InsurerId)AS InsurerBankAccountName
		 FROM #TEMP T 
	END
 ELSE                                  
  SELECT checkId,
  c.InsurerId,
  c.InsurerBankAccountId,
  c.ProviderId,c.TaxId,
  c.TaxIdType,
  PayeeName,
  c.CheckNumber,
  c.CheckDate,
   cast(c.Amount AS DECIMAL(18,2)) AS Amount,
  c.Memo,
  c.Voided,
  c.CreatedBy,
  c.CreatedDate,
  c.ModifiedBy,
  c.ModifiedDate,
  c.RecordDeleted,
  c.DeletedDate,
  c.DeletedBy,
  IsNull(pf.ProviderRefundId,0) AS ProviderRefundId,
  cast(IsNull(pf.CheckNumber,0) as int) AS 'ReturnedCheckNumber',
  c.[835FileText],
  @NextAvailabelCheckNumber as NextAvailabelCheckNumber,
 (SELECT InsurerName from Insurers WHERE InsurerId=c.InsurerId) AS InsurerName,
  IA.BankAccountName as InsurerBankAccountName,
  c.ReleaseToProvider
  FROM checks AS c LEFT OUTER JOIN ProviderRefunds AS pf ON pf.ReturnedcheckId=c.checkId  
  LEFT JOIN InsurerBankAccounts IA on IA.InsurerBankAccountId=C.InsurerBankAccountId      
  AND IsNull(pf.RecordDeleted,'N')='N' WHERE IsNull(c.RecordDeleted,'N')='N' AND c.checkId=@CheckId              
  
     
  SELECT [ProviderRefundId]
      ,[InsurerId]
      ,[ProviderId]
      ,[TaxIdType]
      ,[TaxId]
      ,[DateOfRefund]
      ,[CheckNumber]
      ,[CheckDate]
      ,[Amount]
      ,[BalanceAmount]
      ,[ReturnedCheckId]
      ,[InsurerBankAccountId]
      ,[RowIdentifier]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedDate]
      ,[DeletedBy]
  FROM [ProviderRefunds]
  WHERE IsNull(RecordDeleted,'N')='N'  AND ProviderRefundId=@ProviderRefundId        
        
 
  SELECT [InsurerId]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedDate]
      ,[DeletedBy]
      ,[InsurerName]
      ,[LegalName]
      ,[StartDate]
      ,[ExpirationDate]
      ,[Active]
      ,[TaxID]
      ,[ContactName]
      ,[ContactEmail]
      ,[ContactPhone]
      ,[Website]
      ,[APAccrualAccount]
      ,[Comment]
      ,[ARSystem]
      ,[ARAddress]
      ,[ClinicalSystem]
      ,[ClinicalAddress]
      ,[AccountingSystem]
      ,[AccountingAddress]
      ,[DefaultBankAccountId]
      ,[CashAccountNumber]
      ,[ReportPrinterLocation]
      ,[NationalProviderId]
      ,[SubstanceUseProvider]
      ,[SystemDatabaseId]
      ,[ServiceAreaId]
      ,(SELECT iba.LastCheckNumber FROM InsurerBankAccounts iba       
	   JOIN Checks c on c.InsurerBankAccountId = iba.InsurerBankAccountId       
       WHERE c.CheckId = @CheckId ) AS  LastCheckNumber 
       FROM Insurers 
       WHERE  IsNull(RecordDeleted,'N')='N' AND Active='Y' AND InsurerId=@InsurerId       
  
  SELECT [UnusedCheckId]
      ,[InsurerId]
      ,[CheckStartNumber]
      ,[CheckEndNumber]
      ,[Reason]
      ,[RowIdentifier]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedDate]
      ,[DeletedBy]
  FROM [UnusedChecks]
  WHERE  IsNull(RecordDeleted,'N')='N'  AND InsurerId=@InsurerId        
        
                   
  SELECT cl.ClaimLineId AS 'Claim Line',
  cl.ToDate AS 'DOS',
  bc.BillingCode AS 'Billing Code',
  CONVERT(INT,cl.Units) AS Units,
  cast(cp.Amount AS DECIMAL(18,2)) AS  'Amount',
   --Added by Revathi 21.Oct.2015   
   case when  ISNULL(Clients.ClientType,'I')='I' then
      ISNULL(Clients.LastName,'')+', '+ ISNULL(Clients.FirstName,'')
     else ISNULL(Clients.OrganizationName,'') end AS 'ClientName',
  --LastName + ', ' + Firstname AS 'ClientName',
  Clients.ClientId ,
   cl.Modifier1 as Modifier1,
  cl.Modifier2 as Modifier2,
  cl.Modifier3 as Modifier3,
  cl.Modifier4 as Modifier4          
  FROM Checks AS c        
  INNER JOIN ClaimLinePayments AS cp ON c.CheckId=cp.CheckId AND IsNull(cp.RecordDeleted,'N') ='N'        
  INNER JOIN  ClaimLines AS cl ON cp.ClaimLineId=cl.ClaimlineId AND IsNull(cl.RecordDeleted,'N') ='N'        
  INNER JOIN  BillingCodes AS bc ON bc.BillingCodeId=cl.BillingCodeId AND IsNull(bc.RecordDeleted,'N') ='N' AND bc.Active='Y'        
     
  INNER JOIN  Claims AS cm ON cm.ClaimId=cl.ClaimId AND IsNull(cm.RecordDeleted,'N') ='N'        
  INNER JOIN  Clients ON Clients.Clientid=cm.Clientid AND IsNull(clients.RecordDeleted,'N') ='N' 
  --AND Clients.Active='Y'        
  WHERE IsNull(c.RecordDeleted,'N') ='N' AND c.CheckId=@CheckId        
  UNION ALL 

  SELECT cl.ClaimLineId AS 'Claim Line',
  cl.ToDate AS 'DOS',
  bc.BillingCode AS 'Billing Code',
  CONVERT(INT,cl.Units) AS Units,
  (0-cp.Amount) AS 'Amount',
     --Added by Revathi 13.Oct.2015   
   case when  ISNULL(Clients.ClientType,'I')='I' then
      Clients.LastName+', '+ Clients.FirstName
     else Clients.OrganizationName end AS 'ClientName',
  --LastName + ', ' + Firstname AS 'ClientName',
  Clients.ClientId,
  cl.Modifier1 as Modifier1,
  cl.Modifier2 as Modifier2,
  cl.Modifier3 as Modifier3,
  cl.Modifier4 as Modifier4       
  FROM Checks AS c        
  INNER JOIN ClaimLineCredits AS cp ON c.CheckId=cp.CheckId AND IsNull(cp.RecordDeleted,'N') ='N'        
  INNER JOIN ClaimLines AS cl ON cp.ClaimLineId=cl.ClaimlineId AND IsNull(cl.RecordDeleted,'N') ='N'        
  INNER JOIN BillingCodes AS bc ON bc.BillingCodeId=cl.BillingCodeId AND IsNull(bc.RecordDeleted,'N') ='N' AND bc.Active='Y'                
  INNER JOIN Claims AS cm ON cm.ClaimId=cl.ClaimId AND IsNull(cm.RecordDeleted,'N') ='N'        
  INNER JOIN Clients ON Clients.Clientid=cm.Clientid AND IsNull(clients.RecordDeleted,'N') ='N' 
  --AND Clients.Active='Y'        
  WHERE IsNull(c.RecordDeleted,'N') ='N' AND c.CheckId=@CheckId        
        
      
  
  SELECT [InsurerBankAccountId]
      ,[InsurerId]
      ,[BankAccountName]
      ,[BankName]
      ,[BankAccountNumber]
      ,[LastCheckNumber]
      ,[CheckType]
      ,[CheckPrinterLocation]
      ,[Active]
      ,[FromDate]
      ,[ToDate]
      ,[Signer1]
      ,[Signer2]
      ,[RowIdentifier]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedDate]
      ,[DeletedBy]
  FROM [InsurerBankAccounts] WHERE IsNull(RecordDeleted,'N') ='N' AND Active='Y' 
  
 

 IF (@@ERROR!=0)  
	BEGIN  RAISERROR  20006  'ssp_GetCheckDetails: An Error Occured'    
    RETURN 
 END   
  
        


GO


