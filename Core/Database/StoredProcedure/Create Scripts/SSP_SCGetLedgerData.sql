
/****** Object:  StoredProcedure [dbo].[SSP_SCGetLedgerData]    Script Date: 11/09/2015 19:15:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCGetLedgerData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_SCGetLedgerData]
GO



/****** Object:  StoredProcedure [dbo].[SSP_SCGetLedgerData]    Script Date: 11/09/2015 19:15:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SSP_SCGetLedgerData] @ChargeId BIGINT
	,@ClaimLineItemId INT
AS
-- =============================================      
-- Author:  Pradeep      
-- Create date: Sept 23, 2014      
-- Description: Retrieves CCR Reson for Referral Data      
/*      
 Author			Modified Date			Reason      
   
      
*/
-- =============================================      
BEGIN
	BEGIN TRY
		SELECT A.ArLedgerId
			,FA.FinancialActivityId
			,FAL.FinancialActivityLineId
			,P.PaymentId
			,CH.ServiceId AS ServiceId
			,A.ChargeId
			,Convert(VARCHAR(10), PostedDate) AS PostedDate
			,GC.GlobalCodeId
			,GC.CodeName AS Activity
			,isnull(RTRIM(Cp.DisplayAs) + ' ' + isnull(CCP.InsuredId, ''), 'Client') AS Payer
			,GCL.CodeName AS Type
			,Convert(VARCHAR(10), A.Amount) AS Amount
			,P.ReferenceNumber AS [Check]
			,FAL.Comment AS Reason
			,isnull(MarkedAsError, 'N') AS MarkedAsError
			,A.CreatedBy
			,Convert(VARCHAR(10), A.CreatedDate) AS CreatedDate
			,CH.ClientCoveragePlanId
			,isnull(ErrorCorrection, 'N') AS ErrorCorrection
			,A.RecordDeleted
			,A.AccountingPeriodId
			,Convert(VARCHAR(10), CASE 
					WHEN FAL.Flagged = 'Y'
						THEN 1
					ELSE 0
					END) AS FlaggedButton
			,Convert(VARCHAR(10), FAL.CurrentVersion) AS CurrentVersion
			,S.ClientId
			,St.LastName + ', ' + St.FirstName AS Clinician
			,ProcedureCodeName AS [Procedure]
			,S.Unit AS Units
			,convert(VARCHAR(19), s.DateOfService, 101) + ' ' + ltrim(substring(convert(VARCHAR(19), s.DateOfService, 100), 12, 6)) + ' ' + ltrim(substring(convert(VARCHAR(19), s.DateOfService, 100), 18, 2)) AS DOS
			,'' AS AdjCode
		INTO #FinancialActivitySummary
		FROM ArLedger A
		LEFT JOIN FinancialActivityLines FAL ON FAL.FinancialActivityLineId = A.FinancialActivityLineId
		LEFT JOIN FinancialActivities FA ON FA.FinancialActivityId = FAL.FinancialActivityId
		LEFT JOIN Payments P ON FA.FinancialActivityId = P.FinancialActivityId
		LEFT JOIN GlobalCodes GC ON FA.ActivityType = GC.GlobalCodeID
		LEFT JOIN GlobalCodes GCL ON A.LedgerType = GCL.GlobalCodeID
		LEFT JOIN Charges CH ON A.ChargeId = CH.ChargeId
		LEFT JOIN ClaimLineItemCharges CLI ON CLI.ChargeId = CH.ChargeId
		LEFT JOIN Services S ON S.ServiceId = CH.ServiceId
		LEFT JOIN ClientCoveragePlans CCP ON CH.ClientCoveragePlanId = CCP.ClientCoveragePlanId
		LEFT JOIN CoveragePlans Cp ON CP.CoveragePlanId = CCP.CoveragePlanId
		LEFT JOIN ProcedureCodes PR ON PR.ProcedureCodeId = S.ProcedureCodeId
		LEFT JOIN Staff ST ON St.StaffId = S.ClinicianId
		WHERE CLI.ClaimLineItemId = @ClaimLineItemId
			AND (CH.ChargeId = @ChargeId  OR 0=0)
			AND (
				A.RecordDeleted IS NULL
				OR A.RecordDeleted = 'N'
				)
		ORDER BY PostedDate DESC
			,LedgerType DESC
		
		SELECT *
		FROM #FinancialActivitySummary
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'SSP_SCGetLedgerData') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                     
				16
				,-- Severity.                                                            
				1 -- State.                                                         
				);
	END CATCH
END


GO


