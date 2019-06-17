/****** Object:  StoredProcedure [dbo].[ssp_RDLGetClientBillingType]    Script Date: 01/29/2019 10:51:17 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLGetClientBillingType]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE dbo.ssp_RDLGetClientBillingType
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLGetClientBillingType]    Script Date: 01/29/2019 10:51:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_RDLGetClientBillingType] (@ClientId INT)
	/********************************************************************************************************     
    Report Request:     
     Details ... Gulf Bend - Enhancements > Tasks #211 > CPL - Add Lab  
  
             
    Purpose:  
    Parameters: @ClientId  
    Modified Date   Modified By   Reason     
    ----------------------------------------------------------------     
    Ravi      21/11/2018   Created  Gulf Bend - Enhancements > Tasks #211> CPL - Add Lab  
    ************************************************************************************************************/
AS
BEGIN
	BEGIN TRY
		DECLARE @BillType VARCHAR(1) = 'P'

		--PID-15 to reflect bill type
		--	A = Account Bill
		--	C = Medicaid
		--	I = Insurance
		--	M = Medicare
		IF EXISTS (
				SELECT *
				FROM sys.procedures
				WHERE name = 'scsp_RDLGetClientBillingType'
				)
		BEGIN
			EXEC [scsp_RDLGetClientBillingType] @ClientId
				,@BillType OUTPUT
		END
		ELSE
		BEGIN
			SELECT @BillType = CASE 
					WHEN isnull(CP.MedicaidPlan, 'N') = 'Y'
						THEN 'C'
					WHEN isnull(CP.MedicarePlan, 'N') = 'Y'
						THEN 'M'
					ELSE 'I'
					END
			FROM ClientCoverageHistory CCH
			JOIN ClientCoveragePlans CCP ON CCP.ClientCoveragePlanId = CCH.ClientCoveragePlanId
			JOIN CoveragePlans CP ON CP.CoveragePlanId = CCP.CoveragePlanId
			WHERE CCP.ClientId = @ClientId
				AND isnull(CCH.COBOrder, 1) = 1
				AND ISNULL(CCH.RecordDeleted, 'N') = 'N'
				AND ISNULL(CCP.RecordDeleted, 'N') = 'N'
				AND ISNULL(CP.RecordDeleted, 'N') = 'N'
				AND DATEDIFF(day, cch.StartDate, GETDATE()) >= 0
				AND (
					cch.EndDate IS NULL
					OR DATEDIFF(day, cch.EndDate, GETDATE()) <= 0
					)
		END

		SELECT CASE WHEN @BillType='A' THEN 'Account Bill'
					WHEN @BillType='C' THEN 'Medicaid'
					WHEN @BillType='I' THEN 'Insurance'
					WHEN @BillType='M' THEN 'Medicare'
					WHEN @BillType='P' THEN 'Patient'
					END AS BillType
		
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLGetClientBillingType') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****ERROR_STATE=' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error /* Message text*/
				,16 /*Severity*/
				,1 /*State*/
				)
	END CATCH
END
