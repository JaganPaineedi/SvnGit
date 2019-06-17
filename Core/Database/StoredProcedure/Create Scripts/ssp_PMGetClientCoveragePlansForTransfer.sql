
IF EXISTS (SELECT
    *
  FROM sys.objects
  WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMGetClientCoveragePlansForTransfer]')
  AND type IN (N'P', N'PC'))
  DROP PROCEDURE [dbo].[ssp_PMGetClientCoveragePlansForTransfer]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_PMGetClientCoveragePlansForTransfer] @PayerId int,
@CoveragePlanId int,
@ClientId int,
@ClientIdNew varchar(max),
@ServiceId int,
@StaffId int = NULL



/******************************************************************************         
Hemant 3/8/2017          Moved the TranferTo logic from ssp_PMPostPaymentsServicesSearchSel
                         Philhaven-Support #78.2
                         
Aravind 04/12/2018       Commented - OpenCharges table Join with Charges table and OpenCharges.Balance > 0 Condition to show all 
                         client coverage plans Irrespective of Service Balance.
                         Why:Task #939 - Allegan Support
*******************************************************************************/
AS
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON
  BEGIN TRY

    CREATE TABLE #ResultSet (
      Identity1 [bigint] IDENTITY (1, 1)
      NOT NULL,
      RowNumber int,
      PageNumber int,
      RadioButton char(1),
      ServiceId int,
      ClientId int,
      [Name] varchar(100),
      DateOfService datetime,
      Unit varchar(450),
      Charge money,
      ChargeId int,
      Priority int,
      Payment money,
      Adjustment money,
      Balance money,
      LedgerType int,
      ClaimBatchId int,
      CoveragePlanId int,
      ProcedureCodeId int,
      COBOrder int,
      NextPayer varchar(50),
      IsSelected bit,
      ServiceAreaId int,
      ClientCoveragePlanId int,
      -- 09-DEC-2016 Akwinass
      ProcedureCode varchar(500),
      ProgramCode varchar(100),
      ClinicianName varchar(60),
      CPTCode varchar(100),
      ClaimLineNumber int
    )



    INSERT INTO #ResultSet (RadioButton,
    ServiceId,
    ClientId,
    [Name],
    DateOfService,
    Unit,
    Charge,
    ChargeId,
    Priority,
    ClaimBatchId,
    CoveragePlanId,
    ProcedureCodeId,
    COBOrder,
    NextPayer,
    IsSelected,
    ServiceAreaId,
    ClientCoveragePlanId,
    -- 09-DEC-2016 Akwinass
    ProcedureCode,
    ProgramCode,
    ClinicianName,
    CPTCode,
    ClaimLineNumber)
      SELECT
        '0' AS RadioButton,
        S.ServiceId,
        C.ClientId,
        CASE
          WHEN ISNULL(C.ClientType, 'I') = 'I' THEN C.LastName + ', ' + C.FirstName
          ELSE C.OrganizationName
        END + ' (' + CONVERT(varchar, C.ClientId) + ')' AS [Name],
        S.DateOfService,
        RTRIM(PC.DisplayAs) + ' ' + CONVERT(varchar, S.Unit) + ' ' + GC.CodeName AS [unit],
        S.Charge,
        Ch.ChargeId,
        Ch.Priority,
        1 AS ClaimBatchId,
        CCP.coverageplanid,
        PC.ProcedureCodeId,
        ISNULL(CCH.COBOrder, 0),
        NULL,
        0,
        CCH.ServiceAreaID,
        CCP.ClientCoveragePlanId,

        PC.DisplayAs,
        P.ProgramCode,
        ST.LastName + ', ' + ST.FirstName,
        CH.BillingCode AS CPTCode,
        NULL AS ClaimLineNumber
        FROM  Charges Ch
      --FROM OpenCharges OC    -- Task #939 - Allegan Support 
      --JOIN Charges Ch
      --  ON (Ch.ChargeId = OC.ChargeId)
      JOIN Services S
        ON Ch.ServiceId = S.ServiceId
      JOIN Programs P
        ON P.ProgramId = S.ProgramId
      JOIN Clients C
        ON S.ClientId = C.ClientId
      JOIN ProcedureCodes PC
        ON S.ProcedureCodeId = PC.ProcedureCodeId
      LEFT OUTER JOIN GlobalCodes GC
        ON (S.UnitType = GC.GlobalCodeId)
      LEFT OUTER JOIN ClientCoverageplans CCP
        ON Ch.ClientCoveragePlanId = CCP.ClientCoveragePlanId

      LEFT OUTER JOIN ClientCoverageHistory CCH
        ON (Ch.ClientCoveragePlanId = CCH.ClientCoveragePlanId
        AND CCH.StartDate <= S.DateOfService
        AND (CCH.EndDate IS NULL
        OR DATEADD(dd, 1, CCH.EndDate) > S.DateOfService
        )
        )
        AND CCH.ServiceAreaId = P.ServiceAreaid


      LEFT OUTER JOIN CoveragePlans CP
        ON CCP.CoveragePlanId = CP.CoveragePlanId
      LEFT JOIN Staff ST
        ON S.ClinicianId = ST.StaffId
      WHERE EXISTS (SELECT
        1
      FROM StaffClients SC
      WHERE SC.StaffId = @StaffId
      AND SC.ClientId = C.ClientId)
      AND (@PayerId = -1
      OR CP.PayerId = @PayerId
      )
      AND (@CoveragePlanId = -1
      OR CP.CoveragePlanId = @CoveragePlanId
      )

      --AND (OC.Balance > 0  - Task #939 - Allegan Support
      --)

      AND (@ClientId = -1
      OR (Ch.Priority = 0
      AND S.ClientId = @ClientId
      )
      )

      AND (S.ServiceId = @ServiceId
      )

    CREATE TABLE #ClientList (
      ClientId int
    )
    WHILE (CHARINDEX(',', @ClientIdNew) > 0)
    BEGIN

      DECLARE @Form varchar(30)
      SET @Form = SUBSTRING(@ClientIdNew, 0, CHARINDEX(',', @ClientIdNew))

      INSERT INTO #ClientList
        VALUES (@Form)
      SET @ClientIdNew = SUBSTRING(@ClientIdNew, CHARINDEX(',', @ClientIdNew) + 1, LEN(@ClientIdNew))

    END


    -- Select coverage plans that can be use for Transfer To			
    SELECT DISTINCT
      ccp.ClientCoveragePlanId,
      cp.CoveragePlanId,
      cp.DisplayAs + ' ' + ISNULL(ccp.InsuredId, '') + '(' + CONVERT(varchar, ISNULL(cch.COBOrder, '')) + ')' AS DisplayAs,
      s.ClientId,
      cch.StartDate,
      cch.EndDate,
      cch.CobOrder,
      s.ServiceId,
      p.ServiceAreaId,
      s.ProgramId
    FROM #ResultSet t
    JOIN #ClientList cl
      ON cl.ClientId = t.ClientId
    JOIN Services s
      ON s.ServiceId = t.ServiceId
    JOIN Programs p
      ON p.ProgramId = s.ProgramId
    JOIN ClientCoveragePlans ccp
      ON ccp.ClientId = s.ClientId
    JOIN ClientCoverageHistory cch
      ON cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
      AND cch.ServiceAreaId = p.ServiceAreaId
    JOIN CoveragePlans cp
      ON cp.CoveragePlanId = ccp.CoveragePlanId
    LEFT JOIN Charges c
      ON c.ChargeId = t.ChargeId
      AND ISNULL(c.RecordDeleted, 'N') = 'N'
    WHERE (c.ClientCoveragePlanId IS NULL
    OR c.ClientCoveragePlanId <> ccp.ClientCoveragePlanId
    )
    AND cch.StartDate <= s.DateOfService
    AND (cch.EndDate IS NULL
    OR DATEADD(dd, 1, cch.EndDate) > s.DateOfService
    )
    AND ISNULL(ccp.RecordDeleted, 'N') = 'N'
    AND ISNULL(cch.RecordDeleted, 'N') = 'N'
    -- Check if procedure is billable
    AND NOT EXISTS (SELECT
      *
    FROM CoveragePlanRules cpr
    WHERE ((cpr.CoveragePlanId = cp.CoveragePlanId
    AND ISNULL(cp.BillingRulesTemplate, 'T') = 'T'
    )
    OR (cpr.CoveragePlanId = cp.UseBillingRulesTemplateId
    AND ISNULL(cp.BillingRulesTemplate, 'T') = 'O'
    )
    )
    AND cpr.RuleTypeId = 4267
    AND ISNULL(cpr.RecordDeleted, 'N') = 'N'
    AND (cpr.AppliesToAllProcedureCodes = 'Y'
    OR EXISTS (SELECT
      *
    FROM CoveragePlanRuleVariables cprv
    WHERE cprv.CoveragePlanRuleId = cpr.CoveragePlanRuleId
    AND cprv.ProcedureCodeId = s.ProcedureCodeId
    AND ISNULL(cprv.RecordDeleted, 'N') = 'N')
    ))
    -- Check if Program is billable
    AND NOT EXISTS (SELECT
      *
    FROM ProgramPlans pp
    WHERE pp.CoveragePlanId = cp.CoveragePlanId
    AND pp.ProgramId = s.ProgramId
    AND ISNULL(pp.RecordDeleted, 'N') = 'N')
    ORDER BY s.ServiceId,
    cch.CobOrder


    DROP TABLE #ClientList


  END TRY

  BEGIN CATCH
    DECLARE @Error varchar(8000)
    SET @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****' + CONVERT(varchar(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()), 'ssp_PMGetClientCoveragePlansForTransfer') + '*****' + CONVERT(varchar, ERROR_LINE()) + '*****' + CONVERT(varchar, ERROR_SEVERITY()) + '*****' + CONVERT(varchar, ERROR_STATE())
    RAISERROR
    (
    @Error, -- Message text.      
    16,  -- Severity.      
    1  -- State.      
    );
  END CATCH
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED

END



GO