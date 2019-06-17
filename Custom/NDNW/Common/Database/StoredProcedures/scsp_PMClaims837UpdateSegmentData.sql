If Exists (Select * From   sys.Objects 
           Where  Object_Id = Object_Id(N'dbo.scsp_PMClaims837UpdateSegmentData') 
                  And Type In ( N'P', N'PC' )) 
 Drop Procedure dbo.scsp_PMClaims837UpdateSegmentData
Go


create PROC [dbo].[scsp_PMClaims837UpdateSegmentData]
    @CurrentUser VARCHAR(30) ,
    @ClaimBatchId INT ,
    @FormatType CHAR(1) = 'P'
AS /*********************************************************************/
/* Stored Procedure: dbo.scsp_PMClaims837UpdateSegmentData                         */
/* Creation Date:    9/25/06                                         */
/*                                                                   */
/* Purpose:           */
/*                                                                   */
/* Input Parameters:           */
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
/*   Date		Author      Purpose                                    */
/*  9/25/06		JHB			Created                                    */
/*  9/14/2009	avoss		remove additinonal legacy iedntifiers for select coverages  */
/*	07/25/2016	Govind		Added RenderingSecondaryQualifier & RenderingSecondaryID - NDNW Sup Go Live #393*/
/*********************************************************************/

    UPDATE  a
    SET     ApplicationReceiverCode = 'MHO'
    FROM    ClaimBatches AS cb
            JOIN dbo.ssf_RecodeValuesCurrent('X837PHTECHCLAIMFORMATS') AS c ON c.IntegerCodeId = cb.ClaimFormatid
            CROSS JOIN #HIPAAHeaderTrailer AS a
    WHERE   cb.ClaimBatchId = @ClaimBatchId

    IF @@error <> 0 
        GOTO error

    UPDATE  a
    SET     ReceiverLastName = 'PH TECH'
    FROM    ClaimBatches AS cb
            JOIN dbo.ssf_RecodeValuesCurrent('X837PHTECHCLAIMFORMATS') AS c ON c.IntegerCodeId = cb.ClaimFormatid
            CROSS JOIN #837HeaderTrailer AS a
    WHERE   cb.ClaimBatchId = @ClaimBatchId

    IF @@error <> 0 
        GOTO error

-- Payer Name must be set to ECCO for PHTech
    UPDATE  a
    SET     PayerName = 'EOCCO'
    FROM    ClaimBatches AS cb
            JOIN dbo.ssf_RecodeValuesCurrent('X837PHTECHCLAIMFORMATS') AS c ON c.IntegerCodeId = cb.ClaimFormatid
            CROSS JOIN #837SubscriberClients AS a
    WHERE   cb.ClaimBatchId = @ClaimBatchId
            AND a.PayerName LIKE '%EO%CCO%'

-- Remove Claim Filing Indicator Code from all claims
    UPDATE  #837SubscriberClients
    SET     ClaimFilingIndicatorCode = ''

    UPDATE  clms
    SET     RenderingSecondaryQualifier = 'G2' ,
            RenderingSecondaryId = cp.ProviderId
    FROM    #ClaimLines_temp AS a
            JOIN #837Claims AS clms ON clms.ClaimLineId = a.ClaimLineId
            JOIN #Charges AS chg ON chg.ChargeId = a.ChargeId
            JOIN Charges AS chgp ON chgp.ChargeId = chg.ChargeId
            JOIN ClientCoveragePlans AS ccp ON ccp.ClientCoveragePlanId = chgp.ClientCoveragePlanId
            JOIN CoveragePlans AS cp ON cp.CoveragePlanId = ccp.CoveragePlanId
            JOIN Services AS sv ON sv.ServiceId = chg.ServiceId
            JOIN Programs AS p ON p.ProgramId = sv.ProgramId
            CROSS JOIN Agency AS b
            CROSS JOIN ClaimBatches AS cb
    WHERE   p.ServiceAreaId <> 2
            AND cb.ClaimBatchId = @ClaimBatchId
            AND cb.ClaimFormatId = 1006
            AND cp.ElectronicClaimsPayerId = 'ORDHS'





----------------------------NDNW SGL#393----------------------------------------
    UPDATE  clms
    SET     RenderingSecondaryQualifier = 'CD' ,
            RenderingSecondaryID = staf.NationalProviderId--b.NationalProviderId
    FROM    #ClaimLines_temp AS a
            JOIN #837Claims AS clms ON clms.ClaimLineId = a.ClaimLineId
            JOIN #Charges AS chg ON chg.ChargeId = a.ChargeId
            JOIN claimbatchcharges cbc ON cbc.chargeid = chg.chargeid
                                          AND ISNULL(cbc.RecordDeleted, 'N') <> 'Y'
            JOIN claimbatches cb ON cb.claimbatchid = cbc.claimbatchid
                                    AND ISNULL(cb.RecordDeleted, 'N') <> 'Y'
            JOIN Charges AS chgp ON chgp.ChargeId = chg.ChargeId
                                    AND ISNULL(chgp.RecordDeleted, 'N') <> 'Y'
            JOIN dbo.CoveragePlans cov ON cov.CoveragePlanId = cb.CoveragePlanId
                                          AND ISNULL(cov.recorddeleted, 'N') <> 'Y'
            JOIN Services AS sv ON sv.ServiceId = chg.ServiceId
                                   AND ISNULL(sv.recorddeleted, 'N') <> 'Y'
            JOIN Staff AS staf ON staf.StaffId = sv.ClinicianId
                                  AND ISNULL(staf.RecordDeleted, 'N') <> 'Y'
            JOIN Programs AS p ON p.ProgramId = sv.ProgramId
                                  AND ISNULL(p.recorddeleted, 'N') <> 'Y'
            JOIN dbo.ClaimFormats cf ON cb.ClaimFormatId = cf.ClaimFormatId
                                        AND ISNULL(cf.RecordDeleted, 'N') <> 'Y'
            CROSS JOIN Agency AS b
    WHERE   cf.claimformatid <> 1
            AND cb.ClaimBatchId = @ClaimBatchId
            AND p.ServiceAreaId = 2
            AND cb.Coverageplanid IN (
            SELECT  IntegerCodeId
            FROM    dbo.ssf_RecodeValuesCurrent('XCoveragePlanToIncludeForPrintingCD') )
            AND cb.CoverageplanId IN ( SELECT   CoveragePlanId
                                       FROM     CoveragePlanServiceAreas
                                       WHERE    ServiceAreaId = 2
									   AND ISNULL(RecordDeleted,'N') <> 'Y' )
--------------------------------------------------------------------------------

    RETURN

    error:

