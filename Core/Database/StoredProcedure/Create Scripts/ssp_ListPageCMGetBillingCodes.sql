/****** Object:  StoredProcedure [dbo].[ssp_ListPageCMGetBillingCodes]    Script Date: 06/03/2014 11:56:55 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageCMGetBillingCodes]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_ListPageCMGetBillingCodes]
GO

/****** Object:  StoredProcedure [dbo].[ssp_ListPageCMGetBillingCodes]    Script Date: 06/03/2014 11:56:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_ListPageCMGetBillingCodes] @PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@InsurerId INT
	,@ProviderId INT
	,@SiteId INT
	,@ClientId INT
	,@EffectiveFrom DATETIME
	,@OtherFilter INT
	,@CodeName VARCHAR(100)
	,@Active VARCHAR(2)
AS
/************************************************************************************************                                      
  -- Stored Procedure: dbo.ssp_ListPageCMGetBillingCodes              
  -- Copyright: Streamline Healthcate Solutions              
  -- Purpose: Used by Clients list page              
  -- Updates:              
  -- Date        Author            Purpose              
  -- 04.03.2014  Vichee Humane     Created
  -- 22.Aug.2014 Rohith Uppin		Sorting Parameter modified. Task#56 Cm to SC.
  -- 10.Nov.2014 Rohith Uppin		Active parameter added to filter the result. Task#126 CM to SC Issue tracking.
  -- 26.Dec.2014 Vichee Humane      Modified AllInsurer column to check 'Y' and NULL as well. CareManagemet to SC Env Issues Tracking #277 
  -- 2.Feb.2015  SuryaBalan			Added condition for after saving insurer in Standard Rules tab, its not displaying in list page. CareManagemet to SC Env Issues Tracking #396
  -- 21.10.2015  SuryaBalan			Added join with ContractRateSites, since we are not going use SiteId of COntractRates table, as per task #618 N180 Customizations
--									Before it was Single selection of Sites in COntract Rates Detail Page, now it is multiple selection, 
									so whereever we are using ContractRates-SiteId, we need to join with ContractRateSites-SiteId
--   23.11.2015  Venkatesh			Removed one unwanted Code to avoid the duplicates in list page. - Ref - Valley Support Go Live - 78
--   22.11.2016  Gautam             change the join from Left to Inner with table InsurerRates to remove the duplicate in list page, SWMBH - Support > Tasks#1108
--   05.06.2017  Chita Ranjan       Removed filter 'AllInsurers='Y'' as Billing Codes were not displaying in the list page after adding new record.
--   30.01.2019  Arun K R           Added billingcodemodifiers startdate,enddate and active columns to list. Task #900.77 KCMHSAS - Enhancements.
  *************************************************************************************************/
BEGIN
	BEGIN TRY
		SET NOCOUNT ON;

		--DECLATE TABLE TO GET DATA IF OTHER FILTER EXISTS -------                   
		DECLARE @CustomFiltersApplied CHAR(1)

		CREATE TABLE #CustomFilters (BillingCodeID INT)

		--DECLARE @EventType INT        
		DECLARE @str NVARCHAR(4000)

		-- Set @Active for default value.
		IF @Active IS NULL
			SET @Active = '-1'
		--DECLARE @HospitalizeStatus INT        
		SET @CustomFiltersApplied = 'N'

		--SET @HospitalizeStatus = 2181        
		CREATE TABLE #BillingCodestemp (
			[CheckBox] [VARCHAR](1)
			,[BillingCodeId] [int]
			,[Code] [VARCHAR](20)
			,[Name] [VARCHAR](100)
			,[Rate Unit] [VARCHAR](271)
			,[Payable Rate] [money]
			,[Medicaid Code] [VARCHAR](25)
			,[Modifier 1] [VARCHAR](10)
			,[Modifier 2] [VARCHAR](10)
			,[Modifier 3] [VARCHAR](10)
			,[Modifier 4] [VARCHAR](10)
			,[StartDate] [datetime]
			,[EndDate] [datetime]
			,[IsInsurer] [VARCHAR](1)
			,[InsurerRateId] [int]
			,[BillingCodeRateId] [int]
			,[Active] [char](1)
			,[NewRate] [decimal](18, 0)
			,[NewDate] [datetime]
			,[Button EndDate] [VARCHAR](1)
			,[InsurerId] [int]
			,[BCMStartDate] [datetime] --30.01.2019  Arun K R 
			,[BCMEndDate] [datetime]
			,[BCMActive] [char](1)
			,[BCMBillingCodeModifierId] [int]
			)

		--GET CUSTOM FILTERS                   
		IF @OtherFilter > 10000
		BEGIN
			SET @CustomFiltersApplied = 'Y'

			INSERT INTO #CustomFilters (BillingCodeID)
			EXEC scsp_ListPageCMGetBillingCodes @SortExpression
				,@InsurerId
				,@ProviderId
				,@SiteId
				,@ClientId
				,@EffectiveFrom
				,@OtherFilter
		END

		--INSERT DATE INTO TEMP TABLE WHICH IS FETCHED BELOW BY APPLYING FILTER.                
		IF @CustomFiltersApplied = 'N'
		BEGIN
			IF (
					@InsurerId <= 0
					AND @ProviderId <= 0
					AND @SiteId <= 0
					AND @ClientId <= 0
					) --First condition        
			BEGIN
				--Insert Records from below select Query     
				INSERT INTO #BillingCodestemp
				-- Get BillingCodes with BillingCodeRates   
				SELECT '0' AS 'CheckBox'
					,bc.BillingCodeId
					,bc.BillingCode AS 'Code'
					,bc.CodeName AS 'Name'
					,Convert(VARCHAR(100), convert(BIGINT, bc.Units)) + ' ' + gc.CodeName AS 'Rate Unit'
					,BCR.Rate AS 'Payable Rate'
					,'' AS 'Medicaid Code'
					,BCR.Modifier1 AS 'Modifier 1'
					,BCR.Modifier2 AS 'Modifier 2'
					,BCR.Modifier3 AS 'Modifier 3'
					,BCR.Modifier4 AS 'Modifier 4'
					,BCR.EffectiveFrom AS 'StartDate'
					,BCR.EffectiveTo AS 'EndDate'
					,'N' AS 'IsInsurer'
					,0 AS InsurerRateId
					,BCR.BillingCodeRateId
					,bc.Active
					,Cast(NULL AS DECIMAL) AS NewRate
					,cast(NULL AS DATETIME) AS NewDate
					,'0' AS 'Button EndDate'
					,0 AS InsurerId
					,BCM.StartDate AS BCMStartDate --30.01.2019  Arun K R 
					,BCM.EndDate AS BCMEndDate
					,BCM.Active AS BCMActive
					,BCM.BillingCodeModifierId
				FROM BillingCodes bc
				INNER JOIN BillingCodeRates BCR ON BC.BillingCodeId = BCR.BillingCodeId
					AND Convert(DATETIME, BCR.EffectiveFrom, 101) <= convert(DATETIME, @EffectiveFrom, 101)
					AND (
						Convert(DATETIME, BCR.EffectiveTo, 101) >= Convert(DATETIME, @EffectiveFrom, 101)
						OR Convert(DATETIME, BCR.EffectiveTo, 101) IS NULL
						)
					AND IsNull(bc.RecordDeleted, 'N') = 'N'
					AND IsNull(BCR.RecordDeleted, 'N') = 'N'
				INNER JOIN GlobalCodes AS gc ON gc.GlobalCodeId = bc.UnitType
					AND IsNull(gc.RecordDeleted, 'N') = 'N'
				LEFT JOIN BillingCodeModifiers BCM ON BCM.BillingCodeId=BC.BillingCodeId AND ISNULL(BCM.RecordDeleted,'N')='N'
				WHERE  ---IsNull(bc.AllInsurers, 'Y') = 'Y' and  --05.06.2017 Chita Ranjan
						bc.CodeName LIKE '%' + @CodeName + '%'
					AND (
						@Active = '-1'
						OR bc.Active = @Active
						)
				
				UNION
				
				-- (Get BillingCodes with null Payable Rate)           
				SELECT '0' AS 'CheckBox'
					,bc.BillingCodeId
					,bc.BillingCode AS 'Code'
					,bc.CodeName AS 'Name'
					,Convert(VARCHAR(100), convert(BIGINT, bc.Units)) + ' ' + gc.CodeName AS 'Rate Unit'
					,NULL AS 'Payable Rate'
					,'' AS 'Medicaid Code'
					,'' AS 'Modifier 1'
					,'' AS 'Modifier 2'
					,'' AS 'Modifier 3'
					,'' AS 'Modifier 4'
					,NULL AS 'StartDate'
					,NULL AS 'EndDate'
					,'N' AS 'IsInsurer'
					,0 AS InsurerRateId
					,0 AS BillingCodeRateId
					,bc.Active
					,Cast(NULL AS DECIMAL) AS NewRate
					,cast(NULL AS DATETIME) AS NewDate
					,'0' AS 'Button EndDate'
					,0 AS InsurerId
					,BCM.StartDate AS BCMStartDate --30.01.2019  Arun K R 
					,BCM.EndDate AS BCMEndDate
					,BCM.Active AS BCMActive
					,BCM.BillingCodeModifierId
				--,bc.Units,bc.UnitType,bc.ReportingUnits,bc.ReportingUnitType --3/8/2006           
				FROM BillingCodes bc
				INNER JOIN GlobalCodes AS gc ON gc.GlobalCodeId = bc.UnitType
					AND IsNull(gc.RecordDeleted, 'N') = 'N'
					AND (
						BC.BillingCodeId NOT IN (
							SELECT BillingCodeId
							FROM BillingCodeRates
							WHERE IsNull(RecordDeleted, 'N') = 'N'
								AND bc.CodeName LIKE '%' + @CodeName + '%'
							
							UNION
							
							SELECT BillingcodeId
							FROM InsurerRates
							WHERE IsNull(RecordDeleted, 'N') = 'N'
							)
						AND IsNull(bc.RecordDeleted, 'N') = 'N'
						)
					--and ALLInsurers = 'Y' 
					--AND IsNull(bc.AllInsurers, 'Y') = 'Y' --05.06.2017 Chita Ranjan
				LEFT JOIN BillingCodeModifiers BCM ON BCM.BillingCodeId=BC.BillingCodeId AND ISNULL(BCM.RecordDeleted,'N')='N'
				WHERE bc.CodeName LIKE '%' + @CodeName + '%'
					AND (
						@Active = '-1'
						OR bc.Active = @Active
						)
				
				UNION
				
				-- (Get BillingCodes having InsurerRates only and not having Standard Rates, but we need to display only BillingCode with Payablerate as null)          
				SELECT '0' AS 'CheckBox'
					,bc.BillingCodeId
					,bc.BillingCode AS 'Code'
					,bc.CodeName AS 'Name'
					,Convert(VARCHAR(100), convert(BIGINT, bc.Units)) + ' ' + gc.CodeName AS 'Rate Unit'
					,NULL AS 'Payable Rate'
					,'' AS 'Medicaid Code'
					,'' AS 'Modifier 1'
					,'' AS 'Modifier 2'
					,'' AS 'Modifier 3'
					,'' AS 'Modifier 4'
					,NULL AS 'StartDate'
					,NULL AS 'EndDate'
					,'N' AS 'IsInsurer'
					,0 AS InsurerRateId
					,0 AS BillingCodeRateId
					,bc.Active
					,Cast(NULL AS DECIMAL) AS NewRate
					,cast(NULL AS DATETIME) AS NewDate
					,'0' AS 'Button EndDate'
					,0 AS InsurerId
					,BCM.StartDate AS BCMStartDate --30.01.2019  Arun K R 
					,BCM.EndDate AS BCMEndDate
					,BCM.Active AS BCMActive
					,BCM.BillingCodeModifierId
				--,bc.Units,bc.UnitType,bc.ReportingUnits,bc.ReportingUnitType --3/8/2006           
				FROM BillingCodes bc
				INNER JOIN GlobalCodes AS gc ON gc.GlobalCodeId = bc.UnitType
					AND IsNull(gc.RecordDeleted, 'N') = 'N'
					AND (
						BC.BillingCodeId NOT IN (
							SELECT BillingCodeId
							FROM BillingCodeRates AS BCR
							WHERE IsNull(RecordDeleted, 'N') = 'N'
								AND Convert(DATETIME, BCR.EffectiveFrom, 101) <= Convert(DATETIME, @EffectiveFrom, 101)
								AND (
									Convert(DATETIME, BCR.EffectiveTo, 101) >= Convert(DATETIME, @EffectiveFrom, 101)
									OR Convert(DATETIME, BCR.EffectiveTo, 101) IS NULL
									)
							)
						AND IsNull(bc.RecordDeleted, 'N') = 'N'
						)
					--and ALLInsurers = 'Y' 
					--AND IsNull(bc.AllInsurers, 'Y') = 'Y' --05.06.2017 Chita Ranjan
				LEFT JOIN BillingCodeModifiers BCM ON BCM.BillingCodeId=BC.BillingCodeId AND ISNULL(BCM.RecordDeleted,'N')='N'
				WHERE bc.CodeName LIKE '%' + @CodeName + '%'
					AND (
						@Active = '-1'
						OR bc.Active = @Active
						)
				
				UNION
				
				SELECT '0' AS 'CheckBox'
					,bc.BillingCodeId
					,bc.BillingCode AS 'Code'
					,bc.CodeName AS 'Name'
					,Convert(VARCHAR(20), convert(INT, bc.Units)) + ' ' + gc.CodeName AS 'Rate Unit'
					,IR.Rate AS 'Payable Rate'
					,'' AS 'Medicaid Code'
					,IR.Modifier1 AS 'Modifier 1'
					,IR.Modifier2 AS 'Modifier 2'
					,IR.Modifier3 AS 'Modifier 3'
					,IR.Modifier4 AS 'Modifier 4'
					,IR.EffectiveFrom AS 'StartDate'
					,IR.EffectiveTo AS 'EndDate'
					,'Y' AS 'IsInsurer'
					,IR.InsurerRateId
					,0 AS BillingCodeRateId
					,bc.Active
					,Cast(NULL AS DECIMAL) AS NewRate
					,cast(NULL AS DATETIME) AS NewDate
					,'0' AS 'Button EndDate'
					,IR.InsurerId
					,BCM.StartDate AS BCMStartDate --30.01.2019  Arun K R 
					,BCM.EndDate AS BCMEndDate
					,BCM.Active AS BCMActive
					,BCM.BillingCodeModifierId
				FROM BillingCodes BC
				INNER JOIN GlobalCodes AS gc ON gc.GlobalCodeId = bc.UnitType
					AND IsNull(gc.RecordDeleted, 'N') = 'N'
				INNER JOIN InsurerRates IR ON BC.BillingCodeId = IR.BillingCodeId  --   22.11.2016  Gautam 
					AND Convert(DATETIME, IR.EffectiveFrom, 101) <= Convert(DATETIME, @EffectiveFrom, 101)
					AND (
						Convert(DATETIME, IR.EffectiveTo, 101) >= Convert(DATETIME, @EffectiveFrom, 101)
						OR Convert(DATETIME, IR.EffectiveTo, 101) IS NULL
						)
					AND (
						IR.Rate IS NOT NULL
						OR IR.Rate != 0
						)
					AND IsNull(IR.RecordDeleted, 'N') = 'N'
				LEFT JOIN BillingCodeModifiers BCM ON BCM.BillingCodeId=BC.BillingCodeId AND ISNULL(BCM.RecordDeleted,'N')='N'
				WHERE BC.BillingCodeId IN (
						--Commented by Venkatesh for task 78 in Valley Go Live Support
						--Select BillingCodeId   from   BillingCodes as bc  where 
						--                      IsNull(bc.RecordDeleted, 'N') = 'N' 
						--                     --Where AllInsurers='Y'  
						--                     and IsNull(bc.AllInsurers, 'Y') = 'Y'
						--                     and bc.CodeName like '%' +   @CodeName +    '%' 
						--   union  
						SELECT bcv.BillingCodeId
						FROM BillingCodeValidInsurers AS bcv
						WHERE bcv.BillingCodeId = BC.BillingCodeId
							AND IsNull(bcv.RecordDeleted, 'N') = 'N'
						)
					--4/12/2006   
					AND (@InsurerId = - 1  --   22.11.2016  Gautam 
						)
					AND IsNull(bc.RecordDeleted, 'N') = 'N'
					AND bc.CodeName LIKE '%' + @CodeName + '%'
					AND (
						@Active = '-1'
						OR bc.Active = @Active
						) --and or @InsurerId = -1
			END

			IF (
					@InsurerId > 0
					AND @ProviderId <= 0
					AND @SiteId <= 0
					AND @ClientId <= 0
					) --2nd condition             
			BEGIN
				--Insert Records from below select Query             
				INSERT INTO #BillingCodestemp
				--(get InsurerRates  corresponding to that Insurer)           
				SELECT '0' AS 'CheckBox'
					,bc.BillingCodeId
					,bc.BillingCode AS 'Code'
					,bc.CodeName AS 'Name'
					,Convert(VARCHAR(20), convert(INT, bc.Units)) + ' ' + gc.CodeName AS 'Rate Unit'
					,IR.Rate AS 'Payable Rate'
					,'' AS 'Medicaid Code'
					,IR.Modifier1 AS 'Modifier 1'
					,IR.Modifier2 AS 'Modifier 2'
					,IR.Modifier3 AS 'Modifier 3'
					,IR.Modifier4 AS 'Modifier 4'
					,IR.EffectiveFrom AS 'StartDate'
					,IR.EffectiveTo AS 'EndDate'
					,'Y' AS 'IsInsurer'
					,IR.InsurerRateId
					,0 AS BillingCodeRateId
					,bc.Active
					,Cast(NULL AS DECIMAL) AS NewRate
					,cast(NULL AS DATETIME) AS NewDate
					,'0' AS 'Button EndDate'
					,IR.InsurerId
					,BCM.StartDate AS BCMStartDate --30.01.2019  Arun K R 
					,BCM.EndDate AS BCMEndDate
					,BCM.Active AS BCMActive
					,BCM.BillingCodeModifierId
				FROM BillingCodes BC
				INNER JOIN GlobalCodes AS gc ON gc.GlobalCodeId = bc.UnitType
					AND IsNull(gc.RecordDeleted, 'N') = 'N'
				INNER JOIN InsurerRates IR ON BC.BillingCodeId = IR.BillingCodeId
					AND Convert(DATETIME, IR.EffectiveFrom, 101) <= Convert(DATETIME, @EffectiveFrom, 101)
					AND (
						Convert(DATETIME, IR.EffectiveTo, 101) >= Convert(DATETIME, @EffectiveFrom, 101)
						OR Convert(DATETIME, IR.EffectiveTo, 101) IS NULL
						)
					AND (
						IR.Rate IS NOT NULL
						OR IR.Rate != 0
						)
					AND IsNull(IR.RecordDeleted, 'N') = 'N'
				LEFT JOIN BillingCodeModifiers BCM ON BCM.BillingCodeId=BC.BillingCodeId AND ISNULL(BCM.RecordDeleted,'N')='N'
				WHERE BC.BillingCodeId IN (
						SELECT BillingCodeId
						FROM BillingCodes AS bc
						WHERE IsNull(bc.RecordDeleted, 'N') = 'N'
							--Where AllInsurers='Y'  
							AND IsNull(bc.AllInsurers, 'Y') = 'Y'
							AND bc.CodeName LIKE '%' + @CodeName + '%'
						
						UNION
						
						SELECT BillingCodeId
						FROM BillingCodeValidInsurers AS bcv
						WHERE InsurerId = @InsurerId
							AND IsNull(bcv.RecordDeleted, 'N') = 'N'
						)
					--4/12/2006   
					AND IR.InsurerId = @InsurerId
					AND IsNull(bc.RecordDeleted, 'N') = 'N'
					AND bc.CodeName LIKE '%' + @CodeName + '%'
					AND (
						@Active = '-1'
						OR bc.Active = @Active
						)
				
				UNION
				
				--get billingCoderates for the Insurer (If no InsurerRate exists)           
				SELECT '0' AS 'CheckBox'
					,bc.BillingCodeId
					,bc.BillingCode AS 'Code'
					,bc.CodeName AS 'Name'
					,Convert(VARCHAR(20), convert(INT, bc.Units)) + ' ' + gc.CodeName AS 'Rate Unit'
					,BCR.Rate AS 'Payable Rate'
					,'' AS 'Medicaid Code'
					,BCR.Modifier1 AS 'Modifier 1'
					,BCR.Modifier2 AS 'Modifier 2'
					,BCR.Modifier3 AS 'Modifier 3'
					,BCR.Modifier4 AS 'Modifier 4'
					,BCR.EffectiveFrom AS 'StartDate'
					,BCR.EffectiveTo AS 'EndDate'
					,'N' AS 'IsInsurer'
					,0 AS InsurerRateId
					,BCR.BillingCodeRateId
					,bc.Active
					,Cast(NULL AS DECIMAL) AS NewRate
					,cast(NULL AS DATETIME) AS NewDate
					,'0' AS 'Button EndDate'
					,0 AS InsurerId
					,BCM.StartDate AS BCMStartDate --30.01.2019  Arun K R 
					,BCM.EndDate AS BCMEndDate
					,BCM.Active AS BCMActive
					,BCM.BillingCodeModifierId
				FROM BillingCodes BC
				INNER JOIN GlobalCodes AS gc ON gc.GlobalCodeId = bc.UnitType
					AND IsNull(gc.RecordDeleted, 'N') = 'N'
				INNER JOIN BillingCodeRates BCR ON BC.BillingCodeId = BCR.BillingCodeId
					AND Convert(DATETIME, BCR.EffectiveFrom, 101) <= Convert(DATETIME, @EffectiveFrom, 101)
					AND (
						Convert(DATETIME, BCR.EffectiveTo, 101) >= Convert(DATETIME, @EffectiveFrom, 101)
						OR Convert(DATETIME, BCR.EffectiveTo, 101) IS NULL
						)
					AND (
						BCR.Rate IS NOT NULL
						OR BCR.Rate != 0
						)
					AND IsNull(BCR.RecordDeleted, 'N') = 'N'
				INNER JOIN BillingCodeValidInsurers AS bcv ON bcv.BillingCodeId = BCR.BillingCodeId
					AND bcv.InsurerId = @InsurerId
					--and bc.AllInsurers='N'           
					AND IsNull(bcv.RecordDeleted, 'N') = 'N'
					--4/12/2006           
					AND BC.BillingCodeId NOT IN (
						SELECT BillingcodeId
						FROM InsurerRates AS IR
						WHERE Convert(DATETIME, IR.EffectiveFrom, 101) <= Convert(DATETIME, @EffectiveFrom, 101)
							AND (
								Convert(DATETIME, IR.EffectiveTo, 101) >= Convert(DATETIME, @EffectiveFrom, 101)
								OR Convert(DATETIME, IR.EffectiveTo, 101) IS NULL
								)
							AND (
								IR.Rate IS NOT NULL
								OR IR.Rate != 0
								)
							AND IsNull(IR.RecordDeleted, 'N') = 'N'
							AND InsurerId = @InsurerId
						)
			   LEFT JOIN BillingCodeModifiers BCM ON BCM.BillingCodeId=BC.BillingCodeId AND ISNULL(BCM.RecordDeleted,'N')='N'
				WHERE bc.CodeName LIKE '%' + @CodeName + '%'
					AND (
						@Active = '-1'
						OR bc.Active = @Active
						)
				--5/24/2006  added one condition here at last (and InsurerId=@InsurerId , when a billingcode is valid for only selected Insurers and for some other Insurers InsurerRates have also been defined)           
				
				UNION
				
				--2/26/2006 (Get all billing Code rates with AllInsurers)           
				SELECT '0' AS 'CheckBox'
					,bc.BillingCodeId
					,bc.BillingCode AS 'Code'
					,bc.CodeName AS 'Name'
					,Convert(VARCHAR(100), convert(BIGINT, bc.Units)) + ' ' + gc.CodeName AS 'Rate Unit'
					,BCR.Rate AS 'Payable Rate'
					,'' AS 'Medicaid Code'
					,BCR.Modifier1 AS 'Modifier 1'
					,BCR.Modifier2 AS 'Modifier 2'
					,BCR.Modifier3 AS 'Modifier 3'
					,BCR.Modifier4 AS 'Modifier 4'
					,BCR.EffectiveFrom AS 'StartDate'
					,BCR.EffectiveTo AS 'EndDate'
					,'N' AS 'IsInsurer'
					,0 AS InsurerRateId
					,BillingCodeRateId
					,bc.Active
					,Cast(NULL AS DECIMAL) AS NewRate
					,cast(NULL AS DATETIME) AS NewDate
					,'0' AS 'Button EndDate'
					,0 AS InsurerId
					,BCM.StartDate AS BCMStartDate --30.01.2019  Arun K R 
					,BCM.EndDate AS BCMEndDate
					,BCM.Active AS BCMActive
					,BCM.BillingCodeModifierId
				FROM BillingCodes bc
				INNER JOIN BillingCodeRates BCR ON BC.BillingCodeId = BCR.BillingCodeId
					AND Convert(DATETIME, BCR.EffectiveFrom, 101) <= convert(DATETIME, @EffectiveFrom, 101)
					AND (
						Convert(DATETIME, BCR.EffectiveTo, 101) >= Convert(DATETIME, @EffectiveFrom, 101)
						OR Convert(DATETIME, BCR.EffectiveTo, 101) IS NULL
						)
					AND IsNull(bc.RecordDeleted, 'N') = 'N'
					AND IsNull(BCR.RecordDeleted, 'N') = 'N'
				--left outer join MedicaidBillingCode as mb on mb.BillingCodeId=bc.BillingCodeId and IsNull(mb.RecordDeleted,'N') = 'N'          
				INNER JOIN GlobalCodes AS gc ON gc.GlobalCodeId = bc.UnitType
					AND IsNull(gc.RecordDeleted, 'N') = 'N'
					AND BC.BillingCodeId NOT IN (
						SELECT BillingcodeId
						FROM InsurerRates AS IR
						WHERE Convert(DATETIME, IR.EffectiveFrom, 101) <= Convert(DATETIME, @EffectiveFrom, 101)
							AND (
								Convert(DATETIME, IR.EffectiveTo, 101) >= Convert(DATETIME, @EffectiveFrom, 101)
								OR Convert(DATETIME, IR.EffectiveTo, 101) IS NULL
								)
							AND (
								IR.Rate IS NOT NULL
								OR IR.Rate != 0
								)
							AND IsNull(IR.RecordDeleted, 'N') = 'N'
							AND InsurerId = @InsurerId
						)
					AND bc.AllInsurers = 'Y' --4/12/2006
				LEFT JOIN BillingCodeModifiers BCM ON BCM.BillingCodeId=BC.BillingCodeId AND ISNULL(BCM.RecordDeleted,'N')='N'   
				WHERE bc.CodeName LIKE '%' + @CodeName + '%'
					AND (
						@Active = '-1'
						OR bc.Active = @Active
						)
				
				UNION
				
				--2/28/2006 (Code Added By Tarunjit singh To get data for Billing Codes which have no information in standard Rates and insurer rates (BillingCodeRate is NULL)          
				SELECT '0' AS 'CheckBox'
					,BillingCodes.BillingCodeId
					,BillingCodes.BillingCode AS 'Code'
					,BillingCodes.CodeName AS 'Name'
					,Convert(VARCHAR(100), convert(BIGINT, BillingCodes.Units)) + ' ' + GlobalCodes.CodeName AS 'Rate Unit'
					,NULL AS 'Payable Rate'
					,'' AS 'Medicaid Code'
					,NULL AS 'Modifier 1'
					,NULL AS 'Modifier 2'
					,NULL AS 'Modifier 3'
					,NULL AS 'Modifier 4'
					,NULL AS 'StartDate'
					,NULL AS 'EndDate'
					,'N' AS 'IsInsurer'
					,0 AS 'InsurerRateId'
					,0 AS BillingCodeRateId
					,BillingCodes.Active
					,Cast(NULL AS DECIMAL) AS NewRate
					,cast(NULL AS DATETIME) AS NewDate
					,'0' AS 'Button EndDate'
					,0 AS InsurerId
					,BCM.StartDate AS BCMStartDate --30.01.2019  Arun K R 
					,BCM.EndDate AS BCMEndDate
					,BCM.Active AS BCMActive
					,BCM.BillingCodeModifierId
				--,BillingCodes.Units,BillingCodes.UnitType,BillingCodes.ReportingUnits,BillingCodes.ReportingUnitType --3/8/2006           
				FROM BillingCodes
				INNER JOIN GlobalCodes ON BillingCodes.UnitType = GlobalCodes.GlobalCodeId
				LEFT JOIN BillingCodeModifiers BCM ON BCM.BillingCodeId=BillingCodes.BillingCodeId AND ISNULL(BCM.RecordDeleted,'N')='N'
				WHERE BillingCodes.Active = 'Y'
					AND IsNull(BillingCodes.RecordDeleted, 'N') = 'N'
					AND BillingCodes.BillingCodeId NOT IN (
						SELECT BillingCodeId
						FROM BillingCodeRates AS BCR
						WHERE Isnull(RecordDeleted, 'N') = 'N'
							AND Convert(DATETIME, BCR.EffectiveFrom, 101) <= Convert(DATETIME, @EffectiveFrom, 101)
							AND (
								Convert(DATETIME, BCR.EffectiveTo, 101) >= Convert(DATETIME, @EffectiveFrom, 101)
								OR Convert(DATETIME, BCR.EffectiveTo, 101) IS NULL
								)
						
						UNION
						
						SELECT BillingCodeId
						FROM InsurerRates AS IR
						WHERE Isnull(RecordDeleted, 'N') = 'N'
							AND Convert(DATETIME, IR.EffectiveFrom, 101) <= Convert(DATETIME, @EffectiveFrom, 101)
							AND (
								Convert(DATETIME, IR.EffectiveTo, 101) >= Convert(DATETIME, @EffectiveFrom, 101)
								OR Convert(DATETIME, IR.EffectiveTo, 101) IS NULL
								)
						)
					AND BillingCodes.AllInsurers = 'Y' --4/12/2006   
					AND BillingCodes.CodeName LIKE '%' + @CodeName + '%'
					AND (
						@Active = '-1'
						OR BillingCodes.Active = @Active
						)
				
				UNION --4/12/2006 (To get records for only valid Insuers)            
				
				SELECT '0' AS 'CheckBox'
					,BillingCodes.BillingCodeId
					,BillingCodes.BillingCode AS 'Code'
					,BillingCodes.CodeName AS 'Name'
					,Convert(VARCHAR(100), convert(BIGINT, BillingCodes.Units)) + ' ' + GlobalCodes.CodeName AS 'Rate Unit'
					,NULL AS 'Payable Rate'
					,'' AS 'Medicaid Code'
					,NULL AS 'Modifier 1'
					,NULL AS 'Modifier 2'
					,NULL AS 'Modifier 3'
					,NULL AS 'Modifier 4'
					,NULL AS 'StartDate'
					,NULL AS 'EndDate'
					,'N' AS 'IsInsurer'
					,0 AS 'InsurerRateId'
					,0 AS BillingCodeRateId
					,BillingCodes.Active
					,Cast(NULL AS DECIMAL) AS NewRate
					,cast(NULL AS DATETIME) AS NewDate
					,'0' AS 'Button EndDate'
					,0 AS InsurerId
				    ,BCM.StartDate AS BCMStartDate --30.01.2019  Arun K R 
					,BCM.EndDate AS BCMEndDate
					,BCM.Active AS BCMActive
					,BCM.BillingCodeModifierId
				--,BillingCodes.Units,BillingCodes.UnitType,BillingCodes.ReportingUnits,BillingCodes.ReportingUnitType --3/8/2006           
				FROM BillingCodes
				INNER JOIN GlobalCodes ON BillingCodes.UnitType = GlobalCodes.GlobalCodeId
				INNER JOIN BillingCodeValidInsurers AS bcv ON bcv.BillingCodeId = BillingCodes.BillingCodeId
					AND bcv.InsurerId = @InsurerId
					AND IsNull(bcv.RecordDeleted, 'N') = 'N'
				LEFT JOIN BillingCodeModifiers BCM ON BCM.BillingCodeId=BillingCodes.BillingCodeId AND ISNULL(BCM.RecordDeleted,'N')='N'
				WHERE BillingCodes.Active = 'Y'
					AND IsNull(BillingCodes.RecordDeleted, 'N') = 'N'
					AND BillingCodes.BillingCodeId NOT IN (
						SELECT BillingCodeId
						FROM BillingCodeRates AS BCR
						WHERE Isnull(RecordDeleted, 'N') = 'N'
							AND Convert(DATETIME, BCR.EffectiveFrom, 101) <= Convert(DATETIME, @EffectiveFrom, 101)
							AND (
								Convert(DATETIME, BCR.EffectiveTo, 101) >= Convert(DATETIME, @EffectiveFrom, 101)
								OR Convert(DATETIME, BCR.EffectiveTo, 101) IS NULL
								)
						
						UNION
						
						SELECT BillingCodeId
						FROM InsurerRates AS IR
						WHERE Isnull(RecordDeleted, 'N') = 'N'
							AND Convert(DATETIME, IR.EffectiveFrom, 101) <= Convert(DATETIME, @EffectiveFrom, 101)
							AND (
								Convert(DATETIME, IR.EffectiveTo, 101) >= Convert(DATETIME, @EffectiveFrom, 101)
								OR Convert(DATETIME, IR.EffectiveTo, 101) IS NULL
								)
							AND IR.InsurerId = @InsurerId
							--5/31/2006           
							--and IR.InsurerId=@InsurerId) --4/12/2006           
						)
					AND BillingCodes.AllInsurers = 'N'
					--end change       
					AND BillingCodes.CodeName LIKE '%' + @CodeName + '%'
					AND (
						@Active = '-1'
						OR BillingCodes.Active = @Active
						)
				
				UNION
				
				--2/28/2006 (Code Added By Tarunjit singh To get data for Billing Codes which have no information in standard Rates and have data in  insurer rates not corresponding to insurer selected          
				SELECT '0' AS 'CheckBox'
					,BillingCodes.BillingCodeId
					,BillingCodes.BillingCode AS 'Code'
					,BillingCodes.CodeName AS 'Name'
					,Convert(VARCHAR(20), convert(INT, BillingCodes.Units)) + ' ' + GlobalCodes.CodeName AS 'Rate Unit'
					,NULL AS 'Payable Rate'
					,'' AS 'M edicad Code'
					,NULL AS 'Modifier 1'
					,NULL AS 'Modifier 2'
					,NULL AS 'Modifier 3'
					,NULL AS 'Modifier 4'
					,NULL AS 'StartDate'
					,NULL AS 'EndDate'
					,'N' AS 'IsInsurer'
					,0 AS InsurerRateId
					,0 AS BillingCodeRateId
					,BillingCodes.Active
					,Cast(NULL AS DECIMAL) AS NewRate
					,cast(NULL AS DATETIME) AS NewDate
					,'0' AS 'Button EndDate'
					,0 AS InsurerId
					,BCM.StartDate AS BCMStartDate --30.01.2019  Arun K R 
					,BCM.EndDate AS BCMEndDate
					,BCM.Active AS BCMActive
					,BCM.BillingCodeModifierId
				FROM dbo.BillingCodes
				INNER JOIN dbo.GlobalCodes ON dbo.BillingCodes.UnitType = dbo.GlobalCodes.GlobalCodeId
				LEFT JOIN BillingCodeModifiers BCM ON BCM.BillingCodeId=BillingCodes.BillingCodeId AND ISNULL(BCM.RecordDeleted,'N')='N'
				WHERE (dbo.BillingCodes.Active = 'Y')
					AND (ISNULL(dbo.BillingCodes.RecordDeleted, 'N') = 'N')
					AND (dbo.BillingCodes.AllInsurers = 'Y')
					AND (
						dbo.BillingCodes.BillingCodeId NOT IN (
							SELECT BillingCodeId
							FROM BillingCodeRates
							WHERE ISnull(RecordDeleted, 'N') = 'N'
							)
						)
					AND (
						dbo.BillingCodes.BillingCodeId IN (
							SELECT BillingCodeId
							FROM InsurerRates AS IR
							WHERE ISnull(RecordDeleted, 'N') = 'N'
								AND InsurerID <> @InsurerId
								--3/7/2006           
								AND Convert(DATETIME, IR.EffectiveFrom, 101) <= Convert(DATETIME, @EffectiveFrom, 101)
								AND (
									Convert(DATETIME, IR.EffectiveTo, 101) >= Convert(DATETIME, @EffectiveFrom, 101)
									OR Convert(DATETIME, IR.EffectiveTo, 101) IS NULL
									)
								AND BillingCodeId NOT IN (
									SELECT BillingCodeId
									FROM InsurerRates
									WHERE InsurerId = @InsurerId
										AND ISnull(RecordDeleted, 'N') = 'N'
									)
								AND BillingCodes.CodeName LIKE '%' + @CodeName + '%'
							)
						AND (
							@Active = '-1'
							OR BillingCodes.Active = @Active
							)
						)
			END

			IF (
					@InsurerId > 0
					AND @ProviderId > 0
					AND @SiteId <= 0
					AND @ClientId <= 0
					) --3rd Condition                 
			BEGIN
				INSERT INTO #BillingCodestemp --Get Contracted Rates only           
				SELECT '0' AS 'CheckBox'
					,bc.BillingCodeId
					,bc.BillingCode AS 'Code'
					,bc.CodeName AS 'Name'
					,Convert(VARCHAR(20), convert(INT, bc.Units)) + ' ' + gc.CodeName AS 'Rate Unit'
					,CR.ContractRate AS 'Payable Rate'
					,'' AS 'Medicaid Code'
					,CR.Modifier1 AS 'Modifier1'
					,CR.Modifier2 AS 'Modifier 2'
					,CR.Modifier3 AS 'Modifier 3'
					,CR.Modifier4 AS 'Modifier 4'
					,CR.StartDate
					,CR.EndDate
					,'N' AS 'IsInsurer'
					,0 AS InsurerRateId
					,0 AS BillingCodeRateId
					,bc.Active
					,Cast(NULL AS DECIMAL) AS NewRate
					,cast(NULL AS DATETIME) AS NewDate
					,'0' AS 'Button EndDate'
					,0 AS InsurerId
					,BCM.StartDate AS BCMStartDate --30.01.2019  Arun K R 
					,BCM.EndDate AS BCMEndDate
					,BCM.Active AS BCMActive
					,BCM.BillingCodeModifierId
				FROM BillingCodes AS bc
				INNER JOIN GlobalCodes AS gc ON gc.GlobalCodeId = bc.UnitType
					AND IsNull(gc.RecordDeleted, 'N') = 'N'
				INNER JOIN ContractRates CR ON cr.BillingCodeId = bc.BillingCodeId
					AND IsNull(CR.RecordDeleted, 'N') = 'N'
					AND CR.Active = 'Y'
				LEFT JOIN BillingCodeModifiers BCM ON BCM.BillingCodeId=BC.BillingCodeId AND ISNULL(BCM.RecordDeleted,'N')='N'
				WHERE ContractId IN (
						SELECT ContractId
						FROM Contracts
						WHERE InsurerId = @InsurerId
							AND ProviderId = @ProviderId
							AND Convert(DATETIME, StartDate, 101) <= Convert(DATETIME, @EffectiveFrom, 101)
							AND Convert(DATETIME, EndDate, 101) >= Convert(DATETIME, @EffectiveFrom, 101)
							AND IsNull(RecordDeleted, 'N') = 'N'
						)
					AND (
						CR.StartDate IS NULL
						OR CR.EndDate IS NULL
						OR Convert(DATETIME, CR.StartDate, 101) <= Convert(DATETIME, @EffectiveFrom, 101)
						AND Convert(DATETIME, CR.EndDate, 101) >= Convert(DATETIME, @EffectiveFrom, 101)
						)
					AND IsNull(bc.RecordDeleted, 'N') = 'N'
					AND bc.CodeName LIKE '%' + @CodeName + '%'
					AND (
						@Active = '-1'
						OR bc.Active = @Active
						)
				
				UNION
				
				--2/28/2006 (To get data for Billing Codes which have no information in standard Rates and insurer rates          
				SELECT '0' AS 'CheckBox'
					,BillingCodes.BillingCodeId
					,BillingCodes.BillingCode AS 'Code'
					,BillingCodes.CodeName AS 'Name'
					,Convert(VARCHAR(100), convert(BIGINT, BillingCodes.Units)) + ' ' + GlobalCodes.CodeName AS 'Rate Unit'
					,NULL AS 'Payable Rate'
					,'' AS 'Medicaid Code'
					,NULL AS 'Modifier 1'
					,NULL AS 'Modifier 2'
					,NULL AS 'Modifier 3'
					,NULL AS 'Modifier 4'
					,NULL AS 'StartDate'
					,NULL AS 'EndDate'
					,'N' AS 'IsInsurer'
					,0 AS 'InsurerRateId'
					,0 AS BillingCodeRateId
					,BillingCodes.Active
					,Cast(NULL AS DECIMAL) AS NewRate
					,cast(NULL AS DATETIME) AS NewDate
					,'0' AS 'Button EndDate'
					,0 AS InsurerId
					,BCM.StartDate AS BCMStartDate --30.01.2019  Arun K R 
					,BCM.EndDate AS BCMEndDate
					,BCM.Active AS BCMActive
					,BCM.BillingCodeModifierId
				FROM dbo.BillingCodes
				INNER JOIN dbo.GlobalCodes ON dbo.BillingCodes.UnitType = dbo.GlobalCodes.GlobalCodeId
				LEFT JOIN BillingCodeModifiers BCM ON BCM.BillingCodeId=BillingCodes.BillingCodeId AND ISNULL(BCM.RecordDeleted,'N')='N'
				WHERE BillingCodes.Active = 'Y'
					AND IsNull(BillingCodes.RecordDeleted, 'N') = 'N'
					--and BillingCodes.BillingCodeId not in (Select BillingCodeId from BillingCodeRates where Isnull(RecordDeleted,'N')='N' union Select BillingCodeId from InsurerRates where Isnull(RecordDeleted,'N')='N')          
					AND BillingCodes.BillingCodeId NOT IN (
						SELECT BillingCodeId
						FROM BillingCodeRates AS BCR
						WHERE Isnull(RecordDeleted, 'N') = 'N'
							AND Convert(DATETIME, BCR.EffectiveFrom, 101) <= Convert(DATETIME, @EffectiveFrom, 101)
							AND (
								Convert(DATETIME, BCR.EffectiveTo, 101) >= Convert(DATETIME, @EffectiveFrom, 101)
								OR Convert(DATETIME, BCR.EffectiveTo, 101) IS NULL
								)
						
						UNION
						
						SELECT BillingCodeId
						FROM InsurerRates AS IR
						WHERE Isnull(RecordDeleted, 'N') = 'N'
							AND Convert(DATETIME, IR.EffectiveFrom, 101) <= Convert(DATETIME, @EffectiveFrom, 101)
							AND (
								Convert(DATETIME, IR.EffectiveTo, 101) >= Convert(DATETIME, @EffectiveFrom, 101)
								OR Convert(DATETIME, IR.EffectiveTo, 101) IS NULL
								)
						--5/26/2006  Exclude Contract Rates (which already have included in first condition)          
						
						UNION
						
						SELECT BillingCodeId
						FROM ContractRates AS cr
						INNER JOIN Contracts c ON cr.contractId = c.ContractId
						WHERE (
								CR.StartDate IS NULL
								OR CR.EndDate IS NULL
								OR Convert(DATETIME, CR.StartDate, 101) <= Convert(DATETIME, @EffectiveFrom, 101)
								AND Convert(DATETIME, CR.EndDate, 101) >= Convert(DATETIME, @EffectiveFrom, 101)
								)
							AND IsNull(CR.RecordDeleted, 'N') = 'N'
							AND IsNull(c.RecordDeleted, 'N') = 'N'
							AND CR.Active = 'Y'
							AND c.InsurerId = @InsurerId
							AND c.ProviderId = @ProviderId
							AND Convert(DATETIME, c.StartDate, 101) <= Convert(DATETIME, @EffectiveFrom, 101)
							--5/26/2006 end           
						)
					AND BillingCodes.CodeName LIKE '%' + @CodeName + '%'
					--and BillingCodes.AllInsurers = 'Y' 
					AND IsNull(BillingCodes.AllInsurers, 'Y') = 'Y'
					AND (
						@Active = '-1'
						OR BillingCodes.Active = @Active
						)
				
				UNION
				
				--4/12/2006 (To get records for valid Insuers and which have no records in BIllingCodeRaes or InsurerRates)           
				SELECT '0' AS 'CheckBox'
					,BillingCodes.BillingCodeId
					,BillingCodes.BillingCode AS 'Code'
					,BillingCodes.CodeName AS 'Name'
					,Convert(VARCHAR(100), convert(BIGINT, BillingCodes.Units)) + ' ' + GlobalCodes.CodeName AS 'Rate Unit'
					,NULL AS 'Payable Rate'
					,'' AS 'Medicaid Code'
					,NULL AS 'Modifier 1'
					,NULL AS 'Modifier 2'
					,NULL AS 'Modifier 3'
					,NULL AS 'Modifier 4'
					,NULL AS 'StartDate'
					,NULL AS 'EndDate'
					,'N' AS 'IsInsurer'
					,0 AS 'InsurerRateId'
					,0 AS BillingCodeRateId
					,BillingCodes.Active
					,Cast(NULL AS DECIMAL) AS NewRate
					,cast(NULL AS DATETIME) AS NewDate
					,'0' AS 'Button EndDate'
					,0 AS InsurerId
					,BCM.StartDate AS BCMStartDate --30.01.2019  Arun K R 
					,BCM.EndDate AS BCMEndDate
					,BCM.Active AS BCMActive
					,BCM.BillingCodeModifierId
				--,BillingCodes.Units,BillingCodes.UnitType,BillingCodes.ReportingUnits,BillingCodes.ReportingUnitType --3/8/2006         
				FROM BillingCodes
				INNER JOIN GlobalCodes ON BillingCodes.UnitType = GlobalCodes.GlobalCodeId
				INNER JOIN BillingCodeValidInsurers AS bcv ON bcv.BillingCodeId = BillingCodes.BillingCodeId
					AND bcv.InsurerId = @InsurerId
					AND IsNull(bcv.RecordDeleted, 'N') = 'N'
				LEFT JOIN BillingCodeModifiers BCM ON BCM.BillingCodeId=BillingCodes.BillingCodeId AND ISNULL(BCM.RecordDeleted,'N')='N'
				WHERE BillingCodes.Active = 'Y'
					AND IsNull(BillingCodes.RecordDeleted, 'N') = 'N'
					AND BillingCodes.BillingCodeId NOT IN (
						SELECT BillingCodeId
						FROM BillingCodeRates AS BCR
						WHERE Isnull(RecordDeleted, 'N') = 'N'
							AND Convert(DATETIME, BCR.EffectiveFrom, 101) <= Convert(DATETIME, @EffectiveFrom, 101)
							AND (
								Convert(DATETIME, BCR.EffectiveTo, 101) >= Convert(DATETIME, @EffectiveFrom, 101)
								OR Convert(DATETIME, BCR.EffectiveTo, 101) IS NULL
								)
						
						UNION
						
						SELECT BillingCodeId
						FROM InsurerRates AS IR
						WHERE Isnull(RecordDeleted, 'N') = 'N'
							AND Convert(DATETIME, IR.EffectiveFrom, 101) <= Convert(DATETIME, @EffectiveFrom, 101)
							AND (
								Convert(DATETIME, IR.EffectiveTo, 101) >= Convert(DATETIME, @EffectiveFrom, 101)
								OR Convert(DATETIME, IR.EffectiveTo, 101) IS NULL
								)
							--and IR.InsurerId=@InsurerId) --4/12/2006           
							AND IR.InsurerId = @InsurerId
							--5/31/2006           
						)
					AND BillingCodes.AllInsurers = 'N'
					AND BillingCodes.CodeName LIKE '%' + @CodeName + '%'
					AND (
						@Active = '-1'
						OR BillingCodes.Active = @Active
						)
				
				UNION
				
				--2/28/2006 (Code Added By Tarunjit singh To get data for Billing Codes which have no information in standard Rates and have data in  insurer rates not corresponding to insurer selected          
				SELECT '0' AS 'CheckBox'
					,BillingCodes.BillingCodeId
					,BillingCodes.BillingCode AS 'Code'
					,BillingCodes.CodeName AS 'Name'
					,Convert(VARCHAR(20), convert(INT, BillingCodes.Units)) + ' ' + GlobalCodes.CodeName AS 'Rate Unit'
					,NULL AS 'Payable Rate'
					,'' AS 'Medicaid Code'
					,NULL AS 'Modifier 1'
					,NULL AS 'Modifier 2'
					,NULL AS 'Modifier 3'
					,NULL AS 'Modifier 4'
					,NULL AS 'StartDate'
					,NULL AS 'EndDate'
					,'N' AS 'IsInsurer'
					,0 AS InsurerRateId
					,0 AS BillingCodeRateId
					,BillingCodes.Active
					,Cast(NULL AS DECIMAL) AS NewRate
					,cast(NULL AS DATETIME) AS NewDate
					,'0' AS 'Button EndDate'
					,0 AS InsurerId
					,BCM.StartDate AS BCMStartDate --30.01.2019  Arun K R 
					,BCM.EndDate AS BCMEndDate
					,BCM.Active AS BCMActive
					,BCM.BillingCodeModifierId
				FROM dbo.BillingCodes
				INNER JOIN dbo.GlobalCodes ON dbo.BillingCodes.UnitType = dbo.GlobalCodes.GlobalCodeId
				LEFT JOIN BillingCodeModifiers BCM ON BCM.BillingCodeId=BillingCodes.BillingCodeId AND ISNULL(BCM.RecordDeleted,'N')='N'
				WHERE (dbo.BillingCodes.Active = 'Y')
					AND (ISNULL(dbo.BillingCodes.RecordDeleted, 'N') = 'N')
					AND (dbo.BillingCodes.AllInsurers = 'Y')
					AND (
						dbo.BillingCodes.BillingCodeId NOT IN (
							SELECT BillingCodeId
							FROM BillingCodeRates
							WHERE ISnull(RecordDeleted, 'N') = 'N'
							)
						)
					AND (
						dbo.BillingCodes.BillingCodeId IN (
							SELECT BillingCodeId
							FROM InsurerRates AS IR
							WHERE ISnull(RecordDeleted, 'N') = 'N'
								AND InsurerID <> @InsurerId
								--3/7/2006           
								AND Convert(DATETIME, IR.EffectiveFrom, 101) <= Convert(DATETIME, @EffectiveFrom, 101)
								AND (
									Convert(DATETIME, IR.EffectiveTo, 101) >= Convert(DATETIME, @EffectiveFrom, 101)
									OR Convert(DATETIME, IR.EffectiveTo, 101) IS NULL
									)
								AND BillingCodeId NOT IN (
									SELECT BillingCodeId
									FROM InsurerRates
									WHERE InsurerId = @InsurerId
										AND ISnull(RecordDeleted, 'N') = 'N'
									)
								AND BillingCodes.CodeName LIKE '%' + @CodeName + '%'
							)
						)
					AND (
						@Active = '-1'
						OR BillingCodes.Active = @Active
						)
			END

			IF (
					@InsurerId > 0
					AND @ProviderId > 0
					AND @SiteId > 0
					AND @ClientId <= 0
					) --4th condition                 
			BEGIN
				INSERT INTO #BillingCodestemp
				SELECT '0' AS 'CheckBox'
					,bc.BillingCodeId
					,bc.BillingCode AS 'Code'
					,bc.CodeName AS 'Name'
					,Convert(VARCHAR(20), convert(INT, bc.Units)) + ' ' + gc.CodeName AS 'Rate Unit'
					,CR.ContractRate AS 'Payable Rate'
					,'' AS 'Medicaid Code'
					,CR.Modifier1 AS 'Modifier1'
					,CR.Modifier2 AS 'Modifier 2'
					,CR.Modifier3 AS 'Modifier 3'
					,CR.Modifier4 AS 'Modifier 4'
					,CR.StartDate
					,CR.EndDate
					,'N' AS 'IsInsurer'
					,0 AS InsurerRateId
					,0 AS BillingCodeRateId
					,bc.Active
					,Cast(NULL AS DECIMAL) AS NewRate
					,cast(NULL AS DATETIME) AS NewDate
					,'0' AS 'Button EndDate'
					,0 AS InsurerId
					,BCM.StartDate AS BCMStartDate --30.01.2019  Arun K R 
					,BCM.EndDate AS BCMEndDate
					,BCM.Active AS BCMActive
					,BCM.BillingCodeModifierId
				FROM BillingCodes AS bc
				INNER JOIN ContractRates CR ON cr.BillingCodeId = bc.BillingCodeId
				LEFT JOIN ContractRateSites CRS ON CR.ContractRateId = CRS.ContractRateId
					AND ISNULL(CRS.RecordDeleted, 'N') = 'N'
				INNER JOIN GlobalCodes AS gc ON gc.GlobalCodeId = bc.UnitType
					AND IsNull(gc.RecordDeleted, 'N') = 'N'
				LEFT JOIN BillingCodeModifiers BCM ON BCM.BillingCodeId=BC.BillingCodeId AND ISNULL(BCM.RecordDeleted,'N')='N'
				WHERE ContractId IN (
						SELECT ContractId
						FROM Contracts
						WHERE InsurerId = @InsurerId
							AND ProviderId = @ProviderId
							AND Convert(DATETIME, StartDate, 101) <= Convert(DATETIME, @EffectiveFrom, 101)
							AND Convert(DATETIME, EndDate, 101) >= Convert(DATETIME, @EffectiveFrom, 101)
							AND IsNull(RecordDeleted, 'N') = 'N'
						)
					AND (
						CR.StartDate IS NULL
						OR CR.EndDate IS NULL
						OR Convert(DATETIME, CR.StartDate, 101) <= Convert(DATETIME, @EffectiveFrom, 101)
						AND Convert(DATETIME, CR.EndDate, 101) >= Convert(DATETIME, @EffectiveFrom, 101)
						)
					AND (
						CRS.SiteId = @SiteId
						OR @SiteId IS NULL
						OR @SiteId = 0
						)
					AND IsNull(CRS.RecordDeleted, 'N') = 'N'
					AND IsNull(bc.RecordDeleted, 'N') = 'N'
					AND bc.CodeName LIKE '%' + @CodeName + '%'
					AND (
						@Active = '-1'
						OR bc.Active = @Active
						)
				
				UNION
				
				--2/28/2006 (Code Added By Tarunjit singh To get data for Billing Codes which have no information in standard Rates and insurer rates          
				SELECT '0' AS 'CheckBox'
					,BillingCodes.BillingCodeId
					,BillingCodes.BillingCode AS 'Code'
					,BillingCodes.CodeName AS 'Name'
					,Convert(VARCHAR(100), convert(BIGINT, BillingCodes.Units)) + ' ' + GlobalCodes.CodeName AS 'Rate Unit'
					,NULL AS 'Payable Rate'
					,'' AS '   Medicaid Code'
					,NULL AS 'Modifier 1'
					,NULL AS 'Modifier 2'
					,NULL AS 'Modifier 3'
					,NULL AS 'Modifier 4'
					,NULL AS 'StartDate'
					,NULL AS 'EndDate'
					,'N' AS 'IsInsurer'
					,0 AS 'InsurerRateId'
					,0 AS BillingCodeRateId
					,BillingCodes.Active
					,Cast(NULL AS DECIMAL) AS NewRate
					,cast(NULL AS DATETIME) AS NewDate
					,'0' AS 'Button EndDate'
					,0 AS InsurerId
					,BCM.StartDate AS BCMStartDate --30.01.2019  Arun K R 
					,BCM.EndDate AS BCMEndDate
					,BCM.Active AS BCMActive
					,BCM.BillingCodeModifierId
				FROM dbo.BillingCodes
				INNER JOIN dbo.GlobalCodes ON dbo.BillingCodes.UnitType = dbo.GlobalCodes.GlobalCodeId
					AND IsNull(GlobalCodes.RecordDeleted, 'N') = 'N'
				LEFT JOIN BillingCodeModifiers BCM ON BCM.BillingCodeId=BillingCodes.BillingCodeId AND ISNULL(BCM.RecordDeleted,'N')='N'
				WHERE BillingCodes.Active = 'Y'
					AND IsNull(BillingCodes.RecordDeleted, 'N') = 'N'
					--and BillingCodes.BillingCodeId not in (Select BillingCodeId from BillingCodeRates where Isnull(RecordDeleted,'N')='N' union Select BillingCodeId from InsurerRates where Isnull(RecordDeleted,'N')='N')          
					AND BillingCodes.BillingCodeId NOT IN (
						SELECT BillingCodeId
						FROM BillingCodeRates AS BCR
						WHERE Isnull(RecordDeleted, 'N') = 'N'
							AND Convert(DATETIME, BCR.EffectiveFrom, 101) <= Convert(DATETIME, @EffectiveFrom, 101)
							AND (
								Convert(DATETIME, BCR.EffectiveTo, 101) >= Convert(DATETIME, @EffectiveFrom, 101)
								OR Convert(DATETIME, BCR.EffectiveTo, 101) IS NULL
								)
						
						UNION
						
						SELECT BillingCodeId
						FROM InsurerRates AS IR
						WHERE Isnull(RecordDeleted, 'N') = 'N'
							AND Convert(DATETIME, IR.EffectiveFrom, 101) <= Convert(DATETIME, @EffectiveFrom, 101)
							AND (
								Convert(DATETIME, IR.EffectiveTo, 101) >= Convert(DATETIME, @EffectiveFrom, 101)
								OR Convert(DATETIME, IR.EffectiveTo, 101) IS NULL
								)
							--5/26/2006  Exclude Contract Rates (which already have included in first condition)  
							AND BillingCodes.CodeName LIKE '%' + @CodeName + '%'
						
						UNION
						
						SELECT BillingCodeId
						FROM ContractRates AS cr
						LEFT JOIN ContractRateSites CRS ON cr.ContractRateId = CRS.ContractRateId
							AND ISNULL(CRS.RecordDeleted, 'N') = 'N'
						INNER JOIN Contracts c ON cr.contractId = c.ContractId
						WHERE (
								CR.StartDate IS NULL
								OR CR.EndDate IS NULL
								OR Convert(DATETIME, CR.StartDate, 101) <= Convert(DATETIME, @EffectiveFrom, 101)
								AND Convert(DATETIME, CR.EndDate, 101) >= Convert(DATETIME, @EffectiveFrom, 101)
								)
							AND IsNull(CR.RecordDeleted, 'N') = 'N'
							AND IsNull(c.RecordDeleted, 'N') = 'N'
							AND CR.Active = 'Y'
							AND c.InsurerId = @InsurerId
							AND c.ProviderId = @ProviderId
							AND Convert(DATETIME, c.StartDate, 101) <= Convert(DATETIME, @EffectiveFrom, 101)
							AND (
								CRS.SiteId = @SiteId
								OR @SiteId IS NULL
								OR @SiteId = 0
								)
							AND IsNull(CRS.RecordDeleted, 'N') = 'N'
							--5/26/2006 end           
						)
					AND BillingCodes.AllInsurers = 'Y' --4/12/2006   
					AND BillingCodes.CodeName LIKE '%' + @CodeName + '%'
					AND (
						@Active = '-1'
						OR BillingCodes.Active = @Active
						)
				
				UNION --4/12/2006 (To get records for only valid Insuers)            
				
				SELECT '0' AS 'CheckBox'
					,BillingCodes.BillingCodeId
					,BillingCodes.BillingCode AS 'Code'
					,BillingCodes.CodeName AS 'Name'
					,Convert(VARCHAR(100), convert(BIGINT, BillingCodes.Units)) + ' ' + GlobalCodes.CodeName AS 'Rate Unit'
					,NULL AS 'Payable Rate'
					,'' AS 'Medicaid Code'
					,NULL AS 'Modifier 1'
					,NULL AS 'Modifier 2'
					,NULL AS 'Modifier 3'
					,NULL AS 'Modifier 4'
					,NULL AS 'StartDate'
					,NULL AS 'EndDate'
					,'N' AS 'IsInsurer'
					,0 AS 'InsurerRateId'
					,0 AS BillingCodeRateId
					,BillingCodes.Active
					,Cast(NULL AS DECIMAL) AS NewRate
					,cast(NULL AS DATETIME) AS NewDate
					,'0' AS 'Button EndDate'
					,0 AS InsurerId
					,BCM.StartDate AS BCMStartDate --30.01.2019  Arun K R 
					,BCM.EndDate AS BCMEndDate
					,BCM.Active AS BCMActive
					,BCM.BillingCodeModifierId
				--,BillingCodes.Units,BillingCodes.UnitType,BillingCodes.ReportingUnits,BillingCodes.ReportingUnitType --3/8/2006           
				FROM BillingCodes
				INNER JOIN GlobalCodes ON BillingCodes.UnitType = GlobalCodes.GlobalCodeId
					AND IsNull(GlobalCodes.RecordDeleted, 'N') = 'N'
				INNER JOIN BillingCodeValidInsurers AS bcv ON bcv.BillingCodeId = BillingCodes.BillingCodeId
					AND bcv.InsurerId = @InsurerId
					AND IsNull(bcv.RecordDeleted, 'N') = 'N'
				LEFT JOIN BillingCodeModifiers BCM ON BCM.BillingCodeId=BillingCodes.BillingCodeId AND ISNULL(BCM.RecordDeleted,'N')='N'
				WHERE BillingCodes.Active = 'Y'
					AND IsNull(BillingCodes.RecordDeleted, 'N') = 'N'
					AND BillingCodes.BillingCodeId NOT IN (
						SELECT BillingCodeId
						FROM BillingCodeRates AS BCR
						WHERE Isnull(RecordDeleted, 'N') = 'N'
							AND Convert(DATETIME, BCR.EffectiveFrom, 101) <= Convert(DATETIME, @EffectiveFrom, 101)
							AND (
								Convert(DATETIME, BCR.EffectiveTo, 101) >= Convert(DATETIME, @EffectiveFrom, 101)
								OR Convert(DATETIME, BCR.EffectiveTo, 101) IS NULL
								)
							AND BillingCodes.CodeName LIKE '%' + @CodeName + '%'
						
						UNION
						
						SELECT BillingCodeId
						FROM InsurerRates AS IR
						WHERE Isnull(RecordDeleted, 'N') = 'N'
							AND Convert(DATETIME, IR.EffectiveFrom, 101) <= Convert(DATETIME, @EffectiveFrom, 101)
							AND (
								Convert(DATETIME, IR.EffectiveTo, 101) >= Convert(DATETIME, @EffectiveFrom, 101)
								OR Convert(DATETIME, IR.EffectiveTo, 101) IS NULL
								)
							--and IR.InsurerId=@InsurerId) --4/12/2006           
							AND IR.InsurerId = @InsurerId
							--5/31/2006           
						)
					AND BillingCodes.AllInsurers = 'N'
					AND BillingCodes.CodeName LIKE '%' + @CodeName + '%'
					AND (
						@Active = '-1'
						OR BillingCodes.Active = @Active
						)
				
				UNION
				
				--2/28/2006 (Code Added By Tarunjit singh To get data for Billing Codes which have no information in standard Rates and have data in  insurer rates not corresponding to insurer selected          
				SELECT '0' AS 'CheckBox'
					,BillingCodes.BillingCodeId
					,BillingCodes.BillingCode AS 'Code'
					,BillingCodes.CodeName AS 'Name'
					,Convert(VARCHAR(20), convert(INT, BillingCodes.Units)) + ' ' + GlobalCodes.CodeName AS 'Rate Unit'
					,NULL AS 'Payable Rate'
					,'' AS 'Me             dicaid Code'
					,NULL AS 'Modifier 1'
					,NULL AS 'Modifier 2'
					,NULL AS 'Modifier 3'
					,NULL AS 'Modifier 4'
					,NULL AS 'StartDate'
					,NULL AS 'EndDate'
					,'N' AS 'IsInsurer'
					,0 AS InsurerRateId
					,0 AS BillingCodeRateId
					,BillingCodes.Active
					,Cast(NULL AS DECIMAL) AS NewRate
					,cast(NULL AS DATETIME) AS NewDate
					,'0' AS 'Button EndDate'
					,0 AS InsurerId
					,BCM.StartDate AS BCMStartDate --30.01.2019  Arun K R 
					,BCM.EndDate AS BCMEndDate
					,BCM.Active AS BCMActive
					,BCM.BillingCodeModifierId
				FROM dbo.BillingCodes
				INNER JOIN dbo.GlobalCodes ON dbo.BillingCodes.UnitType = dbo.GlobalCodes.GlobalCodeId
					AND IsNull(GlobalCodes.RecordDeleted, 'N') = 'N'
				LEFT JOIN BillingCodeModifiers BCM ON BCM.BillingCodeId=BillingCodes.BillingCodeId AND ISNULL(BCM.RecordDeleted,'N')='N'
				WHERE (dbo.BillingCodes.Active = 'Y')
					AND (ISNULL(dbo.BillingCodes.RecordDeleted, 'N') = 'N')
					AND (dbo.BillingCodes.AllInsurers = 'Y')
					AND (
						dbo.BillingCodes.BillingCodeId NOT IN (
							SELECT BillingCodeId
							FROM BillingCodeRates
							WHERE ISnull(RecordDeleted, 'N') = 'N'
							)
						)
					AND (
						dbo.BillingCodes.BillingCodeId IN (
							SELECT BillingCodeId
							FROM InsurerRates AS IR
							WHERE ISnull(RecordDeleted, 'N') = 'N'
								AND InsurerID <> @InsurerId
								--3/7/2006           
								AND Convert(DATETIME, IR.EffectiveFrom, 101) <= Convert(DATETIME, @EffectiveFrom, 101)
								AND (
									Convert(DATETIME, IR.EffectiveTo, 101) >= Convert(DATETIME, @EffectiveFrom, 101)
									OR Convert(DATETIME, IR.EffectiveTo, 101) IS NULL
									)
								AND BillingCodeId NOT IN (
									SELECT BillingCodeId
									FROM InsurerRates
									WHERE InsurerId = @InsurerId
										AND ISnull(RecordDeleted, 'N') = 'N'
									)
								AND BillingCodes.CodeName LIKE '%' + @CodeName + '%'
							)
						)
					AND (
						@Active = '-1'
						OR BillingCodes.Active = @Active
						)
			END

			IF (
					@InsurerId > 0
					AND @ProviderId > 0
					AND @ClientId > 0
					) --5th Condition           
			BEGIN
				INSERT INTO #BillingCodestemp
				SELECT '0' AS 'CheckBox'
					,bc.BillingCodeId
					,bc.BillingCode AS 'Code'
					,bc.CodeName AS 'Name'
					,Convert(VARCHAR(20), convert(INT, bc.Units)) + ' ' + gc.CodeName AS 'Rate Unit'
					,CR.ContractRate AS 'Payable Rate'
					,'' AS 'Medicaid Code'
					,CR.Modifier1 AS 'Modifier 1                '
					,CR.Modifier2 AS 'Modifier 2'
					,CR.Modifier3 AS 'Modifier 3'
					,CR.Modifier4 AS 'Modifier 4'
					,CR.StartDate
					,CR.EndDate
					,'N' AS 'IsInsurer'
					,0 AS InsurerRateId
					,0 AS BillingCodeRateId
					,bc.Active
					,Cast(NULL AS DECIMAL) AS NewRate
					,cast(NULL AS DATETIME) AS NewDate
					,'0' AS 'Button EndDate'
					,0 AS InsurerId
					,BCM.StartDate AS BCMStartDate --30.01.2019  Arun K R 
					,BCM.EndDate AS BCMEndDate
					,BCM.Active AS BCMActive
					,BCM.BillingCodeModifierId
				FROM BillingCodes AS bc
				INNER JOIN ContractRates CR ON cr.BillingCodeId = bc.BillingCodeId
				LEFT JOIN ContractRateSites CRS ON CR.ContractRateId = CRS.ContractRateId
					AND ISNULL(CRS.RecordDeleted, 'N') = 'N'
				INNER JOIN GlobalCodes AS gc ON gc.GlobalCodeId = bc.UnitType
					AND IsNull(gc.RecordDeleted, 'N') = 'N'
				LEFT JOIN BillingCodeModifiers BCM ON BCM.BillingCodeId=BC.BillingCodeId AND ISNULL(BCM.RecordDeleted,'N')='N'
				WHERE ContractId IN (
						SELECT ContractId
						FROM Contracts
						WHERE InsurerId = @InsurerId
							AND ProviderId = @ProviderId
							AND Convert(DATETIME, StartDate, 101) <= Convert(DATETIME, @EffectiveFrom, 101)
							AND Convert(DATETIME, EndDate, 101) >= Convert(DATETIME, @EffectiveFrom, 101)
							AND IsNull(RecordDeleted, 'N') = 'N'
						)
					AND (
						CR.StartDate IS NULL
						OR CR.EndDate IS NULL
						OR Convert(DATETIME, CR.StartDate, 101) <= Convert(DATETIME, @EffectiveFrom, 101)
						AND Convert(DATETIME, CR.EndDate, 101) >= Convert(DATETIME, @EffectiveFrom, 101)
						)
					AND (
						CRS.SiteId = @SiteId
						OR @SiteId IS NULL
						OR @SiteId = 0
						)
					AND IsNull(CRS.RecordDeleted, 'N') = 'N'
					AND (CR.ClientID = @ClientId)
					AND IsNull(bc.RecordDeleted, 'N') = 'N'
					AND bc.CodeName LIKE '%' + @CodeName + '%'
					AND (
						@Active = '-1'
						OR bc.Active = @Active
						)
				
				UNION
				
				--2/28/2006 (Code Added By Tarunjit singh To get data for Billing Codes which have no information in standard Rates and insurer rates        
				SELECT '0' AS 'CheckBox'
					,BillingCodes.BillingCodeId
					,BillingCodes.BillingCode AS 'Code'
					,BillingCodes.CodeName AS 'Name'
					,Convert(VARCHAR(100), convert(BIGINT, BillingCodes.Units)) + ' ' + GlobalCodes.CodeName AS 'Rate Unit'
					,NULL AS 'Payable Rate'
					,'                ' AS 'Medicaid Code'
					,NULL AS 'Modifier 1'
					,NULL AS 'Modifier 2'
					,NULL AS 'Modifier 3'
					,NULL AS 'Modifier 4'
					,NULL AS 'StartDate'
					,NULL AS 'EndDate'
					,'N' AS 'IsInsurer'
					,0 AS 'InsurerRateId'
					,NULL AS BillingCodeRateId
					,BillingCodes.Active
					,Cast(NULL AS DECIMAL) AS NewRate
					,cast(NULL AS DATETIME) AS NewDate
					,'0' AS 'Button EndDate'
					,0 AS InsurerId
					,BCM.StartDate AS BCMStartDate --30.01.2019  Arun K R 
					,BCM.EndDate AS BCMEndDate
					,BCM.Active AS BCMActive
					,BCM.BillingCodeModifierId
				FROM dbo.BillingCodes
				INNER JOIN dbo.GlobalCodes ON dbo.BillingCodes.UnitType = dbo.GlobalCodes.GlobalCodeId
					AND IsNull(GlobalCodes.RecordDeleted, 'N') = 'N'
				LEFT JOIN BillingCodeModifiers BCM ON BCM.BillingCodeId=BillingCodes.BillingCodeId AND ISNULL(BCM.RecordDeleted,'N')='N'
				WHERE BillingCodes.Active = 'Y'
					AND IsNull(BillingCodes.RecordDeleted, 'N') = 'N'
					--and BillingCodes.BillingCodeId not in (Select BillingCodeId from BillingCodeRates where Isnull(RecordDeleted,'N')='N' union Select BillingCodeId from InsurerRates where Isnull(RecordDeleted,'N')='N')          
					AND BillingCodes.BillingCodeId NOT IN (
						SELECT BillingCodeId
						FROM BillingCodeRates AS BCR
						WHERE Isnull(RecordDeleted, 'N') = 'N'
							AND Convert(DATETIME, BCR.EffectiveFrom, 101) <= Convert(DATETIME, @EffectiveFrom, 101)
							AND (
								Convert(DATETIME, BCR.EffectiveTo, 101) >= Convert(DATETIME, @EffectiveFrom, 101)
								OR Convert(DATETIME, BCR.EffectiveTo, 101) IS NULL
								)
							AND BillingCodes.CodeName LIKE '%' + @CodeName + '%'
						
						UNION
						
						SELECT BillingCodeId
						FROM InsurerRates AS IR
						WHERE Isnull(RecordDeleted, 'N') = 'N'
							AND Convert(DATETIME, IR.EffectiveFrom, 101) <= Convert(DATETIME, @EffectiveFrom, 101)
							AND (
								Convert(DATETIME, IR.EffectiveTo, 101) >= Convert(DATETIME, @EffectiveFrom, 101)
								OR Convert(DATETIME, IR.EffectiveTo, 101) IS NULL
								)
							--5/26/2006  Exclude Contract Rates (which already have included in first condition)   
							AND BillingCodes.CodeName LIKE '%' + @CodeName + '%'
						
						UNION
						
						SELECT BillingCodeId
						FROM ContractRates AS cr
						LEFT JOIN ContractRateSites CRS ON CR.ContractRateId = CRS.ContractRateId
							AND ISNULL(CRS.RecordDeleted, 'N') = 'N'
						INNER JOIN Contracts c ON cr.contractId = c.ContractId
						WHERE (
								CR.StartDate IS NULL
								OR CR.EndDate IS NULL
								OR Convert(DATETIME, CR.StartDate, 101) <= Convert(DATETIME, @EffectiveFrom, 101)
								AND Convert(DATETIME, CR.EndDate, 101) >= Convert(DATETIME, @EffectiveFrom, 101)
								)
							AND IsNull(CR.RecordDeleted, 'N') = 'N'
							AND IsNull(c.RecordDeleted, 'N') = 'N'
							AND CR.Active = 'Y'
							AND c.InsurerId = @InsurerId
							AND c.ProviderId = @ProviderId
							AND Convert(DATETIME, c.StartDate, 101) <= Convert(DATETIME, @EffectiveFrom, 101)
							AND (
								CRS.SiteId = @SiteId
								OR @SiteId IS NULL
								OR @SiteId = 0
								)
							AND IsNull(CRS.RecordDeleted, 'N') = 'N'
							AND (CR.ClientID = @ClientId)
							--5/26/2006 end           
						)
					AND BillingCodes.AllInsurers = 'Y' --4/12/2006    
					AND BillingCodes.CodeName LIKE '%' + @CodeName + '%'
					AND (
						@Active = '-1'
						OR BillingCodes.Active = @Active
						)
				
				UNION --4/12/2006 (To get records for only valid Insuers)            
				
				SELECT '0' AS 'CheckBox'
					,BillingCodes.BillingCodeId
					,BillingCodes.BillingCode AS 'Code'
					,BillingCodes.CodeName AS 'Name'
					,Convert(VARCHAR(100), convert(BIGINT, BillingCodes.Units)) + ' ' + GlobalCodes.CodeName AS 'Rate Unit'
					,NULL AS 'Payable Rate'
					,'' AS 'Medicaid Code'
					,NULL AS 'Modifier 1'
					,NULL AS 'Modifier 2'
					,NULL AS 'Modifier 3'
					,NULL AS 'Modifier 4'
					,NULL AS 'StartDate'
					,NULL AS 'EndDate'
					,'N' AS 'IsInsurer'
					,0 AS 'InsurerRateId'
					,0 AS BillingCodeRateId
					,BillingCodes.Active
					,Cast(NULL AS DECIMAL) AS NewRate
					,cast(NULL AS DATETIME) AS NewDate
					,'0' AS 'Button EndDate'
					,0 AS InsurerId
				    ,BCM.StartDate AS BCMStartDate --30.01.2019  Arun K R 
					,BCM.EndDate AS BCMEndDate
					,BCM.Active AS BCMActive
					,BCM.BillingCodeModifierId
				--,BillingCodes.Units,BillingCodes.UnitType,BillingCodes.ReportingUnits,BillingCodes.ReportingUnitType --3/8/2006           
				FROM BillingCodes
				INNER JOIN GlobalCodes ON BillingCodes.UnitType = GlobalCodes.GlobalCodeId
					AND IsNull(GlobalCodes.RecordDeleted, 'N') = 'N'
				INNER JOIN BillingCodeValidInsurers AS bcv ON bcv.BillingCodeId = BillingCodes.BillingCodeId
					AND bcv.InsurerId = @InsurerId
					AND IsNull(bcv.RecordDeleted, 'N') = 'N'
				LEFT JOIN BillingCodeModifiers BCM ON BCM.BillingCodeId=BillingCodes.BillingCodeId AND ISNULL(BCM.RecordDeleted,'N')='N'
				WHERE BillingCodes.Active = 'Y'
					AND IsNull(BillingCodes.RecordDeleted, 'N') = 'N'
					AND BillingCodes.BillingCodeId NOT IN (
						SELECT BillingCodeId
						FROM BillingCodeRates AS BCR
						WHERE Isnull(RecordDeleted, 'N') = 'N'
							AND Convert(DATETIME, BCR.EffectiveFrom, 101) <= Convert(DATETIME, @EffectiveFrom, 101)
							AND (
								Convert(DATETIME, BCR.EffectiveTo, 101) >= Convert(DATETIME, @EffectiveFrom, 101)
								OR Convert(DATETIME, BCR.EffectiveTo, 101) IS NULL
								)
							AND BillingCodes.CodeName LIKE '%' + @CodeName + '%'
						
						UNION
						
						SELECT BillingCodeId
						FROM InsurerRates AS IR
						WHERE Isnull(RecordDeleted, 'N') = 'N'
							AND Convert(DATETIME, IR.EffectiveFrom, 101) <= Convert(DATETIME, @EffectiveFrom, 101)
							AND (
								Convert(DATETIME, IR.EffectiveTo, 101) >= Convert(DATETIME, @EffectiveFrom, 101)
								OR Convert(DATETIME, IR.EffectiveTo, 101) IS NULL
								)
							--and IR.InsurerId=@InsurerId) --4/12/2006           
							AND IR.InsurerId = @InsurerId
							--5/31/2006           
						)
					AND BillingCodes.AllInsurers = 'N'
					AND BillingCodes.CodeName LIKE '%' + @CodeName + '%'
					AND (
						@Active = '-1'
						OR BillingCodes.Active = @Active
						)
				
				UNION
				
				--2/28/2006 (Code Added By Tarunjit singh To get data for Billing Codes which have no information in standard Rates and have data in  insurer rates not corresponding to insurer selected          
				SELECT '0' AS 'CheckBox'
					,BillingCodes.BillingCodeId
					,BillingCodes.BillingCode AS 'Code'
					,BillingCodes.CodeName AS 'Name'
					,Convert(VARCHAR(20), convert(INT, BillingCodes.Units)) + ' ' + GlobalCodes.CodeName AS 'Rate Unit'
					,NULL AS 'Payable Rate'
					,'' AS 'Medicaid Code'
					,NULL AS 'Modifier 1'
					,NULL AS 'Modifier 2'
					,NULL AS 'Modifier 3'
					,NULL AS 'Modifier 4'
					,NULL AS 'StartDate'
					,NULL AS 'EndDate'
					,'N' AS 'IsInsurer'
					,0 AS InsurerRateId
					,NULL AS BillingCodeRateId
					,BillingCodes.Active
					,Cast(NULL AS DECIMAL) AS NewRate
					,cast(NULL AS DATETIME) AS NewDate
					,'0' AS 'Button EndDate'
					,0 AS InsurerId
					,BCM.StartDate AS BCMStartDate --30.01.2019  Arun K R 
					,BCM.EndDate AS BCMEndDate
					,BCM.Active AS BCMActive
					,BCM.BillingCodeModifierId
				FROM dbo.BillingCodes
				INNER JOIN dbo.GlobalCodes ON dbo.BillingCodes.UnitType = dbo.GlobalCodes.GlobalCodeId
					AND IsNull(GlobalCodes.RecordDeleted, 'N') = 'N'
				LEFT JOIN BillingCodeModifiers BCM ON BCM.BillingCodeId=BillingCodes.BillingCodeId AND ISNULL(BCM.RecordDeleted,'N')='N'
				WHERE (dbo.BillingCodes.Active = 'Y')
					AND (ISNULL(dbo.BillingCodes.RecordDeleted, 'N') = 'N')
					AND (dbo.BillingCodes.AllInsurers = 'Y')
					AND (
						dbo.BillingCodes.BillingCodeId NOT IN (
							SELECT BillingCodeId
							FROM BillingCodeRates
							WHERE ISnull(RecordDeleted, 'N') = 'N'
							)
						)
					AND (
						dbo.BillingCodes.BillingCodeId IN (
							SELECT BillingCodeId
							FROM InsurerRates AS IR
							WHERE ISnull(RecordDeleted, 'N') = 'N'
								AND InsurerID <> @InsurerId
								--3/7/2006           
								AND Convert(DATETIME, IR.EffectiveFrom, 101) <= Convert(DATETIME, @EffectiveFrom, 101)
								AND (
									Convert(DATETIME, IR.EffectiveTo, 101) >= Convert(DATETIME, @EffectiveFrom, 101)
									OR Convert(DATETIME, IR.EffectiveTo, 101) IS NULL
									)
								AND BillingCodeId NOT IN (
									SELECT BillingCodeId
									FROM InsurerRates
									WHERE InsurerId = @InsurerId
										AND ISnull(RecordDeleted, 'N') = 'N'
									)
								AND BillingCodes.CodeName LIKE '%' + @CodeName + '%'
							)
						)
					AND (
						@Active = '-1'
						OR BillingCodes.Active = @Active
						)
			END

			IF @CustomFiltersApplied = 'Y'
			BEGIN
				SET @str = @str + '  Where isNull(c.RecordDeleted,''N'')<>''Y'' and exists(select * from #CustomFilters cf where cf.ClientId = c.ClientId)'
			END
			ELSE
				SET @str = @str + '  Where isNull(c.RecordDeleted,''N'')<>''Y'' '

			SET @str = @str + 'AND CodeName like' + '%' + @CodeName + '%'

			EXECUTE SP_EXECUTESQL @str

			UPDATE #BillingCodestemp
			SET [Medicaid Code] = (
					SELECT TOP 1 MB.MedicaidCode
					FROM MedicaidBillingCodes MB
					WHERE MB.BillingCodeId = #BillingCodesTemp.BillingCodeId
						AND IsNull(mb.RecordDeleted, 'N') = 'N'
						--Check Effective date for Medicaid code 3/13/2006           
						AND Convert(DATETIME, MB.EffectiveFrom, 101) <= Convert(DATETIME, @EffectiveFrom, 101)
						AND (
							Convert(DATETIME, MB.EffectiveTo, 101) >= Convert(DATETIME, @EffectiveFrom, 101)
							OR Convert(DATETIME, MB.EffectiveTo, 101) IS NULL
							)
					ORDER BY MedicaidProcedureId DESC
					)
		END;

		WITH counts
		AS (
			SELECT COUNT(*) AS TotalRows
			FROM #billingcodestemp
			)
			,listbanners
		AS (
			SELECT BillingCodeId
				,[Code]
				,[Name]
				,[Rate Unit]
				,[Payable Rate]
				,[Medicaid Code]
				,[Modifier 1]
				,[Modifier 2]
				,[Modifier 3]
				,[Modifier 4]
				,[BCMStartDate] --30.01.2019  Arun K R 
				,[BCMEndDate]
				,[BCMActive]
				,COUNT(*) OVER () AS TotalCount
				,RANK() OVER (
					ORDER BY CASE 
							WHEN @SortExpression = 'Code'
								THEN Code
							END
						,CASE 
							WHEN @SortExpression = 'Code desc'
								THEN Code
							END DESC
						,CASE 
							WHEN @SortExpression = 'Name'
								THEN NAME
							END
						,CASE 
							WHEN @SortExpression = 'Name desc'
								THEN NAME
							END DESC
						,CASE 
							WHEN @SortExpression = 'RateUnit'
								THEN [Rate Unit]
							END
						,CASE 
							WHEN @SortExpression = 'RateUnit desc'
								THEN [Rate Unit]
							END DESC
						,CASE 
							WHEN @SortExpression = 'PayableRate'
								THEN [Payable Rate]
							END
						,CASE 
							WHEN @SortExpression = 'PayableRate desc'
								THEN [Payable Rate]
							END DESC
						,CASE 
							WHEN @SortExpression = 'MedicaidCode'
								THEN [Medicaid Code]
							END
						,CASE 
							WHEN @SortExpression = 'MedicaidCode desc'
								THEN [Medicaid Code]
							END DESC
						,CASE 
							WHEN @SortExpression = 'Modifier1'
								THEN [Modifier 1]
							END
						,CASE 
							WHEN @SortExpression = 'Modifier1 desc'
								THEN [Modifier 1]
							END DESC
						,CASE 
							WHEN @SortExpression = 'Modifier2'
								THEN [Modifier 2]
							END
						,CASE 
							WHEN @SortExpression = 'Modifier2 desc'
								THEN [Modifier 2]
							END DESC
						,CASE 
							WHEN @SortExpression = 'Modifier3'
								THEN [Modifier 3]
							END
						,CASE 
							WHEN @SortExpression = 'Modifier3 desc'
								THEN [Modifier 3]
							END DESC
						,CASE 
							WHEN @SortExpression = 'Modifier4'
								THEN [Modifier 4]
							END
						,CASE 
							WHEN @SortExpression = 'Modifier4 desc'
								THEN [Modifier 4]
							END DESC
						,CASE 
							WHEN @SortExpression = 'StartDate'
								THEN [BCMStartDate]
							END
						,CASE 
							WHEN @SortExpression = 'StartDate desc'
								THEN [BCMStartDate]
							END DESC
						,CASE 
							WHEN @SortExpression = 'EndDate'
								THEN [BCMEndDate]
							END
						,CASE 
							WHEN @SortExpression = 'EndDate desc'
								THEN [BCMEndDate]
							END DESC
						,CASE 
							WHEN @SortExpression = 'Active'
								THEN [BCMActive]
							END
						,CASE 
							WHEN @SortExpression = 'Active desc'
								THEN [BCMActive]
							END DESC
						,BillingCodeId
					) AS RowNumber
			FROM #BillingCodestemp
			)
		SELECT TOP (
				CASE 
					WHEN (@PageNumber = - 1)
						THEN (
								SELECT ISNULL(totalrows, 0)
								FROM Counts
								)
					ELSE (@PageSize)
					END
				) BillingCodeId
			,[Code]
			,[Name]
			,[Rate Unit]
			,[Payable Rate]
			,[Medicaid Code]
			,[Modifier 1]
			,[Modifier 2]
			,[Modifier 3]
			,[Modifier 4]
			,[BCMStartDate] --30.01.2019  Arun K R 
			,[BCMEndDate]
			,[BCMActive]
			,TotalCount
			,RowNumber
		INTO #finalresultset
		FROM ListBanners
		WHERE RowNumber > ((@PageNumber - 1) * @PageSize)

		DECLARE @BillingCodeIds VARCHAR(max);

		SELECT @BillingCodeIds = COALESCE(@BillingCodeIds + ',', '') + CAST(bc.BillingCodeId AS VARCHAR)
		FROM #BillingCodestemp bc

		IF (
				SELECT ISNULL(COUNT(*), 0)
				FROM #finalresultset
				) < 1
		BEGIN
			SELECT 0 AS PageNumber
				,0 AS NumberOfPages
				,0 NumberOfRows
				,'' AS BillingCodeIds
		END
		ELSE
		BEGIN
			SELECT TOP 1 @PageNumber AS PageNumber
				,CASE (TotalCount % @PageSize)
					WHEN 0
						THEN ISNULL((TotalCount / @PageSize), 0)
					ELSE ISNULL((TotalCount / @PageSize), 0) + 1
					END AS NumberOfPages
				,ISNULL(totalcount, 0) AS NumberOfRows
				,@BillingCodeIds AS BillingCodeIds
			FROM #FinalResultSet
		END

		SELECT BillingCodeId
			,[Code]
			,[Name]
			,[Rate Unit]
			,[Payable Rate]
			,[Medicaid Code]
			,[Modifier 1]
			,[Modifier 2]
			,[Modifier 3]
			,[Modifier 4]
			,CONVERT(VARCHAR,[BCMStartDate], 101) AS BCMStartDate  --30.01.2019  Arun K R 
			,CONVERT(VARCHAR,[BCMEndDate], 101) AS BCMEndDate 
			,[BCMActive]
		FROM #finalresultset
		ORDER BY RowNumber
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_ListPageCMGetBillingCodes') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,
				-- Message text.                                                                                                          
				16
				,
				-- Severity.                                                                                                          
				1
				-- State.                                                                                                          
				);
	END CATCH
END
GO


