/****** Object:  StoredProcedure [dbo].[ssp_CMListPageServiceClaims]    Script Date: 12/23/2016 07:06:06 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMListPageServiceClaims]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_CMListPageServiceClaims]
GO

/****** Object:  StoredProcedure [dbo].[ssp_CMListPageServiceClaims]    Script Date: 12/23/2016 07:06:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_CMListPageServiceClaims]
	/*********************************************************************/
	/* Author : Shruthi.S                                                */
	/* Date   : 12/03/2015                                               */
	/* Purpose: To display the Service from Claims list page.Ref #605 Network 180 Customizations.*/
	--Date			Name		Purpose
	--24-DEC-2015	Basudev		Sahu Modified For task #609 Network180 Customization to get organization name as client name 
	/*06/15/2016	Rajesh		Replace fromdate to startime task:40 - Arc Environment tracking issues - 
							Service from Claims screen - DOS is not being carried over, system is using current date*/
	--22June2016	Vithobha	Added check for @BillingCodeMod, Bradford - Environment Issues Tracking: #133 
	--31-Aug-2016   Mrunali     Added one condition for checking we want include or exclude  Services - Task No -#308		
	--12-23-2016	Shankha B	Corrected the Logic to display ClaimLines Place of Service instead of displaying Top 1 Location that had	 
	--							Defaultlocationforservicecreationfromclaims = 'Y'	
	--14-02-2017    Bernardin   Changed the DOS display as per ISNULL(CL.FromDate, CL.StartTime) FromDate. The ARC - SGL# 40	
	--17-4-2017     Lakshmi     As per the task we added default date should be the todays date if @DOSFrom and @DOSTo is null, 
							  --CEI - Support Go Live #593	
	 --05-07-2017	 Ravi		what: Appended (inactive) string to ClientNames those are active status 'N' and commented AND Cs.Active = 'Y' in where Clause
	 --							Why : CEI - Support Go Live > Tasks #672 > SC: Question- Services from Claims - inactive clients 
	 --12-26-2017	Shankha     Why: Core Bug# 2469
	 --							What: Incorrect query to get the Procedure Code for the related Service AND removed check for ClaimLine Status = PAID
	 --04-06-2018	Vijay       Why: CEI - Enhancements - #2
	 --							What: SC:Request for Customization: Rates for CM claims to services (we are not creating a new service if the paid amount is null)
	 --03-23-2018	 Ravi		what: list the ClaimLineIds by comma-separated used XML function instead of COALESCE function to improve the performance 
	 --							Why : The Arc - Support Go Live > Tasks # 252 > SC: ARC: Slow performance  
	/*********************************************************************/
	@ProviderId INT
	,@SiteId INT
	,@BillingCodeMod VARCHAR(max)
	,@CoveragePlan INT
	,@Insurer INT
	,@OtherFilter INT
	,@ClientId INT
	,@DOSFrom VARCHAR(20)
	,@DOSTo VARCHAR(20)
	,@IncludeService CHAR(1)
	,@SortExpression VARCHAR(100)
	,@PageNumber INT
	,@PageSize INT
	,@StaffId INT
AS
BEGIN
	BEGIN TRY
	    --Added by Lakshmi on 17/04-2017
	     IF(@DOSFrom IS NULL AND @DOSTo IS NULL)
	     BEGIN
	     SET @DOSFrom=CAST(GETDATE() AS DATE)
	     SET @DOSTo=CAST(GETDATE() AS DATE)
	     END 
		---To get AllInsurer and AllProvider flag.
		DECLARE @AllStaffInsurer VARCHAR(1)
		DECLARE @AllStaffProvider VARCHAR(1)

		SELECT @AllStaffInsurer = AllInsurers
		FROM staff
		WHERE staffid = @StaffId

		SELECT @AllStaffProvider = AllProviders
		FROM staff
		WHERE staffId = @StaffId

		--To get the default place of service
		DECLARE @DefaultLocation VARCHAR(100)

		SELECT TOP 1 @DefaultLocation = LocationName
		FROM Locations
		WHERE isnull(Defaultlocationforservicecreationfromclaims, 'N') = 'Y'
			AND ISNULL(RecordDeleted, 'N') <> 'Y'

		--To split the billingcodemodid 
		DECLARE @BillingCodeId VARCHAR(30)
		DECLARE @BillingCodeModId VARCHAR(30)

		SET @BillingCodeModId = ''
		SET @BillingCodeId = ''

		IF (@BillingCodeMod = '')
			SET @BillingCodeMod = - 1

		IF (@BillingCodeMod != '-1')
		BEGIN
			SELECT @BillingCodeId = SUBSTRING(@BillingCodeMod, 1, CHARINDEX('_', @BillingCodeMod, 0) - 1)

			SELECT @BillingCodeModId = SUBSTRING(@BillingCodeMod, CHARINDEX('_', @BillingCodeMod, 0) + 1, LEN(@BillingCodeMod))
		END

		--  
		--Declare table to get data if Other filter exists -------  
		--  
		CREATE TABLE #CustomFilters (ClaimLineId INT)

		DECLARE @CustomFiltersApplied CHAR(1) = 'N'

		CREATE TABLE #ResultSet (
			ClaimLineId INT
			,ProviderSite VARCHAR(max)
			,ClientName VARCHAR(max)
			,BillingCodeMod VARCHAR(max)
			,DOS DATETIME
			,Units INT
			,ProcedureCode VARCHAR(500)
			,CoveragePlan VARCHAR(300)
			,PlaceOfService VARCHAR(200)
			,ServiceId INT
			,CreatedDate DATETIME
			,CreatedBy VARCHAR(200)
			,ServiceErrors VARCHAR(max)
			,ClientId INT
			)

		IF ISNULL(@SortExpression, '') = ''
			SET @SortExpression = 'ClientName'

		--Get custom filters   
		--                                              
		IF @OtherFilter > 10000
		BEGIN
			SET @CustomFiltersApplied = 'Y'

			INSERT INTO #CustomFilters
			EXEC scsp_CMListPageServiceClaims @ProviderId = @ProviderId
				,@SiteId = @SiteId
				,@BillingCodeMod = @BillingCodeMod
				,@CoveragePlan = @CoveragePlan
				,@Insurer = @Insurer
				,@OtherFilter = @OtherFilter
				,@ClientId = @ClientId
				,@DOSFrom = @DOSFrom
				,@DOSTo = @DOSTo
				,@IncludeService = @IncludeService
		END

		--     
		--                                  
		--Insert data in to temp table which is fetched below by appling filter.     
		--   
		INSERT INTO #ResultSet (
			ClaimLineId
			,ProviderSite
			,ClientName
			,BillingCodeMod
			,DOS
			,Units
			,ProcedureCode
			,CoveragePlan
			,PlaceOfService
			,ServiceId
			,CreatedDate
			,CreatedBy
			,ClientId
			)
		SELECT DISTINCT (Cl.ClaimLineId)
			,p.ProviderName + '/' + S.SiteName AS ProviderSite
			,CASE 
				WHEN ISNULL(CS.ClientType, 'I') = 'I'
					THEN ISNULL(CS.LastName, '') + ', ' + ISNULL(CS.FirstName, '')
				ELSE ISNULL(CS.OrganizationName, '')
				END + CASE WHEN CS.Active = 'N' THEN ' (Inactive)' ELSE '' END AS ClientName   --05-07-2017	 Ravi
			,bc.BillingCode + ':' + CASE 
				WHEN isnull(cl.Modifier1, '') = ''
					THEN ''
				ELSE cl.Modifier1 + ':' + CASE 
						WHEN isnull(cl.Modifier2, '') = ''
							THEN ''
						ELSE cl.Modifier2 + ':' + CASE 
								WHEN isnull(cl.Modifier3, '') = ''
									THEN ''
								ELSE cl.Modifier3 + ':' + CASE 
										WHEN isnull(cl.Modifier4, '') = ''
											THEN ''
										ELSE cl.Modifier4
										END
								END
						END
				END AS BillingCodeMod
			,ISNULL(CL.FromDate, CL.StartTime) FromDate
			,--cl.FromDate,--06/15/2016	Rajesh	
			cl.Units
			--,PC.ProcedureCodeName  -- 12-26-2017 Shankha
			, NULL  -- 12-26-2017 Shankha
			,--In furture change it to Procedurecode in billingcodes
			CPL.CoveragePlanName
			,g.CodeName
			,
			--@DefaultLocation,
			CM.ServiceId
			,CM.CreatedDate
			,CM.CreatedBy
			,C.ClientId
		FROM Claims C
		JOIN ClaimLines CL ON C.ClaimId = cl.ClaimId
			AND ISNULL(cl.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(c.RecordDeleted, 'N') <> 'Y'
		JOIN Clients CS ON Cs.ClientId = c.ClientId
			AND ISNULL(CS.RecordDeleted, 'N') <> 'Y'
			-- AND Cs.Active = 'Y'       --05-07-2017	 Ravi
		JOIN Sites S ON S.SiteId = C.SiteId
			AND ISNULL(S.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN Providers P ON P.ProviderId = CASE 
				WHEN C.claimtype = 2222
					THEN S.ProviderId
				ELSE cl.RenderingProviderId
				END
			AND p.Active = 'Y'
			AND ISNULL(P.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN BillingCodes BC ON CL.BillingCodeId = BC.BillingCodeId
			AND ISNULL(BC.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN (
			SELECT clp.ClaimLineId
				,clp.CoveragePlanId
			FROM ClaimLineCoveragePlans clp
			INNER JOIN CoveragePlans p ON clp.CoveragePlanId = p.CoveragePlanId
			WHERE isnull(clp.RecordDeleted, 'N') <> 'Y'
				AND isnull(p.RecordDeleted, 'N') <> 'Y'
			GROUP BY clp.ClaimLineId
				,clp.CoveragePlanId
			HAVING sum(clp.PaidAmount) > 0
			) CP ON CP.ClaimLineId = Cl.ClaimLineId
		LEFT JOIN CoveragePlans CPL ON CPL.CoveragePlanId = CP.CoveragePlanId
			AND ISNULL(CPL.RecordDeleted, 'N') <> 'Y'
		--LEFT JOIN ProcedureCodes PC ON PC.ProcedureCodeId = BC.ProcedureCodeId
		--	AND ISNULL(PC.RecordDeleted, 'N') <> 'Y' -- 12-26-2017 Shankha
		LEFT JOIN ClaimLineServiceMappings CM ON CM.ClaimLineId = Cl.ClaimLineId
			AND ISNULL(CM.RecordDeleted, 'N') <> 'Y'
		--left join ServiceClaimErrors SE on SE.ClaimLineId = CL.ClaimLineId and ISNULL(SE.RecordDeleted,'N') <> 'Y'
		LEFT JOIN BillingCodeModifiers BM ON BM.BillingCodeId = Cl.BillingCodeId
			AND ISNULL(BM.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN Insurers I ON I.InsurerId = C.InsurerId
			AND ISNULL(I.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN GlobalCodes g ON g.GlobalCodeId = CL.PlaceOfService
			AND ISNULL(g.RecordDeleted, 'N') <> 'Y'
		WHERE (
				(
					@CustomFiltersApplied = 'Y'
					AND EXISTS (
						SELECT *
						FROM #CustomFilters CF
						WHERE CF.ClaimLineId = CL.ClaimLineId
						)
					)
				OR (@CustomFiltersApplied = 'N')
				)
			AND (
				(
					ISNULL(@IncludeService, 'N') = 'N'
					AND CM.ServiceId IS NULL
					)
				OR (ISNULL(@IncludeService, 'N') = 'Y')
				)
			AND (
				BM.BillingCodeModifierId = @BillingCodeModId
				OR @BillingCodeModId = ''
				)
			AND (
				@BillingCodeMod = '-1'
				OR BC.BillingCodeId = @BillingCodeId
				)
			AND CL.[status] = 2026 --For paid status  -- 12-26-2017 Shankha
			AND (
				@ProviderId = - 1
				OR EXISTS (
					SELECT SP.ProviderId
					FROM StaffProviders SP
					WHERE ISNULL(RecordDeleted, 'N') <> 'Y'
						AND SP.StaffId = @StaffId
						AND SP.ProviderId = CASE 
							WHEN C.claimtype = 2222
								THEN S.ProviderId
							ELSE cl.RenderingProviderId
							END
						AND SP.ProviderId = @ProviderId
						AND @AllStaffProvider = 'N'
					)
				OR EXISTS (
					SELECT ProviderId P
					FROM Providers P
					WHERE ISNULL(RecordDeleted, 'N') <> 'Y'
						AND P.ProviderId = CASE 
							WHEN C.claimtype = 2222
								THEN S.ProviderId
							ELSE cl.RenderingProviderId
							END
						AND P.ProviderId = @ProviderId
						AND @AllStaffProvider = 'Y'
					)
				)
			AND (
				@Insurer = - 1
				OR EXISTS (
					SELECT SI.InsurerId
					FROM StaffInsurers SI
					WHERE ISNULL(RecordDeleted, 'N') <> 'Y'
						AND SI.StaffId = @StaffId
						AND c.InsurerId = SI.InsurerId
						AND @AllStaffInsurer = 'N'
					)
				OR EXISTS (
					SELECT InsurerId I
					FROM Insurers I
					WHERE ISNULL(RecordDeleted, 'N') <> 'Y'
						AND c.InsurerId = I.InsurerId
						AND @AllStaffInsurer = 'Y'
					)
				)
			AND (
				@SiteId = - 1
				OR C.SiteId = @SiteId
				)
			AND (
				@CoveragePlan = - 1
				OR CP.CoveragePlanId = @CoveragePlan
				)
			AND (
				@ClientId = 0
				OR @ClientId = C.ClientId
				)
			AND (
				@DOSFrom IS NULL
				OR (cast(Cl.FromDate AS DATE) > = cast(@DOSFrom AS DATE))
				)
			AND (
				@DOSTo IS NULL
				OR (cast(Cl.ToDate AS DATE) <= cast(@DOSTo AS DATE))
				)
		ORDER BY Cl.ClaimLineId
			,
			--SE.CreatedDate,
			ProviderSite
			,ClientName
			,BillingCodeMod
			,FromDate
			,-- cl.FromDate --06/15/2016 Rajesh
			cl.Units
			--,PC.ProcedureCodeName -- 12-26-2017 Shankha
			,CPL.CoveragePlanName
			,CM.ServiceId
			,CM.CreatedDate
			,CM.CreatedBy
			,C.ClientId
		
		-- 12-26-2017 Shankha
		-- To Update the Procedure name 
		UPDATE R
		SET R.ProcedureCode = PC.ProcedureCodeName
		FROM #ResultSet R JOIN Services S on R.ServiceId = S.ServiceId
		Join ProcedureCodes PC on S.ProcedureCodeId = PC.ProcedureCodeId
		AND ISNULL(PC.RecordDeleted, 'N')  = 'N'

		---------------To update Errormessage.Since, a claim line can have multiple error messages.
		UPDATE R
		SET R.ServiceErrors = T.ErrorMessage
		FROM #ResultSet R
		JOIN (
			SELECT R2.ClaimLineId
				,Replace(Replace(Stuff((
								SELECT DISTINCT ', ' + SE.ServiceCreationError
								FROM #ResultSet R1
								LEFT JOIN ServiceClaimErrors SE ON SE.ClaimLineId = R1.ClaimLineId
									AND ISNULL(Se.RecordDeleted, 'N') <> 'Y'
								WHERE R2.ClaimLineId = R1.ClaimLineId
								FOR XML path('')
								), 1, 1, ''), '&lt;', '<'), '&gt;', '>') 'ErrorMessage'
			FROM #ResultSet R2
			) T ON T.ClaimLineId = R.ClaimLineId;

		WITH counts
		AS (
			SELECT COUNT(*) AS TotalRows
			FROM #ResultSet
			)
			,RankResultSet
		AS (
			SELECT ClaimLineId
				,ProviderSite
				,ClientName
				,BillingCodeMod
				,DOS
				,Units
				,ProcedureCode
				,CoveragePlan
				,PlaceOfService
				,ServiceId
				,CreatedDate
				,CreatedBy
				,ServiceErrors
				,ClientId
				,COUNT(*) OVER () AS TotalCount
				,ROW_NUMBER() OVER (
					ORDER BY CASE 
							WHEN @SortExpression = 'ClaimLineId'
								THEN ClaimLineId
							END
						,CASE 
							WHEN @SortExpression = 'ClaimLineId desc'
								THEN ClaimLineId
							END DESC
						,CASE 
							WHEN @SortExpression = 'ProviderSite'
								THEN ProviderSite
							END
						,CASE 
							WHEN @SortExpression = 'ProviderSite desc'
								THEN ProviderSite
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
							WHEN @SortExpression = 'BillingCodeMod'
								THEN BillingCodeMod
							END
						,CASE 
							WHEN @SortExpression = 'BillingCodeMod desc'
								THEN BillingCodeMod
							END DESC
						,CASE 
							WHEN @SortExpression = 'DOS'
								THEN DOS
							END
						,CASE 
							WHEN @SortExpression = 'DOS desc'
								THEN DOS
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
							WHEN @SortExpression = 'ProcedureCode'
								THEN ProcedureCode
							END
						,CASE 
							WHEN @SortExpression = 'ProcedureCode desc'
								THEN ProcedureCode
							END DESC
						,CASE 
							WHEN @SortExpression = 'CoveragePlan'
								THEN CoveragePlan
							END
						,CASE 
							WHEN @SortExpression = 'CoveragePlan desc'
								THEN CoveragePlan
							END DESC
						,CASE 
							WHEN @SortExpression = 'PlaceOfService'
								THEN PlaceOfService
							END
						,CASE 
							WHEN @SortExpression = 'PlaceOfService desc'
								THEN PlaceOfService
							END DESC
						,CASE 
							WHEN @SortExpression = 'ServiceId'
								THEN ServiceId
							END
						,CASE 
							WHEN @SortExpression = 'ServiceId desc'
								THEN ServiceId
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
							WHEN @SortExpression = 'ServiceErrors'
								THEN ServiceErrors
							END
						,CASE 
							WHEN @SortExpression = 'ServiceErrors desc'
								THEN ServiceErrors
							END DESC
						,ClaimLineId
					) AS RowNumber
			FROM #ResultSet
			)
		SELECT TOP (
				CASE 
					WHEN (@PageNumber = - 1)
						THEN (
								SELECT ISNULL(TotalRows, 0)
								FROM Counts
								)
					ELSE (@PageSize)
					END
				) ClaimLineId
			,ProviderSite
			,ClientName
			,BillingCodeMod
			,DOS
			,Units
			,ProcedureCode
			,CoveragePlan
			,PlaceOfService
			,ServiceId
			,CreatedDate
			,CreatedBy
			,ServiceErrors
			,ClientId
			,TotalCount
			,RowNumber
		INTO #FinalResultSet
		FROM RankResultSet
		WHERE RowNumber > ((@PageNumber - 1) * @PageSize)

		DECLARE @ClaimLineIds VARCHAR(max);

		--SELECT @ClaimLineIds = COALESCE(@ClaimLineIds + ',', '') + CAST(fs.ClaimLineId AS VARCHAR)
		--FROM #ResultSet fs
		
		--03-23-2018	 Ravi
		SET @ClaimLineIds=(select ISNULL(STUFF((SELECT ',' + ISNULL(CAST(fs.ClaimLineId AS VARCHAR), '')
						  FROM #ResultSet fs            
						  FOR XML PATH('')
						  ,type ).value('.', 'nvarchar(max)'), 1, 1, ''), '') 
					   )
		

		IF (
				SELECT ISNULL(COUNT(*), 0)
				FROM #FinalResultSet
				) < 1
		BEGIN
			SELECT 0 AS PageNumber
				,0 AS NumberOfPages
				,0 NumberofRows
				,'' AS ClaimLineIds
		END
		ELSE
		BEGIN
			SELECT TOP 1 @PageNumber AS PageNumber
				,CASE (Totalcount % @PageSize)
					WHEN 0
						THEN ISNULL((Totalcount / @PageSize), 0)
					ELSE ISNULL((Totalcount / @PageSize), 0) + 1
					END AS NumberOfPages
				,ISNULL(Totalcount, 0) AS NumberofRows
				,@ClaimLineIds AS ClaimLineIds
			FROM #FinalResultSet
		END

		SELECT ClaimLineId
			,ProviderSite
			,ClientName
			,BillingCodeMod
			,Convert(VARCHAR, DOS, 101) AS DOS
			,Units
			,ProcedureCode
			,CoveragePlan
			,PlaceOfService
			,ServiceId
			,CreatedDate
			,CreatedBy
			,ServiceErrors
			,ClientId
		FROM #FinalResultSet
		ORDER BY RowNumber
	END TRY

	BEGIN CATCH
		DECLARE @error VARCHAR(8000)

		SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_CMListPageServiceClaims') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
	END CATCH
END
GO


