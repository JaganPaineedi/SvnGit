/****** Object:  StoredProcedure [dbo].[ssp_PMCoveragePlanEligibleClientByCoveragePlanID]    Script Date: 11/18/2011 16:25:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMCoveragePlanEligibleClientByCoveragePlanID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMCoveragePlanEligibleClientByCoveragePlanID]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMCoveragePlanEligibleClientByCoveragePlanID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ssp_PMCoveragePlanEligibleClientByCoveragePlanID]
	/* Param List */
	@CoveragePlanID INT
	,@StaffId INT
AS
/******************************************************************************      
**  File: dbo..ssp_PMCoveragePlanEligibleClientByCoveragePlanID .prc      
**  Name: dbo.ssp_PMCoveragePlanEligibleClientByCoveragePlanID       
**  Desc:       
**      
**  This template can be customized:      
**                    
**  Return values:      
**       
**  Called by:         
**                    
**  Parameters:      
**  Input       Output      
**     ----------       -----------      
**      
**  Auth: Balvinder  
**  Date:       
*******************************************************************************      
**  Change History      
*******************************************************************************      
**  Date:  Author:    Description:      
**  --------  --------    -------------------------------------------      
**   Added Nov.27 for Eligible Clients Tab of Plan Details  
/*Eligible Clients*/      
/* 19 Oct 2015    Revathi		what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.    
								why:task #609, Network180 Customization */  
  
*******************************************************************************/
SELECT C.ClientID
	,
	--Added by Revathi  19 Oct 2015     
	CASE 
		WHEN ISNULL(C.ClientType, ''I'') = ''I''
			THEN ISNULL(C.LastName, '''') + '', '' + ISNULL(C.FirstName, '''')
		ELSE ISNULL(C.OrganizationName, '''')
		END AS ClientName
	,1 AS PlanID
	,CCP.ClientCoveragePlanId
	,CCP.InsuredId
	,CCH.COBOrder
	,C.DOB
	,CASE 
		WHEN C.DOB IS NOT NULL
			THEN DATEDIFF(YEAR, C.DOB, GETDATE())
		ELSE NULL
		END AS Age
	,C.Sex
	,GC.CodeName AS Race
	,CAST(CONVERT(VARCHAR, CCH.StartDate, 101) AS DATETIME) AS StartDate
	,CAST(CONVERT(VARCHAR, CCH.EndDate, 101) AS DATETIME) AS EndDate
FROM ClientCoverageHistory CCH
LEFT JOIN ClientCoveragePlans CCP ON CCH.ClientCoveragePlanId = CCP.ClientCoveragePlanId
LEFT JOIN Clients C ON CCP.ClientId = C.ClientId
/*Join with ClientRaces and GlobalCodes for selecting Race field*/
LEFT JOIN ClientRaces CR ON C.ClientID = CR.ClientID
LEFT JOIN GlobalCodes GC ON CR.RaceId = GC.GlobalcodeID
WHERE CCH.ClientCoveragePlanId IN (
		SELECT ClientCoveragePlanId
		FROM ClientCoveragePlans
		WHERE CoveragePlanId = @CoveragePlanID
		)
	AND C.Active = ''Y''
	AND ISNULL(CCH.RecordDeleted, ''N'') = ''N''
	AND ISNULL(CCP.RecordDeleted, ''N'') = ''N''
	AND ISNULL(C.RecordDeleted, ''N'') = ''N''
	-- Bhupinder Bajwa 01 March 2007 REF Task # 267    
	AND NOT EXISTS (
		SELECT sbc.ClientId
		FROM StaffBlockedClients sbc
		WHERE sbc.StaffId = @StaffId
			AND sbc.ClientId = c.ClientId
			AND IsNull(sbc.RecordDeleted, ''N'') = ''N''
		)
ORDER BY ClientName
' 
END
GO
