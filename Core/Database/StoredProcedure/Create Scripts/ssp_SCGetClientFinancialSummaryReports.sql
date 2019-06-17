

/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientFinancialSummaryReports]    Script Date: 05/15/2013 18:40:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetClientFinancialSummaryReports]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetClientFinancialSummaryReports]
GO


/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientFinancialSummaryReports]    Script Date: 05/15/2013 18:40:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetClientFinancialSummaryReports]
	@ClientId int
	/********************************************************************************                                  
-- Stored Procedure: dbo.ssp_GetPermissionItems                                    
--                                  
-- Copyright: Streamline Healthcate Solutions                                  
--                                  
-- Purpose: gets a list of permission items                           
--                                  
-- Updates:                                                                                         
-- Date				Author					Purpose   
   May 22 2014		Chethan N				Retrieving data ClientcoveragePlans for Finance tab in Client Information
-- 04.19.2016	Venkatesh				Update the Financial Record.
*************************************************************************************/                          
AS
BEGIN
 Begin try 
 EXEC ssp_SCWebUpdateFinancial @ClientId -- Added by Venkatesh as per task 697
 
	SELECT [ClientId]
      ,[CoverageBalanceCurrent]
      ,[CoverageBalance30]
      ,[CoverageBalance90]
      ,[CoverageBalance180]
      ,[CoverageBalanceTotal]
      ,[ClientBalanceCurrent]
      ,[ClientBalance30]
      ,[ClientBalance90]
      ,[ClientBalance180]
      ,[ClientBalanceTotal]
      ,[ClientLastPaymentAmount]
      ,[ClientLastPaymentDate]
      ,[FeeArrangement]
      ,[Comment]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedDate]
      ,[DeletedBy]
  FROM [ClientFinancialSummaryReports]
  WHERE ClientId=@ClientId and ISNULL(RecordDeleted,'N')<>'Y'
  
  SELECT cch.ClientCoverageHistoryId AS ClientCoverageId
	,cch.StartDate
	,cch.EndDate
	,cp.CoveragePlanName
	,ccp.InsuredId
	,ccp.GroupNumber
	,'' AS AuthorizationRequired
	,ccp.PlanContactPhone AS ContactPhone
	,ccp.ClientId
	,cch.COBOrder AS Priority
	,cp.MedicaidPlan AS Medicaid
	,cch.CreatedBy
	,cch.CreatedDate
	,cch.ModifiedBy
	,cch.ModifiedDate
	,cch.RecordDeleted
	,cch.DeletedDate
	,cch.DeletedBy
FROM ClientcoveragePlans AS ccp
INNER JOIN CoveragePlans AS cp ON cp.CoveragePlanId = ccp.CoveragePlanId
INNER JOIN ClientCoverageHistory AS cch ON cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
WHERE ccp.ClientId = @ClientId
	AND datediff(day, cch.StartDate, getdate()) >= 0
	AND (
		cch.EndDate IS NULL
		OR datediff(day, cch.EndDate, getdate()) <= 0
		)
	AND isnull(ccp.RecordDeleted, 'N') = 'N'
	AND isnull(cch.RecordDeleted, 'N') = 'N'
ORDER BY cch.StartDate DESC
	,Priority
	
	END TRY                                                 
                                                                                      
BEGIN CATCH          
        
DECLARE @Error varchar(8000)                                                       
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                     
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCGetClientFinancialSummaryReports')                                                                                     
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                      
    + '*****' + Convert(varchar,ERROR_STATE())                                   
 RAISERROR                                                                                     
 (                                                       
  @Error, -- Message text.                                                                                    
  16, -- Severity.                                                                                    
  1 -- State.                                                                                    
 );                                                                                 
END CATCH 
END

GO


