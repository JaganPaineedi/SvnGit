
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageCombinedSCAuthorizations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ListPageCombinedSCAuthorizations]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_ListPageCombinedSCAuthorizations] (
	@StaffId INT
	,@Status INT
	,@FromDate DATETIME
	,@ToDate DATETIME
	,@AuthorizationNumber VARCHAR(35)
	,@ReviewTypes INT
	,@InsurerId INT
	,@CoveragePlanId INT
	,@BillingCodeId INT
	,@ProviderId INT
	,@SiteId INT
	,@AuthorizationCode INT
	,@ClientId INT
	,@DueStartDate DATETIME
	,@DueEndDate DATETIME
	,@ClinicianId INT
	,@UrgentRequests INT
	,@PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@OtherFilter INT
	)
AS
/********************************************************************************    
-- Stored Procedure: dbo.ssp_ListPageCombinedSCAuthorizations      
--  
-- Copyright: Streamline Healthcate Solutions 
--    
-- Created:                                                           
-- Date			 Author				Purpose    
      
22-July-2015	Revathi				what:Get SC Authorizations for Combine Authorization List page
									why:task #662 Network 180 - Customizations
13-Sep-2016     Manjunath           What/Why: Converting 'FromDate' and 'ToDate' from [DATETIME] to [DATE]. 
                                    For Core Bugs #517
05-Jan-2017     Pavani              What added AuthBillingCode,FromDate columns to Sorting                                    
                                    Why :Network180 Support Go Live #17
*********************************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @CustomFiltersApplied CHAR(1) = 'N'

		IF @FromDate = ''
			SET @FromDate = NULL

		IF @ToDate = ''
			SET @ToDate = NULL

		--
		--Declare table to get data if Other filter exists -------
		--
		CREATE TABLE #CustomFilters (AuthorizationId INT)

		CREATE TABLE #ResultSet (
			AuthorizationId INT
			,AuthorizationDocumentId INT
			,ClientId INT
			,ClientName VARCHAR(250)
			,Flag CHAR(1)
			,ProviderName VARCHAR(max)
			,InsurerName VARCHAR(max)
			,AuthBillingCode VARCHAR(50)
			,StatusName VARCHAR(100)
			,FromDate DATETIME
			,ToDate DATETIME
			,AuthDate VARCHAR(max)
			,Used DECIMAL(18, 2)
			,Approved DECIMAL(18, 2)
			,Requested DECIMAL(18, 2)
			,AuthorizationNumber VARCHAR(50)
			,InterventionEndDate DATETIME
			,Clinician VARCHAR(250)
			,DocumentName VARCHAR(250)
			,ScreenId INT
			)

		--
		--Get custom filters 
		--                                            
		IF @OtherFilter > 10000
		BEGIN
			IF OBJECT_ID('dbo.scsp_ListPageCombinedSCAuthorizations', 'P') IS NOT NULL
			BEGIN
				SET @CustomFiltersApplied = 'Y'

				INSERT INTO #CustomFilters
				EXEC scsp_ListPageCombinedSCAuthorizations @StaffId = @StaffId
					,@Status = @Status
					,@FromDate = @FromDate
					,@ToDate = @ToDate
					,@AuthorizationNumber = @AuthorizationNumber
					,@ReviewTypes = @ReviewTypes
					,@InsurerId = @InsurerId
					,@CoveragePlanId = @CoveragePlanId
					,@BillingCodeId = @BillingCodeId
					,@ProviderId = @ProviderId
					,@SiteId = @SiteId
					,@AuthorizationCode = @AuthorizationCode
					,@ClientId = @ClientId
					,@DueStartDate = @DueStartDate
					,@DueEndDate = @DueEndDate
					,@ClinicianId = @ClinicianId
					,@UrgentRequests = @UrgentRequests
			END
		END

		INSERT INTO #ResultSet (
			AuthorizationId
			,AuthorizationDocumentId
			,ClientId
			,ClientName
			,Flag
			,ProviderName
			,InsurerName
			,AuthBillingCode
			,StatusName
			,FromDate
			,ToDate
			,AuthDate
			,Used
			,Approved
			,Requested
			,AuthorizationNumber
			,InterventionEndDate
			,Clinician
			,DocumentName
			,ScreenId
			)
		SELECT A.AuthorizationId
			,AD.AuthorizationDocumentId
			,C.ClientId
			,ISNULL(C.LastName + ', ', '') + C.FirstName AS ClientName
			,NULL
			,NULL
			,CP.DisplayAs AS CoveragePlanName
			,AC.AuthorizationCodeName
			,GC.CodeName AS StatusName
			,CASE 
				WHEN A.STATUS = 4243
					THEN A.StartDate
				ELSE A.StartDateRequested
				END AS FromDate
			,CASE 
				WHEN A.STATUS = 4243
					THEN A.EndDate
				ELSE A.EndDateRequested
				END AS ToDate
			,NULL
			,ISNULL(A.UnitsUsed, 0) AS Used
			,ISNULL(A.TotalUnits, 0) AS Approved
			,ISNULL(A.TotalUnitsRequested, 0) AS Requested
			,A.AuthorizationNumber
			,A.InterventionEndDate
			,ISNULL(S.LastName + ', ', '') + S.FirstName
			,Dc.DocumentName
			,498
		FROM Authorizations A
		INNER JOIN AuthorizationDocuments AD ON A.AuthorizationDocumentId = AD.AuthorizationDocumentId
			AND ISNULL(AD.RecordDeleted, 'N') = 'N'
		INNER JOIN AuthorizationCodes AC ON A.AuthorizationCodeId = AC.AuthorizationCodeId
			AND ISNULL(AC.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes GC ON A.[Status] = GC.GlobalCodeId
			AND ISNULL(GC.RecordDeleted, 'N') = 'N'
			AND GC.Active = 'Y'
		INNER JOIN ClientCoveragePlans CCS ON AD.ClientCoveragePlanId = CCS.ClientCoveragePlanId
			AND ISNULL(CCS.RecordDeleted, 'N') = 'N'
			AND CCS.ClientId > 0
		INNER JOIN Clients C ON C.ClientId = CCS.ClientId
			AND ISNULL(C.RecordDeleted, 'N') = 'N'
		INNER JOIN StaffClients sc ON sc.StaffId = @StaffId
			AND sc.ClientId = C.ClientId
		INNER JOIN CoveragePlans CP ON CP.CoveragePlanId = CCS.CoveragePlanId
			AND ISNULL(CP.RecordDeleted, 'N') = 'N'
		LEFT JOIN Staff S ON S.StaffId = A.ClinicianId
			AND ISNULL(S.RecordDeleted, 'N') = 'N'
		LEFT JOIN Documents D ON D.DocumentId = AD.DocumentId
			AND ISNULL(D.RecordDeleted, 'N') = 'N'
		LEFT JOIN DocumentCodes DC ON DC.DocumentCodeId = D.DocumentCodeId
			AND ISNULL(DC.RecordDeleted, 'N') = 'N'
		WHERE (
				(
					@CustomFiltersApplied = 'Y'
					AND EXISTS (
						SELECT *
						FROM #CustomFilters CF
						WHERE CF.AuthorizationId = A.AuthorizationId
						)
					)
				OR (
					@CustomFiltersApplied = 'N'
					AND (ISNULL(@ClientId, - 1) = - 1 OR  CCS.ClientId =@ClientId)
					AND A.STATUS = CASE 
						WHEN ISNULL(@Status, - 1) = - 1
							THEN A.STATUS
						ELSE @Status
						END
					AND CASE 
						WHEN A.STATUS = 4243
							THEN A.StartDate
						WHEN A.StartDateRequested IS NULL
							THEN A.StartDate
						ELSE A.StartDateRequested
						END < dateadd(dd, 1, ISNULL(@ToDate, (
								CASE 
									WHEN A.STATUS = 4243
										THEN A.StartDate
									WHEN A.StartDateRequested IS NULL
										THEN A.StartDate
									ELSE A.StartDateRequested
									END
								)))
					AND ISNULL(CASE 
							WHEN A.STATUS = 4243
								THEN A.EndDate
							WHEN A.EndDateRequested IS NULL
								THEN A.EndDate
							ELSE A.EndDateRequested
							END, ISNULL(@FromDate, '01/01/1900')) >= ISNULL(@FromDate, '01/01/1900')
					AND (ISNULL(@CoveragePlanId, - 1) = - 1 OR  CCS.CoveragePlanId = @CoveragePlanId)
					AND (ISNULL(@AuthorizationCode, - 1) = -1 OR  A.AuthorizationCodeId=@AuthorizationCode)
					AND (isnull(@AuthorizationNumber, '')='' OR A.AuthorizationNumber=@AuthorizationNumber)
					AND (ISNULL(@ClinicianId,-1)=-1 OR A.ClinicianId=@ClinicianId)
					AND ISNULL(A.RecordDeleted, 'N') = 'N'
					)
				);

		WITH counts
		AS (
			SELECT COUNT(*) AS totalrows
			FROM #ResultSet
			)
			,ListAuthorizations
		AS (
			SELECT AuthorizationId
				,AuthorizationDocumentId
				,ClientId
				,ClientName
				,Flag
				,ProviderName
				,InsurerName
				,AuthBillingCode
				,StatusName
				,FromDate
				,ToDate
				,AuthDate
				,Used
				,Approved
				,Requested
				,AuthorizationNumber
				,InterventionEndDate
				,Clinician
				,DocumentName
				,ScreenId
				,COUNT(*) OVER () AS TotalCount
				,ROW_NUMBER() OVER (
					ORDER BY CASE 
							WHEN @SortExpression = 'AuthorizationId'
								THEN AuthorizationId
							END
						,CASE 
							WHEN @SortExpression = 'AuthorizationId desc'
								THEN AuthorizationId
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
							WHEN @SortExpression = 'InsurerName'
								THEN InsurerName
							END
						,CASE 
							WHEN @SortExpression = 'InsurerName desc'
								THEN InsurerName
							END DESC
						,CASE 
							WHEN @SortExpression = 'AuthBillingCode'
								THEN AuthBillingCode
							END
						,CASE 
							WHEN @SortExpression = 'AuthBillingCode desc'
								THEN AuthBillingCode
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
							WHEN @SortExpression = 'AuthDate'
								THEN AuthDate
							END
						,CASE 
							WHEN @SortExpression = 'AuthDate desc'
								THEN AuthDate
							END DESC
						,CASE 
							WHEN @SortExpression = 'Used'
								THEN Used
							END
						,CASE 
							WHEN @SortExpression = 'Used desc'
								THEN Used
							END DESC
						,CASE 
							WHEN @SortExpression = 'Approved'
								THEN Approved
							END
						,CASE 
							WHEN @SortExpression = 'Approved desc'
								THEN Approved
							END DESC
						,CASE 
							WHEN @SortExpression = 'Requested'
								THEN Requested
							END
						,CASE 
							WHEN @SortExpression = 'Requested desc'
								THEN Requested
							END DESC
						,CASE 
							WHEN @SortExpression = 'AuthorizationNumber'
								THEN AuthorizationNumber
							END
						,CASE 
							WHEN @SortExpression = 'AuthorizationNumber desc'
								THEN AuthorizationNumber
							END DESC
						,CASE 
							WHEN @SortExpression = 'Flag'
								THEN Flag
							END
						,CASE 
							WHEN @SortExpression = 'Flag desc'
								THEN Flag
							END DESC
						,CASE 
							WHEN @SortExpression = 'InterventionEndDate'
								THEN InterventionEndDate
							END
						,CASE 
							WHEN @SortExpression = 'InterventionEndDate desc'
								THEN InterventionEndDate
							END DESC
						,CASE 
							WHEN @SortExpression = 'DocumentName'
								THEN DocumentName
							END
						,CASE 
							WHEN @SortExpression = 'DocumentName desc'
								THEN DocumentName
							END DESC
						,CASE 
							WHEN @SortExpression = 'Clinician'
								THEN Clinician
							END
						,CASE 
							WHEN @SortExpression = 'Clinician desc'
								THEN Clinician
							END DESC
						--05-Jan-2017     Pavani   
						,AuthBillingCode
						,FromDate
						--End
					) AS RowNumber
			FROM #ResultSet
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
				) AuthorizationId
			,AuthorizationDocumentId
			,ClientId
			,ClientName
			,Flag
			,ProviderName
			,InsurerName
			,AuthBillingCode
			,StatusName
			,FromDate
			,ToDate
			,AuthDate
			,Used
			,Approved
			,Requested
			,AuthorizationNumber
			,convert(VARCHAR, InterventionEndDate, 101) AS InterventionEndDate
			,Clinician
			,DocumentName
			,ScreenId
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

		SELECT AuthorizationId
			,AuthorizationDocumentId
			,ClientId
			,ClientName
			,Flag
			,ProviderName
			,InsurerName
			,AuthBillingCode
			,StatusName
			,CONVERT(VARCHAR, FromDate, 101) AS FromDate    --13-Sep-2016     Manjunath
			,CONVERT(VARCHAR, ToDate, 101) AS ToDate        --13-Sep-2016     Manjunath
			,AuthDate
			,Used
			,Approved
			,Requested
			,AuthorizationNumber
			,InterventionEndDate
			,Clinician
			,DocumentName
			,ScreenId
		FROM #FinalResultSet
		ORDER BY RowNumber
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = convert(VARCHAR, error_number()) + '*****' 
		+ convert(VARCHAR(4000), error_message()) + '*****' 
		+ isnull(convert(VARCHAR, error_procedure()), 'ssp_ListPageCombinedSCAuthorizations')
		 + '*****' + convert(VARCHAR, error_line())
		  + '*****' + convert(VARCHAR, error_severity()) 
		  + '*****' + convert(VARCHAR, error_state())

		RAISERROR (
				@Error
				,-- Message text.  
				16
				,-- Severity.  
				1 -- State.  
				);
	END CATCH
END
