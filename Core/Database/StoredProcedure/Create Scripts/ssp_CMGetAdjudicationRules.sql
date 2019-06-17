/****** Object:  StoredProcedure [dbo].[ssp_CMGetAdjudicationRules]    Script Date: 05/03/2013 11:54:00 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMGetAdjudicationRules]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_CMGetAdjudicationRules]
GO

/****** Object:  StoredProcedure [dbo].[ssp_CMGetAdjudicationRules]    Script Date: 05/03/2013 11:54:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_CMGetAdjudicationRules]
	/*************************************************************/
	/* Stored Procedure: dbo.ssp_CMGetAdjudicationRules	             */
	/* Creation Date:  Aug 18 2014                                */
	/* Purpose: To Get the Adjudication Rule		 */
	/*  Date                  Author                 Purpose     */
	/* Aug 18 2014           Chethan N            Created     */
	/* Aug 28 2018           Arjun K R            Added new column "RuleBasedOnEffectiveDate" into select statement.Task #19 Partner Solutions */
	/*************************************************************/
	@AdjudicationRuleId INT
AS
BEGIN
	BEGIN TRY
		-- For table AdjudicationRules
		SELECT AR.[AdjudicationRuleId]
			,AR.[CreatedBy]
			,AR.[CreatedDate]
			,AR.[ModifiedBy]
			,AR.[ModifiedDate]
			,AR.[RecordDeleted]
			,AR.[DeletedBy]
			,AR.[DeletedDate]
			,AR.[RuleTypeId]
			,AR.[RuleName]
			,AR.[SystemRequiredRule]
			,AR.[Active]
			,AR.[StartDate]
			,AR.[EndDate]
			,AR.[ClaimLineStatusIfBroken]
			,AR.[MarkClaimLineToBeWorked]
			,AR.[ToBeWorkedDays]
			,AR.[AllInsurers]
			,AR.[RuleBasedOnEffectiveDate] --Aug 28 2018           Arjun K R    
		FROM [AdjudicationRules] AS AR
		WHERE AR.AdjudicationRuleId = @AdjudicationRuleId

		-- For table AdjudicationRuleInsurers
		SELECT ARI.[AdjudicationRuleInsurerId]
			,ARI.[CreatedBy]
			,ARI.[CreatedDate]
			,ARI.[ModifiedBy]
			,ARI.[ModifiedDate]
			,ARI.[RecordDeleted]
			,ARI.[DeletedBy]
			,ARI.[DeletedDate]
			,ARI.[AdjudicationRuleId]
			,ARI.[InsurerId]
		FROM [AdjudicationRuleInsurers] AS ARI
		INNER JOIN [AdjudicationRules] AS AR ON AR.[AdjudicationRuleId] = ARI.AdjudicationRuleId
		WHERE ARI.AdjudicationRuleId = @AdjudicationRuleId
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_CMGetAdjudicationRules') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.          
				16
				,-- Severity.          
				1 -- State.          
				);
	END CATCH
END
GO

