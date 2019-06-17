 IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCListPageAuthorizationDefaults]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCListPageAuthorizationDefaults]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
 CREATE PROCEDURE [dbo].[ssp_SCListPageAuthorizationDefaults] (
	 @PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@StartDate DATETIME
	,@EndDate DATETIME
	,@Active CHAR(1)
	,@InternalExternal CHAR(1)
	,@OtherFilter INT
	,@BillingCodeId INT
	,@AuthorizationCodeId INT
	,@ProviderId INT
	,@SiteId INT
	)
AS
/************************************************************************************************                                        
*************************************************************************************************                
**  Change History                 
**  Date:    Author:   Description:                 
**  --------   --------  -------------------------------------------------------------  
**  17-Aug-2015   SuryaBalan				What:Used in Authorizations Default List Page
									Why:task Network 180 - Customizations #602 - Authorization process - ability to set defaults based on auth code               
**  17-Aug-2015   SuryaBalan		Network 180 - Customizations #602 - Changed the display name Billing Codename              
*************************************************************************************************/
BEGIN
	BEGIN TRY
		SET NOCOUNT ON;

		--                  
		--Declare table to get data if Other filter exists -------                  
		--                  
		CREATE TABLE #ProviderAuthorizationDefaults (ProviderAuthorizationDefaultId INT)

		CREATE TABLE #ResultSet (
			ProviderAuthorizationDefaultId INT
			,StartDate VARCHAR(20)
			,EndDate VARCHAR(20)
			,Active CHAR(1)
			,InternalExternal CHAR(1)
			,Units DECIMAL(18, 2)
			,Frequency VARCHAR(100)
			,Duration INT
			,DurationEntry VARCHAR(10)
			,TotalUnits DECIMAL(18, 2)
			,CreatedDate VARCHAR(20)
			,CreatedBy VARCHAR(200)
			,ProviderName VARCHAR(max)
			,SiteName VARCHAR(max)
			,AuthorizationCodeName VARCHAR(max)
			,CodeName VARCHAR(max)
			)

		INSERT INTO #ResultSet (
			ProviderAuthorizationDefaultId
			,StartDate
			,EndDate
			,Active
			,InternalExternal
			,Units
			,Frequency
			,Duration
			,DurationEntry
			,TotalUnits
			,CreatedDate
			,CreatedBy
			,ProviderName
			,SiteName
			    
			,CodeName
			)
		SELECT A.ProviderAuthorizationDefaultId
			,CONVERT(VARCHAR, A.StartDate, 101) AS StartDate
			,CONVERT(VARCHAR, A.EndDate, 101) AS EndDate
			,A.Active AS Active
			,A.InternalExternal
			,A.Units
			,gc1.CodeName as Frequency
			,A.Duration
			,gc2.CodeName as DurationEntry
			,A.TotalUnits
			,CONVERT(VARCHAR, A.CreatedDate, 101) AS CreatedDate
			,A.CreatedBy
			,STUFF((
					SELECT ', ' + STUFF(COALESCE('- ' + RTRIM(P.ProviderName), '') + COALESCE(' - ' + RTRIM(S.SiteName), ''), 1, 2, '')
					FROM Providers P
					INNER JOIN ProviderAuthorizationDefaultProviderSites ADPS ON P.ProviderId = ADPS.ProviderId
						AND ADPS.ProviderAuthorizationDefaultId = A.ProviderAuthorizationDefaultId
					LEFT JOIN Sites S ON S.SiteId = ADPS.SiteId
						AND ISNULL(S.RecordDeleted, 'N') = 'N'
					WHERE (
							ADPS.ProviderId = @ProviderId
							OR @ProviderId = 0
							)
						AND ISNULL(P.RecordDeleted, 'N') = 'N'
						AND ISNULL(ADPS.RecordDeleted, 'N') = 'N'
					FOR XML PATH('')
						,TYPE
					).value('.[1]', 'nvarchar(max)'), 1, 2, '') AS ProviderName
			,STUFF((
					SELECT ', ' + S.SiteName
					FROM Sites S
					INNER JOIN ProviderAuthorizationDefaultProviderSites ADPS ON S.SiteId = ADPS.SiteId
						AND ADPS.ProviderAuthorizationDefaultId = A.ProviderAuthorizationDefaultId
					WHERE (
							ADPS.SiteId = @SiteId
							OR @SiteId = 0
							)
						AND ISNULL(S.RecordDeleted, 'N') = 'N'
						AND ISNULL(ADPS.RecordDeleted, 'N') = 'N'
					FOR XML PATH('')
						,TYPE
					).value('.[1]', 'nvarchar(max)'), 1, 2, '') AS SiteName
			    
			,CASE 
				WHEN A.InternalExternal = 'I'
					THEN STUFF((
								SELECT ', ' + AC.AuthorizationCodeName
								FROM AuthorizationCodes AC
								INNER JOIN ProviderAuthorizationDefaultAuthorizationCodes ADAS ON AC.AuthorizationCodeId = ADAS.AuthorizationCodeId
									AND ADAS.ProviderAuthorizationDefaultId = A.ProviderAuthorizationDefaultId
								WHERE (
										ADAS.AuthorizationCodeId = @AuthorizationCodeId
										OR @AuthorizationCodeId = 0
										)
									AND ISNULL(ADAS.RecordDeleted, 'N') = 'N'
									AND ISNULL(AC.RecordDeleted, 'N') = 'N'
								FOR XML PATH('')
									,TYPE
								).value('.[1]', 'nvarchar(max)'), 1, 2, '')
				ELSE STUFF((
							SELECT ', ' + BC.BillingCode
							FROM BillingCodes BC
							INNER JOIN ProviderAuthorizationDefaultBillingCodes ADBC ON BC.BillingCodeId = ADBC.BillingCodeId
								AND ADBC.ProviderAuthorizationDefaultId = A.ProviderAuthorizationDefaultId
							WHERE (
									ADBC.BillingCodeId = @BillingCodeId
									OR @BillingCodeId = 0
									)
								AND ISNULL(ADBC.RecordDeleted, 'N') = 'N'
								AND ISNULL(BC.RecordDeleted, 'N') = 'N'
							FOR XML PATH('')
								,TYPE
							).value('.[1]', 'nvarchar(max)'), 1, 2, '')
				END AS CodeName
		FROM ProviderAuthorizationDefaults A
		 Left OUTER JOIN  GlobalCodes gc1 ON  gc1.GlobalCodeId=A.Frequency and gc1.Category like 'TPFREQUENCYTYPE'  
		 Left OUTER JOIN  GlobalCodes gc2 ON  gc2.GlobalCodeId=A.DurationEntry and gc2.Category like 'AUTHUNITTYPE'      
		
		WHERE (
				(
					A.StartDate = @StartDate
					OR (@StartDate IS NULL)
					)
				AND (
					A.EndDate = @EndDate
					OR (@EndDate IS NULL)
					)
				AND (
					A.InternalExternal = @InternalExternal
					OR (@InternalExternal = '')
					)
				AND (
					A.RecordDeleted = 'N'
					OR A.RecordDeleted IS NULL
					)
				AND (
					A.Active = @Active
					OR A.Active IS NULL
					)
				AND (
					@ProviderId = 0
					OR EXISTS (
						SELECT 1
						FROM ProviderAuthorizationDefaultProviderSites ADPS
						WHERE ADPS.ProviderAuthorizationDefaultId = A.ProviderAuthorizationDefaultId
							AND ISNULL(ADPS.RecordDeleted, 'N') = 'N'
							AND ADPS.ProviderId = @ProviderId
						)
					)
				AND (
					@SiteId = 0
					OR EXISTS (
						SELECT 1
						FROM ProviderAuthorizationDefaultProviderSites ADPS
						WHERE ADPS.ProviderAuthorizationDefaultId = A.ProviderAuthorizationDefaultId
							AND ISNULL(ADPS.RecordDeleted, 'N') = 'N'
							AND ADPS.SiteId = @SiteId
						)
					)
				AND (
					@BillingCodeId = 0
					OR EXISTS (
						SELECT 1
						FROM ProviderAuthorizationDefaultBillingCodes ADBC
						WHERE ADBC.ProviderAuthorizationDefaultId = A.ProviderAuthorizationDefaultId
							AND ISNULL(ADBC.RecordDeleted, 'N') = 'N'
							AND ADBC.BillingCodeId = @BillingCodeId
						)
					)
				AND (
					@AuthorizationCodeId = 0
					OR EXISTS (
						SELECT 1
						FROM ProviderAuthorizationDefaultAuthorizationCodes ADAS
						WHERE ADAS.ProviderAuthorizationDefaultId = A.ProviderAuthorizationDefaultId
							AND ISNULL(ADAS.RecordDeleted, 'N') = 'N'
							AND ADAS.AuthorizationCodeId = @AuthorizationCodeId
						)
					)
				     
				);

		IF @OtherFilter > 10000
		BEGIN
			INSERT INTO #ProviderAuthorizationDefaults (ProviderAuthorizationDefaultId)
			EXEC scsp_ListPageSCAuthorizationDefaults    @StartDate =@StartDate
														,@EndDate =@EndDate
														,@Active =@Active
														,@InternalExternal =@InternalExternal
														,@OtherFilter =@OtherFilter
														,@BillingCodeId =@BillingCodeId
														,@AuthorizationCodeId =@AuthorizationCodeId
														,@ProviderId =@ProviderId
														,@SiteId =@SiteId
		END
				--                                                 
				--Insert data in to temp table which is fetched below by appling filter.                     
				--                    
				;

		WITH counts
		AS (
			SELECT COUNT(*) AS TotalRows
			FROM #ResultSet
			)
			,RankResultSet
		AS (
			SELECT 
			     ProviderAuthorizationDefaultId
				 ,ProviderName
				 ,SiteName
				 ,CodeName
				 ,CONVERT(VARCHAR, StartDate, 101) AS StartDate
				 ,CONVERT(VARCHAR, EndDate, 101) AS EndDate
				 ,Units
				 ,Frequency
				 ,Duration
				 ,DurationEntry
				 ,TotalUnits
				 ,CreatedBy
				 ,CONVERT(VARCHAR, CreatedDate, 101) AS CreatedDate
				,COUNT(*) OVER () AS TotalCount
				,ROW_NUMBER() OVER (
					ORDER BY CASE 
							WHEN @SortExpression = 'StartDate'
								THEN StartDate
							END
						,CASE 
							WHEN @SortExpression = 'StartDate desc'
								THEN StartDate
							END DESC
						,CASE 
							WHEN @SortExpression = 'EndDate'
								THEN EndDate
							END
						,CASE 
							WHEN @SortExpression = 'EndDate desc'
								THEN EndDate
							END DESC
						,CASE 
							WHEN @SortExpression = 'Active'
								THEN Active
							END
						,CASE 
							WHEN @SortExpression = 'Active desc'
								THEN Active
							END DESC
						,CASE 
							WHEN @SortExpression = 'InternalExternal'
								THEN InternalExternal
							END
						,CASE 
							WHEN @SortExpression = 'InternalExternal desc'
								THEN InternalExternal
							END DESC
						,CASE 
							WHEN @SortExpression = 'Units'
								THEN Units
							END
						,CASE 
							WHEN @SortExpression = 'Units desc'
								THEN Units
							END DESC
						,CASE 
							WHEN @SortExpression = 'Frequency'
								THEN Frequency
							END
						,CASE 
							WHEN @SortExpression = 'Frequency desc'
								THEN Frequency
							END DESC
						,CASE 
							WHEN @SortExpression = 'Duration'
								THEN Duration
							END
						,CASE 
							WHEN @SortExpression = 'Duration desc'
								THEN Duration
							END DESC
						,CASE 
							WHEN @SortExpression = 'DurationEntry'
								THEN DurationEntry
							END
						,CASE 
							WHEN @SortExpression = 'DurationEntry desc'
								THEN DurationEntry
							END DESC
						,CASE 
							WHEN @SortExpression = 'TotalUnits'
								THEN TotalUnits
							END
						,CASE 
							WHEN @SortExpression = 'TotalUnits desc'
								THEN TotalUnits
							END DESC
						,CASE 
							WHEN @SortExpression = 'CreatedDate'
								THEN CreatedDate
							END
						,CASE 
							WHEN @SortExpression = 'CreatedDate desc'
								THEN CreatedDate
							END DESC
						,CASE 
							WHEN @SortExpression = 'CreatedBy'
								THEN CreatedBy
							END
						,CASE 
							WHEN @SortExpression = 'CreatedBy desc'
								THEN CreatedBy
							END DESC
						,CASE 
							WHEN @SortExpression = 'ProviderName'
								THEN ProviderName
							END
						,CASE 
							WHEN @SortExpression = 'ProviderName desc'
								THEN ProviderName
							END DESC
						,CASE 
							WHEN @SortExpression = 'SiteName'
								THEN SiteName
							END
						,CASE 
							WHEN @SortExpression = 'SiteName desc'
								THEN SiteName
							END DESC
						,CASE 
							WHEN @SortExpression = 'CodeName'
								THEN CodeName
							END
						,CASE 
							WHEN @SortExpression = 'CodeName desc'
								THEN CodeName
							END DESC
					) AS RowNumber
			FROM #ResultSet
			)
		SELECT TOP (
				CASE 
					WHEN (@PageNumber = - 1)
						THEN (
								SELECT ISNULL(TotalRows, 0)
								FROM counts
								)
					ELSE (@PageSize)
					END
				) 
			 ProviderAuthorizationDefaultId
			--,StartDate
			--,EndDate
			--,Active
			--,InternalExternal
			--,Units
			--,Frequency
			--,Duration
			--,DurationEntry
			--,TotalUnits
			--,CreatedDate
			--,CreatedBy
			--,ProviderName
			--,SiteName
			--,AuthorizationCodeName
			--,CodeName
			 ,ProviderName
			 ,SiteName
			 ,CodeName
			 ,StartDate
			 ,EndDate
			 ,Units
			 ,Frequency
			 ,Duration
			 ,DurationEntry
			 ,TotalUnits
			 ,CreatedBy
			 ,CreatedDate
			,TotalCount
			,RowNumber
		INTO #FinalResultSet
		FROM RankResultSet
		WHERE RowNumber > ((@PageNumber - 1) * @PageSize)

		IF (
				SELECT ISNULL(COUNT(*), 0)
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
						THEN ISNULL((TotalCount / @PageSize), 0)
					ELSE ISNULL((TotalCount / @PageSize), 0) + 1
					END AS NumberOfPages
				,ISNULL(TotalCount, 0) AS NumberOfRows
			FROM #FinalResultSet
		END

		SELECT 
		    ProviderAuthorizationDefaultId
			--,StartDate
			--,EndDate
			--,Active
			--,InternalExternal
			--,Units
			--,Frequency
			--,Duration
			--,DurationEntry
			--,CreatedDate
			--,CreatedBy
			--,ProviderName
			--,SiteName
			--,AuthorizationCodeName
			--,CodeName
			--,TotalUnits
			  ,ProviderName
			 ,SiteName
			 ,CodeName
			 ,StartDate
			 ,EndDate
			 ,Units
			 ,Frequency
			 ,Duration
			 ,DurationEntry
			 ,TotalUnits
			 ,CreatedBy
			 ,CreatedDate
		FROM #FinalResultSet
		ORDER BY RowNumber

		DROP TABLE #FinalResultSet

		DROP TABLE #ProviderAuthorizationDefaults
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCListPageAuthorizationDefaults') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                                    
				16
				,-- Severity.                                                                                                    
				1 -- State.                                                                                                    
				);
	END CATCH
END