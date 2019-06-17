IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetBillingCodes]') AND type IN (N'P', N'PC'))
  DROP PROCEDURE [dbo].[ssp_GetBillingCodes] 
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetBillingCodes] 
(
	@BillingCodeID int,
	@SiteId int=null,
	@ProviderId int=null   
) 

/********************************************************************************    
-- Stored Procedure: dbo.[ssp_GetBillingCodes]      
--  
-- Copyright: Streamline Healthcate Solutions 
--    
-- Created:           
-- Date			  Author				Purpose 
-- 03-Nov-2015   Arjun K R			Task #604.6 Network180 Customizations.
*********************************************************************************/  

   
AS    
BEGIN    
  BEGIN TRY    
  
  DECLARE @DFAId INT

  SET @DFAId=(SELECT AuthorizationRequestFormId FROM BillingCodes WHERE BillingCodeId=@BillingCodeID AND ISNULL(RecordDeleted, 'N') <> 'Y') 
 
 
  IF NOT EXISTS (Select FormId from Forms Where Formid=@DFAId)
	BEGIN
		 SET @DFAId=(SELECT TOP 1 AuthorizationRequestFormId FROM BillingCodeAuthorizationRequestForms WHERE BillingCodeId=@BillingCodeID AND ProviderId=@ProviderId AND SiteId=@SiteId AND ISNULL(RecordDeleted, 'N') <> 'Y')
   END
  
 
   SELECT [BillingCodeId]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedBy]
      ,[DeletedDate]
      ,[ProcedureCodeId]
      ,[BillingCode]
      ,[CodeName]
      ,[Active]
      ,[Units]
      ,[UnitType]
      ,[ReportingUnits]
      ,[ReportingUnitType]
      ,[HospitalCode]
      ,[ExcludeDischargeDay]
      ,[NoRateCode]
      ,[ExternalCode1]
      ,[ExternalSource1]
      ,[ExternalCode2]
      ,[ExternalSource2]
      ,[UnlimitedDailyUnits]
      ,[DailyUnits]
      ,[UnlimitedWeeklyUnits]
      ,[WeeklyUnits]
      ,[UnlimitedMonthlyUnits]
      ,[MonthlyUnits]
      ,[UnlimitedYearlyUnits]
      ,[YearlyUnits]
      ,[ExceedLimitAction]
      ,[ServiceEndDateEqualsStartDate]
      ,[AllInsurers]
      ,[ValidAllPlans]
      ,[AuthorizationRequired]
      ,[AllowMultipleClaimsPerDay]
      ,[RowIdentifier]
      ,@DFAId AS [AuthorizationRequestFormId]
  FROM [BillingCodes]
  WHERE BillingCodeId=@BillingCodeID
  AND ISNULL(RecordDeleted, 'N') <> 'Y'    
       
  END TRY    
    
  BEGIN CATCH    
    DECLARE @Error varchar(8000)    
    
    SET @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****'    
    + CONVERT(varchar(4000), ERROR_MESSAGE())    
    + '*****'    
    + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()),    
    'ssp_GetBillingCodes')    
    + '*****' + CONVERT(varchar, ERROR_LINE())    
    + '*****' + CONVERT(varchar, ERROR_SEVERITY())    
    + '*****' + CONVERT(varchar, ERROR_STATE())    
    
    RAISERROR (@Error,    
    -- Message text.                                                         
    16,    
    -- Severity.                                       
    1    
    -- State.                                                                                                                        
    );    
  END CATCH    
END 