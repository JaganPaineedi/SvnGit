IF OBJECT_ID('csp_PMClaims837UpdateClaimLines','P') is not NULL
DROP PROC csp_PMClaims837UpdateClaimLines
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROC [dbo].[csp_PMClaims837UpdateClaimLines] 
@CurrentUser VARCHAR(30), @ClaimBatchId INT, @FormatType CHAR(1) = 'P'
AS
/*********************************************************************/
/* Stored Procedure: dbo.csp_PMClaims837UpdateClaimLines              */
/* Creation Date:    12/27/2017                                       */
/*                                                                   */
/* Purpose:           */
/*                                                                   */

/* Input Parameters:						     */
/*                                                                   */
/* Output Parameters:                                                */
/*                                                                   */
/* Return Status:                                                    */
/*                                                                   */
/* Called By:       */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/* Updates:                                                          */
/*																	*/
/*	12/13/2017	MJensen	Update modifiers for BH Redesign			*/
/*	07/10/2018	MJensen	Older MCO claims must use older Electronic claims payer id	ARM Enhancements #40	*/
/*********************************************************************/

declare @CurrentDate datetime

SET @CurrentDate = GETDATE()

--
-- Changes for BH Redesign - remove modifiers when billing by supervisor
--
if exists (
	select *
	from ClaimBatches as cb
	join dbo.ssf_RecodeValuesCurrent('XBHREDESIGNCLAIMFORMATS') as rcf on rcf.IntegerCodeId = cb.ClaimFormatId
	where cb.ClaimBatchId = @ClaimBatchId
)
begin
	UPDATE cl
	SET Modifier1 = CASE 
			WHEN Modifier1 LIKE 'U%'
				THEN NULL
			ELSE Modifier1
			END
		,Modifier2 = CASE 
			WHEN Modifier2 LIKE 'U%'
				THEN NULL
			ELSE Modifier2
			END
		,Modifier3 = CASE 
			WHEN Modifier3 LIKE 'U%'
				THEN NULL
			ELSE Modifier3
			END
		,Modifier4 = CASE 
			WHEN Modifier4 LIKE 'U%'
				THEN NULL
			ELSE Modifier4
			END
	FROM #ClaimLines cl
	WHERE SupervisingProvider2310DLastName IS NOT NULL
			AND BillingCode NOT LIKE '96%'
			

	-- don't leave orphan modifiers
	UPDATE cl
	SET Modifier1 = Modifier2
		,Modifier2 = Modifier3
		,Modifier3 = Modifier4
		,Modifier4 = NULL
	FROM #ClaimLines cl
	WHERE Modifier1 IS NULL

	UPDATE cl
	SET Modifier2 = Modifier3
		,Modifier3 = Modifier4
		,Modifier4 = NULL
	FROM #ClaimLines cl
	WHERE Modifier2 IS NULL

	UPDATE cl
	SET Modifier3 = Modifier4
		,Modifier4 = NULL
	FROM #ClaimLines cl
	WHERE Modifier3 IS NULL

END			

-- for older MCO claims force in old electronic claims payer id
IF (
		SELECT ClaimFormatId
		FROM ClaimBatches
		WHERE ClaimBatchId = @ClaimBatchId
		) = 10016
BEGIN
	UPDATE O
	SET ElectronicClaimsPayerId = 'MMISODJFS'
	FROM #OtherInsured o
	JOIN CustomBHRCoveragePlanClaimFormats bhr ON bhr.CoveragePlanId = o.CoveragePlanId
	JOIN Charges C ON c.ChargeId = o.ChargeId
	JOIN Services s ON s.ServiceId = C.ServiceId
	WHERE Isnull(bhr.RecordDeleted, 'N') = 'N'
		AND bhr.ClaimFormatAfterMCO IS NOT NULL
		AND s.DateOfService < CAST((
				SELECT Value
				FROM SystemConfigurationKeys
				WHERE [Key] = 'XBHRedesignNPIMandatoryEffectiveDate'
					AND Isnull(RecordDeleted, 'N') = 'N'
				) AS DATE);
END;

