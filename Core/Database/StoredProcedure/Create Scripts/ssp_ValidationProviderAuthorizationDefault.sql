/****** Object:  StoredProcedure [dbo].[ssp_ValidationProviderAuthorizationDefault]    Script Date: 08/09/2015 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ValidationProviderAuthorizationDefault]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ValidationProviderAuthorizationDefault]
GO

/****** Object:  StoredProcedure [dbo].[ssp_ValidationProviderAuthorizationDefault]    Script Date: 08/09/2015 
-- Created:           
-- Date			Author				Purpose 
  
  9-Sept-2015   Ravichander			Created this ssp for validation before saving Authorization Defaults
									Network 180 - Customizations #602 
15-Sept-2015   SUryaBalan			Fixed Validation issue while setting defaults for Authorization Codes
									Network 180 - Customizations #602 								
									*********************************************************************************/  
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  

CREATE PROCEDURE [dbo].[ssp_ValidationProviderAuthorizationDefault] @ProviderAuthorizationDefaultProviderSiteId VARCHAR(max)
	,@ProviderAuthorizationDefaultBillingCodeId VARCHAR(max)
	,@ProviderAuthorizationDefaultAuthorizationCodeId VARCHAR(max)
	,@AllProvides CHAR(1)
	,@AllBillingCodes CHAR(1)
	,@AllAuthorizationCodes CHAR(1)
AS
BEGIN
	BEGIN TRY
		CREATE TABLE #validationReturnTable (
			TableName VARCHAR(100)
			,ColumnName VARCHAR(100)
			,ErrorMessage VARCHAR(max)
			,TabOrder INT
			,ValidationOrder INT
			)

		IF @AllProvides = 'Y'
			OR @AllBillingCodes = 'Y'
		BEGIN
			SELECT ProviderId
			INTO #AllProviders
			FROM Providers
			WHERE ISNULL(RecordDeleted, 'N') = 'N'

			SELECT BillingCodeId
			INTO #AllBillingCodes
			FROM BillingCodes
			WHERE ISNULL(RecordDeleted, 'N') = 'N'

			SELECT d.ProviderAuthorizationDefaultId
				,p.ProviderId
				,b.BillingCodeId
			INTO #resultset
			FROM ProviderAuthorizationDefaults d
			INNER JOIN ProviderAuthorizationDefaultProviderSites p ON p.ProviderAuthorizationDefaultId = d.ProviderAuthorizationDefaultId
			INNER JOIN ProviderAuthorizationDefaultBillingCodes b ON b.ProviderAuthorizationDefaultId = d.ProviderAuthorizationDefaultId
			WHERE ISNULL(d.RecordDeleted, 'N') = 'N'
				AND ISNULL(p.RecordDeleted, 'N') = 'N'
				AND ISNULL(b.RecordDeleted, 'N') = 'N'

			INSERT INTO #validationReturnTable (
				TableName
				,ColumnName
				,ErrorMessage
				)
			SELECT '' AS TableName
				,'DefaultId, ProviderId , BillingCodeId' AS ColumnName
				,convert(VARCHAR(100), ProviderAuthorizationDefaultId) AS ErrorMessage
			FROM #ResultSet
			INNER JOIN Providers pr ON pr.ProviderId = #ResultSet.ProviderId
				AND ISNULL(pr.RecordDeleted, 'N') = 'N'
			INNER JOIN BillingCodes BC ON BC.BillingCodeId = #ResultSet.BillingCodeId
				AND ISNULL(BC.RecordDeleted, 'N') = 'N'
			WHERE EXISTS (
					SELECT d.ProviderAuthorizationDefaultId
					FROM ProviderAuthorizationDefaults d
					INNER JOIN ProviderAuthorizationDefaultProviderSites p ON p.ProviderAuthorizationDefaultId = d.ProviderAuthorizationDefaultId
					INNER JOIN ProviderAuthorizationDefaultBillingCodes b ON b.ProviderAuthorizationDefaultId = d.ProviderAuthorizationDefaultId
					WHERE ISNULL(d.RecordDeleted, 'N') = 'N'
						AND ISNULL(p.RecordDeleted, 'N') = 'N'
						AND ISNULL(b.RecordDeleted, 'N') = 'N'
					)
				AND EXISTS (
					SELECT ps.ProviderId
					FROM #AllProviders ps
					WHERE ps.ProviderId = #ResultSet.ProviderId
					)
				AND EXISTS (
					SELECT Bc.BillingCodeId
					FROM #AllBillingCodes Bc
					WHERE Bc.BillingCodeId = #ResultSet.BillingCodeId
					)
		END
		ELSE
		BEGIN
			IF OBJECT_ID('tempdb..#ProviderSite') IS NOT NULL
				DROP TABLE #ProviderSite

			CREATE TABLE #ProviderSite (item INT)

			INSERT INTO #ProviderSite
			SELECT *
			FROM dbo.fnSplit(@ProviderAuthorizationDefaultProviderSiteId, ',')

			IF OBJECT_ID('tempdb..#BillingCode') IS NOT NULL
				DROP TABLE #BillingCode

			CREATE TABLE #BillingCode (item INT)

			INSERT INTO #BillingCode
			SELECT *
			FROM dbo.fnSplit(@ProviderAuthorizationDefaultBillingCodeId, ',')

			IF OBJECT_ID('tempdb..#AuthorizationCode') IS NOT NULL
				DROP TABLE #AuthorizationCode

			CREATE TABLE #AuthorizationCode (item INT)

			INSERT INTO #AuthorizationCode
			SELECT *
			FROM dbo.fnSplit(@ProviderAuthorizationDefaultAuthorizationCodeId, ',')

			SELECT d.ProviderAuthorizationDefaultId
				,p.ProviderId
				,b.BillingCodeId
			INTO #ResultSet1
			FROM ProviderAuthorizationDefaults d
			INNER JOIN ProviderAuthorizationDefaultProviderSites p ON p.ProviderAuthorizationDefaultId = d.ProviderAuthorizationDefaultId
			INNER JOIN ProviderAuthorizationDefaultBillingCodes b ON b.ProviderAuthorizationDefaultId = d.ProviderAuthorizationDefaultId
			WHERE ISNULL(d.RecordDeleted, 'N') = 'N'
				AND ISNULL(p.RecordDeleted, 'N') = 'N'
				AND ISNULL(b.RecordDeleted, 'N') = 'N'

			INSERT INTO #validationReturnTable (
				TableName
				,ColumnName
				,ErrorMessage
				)
			SELECT '' AS TableName
				,'DefaultId, ProviderId , BillingCodeId' AS ColumnName
				,convert(VARCHAR(100), ProviderAuthorizationDefaultId) AS ErrorMessage
			FROM #ResultSet1
			INNER JOIN Providers pr ON pr.ProviderId = #ResultSet1.ProviderId
				AND ISNULL(pr.RecordDeleted, 'N') = 'N'
			INNER JOIN BillingCodes BC ON BC.BillingCodeId = #ResultSet1.BillingCodeId
				AND ISNULL(BC.RecordDeleted, 'N') = 'N'
			WHERE EXISTS (
					SELECT d.ProviderAuthorizationDefaultId
					FROM ProviderAuthorizationDefaults d
					INNER JOIN ProviderAuthorizationDefaultProviderSites p ON p.ProviderAuthorizationDefaultId = d.ProviderAuthorizationDefaultId
					INNER JOIN ProviderAuthorizationDefaultBillingCodes b ON b.ProviderAuthorizationDefaultId = d.ProviderAuthorizationDefaultId
					WHERE ISNULL(d.RecordDeleted, 'N') = 'N'
						AND ISNULL(p.RecordDeleted, 'N') = 'N'
						AND ISNULL(b.RecordDeleted, 'N') = 'N'
					)
				AND EXISTS (
					SELECT p.item
					FROM #ProviderSite p
					WHERE p.item = #ResultSet1.ProviderId
					)
				AND EXISTS (
					SELECT b.item
					FROM #BillingCode B
					WHERE B.item = #ResultSet1.BillingCodeId
					)
			
			UNION
			
			SELECT 'ProviderAuthorizationDefaultAuthorizationCodes' AS TableName
				,'AuthorizationCodeId' AS ColumnName
				,convert(VARCHAR(100), P.ProviderAuthorizationDefaultId) AS ErrorMessage
			FROM ProviderAuthorizationDefaultAuthorizationCodes A
			INNER JOIN ProviderAuthorizationDefaults P ON P.ProviderAuthorizationDefaultId = A.ProviderAuthorizationDefaultId
				AND ISNULL(A.RecordDeleted, 'N') = 'N'
			INNER JOIN #AuthorizationCode ON #AuthorizationCode.item = A.AuthorizationCodeId
			WHERE EXISTS (
					SELECT item
					FROM #AuthorizationCode aa
					WHERE A.AuthorizationCodeId = aa.item
					)
		END

		IF NOT EXISTS (
				SELECT TableName
					,ColumnName
					,ErrorMessage
					,TabOrder
					,ValidationOrder
				FROM #validationReturnTable
				)
		BEGIN
			SELECT '' AS TableName
				,'' AS ColumnName
				,'0' AS ErrorMessage
				,'' AS TabOrder
				,'' AS ValidationOrder
		END
		ELSE
		BEGIN
			SELECT ISNULL(STUFF((
							SELECT ', ' + ErrorMessage AS ErrorMessage
							FROM #validationReturnTable
							FOR XML PATH('')
								,TYPE
							).value('.', 'nvarchar(max)'), 1, 2, ''), '')
				--SELECT TableName        
				--   ,ColumnName        
				--   ,ErrorMessage        
				--   ,TabOrder        
				--   ,ValidationOrder        
				--  FROM #validationReturnTable        
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_ValidationProviderAuthorizationDefault') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())
	END CATCH
END
