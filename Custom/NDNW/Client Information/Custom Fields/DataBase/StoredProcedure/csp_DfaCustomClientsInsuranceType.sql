/****** Object:  StoredProcedure [dbo].[csp_DfaCustomClientsInsuranceType]    Script Date: 04/18/2016 11:43:11 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_DfaCustomClientsInsuranceType]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_DfaCustomClientsInsuranceType]
GO

/****** Object:  StoredProcedure [dbo].[csp_DfaCustomClientsInsuranceType]    Script Date: 04/18/2016 11:43:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_DfaCustomClientsInsuranceType] --(@ClientId INT)
AS
--SELECT tp.GlobalCodeId
--	,CASE 
--		WHEN tp.CodeName = 'Commercial'
--			THEN 'Private'
--		WHEN tp.CodeName = 'Medicaid'
--			THEN 'Medicaid'
--		WHEN tp.CodeName = 'Medicare'
--			THEN 'Medicare'
--		WHEN tp.CodeName = 'Self Pay'
--			THEN 'Self Pay'
--		ELSE 'None'
--		END AS InsuranceType
--FROM ClientCoveragePlans ccp
--JOIN CoveragePlans cp ON ccp.CoveragePlanId = cp.CoveragePlanId AND ISNULL(cp.RecordDeleted, 'N') <> 'Y'
--JOIN Payers p ON cp.PayerId = p.PayerId AND ISNULL(p.RecordDeleted , 'N') <> 'Y'
--JOIN GlobalCodes tp ON p.PayerType = tp.GlobalCodeId AND ISNULL(tp.RecordDeleted, 'N') <> 'Y'
--JOIN ClientCoverageHistory cch ON ccp.ClientCoveragePlanId = cch.ClientCoveragePlanId AND ISNULL(cch.RecordDeleted, 'N') <> 'Y'
--WHERE ccp.ClientId = @ClientId
--	--AND ISNULL(ccp.RecordDeleted, 'N') <> 'Y'
--	--AND ISNULL(p.RecordDeleted, 'N') <> 'Y'
--	AND (cch.EndDate IS NULL OR cch.EndDate >= GETDATE())

SELECT tp.GlobalCodeId
	,CASE 
		WHEN tp.CodeName = 'Commercial'
			THEN 'Private'
		WHEN tp.CodeName = 'Medicaid'
			THEN 'Medicaid'
		WHEN tp.CodeName = 'Medicare'
			THEN 'Medicare'
		WHEN tp.CodeName = 'Self Pay'
			THEN 'Self Pay'
		ELSE 'None'
		END AS InsuranceType
FROM GlobalCodes tp
WHERE ISNULL(tp.RecordDeleted, 'N') <> 'Y'
AND tp.GlobalCodeId IN (10021, 10086, 10087, 10135)
UNION
SELECT NULL, 'None' AS InsuranceType

GO


