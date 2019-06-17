/****** Object:  StoredProcedure [dbo].[ssp_CMGetInsurerDetails]    Script Date: 08/19/2014 16:04:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMGetInsurerDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CMGetInsurerDetails]
GO

/****** Object:  StoredProcedure [dbo].[ssp_CMGetInsurerDetails]    Script Date: 08/19/2014 16:04:33 ******/
--Modified by SuryBalan for Task 50 CM to SC Project, For Inactive Bank accounts also we can add plans
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

----------------------------------------------------------------------
--Author : Modified by Shruthi.S  
--Date   : 28/07/2016
--Purpose: Changed * from field names for InsurerBankAccounts table.Ref : #24 AspenPointe-Environment Issues.

--Author : Arjun K R
--Date   : 27/11/2018
--Purpose: Added InsurerAdjustmentReasons and GlobalSubCodes tables for select statement. Task #15 Partner Solutions Enhancement.

----------------------------------------------------------------------


CREATE PROCEDURE [dbo].[ssp_CMGetInsurerDetails] 
      
@InsurerId int      
      
AS      
BEGIN TRY
 --For Insurer general  and Information System details       
 Select * from Insurers as i Where isNull(i.RecordDeleted,'N') ='N' and i.InsurerName <> 'All'  and InsurerId=@InsurerId      
    
--Checking For Errors    
If (@@error!=0)  Begin  RAISERROR ('ssp_CMGetInsurerDetails: An Error Occured ',16,1);
     Return  End    
        
SELECT     InsurerAddresses.*,GlobalCodes.SortOrder    
FROM         InsurerAddresses INNER JOIN    
                      GlobalCodes ON InsurerAddresses.AddressType = GlobalCodes.GlobalCodeId    
WHERE     (ISNULL(InsurerAddresses.RecordDeleted, 'N') ='N' ) AND (InsurerAddresses.InsurerId = @InsurerId) AND (GlobalCodes.Active = 'Y') AND     
                      (ISNULL(GlobalCodes.RecordDeleted, 'N') = 'N')    
    
--Checking For Errors    
If (@@error!=0)  Begin  RAISERROR ('ssp_CMGetInsurerDetails: An Error Occured ',16,1);
    Return  End    
       
 --For Insurer Plans details      
--Select 'D' as 'DeleteButton','N' as 'RadioButton',p.PlanName,ip.InsurerPlanId,ip.InsurerId,p.PlanId,ip.StartDate,ip.ExpirationDate,ip.Active,ip.Comment,ip.RowIdentifier,ip.CreatedBy,ip.CreatedDate,ip.ModifiedBy,ip.ModifiedDate,ip.RecordDeleted,ip.DeletedDate,ip.DeletedBy      
-- from InsurerPlans as ip inner join Plans as p on ip.PlanId=p.PlanId      
-- Where isNull(ip.RecordDeleted,'N') ='N' and isNull(p.RecordDeleted,'N') ='N'  and p.Active='Y'       
-- --and (convert(datetime,p.Expirationdate,101)>=convert(datetime,getdate()-1,101)  or isnull(p.Expirationdate,'') ='') --2/26/2006 now display  all Insurer Plans as Plan expiration date can be less than current date also      
-- and InsurerId=@InsurerId      
    
       
--Checking For Errors    
If (@@error!=0)  Begin  RAISERROR ('ssp_CMGetInsurerDetails: An Error Occured ',16,1);
     Return  End    
  
 -- Addded By Neelam Prasad   24/04/2007  
 -- For InsurerBankAccounts  
  Select InsurerBankAccountId,
InsurerId,
BankAccountName,
BankName,
BankAccountNumber,
LastCheckNumber,
CheckType,
CheckPrinterLocation,
Active,
FromDate,
ToDate,
Signer1,
Signer2,
RowIdentifier,
CreatedBy,
CreatedDate,
ModifiedBy,
ModifiedDate,
RecordDeleted,
DeletedDate,
DeletedBy From InsurerBankAccounts 
  Where isNull(RecordDeleted,'N') ='N' and InsurerId=@InsurerId  
  -- and Active='Y'  
    
--Checking For Errors    
If (@@error!=0)  Begin  RAISERROR ('ssp_CMGetInsurerDetails: An Error Occured ',16,1);
     Return  End    
  
  --For InsurerBankAccountPlans  
   Select B.InsurerBankAccountCoveragePlanId,B.InsurerBankAccountId,B.CoveragePlanId,B.CreatedBy,B.CreatedDate,B.ModifiedBy,B.ModifiedDate,B.RecordDeleted,B.DeletedDate,B.DeletedBy From InsurerBankAccounts A,InsurerBankAccountCoveragePlans B   
       Where A.InsurerBankAccountId = B.InsurerBankAccountId and   
  -- A.Active='Y' and   
   isNull(A.RecordDeleted,'N') ='N' and  
   isNull(B.RecordDeleted,'N') ='N' and  
   A.InsurerId=@InsurerId   
--Checking For Errors    
If (@@error!=0)  Begin  RAISERROR ('ssp_CMGetInsurerDetails: An Error Occured ',16,1);
    Return  End    
  

Select 0 as 'CheckBox',CoveragePlanId, CoveragePlanName from CoveragePlans  
 Where Active='Y'   
 --and (convert(datetime,Expirationdate,101)>=convert(datetime,getdate()-1,101)  or isnull(Expirationdate,'') ='') --2/26/2006 now we have to get All Active Plans as Plan  expiration date can be less than current date  
 and IsNull(RecordDeleted,'N') ='N'  
 order by CoveragePlanName   

-- Added On Date   : 27/11/2018
SELECT [InsurerCOBExcludeAdjustmentReasonId]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedBy]
      ,[DeletedDate]
      ,[InsurerId]
      ,[AdjustmentReason]
FROM [InsurerCOBExcludeAdjustmentReasons]
WHERE InsurerId=@InsurerId
AND ISNULL(RecordDeleted,'N')='N'

SELECT GSC.[GlobalSubCodeId]
      ,GSC.[GlobalCodeId]
      ,GSC.[SubCodeName]
      ,GSC.[Code]
      ,GSC.[Description]
      ,GSC.[Active]
      ,GSC.[CannotModifyNameOrDelete]
      ,GSC.[SortOrder]
      ,GSC.[ExternalCode1]
      ,GSC.[ExternalSource1]
      ,GSC.[ExternalCode2]
      ,GSC.[ExternalSource2]
      ,GSC.[Bitmap]
      ,GSC.[BitmapImage]
      ,GSC.[Color]
      ,GSC.[RowIdentifier]
      ,GSC.[CreatedBy]
      ,GSC.[CreatedDate]
      ,GSC.[ModifiedBy]
      ,GSC.[ModifiedDate]
      ,GSC.[DeletedBy]
      ,GSC.[RecordDeleted]
      ,GSC.[DeletedDate]
  FROM [GlobalSubCodes] GSC
  INNER JOIN GlobalCodes GC ON GSC.GlobalCodeId=GC.GlobalCodeId
  WHERE ISNULL(GSC.RecordDeleted,'N')='N'
  AND ISNULL(GC.RecordDeleted,'N')='N'
  AND GC.Category='CLAIMADJGROUPCODE'

 END TRY

BEGIN CATCH  
     IF @@error <> 0  
		 BEGIN    
		    RAISERROR('Failed to execute ssp_CMGetInsurerDetails.', 16, 1);
		  END  
  END CATCH  



