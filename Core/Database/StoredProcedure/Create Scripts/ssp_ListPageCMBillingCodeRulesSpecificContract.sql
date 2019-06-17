/****** Object:  StoredProcedure [dbo].[ssp_ListPageCMBillingCodeRulesSpecificContract]    Script Date: 04/09/2014 10:25:22 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageCMBillingCodeRulesSpecificContract]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_ListPageCMBillingCodeRulesSpecificContract]
GO

/****** Object:  StoredProcedure [dbo].[ssp_ListPageCMBillingCodeRulesSpecificContract]    Script Date: 04/09/2014 10:25:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_ListPageCMBillingCodeRulesSpecificContract] (
	
	@SiteId INT
	
	,@ContractDate DATETIME
	,@ContractEndDate DATETIME
	,@InsurerId INT
	,@ContractId INT
	,@SortExpression VARCHAR(100)
	
	,@PageNumber INT
	,@PageSize INT
	,@OtherFilter INT
	)
AS
/*********************************************************************/
/* Stored Procedure: dbo.ssp_ListPageCMBillingCodeRulesSpecificContract                  */
/* Copyright: 2005 Provider Claim Management System                  */
/* Creation Date:  05/13/2014                                    */
/*                                                                   */
/* Purpose: To  show Member  Provider Contract datagrid               */
/*                                                                   */
/* Input Parameters:                                                 */
/*                                                                   */
/* Output Parameters:                                                */
/*                                                                   */
/*                                                                   */
/* Called By:                                                        */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/*  Date                 Author       Purpose                        */
/* 26-Sept-2015 SuryaBalan Network Customization- Created for Provider Contracts Rules List Page under Provider COntracts Detail Page*/
/* 6-Oct-2015 SuryaBalan Network Customization- Added Sorting Code*/
/*  21-Aug-2017 SuryaBalan  Billing Code Rules List Page Items not matching with Exported Data, So I have changed the order of columns KCMHSAS - Support #900.81*/
/*  28-Aug-2017 SuryaBalan  Kalamzoo Needs Contract Name at the beginning of the Billing Code  Rule export So I have added the name KCMHSAS - Support #900.81*/
/*  13-Sept-2017 SuryaBalan  Fixed in BillingCodeRules list-EOB required field is showing 'Yes' eventhough it is null  in backend and have done the same for AuthorizationRequired KCMHSAS - Support #900.81*/
/*********************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @CustomFiltersApplied CHAR(1)

		CREATE TABLE #CustomFilters (DocumentId INT)

		SET @CustomFiltersApplied = 'N'

		
		CREATE TABLE #ResultSet (
		     ContractName VARCHAR(MAX)  --SuryaBalan 28-Aug-2017
			,ContractRuleId INT
			,ContractId INT
			,BillingCodeId INT
			,UnlimitedDailyUnits VARCHAR(3)
			,DailyUnits DECIMAL
			,UnlimitedWeeklyUnits VARCHAR(3)
			,WeeklyUnits DECIMAL
			,UnlimitedMonthlyUnits VARCHAR(3)
			,MonthlyUnits DECIMAL
			,UnlimitedYearlyUnits VARCHAR(3)
			,YearlyUnits DECIMAL
			,AmountCap MONEY
			,TotalAmountUsed MONEY
			,ExceedLimitAction VARCHAR(3)
			,AuthorizationRequired VARCHAR(3)
			,PreviousPayerEOBRequired VARCHAR(100)
			,CodeandModifiers VARCHAR(100)
			,BillingCodeName VARCHAR(100)
			,AmountCap1 MONEY
			)

		--,EffectiveAs Date
		--GET CUSTOM FILTERS           
		IF @OtherFilter > 10000
		BEGIN
			SET @CustomFiltersApplied = 'Y'

			IF EXISTS (
					SELECT *
					FROM sys.objects
					WHERE object_id = OBJECT_ID(N'[dbo].[scsp_ListPageCMProviderSpecificContract]')
						AND type IN (
							N'P'
							,N'PC'
							)
					)
			BEGIN
				INSERT INTO #CustomFilters (DocumentId)
				EXEC scsp_ListPageCMProviderSpecificContract @SiteId = @SiteId
					 
					,@ContractDate =@ContractDate
					,@ContractEndDate =@ContractEndDate
					,@InsurerId =@InsurerId
					,@ContractId =@ContractId
			END
		END

		INSERT INTO #ResultSet (
		    ContractName      --SuryaBalan 28-Aug-2017
			,ContractRuleId
			,ContractId
			,BillingCodeId
			,UnlimitedDailyUnits
			,DailyUnits
			,UnlimitedWeeklyUnits
			,WeeklyUnits
			,UnlimitedMonthlyUnits
			,MonthlyUnits
			,UnlimitedYearlyUnits
			,YearlyUnits
			,AmountCap
			,TotalAmountUsed
			,ExceedLimitAction
			,AuthorizationRequired
			,PreviousPayerEOBRequired
			,CodeandModifiers
			,BillingCodeName
			,AmountCap1
			)
		--,EffectiveAs
		SELECT DISTINCT 
		    C.ContractName    --SuryaBalan 28-Aug-2017
		    ,CRU.ContractRuleId
			,CRU.ContractId
			,CRU.BillingCodeId
			,CRU.UnlimitedDailyUnits
			,CRU.DailyUnits
			,CRU.UnlimitedWeeklyUnits
			,CRU.WeeklyUnits
			,CRU.UnlimitedMonthlyUnits
			,CRU.MonthlyUnits
			,CRU.UnlimitedYearlyUnits
			,CRU.YearlyUnits
			,CRU.AmountCap
			,CRU.TotalAmountUsed
			,CRU.ExceedLimitAction
			,CRU.AuthorizationRequired
			
			,PreviousPayerEOBRequired
			,BC.BillingCode AS CodeandModifiers
			,BC.CodeName AS BillingCodeName
			,'$' + convert(VARCHAR, cast(CRU.AmountCap AS MONEY), 10) AS AmountCap1
		FROM ContractRules CRU
		LEFT JOIN Contracts C on C.ContractId=CRU.ContractId and ISNULL(C.RecordDeleted, 'N') = 'N' --SuryaBalan 28-Aug-2017
		LEFT JOIN BillingCodes BC ON BC.BillingCodeId = CRU.BillingCodeId
		-- left join BillingCodeModifiers BM on BC.BillingCodeId = BM.BillingCodeId
		LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = BC.UnitType
		WHERE (ISNULL(CRU.RecordDeleted, 'N') = 'N')
			AND CRU.ContractId = @ContractId
		
			;

		WITH counts
		AS (
			SELECT Count(*) AS TotalRows
			FROM #ResultSet
			)
			,RankResultSet
		AS (
			SELECT
			     ContractName  --SuryaBalan 28-Aug-2017
			    ,ContractRuleId
				,ContractId
				,BillingCodeId
				,UnlimitedDailyUnits
				,DailyUnits
				,UnlimitedWeeklyUnits
				,WeeklyUnits
				,UnlimitedMonthlyUnits
				,MonthlyUnits
				,UnlimitedYearlyUnits
				,YearlyUnits
				,AmountCap
				,TotalAmountUsed
				,ExceedLimitAction
				,AuthorizationRequired
				,PreviousPayerEOBRequired
				,CodeandModifiers
				,BillingCodeName
				,AmountCap1
				--,EffectiveAs
				,Count(*) OVER () AS TotalCount
				,Rank() OVER (
					ORDER BY CASE 
							WHEN @SortExpression = 'ContractRuleId'
								THEN ContractRuleId
							END
						,CASE 
							WHEN @SortExpression = 'ContractRuleId desc'
								THEN ContractRuleId
							END DESC,
							 CASE 
							WHEN @SortExpression = 'CodeandModifiers'
								THEN CodeandModifiers
							END
						,CASE 
							WHEN @SortExpression = 'CodeandModifiers desc'
								THEN CodeandModifiers
							END DESC,
							 CASE 
							WHEN @SortExpression = 'DailyUnits'
								THEN DailyUnits
							END
						,CASE 
							WHEN @SortExpression = 'DailyUnits desc'
								THEN DailyUnits
							END DESC,
							 CASE 
							WHEN @SortExpression = 'WeeklyUnits'
								THEN WeeklyUnits
							END
						,CASE 
							WHEN @SortExpression = 'WeeklyUnits desc'
								THEN WeeklyUnits
							END DESC,
							 CASE 
							WHEN @SortExpression = 'MonthlyUnits'
								THEN MonthlyUnits
							END
						,CASE 
							WHEN @SortExpression = 'MonthlyUnits desc'
								THEN MonthlyUnits
							END DESC,
							 CASE 
							WHEN @SortExpression = 'YearlyUnits'
								THEN YearlyUnits
							END
						,CASE 
							WHEN @SortExpression = 'YearlyUnits desc'
								THEN YearlyUnits
							END DESC,
							
							 CASE 
							WHEN @SortExpression = 'AmountCap1'
								THEN AmountCap1
							END
						,CASE 
							WHEN @SortExpression = 'AmountCap1 desc'
								THEN AmountCap1
							END DESC,
							CASE 
							WHEN @SortExpression = 'ExceedLimitAction'
								THEN ExceedLimitAction
							END
						,CASE 
							WHEN @SortExpression = 'ExceedLimitAction desc'
								THEN ExceedLimitAction
							END DESC,
							CASE 
							WHEN @SortExpression = 'AuthorizationRequired'
								THEN AuthorizationRequired
							END
						,CASE 
							WHEN @SortExpression = 'AuthorizationRequired desc'
								THEN AuthorizationRequired
							END DESC,
							CASE 
							WHEN @SortExpression = 'PreviousPayerEOBRequired'
								THEN PreviousPayerEOBRequired
							END
						,CASE 
							WHEN @SortExpression = 'PreviousPayerEOBRequired desc'
								THEN PreviousPayerEOBRequired
							END DESC
							
						
					) AS RowNumber
			FROM #ResultSet
			)
		SELECT TOP (
				CASE 
					WHEN (@PageNumber = - 1)
						THEN (
								SELECT Isnull(Totalrows, 0)
								FROM Counts
								)
					ELSE (@PageSize)
					END
				)
			 ContractName	 --SuryaBalan 28-Aug-2017
			,ContractRuleId
			,ContractId
			,BillingCodeId
			,UnlimitedDailyUnits
			,DailyUnits
			,UnlimitedWeeklyUnits
			,WeeklyUnits
			,UnlimitedMonthlyUnits
			,MonthlyUnits
			,UnlimitedYearlyUnits
			,YearlyUnits
			,AmountCap
			,TotalAmountUsed
			,ExceedLimitAction
			,AuthorizationRequired
			,PreviousPayerEOBRequired
			,CodeandModifiers
			,BillingCodeName
			,AmountCap1
			--,EffectiveAs
			,TotalCount
			,RowNumber
		INTO #FinalResultSet
		FROM RankResultSet
		WHERE RowNumber > ((@PageNumber - 1) * @PageSize)

		IF (
				SELECT Isnull(Count(*), 0)
				FROM #FinalResultSet
				) < 1
		BEGIN
			SELECT 0 AS PageNumber
				,0 AS NumberOfPages
				,0 NumberOfRows
		END
		ELSE
		BEGIN
			SELECT TOP 1 @PageNumber AS PageNumber
				,CASE (TotalCount % @PageSize)
					WHEN 0
						THEN Isnull((TotalCount / @PageSize), 0)
					ELSE Isnull((TotalCount / @PageSize), 0) + 1
					END NumberOfPages
				,Isnull(TotalCount, 0) AS NumberOfRows
			FROM #FinalResultSet
		END

		SELECT ContractName --SuryaBalan 28-Aug-2017
		    ,ContractRuleId
		    ,CodeandModifiers --21-Aug-2017 SuryaBalan
		    ,BillingCodeName  --21-Aug-2017 SuryaBalan
			,ContractId
			,BillingCodeId
			,UnlimitedDailyUnits
			,DailyUnits
			,UnlimitedWeeklyUnits
			,WeeklyUnits
			,UnlimitedMonthlyUnits
			,MonthlyUnits
			,UnlimitedYearlyUnits
			,YearlyUnits
			,'$' + convert(VARCHAR, cast(AmountCap AS MONEY), 10) AS AmountCap1 --21-Aug-2017 SuryaBalan
			,AmountCap
			,TotalAmountUsed
			,(CASE WHEN ExceedLimitAction='P' THEN 'Pended' Else 'Denied' END) AS  ExceedLimitAction
			,(CASE WHEN (ISNULL(AuthorizationRequired, 'N') = 'N') THEN 'No' Else 'Yes' END) AS  AuthorizationRequired  --13-Sept-2017 SuryaBalan
            ,(CASE WHEN (ISNULL(PreviousPayerEOBRequired, 'N') = 'N') THEN 'No' Else 'Yes' END) AS  PreviousPayerEOBRequired --13-Sept-2017 SuryaBalan
			
			
			
		--,convert(VARCHAR, EffectiveAs, 101) AS EffectiveAs  
		FROM #FinalResultSet
		ORDER BY Rownumber
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_ListPageCMBillingCodeRulesSpecificContract') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())

		RAISERROR (
				@Error
				,
				-- Message text.                                            
				16
				,-- Severity.                                            
				1 -- State.                                            
				);
	END CATCH
END
GO

