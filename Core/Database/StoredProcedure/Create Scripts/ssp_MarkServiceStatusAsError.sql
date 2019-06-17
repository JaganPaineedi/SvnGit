/****** Object:  StoredProcedure [dbo].[ssp_MarkServiceStatusAsError]    Script Date: 08/22/2016 17:52:19 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_MarkServiceStatusAsError]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_MarkServiceStatusAsError]
GO

/****** Object:  StoredProcedure [dbo].[ssp_MarkServiceStatusAsError]    Script Date: 08/22/2016 17:52:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_MarkServiceStatusAsError] (
	@GroupServiceId INT
	,@clientid NVARCHAR(100)
	,@UserCode VARCHAR(30) = NULL
	)
AS
/*-------------Modification History--------------------------               */
/*-------Date-----------Author------------Purpose---------------------------*/
/*       22-AUG-2016    Akwinass          WHAT: Added @UserCode parameter and Documents table Update Script.
										  WHY:  Task #437 in Key Point - Support Go Live.*/
/*		27-10-2017		Pavani            What : Added condition to avoid services marking as error when it is having balance.
                                          Reference : copied servicedetail error logic from ssp_PMMarkServiceAsError  
                                          Why : Thresholds - Support #1057				  */
/****************************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @AllowServiceErrorWithPayment CHAR(1)

		SELECT @AllowServiceErrorWithPayment = ISNULL(LEFT(dbo.ssf_GetSystemConfigurationKeyValue('ALLOWSERVICEERRORWITHPAYMENT'), 1), 'N')

		--select  top 10* from Services where GroupServiceId=@GroupServiceId and  
		--clientId in(SELECT Token FROM  dbo.SplitString(@clientid, ','))
		IF @UserCode IS NULL
		BEGIN
			SET @UserCode = 'GROUPSERVICEMARKASERROR'
		END

	
		CREATE TABLE #TempCharges (
			ChargeId INT
			,Balance MONEY
			,LedgerType INT
			,CoveragePlanId INT
			,ClientId INT
			,ServiceId INT
			)

		INSERT INTO #TempCharges (
			ChargeId
			,Balance
			,LedgerType
			,ServiceId
			)
		SELECT AR.ChargeId
			,sum(AR.Amount)
			,AR.LedgerType
			,Ch.ServiceId
		FROM ARLedger AR
		INNER JOIN Charges Ch ON (AR.ChargeId = Ch.ChargeId)
		WHERE Ch.ServiceId IN (
				SELECT ServiceId
				FROM services
				WHERE GroupServiceId = @GroupServiceId
				) -- @ServiceId  
		GROUP BY AR.CHargeId
			,AR.LedgerType
			,Ch.ServiceId

	
		IF (@AllowServiceErrorWithPayment = 'N')
		BEGIN
			UPDATE Services
			SET [Status] = 76
				,ModifiedBy = @UserCode
				,ModifiedDate = GETDATE()
			WHERE GroupServiceId = @GroupServiceId and
				ServiceId NOT IN (
					SELECT DISTINCT (ServiceId)
					FROM #TempCharges
					WHERE LedgerType = 4202
						AND balance <> 0
					)
				AND ClientId IN (
					SELECT Token
					FROM dbo.SplitString(@clientid, ',')
					)

			UPDATE Documents
			SET RecordDeleted = 'Y'
				,DeletedBy = @UserCode
				,DeletedDate = GETDATE()
			WHERE ServiceId NOT IN 
				(
					SELECT DISTINCT (ServiceId)
					FROM #TempCharges
					WHERE LedgerType = 4202
						AND balance <> 0
					)
				AND ClientId IN (
					SELECT Token
					FROM dbo.SplitString(@clientid, ',')
					)
					AND serviceid in(SELECT ServiceId FROM Services WHERE GroupServiceId = @GroupServiceId and isnull(recorddeleted,'N')='N')
					
		END
		ELSE
		BEGIN
			UPDATE Services
			SET [Status] = 76
				,ModifiedBy = @UserCode
				,ModifiedDate = GETDATE()
			WHERE GroupServiceId = @GroupServiceId
				AND ClientId IN (
					SELECT Token
					FROM dbo.SplitString(@clientid, ',')
					)

			UPDATE Documents
			SET RecordDeleted = 'Y'
				,DeletedBy = @UserCode
				,DeletedDate = GETDATE()
			WHERE ServiceId IN (
					SELECT ServiceId
					FROM Services
					WHERE GroupServiceId = @GroupServiceId
						AND ClientId IN (
							SELECT Token
							FROM dbo.SplitString(@clientid, ',')
							)
					)
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_MarkServiceStatusAsError') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


