IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCRevertAdjustments]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCRevertAdjustments]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCRevertAdjustments] (
	@UserCode VARCHAR(30)
	,@ChargeIds VARCHAR(max)
	,@FinancialActivityLineIds VARCHAR(max)
	)
AS
BEGIN
	/*********************************************************************/
	/* Stored Procedure: dbo.[ssp_SCRevertAdjustments]                */
	/* Creation Date:    10 Feb 2017                                        */
	/* Created By :    Vithobha                               */
	/*                                                                   */
	/* Purpose: To Revert Adjustments   */
	/*                                                                   */
	/*   Updates:                                                          */
	/*       Date              Author                  Purpose                                    */
	/*********************************************************************/
	BEGIN TRY
		DECLARE @PostedAccountingPeriodId INT
		DECLARE @ClientId INT

		CREATE TABLE #ChargeList (ChargeId INT)
		CREATE TABLE #ClientChargeList(ChargeId INT,ClientId INT)
		
		INSERT INTO #ChargeList
		SELECT item
		FROM [dbo].fnSplit(@ChargeIds, ',')

		INSERT INTO #ClientChargeList
		(ChargeId
		,ClientId
		)
		SELECT 
		T.ChargeId
		,S.ClientId
		FROM 
		#ChargeList T
		JOIN Charges C ON C.ChargeId=T.ChargeId
		JOIN Services S ON S.ServiceId=C.ServiceId
		WHERE ISNULL(C.RecordDeleted,'N')='N' AND ISNULL(S.RecordDeleted,'N')='N'

		CREATE TABLE #FinancialActivityLines (FinancialActivityLineId INT)

		INSERT INTO #FinancialActivityLines
		SELECT item
		FROM [dbo].fnSplit(@FinancialActivityLineIds, ',')

		-- update Charges
			UPDATE C
			SET ExternalCollectionStatus = NULL
			FROM Charges C
			JOIN #ClientChargeList T ON T.ChargeId=C.ChargeId
			WHERE C.ChargeId = T.ChargeId
			
			--Update Clients
			UPDATE C
			SET ExternalCollections = 'N'
			FROM Clients C
			JOIN #ClientChargeList T ON T.ClientId = C.ClientId
			WHERE C.ClientId = T.ClientId
			
			--Update ExternalCollectionCharges
			UPDATE E
			SET RecordDeleted = 'Y',
			DeletedBy = @UserCode,
			DeletedDate=Getdate()
			FROM ExternalCollectionCharges E
			JOIN  #ClientChargeList T ON T.ChargeId=E.ChargeId
			WHERE E.ChargeId = T.ChargeId
			AND ISNULL(RecordDeleted, 'N') = 'N'

		DECLARE @ChargeId INT
			,@FinancialActivityLineId INT
			,@AccountingPeriodId INT

		DECLARE FinancialActivityLines_cursor CURSOR
		FOR
		SELECT AR.ChargeId
			,AR.FinancialActivityLineId
			,AR.AccountingPeriodId
		FROM ARLedger AR
		JOIN #FinancialActivityLines FAL ON FAL.FinancialActivityLineId = AR.FinancialActivityLineId
		JOIN #ChargeList CL ON CL.ChargeId = AR.ChargeId
		WHERE ISNULL(AR.RecordDeleted, 'N') = 'N'
			AND ISNULL(MarkedAsError, 'N') <> 'Y'

		OPEN FinancialActivityLines_cursor

		FETCH NEXT
		FROM FinancialActivityLines_cursor
		INTO @ChargeId
			,@FinancialActivityLineId
			,@AccountingPeriodId

		WHILE @@FETCH_STATUS = 0
		BEGIN
			EXEC [ssp_PMDELETEClientLedgerEntries] @FinancialActivityLineId
				,@UserCode
				,@AccountingPeriodId
				,@ClientId
				,NULL
				,@ChargeId

			FETCH NEXT
			FROM FinancialActivityLines_cursor
			INTO @ChargeId
				,@FinancialActivityLineId
				,@AccountingPeriodId
		END

		CLOSE FinancialActivityLines_cursor

		DEALLOCATE FinancialActivityLines_cursor
		
		--Update Clients if they have charges in ExternalCollectionCharges
			UPDATE C
			SET ExternalCollections = 'Y'
			FROM Clients C
			JOIN #ClientChargeList T ON T.ClientId = C.ClientId
			WHERE C.ClientId = T.ClientId
				AND EXISTS (
					SELECT 1
					FROM ExternalCollectionCharges E
					JOIN Charges CR ON CR.ChargeId = E.ChargeId
					JOIN Services S ON S.ServiceId = CR.ServiceId
					WHERE ISNULL(E.Recorddeleted, 'N') = 'N'
						AND S.ClientId = T.ClientId
					)
							
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCRevertAdjustments') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                        
				16
				,-- Severity.                        
				1 -- State.                        
				)
	END CATCH
END
GO



