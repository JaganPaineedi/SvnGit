IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCListPageProviderAuthorizationList]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCListPageProviderAuthorizationList]
GO

CREATE PROCEDURE [dbo].[ssp_SCListPageProviderAuthorizationList] (
	@SessionId VARCHAR(30)
	,@InstanceId INT
	,@PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@staffId INT
	,@ClientId INT
	,@AuthorizationStatus INT
	,@StartDate DATETIME
	,@EndDate DATETIME
	,@AuthorizationCode INT
	,@AuthorizationNumber VARCHAR(35)
	,@ProvidersFilter INT
	,@OtherFilter INT
	)
AS
/********************************************************************************/
-- Stored Procedure: dbo.[ssp_SCListPageProviderAuthorizationList]  
--                                                                                                               
-- Copyright: Streamline Healthcate Solutions                                                                                                               
--                                                                                                               
-- Purpose:  To fecth the data for the list page CM Authorization                 
--    
-- Author: Malathi Shiva
--  
-- Date: July 01 2014
--                                                                                                             
-- Updates:         
-- Date				Author			Purpose 
-- 21 Oct 2015		Revathi		what:Changed code to display Clients LastName and FirstName when ClientType='I' else  OrganizationName.  /   
--								why:task #609, Network180 Customization  /
/*********************************************************************************/
BEGIN
	SET NOCOUNT ON;

	IF @StartDate = ''
		SET @StartDate = NULL

	IF @EndDate = ''
		SET @EndDate = NULL

	--  
	--Declare table to get data if Other filter exists -------  
	--  
	CREATE TABLE #Authorizations (AuthorizationId INT)

	--  
	--Get custom filters   
	--                                              
	IF @OtherFilter > 10000
	BEGIN
		INSERT INTO #Authorizations
		EXEC scsp_SCListPageProviderAuthorization @OtherFilter = @OtherFilter
	END
			--                                 
			--Insert data in to temp table which is fetched below by appling filter.     
			--   
			;

	WITH TotalAuthorizations
	AS (
		SELECT CLA.ClaimLineAuthorizationId
			,PAD.ProviderAuthorizationDocumentId
			,CL.ClientId
			--Added by Revathi 21 Oct 2015
			,CASE 
				WHEN ISNULL(CL.ClientType, 'I') = 'I'
					THEN ISNULL(CL.LastName, '') + ', ' + ISNULL(CL.FirstName, '')
				ELSE ISNULL(CL.OrganizationName, '')
				END AS ClientName
			,CASE ISNULL(P.ProviderName, 'N')
				WHEN 'N'
					THEN ''
				ELSE P.ProviderName
				END AS ProviderName
			,BC.BillingCode
			,GCS.CodeName AS StatusName
			,CASE 
				WHEN (
						PA.STATUS = 4242
						OR PA.STATUS = 4244
						)
					THEN PA.StartDateRequested
				ELSE PA.StartDate
				END AS FromDate
			,CASE 
				WHEN (
						PA.STATUS = 4242
						OR PA.STATUS = 4244
						)
					THEN PA.EndDateRequested
				ELSE PA.EndDate
				END AS ToDate
			,PA.UnitsUsed
			,PA.UnitsApproved
			,PA.UnitsRequested
			,PA.AuthorizationNumber
		FROM Events E
		INNER JOIN EventTypes ET ON ET.EventTypeId = E.EventTypeId
			AND ISNULL(ET.RecordDeleted, 'N') = 'N'
		INNER JOIN Clients CL ON CL.ClientId = E.ClientId
			AND ISNULL(CL.RecordDeleted, 'N') = 'N'
		INNER JOIN ProviderAuthorizationDocuments PAD ON PAD.EventId = E.EventId
			AND ISNULL(PAD.RecordDeleted, 'N') = 'N'
		INNER JOIN ProviderAuthorizations PA ON PA.ProviderAuthorizationDocumentId = PAD.ProviderAuthorizationDocumentId
			AND ISNULL(PA.RecordDeleted, 'N') = 'N'
		INNER JOIN ClaimLineAuthorizations CLA ON CLA.ProviderAuthorizationId = PA.ProviderAuthorizationId
			AND ISNULL(CLA.RecordDeleted, 'N') = 'N'
		INNER JOIN Providers P ON P.ProviderId = PA.ProviderId
			AND ISNULL(P.RecordDeleted, 'N') = 'N'
		INNER JOIN GlobalCodes GCS ON PA.STATUS = GCS.GlobalCodeId
			AND ISNULL(GCS.RecordDeleted, 'N') = 'N'
			AND GCS.Active = 'Y'
		LEFT JOIN BillingCodes BC ON BC.BillingCodeId = PA.BillingCodeId
			AND ISNULL(BC.RecordDeleted, 'N') = 'N'
		LEFT JOIN Sites S ON PA.SiteId = S.SiteId
			AND ISNULL(S.RecordDeleted, 'N') = 'N'
		WHERE (
				@ClientId != - 1
				AND CL.ClientId = @ClientId
				)
		)
		,counts
	AS (
		SELECT COUNT(*) AS totalrows
		FROM TotalAuthorizations
		)
		,ListAuthorizations
	AS (
		SELECT DISTINCT ClaimLineAuthorizationId
			,ProviderAuthorizationDocumentId
			,ClientId
			,ClientName
			,ProviderName
			,BillingCode
			,StatusName
			,FromDate
			,ToDate
			,UnitsUsed
			,UnitsApproved
			,UnitsRequested
			,AuthorizationNumber
			,COUNT(*) OVER () AS TotalCount
			,ROW_NUMBER() OVER (
				ORDER BY CASE 
						WHEN @SortExpression = 'ClaimLineAuthorizationId'
							THEN ClaimLineAuthorizationId
						END
					,CASE 
						WHEN @SortExpression = 'ClaimLineAuthorizationId desc'
							THEN ClaimLineAuthorizationId
						END DESC
					,CASE 
						WHEN @SortExpression = 'ClientName'
							THEN ClientName
						END
					,CASE 
						WHEN @SortExpression = 'ClientName desc'
							THEN ClientName
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
						WHEN @SortExpression = 'BillingCode'
							THEN BillingCode
						END
					,CASE 
						WHEN @SortExpression = 'BillingCode desc'
							THEN BillingCode
						END DESC
					,CASE 
						WHEN @SortExpression = 'StatusName'
							THEN StatusName
						END
					,CASE 
						WHEN @SortExpression = 'StatusName desc'
							THEN StatusName
						END DESC
					,CASE 
						WHEN @SortExpression = 'FromDate'
							THEN FromDate
						END
					,CASE 
						WHEN @SortExpression = 'FromDate desc'
							THEN FromDate
						END DESC
					,CASE 
						WHEN @SortExpression = 'ToDate'
							THEN ToDate
						END
					,CASE 
						WHEN @SortExpression = 'ToDate desc'
							THEN ToDate
						END DESC
					,CASE 
						WHEN @SortExpression = 'UnitsUsed'
							THEN UnitsUsed
						END
					,CASE 
						WHEN @SortExpression = 'UnitsUsed desc'
							THEN UnitsUsed
						END DESC
					,CASE 
						WHEN @SortExpression = 'UnitsApproved'
							THEN UnitsApproved
						END
					,CASE 
						WHEN @SortExpression = 'UnitsApproved desc'
							THEN UnitsApproved
						END DESC
					,CASE 
						WHEN @SortExpression = 'UnitsRequested'
							THEN UnitsRequested
						END
					,CASE 
						WHEN @SortExpression = 'UnitsRequested desc'
							THEN UnitsRequested
						END DESC
					,CASE 
						WHEN @SortExpression = 'AuthorizationNumber'
							THEN UnitsRequested
						END
					,CASE 
						WHEN @SortExpression = 'AuthorizationNumber desc'
							THEN UnitsRequested
						END DESC
				) AS RowNumber
		FROM TotalAuthorizations
		)
	SELECT TOP (
			CASE 
				WHEN (@PageNumber = - 1)
					THEN (
							SELECT ISNULL(totalrows, 0)
							FROM counts
							)
				ELSE (@PageSize)
				END
			) ClaimLineAuthorizationId
		,ProviderAuthorizationDocumentId
		,ClientId
		,ClientName
		,ProviderName
		,BillingCode
		,StatusName
		,FromDate
		,ToDate
		,UnitsUsed
		,UnitsApproved
		,UnitsRequested
		,AuthorizationNumber
		,TotalCount
		,RowNumber
	INTO #FinalResultSet
	FROM ListAuthorizations
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

	SELECT ClaimLineAuthorizationId
		,ProviderAuthorizationDocumentId
		,ClientId
		,ClientName
		,ProviderName
		,BillingCode
		,StatusName
		,FromDate
		,ToDate
		,UnitsUsed
		,UnitsApproved
		,UnitsRequested
		,AuthorizationNumber
	FROM #FinalResultSet
	ORDER BY RowNumber

	DROP TABLE #FinalResultSet

	DROP TABLE #Authorizations
END