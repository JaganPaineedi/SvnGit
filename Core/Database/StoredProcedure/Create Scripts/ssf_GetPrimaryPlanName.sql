/****** Object:  UserDefinedFunction [dbo].[ssf_GetPrimaryPlanName]    Script Date: 05/24/2016 12:32:23 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssf_GetPrimaryPlanName]')
			AND type IN (
				N'FN'
				,N'IF'
				,N'TF'
				,N'FS'
				,N'FT'
				)
		)
	DROP FUNCTION [dbo].[ssf_GetPrimaryPlanName]
GO

/****** Object:  UserDefinedFunction [dbo].[ssf_GetPrimaryPlanName]    Script Date: 05/24/2016 12:32:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[ssf_GetPrimaryPlanName] (@ClientId INT)
RETURNS VARCHAR(250)
AS
BEGIN
	DECLARE @PrimaryPlan VARCHAR(250)

	SELECT TOP 1 @PrimaryPlan = CP.CoveragePlanName
	FROM ClientCoveragePlans CCp
	INNER JOIN ClientCoverageHistory CCH ON CCH.ClientCoveragePlanId = CCP.ClientCoveragePlanId
		AND ISNULL(CCP.RecordDeleted, 'N') = 'N'
		AND CCH.StartDate <= getdate()
		AND (
			CCH.EndDate IS NULL
			OR CCH.EndDate > dateadd(dd, 1, getdate())
			)
		AND CCH.COBOrder = 1
	LEFT JOIN CoveragePlans CP ON CP.CoveragePlanId = CCP.CoveragePlanId
		AND CP.Active = 'Y'
		AND ISNULL(CP.RecordDeleted, 'N') = 'N'
	WHERE CCP.ClientId = @ClientId
	ORDER BY CP.COBPriority

	RETURN ISNULL(@PrimaryPlan, '')
END
GO


