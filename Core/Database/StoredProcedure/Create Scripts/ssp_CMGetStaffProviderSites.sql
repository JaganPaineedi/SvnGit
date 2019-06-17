/****** Object:  StoredProcedure [dbo].[ssp_CMGetStaffProviderSites]    Script Date: 01/29/2015 17:40:09 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMGetStaffProviderSites]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_CMGetStaffProviderSites]
GO

/****** Object:  StoredProcedure [dbo].[ssp_CMGetStaffProviderSites]    Script Date: 01/29/2015 17:40:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_CMGetStaffProviderSites] (
		@StaffID INT
	)
AS
/******************************************************************************                                                
**  File: ssp_CMGetStaffProviderSites                                            
**  Name: ssp_CMGetStaffProviderSites                        
**  Desc: To Get Staff ProviderSites                   
**  Return values: Get Provider Sites by staff                                              
**  Called by:                                                 
**  Parameters:                            
**  Auth:  Ponnin selvan                              
**  Date:  March 18 2016
*******************************************************************************                                                
**  Change History                                          
*******************************************************************************                                          
/*  26/March/2016		Ponnin				 What : Created
											 Why : Network 180 - Customizations task #702 */
--*******************************************************************************/
BEGIN
	BEGIN TRY
	
	CREATE TABLE #ProviderSitesResult (
		ProviderID INT
		,SiteId INT
		,ProviderName VARCHAR(100)
		,SiteName VARCHAR(100)
		,ProviderSites VARCHAR(250)
		)
	
		
DECLARE @AllProviders CHAR(1)

SET @AllProviders = (
		SELECT TOP 1 AllProviders
		FROM Staff
		WHERE Staffid = @StaffID
		)

	IF (@AllProviders = 'Y')
	BEGIN
	INSERT INTO #ProviderSitesResult (
		ProviderID
		,SiteId
		,ProviderName
		,SiteName
		,ProviderSites
		)
	
	(SELECT DISTINCT P.ProviderID
			,S.SiteId
			,P.ProviderName
			,S.SiteName
			,P.ProviderName + ' ' + ISNULL(S.SiteName, '') as ProviderSites
		FROM Providers P
		LEFT JOIN Sites S ON P.providerID = S.ProviderID
		WHERE ISNULL(P.RecordDeleted, 'N') = 'N'
			AND ISNULL(S.RecordDeleted, 'N') = 'N'
			AND P.active = 'Y'
			AND S.Active = 'Y') 
			
		Union
	
		(SELECT DISTINCT P.ProviderID
			,NULL as SiteId
			,P.ProviderName
			,'All Sites' as SiteName
			,P.ProviderName + ' All Sites' as ProviderSites
		FROM Providers P
		WHERE ISNULL(P.RecordDeleted, 'N') = 'N'
			AND P.active = 'Y')
	END
	ELSE
	BEGIN
	
	INSERT INTO #ProviderSitesResult (
	ProviderID
	,SiteId
	,ProviderName
	,SiteName
	,ProviderSites
	)
		(SELECT DISTINCT P.ProviderID
			,S.SiteId
			,P.ProviderName
			,S.SiteName
			,P.ProviderName + ' ' + ISNULL(S.SiteName, '') as ProviderSites
		FROM Providers P
		INNER JOIN StaffProviders SP ON SP.ProviderId = P.ProviderId
		LEFT JOIN Sites S ON P.providerID = S.ProviderID
		WHERE ISNULL(P.RecordDeleted, 'N') = 'N'
			AND ISNULL(S.RecordDeleted, 'N') = 'N'
			AND ISNULL(SP.RecordDeleted, 'N') = 'N'
			AND P.active = 'Y'
			AND S.Active = 'Y'
			AND SP.StaffId = @StaffID) 
			
			Union
			
			(SELECT DISTINCT P.ProviderID
			,NULL as SiteId
			,P.ProviderName
			,'All Sites' as SiteName
			,P.ProviderName + ' All Sites' as ProviderSites
		FROM Providers P
		INNER JOIN StaffProviders SP ON SP.ProviderId = P.ProviderId
		WHERE ISNULL(P.RecordDeleted, 'N') = 'N'
			AND ISNULL(SP.RecordDeleted, 'N') = 'N'
			AND P.active = 'Y'
			AND SP.StaffId = @StaffID)
	END
		
		SELECT ProviderID
			,SiteId
			,ProviderName
			,SiteName
			,ProviderSites
		FROM #ProviderSitesResult
		ORDER BY ProviderName
			,SiteId
		
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_CMGetStaffProviderSites') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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

