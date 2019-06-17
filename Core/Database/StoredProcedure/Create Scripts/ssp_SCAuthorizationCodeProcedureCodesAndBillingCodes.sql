IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCAuthorizationCodeProcedureCodesAndBillingCodes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCAuthorizationCodeProcedureCodesAndBillingCodes]
GO
CREATE  PROCEDURE  [dbo].[ssp_SCAuthorizationCodeProcedureCodesAndBillingCodes]        
        
As        
  
Begin                
/*********************************************************************/                  
/* Stored Procedure: dbo.ssp_SCAuthorizationCodeDetails    */        
                                                
        
/* Copyright: 2006 Streamlin Healthcare Solutions           */                  
        
/* Creation Date:  01/07/2015                                   */                  
/*                                                                   */                  
/* Purpose: Gets List of  data show in AuthorizationCodeDetails  page*/                 
/*                                                                   */                
/* Input Parameters: */                
/*                                                                   */                   
/* Output Parameters:                                */                  
/*                                                                   */                  
/* Return:   */                  
/*                                                                   */                  
/* Called By: */                  
        
/*                                                                   */                  
/* Calls:                                                            */                  
/*                                                                   */                  
/* Data Modifications:                                               */                  
/*                                                                   */                  
/*   Updates:                                                        */                  
        
/*       Date              Author                  Purpose            */                  
/* 01/07/2015              Bernardin               Created           */
/*********************************************************************/                   
              
  --For Procedures Code      
          
  SELECT  '' as DeleteButton, '0' as CheckBox, ProcedureCodeId,        
           DisplayAs,        
           ProcedureCodeName,        
           Active,        
           EnteredAs,        
           FaceToFace,        
           GroupCode,        
           CreditPercentage,        
           --ExternalReferenceId,        
           CreatedBy,        
           CreatedDate,        
           ModifiedBy,        
           ModifiedDate,        
           RecordDeleted,        
           DeletedDate,        
           DeletedBy,  
           ProcedureCodes.AllowDecimals,  
           ProcedureCodes.AssociatedNoteId,  
           ProcedureCodes.Category1,        
           ProcedureCodes.Category2,  
           ProcedureCodes.Category3,  
           ProcedureCodes.DisplayDocumentAsProcedureCode,  
           ProcedureCodes.DoesNotRequireStaffForService,  
           ProcedureCodes.EndDateEqualsStartDate,  
           ProcedureCodes.ExternalCode1,  
           ProcedureCodes.ExternalCode2,  
           ProcedureCodes.ExternalSource1,  
           ProcedureCodes.ExternalSource2,  
           ProcedureCodes.MaxUnits,  
           ProcedureCodes.MedicationCode,  
           ProcedureCodes.MinUnits,  
           ProcedureCodes.NotBillable,  
           ProcedureCodes.NotOnCalendar,  
           ProcedureCodes.RequiresSignedNote,  
           ProcedureCodes.RequiresTimeInTimeOut,  
           ProcedureCodes.UnitIncrements,  
           ProcedureCodes.UnitsList  
           --ProcedureCodes.RowIdentifier  
             
             
             
      FROM ProcedureCodes where Active='Y'  and isNull(RecordDeleted,'N')<>'Y' order by ProcedureCodeName        
        
  --Checking For Errors        
  If (@@error!=0)        
  Begin        
   RAISERROR  20006   'ssp_SCAuthorizationCodeDetails: An Error Occured'         
   Return        
   End                 
           
--For Billing Codes            
 SELECT  '' as DeleteButton, '0' as CheckBox, BillingCodeId,      
           BillingCode,      
           CodeName,      
           Active,      
           CreatedBy,      
           CreatedDate,      
           ModifiedBy,      
           ModifiedDate,      
           RecordDeleted,      
           DeletedDate,      
           DeletedBy,  
           BillingCodes.Units,  
           BillingCodes.UnitType,  
           BillingCodes.ReportingUnitType,  
           HospitalCode,  
           ExcludeDischargeDay,  
           NoRateCode,  
           ExternalCode1,  
           ExternalSource1,  
           ExternalCode2,  
           ExternalSource2,  
           UnlimitedDailyUnits,  
           DailyUnits,  
           UnlimitedWeeklyUnits,  
           WeeklyUnits,  
           UnlimitedMonthlyUnits,  
           MonthlyUnits,  
           UnlimitedYearlyUnits,  
           YearlyUnits,  
           ExceedLimitAction,  
           ServiceEndDateEqualsStartDate,  
           AllInsurers,  
           ValidAllPlans,  
           AuthorizationRequired,  
           RowIdentifier,  
           ReportingUnits  
                 
      FROM BillingCodes where Active='Y'  and isNull(RecordDeleted,'N')<>'Y' order by CodeName      
      
 --Checking For Errors      
  If (@@error!=0)      
  Begin      
   RAISERROR  20006   'ssp_SCAuthorizationBillingDetails: An Error Occured'       
   Return      
   End               
        
        
End     