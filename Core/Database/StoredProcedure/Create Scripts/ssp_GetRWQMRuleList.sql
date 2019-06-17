IF EXISTS (SELECT
    *
  FROM sys.objects
  WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetRWQMRuleList]')
  AND type IN (
  N'P'
  , N'PC'
  ))
  DROP PROCEDURE [dbo].[ssp_GetRWQMRuleList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_GetRWQMRuleList] 
/********************************************************************************                                                   
** Stored Procedure: ssp_GetRWQMRuleList                                                      
**                                                    
** Copyright: Streamline Healthcate Solutions                                                      
** Updates:                                                                                                           
** Date            Author              Purpose  
  26/July/2017      Ajay       What/why: Get data for RWQM Rule for AHN-Customization: #44     									
*********************************************************************************/
AS
BEGIN
  BEGIN TRY
 select 
 RWQMRuleId
,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate
,RecordDeleted
,DeletedBy
,DeletedDate
,StartDate
,EndDate
,Active
,RWQMRuleName
,RulePriority
,RuleType
,RuleNumberOfDays
,Balance
,IncludeFlaggedCharges
,DaysToDueDate
,DaysToOverdue
,AllChargeActions
,ChargesActions
,AllChargeStatuses
,ChargeStatuses
,AllFinancialAssignments
,FinancialAssignments
,Comments
  from RWQMRules
 where ISNULL(RecordDeleted,'N')='N'
  END TRY

  BEGIN CATCH
    DECLARE @error varchar(8000)

    SET @error = CONVERT(varchar, ERROR_NUMBER()) + '*****' + CONVERT(varchar(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()), 'ssp_GetRWQMRuleList') + '*****' + CONVERT(varchar, ERROR_LINE()) + '*****' + CONVERT(varchar, ERROR_SEVERITY()) + '*****' + CONVERT(varchar, ERROR_STATE())

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