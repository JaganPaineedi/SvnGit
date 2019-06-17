/****** Object:  StoredProcedure [dbo].[ssp_PMCoveragePlanBilingCodeInitData]    Script Date: 02/21/2012 15:56:55 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMCoveragePlanBilingCodeInitData]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_PMCoveragePlanBilingCodeInitData]
GO

/****** Object:  StoredProcedure [dbo].[ssp_PMCoveragePlanBilingCodeInitData]    Script Date: 02/21/2012 15:56:55 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

/****************************************************************************** 
** File: ssp_PMCoveragePlanBilingCodeInitData.sql
** Name: ssp_PMCoveragePlanBilingCodeInitData
** Desc:  
** 
** 
** This template can be customized: 
** 
** Return values: Drop down values for Plan Details - BillingCodes Tab
** 
** Called by: 
** 
** Parameters: 
** Input Output 
** ---------- ----------- 
** N/A   Dropdown values
** Auth: Mary Suma
** Date: 12/05/2011
******************************************************************************* 
** Change History 
******************************************************************************* 
** Date: 			Author: 			Description: 
** 12/05/2011		Mary Suma			Procedure to retrieve drop down values in BillingCodes Tab-Plan Details
-------- 			-------- 			--------------- 
** 02.21.2012		avoss				correcly load lists.. fixed joins and data that should be retrieved.
/* 12.26.2013       Manju P             Modified to get DisplayAs as StaffName from staff table. What/Why: Task: Core Bugs #1315 Staff Detail Changes*/
/* 19 /Oct/ 2015	Revathi 			what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  
										why:task #609, Network180 Customization	 */
*******************************************************************************/
CREATE PROCEDURE [dbo].[ssp_PMCoveragePlanBilingCodeInitData]
AS
BEGIN
	--Table 1 All Programs              
	SELECT P.ProgramId
		,P.ProgramCode
	FROM Programs P
	--INNER JOIN              
	--ProcedureRatePrograms PRP              
	--ON P.ProgramId=PRP.ProgramId               
	WHERE ISNULL(P.RecordDeleted, 'N') = 'N'
		AND p.Active = 'Y'
	--ISNULL(PRP.RecordDeleted, 'N') = 'N'              
	ORDER BY ProgramCode

	--Table 2 All Degrees
	SELECT GC.GlobalCodeId
		,GC.CodeName
		,ISNULL(GC.SortOrder, 9999) AS SortOrder
	FROM GlobalCodes GC
	--	INNER JOIN              
	--ProcedureRateDegrees PRD              
	--ON GC.GlobalCodeId=PRD.Degree                
	WHERE GC.Category = 'DEGREE'
		AND (
			GC.RecordDeleted = 'N'
			OR GC.RecordDeleted IS NULL
			)
	--AND 
	--ISNULL(PRD.RecordDeleted, 'N') = 'N'              
	ORDER BY SortOrder
		,CodeName

	--Table 3 All Staff              
	SELECT S.StaffId
		,CASE 
			WHEN GC.CodeName IS NULL
				THEN S.DisplayAs
			ELSE S.DisplayAs + ' ' + GC.CodeName
			END AS StaffName
	FROM Staff S
	LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = S.Degree
	--INNER JOIN ProcedureRateStaff PRS
	--ON PRS.StaffId = S.StaffId            
	WHERE S.Active = 'Y'
		AND ISNULL(S.RecordDeleted, 'N') = 'N'
		AND s.UserCode IS NOT NULL
	ORDER BY StaffName

	--Table 4 Clients              
	SELECT DISTINCT C.ClientId
		,
		--Added by Revathi 19 /Oct/ 2015
		CASE 
			WHEN ISNULL(C.ClientType, 'I') = 'I'
				THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')
			ELSE ISNULL(C.OrganizationName, '')
			END AS ClientName
	FROM Clients C
	INNER JOIN ProcedureRates PR ON C.ClientId = PR.ClientId
	WHERE ISNULL(C.RecordDeleted, 'N') = 'N'
		AND C.Active = 'Y'
		AND ISNULL(PR.RecordDeleted, 'N') = 'N'
	ORDER BY ClientName

	-- TAble 5 USe BillingCode from Specified Plan
	SELECT CoveragePlanId
		,DisplayAs
	FROM CoveragePlans
	WHERE Active = 'Y'
		AND ISNULL(RecordDeleted, 'N') = 'N'
		AND BillingCodeTemplate = 'T'
	ORDER BY DisplayAs ASC

	RETURN
END
GO

