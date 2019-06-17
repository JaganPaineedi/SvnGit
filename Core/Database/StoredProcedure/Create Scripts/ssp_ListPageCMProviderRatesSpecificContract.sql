
IF EXISTS ( SELECT *
                FROM sys.objects
                WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageCMProviderRatesSpecificContract]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [dbo].[ssp_ListPageCMProviderRatesSpecificContract]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_ListPageCMProviderRatesSpecificContract] ( @EffectiveDate DATETIME
                                                                     , @SiteId INT
																	 , @CoveragePlanId Int
                                                                     , @ClientId INT
                                                                     , @ContractDate DATETIME
                                                                     , @ContractEndDate DATETIME
                                                                     , @InsurerId INT
                                                                     , @ContractId INT
                                                                     , @SortExpression VARCHAR(100)
                                                                     , @ProviderId INT
                                                                     , @PageNumber INT
                                                                     , @PageSize INT
                                                                     , @OtherFilter INT 
                                                                     , @BillingCodeId INT
                                                                     , @BillingCodeModifierId INT)
AS 
/*********************************************************************/
/* Stored Procedure: dbo.ssp_ListPageCMProviderRatesSpecificContract */
/* Copyright: 2005 Provider Claim Management System                  */
/* Creation Date:  05/13/2014                                        */
/*                                                                   */
/* Purpose: To  show Member  Provider Contract datagrid              */
/*                                                                   */
/* Input Parameters:                                                 */
/*                                                                   */
/* Output Parameters:                                                */
/*                                                                   */
/*                                                                   */
/* Called By:                                                        */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/*  Date                 Author       Purpose                        */
/* 26-Sept-2015 SuryaBalan Network Customization- Created for Provider Contracts Rate List Page under Provider COntracts Detail Page*/
/* 13-Oct-2015* SuryaBalan To get multiple site names I added condition #618*/
/* 13-Dec-2015* SuryaBalan Fixed Contracted Rates - Effective As Of filter not working Issue. #618.6 Network 180 Environment Issues Tracking */
/* 23-Feb-2016  Shruthi.S  Uncommented effective date condition which was commented out.Ref : #618.6 Network 180 Environment Issues Tracking.*/
-- 21.Apr.2016	Rohith Uppin		Null Check for Date filled modified and Sorting for billingcode name added. Task#906 SWMBH Support.
-- 15.June.2016 Himmat     Added extra comma in between sitetext Swmbh Task No.1002
-- 18/11/2016	Chethan N		 What : Get BillingCodeModifiers.Description instead BillingCodes.CodeName.
--								 Why: SWMBH-Support Task #893 
--/* 02-March-2017 Nandita S	 What : Mapping License group id and text with contract rate id and mapping place of service id with global code id fpr place of service
--								 Why: Heartland east task #6800*/	
--   6 June 2017    PradeepT     What: Modified the temp table #ResultSet to increase the length of BillingCodeName from 100 to 250
--                               Why: Task KCMHAS-#900.48: #ResultSet.BillingCodeName field is poulating from BillingCodeModifiers.Description which is varchar(250). KCMHAS-#900.48	
--   06/20/2017     Pranay       Added CoveragePlanText Why :SWMBHA Task#557
---  12/04/2017     PradeepT     What: Made modification as per changes that I did for KCMHAS-#900.48 on dated  6 June 2017
-- 12/22/2017		Ponnin		 What: Removed the space after Client's Last name. Why: For task Core Bugs #2473
-- 16-feb-2018       neethu		 What :Bind BillingCodeModifiers.CodeName instead BillingCodes.Description.
--								 Why: SWMBH - Enhancements Task #1162 
--26 Feb 2018       PradeepT     What: Enclosed the left join logic into parnthesis where we are comparing modifiers of
--                                     BilingcodeModifier and associated ContractRates modifier.Also optimized case statament as Per Slavik Suggestion
---                              Why: It was returning too large records which was not correct. As per Task KCMHSAS - Support-#972			 						 
--07 Mar 2018		Vijay		 Why: LicenseTypeIdText,LicenseTypeGroupName,PlaceOfServiceIdText,PlaceOfServiceGroupName columns are added and search by BillingCodeId,BillingCodeModifierId functionality added
--								 What: Heartland East - Customizations - Task#26
/*********************************************************************/
    BEGIN
        BEGIN TRY
            DECLARE @CustomFiltersApplied CHAR(1)

            CREATE TABLE #CustomFilters ( DocumentId INT )

            SET @CustomFiltersApplied = 'N'

            DECLARE @AllProviders VARCHAR(1)
            DECLARE @AllInsurers VARCHAR(1)
            DECLARE @SiteIdText VARCHAR(MAX)
			DECLARE @CoveragePalnIdTest VARCHAR(MAX)
		--SELECT TOP 1 @AllProviders = allproviders  
		-- ,@AllInsurers = allinsurers  
		--FROM staff  
		--WHERE staffid = @StaffId  
		-- AND ISNULL(RecordDeleted, 'N') <> 'Y'  
            CREATE TABLE #ResultSet ( ContractRateId INT
                                    , ContractId INT
                                    , BillingCodeId INT
                                    , Modifier1 VARCHAR(10)
                                    , Modifier2 VARCHAR(10)
                                    , Modifier3 VARCHAR(10)
                                    , Modifier4 VARCHAR(10)
                                    , SiteId INT
									, CoveragePlanId INT  --Pranay
                                    , ClientId INT
                                    , StartDate DATE
                                    , EndDate DATE
                                    , ContractRate MONEY
                                    , Active VARCHAR(10)
                                    , RequiresAffilatedProvider VARCHAR(10)
                                    , AllAffiliatedProviders VARCHAR(10)
                                    , RateUnit VARCHAR(50)
                                    , CodeandModifiers VARCHAR(100)
                                    , BillingCodeName VARCHAR(250)
                                    , ClientIdText VARCHAR(100)
                                    , SiteIdText VARCHAR(MAX)
									, CoveragePlanIdText VARCHAR(MAX)
									, LicenseTypeIdText  VARCHAR(MAX)
									, PlaceOfServiceIdText  VARCHAR(MAX)
									, LicenseTypeGroupName   VARCHAR(250)
									, PlaceOfServiceGroupName  VARCHAR(250) 
                                    , ContractRate1 VARCHAR(100)
                                    , BillingCodeModifierId VARCHAR(100)
                                    , StartDate1 DATE
                                    , EndDate1 DATE)

		--,EffectiveAs Date  
		--GET CUSTOM FILTERS             
            IF @OtherFilter > 10000
                BEGIN
                    SET @CustomFiltersApplied = 'Y'

                    IF EXISTS ( SELECT *
                                    FROM sys.objects
                                    WHERE object_id = OBJECT_ID(N'[dbo].[scsp_ListPageCMProviderSpecificContract]')
                                        AND type IN ( N'P', N'PC' ) )
                        BEGIN
                            INSERT INTO #CustomFilters
                                    ( DocumentId )
                                    EXEC scsp_ListPageCMProviderSpecificContract @SiteId = @SiteId,@CoveragePlanId=@CoveragePlanId, @ClientId = @ClientId, @ContractDate = @ContractDate, @ContractEndDate = @ContractEndDate, @InsurerId = @InsurerId, @ContractId = @ContractId, @SortExpression = @SortExpression, @ProviderId = @ProviderId
                       
					    END
                END

            INSERT INTO #ResultSet
                    ( ContractRateId
                    ,ContractId
                    ,BillingCodeId
                    ,Modifier1
                    ,Modifier2
                    ,Modifier3
                    ,Modifier4
                    ,SiteId
					,CoveragePlanId
                    ,ClientId
                    ,StartDate
                    ,EndDate
                    ,ContractRate
                    ,Active
                    ,RequiresAffilatedProvider
                    ,AllAffiliatedProviders
                    ,RateUnit
                    ,CodeandModifiers
                    ,BillingCodeName
                    ,ClientIdText
                    ,SiteIdText
					,CoveragePlanIdText
					,LicenseTypeIdText
					,PlaceOfServiceIdText
					,LicenseTypeGroupName
					,PlaceOfServiceGroupName
                    ,ContractRate1
                    ,BillingCodeModifierId
                    ,StartDate1
                    ,EndDate1
            --,EffectiveAs
                     )
                    SELECT DISTINCT CR.ContractRateId
                        ,   CR.ContractId
                        ,   CR.BillingCodeId
                        ,   CR.Modifier1
                        ,   CR.Modifier2
                        ,   CR.Modifier3
                        ,   CR.Modifier4
                        ,   CR.SiteId
						,   NULL
                        ,   CR.ClientId
                        ,   CR.StartDate
                        ,   CR.EndDate
                        ,   CR.ContractRate
                        ,   CR.Active
                        ,   CR.RequiresAffilatedProvider
                        ,   CR.AllAffiliatedProviders
                        ,   CAST(BC.Units AS CHAR(18)) + GC.CodeName AS RateUnit
                        ,   LTRIM(RTRIM(BC.BillingCode)) + CASE WHEN LEN(ISNULL(LTRIM(RTRIM(ISNULL(CR.[Modifier1], ' '))), ' ') + ISNULL(LTRIM(RTRIM(ISNULL(CR.[Modifier2], ' '))), ' ') + ISNULL(LTRIM(RTRIM(ISNULL(CR.[Modifier3], ' '))), ' ') + ISNULL(LTRIM(RTRIM(ISNULL(CR.[Modifier4], ' '))), ' ')) = 0 THEN ''
                                                                ELSE ':'
                                                           END + CASE WHEN ISNULL(LTRIM(RTRIM(ISNULL(CR.[Modifier1], ''))), '') = '' THEN ' '
                                                                      ELSE LTRIM(RTRIM(ISNULL(CR.[Modifier1], ' '))) + ':'
                                                                 END + CASE WHEN ISNULL(LTRIM(RTRIM(ISNULL(CR.[Modifier2], ''))), '') = '' THEN ' '
                                                                            ELSE LTRIM(RTRIM(ISNULL(CR.[Modifier2], ''))) + ':'
                                                                       END + CASE WHEN ISNULL(LTRIM(RTRIM(ISNULL(CR.[Modifier3], ''))), '') = '' THEN ' '
                                                                                  ELSE LTRIM(RTRIM(ISNULL(CR.[Modifier3], ''))) + ':'
                                                                             END + CASE WHEN ISNULL(LTRIM(RTRIM(ISNULL(CR.[Modifier4], ''))), '') = '' THEN ' '
                                                                                        ELSE LTRIM(RTRIM(ISNULL(CR.[Modifier4], '')))
                                                                                   END AS CodeandModifiers
                        ,   Ltrim(RTrim(Isnull(BC.Codename,''))) AS BillingCodeName --Neethu 16-feb-2018
                        ,   c.LastName + ', ' + c.FirstName AS ClientIdText
			--,REPLACE((
			--		SELECT S.SiteName AS 'data()'
			--		FROM Sites S
			--		INNER JOIN ContractRateSites CRS ON S.SiteId = CRS.SiteId
			--			AND CRS.ContractRateId = CR.ContractRateId
			--		WHERE --(  
			--			--     @SiteId = -1 OR CRS.SiteId = @SiteId  
			--			--  )  
			--			-- AND   
			--			ISNULL(S.RecordDeleted, 'N') = 'N'
			--			AND ISNULL(CRS.RecordDeleted, 'N') = 'N'
			--		FOR XML path('')
			--		), ' ', ', ')
                        ,   ( SELECT STUFF((SELECT ', ' + S.SiteName
                                                FROM Sites S
                                                    INNER JOIN ContractRateSites CRS ON S.SiteId = CRS.SiteId
                                                WHERE ISNULL(S.RecordDeleted, 'N') = 'N'
                                                    AND CRS.ContractRateId = CR.ContractRateId
                                                    AND ISNULL(CRS.RecordDeleted, 'N') = 'N'
                                    FOR    XML PATH('')
                                           ,   TYPE).value('.[1]', 'nvarchar(max)'), 1, 2, '') ) AS SiteIdText
										   ,( SELECT STUFF((SELECT ', ' + CP.CoveragePlanName
                                                FROM dbo.CoveragePlans CP
                                                    INNER JOIN ContractRateCoveragePlans CRCP ON CP.CoveragePlanId = CRCP.CoveragePlanId
                                                WHERE ISNULL(CP.RecordDeleted, 'N') = 'N'
                                                    AND CRCP.ContractRateId = CR.ContractRateId
                                                    AND ISNULL(CRCP.RecordDeleted, 'N') = 'N'
                                    FOR    XML PATH('')
                                           ,   TYPE).value('.[1]', 'nvarchar(max)'), 1, 2, '') ) AS CoveragePlanIdText
                          --Added By Vijay                 
                          ,(SELECT STUFF((SELECT ', ' + GC.CodeName
                                    FROM GlobalCodes GC
                                        INNER JOIN ContractRateLicenseTypes CRLT ON GC.GlobalCodeId = CRLT.LicenseTypeId
                                    WHERE ISNULL(CRLT.RecordDeleted, 'N') = 'N'
                                        AND CRLT.ContractRateId = CR.ContractRateId
                                        AND ISNULL(GC.RecordDeleted, 'N') = 'N'
                                    FOR    XML PATH('')
                                    ,   TYPE).value('.[1]', 'nvarchar(max)'), 1, 2, '') ) as LicenseTypeIdText
						  
						  ,(SELECT STUFF((SELECT ', ' + GC.CodeName
                                    FROM GlobalCodes GC
                                        INNER JOIN ContractRatePlaceOfServices CRPS ON GC.GlobalCodeId = CRPS.PlaceOfServiceId
                                    WHERE ISNULL(CRPS.RecordDeleted, 'N') = 'N'
                                        AND CRPS.ContractRateId = CR.ContractRateId
                                        AND ISNULL(GC.RecordDeleted, 'N') = 'N'
                                    FOR    XML PATH('')
                                    ,   TYPE).value('.[1]', 'nvarchar(max)'), 1, 2, '') ) as PlaceOfServiceIdText
							             
                        ,	CR.LicenseTypeGroupName
						,	CR.PlaceOfServiceGroupName                 
                                           
                                           
                        ,   '$' + CONVERT(VARCHAR, CAST(CR.ContractRate AS MONEY), 10) AS ContractRate1
                        ,   CONVERT(VARCHAR, BM.BillingCodeId) + '_' + CONVERT(VARCHAR, BM.BillingCodeModifierId) AS BillingCodeModifierId
                        ,   CONVERT(CHAR(10), CR.StartDate, 101) AS StartDate1
                        ,   CONVERT(CHAR(10), CR.EndDate, 101) AS EndDate1
		--,convert(CHAR(10), CR.EffectiveAs, 101) AS EffectiveAs  
                        FROM ContractRates CR
							LEFT JOIN Clients c ON CR.ClientId = c.ClientId
                            LEFT JOIN ContractRateSites CRS ON CRS.ContractRateId = CR.ContractRateId  AND ISNULL(CRS.RecordDeleted, 'N') = 'N'
                            LEFT JOIN Sites S ON S.SiteId = CRS.SiteId
                                                 AND ( ISNULL(S.RecordDeleted, 'N') = 'N' )
							LEFT JOIN  dbo.ContractRateCoveragePlans CRCP ON CRCP.ContractRateId = CR.ContractRateId AND ISNULL(CRCP.RecordDeleted,'N')='N'
							LEFT JOIN dbo.CoveragePlans cp ON cp.CoveragePlanId=CRCP.CoveragePlanId AND (ISNULL(cp.RecordDeleted,'N')='N')
                            LEFT JOIN BillingCodes BC ON BC.BillingCodeId = CR.BillingCodeId
                            LEFT JOIN BillingCodeModifiers BM ON BC.BillingCodeId = BM.BillingCodeId
                                                                 AND ( ISNULL(BM.RecordDeleted, 'N') = 'N' )
                                                                 AND
                                                                 (---Added by PradeepT,22 Feb 2018
	                                                              ISNULL(bm.Modifier1, '') = ISNULL(cr.Modifier1, '')
                                                                  AND ISNULL(bm.Modifier2, '') = ISNULL(cr.Modifier2, '')
                                                                  AND ISNULL(bm.Modifier3, '') = ISNULL(cr.Modifier3, '')
                                                                  AND ISNULL(bm.Modifier4, '') = ISNULL(cr.Modifier4, '')
                                                                 
                                                               )     
                            LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = BC.UnitType
							
                        WHERE ( ISNULL(CR.RecordDeleted, 'N') = 'N' )
                            AND CR.ContractId = @ContractId
                            AND ( ISNULL(GC.RecordDeleted, 'N') = 'N' )
                            AND ( @SiteId = -1
                                  OR CRS.SiteId = @SiteId )
						  AND (@CoveragePlanId=-1
								  OR CRCP.CoveragePlanId=@CoveragePlanId
								  )
						  AND (@BillingCodeId=-1
								  OR CR.BillingCodeId=@BillingCodeId
								  )	
						  AND (@BillingCodeModifierId=-1
								  OR BM.BillingCodeModifierId=@BillingCodeModifierId
								  )								  							  
                            --- jwheeler moved up to the left join AND ( ISNULL(CRS.RecordDeleted, 'N') = 'N' )
                            AND ( @ClientId = -1
                                  OR CR.ClientId = @ClientId )
                            AND ( ISNULL(@ContractDate, -1) = -1
                                  OR CR.StartDate = @ContractDate )
                            AND ( ISNULL(@ContractEndDate, -1) = -1
                                  OR CR.EndDate = @ContractEndDate )
			--	Shruthi.S  Uncommented effective date condition which was commented out.   
                            AND ( ISNULL(@EffectiveDate, -1) = -1
                                  OR CAST(CR.StartDate AS DATETIME) >= CAST(@EffectiveDate AS DATETIME) );

            WITH    counts
                      AS ( SELECT COUNT(*) AS TotalRows
                            FROM #ResultSet),
                    RankResultSet
                      AS ( SELECT ContractRateId
                            ,   ContractId
                            ,   BillingCodeId
                            ,   Modifier1
                            ,   Modifier2
                            ,   Modifier3
                            ,   Modifier4
                            ,   SiteId
						--	,CoveragePlanId
                            ,   ClientId
                            ,   StartDate
                            ,   EndDate
                            ,   ContractRate
                            ,   Active
                            ,   RequiresAffilatedProvider
                            ,   AllAffiliatedProviders
                            ,   RateUnit
                            ,   CodeandModifiers
                            ,   BillingCodeName
                            ,   ClientIdText
                            ,   SiteIdText
							,   CoveragePlanIdText
							,	LicenseTypeIdText
						    ,	PlaceOfServiceIdText 
						    ,	LicenseTypeGroupName
							,	PlaceOfServiceGroupName 
                            ,   ContractRate1
                            ,   BillingCodeModifierId
                            ,   StartDate1
                            ,   EndDate1
				--,EffectiveAs  
                            ,   COUNT(*) OVER ( ) AS TotalCount
                            ,   RANK() OVER ( ORDER BY CASE WHEN @SortExpression = 'ContractRateId' THEN ContractRateId
                                                       END
						, CASE WHEN @SortExpression = 'ContractRateId desc' THEN ContractRateId
                                END DESC
						, CASE WHEN @SortExpression = 'CodeandModifiers' THEN CodeandModifiers
                                END
						, CASE WHEN @SortExpression = 'CodeandModifiers desc' THEN CodeandModifiers
                                END DESC
						, CASE WHEN @SortExpression = 'BillingCodeName' THEN BillingCodeName
                                END
						, CASE WHEN @SortExpression = 'BillingCodeName desc' THEN BillingCodeName
                                END DESC
						, CASE WHEN @SortExpression = 'RateUnit' THEN RateUnit
                                END
						, CASE WHEN @SortExpression = 'RateUnit desc' THEN RateUnit
                                END DESC
						, CASE WHEN @SortExpression = 'ContractRate1' THEN ContractRate1
                                END
						, CASE WHEN @SortExpression = 'ContractRate1 desc' THEN ContractRate1
                                END DESC
						, CASE WHEN @SortExpression = 'SiteIdText' THEN SiteIdText
                                END
						, CASE WHEN @SortExpression = 'SiteIdText desc' THEN SiteIdText
                                END DESC
							, CASE WHEN @SortExpression = 'CoveragePlanIdText' THEN CoveragePlanIdText
                                END
						, CASE WHEN @SortExpression = 'CoveragePlanIdText desc' THEN CoveragePlanIdText
                                END DESC
                        , CASE WHEN @SortExpression = 'LicenseTypeIdText' THEN LicenseTypeIdText
                                END
						, CASE WHEN @SortExpression = 'LicenseTypeIdText desc' THEN LicenseTypeIdText
                                END DESC
                        , CASE WHEN @SortExpression = 'PlaceOfServiceIdText' THEN PlaceOfServiceIdText
                                END
						, CASE WHEN @SortExpression = 'PlaceOfServiceIdText desc' THEN PlaceOfServiceIdText
                                END DESC
                        , CASE WHEN @SortExpression = 'LicenseTypeGroupName' THEN LicenseTypeGroupName
                                END
						, CASE WHEN @SortExpression = 'LicenseTypeGroupName desc' THEN LicenseTypeGroupName
                                END DESC
                        , CASE WHEN @SortExpression = 'PlaceOfServiceGroupName' THEN PlaceOfServiceGroupName
                                END
						, CASE WHEN @SortExpression = 'PlaceOfServiceGroupName desc' THEN PlaceOfServiceGroupName
                                END DESC
						, CASE WHEN @SortExpression = 'ClientIdText desc' THEN ClientIdText
                                END DESC
						, CASE WHEN @SortExpression = 'ClientIdText' THEN ClientIdText
                                END
						, CASE WHEN @SortExpression = 'StartDate desc' THEN StartDate
                                END DESC
						, CASE WHEN @SortExpression = 'StartDate' THEN StartDate
                                END
						, CASE WHEN @SortExpression = 'EndDate desc' THEN EndDate
                                END DESC
						, CASE WHEN @SortExpression = 'EndDate' THEN EndDate
                                END
						, CASE WHEN @SortExpression = 'RequiresAffilatedProvider desc' THEN RequiresAffilatedProvider
                                END DESC
						, CASE WHEN @SortExpression = 'RequiresAffilatedProvider' THEN RequiresAffilatedProvider
                                END, ContractRateId ) AS RowNumber
						
                            FROM #ResultSet)
                SELECT TOP ( CASE WHEN ( @PageNumber = -1 ) THEN ( SELECT ISNULL(TotalRows, 0)
                                                                    FROM counts )
                                  ELSE ( @PageSize )
                             END ) ContractRateId
                    ,   ContractId
                    ,   BillingCodeId
                    ,   Modifier1
                    ,   Modifier2
                    ,   Modifier3
                    ,   Modifier4
                    ,   SiteId
				--	,CoveragePlanId
                    ,   ClientId
                    ,   StartDate
                    ,   EndDate
                    ,   ContractRate
                    ,   Active
                    ,   RequiresAffilatedProvider
                    ,   AllAffiliatedProviders
                    ,   RateUnit
                    ,   CodeandModifiers
                    ,   BillingCodeName
                    ,   ClientIdText
                    ,   SiteIdText
					,  CoveragePlanIdText 
					,	LicenseTypeIdText
					,	PlaceOfServiceIdText 
					,	LicenseTypeGroupName
					,	PlaceOfServiceGroupName 
                    ,   ContractRate1
                    ,   BillingCodeModifierId
                    ,   StartDate1
                    ,   EndDate1
			--,EffectiveAs  
                    ,   TotalCount
                    ,   RowNumber
					--,RankResultSet.LicenseAndDegreeGroupName
                    INTO #FinalResultSet
                    FROM RankResultSet
                    WHERE RowNumber > ( ( @PageNumber - 1 ) * @PageSize )

            IF ( SELECT ISNULL(COUNT(*), 0)
                    FROM #FinalResultSet ) < 1
                BEGIN
                    SELECT 0 AS PageNumber
                        ,   0 AS NumberOfPages
                        ,   0 NumberOfRows
                END
            ELSE
                BEGIN
                    SELECT TOP 1 @PageNumber AS PageNumber
                        ,   CASE ( TotalCount % @PageSize )
                              WHEN 0 THEN ISNULL(( TotalCount / @PageSize ), 0)
                              ELSE ISNULL(( TotalCount / @PageSize ), 0) + 1
                            END NumberOfPages
                        ,   ISNULL(TotalCount, 0) AS NumberOfRows
                        FROM #FinalResultSet
                END

            SELECT ContractRateId
                ,   ContractId
                ,   BillingCodeId
                ,   Modifier1
                ,   Modifier2
                ,   Modifier3
                ,   Modifier4
                ,  SiteId
				--, CoveragePlanId
                ,   ClientId
                ,   CONVERT(VARCHAR, StartDate, 101) AS StartDate
                ,   CONVERT(VARCHAR, EndDate, 101) AS EndDate
                ,   ContractRate
                ,   Active
                ,   ( CASE WHEN RequiresAffilatedProvider = 'N' THEN 'No'
                           ELSE 'Yes'
                      END ) AS RequiresAffilatedProvider
                ,   AllAffiliatedProviders
                ,   RateUnit
                ,   CodeandModifiers
                ,   BillingCodeName
                ,   ClientIdText
                ,   SiteIdText
				,   CoveragePlanIdText
				,	LicenseTypeIdText
				,	PlaceOfServiceIdText
				,	LicenseTypeGroupName
				,	PlaceOfServiceGroupName
                ,   ContractRate1
                ,   BillingCodeModifierId
                ,   CONVERT(VARCHAR, StartDate1, 101) AS StartDate1
                ,   CONVERT(VARCHAR, EndDate1, 101) AS EndDate1
		--,convert(VARCHAR, EffectiveAs, 101) AS EffectiveAs    
                FROM #FinalResultSet
                ORDER BY RowNumber
        END TRY

        BEGIN CATCH
            DECLARE @Error VARCHAR(8000)

            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_ListPageCMProviderRatesSpecificContract') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

            RAISERROR (
				@Error
				,
				-- Message text.                                              
				16
				,-- Severity.                                              
				1 -- State.                                              
				);
        END CATCH
    END
GO
