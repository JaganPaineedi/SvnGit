

/****** Object:  StoredProcedure [dbo].[ssp_SCGetPlanAndProviderSiteInformationForChecks]    Script Date: 01/08/2016 17:33:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetPlanAndProviderSiteInformationForChecks]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetPlanAndProviderSiteInformationForChecks]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetPlanAndProviderSiteInformationForChecks]    Script Date: 01/08/2016 17:33:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetPlanAndProviderSiteInformationForChecks] (@CheckId INT)
AS
/*******************************************************************************  
Author: MD Khusro
Date: 01/07/2016
Task: #385 SWMBH - Support
    
**  Change History      
*******************************************************************************      
**  Date:  Author:    Description:      
**  --------  --------    ----------------------------------------------------      
 
*******************************************************************************/   
BEGIN
	BEGIN TRY
		SELECT cl.ClaimLineId
			,clcp.CoveragePlanId
			,CoveragePlanName
			,s.SiteName AS ProviderSiteInfo
		FROM Checks AS c
		INNER JOIN ClaimLinePayments AS cp ON c.CheckId = cp.CheckId
			AND IsNull(cp.RecordDeleted, 'N') = 'N'
		INNER JOIN ClaimLines AS cl ON cp.ClaimLineId = cl.ClaimlineId
			AND IsNull(cl.RecordDeleted, 'N') = 'N'
		INNER JOIN BillingCodes AS bc ON bc.BillingCodeId = cl.BillingCodeId
			AND IsNull(bc.RecordDeleted, 'N') = 'N'
			AND bc.Active = 'Y'
		INNER JOIN Claims AS cm ON cm.ClaimId = cl.ClaimId
			AND IsNull(cm.RecordDeleted, 'N') = 'N'
		INNER JOIN Clients ON Clients.Clientid = cm.Clientid
			AND IsNull(clients.RecordDeleted, 'N') = 'N'
		INNER JOIN ClaimLineCoveragePlans clcp ON cl.claimlineid = clcp.claimlineid
		INNER JOIN CoveragePlans cpl ON cpl.CoveragePlanId = clcp.CoveragePlanId
			AND IsNull(cpl.RecordDeleted, 'N') = 'N'
		INNER JOIN sites s ON s.SiteId = cm.SiteId
			AND IsNull(s.RecordDeleted, 'N') = 'N'     
		WHERE IsNull(c.RecordDeleted, 'N') = 'N'
			AND c.CheckId = @CheckId
		
		UNION ALL
		
		SELECT cl.ClaimLineId
			,clcp.CoveragePlanId
			,CoveragePlanName
			,s.SiteName AS ProviderSiteInfo
		FROM Checks AS c
		INNER JOIN ClaimLineCredits AS cp ON c.CheckId = cp.CheckId
			AND IsNull(cp.RecordDeleted, 'N') = 'N'
		INNER JOIN ClaimLines AS cl ON cp.ClaimLineId = cl.ClaimlineId
			AND IsNull(cl.RecordDeleted, 'N') = 'N'
		INNER JOIN BillingCodes AS bc ON bc.BillingCodeId = cl.BillingCodeId
			AND IsNull(bc.RecordDeleted, 'N') = 'N'
			AND bc.Active = 'Y'
		INNER JOIN Claims AS cm ON cm.ClaimId = cl.ClaimId
			AND IsNull(cm.RecordDeleted, 'N') = 'N'
		INNER JOIN Clients ON Clients.Clientid = cm.Clientid
			AND IsNull(clients.RecordDeleted, 'N') = 'N'
		INNER JOIN ClaimLineCoveragePlans clcp ON cl.claimlineid = clcp.claimlineid
		INNER JOIN CoveragePlans cpl ON cpl.CoveragePlanId = clcp.CoveragePlanId
			AND IsNull(cpl.RecordDeleted, 'N') = 'N'
		INNER JOIN sites s ON s.SiteId = cm.SiteId
			AND IsNull(s.RecordDeleted, 'N') = 'N'        
		WHERE IsNull(c.RecordDeleted, 'N') = 'N'
			AND c.CheckId = @CheckId
	END TRY

	BEGIN CATCH
		IF (@@ERROR != 0)
		BEGIN
			RAISERROR (
					'ssp_SCGetPlanAndProviderSiteInformationForChecks: An Error Occured while fetching data'
					,16
					,1
					)

			RETURN
		END
	END CATCH
END

GO


