/****** Object:  StoredProcedure [dbo].[ssp_PMGetChargeDetails]    Script Date: 11/18/2011 16:25:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMGetChargeDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMGetChargeDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMGetChargeDetails]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ssp_PMGetChargeDetails] @ChargeId INT
AS
/*********************************************************************/
/* Stored Procedure: dbo.ssp_PMGetChargeDetails                */
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */
/* Creation Date:  05/15/2006                                    */
/*                                                                   */
/* Purpose: Selects the Details from the Staff Table for updating the Records      */
/*                                                                   */
/* Input Parameters: @Chargeid int*/
/*                                                                   */
/* Output Parameters:                                */
/*                                                                   */
/* Return:   */
/*                                                                   */
/* Called By: ChargeDetails.cs    */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/*   Updates:                                                          */
/*       Date              Author           Purpose                                    */
/* 05/15/2006			Sukhbir Singh       Fetch Charge Details Data*/
/* 06/01/2009			Priya    Added		space in Client Name ref ticket#1151   */
/* 19 Oct 2015			Revathi				what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.      
--											why:task #609, Network180 Customization */
/*********************************************************************/
BEGIN
	--Charge & Plan Data      
	SELECT C.*
		,CP.DisplayAs AS PlanName
	FROM Charges C
	LEFT JOIN ClientCoveragePlans CCP ON C.ClientCoveragePlanId = CCP.ClientCoveragePlanId
	LEFT JOIN CoveragePlans CP ON CCP.CoveragePlanId = CP.CoveragePlanId
	WHERE ChargeId = @ChargeId
		AND IsNull(C.RecordDeleted, ''N'') = ''N''
		AND IsNull(CCP.RecordDeleted, ''N'') = ''N''
		AND IsNull(CP.RecordDeleted, ''N'') = ''N''

	--Checking For Errors      
	IF (@@error != 0)
	BEGIN
		RAISERROR 20006 ''ssp_PMGetChargeDetails: An Error Occured''

		RETURN
	END

	--Client & Services Data      
	SELECT S.ClientId
		,
		--Added by Revathi 19 Oct 2015
		Cast(C.ClientId AS VARCHAR) + '' - '' + CASE 
			WHEN ISNULL(C.ClientType, ''I'') = ''I''
				THEN ISNULL(C.LastName, '''') + '', '' + C.FirstName
			ELSE C.OrganizationName
			END AS ClientName
		,CASE 
			WHEN ISNULL(C.ClientType, ''I'') = ''I''
				THEN C.LastName + '' ,'' + C.FirstName
			ELSE C.OrganizationName
			END AS DisplayClientName
		,S.ServiceId
		,S.DateOfService
		,S.ProcedureCodeId
		,S.ClinicianId
		,S.ProgramId
		,S.LocationId
		,PC.DisplayAs + '' - '' + Cast(S.Unit AS VARCHAR) + ''  '' + GCUnitType.CodeName AS ProcedureCode
		,St.LastName + '', '' + St.FirstName AS ClinicianName
		,P.ProgramCode AS Program
		,L.LocationCode AS Location
		,S.Charge
		,S.ProcedureRateId
	FROM Clients C
	INNER JOIN Services S ON C.ClientId = S.ClientId
	INNER JOIN Charges CH ON CH.ServiceId = S.ServiceId
	INNER JOIN ProcedureCodes PC ON S.ProcedureCodeId = PC.ProcedureCodeId
	INNER JOIN GlobalCodes GCUnitType ON S.UnitType = GCUnitType.GlobalCodeId
	LEFT JOIN Staff St ON St.StaffId = S.ClinicianId
	LEFT JOIN Programs P ON P.ProgramId = S.ProgramId
	LEFT JOIN Locations L ON L.LocationId = S.LocationId
	WHERE CH.ChargeId = @ChargeId
		AND IsNull(S.RecordDeleted, ''N'') = ''N''
		AND IsNull(C.RecordDeleted, ''N'') = ''N''
		AND IsNull(CH.RecordDeleted, ''N'') = ''N''
		AND IsNull(St.RecordDeleted, ''N'') = ''N''
		AND IsNull(P.RecordDeleted, ''N'') = ''N''
		AND IsNull(L.RecordDeleted, ''N'') = ''N''
		AND IsNull(PC.RecordDeleted, ''N'') = ''N''
		AND IsNull(GCUnitType.RecordDeleted, ''N'') = ''N''

	--Checking For Errors      
	IF (@@error != 0)
	BEGIN
		RAISERROR 20006 ''ssp_PMGetChargeDetails: An Error Occured''

		RETURN
	END

	--Payer Payment      
	SELECT 0 - IsNull(sum(ARL.amount), 0) AS PayerPayment
	FROM ARLedger ARL
	WHERE ARL.LedgerType = 4202
		AND ARL.ChargeId = @ChargeId
		AND IsNull(ARL.RecordDeleted, ''N'') = ''N''
	GROUP BY ARL.Chargeid

	--Checking For Errors      
	IF (@@error != 0)
	BEGIN
		RAISERROR 20006 ''ssp_PMGetChargeDetails: An Error Occured''

		RETURN
	END

	SELECT ARL.PaymentId AS PaymentId
		,FAL.FinancialActivityId AS FinancialActivityId
	FROM ARLedger ARL
	INNER JOIN FinancialActivityLines FAL ON ARL.FinancialActivityLineId = FAL.FinancialActivityLineId
	WHERE FAL.FinancialActivityLineId = (
			SELECT Max(FinancialActivityLineId)
			FROM ARLedger
			WHERE ChargeId = @ChargeId
				AND IsNull(RecordDeleted, ''N'') = ''N''
				AND LedgerType = 4202
			)
		AND LedgerType = 4202
		AND IsNull(ARL.RecordDeleted, ''N'') = ''N''
		AND IsNull(FAL.RecordDeleted, ''N'') = ''N''

	--Checking For Errors      
	IF (@@error != 0)
	BEGIN
		RAISERROR 20006 ''ssp_PMGetChargeDetails: An Error Occured''

		RETURN
	END

	--Billing History Data      
	SELECT BH.ChargeId
		,BH.BilledDate
		,BH.ClaimBatchId
		,CB.ClaimProcessId
		,CB.ProcessedDate
		,CB.CreatedBy
		,Electronic
	FROM BillingHistory BH
	LEFT JOIN ClaimBatches CB ON BH.ClaimBatchId = CB.ClaimBatchId
	LEFT JOIN ClaimFormats CF ON CF.ClaimFormatId = CB.ClaimFormatId
	WHERE ChargeId = @ChargeId
		AND IsNull(BH.RecordDeleted, ''N'') = ''N''
		AND IsNull(CB.RecordDeleted, ''N'') = ''N''
		AND IsNull(CF.RecordDeleted, ''N'') = ''N''

	--Checking For Errors      
	IF (@@error != 0)
	BEGIN
		RAISERROR 20006 ''ssp_PMGetChargeDetails: An Error Occured''

		RETURN
	END

	--Charge Error Data       
	SELECT ChargeErrorId
		,CE.ChargeId
		,CE.ErrorType
		,GC.CodeName
		,CE.ErrorDescription
		,CE.RowIdentifier
		,CE.CreatedBy
		,CE.CreatedDate
		,CE.ModifiedBy
		,CE.ModifiedDate
		,CE.RecordDeleted
		,CE.DeletedDate
		,CE.DeletedBy
	FROM ChargeErrors CE
	INNER JOIN GlobalCodes GC ON CE.ErrorType = GC.GlobalCodeId
	WHERE IsNull(GC.RecordDeleted, ''N'') = ''N''
		AND IsNull(CE.RecordDeleted, ''N'') = ''N''
		AND ChargeId = @ChargeId

	--Checking For Errors      
	IF (@@error != 0)
	BEGIN
		RAISERROR 20006 ''ssp_PMGetChargeDetails: An Error Occured''

		RETURN
	END
END
' 
END
GO
