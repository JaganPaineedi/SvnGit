
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'csp_RDLRevenueAdjustmentWithARBalance') AND type IN ( N'P', N'PC' ))
	DROP PROCEDURE csp_RDLRevenueAdjustmentWithARBalance
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE dbo.csp_RDLRevenueAdjustmentWithARBalance
@FromDate date
, @ToDate date
AS
/************************************************************************************************
Stored Procedure: csp_RDLRevenueAdjustmentWithARBalance

Created By:	Jay
Purpose:	What: Create report that pulls AR Balances for certain time periods.
			Why: New Directions Enhancement 24

Test Call:
			EXEC csp_RDLRevenueAdjustmentWithARBalance '1/1/18', '12/31/19'

Change Log: 
2019-01-04 jwheeler		Created ; New Directions Enhancement 24

****************************************************************************************************/
BEGIN

	DECLARE @CRLF char(2) = char(13) + char(10);
	DECLARE @ErrorMessage varchar(MAX) = @CRLF;
	DECLARE @Bookmark varchar(MAX) = 'Init'; --#EH!INFO!ADD!@Bookmark!

	BEGIN TRY

		;WITH Buckets AS (
			SELECT	gc.GlobalCodeId			AS LedgerType
					, gc.CodeName			AS LedgerTypeName
					, CASE
						WHEN gc.GlobalCodeId IN ( 4201, 4204 ) THEN 'Revenue'
						ELSE gc.CodeName + 's'
					END						AS ColGrouping
			FROM	dbo.GlobalCodes AS gc
			WHERE	gc.Category = 'ARLEDGERTYPE'
		), RptStuff AS (
			SELECT	ISNULL(cp.CoveragePlanId, 0)	AS CoveragePlanId
					, B.ColGrouping					AS LedgerType
					, SUM(AL.Amount)				AS Amount
			FROM	dbo.ARLedger AL
					JOIN Buckets B ON B.LedgerType = AL.LedgerType
					JOIN dbo.AccountingPeriods AP ON AP.AccountingPeriodId = AL.AccountingPeriodId
					LEFT JOIN dbo.CoveragePlans cp ON cp.CoveragePlanId = AL.CoveragePlanId
			WHERE	AP.StartDate >= @FromDate
					AND AP.StartDate < @ToDate
					AND ISNULL(AL.RecordDeleted, 'N') = 'N'
			GROUP BY cp.CoveragePlanId
					, cp.CoveragePlanName
					, B.ColGrouping
		), Amounts AS (
			SELECT	* FROM RptStuff r
			UNION ALL
			SELECT	ISNULL(AL.CoveragePlanId, 0), 'Balance', SUM(AL.Amount)
			FROM	dbo.ARLedger AL 
			WHERE	ISNULL(AL.RecordDeleted, 'N') = 'N'
			GROUP BY ISNULL(AL.CoveragePlanId, 0)
		)
		SELECT	A.coveragePlanId
				, ISNULL(cp.CoveragePlanName, 'Client Liability') AS CoveragePlanName
				, A.ledgertype
				, A.Amount
		FROM	Amounts A
				LEFT JOIN dbo.CoveragePlans cp ON cp.CoveragePlanId = A.coveragePlanId
		UNION ALL SELECT -1000, 'Balance', 'Balance', 0
		UNION ALL SELECT -100, 'Revenue', 'Revenue', 0
		UNION ALL SELECT -10, 'Adjustments', 'Adjustments', 0
		UNION ALL SELECT -1, 'Payments', 'Payments', 0
		;

	END TRY

	BEGIN CATCH		--SQL Prompt Formatting Off
 
		DECLARE @ErrorBlockLineLen integer = 0
		DECLARE @ErrorBlockGotTheFormat bit = 0
		DECLARE @ErrorFormatIndent integer = 3
		DECLARE @ErrorBlockBeenThrough integer = NULL -- must be set to null
		DECLARE @ThisProcedureName varchar(255) = ISNULL(OBJECT_NAME(@@PROCID), 'Testing')
		DECLARE @ErrorProc varchar(4000) = CONVERT(varchar(4000), ISNULL(ERROR_PROCEDURE(), @ThisProcedureName))

		WHILE @ErrorBlockGotTheFormat = 0
		BEGIN

			IF @ErrorBlockBeenThrough IS NOT NULL
				SELECT @ErrorBlockGotTheFormat = 1;

			SET @errormessage = Space(isnull(@ErrorFormatIndent,0)) + @ThisProcedureName + ' Reports Error Thrown by: ' + @ErrorProc + char(13) + char(10)
			;
			SET @errormessage += char(13) + char(10) + Space(isnull(@ErrorFormatIndent,0)) +'-------->'
				+ ISNULL(CONVERT(varchar(4000), ERROR_MESSAGE()), 'Unknown') + '<--------' + char(13) + char(10)
				+ Space(isnull(@ErrorFormatIndent,0)) + REPLICATE('=', @ErrorBlockLineLen) + char(13) + char(10)
				+ Space(isnull(@ErrorFormatIndent,0)) + UPPER(@ThisProcedureName + ' Variable dump:') + char(13) + char(10)
				+ Space(isnull(@ErrorFormatIndent,0)) + REPLICATE('=', @ErrorBlockLineLen) + char(13) + char(10)
				+ Space(isnull(@ErrorFormatIndent,0)) + '@FromDate:.....<' + ISNULL(CAST(@FromDate		AS varchar(125)), 'Null') + '>' + char(13) + char(10)
				+ Space(isnull(@ErrorFormatIndent,0)) + '@ToDate:.......<' + ISNULL(CAST(@ToDate		AS varchar(125)), 'Null') + '>' + char(13) + char(10)
				+ Space(isnull(@ErrorFormatIndent,0)) + '@Bookmark:.....<' + ISNULL(CAST(@Bookmark		AS varchar(125)), 'Null') + '>' + char(13) + char(10)
			;

			SELECT	@ErrorBlockLineLen = MAX(LEN(RTRIM(item)))
			FROM	dbo.fnSplit(@errormessage, char(13) + char(10))
			;

			SELECT @ErrorBlockBeenThrough = 1;

		END
		RAISERROR('%s', 16, 1, @errormessage);		--SQL Prompt Formatting On

	END CATCH

END

GO

