/****** Object:  StoredProcedure [dbo].[ssp_CMGetAuthorizationContractBillingCodes]    Script Date: 05/13/2014 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMGetAuthorizationContractBillingCodes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CMGetAuthorizationContractBillingCodes]
GO

/****** Object:  StoredProcedure [dbo].[ssp_CMGetAuthorizationContractBillingCodes]    Script Date: 12/17/2018 8:37:53 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_CMGetAuthorizationContractBillingCodes] --1067,1,'03/15/2010','09/30/2010'
        (
        @ProviderId int,
        @InsurerId int,
        @EffectiveFrom DateTime,
        @EffectiveTo DateTime
        )
                 
AS          
/*********************************************************************/                        
/* Stored Procedure: dbo.ssp_CMGetAuthorizationContractBillingCodes           */                        
/* Copyright: 2005 Provider Claim Management System             */                        
/* Creation Date:  9/11/2010                                    */                        
/*                                                                   */                        
/* Purpose: it will get list of all billing codes with contracts            */                       
/*                                                                   */                      
/* Output Parameters:                                */                        
/*                                                                   */                        
/* Called By:                                                        */                        
/*                                                                   */                        
/* Calls:                                                            */                        
/*                                                                   */                        
/* Data Modifications:                                               */                        
/*                                                                   */                        
/* Updates:                                                          */                        
/*  Date          Author      Purpose                                    */                        
/* 9/11/2010   Priya      Created                                    */
/* 17/11/2018  Jeffin	  Added condition for checking the Start and End Date from BillingCode Modifier table. Why : For task KCMHSAS - Enhancements 900.77 */                    
/*********************************************************************/    

    if(@ProviderId = 0 and  @InsurerId = 0 and @EffectiveFrom = '' and  @EffectiveTo = '')
    begin
   
     Select '' as BillingCode,0 as BillingCodeId,'' as EffectiveFrom,'' as EffectiveTo,0 as ProviderId,0 as InsurerId,'' as UnitsType      
    UNION       
    Select Ltrim(Rtrim(BillingCodes.BillingCode)) + ' - ' +  Ltrim(RTrim(BillingCodes.CodeName)), ContractRates.BillingCodeId, CONVERT(varchar, Contracts.StartDate, 101) AS EffectiveFrom, CONVERT(varchar,Contracts.EndDate, 101) AS EffectiveTo, Contracts.providerId, Contracts.InsurerId, CAST(CAST(BillingCodes.Units AS decimal(18, 0)) AS varchar) + ' ' + GlobalCodes.CodeName AS UnitsType      
    FROM Contracts       
    INNER JOIN ContractRates ON Contracts.ContractId = ContractRates.ContractId AND ISNULL(Contracts.RecordDeleted, 'N') = 'N' AND ISNULL(ContractRates.RecordDeleted, 'N') = 'N'       
    INNER JOIN BillingCodes ON ContractRates.BillingCodeId = BillingCodes.BillingCodeId       
    INNER JOIN GlobalCodes ON BillingCodes.UnitType = GlobalCodes.GlobalCodeId      
    Where  (ISNULL(BillingCodes.RecordDeleted, 'N') = 'N') AND (ContractRates.Active = 'Y') AND (BillingCodes.Active = 'Y') AND (GlobalCodes.Active = 'Y') AND  (ISNULL(GlobalCodes.RecordDeleted, 'N') = 'N')      
    end
    else
    begin
    
    Select '' as BillingCode,0 as BillingCodeId,'' as EffectiveFrom,'' as EffectiveTo,0 as ProviderId,0 as InsurerId,'' as UnitsType      
    UNION       
    Select Ltrim(Rtrim(BillingCodes.BillingCode)) + ' - ' +  Ltrim(RTrim(BillingCodes.CodeName)), ContractRates.BillingCodeId, CONVERT(varchar, Contracts.StartDate, 101) AS EffectiveFrom, CONVERT(varchar,Contracts.EndDate, 101) AS EffectiveTo, Contracts.providerId, Contracts.InsurerId, CAST(CAST(BillingCodes.Units AS decimal(18, 0)) AS varchar) + ' ' + GlobalCodes.CodeName AS UnitsType      
    FROM Contracts  
    INNER JOIN ContractRates ON Contracts.ContractId = ContractRates.ContractId AND ISNULL(Contracts.RecordDeleted, 'N') = 'N' AND ISNULL(ContractRates.RecordDeleted, 'N') = 'N'       
    INNER JOIN BillingCodes ON ContractRates.BillingCodeId = BillingCodes.BillingCodeId       
    INNER JOIN GlobalCodes ON BillingCodes.UnitType = GlobalCodes.GlobalCodeId  
	INNER JOIN BillingCodeModifiers ON BillingCodes.BillingCodeId=BillingCodeModifiers.BillingCodeId    
    Where  ((ISNULL(BillingCodes.RecordDeleted, 'N') = 'N') AND (ContractRates.Active = 'Y') AND (BillingCodes.Active = 'Y') AND (GlobalCodes.Active = 'Y') AND  (ISNULL(GlobalCodes.RecordDeleted, 'N') = 'N')      
    and Contracts.providerId=@ProviderId and Contracts.InsurerId=@InsurerId 
    and (Contracts.StartDate>=@EffectiveFrom and Contracts.StartDate<=@EffectiveTo 
    or (Contracts.StartDate <=@EffectiveFrom and Contracts.EndDate >=@EffectiveFrom and Contracts.EndDate<=@EffectiveTo)
    or (Contracts.StartDate <=@EffectiveFrom and Contracts.EndDate >=@EffectiveFrom and Contracts.EndDate>=@EffectiveTo))
    or (Contracts.ProviderId=0))
	--Added by Jeffin on 17/11/2018 - For task KCMHSAS - Enhancements 900.77
	AND ((cast(isnull(BillingCodeModifiers.StartDate,0) as date) <= cast(isnull(@EffectiveFrom,0) as date)) OR @EffectiveFrom IS NULL)
	AND ((cast(isnull(@EffectiveTo,2958463) as date)<= cast(isnull(BillingCodeModifiers.EndDate,2958463) as date)) OR @EffectiveTo IS NULL)
	AND isnull(BillingCodeModifiers.Active,'N')='Y'

    
     end 
  --Checking For Errors      
  If (@@error!=0)  Begin  RAISERROR ('ssp_CMGetAuthorizationContractBillingCodes: An Error Occured',16,1)     Return  End       
      
      
   
      
      
      
      
GO


