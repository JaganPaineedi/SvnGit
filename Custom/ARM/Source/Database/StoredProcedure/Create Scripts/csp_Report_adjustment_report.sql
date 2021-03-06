/****** Object:  StoredProcedure [dbo].[csp_Report_adjustment_report]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_adjustment_report]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_adjustment_report]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_adjustment_report]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE	PROCEDURE	[dbo].[csp_Report_adjustment_report]
		@month int,
		@year int,
		@user_id varchar(10)

AS
--*/

/*
DECLARE	@month int,
		@year int,
		@user_id varchar(10)

SELECT	@month = 6,
		@year = 2012,
		@user_id = ''huling''
--*/


/********************************************************************/
/* Stored Procedure: csp_Report_adjustment_report					*/
/*																	*/
/* Updates:															*/
/* Date			Author		Purpose									*/
/* 07/02/2012	Jess		Converted From PsychConsult				*/
/********************************************************************/
DECLARE	@StartDate Date
SET		@StartDate = convert(varchar, @month) + ''/1/'' + convert(varchar, @year)

SELECT	AR.PostedDate,
		AR.CreatedBy,
		AR.ClientId,
		C.LastName + '', '' + C.FirstName AS ''Client'',
		AR.DateOfService,
		COALESCE(CP.DisplayAs, ''Client'') AS ''Coverage Plan ID'',
		AR.Amount,
		CASE	WHEN	(	AR.LedgerType = 4202	-- Payment - When Negative, Then Refund?
						AND	AR.Amount > 0
						)
				THEN	''Refund''
				WHEN	AR.LedgerType = 4204	-- Transfer
				THEN	''Transfer''
				WHEN	(	AR.LedgerType = 4203	-- Adjustment
						AND	AR.AdjustmentCode <> 1000317	-- LOSS-BAD DEBT (Meaning it''s not a writeoff)
						)
				THEN	''Adjustment''
				WHEN	(	AR.LedgerType = 4203	-- Adjustment
						AND	AR.AdjustmentCode = 1000317	-- LOSS-BAD DEBT
						)
				THEN	''Writeoff''
				ELSE	''Unknown''
		END	AS	''Subtype'',
		GC.CodeName,
		AP.StartDate,
		AP.EndDate
FROM	ARLedger AR
JOIN	AccountingPeriods AP
ON		AR.AccountingPeriodId = AP.AccountingPeriodId
JOIN	Clients C
ON		AR.ClientId = C.ClientId
LEFT	JOIN	CoveragePlans CP
ON		AR.CoveragePlanId = CP.CoveragePlanId
LEFT	JOIN	GlobalCodes GC
ON		AR.AdjustmentCode = GC.GlobalCodeId
WHERE	AP.StartDate = @StartDate
AND		AR.CreatedBy like @user_id
AND		AR.LedgerType in (''4202'', ''4203'', ''4204'')	--Payment, Transfer, Adjustment
ORDER	BY
		AR.CreatedBy,
		AR.DateOfService,
		''Client''

' 
END
GO
