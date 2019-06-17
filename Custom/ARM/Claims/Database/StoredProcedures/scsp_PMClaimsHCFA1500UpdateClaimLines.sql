IF OBJECT_ID('scsp_PMClaimsHCFA1500UpdateClaimLines','P') IS NOT NULL
DROP PROC scsp_PMClaimsHCFA1500UpdateClaimLines
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC scsp_PMClaimsHCFA1500UpdateClaimLines 
@CurrentUser VARCHAR(30), @ClaimBatchId INT, @FormatType CHAR(1) = 'P'
AS
/*********************************************************************/
/* Stored Procedure: dbo.scsp_PMClaimsHCFA1500UpdateClaimLines                         */
/* Creation Date:    9/25/06                                         */
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
/*   Date     Author      Purpose                                    */
/*  9/25/06   JHB	  Created                                    */
/*	8/18/2018	MAJ		For medicare  put CLIA number in Authorization field.  ARM Enhancements #50		*/
/*********************************************************************/

UPDATE cl 
SET AuthorizationNumber = dbo.ssf_GetSystemConfigurationKeyValue('XAgencyCLIANumber')
FROM #ClaimLines cl
WHERE cl.CoveragePlanId IN (SELECT IntegerCodeId FROM dbo.ssf_RecodeValuesCurrent('PlansThatRequireCLIANumber'))
AND BillingCode = '80305'

GO


