If Exists (Select * From   sys.Objects 
           Where  Object_Id = Object_Id(N'dbo.scsp_PMClaimsHCFA1500UpdateClaimLines') 
                  And Type In ( N'P', N'PC' )) 
 Drop Procedure dbo.scsp_PMClaimsHCFA1500UpdateClaimLines
Go

/****** Object:  StoredProcedure [dbo].[scsp_PMClaimsHCFA1500UpdateClaimLines]    Script Date: 7/8/2016 9:33:15 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROC [dbo].[scsp_PMClaimsHCFA1500UpdateClaimLines]
    @CurrentUser VARCHAR(30)
,   @ClaimBatchId INT
,   @FormatType CHAR(1) = 'P'
AS /*********************************************************************/
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
/*  9/25/06     JHB	      Created    
/*  11/17/2015 Govind     Added Update CL block and modified facility address 2 to NULL - ND SupGo Live Task#142*/
/*  4/20/16 jwheeler removed hardcoding of facility name   nd support go live task 324 */ 
/*  7/7/2016 mjensen removed hard code of "CD" in rendering provider per nd support go live task 393 */
/*	12 Nov 2018	MJensen		For SA service area use the agency NPI for rendering.  NDNW Enhancements #18	*/
/*********************************************************************/
*/

    UPDATE  CL
    SET     --  FacilityName = 'New Directions Northwest',
            FacilityName = b.FacilityName
    ,       FacilityTaxIdType = b.FacilityTaxIdType
    ,       FacilityTaxId = b.FacilityTaxId
    ,       FacilityAddress1 = b.FacilityAddress1
    ,       FacilityAddress2 = NULL
    , --b.FacilityAddress2,
            FacilityCity = b.facilityCity
    ,       FacilityState = b.FacilityState
    ,       FacilityZip = b.FacilityZip
    ,       FacilityPhone = b.FacilityPhone
       --PayToProviderLastName = ''
    FROM    #ClaimLines CL
            JOIN #Charges AS b ON b.chargeid = CL.chargeid
            JOIN ClaimBatchCharges AS cbc ON cbc.ChargeId = b.Chargeid
            JOIN ClaimBatches AS cb ON cb.ClaimBatchId = cbc.ClaimBatchId
            JOIN ClaimFormats AS cf ON cf.ClaimFormatId = cb.ClaimFormatId
    WHERE   cb.ClaimBatchId = @ClaimBatchId
            AND ISNULL(cf.Electronic, 'N') = 'N'


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

	
    --#############################################################################
    --Program tags – SUD providers must use program tags when submitting claims/electronic files
 
    --Paper claims: Box 24J on the CMS 1500, the top/shaded portion of that field, please enter “CD”.
    --Electronic claims: Please enter “CD” in the 2310B loop (REF segment, Secondary ID)
    --Please complete in TRAIN for initial testing
    --############################################################################# 
    
	
	-- 7/7/2016 mjensen moved to scsp_ PMClaimsHCFA1500 causing validation error
    --UPDATE  a
    --SET     RenderingProviderID = 'CD'
    --FROM    #ClaimLines AS a
    --        JOIN #Charges AS chg ON chg.ChargeId = a.ChargeId
    --        JOIN Services AS sv ON sv.ServiceId = chg.ServiceId
    --        JOIN Programs AS p ON p.ProgramId = sv.ProgramId
    --        CROSS JOIN Agency AS b
    --WHERE   p.ServiceAreaId = 2



--EXEC scsp_PMClaimsHCFA1500UpdateClaimLines 'kweirick',279,'P'




GO


