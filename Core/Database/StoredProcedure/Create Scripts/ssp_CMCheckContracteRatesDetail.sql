IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMCheckContracteRatesDetail]')
			AND type IN (N'P', N'PC')
		)
	DROP PROCEDURE [dbo].[ssp_CMCheckContracteRatesDetail]
GO

IF EXISTS (
		SELECT *
		FROM sys.types st
		INNER JOIN sys.schemas ss ON st.schema_id = ss.schema_id
		WHERE st.NAME = N'ContractRateSitesType'
			AND ss.NAME = N'dbo'
		)
	DROP type [dbo].[ContractRateSitesType]
GO

CREATE type [dbo].[ContractRateSitesType] AS TABLE (
	[ContractRateSiteId] [Int] NULL
	,[SiteId] [Int] NULL
	,[ContractRateId] [Int] NULL
	,[RecordDeleted] [Type_yorn] NULL
	)
GO

IF EXISTS (
		SELECT *
		FROM sys.types st
		INNER JOIN sys.schemas ss ON st.schema_id = ss.schema_id
		WHERE st.NAME = N'ContractRateCoveragePlansType'
			AND ss.NAME = N'dbo'
		)
	DROP type [dbo].[ContractRateCoveragePlansType]
GO

CREATE type [dbo].[ContractRateCoveragePlansType] AS TABLE (
	[ContractRateCoveragePlanId] [Int] NULL
	,[RecordDeleted] [Dbo].[Type_yorn] NULL
	,[ContractRateId] [Int] NULL
	,[CoveragePlanId] [Int] NULL
	)
GO

IF EXISTS (
		SELECT *
		FROM sys.types st
		INNER JOIN sys.schemas ss ON st.schema_id = ss.schema_id
		WHERE st.NAME = N'ContractRateLicenseTypesType'
			AND ss.NAME = N'dbo'
		)
	DROP type [dbo].[ContractRateLicenseTypesType]
GO

CREATE type [dbo].[ContractRateLicenseTypesType] AS TABLE (
	[ContractRateLicenseTypeId] [Int] NULL
	,[RecordDeleted] [Dbo].[Type_yorn] NULL
	,[ContractRateId] [Int] NULL
	,[LicenseTypeId] [Dbo].[Type_globalcode] NULL
	)
GO

IF EXISTS (
		SELECT *
		FROM sys.types st
		INNER JOIN sys.schemas ss ON st.schema_id = ss.schema_id
		WHERE st.NAME = N'ContractRatePlaceOfServicesType'
			AND ss.NAME = N'dbo'
		)
	DROP type [dbo].[ContractRatePlaceOfServicesType]
GO

CREATE type [dbo].[ContractRatePlaceOfServicesType] AS TABLE (
	[ContractRatePlaceOfServiceId] [Int] NULL
	,[RecordDeleted] [Dbo].[Type_yorn] NULL
	,[ContractRateId] [Int] NULL
	,[PlaceOfServiceId] [Dbo].[Type_globalcode] NULL
	)
GO

IF EXISTS (
		SELECT *
		FROM sys.types st
		INNER JOIN sys.schemas ss ON st.schema_id = ss.schema_id
		WHERE st.NAME = N'ContractRatesType'
			AND ss.NAME = N'dbo'
		)
	DROP type [dbo].[ContractRatesType]
GO

CREATE type [dbo].[ContractRatesType] AS TABLE (
	[ContractRateId] [Int] NULL
	,[ContractId] [Int] NULL
	,[BillingCodeId] [Int] NULL
	,[Modifier1] [Varchar](10) NULL
	,[Modifier2] [Varchar](10) NULL
	,[Modifier3] [Varchar](10) NULL
	,[Modifier4] [Varchar](10) NULL
	,[SiteId] [Int] NULL
	,[ClientId] [Int] NULL
	,[StartDate] [Datetime] NULL
	,[EndDate] [Datetime] NULL
	,[ContractRate] [Money] NULL
	,[Active] CHAR(1) NULL
	,[RequiresAffilatedProvider] [Dbo].[Type_yorn] NULL
	,[AllAffiliatedProviders] [Dbo].[Type_yorn] NULL
	,[Recorddeleted] [Dbo].[Type_yorn] NULL
	,[Requiresaffilatedproviderdummy] VARCHAR(3) NULL
	,[Rateunit] [Varchar](Max) NULL
	,[Codeandmodifiers] [Varchar](Max) NULL
	,[Billingcodename] [Varchar](Max) NULL
	,[Clientidtext] [Varchar](Max) NULL
	,[Siteidtext] [Varchar](Max) NULL
	,[Contractrate1] [Varchar](Max) NULL
	,[Billingcodemodifierid] [Varchar](Max) NULL
	,[Startdate1] [Varchar](Max) NULL
	,[Enddate1] [Varchar](Max) NULL
	,[AllSites] [Varchar](Max) NULL
	,[Alllicensetypes] [Varchar](Max) NULL
	,[Allplaceofservices] [Varchar](Max) NULL
	,[Insurerid] [Int] NULL
	,[Placeofserviceid] [Int] NULL
	,[Licensetypeidtext] [Varchar](Max) NULL
	,[Placeofserviceidtext] [Varchar](Max) NULL
	,[LicenseTypeGroupName] [Varchar](250) NULL
	,[PlaceOfServiceGroupName] [Varchar](250) NULL
	,[CoveragePlanGroupName] [Varchar](Max) NULL
	,[Dummybillingcodemodifiername] [Varchar](Max) NULL
	)
GO

IF EXISTS (
		SELECT *
		FROM sys.types st
		INNER JOIN sys.schemas ss ON st.schema_id = ss.schema_id
		WHERE st.NAME = N'ContractRateAffiliatesType'
			AND ss.NAME = N'dbo'
		)
	DROP type [dbo].[ContractRateAffiliatesType]
GO

CREATE type [dbo].[ContractRateAffiliatesType] AS TABLE (
	[ContractRateAffiliateId] [int] NULL
	,[ProviderId] [int] NOT NULL
	,[ContractRateId] [int] NOT NULL
	,[RecordDeleted] [Dbo].[Type_yorn] NULL
	)
GO

CREATE PROCEDURE [dbo].[ssp_CMCheckContracteRatesDetail] (
	@ContractId INT
	,@BillingCodeId INT
	,@Modifier1 VARCHAR(10)
	,@Modifier2 VARCHAR(10)
	,@Modifier3 VARCHAR(10)
	,@Modifier4 VARCHAR(10)
	,@StartDate DATETIME
	,@EndDate DATETIME
	,@ClientId INT
	,@tblContractRateSites ContractRateSitesType READONLY
	,@tblContractRateCoveragePlans ContractRateCoveragePlansType READONLY
	,@tblContractRateLicenseTypes ContractRateLicenseTypesType READONLY
	,@tblContractRatePlaceOfServices ContractRatePlaceOfServicesType READONLY
	,@tblContractRates ContractRatesType READONLY
	,@tblContractRateAffiliates ContractRateAffiliatesType READONLY
	)
AS
SET NOCOUNT ON

-----------------------------------------------------------  
-- Stored Procedure: ssp_CMCheckContracteRatesDetail  
-- Copyright: Streamline Healthcare Solutions  
/* Date              Author                 Purpose                 */
/* 07/19/2017        K.Soujanya             Get the Contracted rates detail to check duplicates why:Network180-Enhancements #219       */
-- History  
--16 May 2018        K.Soujanya             Added Client Id, Start Date and End Date along with Billing Code and modifier combination to check duplicate BillingCode Modifier combination. Task#CEI - Support Go Live ,Task#967
--07/24/2018         Hemant                 The additional logic has been added to check all the combinations with Sites, License Group, Place of Service and Affiliates when we are checking the duplicate combinations. SWMBH - Enhancements: #557
-----------------------------------------------------------     
BEGIN
	BEGIN TRY
		DECLARE @ProviderId INT;
		DECLARE @_ContractRateId AS INT;
		DECLARE @_tblContractRateSitesCount INT;
		DECLARE @_ContractRateSitesFinalListCount INT;
		DECLARE @_ContractRateCoveragePlansListCount INT;
		DECLARE @_tblContractRateCoveragePlansCount INT;
		DECLARE @_tblContractRateLicenseTypesCount INT;
		DECLARE @_ContractRateLicenseTypesCount INT;
		DECLARE @_tblContractRatePlaceOfServicesCount INT;
		DECLARE @_ContractRatePlaceOfServicesListCount INT;
		DECLARE @_ContractRateAffiliateListCount INT;
		DECLARE @_tblContractRateAffiliateCount INT;
		DECLARE @ContractRateDetailsCursor AS CURSOR;
		DECLARE @ContractRatesFinalListCount INT;

		SELECT @ProviderId = ProviderId
		FROM Contracts
		WHERE ContractId = @ContractId;

		IF OBJECT_ID('tempdb..#ContractRatesFinalList') IS NOT NULL
		BEGIN
			DROP TABLE [dbo].#ContractRatesFinalList
		END

		IF OBJECT_ID('tempdb..#ContractRateSitesFinalList') IS NOT NULL
		BEGIN
			DROP TABLE [dbo].#ContractRateSitesFinalList
		END

		IF OBJECT_ID('tempdb..#ContractRateCoveragePlansList') IS NOT NULL
		BEGIN
			DROP TABLE [dbo].#ContractRateCoveragePlansList
		END

		IF OBJECT_ID('tempdb..#ContractRateLicenseTypesList') IS NOT NULL
		BEGIN
			DROP TABLE [dbo].#ContractRateLicenseTypesList
		END

		IF OBJECT_ID('tempdb..#ContractRatePlaceOfServicesList') IS NOT NULL
		BEGIN
			DROP TABLE [dbo].#ContractRatePlaceOfServicesList
		END

		IF OBJECT_ID('tempdb..#ContractRateAffiliatesList') IS NOT NULL
		BEGIN
			DROP TABLE [dbo].#ContractRateAffiliatesList
		END

		CREATE TABLE [dbo].#ContractRatesFinalList (
			[ContractRateId] [int] IDENTITY(1, 1) NOT NULL
			,[ContractId] [int] NOT NULL
			,[BillingCodeId] [int] NOT NULL
			,[Modifier1] [varchar](10) NULL
			,[Modifier2] [varchar](10) NULL
			,[Modifier3] [varchar](10) NULL
			,[Modifier4] [varchar](10) NULL
			,[ClientId] [int] NULL
			,[StartDate] [datetime] NULL
			,[EndDate] [datetime] NULL
			,[RecordDeleted] [char](1) NULL
			,[AllAffiliatedProviders] [char](1) NULL
			,[AllSites] [char](1) NULL
			,[AllCoveragePlans] [char](1) NULL
			,[AllContractRateLicenseTypes] [char](1) NULL
			,[AllContractRatePlaceOfServices] [char](1) NULL
			)

		CREATE TABLE [dbo].#ContractRateSitesFinalList (
			[ContractRateSiteId] [int] IDENTITY(1, 1) NOT NULL
			,[ContractRateId] [int] NULL
			,[SiteId] [int] NULL
			,[Recorddeleted] [char](1) NULL
			)

		CREATE TABLE [dbo].#ContractRateCoveragePlansList (
			[ContractRateCoveragePlanId] [int] IDENTITY(1, 1) NOT NULL
			,[ContractRateId] [int] NOT NULL
			,[CoveragePlanId] [int] NOT NULL
			,[Recorddeleted] [char](1) NULL
			)

		CREATE TABLE [dbo].#ContractRateLicenseTypesList (
			[ContractRateLicenseTypeId] [int] IDENTITY(1, 1) NOT NULL
			,[ContractRateId] [int] NOT NULL
			,[LicenseTypeId] [int] NULL
			,[Recorddeleted] [char](1) NULL
			)

		CREATE TABLE [dbo].#ContractRatePlaceOfServicesList (
			[ContractRatePlaceOfServiceId] [int] IDENTITY(1, 1) NOT NULL
			,[ContractRateId] [int] NOT NULL
			,[PlaceOfServiceId] [int] NULL
			,[Recorddeleted] [char](1) NULL
			)

		CREATE TABLE [dbo].#ContractRateAffiliatesList (
			[ContractRateAffiliateId] [int] PRIMARY KEY IDENTITY(1, 1) NOT NULL
			,[ProviderId] [int] NOT NULL
			,[ContractRateId] [int] NOT NULL
			,[Recorddeleted] [char](1) NULL
			)

		SET IDENTITY_INSERT [dbo].#ContractRatesFinalList ON

		INSERT INTO #ContractRatesFinalList (
			Contractrateid
			,Contractid
			,Billingcodeid
			,Modifier1
			,Modifier2
			,Modifier3
			,Modifier4
			,Clientid
			,Startdate
			,Enddate
			,Recorddeleted
			,AllAffiliatedProviders
			)
		SELECT [Contractrateid]
			,[Contractid]
			,[Billingcodeid]
			,[Modifier1]
			,[Modifier2]
			,[Modifier3]
			,[Modifier4]
			,[Clientid]
			,CAST([Startdate] AS DATE)
			,CAST([Enddate] AS DATE)
			,[Recorddeleted]
			,[AllAffiliatedProviders]
		FROM ContractRates CR
		WHERE CR.ContractId = @ContractId
			AND CR.BillingCodeId = @BillingCodeId
			AND (
				(
					@Modifier1 IS NULL
					AND CR.Modifier1 IS NULL
					)
				OR ISNULL(CR.Modifier1, '') = @Modifier1
				)
			AND (
				(
					@Modifier2 IS NULL
					AND CR.Modifier2 IS NULL
					)
				OR ISNULL(CR.Modifier2, '') = @Modifier2
				)
			AND (
				(
					@Modifier3 IS NULL
					AND CR.Modifier3 IS NULL
					)
				OR ISNULL(CR.Modifier3, '') = @Modifier3
				)
			AND (
				(
					@Modifier4 IS NULL
					AND CR.Modifier4 IS NULL
					)
				OR ISNULL(CR.Modifier4, '') = @Modifier4
				)
			AND (
				(
					@ClientId = 0
					AND CR.ClientId IS NULL
					)
				OR CR.ClientId = @ClientId
				)
			AND (
				(
					@StartDate IS NULL
					AND CR.StartDate IS NULL
					)
				OR CAST(CR.StartDate AS DATE) = CAST(@StartDate AS DATE)
				)
			AND (
				(
					@EndDate IS NULL
					AND CR.EndDate IS NULL
					)
				OR CAST(CR.EndDate AS DATE) = CAST(@EndDate AS DATE)
				)
			AND ISNULL(CR.RecordDeleted, 'N') = 'N'

		MERGE INTO #ContractRatesFinalList AS T
		USING (
			SELECT [Contractrateid]
				,[Contractid]
				,[Billingcodeid]
				,[Modifier1]
				,[Modifier2]
				,[Modifier3]
				,[Modifier4]
				,[Siteid]
				,[Clientid]
				,CAST([Startdate] AS DATE) AS 'Startdate'
				,CAST([Enddate] AS DATE) AS 'Enddate'
				,[Recorddeleted]
				,[AllAffiliatedProviders]
			FROM @tblContractRates
			WHERE ContractId = @ContractId
				AND BillingCodeId = @BillingCodeId
				AND (
					(
						@Modifier1 IS NULL
						AND Modifier1 IS NULL
						)
					OR ISNULL(Modifier1, '') = @Modifier1
					)
				AND (
					(
						@Modifier2 IS NULL
						AND Modifier2 IS NULL
						)
					OR ISNULL(Modifier2, '') = @Modifier2
					)
				AND (
					(
						@Modifier3 IS NULL
						AND Modifier3 IS NULL
						)
					OR ISNULL(Modifier3, '') = @Modifier3
					)
				AND (
					(
						@Modifier4 IS NULL
						AND Modifier4 IS NULL
						)
					OR ISNULL(Modifier4, '') = @Modifier4
					)
				AND (
					(
						@ClientId = 0
						AND ClientId IS NULL
						)
					OR ClientId = @ClientId
					)
				AND (
					(
						@StartDate IS NULL
						AND StartDate IS NULL
						)
					OR CAST(StartDate AS DATE) = CAST(@StartDate AS DATE)
					)
				AND (
					(
						@EndDate IS NULL
						AND EndDate IS NULL
						)
					OR CAST(EndDate AS DATE) = CAST(@EndDate AS DATE)
					)
				AND ISNULL(RecordDeleted, 'N') = 'N'
			) AS S
			ON T.Contractrateid = S.Contractrateid
		WHEN MATCHED
			THEN
				UPDATE
				SET T.[Contractid] = S.[Contractid]
					,T.[Billingcodeid] = S.[Billingcodeid]
					,T.[Modifier1] = S.[Modifier1]
					,T.[Modifier2] = S.[Modifier2]
					,T.[Modifier3] = S.[Modifier3]
					,T.[Modifier4] = S.[Modifier4]
					,T.[Clientid] = S.[Clientid]
					,T.[Startdate] = S.[Startdate]
					,T.[Enddate] = S.[Enddate]
					,T.[Recorddeleted] = S.[Recorddeleted]
					,T.[AllAffiliatedProviders] = S.[AllAffiliatedProviders]
		WHEN NOT MATCHED
			THEN
				INSERT (
					Contractrateid
					,Contractid
					,Billingcodeid
					,Modifier1
					,Modifier2
					,Modifier3
					,Modifier4
					,Clientid
					,Startdate
					,Enddate
					,Recorddeleted
					,AllAffiliatedProviders
					)
				VALUES (
					S.Contractrateid
					,S.Contractid
					,S.Billingcodeid
					,S.Modifier1
					,S.Modifier2
					,S.Modifier3
					,S.Modifier4
					,S.Clientid
					,S.Startdate
					,S.Enddate
					,S.Recorddeleted
					,S.AllAffiliatedProviders
					);

		SET IDENTITY_INSERT [dbo].#ContractRatesFinalList OFF

		UPDATE [dbo].#ContractRatesFinalList
		SET ClientID = 0
		WHERE ClientID IS NULL

		SET IDENTITY_INSERT [dbo].#ContractRateSitesFinalList ON

		INSERT INTO [dbo].#ContractRateSitesFinalList (
			ContractRateSiteId
			,ContractRateId
			,SiteId
			,Recorddeleted
			)
		SELECT [ContractRateSiteId]
			,[ContractRateId]
			,[SiteId]
			,[Recorddeleted]
		FROM ContractRateSites CRS
		WHERE CRS.ContractRateId IN (
				SELECT DISTINCT [Contractrateid]
				FROM [dbo].#ContractRatesFinalList
				)
			AND ISNULL(CRS.RecordDeleted, 'N') = 'N'

		MERGE INTO [dbo].#ContractRateSitesFinalList AS T1
		USING (
			SELECT [ContractRateSiteId]
				,[ContractRateId]
				,[SiteId]
				,[Recorddeleted]
			FROM @tblContractRateSites
			WHERE ContractRateId IN (
					SELECT DISTINCT [Contractrateid]
					FROM [dbo].#ContractRatesFinalList
					)
			) AS S1
			ON T1.ContractRateSiteId = S1.ContractRateSiteId
		WHEN MATCHED
			THEN
				UPDATE
				SET T1.[ContractRateId] = S1.[ContractRateId]
					,T1.[SiteId] = S1.[SiteId]
					,T1.[Recorddeleted] = S1.[Recorddeleted]
		WHEN NOT MATCHED
			THEN
				INSERT (
					ContractRateSiteId
					,ContractRateId
					,SiteId
					,Recorddeleted
					)
				VALUES (
					S1.ContractRateSiteId
					,S1.ContractRateId
					,S1.SiteId
					,S1.Recorddeleted
					);

		SET IDENTITY_INSERT [dbo].#ContractRateSitesFinalList OFF
		SET IDENTITY_INSERT [dbo].#ContractRateCoveragePlansList ON

		INSERT INTO [dbo].#ContractRateCoveragePlansList (
			ContractRateCoveragePlanId
			,RecordDeleted
			,ContractRateId
			,CoveragePlanId
			)
		SELECT [ContractRateCoveragePlanId]
			,[RecordDeleted]
			,[ContractRateId]
			,[CoveragePlanId]
		FROM ContractRateCoveragePlans CRCP
		WHERE CRCP.ContractRateId IN (
				SELECT DISTINCT [Contractrateid]
				FROM [dbo].#ContractRatesFinalList
				)
			AND ISNULL(CRCP.RecordDeleted, 'N') = 'N'

		MERGE INTO [dbo].#ContractRateCoveragePlansList AS T2
		USING (
			SELECT [ContractRateCoveragePlanId]
				,[RecordDeleted]
				,[ContractRateId]
				,[CoveragePlanId]
			FROM @tblContractRateCoveragePlans
			WHERE ContractRateId IN (
					SELECT DISTINCT [Contractrateid]
					FROM [dbo].#ContractRatesFinalList
					)
			) AS S2
			ON T2.ContractRateCoveragePlanId = S2.ContractRateCoveragePlanId
		WHEN MATCHED
			THEN
				UPDATE
				SET T2.[ContractRateId] = S2.[ContractRateId]
					,T2.[CoveragePlanId] = S2.[CoveragePlanId]
					,T2.[Recorddeleted] = S2.[Recorddeleted]
		WHEN NOT MATCHED
			THEN
				INSERT (
					ContractRateCoveragePlanId
					,RecordDeleted
					,ContractRateId
					,CoveragePlanId
					)
				VALUES (
					S2.ContractRateCoveragePlanId
					,S2.RecordDeleted
					,S2.ContractRateId
					,S2.CoveragePlanId
					);

		SET IDENTITY_INSERT [dbo].#ContractRateCoveragePlansList OFF
		SET IDENTITY_INSERT [dbo].#ContractRateLicenseTypesList ON

		INSERT INTO [dbo].#ContractRateLicenseTypesList (
			ContractRateLicenseTypeId
			,RecordDeleted
			,ContractRateId
			,LicenseTypeId
			)
		SELECT [ContractRateLicenseTypeId]
			,[RecordDeleted]
			,[ContractRateId]
			,[LicenseTypeId]
		FROM ContractRateLicenseTypes CRLT
		WHERE CRLT.ContractRateId IN (
				SELECT DISTINCT [Contractrateid]
				FROM [dbo].#ContractRatesFinalList
				)
			AND ISNULL(CRLT.RecordDeleted, 'N') = 'N'

		MERGE INTO [dbo].#ContractRateLicenseTypesList AS T3
		USING (
			SELECT [ContractRateLicenseTypeId]
				,[RecordDeleted]
				,[ContractRateId]
				,[LicenseTypeId]
			FROM @tblContractRateLicenseTypes
			WHERE ContractRateId IN (
					SELECT DISTINCT [Contractrateid]
					FROM [dbo].#ContractRatesFinalList
					)
			) AS S3
			ON T3.ContractRateLicenseTypeId = S3.ContractRateLicenseTypeId
		WHEN MATCHED
			THEN
				UPDATE
				SET T3.[ContractRateId] = S3.[ContractRateId]
					,T3.[LicenseTypeId] = S3.[LicenseTypeId]
					,T3.[Recorddeleted] = S3.[Recorddeleted]
		WHEN NOT MATCHED
			THEN
				INSERT (
					ContractRateLicenseTypeId
					,RecordDeleted
					,ContractRateId
					,LicenseTypeId
					)
				VALUES (
					S3.ContractRateLicenseTypeId
					,S3.RecordDeleted
					,S3.ContractRateId
					,S3.LicenseTypeId
					);

		SET IDENTITY_INSERT [dbo].#ContractRateLicenseTypesList OFF
		SET IDENTITY_INSERT [dbo].#ContractRatePlaceOfServicesList ON

		INSERT INTO [dbo].#ContractRatePlaceOfServicesList (
			ContractRatePlaceOfServiceId
			,RecordDeleted
			,ContractRateId
			,PlaceOfServiceId
			)
		SELECT [ContractRatePlaceOfServiceId]
			,[RecordDeleted]
			,[ContractRateId]
			,[PlaceOfServiceId]
		FROM ContractRatePlaceOfServices CRPOS
		WHERE CRPOS.ContractRateId IN (
				SELECT DISTINCT [Contractrateid]
				FROM [dbo].#ContractRatesFinalList
				)
			AND ISNULL(CRPOS.RecordDeleted, 'N') = 'N'

		MERGE INTO [dbo].#ContractRatePlaceOfServicesList AS T4
		USING (
			SELECT [ContractRatePlaceOfServiceId]
				,[RecordDeleted]
				,[ContractRateId]
				,[PlaceOfServiceId]
			FROM @tblContractRatePlaceOfServices
			WHERE ContractRateId IN (
					SELECT DISTINCT [Contractrateid]
					FROM [dbo].#ContractRatesFinalList
					)
			) AS S4
			ON T4.ContractRatePlaceOfServiceId = S4.ContractRatePlaceOfServiceId
		WHEN MATCHED
			THEN
				UPDATE
				SET T4.[ContractRateId] = S4.[ContractRateId]
					,T4.[PlaceOfServiceId] = S4.[PlaceOfServiceId]
					,T4.[Recorddeleted] = S4.[Recorddeleted]
		WHEN NOT MATCHED
			THEN
				INSERT (
					ContractRatePlaceOfServiceId
					,RecordDeleted
					,ContractRateId
					,PlaceOfServiceId
					)
				VALUES (
					S4.ContractRatePlaceOfServiceId
					,S4.RecordDeleted
					,S4.ContractRateId
					,S4.PlaceOfServiceId
					);

		SET IDENTITY_INSERT [dbo].#ContractRatePlaceOfServicesList OFF
		SET IDENTITY_INSERT [dbo].#ContractRateAffiliatesList ON

		INSERT INTO [dbo].#ContractRateAffiliatesList (
			ContractRateAffiliateId
			,ProviderId
			,ContractRateId
			,RecordDeleted
			)
		SELECT ContractRateAffiliateId
			,ProviderId
			,ContractRateId
			,RecordDeleted
		FROM ContractRateAffiliates CRA
		WHERE CRA.ContractRateId IN (
				SELECT DISTINCT [Contractrateid]
				FROM [dbo].#ContractRatesFinalList
				)
			AND ISNULL(CRA.RecordDeleted, 'N') = 'N'

		MERGE INTO [dbo].#ContractRateAffiliatesList AS T5
		USING (
			SELECT [ContractRateAffiliateId]
				,[ProviderId]
				,[ContractRateId]
				,[RecordDeleted]
			FROM @tblContractRateAffiliates
			WHERE ContractRateId IN (
					SELECT DISTINCT [Contractrateid]
					FROM [dbo].#ContractRatesFinalList
					)
			) AS S5
			ON T5.ContractRateAffiliateId = S5.ContractRateAffiliateId
		WHEN MATCHED
			THEN
				UPDATE
				SET T5.[ProviderId] = S5.[ProviderId]
					,T5.[ContractRateId] = S5.[ContractRateId]
					,T5.[RecordDeleted] = S5.[RecordDeleted]
		WHEN NOT MATCHED
			THEN
				INSERT (
					ContractRateAffiliateId
					,ProviderId
					,ContractRateId
					,RecordDeleted
					)
				VALUES (
					S5.ContractRateAffiliateId
					,S5.ProviderId
					,S5.ContractRateId
					,S5.RecordDeleted
					);

		SET IDENTITY_INSERT [dbo].#ContractRateAffiliatesList OFF
		SET @ContractRateDetailsCursor = CURSOR
		FOR

		SELECT DISTINCT [Contractrateid]
		FROM [dbo].#ContractRatesFinalList

		BEGIN
			OPEN @ContractRateDetailsCursor;

			FETCH NEXT
			FROM @ContractRateDetailsCursor
			INTO @_ContractRateId;

			WHILE @@FETCH_STATUS = 0
			BEGIN
				SELECT @_ContractRateSitesFinalListCount = Count(ContractRateSiteId)
				FROM #ContractRateSitesFinalList
				WHERE ContractRateId = @_ContractRateId
					AND ISNULL(RecordDeleted, 'N') = 'N';

				SELECT @_tblContractRateSitesCount = Count(ContractRateSiteId)
				FROM @tblContractRateSites
				WHERE ContractRateId = @_ContractRateId
					AND ISNULL(RecordDeleted, 'N') = 'N';

				SELECT @_ContractRateCoveragePlansListCount = Count(ContractRateCoveragePlanId)
				FROM #ContractRateCoveragePlansList
				WHERE ContractRateId = @_ContractRateId
					AND ISNULL(RecordDeleted, 'N') = 'N';

				SELECT @_tblContractRateCoveragePlansCount = Count(ContractRateCoveragePlanId)
				FROM @tblContractRateCoveragePlans
				WHERE ContractRateId = @_ContractRateId
					AND ISNULL(RecordDeleted, 'N') = 'N';

				SELECT @_ContractRateLicenseTypesCount = Count(ContractRateLicenseTypeId)
				FROM #ContractRateLicenseTypesList
				WHERE ContractRateId = @_ContractRateId
					AND ISNULL(RecordDeleted, 'N') = 'N';

				SELECT @_tblContractRateLicenseTypesCount = Count(ContractRateLicenseTypeId)
				FROM @tblContractRateLicenseTypes
				WHERE ContractRateId = @_ContractRateId
					AND ISNULL(RecordDeleted, 'N') = 'N';

				SELECT @_ContractRatePlaceOfServicesListCount = Count(ContractRatePlaceOfServiceId)
				FROM #ContractRatePlaceOfServicesList
				WHERE ContractRateId = @_ContractRateId
					AND ISNULL(RecordDeleted, 'N') = 'N';

				SELECT @_tblContractRatePlaceOfServicesCount = Count(ContractRatePlaceOfServiceId)
				FROM @tblContractRatePlaceOfServices
				WHERE ContractRateId = @_ContractRateId
					AND ISNULL(RecordDeleted, 'N') = 'N';

				SELECT @_ContractRateAffiliateListCount = Count(ContractRateAffiliateId)
				FROM #ContractRateAffiliatesList
				WHERE ContractRateId = @_ContractRateId
					AND ISNULL(RecordDeleted, 'N') = 'N';

				SELECT @_tblContractRateAffiliateCount = Count(ContractRateAffiliateId)
				FROM @tblContractRateAffiliates
				WHERE ContractRateId = @_ContractRateId
					AND ISNULL(RecordDeleted, 'N') = 'N';

				IF (
						@_ContractRateSitesFinalListCount = 0
						AND @_tblContractRateSitesCount = 0
						)
				BEGIN
					INSERT INTO [dbo].#ContractRateSitesFinalList (
						ContractRateId
						,SiteId
						,Recorddeleted
						)
					SELECT @_ContractRateId
						,Sites.SiteId
						,Sites.Recorddeleted
					FROM Sites
					WHERE Sites.ProviderID = @ProviderId
						AND ISNULL(Sites.RecordDeleted, 'N') = 'N'
				END

				IF (
						@_ContractRateCoveragePlansListCount = 0
						AND @_tblContractRateCoveragePlansCount = 0
						)
				BEGIN
					INSERT INTO [dbo].#ContractRateCoveragePlansList (
						ContractRateId
						,CoveragePlanId
						,Recorddeleted
						)
					SELECT @_ContractRateId
						,CoveragePlans.CoveragePlanId
						,CoveragePlans.Recorddeleted
					FROM CoveragePlans
					WHERE ISNULL(CoveragePlans.RecordDeleted, 'N') = 'N'
						AND CoveragePlans.Active = 'Y'
				END

				IF (
						@_ContractRateLicenseTypesCount = 0
						AND @_tblContractRateLicenseTypesCount = 0
						)
				BEGIN
					INSERT INTO [dbo].#ContractRateLicenseTypesList (
						ContractRateId
						,LicenseTypeId
						,RecordDeleted
						)
					SELECT @_ContractRateId
						,GlobalCodes.GlobalCodeId
						,GlobalCodes.RecordDeleted
					FROM GlobalCodes
					WHERE GlobalCodes.Category LIKE 'LICENSETYPE'
						AND GlobalCodes.Active = 'Y'
						AND ISNULL(GlobalCodes.RecordDeleted, 'N') <> 'Y'
					ORDER BY GlobalCodes.SortOrder
				END

				IF (
						@_ContractRatePlaceOfServicesListCount = 0
						AND @_tblContractRatePlaceOfServicesCount = 0
						)
				BEGIN
					INSERT INTO [dbo].#ContractRatePlaceOfServicesList (
						ContractRateId
						,PlaceOfServiceId
						,Recorddeleted
						)
					SELECT @_ContractRateId
						,GlobalCodes.GlobalCodeId
						,GlobalCodes.RecordDeleted
					FROM GlobalCodes
					WHERE ISNULL(GlobalCodes.RecordDeleted, 'N') = 'N'
						AND GlobalCodes.Category LIKE 'PCMPLACEOFSERVICE'
						AND GlobalCodes.Active = 'Y'
					ORDER BY GlobalCodes.SortOrder
				END

				IF (
						@_ContractRateAffiliateListCount = 0
						AND @_tblContractRateAffiliateCount = 0
						)
				BEGIN
					INSERT INTO [dbo].#ContractRateAffiliatesList (
						ProviderId
						,ContractRateId
						,Recorddeleted
						)
					SELECT ProviderId
						,@_ContractRateId
						,RecordDeleted
					FROM Providers
					WHERE ProviderId IN (
							SELECT ProviderAffiliates.AffiliateProviderId
							FROM Providers
								,ProviderAffiliates
							WHERE Providers.ProviderId = ProviderAffiliates.ProviderId
								AND Providers.ProviderId = @ProviderID
								AND ISNULL(dbo.Providers.RecordDeleted, 'N') = 'N'
								AND ISNULL(dbo.ProviderAffiliates.RecordDeleted, 'N') = 'N'
							)
						AND ISNULL(dbo.Providers.RecordDeleted, 'N') = 'N'
				END

				FETCH NEXT
				FROM @ContractRateDetailsCursor
				INTO @_ContractRateId;
			END

			CLOSE @ContractRateDetailsCursor;

			DEALLOCATE @ContractRateDetailsCursor;
		END

		SELECT @ContractRatesFinalListCount = Count(*)
		FROM #ContractRatesFinalList;

		IF EXISTS (
				SELECT SiteId
					,Count(SiteId)
				FROM #ContractRateSitesFinalList
				GROUP BY SiteId
				HAVING COUNT(*) > 1
				)
		BEGIN
			UPDATE #ContractRatesFinalList
			SET AllSites = 'Y'
		END

		IF EXISTS (
				SELECT CoveragePlanId
					,Count(CoveragePlanId)
				FROM #ContractRateCoveragePlansList
				GROUP BY CoveragePlanId
				HAVING COUNT(*) > 1
				)
		BEGIN
			UPDATE #ContractRatesFinalList
			SET AllCoveragePlans = 'Y'
		END

		IF EXISTS (
				SELECT LicenseTypeId
					,Count(LicenseTypeId)
				FROM #ContractRateLicenseTypesList
				GROUP BY LicenseTypeId
				HAVING COUNT(*) > 1
				)
		BEGIN
			UPDATE #ContractRatesFinalList
			SET AllContractRateLicenseTypes = 'Y'
		END

		IF EXISTS (
				SELECT PlaceOfServiceId
					,Count(PlaceOfServiceId)
				FROM #ContractRatePlaceOfServicesList
				GROUP BY PlaceOfServiceId
				HAVING COUNT(*) > 1
				)
		BEGIN
			UPDATE #ContractRatesFinalList
			SET AllContractRatePlaceOfServices = 'Y'
		END

		IF EXISTS (
				SELECT ProviderId
					,Count(ProviderId)
				FROM #ContractRateAffiliatesList
				GROUP BY ProviderId
				HAVING COUNT(*) > 1
				)
		BEGIN
			UPDATE #ContractRatesFinalList
			SET AllAffiliatedProviders = 'Y'
		END

		IF (@ContractRatesFinalListCount > 1)
		BEGIN
			IF EXISTS (
					SELECT *
					FROM #ContractRatesFinalList
					WHERE AllAffiliatedProviders = 'Y'
						AND AllSites = 'Y'
						AND AllCoveragePlans = 'Y'
						AND AllContractRateLicenseTypes = 'Y'
						AND AllContractRatePlaceOfServices = 'Y'
					)
			BEGIN
				SELECT 'EXISTS' AS ContractRates
			END
			ELSE
			BEGIN
				SELECT 'NOT EXISTS' AS ContractRates
			END
		END
		ELSE
		BEGIN
			SELECT 'NOT EXISTS' AS ContractRates
		END

		SELECT 'EXISTS' AS ModifierCombination
		FROM BillingCodeModifiers
		WHERE ISNULL(Modifier1, '') = @Modifier1
			AND ISNULL(Modifier2, '') = @Modifier2
			AND ISNULL(Modifier3, '') = @Modifier3
			AND ISNULL(Modifier4, '') = @Modifier4
			AND BillingCodeId = @BillingCodeId
			AND ISNULL(RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), ' ssp_CMCheckContracteRatesDetail ') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                       
				16
				,-- Severity.                       
				1 -- State.                       
				);
	END CATCH
END