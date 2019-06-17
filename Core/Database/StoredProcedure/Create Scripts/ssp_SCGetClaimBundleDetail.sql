
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetClaimBundleDetail]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetClaimBundleDetail]
GO
--exec [ssp_SCGetClaimBundleDetail] 17

CREATE PROCEDURE [dbo].[ssp_SCGetClaimBundleDetail] (@ClaimBundleId INT)
AS
/*********************************************************************/
/* Stored Procedure: dbo.ssp_SCGetClaimBundleDetail            */
/* Date            Author      Purpose                                */
/*09-Oct-2015	SuryaBalan  Claim Bundles Detail Network 180 - Customizations Task #608*/
/*09-Oct-2015	SuryaBalan  Added Billing Code Name Column*/
/*09-Oct-2015	SuryaBalan  Removed ICD10CodeId Column*/
/*05-APR-2015	Suneel N	Added Columns based on the multiple requirements of Network180 - Customizations Task #608.6*/
/*05-Nov-2018	Jeffin Scaria	What: Added Column for Claim Submission Frequency
								Why: KCMHSAS - Enhancements Task #36*/
/*********************************************************************/
BEGIN
	SELECT C.ClaimBundleId
		,C.CreatedBy
		,C.CreatedDate
		,C.ModifiedBy
		,C.ModifiedDate
		,C.RecordDeleted
		,C.DeletedBy
		,C.DeletedDate
		,C.ProviderId
		,C.BillingCodeId
		,C.ProviderSiteId
		,C.AllSites
		,C.BundleName
		,C.Active
		,C.StartDate
		,C.EndDate
		,C.Period
		,C.BundleComments
		,C.ClaimType
		,C.Modifier1
		,C.Modifier2
		,C.Modifier3
		,C.Modifier4
		--,C.ICD10CodeId
		--,C.Diagnosis
		,C.DateOfService
		,C.PlaceOfService
		,gccr.CodeName
		--,C.BillingCodeName
        ,C.ClientId
		--,CC.LastName + ' , ' + CC.FirstName AS ClientOrganization
		--05-APR-2015	Suneel N
		,CC.OrganizationName AS ClientOrganization
		,C.InsurerId
		,C.AllClients
		,C.AllBillingCodes
		,C.AllBillingCodesMinimumUnitsPerPeriod
		,C.BundledClaimStatus
		,C.ClientSameAsAbove
		,C.ProviderSiteGroupName
		,C.SubmissionFrequency
		
	FROM ClaimBundles C
	LEFT JOIN Clients CC ON CC.ClientId = C.ClientId
		AND (ISNULL(CC.RecordDeleted, 'N') = 'N')
	LEFT JOIN GlobalCodes gccr ON gccr.GlobalCodeId = C.Period
		AND (ISNULL(gccr.RecordDeleted, 'N') = 'N')
	WHERE (ISNULL(C.RecordDeleted, 'N') = 'N')
		AND (C.ClaimBundleId = @ClaimBundleId)

	SELECT CS.ClaimBundleSiteId
		,CS.CreatedBy
		,CS.CreatedDate
		,CS.ModifiedBy
		,CS.ModifiedDate
		,CS.RecordDeleted
		,CS.DeletedBy
		,CS.DeletedDate
		,CS.ClaimBundleId
		,CS.SiteId
		--05-APR-2015	Suneel N
		,CS.ProviderId
		,S.SiteName
	FROM ClaimBundleSites CS
	LEFT JOIN Sites S ON S.SiteId = CS.SiteId
		AND (ISNULL(S.RecordDeleted, 'N') = 'N')
	WHERE (ISNULL(CS.RecordDeleted, 'N') = 'N')
		AND CS.ClaimBundleId = @ClaimBundleId

	SELECT CC.ClaimBundleClientId
		,CC.CreatedBy
		,CC.CreatedDate
		,CC.ModifiedBy
		,CC.ModifiedDate
		,CC.RecordDeleted
		,CC.DeletedBy
		,CC.DeletedDate
		,CC.ClaimBundleId
		,CC.ClientId
		,C.LastName + ' , ' + C.FirstName AS ClientName
	FROM ClaimBundleClients CC
	LEFT JOIN Clients C ON C.ClientId = CC.ClientId
		AND (ISNULL(C.RecordDeleted, 'N') = 'N')
	WHERE (ISNULL(CC.RecordDeleted, 'N') = 'N')
		AND CC.ClaimBundleId = @ClaimBundleId

	--SELECT CBC.ClaimBundleBillingCodeId
	--	,CBC.CreatedBy
	--	,CBC.CreatedDate
	--	,CBC.ModifiedBy
	--	,CBC.ModifiedDate
	--	,CBC.RecordDeleted
	--	,CBC.DeletedBy
	--	,CBC.DeletedDate
	--	,CBC.ClaimBundleId
	--	,CBC.BillingCodeId
	--	,BC.CodeName
	--	,CBC.MinimumUnitsPerPeriod
	--	,CBC.BillingCodeComments
	--	--05-APR-2015	Suneel N
	--	,BC.BillingCode as BillingCodeName
	--FROM ClaimBundleBillingCodes CBC
	--LEFT JOIN BillingCodes BC on BC.BillingCodeId=CBC.BillingCodeId AND (ISNULL(BC.RecordDeleted, 'N') = 'N')
	--WHERE CBC.ClaimBundleId = @ClaimBundleId
	--	AND (ISNULL(CBC.RecordDeleted, 'N') = 'N')

		SELECT BillingCodeId,
		CreatedBy,
		CreatedDate,
		ModifiedBy,
		ModifiedDate,
		RecordDeleted,
		DeletedBy,
		DeletedDate,
		ProcedureCodeId,
		--FormId,
		BillingCode,
		CodeName,
		Active,
		Units,
		UnitType,
		ReportingUnits,
		ReportingUnitType,
		HospitalCode,
		ExcludeDischargeDay,
		NoRateCode,
		ExternalCode1,
		ExternalSource1,
		ExternalCode2,
		ExternalSource2,
		UnlimitedDailyUnits,
		DailyUnits,
		UnlimitedWeeklyUnits,
		WeeklyUnits,
		UnlimitedMonthlyUnits,
		MonthlyUnits,
		UnlimitedYearlyUnits,
		YearlyUnits,
		ExceedLimitAction,
		ServiceEndDateEqualsStartDate,
		AllInsurers,
		ValidAllPlans,
		AuthorizationRequired,
		AllowMultipleClaimsPerDay,
		RowIdentifier from BillingCodes BC where  (ISNULL(BC.RecordDeleted, 'N') = 'N')
	
	SELECT CBCG.ClaimBundleBillingCodeGroupId,
			CBCG.CreatedBy,
			CBCG.CreatedDate,
			CBCG.ModifiedBy,
			CBCG.ModifiedDate,
			CBCG.RecordDeleted,
			CBCG.DeletedBy,
			CBCG.DeletedDate,
			CBCG.ClaimBundleId,
			CBCG.BillingCodeGroupName,
			CBCG.MinimumUnitsPerPeriod
	FROM ClaimBundleBillingCodeGroups CBCG
	WHERE CBCG.ClaimBundleId = @ClaimBundleId 
	AND (ISNULL(CBCG.RecordDeleted, 'N') = 'N')
	
	SELECT CBG.ClaimBundleBillingCodeGroupBillingCodeId,
			CBG.CreatedBy,
			CBG.CreatedDate,
			CBG.ModifiedBy,
			CBG.ModifiedDate,
			CBG.RecordDeleted,
			CBG.DeletedBy,
			CBG.DeletedDate,
			CBG.ClaimBundleBillingCodeGroupId,
			CBG.BillingCodeModifierId,
			CBG.ApplyToAllModifiers
	FROM ClaimBundleBillingCodeGroupBillingCodes CBG
	LEFT JOIN ClaimBundleBillingCodeGroups CBCG ON CBG.ClaimBundleBillingCodeGroupId = CBCG.ClaimBundleBillingCodeGroupId AND (ISNULL(CBCG.RecordDeleted, 'N') = 'N')
	LEFT JOIN BillingCodeModifiers BCM ON BCM.BillingCodeModifierId = CBG.BillingCodeModifierId AND (ISNULL(BCM.RecordDeleted, 'N') = 'N')
	WHERE CBG.ClaimBundleBillingCodeGroupId = CBCG.ClaimBundleBillingCodeGroupId AND (ISNULL(CBG.RecordDeleted, 'N') = 'N')
	
	SELECT BCM.BillingCodeModifierId,
			BCM.CreatedBy,
			BCM.CreatedDate,
			BCM.ModifiedBy,
			BCM.ModifiedDate,
			BCM.RecordDeleted,
			BCM.DeletedDate,
			BCM.DeletedBy,
			BCM.BillingCodeId,
			BCM.Modifier1,
			BCM.Modifier2,
			BCM.Modifier3,
			BCM.Modifier4,
			BCM.Description,
			BCM.AllowMultipleClaimsPerDay,
			BCM.ProcedureCodeId
	FROM BillingCodeModifiers BCM where  (ISNULL(BCM.RecordDeleted, 'N') = 'N')
	--Checking For Errors    
	IF (@@error != 0)
	BEGIN
		RAISERROR ('ssp_SCGetClaimBundleDetail: An Error Occured While Updating ',16,1);
		RETURN
	END
END