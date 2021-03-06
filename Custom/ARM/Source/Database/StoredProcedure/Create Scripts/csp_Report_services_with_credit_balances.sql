/****** Object:  StoredProcedure [dbo].[csp_Report_services_with_credit_balances]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_services_with_credit_balances]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_services_with_credit_balances]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_services_with_credit_balances]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE	PROCEDURE	[dbo].[csp_Report_services_with_credit_balances]
		@start_date	datetime,
		@end_date	datetime
AS
--*/

/*
DECLARE	@start_date	datetime,
		@end_date	datetime

SELECT	@start_date =	''7/1/09'',
		@end_date =	''6/30/10''
--*/


/********************************************************************/
/* Stored Procedure: csp_Report_services_with_credit_balances		*/
/*			(formerly csp_transactions_with_credit_balances)		*/
/*																	*/
/* Updates:															*/
/* Date			Author		Purpose									*/
/* 07/02/2012	Jess		Converted From PsychConsult				*/
/********************************************************************/

SELECT	CL.ClientId,
		CL.LastName + '', '' + CL.FirstName AS ''Client'',
		S.DateOfService,
		OC.Balance,
		COALESCE(CP.DisplayAs, ''CLIENT'') AS ''CoveragePlan''

FROM	OpenCharges OC
JOIN	Charges C
ON		OC.ChargeId = C.ChargeId
LEFT	JOIN	ClientCoveragePlans CCP
ON		C.ClientCoveragePlanId = CCP.ClientCoveragePlanId
LEFT	JOIN	CoveragePlans CP
ON		CCP.CoveragePlanId = CP.CoveragePlanId
JOIN	Services S
ON		C.ServiceId = S.ServiceId
JOIN	Clients CL
ON		S.ClientId = CL.ClientId
WHERE	OC.Balance < 0
AND		S.DateOfService between @start_date and dateadd(dd, 1, @end_date)
ORDER	BY
		CL.ClientId
		
' 
END
GO
