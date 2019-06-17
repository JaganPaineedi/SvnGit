IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = 
                  OBJECT_ID(N'[dbo].[ssp_CMGetContractBillingCodeRulesDetail]') 
                  AND type IN ( N'P', N'PC' )) 
DROP PROCEDURE [dbo].[ssp_CMGetContractBillingCodeRulesDetail] 

GO
/*********************************************************************/                  
/* Stored Procedure: dbo.ssp_GetContract            */                  
/* Copyright: 2005 Provider Claim Management System             */                  
/* Creation Date:  May 22/2014                                */                  
/*                                                                   */                  
/* Purpose: it will get all Contract Detail             */                 
/*                                                                   */                
/* Input Parameters: @Active          */                
/*                                                                   */                  
/* Output Parameters:                                */                  
/*                                                                   */                  
/* Return:Plan Records based on the applied filer  */                  
/*                                                                   */                  
/* Called By:                                                        */                  
/*                                                                   */                  
/* Calls:                                                            */                  
/*                                                                   */                  
/* Data Modifications:                                               */                  
/*                                                                   */                  
/* Updates:                                                          */                  
/* Date            Author      Purpose                                */                  
/* 05-Oct-2015* SuryaBalan To Get Provider Billing Code Rules #618*/
/*********************************************************************/       
/*********************************************************************/       
CREATE  PROCEDURE [dbo].[ssp_CMGetContractBillingCodeRulesDetail]     
(    
@ContractRuleId int   
)    
AS  

begin   

 
  
  select 
distinct CRU.ContractRuleId,
CRU.ContractId,
CRU.BillingCodeId,
CRU.UnlimitedDailyUnits,
CRU.DailyUnits,
CRU.UnlimitedWeeklyUnits,
CRU.WeeklyUnits,
CRU.UnlimitedMonthlyUnits,
CRU.MonthlyUnits,
CRU.UnlimitedYearlyUnits,
CRU.YearlyUnits,
CRU.AmountCap,
CRU.TotalAmountUsed,
CRU.ExceedLimitAction,
CRU.AuthorizationRequired,
CRU.RowIdentifier,
CRU.CreatedBy,
CRU.CreatedDate,
CRU.ModifiedBy,
CRU.ModifiedDate,
CRU.RecordDeleted,
CRU.DeletedDate,
CRU.DeletedBy,
PreviousPayerEOBRequired,
BC.BillingCode as CodeandModifiers,   
BC.CodeName as BillingCodeName,
'$'+ convert(varchar,cast(CRU.AmountCap as money),10)  as AmountCap1
  from 
  ContractRules CRU
  left join BillingCodes BC on BC.BillingCodeId = CRU.BillingCodeId
 -- left join BillingCodeModifiers BM on BC.BillingCodeId = BM.BillingCodeId
  left join GlobalCodes GC on GC.GlobalCodeId = BC.UnitType
  where (ISNULL(CRU.RecordDeleted, 'N') = 'N')  and CRU.ContractRuleId =@ContractRuleId
  
  
  
  

  --Checking For Errors    
If (@@error!=0)  Begin  RAISERROR  20006  'ssp_CMGetContractBillingCodeRulesDetail: An Error Occured'     Return  End    
          
 end