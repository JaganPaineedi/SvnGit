if object_Id('scsp_PMClaims837UpdateClaimLines','P') is not null
drop proc scsp_PMClaims837UpdateClaimLines
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC scsp_PMClaims837UpdateClaimLines
    @CurrentUser VARCHAR(30)
,   @ClaimBatchId INT
,   @FormatType CHAR(1) = 'P'
AS /*********************************************************************/  
/* Stored Procedure: dbo.scsp_PMClaims837UpdateClaimLines                         */  
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
/*   Date     Author      Purpose                                    */
/*	12 Nov 2018	MJensen		For SA service area use the agency NPI for rendering.  NDNW Enhancements #18	*/

  
--declare @CurrentDate datetime  
  
--set @CurrentDate = getdate()  
  
    UPDATE  a
    SET     RenderingProviderNPI = b.NationalProviderId
    FROM    #ClaimLines AS a
            CROSS JOIN Agency AS b
    WHERE   a.RenderingProviderNPI IS NULL

--
-- for NON-SA Services sent via office ally, set the "provider commercial number" in claim lines"
--

    UPDATE  a
    SET     ProviderCommercialNumber = cp.ProviderId
    FROM    #ClaimLines AS a
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

--
-- Set rendering NPI for service area SA
--
UPDATE cl
SET RenderingProviderNPI = ag.NationalProviderId
FROM #ClaimLines AS cl
JOIN Programs AS p ON p.Programid = cl.Programid
JOIN ProcedureCodes AS pc ON pc.ProcedureCodeId = cl.ProcedureCodeId
CROSS JOIN Agency AS ag
WHERE p.ServiceAreaId = 2
	AND NOT (
		isnull(pc.BedProcedureCode, 'N') = 'Y'
		AND cl.CoveragePlanId IN (
			SELECT IntegerCodeId
			FROM dbo.ssf_RecodeValuesAsOfDate('XCoveragePlansToUseSupervisorNPI', cl.DateOfService)
			)
		)
--
-- for all formats, overwrite the rendering NPI with the agency NPI
-- when the service area is SA
--

    --#############################################################################
    -- commented out with code that follows to replace
    --############################################################################# 
    --UPDATE  a
    --SET     RenderingProviderNPI = b.NationalProviderId
    --FROM    #ClaimLines AS a
    --        JOIN #Charges AS chg ON chg.ChargeId = a.ChargeId
    --        JOIN Services AS sv ON sv.ServiceId = chg.ServiceId
    --        JOIN Programs AS p ON p.ProgramId = sv.ProgramId
    --        CROSS JOIN Agency AS b
    --WHERE   p.ServiceAreaId = 2

    --#############################################################################
    --Program tags – SUD providers must use program tags when submitting claims/electronic files
 
    --Paper claims: Box 24J on the CMS 1500, the top/shaded portion of that field, please enter “CD”.
    --Electronic claims: Please enter “CD” in the 2310B loop (REF segment, Secondary ID)
    --Please complete in TRAIN for initial testing
    --############################################################################# 

   -- UPDATE  a
   -- SET     RenderingProviderNPI = b.NationalProviderId,
   --        RenderingProviderID = 'CD'
   -- FROM    #ClaimLines AS a
   --         JOIN #Charges AS chg ON chg.ChargeId = a.ChargeId
   --         --JOIN Services AS sv ON sv.ServiceId = chg.ServiceId
   --         --JOIN Programs AS p ON p.ProgramId = sv.ProgramId
   --         CROSS JOIN Agency AS b
			--JOIN claimbatchcharges cbc ON cbc.chargeid = chg.chargeid
   --                                       AND ISNULL(cbc.RecordDeleted, 'N') = 'N'
   --         JOIN claimbatches cb ON cb.claimbatchid = cbc.claimbatchid
   --                                 AND ISNULL(cb.RecordDeleted, 'N') = 'N'
   --         JOIN charges c ON c.chargeid = cbc.chargeid
   --                           AND ISNULL(c.RecordDeleted, 'N') = 'N'
   --         JOIN services s ON s.serviceid = c.serviceid
   --                            AND ISNULL(s.RecordDeleted, 'N') = 'N'
   --         JOIN dbo.ClaimFormats cf ON cb.ClaimFormatId = cf.ClaimFormatId
   --                                     AND ISNULL(cf.RecordDeleted, 'N') = 'N'
			--WHERE   cb.ClaimBatchId = @ClaimBatchId
   --         AND cf.claimformatid <> 1
			--AND cb.Coverageplanid IN (
   --         SELECT  IntegerCodeId
   --         FROM    dbo.ssf_RecodeValuesCurrent('XCoveragePlanToIncludeForPrintingCD') )
			--AND cb.CoverageplanId IN (SELECT CoveragePlanId FROM CoveragePlanServiceAreas WHERE ServiceAreaId = 2)
			--AND s.ProgramId IN (SELECT ProgramId FROM Programs WHERE ServiceAreaId = 2)










    error:  
  
  
  





GO
