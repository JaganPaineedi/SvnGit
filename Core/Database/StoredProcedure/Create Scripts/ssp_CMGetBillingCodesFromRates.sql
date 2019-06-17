IF EXISTS 
(
	SELECT	*
	FROM	sys.objects
	WHERE	object_id = OBJECT_ID(N'[dbo].[ssp_CMGetBillingCodesFromRates]')
		AND type IN (N'P', N'PC')
)
	DROP PROCEDURE [dbo].[ssp_CMGetBillingCodesFromRates]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[ssp_CMGetBillingCodesFromRates] 
(
	@From DATETIME,
	@To DATETIME,
	@InsurerId INT,
	@ProviderId INT,
	@ClaimEntryType VARCHAR(2)
)
AS
/***********************************************************************************************************************
	Stored Procedure:	dbo.ssp_GetBillingCodesFromRates 
	Copyright:			2005 Provider Claim Management System
	Creation Date:		01/03/2006 
	Purpose:			it will get records of all Billing Codes from billingcoderates table
	Return:				Plan Records based on the applied filer
========================================================================================================================
	Modifications
========================================================================================================================
	Date		Author			Purpose
	----------	--------------	--------------------------------------------------------------------
	04/01/2006  Raman			Created
	27/08/2016  R.M.Mani		what:Added condition to check "ContractRates table startdate and end date " 
								Why:Task #85 AspenPointe-Environment Issues
	07/03/2018	Ting-Yu Mu		What: 
								1. Added TRY CATCH block for error handling and updated RAISERROR syntax
								2. Modified to use Alias in the query
								3. Added local variables to be referenced in the query to avoid parameters sniffing
								Why: Partner Solutions-Support Go Live
	12/19/2018  Vijay           What:If Billing Code does not match on the contract then we need to check the Billing Codes table for an exact match.  If there is an Exact Match then we insert that Billing Code ID. Only if there is not an exact match in the Billing Codes table would Billing Code ID be NULL
								Why:CEI - Support Go Live Task#1049
***********************************************************************************************************************/
BEGIN TRY
	-- #### Declare local variable to avoid parameters sniffing ################
	DECLARE	@FromDate DATETIME = @From;
	DECLARE	@ToDate DATETIME = @To;
	DECLARE	@LocalInsurerId INT = @InsurerId;
	DECLARE	@LocalProviderId INT = @ProviderId;
	-- #########################################################################
      
    CREATE TABLE #ClaimsBillingCodes
    (
      BillingCodeID INT,
      BillingCode VARCHAR(20),
      ServiceEndDateEqualsStartDate CHAR(1)
    )
    
    INSERT  INTO #ClaimsBillingCodes
    ( BillingCodeID ,
      BillingCode ,
      ServiceEndDateEqualsStartDate
	)      
	SELECT	0 AS BillingCodeID,
			'' AS BillingCode,
			'' AS ServiceEndDateEqualsStartDate

	UNION ALL

	SELECT	DISTINCT BC.BillingCodeId,
			BC.BillingCode,
			BC.ServiceEndDateEqualsStartDate
	FROM	dbo.BillingCodes AS BC
	INNER JOIN dbo.ContractRates AS CR ON BC.BillingCodeId = CR.BillingCodeId
	LEFT JOIN dbo.Contracts AS C ON CR.ContractId = C.ContractId
			AND ISNULL(C.RecordDeleted, 'N') = 'N'
	WHERE	ISNULL(BC.RecordDeleted, 'N') = 'N'
		--and BillingCodes.Active='Y'    
		AND ISNULL(CR.RecordDeleted, 'N') = 'N'
		--AND ISNULL(C.RecordDeleted, 'N') = 'N'
		AND C.InsurerId = @LocalInsurerId
		AND C.ProviderId = @LocalProviderId
		AND 
		(
			C.StartDate IS NULL
			OR CAST(@FromDate AS DATE) >= CAST(C.StartDate AS DATE)
		)
		AND 
		(
			C.EndDate IS NULL
			OR CAST(@ToDate AS DATE) <= CAST(C.EndDate AS DATE)
		)
		AND 
		(
			CR.StartDate IS NULL
			OR CAST(@FromDate AS DATE) >= CAST(CR.StartDate AS DATE)
		)
		AND 
		(
			CR.EndDate IS NULL
			OR CAST(@ToDate AS DATE) <= CAST(CR.EndDate AS DATE)
		)
	
	DECLARE @NoOfRows INT
	SET @NoOfRows = (select Count(*) from #ClaimsBillingCodes);
		
	If(@NoOfRows = 1 AND @ClaimEntryType <> 'PP')	
	BEGIN
		SELECT	DISTINCT BillingCodeId,
			BillingCode,
			ServiceEndDateEqualsStartDate
	FROM	dbo.BillingCodes WHERE ISNULL(RecordDeleted, 'N') = 'N'
	END
	ELSE
	BEGIN
		SELECT * FROM #ClaimsBillingCodes
	END
	
END TRY
BEGIN CATCH
	DECLARE	@ErrMsg VARCHAR(8000);
	SET	@ErrMsg = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + 
				  CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + 
				  ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetBillingCodesFromRates') + '*****' + 
				  CONVERT(VARCHAR, ERROR_LINE()) + '*****' + 
				  CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + 
				  CONVERT(VARCHAR, ERROR_STATE());
	RAISERROR(@ErrMsg, 16, 1)
	RETURN
END CATCH       
GO