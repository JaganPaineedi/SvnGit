/****** Object:  StoredProcedure [dbo].[ssp_PMGetNextBillablePayer]    Script Date: 09/11/2015 12:13:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[ssp_PMGetNextBillablePayer]
    @ClientId INT ,
    @ServiceId INT ,
    @DateOfService DATETIME ,
    @ProcedureCodeId INT ,
    @ClinicianId INT ,
    @ClientCoveragePlanId INT ,
    @NextClientCoveragePlanId INT OUTPUT
AS /*********************************************************************
-- Stored Procedure: dbo.ssp_PMGetNextBillablePayer
-- Creation Date:    11/27/06
--
-- Purpose:
--
-- Updates:
--   Date      Author      Purpose
--  11/27/06   JHB         Created
--  07/09/09   SFarber     Added check for ClientCoverageHistory.RecorDeleted flag
--  06/21/12   MSuma       Added additional condition to check for ServiceArea
--  06/22/13   T.Remisoski Removed code that would allow coverage plans outside service area to be used.
--  09/12/13   SFarber     Added additional checks for service area in 'not exists' parts.
--  01/21/14   John S	   Added back the logic related to "ProgramPlans"
--  09/11/15   NJain	   Added UseBillingRulesTemplateId IS NULL condition
						   When a plan has rules defined for it and then its changed to use another plan as template, the rules initially created for the plan do not go away. This can cause issues if the new rules are different from the old ones. This new condition should prevent this by only looking at rules for the current plan when there isn't a template associated with it.
*********************************************************************/

  -- If @ClientCoveragePlanId is null then get the first billable

    DECLARE @ProgramId INT
    DECLARE @ServiceAreaID INT
    SELECT  @ProgramId = ProgramId
    FROM    Services
    WHERE   ServiceID = @ServiceId
    SELECT  @ServiceAreaID = ServiceAreaId
    FROM    Programs
    WHERE   ProgramId = @ProgramId

    IF @ClientCoveragePlanId IS NULL
        BEGIN

            SELECT  @NextClientCoveragePlanId = CCH1.ClientCoveragePlanId
            FROM    ClientCoveragePlans CCP1
                    JOIN ClientCoverageHistory CCH1 ON ( CCH1.ClientCoveragePlanId = CCP1.ClientCoveragePlanId
                                                         AND CCH1.ServiceAreaId = @ServiceAreaID
                                                       )
                    JOIN CoveragePlans CP1 ON ( CCP1.CoveragePlanId = CP1.CoveragePlanId )
                    LEFT JOIN CoveragePlanRules CPR1 ON ( ( ( CP1.CoveragePlanId = CPR1.CoveragePlanId
                                                              AND CP1.UseBillingRulesTemplateId IS NULL
                                                            )
                                                            OR CP1.UseBillingRulesTemplateId = CPR1.CoveragePlanId
                                                          )
		-- JHB 12/1/06
		
		
                                                          AND ISNULL(CPR1.RecordDeleted, 'N') = 'N'
                                                          AND CPR1.RuleTypeId = 4267
                                                        )
                    LEFT JOIN CoveragePlanRuleVariables CPRV1 ON ( CPR1.CoveragePlanRuleId = CPRV1.CoveragePlanRuleId
                                                                   AND ( CPRV1.ProcedureCodeId = @ProcedureCodeId )
                                                                   AND ( ISNULL(CPRV1.RecordDeleted, 'N') = 'N' )
                                                                 )
            WHERE   CCP1.ClientId = @ClientId
                    AND CCH1.StartDate <= @DateOfService
                    AND ( CCH1.EndDate IS NULL
                          OR CCH1.EndDate >= CONVERT(DATETIME, CONVERT(VARCHAR, @DateOfService, 101))
                        )
                    AND ISNULL(CCP1.RecordDeleted, 'N') = 'N'
                    AND ISNULL(CCH1.RecordDeleted, 'N') = 'N'
                    AND CPRV1.RuleVariableId IS NULL
                    AND ISNULL(CPR1.AppliesToAllProcedureCodes, 'N') = 'N'
                    AND NOT EXISTS ( SELECT *
                                     FROM   ProgramPlans pp1
                                     WHERE  pp1.CoveragePlanId = ccp1.CoveragePlanId
                                            AND pp1.ProgramId = @ProgramId
                                            AND ISNULL(pp1.RecordDeleted, 'N') = 'N' )
                    AND NOT EXISTS ( SELECT *
                                     FROM   ClientCoveragePlans CCP2
                                            JOIN ClientCoverageHistory CCH2 ON ( CCH2.ClientCoveragePlanId = CCP2.ClientCoveragePlanId
                                                                                 AND CCH2.ServiceAreaId = @ServiceAreaID
                                                                               )
                                            JOIN CoveragePlans CP2 ON ( CCP2.CoveragePlanId = CP2.CoveragePlanId )
                                            LEFT JOIN CoveragePlanRules CPR2 ON ( ( ( CP2.CoveragePlanId = CPR2.CoveragePlanId
                                                                                      AND CP2.UseBillingRulesTemplateId IS NULL
                                                                                    )
                                                                                    OR CP2.UseBillingRulesTemplateId = CPR2.CoveragePlanId
                                                                                  )
            -- JHB 12/1/06
                                                                                  AND ISNULL(CPR2.RecordDeleted, 'N') = 'N'
                                                                                  AND CPR2.RuleTypeId = 4267
                                                                                )
                                            LEFT JOIN CoveragePlanRuleVariables CPRV2 ON ( CPR2.CoveragePlanRuleId = CPRV2.CoveragePlanRuleId
                                                                                           AND ( CPRV2.ProcedureCodeId = @ProcedureCodeId )
                                                                                           AND ( ISNULL(CPRV2.RecordDeleted, 'N') = 'N' )
                                                                                         )
                                     WHERE  CCP2.ClientId = @ClientId
                                            AND CCH2.StartDate <= @DateOfService
                                            AND ( CCH2.EndDate IS NULL
                                                  OR CCH2.EndDate >= CONVERT(DATETIME, CONVERT(VARCHAR, @DateOfService, 101))
                                                )
                                            AND CCH2.COBOrder < CCH1.COBOrder
                                            AND ISNULL(CCP2.RecordDeleted, 'N') = 'N'
                                            AND ISNULL(CCH2.RecordDeleted, 'N') = 'N'
                                            AND CPRV2.RuleVariableId IS NULL
                                            AND ISNULL(CPR2.AppliesToAllProcedureCodes, 'N') = 'N'
                                            AND NOT EXISTS ( SELECT *
                                                             FROM   ProgramPlans pp2
                                                             WHERE  pp2.CoveragePlanId = ccp2.CoveragePlanId
                                                                    AND pp2.ProgramId = @ProgramId
                                                                    AND ISNULL(pp2.RecordDeleted, 'N') = 'N' ) )

  -- 2013.06.22 - TER - removed code that ignores service area id.  coverage history must be active in the service are to be used to pay for a service provided in that area


        END
    ELSE
        BEGIN

            SELECT  @NextClientCoveragePlanId = CCH1.ClientCoveragePlanId
            FROM    ClientCoveragePlans z
                    JOIN ClientCoverageHistory a ON ( a.ClientCoveragePlanId = z.ClientCoveragePlanId
                                                      AND a.ServiceAreaId = @ServiceAreaID
                                                    )
                    JOIN ClientCoveragePlans CCP1 ON ( z.ClientId = CCP1.ClientId )
                    JOIN ClientCoverageHistory CCH1 ON ( CCH1.ClientCoveragePlanId = CCP1.ClientCoveragePlanId
                                                         AND CCH1.ServiceAreaId = @ServiceAreaID
                                                       )
                    JOIN CoveragePlans CP1 ON ( CCP1.CoveragePlanId = CP1.CoveragePlanId )
                    LEFT JOIN CoveragePlanRules CPR1 ON ( ( ( CP1.CoveragePlanId = CPR1.CoveragePlanId
                                                              AND CP1.UseBillingRulesTemplateId IS NULL
                                                            )
                                                            OR CP1.UseBillingRulesTemplateId = CPR1.CoveragePlanId
                                                          )
        -- JHB 12/1/06
                                                          AND ISNULL(CPR1.RecordDeleted, 'N') = 'N'
                                                          AND CPR1.RuleTypeId = 4267
                                                        )
                    LEFT JOIN CoveragePlanRuleVariables CPRV1 ON ( CPR1.CoveragePlanRuleId = CPRV1.CoveragePlanRuleId
                                                                   AND ( CPRV1.ProcedureCodeId = @ProcedureCodeId )
        -- JHB 12/1/06
                                                                   AND ISNULL(CPRV1.RecordDeleted, 'N') = 'N'
                                                                 )
            WHERE   z.ClientId = @ClientId
                    AND a.StartDate <= @DateOfService
                    AND ( a.EndDate IS NULL
                          OR a.EndDate >= CONVERT(DATETIME, CONVERT(VARCHAR, @DateOfService, 101))
                        )
                    AND a.ClientCoveragePlanId = @ClientCoveragePlanId
                    AND CCH1.StartDate <= @DateOfService
                    AND ( CCH1.EndDate IS NULL
                          OR CCH1.EndDate >= CONVERT(DATETIME, CONVERT(VARCHAR, @DateOfService, 101))
                        )
                    AND CCH1.COBOrder > a.COBOrder
                    AND ISNULL(CCP1.RecordDeleted, 'N') = 'N'
                    AND ISNULL(CCH1.RecordDeleted, 'N') = 'N'
                    AND CPRV1.RuleVariableId IS NULL
                    AND ISNULL(CPR1.AppliesToAllProcedureCodes, 'N') = 'N'
                    AND NOT EXISTS ( SELECT *
                                     FROM   ProgramPlans pp1
                                     WHERE  pp1.CoveragePlanId = ccp1.CoveragePlanId
                                            AND pp1.ProgramId = @ProgramId
                                            AND ISNULL(pp1.RecordDeleted, 'N') = 'N' )
                    AND NOT EXISTS ( SELECT *
                                     FROM   ClientCoveragePlans CCP2
                                            JOIN ClientCoverageHistory CCH2 ON ( CCH2.ClientCoveragePlanId = CCP2.ClientCoveragePlanId
                                                                                 AND CCH2.ServiceAreaId = @ServiceAreaID
                                                                               )
                                            JOIN CoveragePlans CP2 ON ( CCP2.CoveragePlanId = CP2.CoveragePlanId )
                                            LEFT JOIN CoveragePlanRules CPR2 ON ( ( ( CP2.CoveragePlanId = CPR2.CoveragePlanId
                                                                                      AND CP2.UseBillingRulesTemplateId IS NULL
                                                                                    )
                                                                                    OR CP2.UseBillingRulesTemplateId = CPR2.CoveragePlanId
                                                                                  )
            -- JHB 12/1/06
                                                                                  AND ISNULL(CPR2.RecordDeleted, 'N') = 'N'
                                                                                  AND CPR2.RuleTypeId = 4267
                                                                                )
                                            LEFT JOIN CoveragePlanRuleVariables CPRV2 ON ( CPR2.CoveragePlanRuleId = CPRV2.CoveragePlanRuleId
                                                                                           AND ( CPRV2.ProcedureCodeId = @ProcedureCodeId )
            -- JHB 12/1/06
                                                                                           AND ISNULL(CPRV2.RecordDeleted, 'N') = 'N'
                                                                                         )
                                     WHERE  CCP2.ClientId = @ClientId
                                            AND CCH2.StartDate <= @DateOfService
                                            AND ( CCH2.EndDate IS NULL
                                                  OR CCH2.EndDate >= CONVERT(DATETIME, CONVERT(VARCHAR, @DateOfService, 101))
                                                )
                                            AND CCH2.COBOrder > a.COBOrder
                                            AND CCH2.COBOrder < CCH1.COBOrder
                                            AND ISNULL(CCP2.RecordDeleted, 'N') = 'N'
                                            AND ISNULL(CCH2.RecordDeleted, 'N') = 'N'
                                            AND CPRV2.RuleVariableId IS NULL
                                            AND ISNULL(CPR2.AppliesToAllProcedureCodes, 'N') = 'N'
                                            AND NOT EXISTS ( SELECT *
                                                             FROM   ProgramPlans pp2
                                                             WHERE  pp2.CoveragePlanId = ccp2.CoveragePlanId
                                                                    AND pp2.ProgramId = @ProgramId
                                                                    AND ISNULL(pp2.RecordDeleted, 'N') = 'N' ) )

    -- 2013.06.22 - TER - removed code that ignores service area id.  coverage history must be active in the service are to be used to pay for a service provided in that area


            IF @@error <> 0
                GOTO error

        END

    RETURN 0

    error:
  ------------------------------------------------------------
  --raiserror 30001 'Failed to get next payer'
  --Modified by: SWAPAN MOHAN
  --Modified on: 4 July 2012
  --Purpose: For implementing the Customizable Message Codes.
  --The Function Ssf_GetMesageByMessageCode(Screenid,MessageCode,OriginalText) will return NVARCHAR(MAX) value.
    DECLARE @ERROR NVARCHAR(MAX)
    SET @ERROR = dbo.Ssf_GetMesageByMessageCode(29, 'FAILEDTOGETPAYER_SSP', 'Failed to get next payer')
    RAISERROR 30001 @ERROR
-----------------------------------------------------------


GO
