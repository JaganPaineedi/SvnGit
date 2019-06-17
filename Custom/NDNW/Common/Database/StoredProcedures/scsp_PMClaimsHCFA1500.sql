IF EXISTS ( SELECT  *
            FROM    sys.Objects
            WHERE   Object_Id = OBJECT_ID(N'dbo.scsp_PMClaimsHCFA1500')
                    AND Type IN ( N'P', N'PC' ) ) 
    DROP PROCEDURE dbo.scsp_PMClaimsHCFA1500
Go


CREATE PROC [dbo].[scsp_PMClaimsHCFA1500]
    @CurrentUser VARCHAR(30) ,
    @ClaimBatchId INT
AS /*********************************************************************/
/* Stored Procedure: dbo.scsp_PMClaimsHCFA1500                         */
/* Creation Date:    10/20/06                                         */
/*                                                                   */
/* Purpose:           */
/*                                                                   */
/* Input Parameters:	@CurrentUser	*/
/*			@ClaimBatchId	*/
/*					     */
/*                                                                   */
/* Output Parameters:   837 segment                                            */
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
/*  10/20/06   JHB	  Created                                    */
/*  07/07/2016 MJensen	Default "CD" as rendering id per NDNW go live 393   */
/*	07/18/2016	Govind	Default "CD" applicable only to Covg Plans in the Recode 'XCoveragePlanToIncludeForPrintingCD' 
						and check for Service area at Covg Plan Level & Program Level - NDNW SGL #393*/
/*  07/22/2016  Govind  Add Provider ID for DMAP MH - NDNW SGL #393*/
/*********************************************************************/

    UPDATE  c
    SET     c.Field24gUnits1 = CONVERT(VARCHAR, CONVERT(INT, CONVERT(NUMERIC, c.Field24gUnits1))) ,
            c.Field24gUnits2 = CONVERT(VARCHAR, CONVERT(INT, CONVERT(NUMERIC, c.Field24gUnits2))) ,
            c.Field24gUnits3 = CONVERT(VARCHAR, CONVERT(INT, CONVERT(NUMERIC, c.Field24gUnits3))) ,
            c.Field24gUnits4 = CONVERT(VARCHAR, CONVERT(INT, CONVERT(NUMERIC, c.Field24gUnits4))) ,
            c.Field24gUnits5 = CONVERT(VARCHAR, CONVERT(INT, CONVERT(NUMERIC, c.Field24gUnits5))) ,
            c.Field24gUnits6 = CONVERT(VARCHAR, CONVERT(INT, CONVERT(NUMERIC, c.Field24gUnits6)))
    FROM    ClaimNPIHCFA1500s c
            JOIN ClaimLineItemGroups clig ON clig.ClaimLineItemGroupId = c.ClaimLineItemGroupId
            JOIN ClaimBatches cb ON cb.ClaimBatchId = clig.ClaimBatchId
    WHERE   ( cb.ClaimBatchId = @ClaimBatchId )
            AND ISNULL(clig.RecordDeleted, 'N') = 'N'
            AND ISNULL(c.RecordDeleted, 'N') = 'N'
 
 
--Paper claims: Box 24J on the CMS 1500, the top/shaded portion of that field, please enter “CD”.
    UPDATE  c
    SET     c.Field24jRenderingID1 = CASE WHEN c.Field24dProcedureCode1 IS NOT NULL
                                          THEN 'CD'
                                               + ISNULL(c.Field24jRenderingID1,
                                                        '')
                                          ELSE NULL
                                     END ,
            c.Field24jRenderingID2 = CASE WHEN c.Field24dProcedureCode2 IS NOT NULL
                                          THEN 'CD'
                                               + ISNULL(c.Field24jRenderingID2,
                                                        '')
                                          ELSE NULL
                                     END ,
            c.Field24jRenderingID3 = CASE WHEN c.Field24dProcedureCode3 IS NOT NULL
                                          THEN 'CD'
                                               + ISNULL(c.Field24jRenderingID3,
                                                        '')
                                          ELSE NULL
                                     END ,
            c.Field24jRenderingID4 = CASE WHEN c.Field24dProcedureCode4 IS NOT NULL
                                          THEN 'CD'
                                               + ISNULL(c.Field24jRenderingID4,
                                                        '')
                                          ELSE NULL
                                     END ,
            c.Field24jRenderingID5 = CASE WHEN c.Field24dProcedureCode5 IS NOT NULL
                                          THEN 'CD'
                                               + ISNULL(c.Field24jRenderingID5,
                                                        '')
                                          ELSE NULL
                                     END ,
            c.Field24jRenderingID6 = CASE WHEN c.Field24dProcedureCode6 IS NOT NULL
                                          THEN 'CD'
                                               + ISNULL(c.Field24jRenderingID6,
                                                        '')
                                          ELSE NULL
                                     END
    FROM    ClaimNPIHCFA1500s c
            JOIN ClaimLineItemGroups clig ON clig.ClaimLineItemGroupId = c.ClaimLineItemGroupId
            JOIN ClaimBatches cb ON cb.ClaimBatchId = clig.ClaimBatchId
                                    AND ISNULL(cb.recorddeleted, 'N') <> 'Y'
            JOIN ClaimBatchCharges cbc ON cbc.ClaimBatchId = cb.ClaimBatchId
                                          AND ISNULL(cbc.recorddeleted, 'N') <> 'Y'
            JOIN Charges chg ON chg.ChargeId = cbc.ChargeId
                                AND ISNULL(chg.recorddeleted, 'N') <> 'Y'
            JOIN services ser ON ser.ServiceId = chg.ServiceId
                                 AND ISNULL(ser.recorddeleted, 'N') <> 'Y'
            JOIN Programs AS p ON p.ProgramId = ser.ProgramId
                                  AND ISNULL(p.recorddeleted, 'N') <> 'Y'

    WHERE   ( cb.ClaimBatchId = @ClaimBatchId )
            AND ISNULL(clig.RecordDeleted, 'N') <> 'Y'
            AND ISNULL(c.RecordDeleted, 'N') <> 'Y'
            AND cb.Coverageplanid IN (
            SELECT  IntegerCodeId
            FROM    dbo.ssf_RecodeValuesCurrent('XCoveragePlanToIncludeForPrintingCD') )
            AND p.ServiceAreaId = 2
        	AND cb.CoverageplanId IN (SELECT CoveragePlanId FROM CoveragePlanServiceAreas WHERE ServiceAreaId = 2 AND ISNULL(RecordDeleted,'N') <> 'Y')




    UPDATE  a
    SET     --Field32bFacilityProviderId = cov.ProviderId,
            Field33bBillingProviderId = cov.ProviderId
    FROM    dbo.ClaimNPIHCFA1500s a
            JOIN ClaimLineItemGroups clig ON clig.ClaimLineItemGroupId = a.ClaimLineItemGroupId
                                             AND ISNULL(clig.RecordDeleted,
                                                        'N') <> 'Y'
            JOIN ClaimBatches cb ON cb.ClaimBatchId = clig.ClaimBatchId
                                    AND ISNULL(cb.recorddeleted, 'N') <> 'Y'
            JOIN dbo.CoveragePlans cov ON cov.CoveragePlanId = cb.CoveragePlanId
                                          AND ISNULL(cov.recorddeleted, 'N') <> 'Y'
            JOIN ClaimBatchCharges cbc ON cbc.ClaimBatchId = cb.ClaimBatchId
                                          AND ISNULL(cbc.recorddeleted, 'N') <> 'Y'
            JOIN Charges chg ON chg.ChargeId = cbc.ChargeId
                                AND ISNULL(chg.recorddeleted, 'N') <> 'Y'
            JOIN services ser ON ser.ServiceId = chg.ServiceId
                                 AND ISNULL(ser.recorddeleted, 'N') <> 'Y'
    WHERE   ( cb.ClaimBatchId = @ClaimBatchId )
            AND ISNULL(a.RecordDeleted, 'N') <> 'Y'
            AND cb.Coverageplanid IN (
            SELECT  IntegerCodeId
            FROM    dbo.ssf_RecodeValuesCurrent('XCoveragePlanToIncludeForPrintingProviderID') )





