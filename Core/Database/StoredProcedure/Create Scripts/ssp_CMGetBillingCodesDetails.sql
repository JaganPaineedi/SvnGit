IF EXISTS (SELECT
    *
  FROM sys.objects
  WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMGetBillingCodesDetails]')
  AND type IN (N'P', N'PC'))
  DROP PROCEDURE [dbo].[ssp_CMGetBillingCodesDetails]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_CMGetBillingCodesDetails] (@BillingCodeID int,    
@StaffId int)    
AS    
BEGIN    
  BEGIN TRY    
    /****************************************************************************************/    
    /* Stored Procedure: dbo.ssp_CMGetBillingCodesDetails       */    
    /* Creation Date:  14-May-2014     */    
    /* Creation By:    Vichee Humane    */    
    /* Purpose: To Get BillingCodes Details on basis of BillingCodeId     */    
    /* Input Parameters: @BillingCodeID     */    
    /* Output Parameters:            */    
    /*  Date                Author               Purpose   */    
    /*  14May2014           Vichee Humane        Created      */    
    /*  16Sep2014           Avi Goyal				Replaced BillingCodeValidPlans table with BillingCodeValidCoveragePlans
													Task: 37 Project: Care Management to Smart Care     */
    /*  18/03/2015          Shruthi.S            Added ProcedureCodeID new field in BillngCodes and BillingCodeMod.Ref : #605 Network 180 Cust.*/
    /*  03/Nov/2015         Arjun K R            Added Select Statement to get the BillingCodeAuthorizationRequestForms table records. Task #604 Network180 Customization */
    /*  16/Feb/2016			Chethan N			 What : Added Category1, Category2 and Category3 to BillingCodes
												 Why : Network 180 - Customizations task #709.1 */
	/*  26/March/2016		Ponnin				 What : Added new tables AuthorizationClaimsBillingCodeExchanges, AuthorizationClaimsBillingCodeExchangeProviderSites, AuthorizationClaimsBillingCodeExchangeInsurers and AuthorizationClaimsBillingCodeExchangeBillingCodes
												 Why : Network 180 - Customizations task #702 */
	/*  27/March/2016		Ponnin				 What : Table Names and column names changed based on Data model changes.
												 Why : Network 180 - Customizations task #702 */
	/*  28/Nov/2017		    Ajay				 What : Added two columns [ExternalCode3]  and [ExternalSource3] in BillingCodes Table
												 Why : Meaningful Use - Stage 3 #66 */		
    /* DEC 18 2018          Arjun K R            What : Added StartDate,EndDate and Active new columns to BillingCodeModifiers table.
												 Why : #900.77 KCMHSAS Enhancement*/
    /****************************************************************************************/    
    SELECT    
      BC.[BillingCodeId],    
      BC.[BillingCode],    
      BC.[CodeName],    
      BC.[Active],    
      CAST(BC.[Units] AS decimal(18, 0)) AS Units,    
      BC.[UnitType],    
      CAST(BC.[ReportingUnits] AS decimal(18, 0)) AS ReportingUnits,    
      BC.[ReportingUnitType],    
      BC.[HospitalCode],    
      BC.[ExcludeDischargeDay],    
      BC.[NoRateCode],    
      BC.[ExternalCode1],    
      BC.[ExternalSource1],    
      BC.[ExternalCode2],    
      BC.[ExternalSource2],    
      BC.[UnlimitedDailyUnits],    
      BC.[DailyUnits],    
      BC.[UnlimitedWeeklyUnits],    
      BC.[WeeklyUnits],    
      BC.[UnlimitedMonthlyUnits],    
      BC.[MonthlyUnits],    
      BC.[UnlimitedYearlyUnits],    
      BC.[YearlyUnits],    
      BC.[ExceedLimitAction],    
      BC.[ServiceEndDateEqualsStartDate],    
      BC.[AllInsurers],    
      BC.[ValidAllPlans],    
      BC.[AuthorizationRequired],    
      BC.[AllowMultipleClaimsPerDay],    
      BC.[RowIdentifier],    
      BC.[CreatedBy],    
      BC.[CreatedDate],    
      BC.[ModifiedBy],    
      BC.[ModifiedDate],    
      BC.[RecordDeleted],    
      BC.[DeletedDate],    
      BC.[DeletedBy],
      GC.CodeName  as 'BillingCodeUnitType',
      ProcedureCodeId,
      BC.AuthorizationRequestFormId,
      BC.[Category1],
      BC.[Category2],
      BC.[Category3],
      BC.[ExternalCode3],
      BC.[ExternalSource3]
    FROM BillingCodes BC 
    INNER JOIN GlobalCodes GC ON BC.UnitType = GC.GlobalCodeId      
    WHERE BC.BillingCodeId = @BillingCodeID    
    AND ISNULL(BC.RecordDeleted, 'N') <> 'Y'    
    
    
    
    
    SELECT        
      BCR.BillingCodeRateId,    
      BCR.BillingCodeId,    
      BCR.Modifier1,    
      BCR.Modifier2,    
      BCR.Modifier3,    
      BCR.Modifier4,    
      BCR.Modifier1Specifies,    
      BCR.Modifier2Specifies,    
      BCR.Modifier3Specifies,    
      BCR.Modifier4Specifies,     
      CONVERT(VARCHAR(10),BCR.EffectiveFrom,101) as EffectiveFrom ,      
      CONVERT(VARCHAR(10),BCR.EffectiveTo,101) as EffectiveTo ,      
       '$'+ convert(varchar,cast(BCR.Rate as money),10)  as Rate,     
      BCR.BillingCodeModifiersId,       
      BCR.RowIdentifier,    
      BCR.CreatedBy,    
      BCR.CreatedDate,    
      BCR.ModifiedBy,    
      BCR.ModifiedDate,    
      BCR.RecordDeleted,    
      BCR.DeletedDate,    
      BCR.DeletedBy,    
	  BCM.[Description] AS BillingCodeModifiersText,
	  BCM.ProcedureCodeId,
	  Pc.ProcedureCodeName as ProcedureCodeIdText,
	  BCM.StartDate, --DEC 18 2018          Arjun K R 
	  BCM.EndDate,
	  BCM.Active
    FROM BillingCodeRates BCR    
    LEFT JOIN BillingCodeModifiers BCM ON BCM.BillingCodeModifierId=BCR.BillingCodeModifiersId and ISNULL(BCM.RecordDeleted, 'N') <> 'Y'
    LEFT JOIN ProcedureCodes PC on Pc.ProcedureCodeId = BCM.ProcedureCodeId and ISNULL(PC.RecordDeleted, 'N') <> 'Y'   
    WHERE ISNULL(BCR.RecordDeleted, 'N') <> 'Y'    
    AND BCR.BillingCodeID = @BillingCodeID    
    ORDER BY BCR.EffectiveFrom DESC,    
    Modifier1    
    
    
    SELECT    
      BCP.BillingCodeValidCoveragePlanId,    
      BCP.CoveragePlanId,    
      BCP.BillingCodeId,    
      BCP.CreatedBy,    
      BCP.CreatedDate,    
      BCP.ModifiedBy,    
      BCP.ModifiedDate,    
      BCP.RecordDeleted,    
      BCP.DeletedDate,    
      BCP.DeletedBy,    
      CP.CoveragePlanName    
    FROM BillingCodeValidCoveragePlans BCP    
    INNER JOIN CoveragePlans  CP  
      ON BCP.CoveragePlanId = CP.CoveragePlanId    
    WHERE (BCP.BillingCodeId = @BillingCodeId)    
    AND (CP.Active = 'Y')    
    AND (ISNULL(CP.RecordDeleted, 'N') = 'N')    
    AND (ISNULL(BCP.RecordDeleted, 'N') = 'N')    
    ORDER BY BillingCodeValidCoveragePlanId DESC,    
    CP.CoveragePlanName    
    
    
    
    SELECT    
      BCI.BillingCodeValidInsurerId,    
      BCI.InsurerId,    
      BCI.BillingCodeId,    
      BCI.CreatedBy,    
      BCI.CreatedDate,    
      BCI.ModifiedBy,    
      BCI.ModifiedDate,    
      BCI.RecordDeleted,    
     BCI.DeletedDate,    
      BCI.DeletedBy,    
      Insurers.InsurerName          
    FROM BillingCodeValidInsurers BCI    
    INNER JOIN Insurers    
      ON BCI.InsurerId =    
      Insurers.InsurerId    
    WHERE (BCI.BillingCodeId = @BillingCodeID)    
    AND (ISNULL(BCI.RecordDeleted, 'N') = 'N')    
    AND (Insurers.Active = 'Y')    
    AND (ISNULL(Insurers.RecordDeleted, 'N') = 'N')    
    ORDER BY BillingCodeValidInsurerId DESC,    
    Insurers.InsurerName    
    
    
    
    
    
    
    SELECT    
      IR.InsurerRateId,    
      IR.InsurerId,    
      IR.BillingCodeId,    
      IR.Modifier1,    
      IR.Modifier2,    
      IR.Modifier3,    
      IR.Modifier4,    
      IR.EffectiveFrom,    
      IR.EffectiveTo,          
    '$'+ convert(varchar,cast(IR.Rate as money),10)  as Rate,     
      IR.RowIdentifier,    
      IR.CreatedBy,    
      IR.CreatedDate,    
      IR.ModifiedBy,    
      IR.ModifiedDate,    
      IR.RecordDeleted,    
      IR.DeletedDate,    
      IR.DeletedBy,    
      Insurers.InsurerName as InsurerIdText,
      CONVERT(varchar,cast(dbo.BillingCodes.Units as int),20) + ' ' + dbo.GlobalCodes.CodeName  as 'Rate/UnitRange'       
    FROM InsurerRates IR    
    INNER JOIN dbo.Insurers    
      ON IR.InsurerId = dbo.Insurers.InsurerId    
    INNER JOIN dbo.BillingCodes    
      ON IR.BillingCodeId =    
      dbo.BillingCodes.BillingCodeId    
    INNER JOIN dbo.GlobalCodes    
      ON dbo.BillingCodes.UnitType =    
      dbo.GlobalCodes.GlobalCodeId    
    WHERE (ISNULL(IR.RecordDeleted, 'N') <> 'Y')    
    AND (ISNULL(dbo.Insurers.RecordDeleted, 'N') = 'N')    
    
    AND (ISNULL(dbo.BillingCodes.RecordDeleted, 'N') = 'N')    
    AND (dbo.GlobalCodes.Active = 'Y')    
    AND (ISNULL(dbo.GlobalCodes.RecordDeleted, 'N') = 'N')    
    AND (IR.BillingCodeId = @BillingCodeID)          
    ORDER BY IR.EffectiveFrom DESC,    
    IR.Modifier1    
    
    
    
    
    SELECT    
      MP.MedicaidProcedureId,    
      MP.BillingCodeId,    
      MP.MedicaidCode,    
      MP.EffectiveFrom,    
      MP.EffectiveTo,    
      MP.Unit,    
      MP.UnitType,    
      MP.RowIdentifier,    
      MP.CreatedBy,    
      MP.CreatedDate,    
      MP.ModifiedBy,    
      MP.ModifiedDate,    
      MP.RecordDeleted,    
      MP.DeletedDate,    
      MP.DeletedBy    
    FROM MedicaidBillingCodes MP    
    WHERE ISNULL(RecordDeleted, 'N') <> 'Y'    
    AND BillingCodeId = @BillingCodeId    
    ORDER BY MedicaidCode    
    
    
    
    SELECT    
      BCM.BillingCodeModifierId,    
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
      BCM.AllowMultipleClaimsPerDay  ,  
      BCM.ProcedureCodeId,
	  PC.ProcedureCodeName as ProcedureCodeIdText,
	  BCM.StartDate,  --DEC 18 2018 Arjun K R
      BCM.EndDate,
      BCM.Active
    FROM BillingCodeModifiers BCM    
      LEFT JOIN ProcedureCodes PC on PC.ProcedureCodeId = BCM.ProcedureCodeId and ISNULL(PC.RecordDeleted, 'N') <> 'Y'   
    WHERE BCM.BillingCodeId = @BillingCodeId    
    AND ISNULL(BCM.RecordDeleted, 'N') = 'N'  
    
    
   
   --Added By Arjun K R 03/Nov/2015
    SELECT BAF.[BillingCodeAuthorizationRequestFormId]
      ,BAF.[CreatedBy]
      ,BAF.[CreatedDate]
      ,BAF.[ModifiedBy]
      ,BAF.[ModifiedDate]
      ,BAF.[RecordDeleted]
      ,BAF.[DeletedBy]
      ,BAF.[DeletedDate]
      ,BAF.[BillingCodeId]
      ,BAF.[AllProviderSites]
      ,BAF.[ProviderId]
      ,BAF.[SiteId]
      ,BAF.[AuthorizationRequestFormId]
      ,(P.ProviderName +' - '+S.SiteName) AS ProviderName
      ,S.SiteName
      ,F.FormName AS DFAName
  FROM [BillingCodeAuthorizationRequestForms] BAF
  INNER JOIN BillingCodes BC ON BC.BillingCodeId=BAF.BillingCodeId
  INNER JOIN Providers P ON P.ProviderId=BAF.ProviderId
  INNER JOIN Sites S ON S.SiteId=BAF.SiteId
  INNER JOIN Forms F ON F.FormId=BAF.AuthorizationRequestFormId
  WHERE ISNULL(BAF.RecordDeleted,'N')='N'
  AND ISNULL(BC.RecordDeleted,'N')='N'
  AND BAF.BillingCodeId=@BillingCodeID
  
 
		 SELECT ABE.AuthorizationClaimsBillingCodeExchangeId
		,ABE.CreatedBy
		,ABE.CreatedDate
		,ABE.ModifiedBy
		,ABE.ModifiedDate
		,ABE.RecordDeleted
		,ABE.DeletedBy
		,ABE.DeletedDate
		,ABE.BillingCodeModifierId
		,ABE.ApplyToAllModifiers
		,ABE.Interchangeable
		,ABE.StartDate
		,ABE.EndDate
		,ABE.ProviderSitesGroupName
		,ABE.InsurerGroupName
		,ABE.ClaimBillingCodeGroupName
		,CASE 
			WHEN ABE.Interchangeable = 'N'
				THEN 'No'
			WHEN ABE.Interchangeable = 'Y'
				THEN 'Yes'
			ELSE ''
			END AS InterchangeableText
		,CASE WHEN
		ISNULL((coalesce(':' + nullif(BCM.Modifier1, ''), '') + 
		coalesce(':' + nullif(BCM.Modifier2, ''), '') + 
		 coalesce(':' + nullif(BCM.Modifier3, ''), '') + 
		 coalesce(':' + nullif(BCM.Modifier4, ''), '')) , '' ) = ''
		 
		 THEN BC.BillingCode ELSE
			(BC.BillingCode + '-' +
		 STUFF((coalesce(':' + nullif(BCM.Modifier1, ''), '') + 
		coalesce(':' + nullif(BCM.Modifier2, ''), '') + 
		 coalesce(':' + nullif(BCM.Modifier3, ''), '') + 
		 coalesce(':' + nullif(BCM.Modifier4, ''), '')),1,1,''))
			END AS BillingCodeModifierIdText
	FROM AuthorizationClaimsBillingCodeExchanges ABE
	INNER JOIN BillingCodeModifiers BCM ON BCM.BillingCodeModifierId = ABE.BillingCodeModifierId
	INNER JOIN BillingCodes BC ON BC.BillingCodeId = BCM.BillingCodeId
	WHERE BCM.BillingCodeId = @BillingCodeID
		AND ISNULL(BCM.RecordDeleted, 'N') = 'N'
		AND ISNULL(BC.RecordDeleted, 'N') = 'N'
		AND ISNULL(ABE.RecordDeleted, 'N') = 'N'
		
		
	SELECT ABPS.AuthorizationClaimsBillingCodeExchangeProviderSiteId
		,ABPS.CreatedBy
		,ABPS.CreatedDate
		,ABPS.ModifiedBy
		,ABPS.ModifiedDate
		,ABPS.RecordDeleted
		,ABPS.DeletedBy
		,ABPS.DeletedDate
		,ABPS.AuthorizationClaimsBillingCodeExchangeId
		,ABPS.ProviderId
		,ABPS.SiteId
	FROM AuthorizationClaimsBillingCodeExchangeProviderSites ABPS
	INNER JOIN AuthorizationClaimsBillingCodeExchanges ABE ON ABPS.AuthorizationClaimsBillingCodeExchangeId = ABE.AuthorizationClaimsBillingCodeExchangeId
	INNER JOIN BillingCodeModifiers BCM ON BCM.BillingCodeModifierId = ABE.BillingCodeModifierId
	INNER JOIN BillingCodes BC ON BC.BillingCodeId = BCM.BillingCodeId
	WHERE BCM.BillingCodeId = @BillingCodeId
		AND ISNULL(BCM.RecordDeleted, 'N') = 'N'
		AND ISNULL(BC.RecordDeleted, 'N') = 'N'
		AND ISNULL(ABE.RecordDeleted, 'N') = 'N'
		AND ISNULL(ABPS.RecordDeleted, 'N') = 'N'
		
	SELECT ABI.AuthorizationClaimsBillingCodeExchangeInsurerId
		,ABI.CreatedBy
		,ABI.CreatedDate
		,ABI.ModifiedBy
		,ABI.ModifiedDate
		,ABI.RecordDeleted
		,ABI.DeletedBy
		,ABI.DeletedDate
		,ABI.AuthorizationClaimsBillingCodeExchangeId
		,ABI.InsurerId
	FROM AuthorizationClaimsBillingCodeExchangeInsurers ABI
	INNER JOIN AuthorizationClaimsBillingCodeExchanges ABE ON ABI.AuthorizationClaimsBillingCodeExchangeId = ABE.AuthorizationClaimsBillingCodeExchangeId
	INNER JOIN BillingCodeModifiers BCM ON BCM.BillingCodeModifierId = ABE.BillingCodeModifierId
	INNER JOIN BillingCodes BC ON BC.BillingCodeId = BCM.BillingCodeId
	WHERE BCM.BillingCodeId = @BillingCodeId
		AND ISNULL(BCM.RecordDeleted, 'N') = 'N'
		AND ISNULL(BC.RecordDeleted, 'N') = 'N'
		AND ISNULL(ABE.RecordDeleted, 'N') = 'N'
		AND ISNULL(ABI.RecordDeleted, 'N') = 'N'
  
  
	SELECT ABBC.AuthorizationClaimsBillingCodeExchangeBillingCodeId
		,ABBC.CreatedBy
		,ABBC.CreatedDate
		,ABBC.ModifiedBy
		,ABBC.ModifiedDate
		,ABBC.RecordDeleted
		,ABBC.DeletedBy
		,ABBC.DeletedDate
		,ABBC.AuthorizationClaimsBillingCodeExchangeId
		,ABBC.BillingCodeModifierId
		,ABBC.ApplyToAllModifiers
	FROM AuthorizationClaimsBillingCodeExchangeBillingCodes ABBC
	INNER JOIN AuthorizationClaimsBillingCodeExchanges ABE ON ABBC.AuthorizationClaimsBillingCodeExchangeId = ABE.AuthorizationClaimsBillingCodeExchangeId
	INNER JOIN BillingCodeModifiers BCM ON BCM.BillingCodeModifierId = ABE.BillingCodeModifierId
	INNER JOIN BillingCodes BC ON BC.BillingCodeId = BCM.BillingCodeId
	WHERE BCM.BillingCodeId = @BillingCodeId
		AND ISNULL(BCM.RecordDeleted, 'N') = 'N'
		AND ISNULL(BC.RecordDeleted, 'N') = 'N'
		AND ISNULL(ABE.RecordDeleted, 'N') = 'N'
		AND ISNULL(ABBC.RecordDeleted, 'N') = 'N'
   
  END TRY    
    
  BEGIN CATCH    
    DECLARE @Error varchar(8000)    
    
    SET @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****'    
    + CONVERT(varchar(4000), ERROR_MESSAGE())    
    + '*****'    
    + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()),    
    'ssp_CMGetBillingCodesDetails')    
    + '*****' + CONVERT(varchar, ERROR_LINE())    
    + '*****' + CONVERT(varchar, ERROR_SEVERITY())    
    + '*****' + CONVERT(varchar, ERROR_STATE())    
    
    RAISERROR (@Error,    
    -- Message text.                                                         
    16,    
    -- Severity.                                       
    1    
    -- State.                                                                                                                        
    );    
  END CATCH    
END 