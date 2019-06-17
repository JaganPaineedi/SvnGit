IF EXISTS 
(
	SELECT *
	FROM SYS.objects
	WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageCMAuthorizations]')
		AND type IN (N'P', N'PC')
)
	DROP PROCEDURE [dbo].[ssp_ListPageCMAuthorizations]
GO

CREATE PROCEDURE [dbo].[ssp_ListPageCMAuthorizations] 
(
	@StaffId INT,
	@AuthorizationStatus INT,
	@StartDate DATETIME,
	@EndDate DATETIME,
	@AuthorizationNumber VARCHAR(35),
	@ReviewTypes INT,
	@InsurerId INT,
	@PopulationId INT,
	@BillingCodeModifierId INT,
	@ProviderId INT,
	@SiteId INT,
	@OtherFilter INT,
	@ClientId INT,
	@DueStartDate DATETIME,
	@DueEndDate DATETIME,
	@UrgentRequests INT,
	@PageNumber INT,
	@PageSize INT,
	@SortExpression VARCHAR(100),
	@ProgramType INT
)
AS
/***********************************************************************************************************************    
	Stored Procedure:	dbo.ssp_ListPageCMAuthorizations        
	Copyright:			Streamline Healthcate Solutions    
	Created:  
========================================================================================================================
	Modification Log
========================================================================================================================                                                         
	Date			Author				Purpose 
	-------------	----------------	------------------------------------------------------------
	01-Jul-2014		Malathi Shiva 		What:CM Authorization List Page.          
										Why:task #15 CM to SC
	15-Jul-2014		Revathi				What:Get data from Provider Authorization and Related tables for CM Authorization List Page.          
										Why:task #15 CM to SC
	16-July-2014	Malathi Shiva		PopulationId for "All Population" is modified to GlobalSubCodeId = 10622 instead 
										of -1 since the drop down is bound with the GlobalCodeId = 5412 so the corresponding 
										GlobalSubCodeId is used.
										Urgent Flag sorting criteria is added
	04-Aug-2014		Malathi Shiva		Added active check for Providers and Sites table because from the list page when 
										we redirect to the detail page by clicking on Id, Inactive Providers are not 
										displayed in the Provider dropdown due to which it does not select them
	12-Sep-2014		Revathi				change inner join  ProviderAuthorizations with ProviderAuthorizationDocumentId 
										instead of AuthorizationDocumentId
	16-sept-2014	Malathi Shiva		Active check added to Billing codes
	23-sept-2014	Malathi Shiva		CodeName is removed from the AuthDate display since only the date is supposed to 
										be displayed in the grid
	29-sept-2014	Malathi Shiva		PopulationId for "All Population" is modified to GlobalSubCodeId = with Code 'AP' 
										instead of 10622 since it is custom Global SunCodeId and there is possibility to 
										change in every database.
	10-dec-2015		Basudev 			modify   for  network 180 task #609
	27-Jan-2016		Aravind             Added a ProgramType Parameter for List Page to allow filtering by Client Program 
										Enrollment Type
										Why:Task #795 - CM Auth List Page: Add Field - Program Type
	06/15/2016		Rajesh				Added Distinct in main query to remove duplicate records
										task:40 - Arc Environment tracking issue - CM Auths: each auth is repeating itself 
										4x when seen on list page
	04/27/2017		Shankha B			NULL Check was not present while fetching values for AllProviders,AllInsurers
										Why: Allegan - Support# 687.61
	02 Jan 2018	    Neelima 			Added PA.BillingCodeId = @BillingCodeId, since when there is no Billing code 
										selected in the CM Authorizations and data is inserted, the RequestedBillingCodeId 
										value is NULL and is not getting filtered in the list page 
										Why: SWMBH - Support #1355
	30 Jan 2018	    Neelima 			Added @BillingCodeModifierId as parameter instead of BillingCodeId, since while 
										filtering it should filter exactly  based on Modifier data
										Why: SWMBH - Support #1355
	02/06/2018		Ting-Yu Mu			Modified to use SystemConfigurationKey = 'ProviderAuthDueDateFromEventDate' to
										get the correct auth due date as follow:
											1. If Key value = 'Y' then compute the auth due date by calling custom function
											csf_GetProviderAuthDueDateFromEventDate
											2. If key value = 'N' then compute the auth due date from StartDateRequested
											based on the review level
										Why: SWMBH - Support #1326
	03/19/2018		Ting-Yu Mu			Modified the code to reference the ssf_GetProviderAuthDueDateFromEventDate
										instead of csf_GetProviderAuthDueDateFromEventDate
										Why: SWMBH - Support #1326
	06/25/2018		Ting-Yu Mu			What:
										1. Modified the logic to check the population criteria against the ProviderAuthorizations
										   in the WHERE clause by using EXISTS statement
										2. Declare a variable @ProviderAuthDueDateFromEventDate to hold the value from 
										   the system configuration key "ProviderAuthDueDateFromEventDate" so that the
										   function will not be executed multiple times based on number of records got returned
										   to increase the query performance
										Why: KCMHSAS - Support #1080
	06/28/2018		Ting-Yu Mu			What: Added the statement in the WHERE clause to take "No Population Assigned"
										filter into consideration
										Why: KCMHSAS - Support #1080
    12/02/2018      Sachin			    What : CM Authorizations: 'Auth Due' column displays an incorrect date.
                                        Why  : As part of SWMBH - Support #1326 task, added the logic for auth date and in END passed as '' hence it is showing "1900-01-01" date 
                                        instead of NULL. To make it work added the NULL instead of '' condition for Allegan - Support#1463.

***********************************************************************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @AllStaffInsurer VARCHAR(1)
		DECLARE @AllStaffProvider VARCHAR(1)

		SELECT	@AllStaffInsurer = ISNULL(AllInsurers,'N')
		FROM	dbo.Staff
		WHERE	staffid = @StaffId

		SELECT	@AllStaffProvider = ISNULL(AllProviders,'N')
		FROM	dbo.Staff
		WHERE	staffId = @StaffId

		DECLARE @CustomFiltersApplied CHAR(1) = 'N'

		IF @StartDate = ''
			SET @StartDate = NULL

		IF @EndDate = ''
			SET @EndDate = NULL

		DECLARE @AllPopulation INT
		DECLARE	@NoPopulation INT

		SET @AllPopulation = 
			(
				SELECT	TOP 1 GlobalSubCodeId
				FROM	GlobalSubCodes
				WHERE	GlobalCodeId = 5412
					AND Active = 'Y'
					AND ISNULL(RecordDeleted, 'N') = 'N'
					AND Code = 'AP'
			)

		SET @NoPopulation = 
			(
				SELECT	TOP 1 GlobalSubCodeId
				FROM	GlobalSubCodes
				WHERE	GlobalCodeId = 5412
					AND Active = 'Y'
					AND ISNULL(RecordDeleted, 'N') = 'N'
					AND Code = 'NPA'
			)

		--To get the default place of service
		DECLARE @DefaultLocation VARCHAR(100)

		SELECT	TOP 1 @DefaultLocation = LocationName
		FROM	dbo.Locations
		WHERE	ISNULL(Defaultlocationforservicecreationfromclaims, 'N') = 'Y'
			AND ISNULL(RecordDeleted, 'N') <> 'Y'

		--  
		--Declare table to get data if Other filter exists -------  
		--  
		CREATE TABLE #CustomFilters (ProviderAuthorizationId INT)

		CREATE TABLE #ResultSet 
		(
			ProviderAuthorizationId INT
			,ProviderAuthorizationDocumentId INT
			,ClientId INT
			,ClientName VARCHAR(100)
			,ProviderName VARCHAR(max)
			,BillingCodes VARCHAR(50)
			,StatusName VARCHAR(100)
			,FromDate DATETIME
			,ToDate DATETIME
			,Used DECIMAL(18, 2)
			,Approved DECIMAL(18, 2)
			,Requested DECIMAL(18, 2)
			,AuthDate VARCHAR(max)
			,AuthorizationNumber VARCHAR(50)
			,UrgentFlag CHAR(1)
			,IdentityId INT
			,BitmapNo INT
			,
			---------- Urgent flag ------------------------------------------------------------------------------------
			ObjectFlagId1 VARCHAR(250)
			,FlagTypeId1 INT
			,Bitmap1 VARCHAR(200)
			,Note1 VARCHAR(MAX)
			,CodeName1 VARCHAR(250)
			,
			---------- pended flag ------------------------------------------------------------------------------------
			ObjectFlagId2 VARCHAR(250)
			,FlagTypeId2 INT
			,Bitmap2 VARCHAR(200)
			,Note2 VARCHAR(MAX)
			,CodeName2 VARCHAR(250)
			,
		)

		IF ISNULL(@SortExpression, '') = ''
			SET @SortExpression = 'ClientName'

		--  
		--Get custom filters   
		--                                              
		IF @OtherFilter > 10000
		BEGIN
			SET @CustomFiltersApplied = 'Y'

			INSERT INTO #CustomFilters
			EXEC scsp_ListPageCMAuthorizations @StaffId = @StaffId
				,@AuthorizationStatus = @AuthorizationStatus
				,@StartDate = @StartDate
				,@EndDate = @EndDate
				,@AuthorizationNumber = @AuthorizationNumber
				,@ReviewTypes = @ReviewTypes
				,@InsurerId = @InsurerId
				,@PopulationId = @PopulationId
				,@BillingCodeModifierId = @BillingCodeModifierId
				,@ProviderId = @ProviderId
				,@SiteId = @SiteId
				,@OtherFilter = @OtherFilter
				,@ClientId = @ClientId
				,@DueStartDate = @DueStartDate
				,@DueEndDate = @DueEndDate
				,@UrgentRequests = @UrgentRequests
		END

		CREATE TABLE #Flags 
		(
			FlagId INT IDENTITY NOT NULL
			,NoteOrder INT NULL
			,IdentityId INT NULL
			,ObjectFlagId INT NULL
			,FlagTypeId INT NULL
			,Bitmap INT NULL
			,NoteNumber INT NULL
			,Note VARCHAR(100) NULL
			,CodeName VARCHAR(250) NULL
		)
		
		--all flags associated with ProviderAuthorizations
		;WITH ObjectFlags_CTE
		AS 
		(
			SELECT o.IdentityId
				,o.ObjectFlagId
				,o.FlagTypeId
				,o.Note
				,ISNULL(o.NoteLevel, 0) AS NoteLevel
				,o.StartDate
				,o.EndDate
				,o.CreatedDate
			FROM ObjectFlags o
			WHERE ISNULL(o.RecordDeleted, 'N') = 'N'
				AND o.Active = 'Y'
				AND o.TableNameOfObject = 'ProviderAuthorizations'
		)
		--Get data and insert flags into #flags
		INSERT INTO #Flags 
		(
			NoteOrder
			,--used to iterate over flags
			IdentityId
			,ObjectFlagId
			,FlagTypeId
			,Bitmap
			,Note
			,CodeName
		)
		SELECT ROW_NUMBER() OVER 
			(
				PARTITION BY o.IdentityId ORDER BY o.IdentityId
					,ISNULL(o.NoteLevel, 0)
					,o.CreatedDate
			) AS NoteOrder
			,o.IdentityId
			,o.ObjectFlagId
			,o.FlagTypeId
			,FT.FlagTypeId AS GlobalCodeId
			,o.Note
			,FT.FlagType AS CodeName
		FROM ObjectFlags_CTE o
		LEFT JOIN ProviderAuthorizations PA ON PA.ProviderAuthorizationId = o.IdentityId
		INNER JOIN FlagTypes FT ON FT.FlagTypeId = o.FlagTypeId
			AND ISNULL(FT.RecordDeleted, 'N') = 'N'
			AND ISNULL(FT.DoNotDisplayFlag, 'N') = 'N'
			AND (
				ISNULL(FT.PermissionedFlag, 'N') = 'N'
				OR (
					ISNULL(FT.PermissionedFlag, 'N') = 'Y'
					AND (
						(
							EXISTS (
								SELECT 1
								FROM PermissionTemplateItems PTI
								INNER JOIN PermissionTemplates PT ON PT.PermissionTemplateId = PTI.PermissionTemplateId
									AND ISNULL(PT.RecordDeleted, 'N') = 'N'
									AND dbo.ssf_GetGlobalCodeNameById(PT.PermissionTemplateType) = 'Flags'
								INNER JOIN StaffRoles SR ON SR.RoleId = PT.RoleId
									AND ISNULL(SR.RecordDeleted, 'N') = 'N'
								WHERE ISNULL(PTI.RecordDeleted, 'N') = 'N'
									AND PTI.PermissionItemId = FT.FlagTypeId
									AND SR.StaffId = @StaffId
								)
							OR EXISTS (
								SELECT 1
								FROM StaffPermissionExceptions SPE
								WHERE SPE.StaffId = @StaffId
									AND ISNULL(SPE.RecordDeleted, 'N') = 'N'
									AND dbo.ssf_GetGlobalCodeNameById(SPE.PermissionTemplateType) = 'Flags'
									AND SPE.PermissionItemId = FT.FlagTypeId
									AND SPE.Allow = 'Y'
									AND (
										SPE.StartDate IS NULL
										OR CAST(SPE.StartDate AS DATE) <= CAST(GETDATE() AS DATE)
										)
									AND (
										SPE.EndDate IS NULL
										OR CAST(SPE.EndDate AS DATE) >= CAST(GETDATE() AS DATE)
										)
								)
							)
						AND NOT EXISTS (
							SELECT 1
							FROM StaffPermissionExceptions SPE
							WHERE SPE.StaffId = @StaffId
								AND ISNULL(SPE.RecordDeleted, 'N') = 'N'
								AND dbo.ssf_GetGlobalCodeNameById(SPE.PermissionTemplateType) = 'Flags'
								AND SPE.PermissionItemId = FT.FlagTypeId
								AND SPE.Allow = 'N'
								AND (
									SPE.StartDate IS NULL
									OR CAST(SPE.StartDate AS DATE) <= CAST(GETDATE() AS DATE)
									)
								AND (
									SPE.EndDate IS NULL
									OR CAST(SPE.EndDate AS DATE) >= CAST(GETDATE() AS DATE)
									)
							)
						)
					)
				)
		ORDER BY o.IdentityId
			,o.NoteLevel
			,o.CreatedDate

		--table to aggregate flags for a specific identity into one row of columns
		CREATE TABLE #FlagColumns 
		(
			IdentityId INT
			,BitmapNo INT
			,ObjectFlagId1 INT --flag 1 - urgent flag
			,FlagTypeId1 INT
			,Bitmap1 VARCHAR(200)
			,Note1 VARCHAR(MAX)
			,CodeName1 VARCHAR(250)
			,ObjectFlagId2 INT --flag 2 - pended authorization flag
			,FlagTypeId2 INT
			,Bitmap2 VARCHAR(200)
			,Note2 VARCHAR(MAX)
			,CodeName2 VARCHAR(250)
		)

		INSERT INTO #FlagColumns (IdentityId)
		SELECT DISTINCT IdentityId
		FROM #Flags

		DECLARE @PKCounter INT
		DECLARE @LoopCounter INT
		DECLARE @IdentityId INT

		SET @LoopCounter = ISNULL((
					SELECT COUNT(*)
					FROM #Flags
					), 0)
		SET @PKCounter = 1

		--merge rows in #flags for similar identities into a single row in #FlagColumns 
		WHILE (
				@LoopCounter > 0
				AND @PKCounter <= @LoopCounter
				)
		BEGIN
			SELECT @IdentityId = IdentityId
			FROM #Flags
			WHERE FlagId = @PKCounter

			UPDATE fc
			SET fc.IdentityId = f.IdentityId
				,fc.BitmapNo = ISNULL(fc.BitmapNo, 0) + 1
				,
				------ 1 - Urgent flag
				fc.ObjectFlagId1 = CASE 
					WHEN f.NoteOrder = 1
						THEN f.ObjectFlagId
					ELSE fc.ObjectFlagId1
					END
				,fc.FlagTypeId1 = CASE 
					WHEN f.NoteOrder = 1
						THEN f.FlagTypeId
					ELSE fc.FlagTypeId1
					END
				,fc.Bitmap1 = CASE 
					WHEN f.NoteOrder = 1
						THEN f.Bitmap
					ELSE fc.Bitmap1
					END
				,fc.Note1 = CASE 
					WHEN f.NoteOrder = 1
						THEN f.Note
					ELSE fc.Note1
					END
				,fc.CodeName1 = CASE 
					WHEN f.NoteOrder = 1
						THEN f.CodeName
					ELSE fc.CodeName1
					END
				,
				------ 2 - Authorization pended flag
				fc.ObjectFlagId2 = CASE 
					WHEN f.NoteOrder = 2
						THEN f.ObjectFlagId
					ELSE fc.ObjectFlagId2
					END
				,fc.FlagTypeId2 = CASE 
					WHEN f.NoteOrder = 2
						THEN f.FlagTypeId
					ELSE fc.FlagTypeId2
					END
				,fc.Bitmap2 = CASE 
					WHEN f.NoteOrder = 2
						THEN f.Bitmap
					ELSE fc.Bitmap2
					END
				,fc.Note2 = CASE 
					WHEN f.NoteOrder = 2
						THEN f.Note
					ELSE fc.Note2
					END
				,fc.CodeName2 = CASE 
					WHEN f.NoteOrder = 2
						THEN f.CodeName
					ELSE fc.CodeName2
					END
			FROM #Flags f
			JOIN #FlagColumns fc ON fc.IdentityId = f.IdentityId
			WHERE f.FlagId = @PKCounter

			SET @PKCounter = @PKCounter + 1
		END

		DECLARE	@ProviderAuthDueDateFromEventDate CHAR(1) = 'N'
		SET		@ProviderAuthDueDateFromEventDate = dbo.ssf_GetSystemConfigurationKeyValue('ProviderAuthDueDateFromEventDate')
		
		--                                  
		--Insert data in to temp table which is fetched below by appling filter.     
		--   
		INSERT INTO #ResultSet 
		(
			ProviderAuthorizationId
			,ProviderAuthorizationDocumentId
			,ClientId
			,ClientName
			,ProviderName
			,BillingCodes
			,StatusName
			,FromDate
			,ToDate
			,Used
			,Approved
			,Requested
			,AuthDate
			,AuthorizationNumber
			,UrgentFlag
			,BitmapNo
			,IdentityId
			,ObjectFlagId1
			,FlagTypeId1
			,Bitmap1
			,Note1
			,CodeName1
			,ObjectFlagId2
			,FlagTypeId2
			,Bitmap2
			,Note2
			,CodeName2
		)
		SELECT DISTINCT -- 06/15/2016		Rajesh
			PA.ProviderAuthorizationId
			,PA.ProviderAuthorizationDocumentId
			,C.ClientId
			,CASE -- modify by Basu deva  for  network 180 task #609
				WHEN ISNULL(C.ClientType, 'I') = 'I'
					THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')
				ELSE ISNULL(C.OrganizationName, '')
				END AS ClientName ---
			--,ISNULL(C.LastName + ', ', '') + C.FirstName AS ClientName
			,STUFF(COALESCE('- ' + RTRIM(P.ProviderName), '') + COALESCE(' - ' + RTRIM(S.SiteName), ''), 1, 2, '') AS ProviderName
			,CASE 
				WHEN (
						ISNULL(PA.Modifier1, '') = ''
						AND ISNULL(PA.Modifier2, '') = ''
						AND ISNULL(PA.Modifier3, '') = ''
						AND ISNULL(PA.Modifier4, '') = ''
						)
					THEN BC.BillingCode
				ELSE BC.BillingCode + ' : ' + ISNULL(PA.Modifier1 + ' ', '') + ISNULL(PA.Modifier2 + ' ', '') + ISNULL(PA.Modifier3 + ' ', '') + ISNULL(PA.Modifier4 + ' ', '')
				END AS BilllingCodes
			,GC.CodeName AS StatusName
			,CASE 
				WHEN PA.STATUS = 2042
					THEN PA.StartDate
				ELSE PA.StartDateRequested
				END AS FromDate
			,CASE 
				WHEN PA.STATUS = 2042
					THEN PA.EndDate
				ELSE PA.EndDateRequested
				END AS ToDate
			,ISNULL(PA.UnitsUsed, 0) AS Used
			,ISNULL(PA.TotalUnitsApproved, 0) AS Approved
			,ISNULL(PA.TotalUnitsRequested, 0) AS Requested
			-- TMU modified on 01/02/2018 as per SWMBH - Support #1326 =================================================
			,CASE 
				WHEN @ProviderAuthDueDateFromEventDate = 'Y'
					THEN dbo.ssf_GetProviderAuthDueDateFromEventDate(PA.ProviderAuthorizationId) -- ==== TMU modified on 03/19/2018
				ELSE
					CASE 
						WHEN PA.ReviewLevel = 8726
							THEN CONVERT(VARCHAR, DATEADD(DAY, 30, PA.StartDateRequested), 101)
						WHEN PA.ReviewLevel = 8727
							THEN CONVERT(VARCHAR, DATEADD(DAY, 14, PA.StartDateRequested), 101)
						WHEN PA.ReviewLevel = 8728
							THEN CONVERT(VARCHAR, DATEADD(DAY, 3, PA.StartDateRequested), 101)
						ELSE NULL
					END
				END AS AuthDate
			-- ==== End of TMU modification ============================================================================
			,PA.AuthorizationNumber
			,ISNULL(PA.Urgent, 'N') AS UrgentFlag ----------------------------------------------------------------------------------------------------
			,FC.BitmapNo AS BitmapNo
			,FC.IdentityId
			---- Urgent Flag
			,FC.ObjectFlagId1 AS ObjectFlagId1
			,FC.FlagTypeId1 AS FlagTypeId1
			,FC.Bitmap1 AS Bitmap1
			,ISNULL(FC.CodeName1 + ':' + FC.Note1, '') AS Note1
			,FC.CodeName1 AS CodeName1
			---- Pended flag
			,FC.ObjectFlagId2 AS ObjectFlagId2
			,FC.FlagTypeId2 AS FlagTypeId2
			,FC.Bitmap2 AS Bitmap2
			,ISNULL(FC.CodeName2 + ':' + FC.Note2, '') AS Note2
			,FC.CodeName2 AS CodeName2
		FROM ProviderAuthorizations PA
		INNER JOIN ProviderAuthorizationDocuments PAD ON PA.ProviderAuthorizationDocumentId = PAD.ProviderAuthorizationDocumentId
		--INNER JOIN BillingCodes BC   ON PA.RequestedBillingCodeId = BC.BillingCodeId 
		INNER JOIN BillingCodes BC ON BC.BillingCodeId = ISNULL(PA.BillingCodeId, PA.RequestedBillingCodeId)
		INNER JOIN BillingCodeModifiers BCM ON BCM.BillingCodeId = PA.BillingCodeId
		INNER JOIN Clients C ON C.ClientId = PA.ClientId
		INNER JOIN StaffClients sc ON sc.StaffId = @StaffId
			AND sc.ClientId = C.ClientId
		LEFT JOIN GlobalCodes GC ON PA.[Status] = GC.GlobalCodeId
			AND ISNULL(GC.RecordDeleted, 'N') = 'N'
			AND GC.Active = 'Y'
		LEFT JOIN GlobalCodes GC1 ON PA.ReviewLevel = GC1.GlobalCodeId
			AND ISNULL(GC1.RecordDeleted, 'N') = 'N'
		LEFT JOIN Providers P ON PA.ProviderId = P.ProviderId
		LEFT JOIN Sites S ON S.SiteId = PA.SiteId
		LEFT JOIN ClientPrograms CP ON CP.ClientId = C.ClientId
			OR (
				@ClientId = - 1
				OR CP.ClientId = @ClientId
				)
			AND CP.STATUS = 4
			AND ISNULL(CP.RecordDeleted, 'N') = 'N'
		LEFT JOIN Programs PR ON PR.ProgramId = CP.ProgramId
			AND ISNULL(PR.RecordDeleted, 'N') = 'N'
		LEFT JOIN #FlagColumns FC ON FC.IdentityId = PA.ProviderAuthorizationId
		WHERE (
				(
					@CustomFiltersApplied = 'Y'
					AND EXISTS (
						SELECT *
						FROM #CustomFilters CF
						WHERE CF.ProviderAuthorizationId = PA.ProviderAuthorizationId
						)
					)
				OR (@CustomFiltersApplied = 'N')
				)
			AND PA.ClientId = CASE 
				WHEN ISNULL(@ClientId, 0) = 0
					THEN PA.ClientId
				ELSE @ClientId
				END
			AND PA.STATUS = CASE 
				WHEN ISNULL(@AuthorizationStatus, 0) = 0
					THEN PA.STATUS
				ELSE @AuthorizationStatus
				END
			AND CASE 
				WHEN PA.STATUS = 2042
					THEN PA.StartDate
				WHEN PA.StartDateRequested IS NULL
					THEN PA.StartDate
				ELSE PA.StartDateRequested
				END < DATEADD(DD, 1, ISNULL(@EndDate, (
						CASE 
							WHEN PA.STATUS = 2042
								THEN PA.StartDate
							WHEN PA.StartDateRequested IS NULL
								THEN PA.StartDate
							ELSE PA.StartDateRequested
							END
						)))
			AND ISNULL(CASE 
					WHEN PA.STATUS = 2042
						THEN PA.EndDate
					WHEN PA.EndDateRequested IS NULL
						THEN PA.EndDate
					ELSE PA.EndDateRequested
					END, ISNULL(@StartDate, '01/01/1900')) >= ISNULL(@StartDate, '01/01/1900')
			AND (
				ISNULL(PA.AuthorizationNumber, '') = CASE 
					WHEN ISNULL(@AuthorizationNumber, '') = ''
						THEN ISNULL(PA.AuthorizationNumber, '')
					ELSE @AuthorizationNumber
					END
				AND (
					ISnull(@UrgentRequests, 0) = 0
					OR PA.Urgent = CASE 
						WHEN @UrgentRequests = 1
							THEN 'Y'
						END
					)
				OR CAST(PA.ProviderAuthorizationId AS VARCHAR(MAX)) = CAST(@AuthorizationNumber AS VARCHAR(MAX))
				)
			--AND(@BillingCodeId =-1 OR @BillingCodeId ='' OR PA.RequestedBillingCodeId=@BillingCodeId OR PA.BillingCodeId = @BillingCodeId)   --Modified by Neelima
			AND 
			(
				@BillingCodeModifierId = '-1'
				OR @BillingCodeModifierId = ''
				OR PA.RequestedBillingCodeModifierId = @BillingCodeModifierId
			)
			AND 
			(
				@ProgramType = - 1
				OR PR.ProgramType = @ProgramType
			)
			AND 
			(
				@InsurerId = - 1
				OR PA.InsurerId = @InsurerId
			)
			AND 
			(
				@ProviderId = - 1
				OR PA.ProviderId = @ProviderId
			)
			AND 
			(
				EXISTS (
					SELECT SI.InsurerId
					FROM StaffInsurers SI
					WHERE ISNULL(RecordDeleted, 'N') <> 'Y'
						AND SI.StaffId = @StaffId
						AND PA.InsurerId = SI.InsurerId
						AND @AllStaffInsurer = 'N'
					)
				OR EXISTS (
					SELECT InsurerId I
					FROM Insurers I
					WHERE ISNULL(RecordDeleted, 'N') <> 'Y'
						AND PA.InsurerId = I.InsurerId
						AND @AllStaffInsurer = 'Y'
					)
			)
			AND 
			(
				EXISTS (
					SELECT SP.ProviderId
					FROM StaffProviders SP
					WHERE ISNULL(RecordDeleted, 'N') <> 'Y'
						AND SP.StaffId = @StaffId
						AND PA.ProviderId = SP.ProviderId
						AND @AllStaffProvider = 'N'
					)
				OR EXISTS (
					SELECT ProviderId P
					FROM Providers P
					WHERE ISNULL(RecordDeleted, 'N') <> 'Y'
						AND PA.ProviderId = P.ProviderId
						AND @AllStaffProvider = 'Y'
					)
			)
			AND 
			(
				@SiteId = - 1
				OR PA.SiteId = @SiteId
			)
			AND -- TMU modified on 06/25/2018 as per KCMHSAS - Support #1080 ===
			(
				@PopulationId = @AllPopulation
				OR PAD.AssignedPopulation = @PopulationId
				OR EXISTS
				(
					SELECT	GC.GlobalCodeId
					FROM	dbo.GlobalCodes GC 
					JOIN	dbo.GlobalSubCodes GSC ON GC.CodeName = GSC.SubCodeName
						AND GSC.GlobalCodeId = 5412
					WHERE	ISNULL(GC.RecordDeleted, 'N') = 'N'
						AND ISNULL(GSC.RecordDeleted, 'N') = 'N'
						AND GC.Active = 'Y'
						AND GSC.Active = 'Y'
						AND GSC.GlobalSubCodeId = @PopulationId
						AND GC.GlobalCodeId = PA.AssignedPopulation
				)
				OR 
				(
					@PopulationId = @NoPopulation AND
					--PAD.AssignedPopulation IS NULL OR 
					PA.AssignedPopulation IS NULL
				) 
			)	-- End of TMU modification on 06/25/2018 =======================
			AND 
			(
				@ReviewTypes = - 1
				OR PA.ReviewLevel = @ReviewTypes
			)
			AND 
			(
				ISNULL(@DueStartDate, '') = ''
				-- TMU modified on 01/02/2018 as per SWMBH - Support #1326 =============================================
				OR (
					CASE 
						WHEN @ProviderAuthDueDateFromEventDate = 'Y'
							THEN dbo.ssf_GetProviderAuthDueDateFromEventDate(PA.ProviderAuthorizationId) -- ==== TMU modified on 03/19/2018
						ELSE
							CASE 
								WHEN PA.ReviewLevel = 8726
									THEN CONVERT(VARCHAR, DATEADD(DAY, 30, PA.StartDateRequested), 101)
								WHEN PA.ReviewLevel = 8727
									THEN CONVERT(VARCHAR, DATEADD(DAY, 14, PA.StartDateRequested), 101)
								WHEN PA.ReviewLevel = 8728
									THEN CONVERT(VARCHAR, DATEADD(DAY, 3, PA.StartDateRequested), 101)
								ELSE ''
							END
					END >= @DueStartDate
					)
				-- ==== End of TMU modification ========================================================================
			)
			AND 
			(
				ISNULL(@DueEndDate, '') = ''
				-- TMU modified on 01/02/2018 as per SWMBH - Support #1326 =============================================
				OR (
					CASE 
						WHEN @ProviderAuthDueDateFromEventDate = 'Y'
							THEN dbo.ssf_GetProviderAuthDueDateFromEventDate(PA.ProviderAuthorizationId) -- ==== TMU modified on 03/19/2018
						ELSE
							CASE 
								WHEN PA.ReviewLevel = 8726
									THEN CONVERT(VARCHAR, DATEADD(DAY, 30, PA.StartDateRequested), 101)
								WHEN PA.ReviewLevel = 8727
									THEN CONVERT(VARCHAR, DATEADD(DAY, 14, PA.StartDateRequested), 101)
								WHEN PA.ReviewLevel = 8728
									THEN CONVERT(VARCHAR, DATEADD(DAY, 3, PA.StartDateRequested), 101)
								ELSE ''
							END
					END <= @DueEndDate
				)
				-- ==== End of TMU modification ========================================================================
			)
			AND ISNULL(PA.RecordDeleted, 'N') = 'N'
			AND ISNULL(PAD.RecordDeleted, 'N') = 'N'
			AND ISNULL(BC.RecordDeleted, 'N') = 'N'
			AND ISNULL(C.RecordDeleted, 'N') = 'N'
			AND ISNULL(P.RecordDeleted, 'N') = 'N'
			AND 
			(
				PA.ProviderId IS NULL
				OR P.Active = 'Y'
			)
			AND ISNULL(S.RecordDeleted, 'N') = 'N'
			AND 
			(
				PA.SiteId IS NULL
				OR S.Active = 'Y'
			)
			AND 
			(
				PA.RequestedBillingCodeId IS NULL
				OR BC.Active = 'Y'
			)
			AND 
			(
				PA.BillingCodeId IS NULL
				OR BC.Active = 'Y'
			)

		;WITH counts
		AS 
		(
			SELECT COUNT(*) AS TotalRows
			FROM #ResultSet
		)
		,RankResultSet
		AS 
		(
			SELECT ProviderAuthorizationId
				,ProviderAuthorizationDocumentId
				,ClientId
				,ClientName
				,ProviderName
				,BillingCodes
				,StatusName
				,FromDate
				,ToDate
				,Used
				,Approved
				,Requested
				,AuthDate
				,AuthorizationNumber
				,UrgentFlag
				,BitmapNo
				,IdentityId
				,ObjectFlagId1
				,FlagTypeId1
				,Bitmap1
				,Note1
				,CodeName1
				,ObjectFlagId2
				,FlagTypeId2
				,Bitmap2
				,Note2
				,CodeName2
				,COUNT(*) OVER () AS TotalCount
				,ROW_NUMBER() OVER (
					ORDER BY CASE 
							WHEN @SortExpression = 'ProviderAuthorizationId'
								THEN ProviderAuthorizationId
							END
						,CASE 
							WHEN @SortExpression = 'ProviderAuthorizationId desc'
								THEN ProviderAuthorizationId
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
							WHEN @SortExpression = 'BillingCodes'
								THEN BillingCodes
							END
						,CASE 
							WHEN @SortExpression = 'BillingCodes desc'
								THEN BillingCodes
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
							WHEN @SortExpression = 'AuthDate'
								THEN AuthDate
							END
						,CASE 
							WHEN @SortExpression = 'AuthDate desc'
								THEN AuthDate
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
							WHEN @SortExpression = 'UrgentFlag'
								THEN UrgentFlag
							END
						,--needs to be changed, should sort by ObjecFlagId?
						CASE 
							WHEN @SortExpression = 'UrgentFlag desc'
								THEN UrgentFlag
							END DESC
						,ProviderAuthorizationId
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
				) ProviderAuthorizationId
			,ProviderAuthorizationDocumentId
			,ClientId
			,ClientName
			,ProviderName
			,BillingCodes
			,StatusName
			,convert(VARCHAR, FromDate, 101) AS FromDate
			,convert(VARCHAR, ToDate, 101) AS ToDate
			,Used
			,Approved
			,Requested
			,AuthDate
			,AuthorizationNumber
			,UrgentFlag
			,TotalCount
			,RowNumber
			,BitmapNo
			,IdentityId
			,ObjectFlagId1
			,FlagTypeId1
			,Bitmap1
			,Note1
			,CodeName1
			,ObjectFlagId2
			,FlagTypeId2
			,Bitmap2
			,Note2
			,CodeName2
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
				,0 NumberofRows
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
			FROM #FinalResultSet
		END

		SELECT ProviderAuthorizationId
			,ProviderAuthorizationDocumentId
			,ClientId
			,ClientName
			,ProviderName
			,BillingCodes
			,StatusName
			,FromDate
			,ToDate
			,Used
			,Approved
			,Requested
			,AuthDate
			,AuthorizationNumber
			,UrgentFlag
			,BitmapNo
			,IdentityId
			,ObjectFlagId1
			,FlagTypeId1
			,Bitmap1
			,Note1
			,CodeName1
			,ObjectFlagId2
			,FlagTypeId2
			,Bitmap2
			,Note2
			,CodeName2
		FROM #FinalResultSet
		ORDER BY RowNumber
	END TRY

	BEGIN CATCH
		DECLARE @error VARCHAR(8000)

		SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + 
				'*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_ListPageCMAuthorizations') + 
				'*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + 
				'*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR 
		(
			@error,	-- Message text.
			16,		-- Severity.
			1		-- State.
		);
	END CATCH
END
GO


