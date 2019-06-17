IF EXISTS (SELECT
    *
  FROM sys.objects
  WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageRWQMRules]')
  AND type IN (
  N'P'
  , N'PC'
  ))
  DROP PROCEDURE [dbo].[ssp_ListPageRWQMRules]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_ListPageRWQMRules] (@PageNumber int
, @PageSize int
, @SortExpression varchar(100)
, @RuleTypes int
, @FinancialAssignment int
, @ChargeStatus int
, @RWQMActions int
, @RuleName varchar(250)
, @EffectiveAsOf DateTime
, @OtherFilter int)
/********************************************************************************                                                   
** Stored Procedure: ssp_ListPageRWQMRules                                                      
**                                                    
** Copyright: Streamline Healthcate Solutions                                                      
** Updates:                                                                                                           
** Date            Author              Purpose  
  26/July/2017      Ajay       What/why: Get list for RWQM Rules list page for AHN-Customization: #44
*********************************************************************************/
AS
BEGIN
  BEGIN TRY
    DECLARE @CustomFiltersApplied char(1) = 'N'
    DECLARE @ApplyFilterClick AS char(1)

    SET @SortExpression = RTRIM(LTRIM(@SortExpression))

    IF ISNULL(@SortExpression, '') = ''
      SET @SortExpression = 'RuleName desc'

    CREATE TABLE #ResultSet (
      RWQMRuleId int,
      RuleName varchar(250),
      FinancialAssignment varchar(max),
      RuleType varchar(50),
      RulePriority int,
      Actions varchar(max),
      ChargeStatus varchar(max)
    )

    CREATE TABLE #CustomFilters (
      RWQMRuleId int
    )

    --Get custom filters                                                      
    IF @OtherFilter > 10000
    BEGIN
      IF OBJECT_ID('dbo.scsp_ListPageRWQMRules', 'P') IS NOT NULL
      BEGIN
        SET @CustomFiltersApplied = 'Y'

        INSERT INTO #CustomFilters (RWQMRuleId)
        EXEC scsp_ListPageRWQMRules @RuleTypes = @RuleTypes,
                                    @FinancialAssignment = @FinancialAssignment,
                                    @ChargeStatus = @ChargeStatus,
                                    @RWQMActions = @RWQMActions,
                                    @RuleName = @RuleName,
                                    @EffectiveAsOf = @RuleName,
                                    @OtherFilter = @RuleName
      END
    END
    
    CREATE TABLE #RWQMRules (
      RWQMRuleId int,
      EffectiveAsOf datetime,
      EndDate datetime,
      Active varchar(50),
      RWQMRuleName varchar(250),
      RulePriority varchar(250),
      RuleType varchar(50),
      FinancialAssignments varchar(max),
      Actions varchar(max),
      ChargeStatus varchar(max),
      RuleTypeId int,
      FinancialAssignmentId int,
      RWQMActionsId int,
      ChargeStatusId int,
      AllChargeActions char(1),
      AllChargeStatuses char(1),
      AllFinancialAssignments char(1)
    )
    INSERT INTO #RWQMRules
     SELECT
        RWQMA.RWQMRuleId,
        RWQMA.StartDate,
        RWQMA.EndDate,
        RWQMA.Active,
        RWQMA.RWQMRuleName,
        RWQMA.RulePriority,
        dbo.csf_GetGlobalCodeNameById(RWQMA.RuleType) AS RuleType,
        (SELECT
          ISNULL(STUFF((SELECT
            ', ' + ISNULL(CR.AssignmentName, '')

          FROM FinancialAssignments CR
          JOIN RWQMRuleFinancialAssignments FA
            ON CR.FinancialAssignmentId = FA.FinancialAssignmentId
          WHERE (RWQMA.RWQMRuleId = FA.RWQMRuleId OR RWQMA.AllFinancialAssignments='Y')
          AND ISNULL(FA.RecordDeleted, 'N') = 'N' 
          FOR xml PATH (''), TYPE)
          .value('.', 'nvarchar(max)'), 1, 2, ''), ''))
        AS FinancialAssignments,

        (SELECT
          ISNULL(STUFF((SELECT
            ', ' + ISNULL(CR.ActionName, '')

          FROM RWQMActions CR
          JOIN RWQMRuleChargeActions FA
            ON CR.RWQMActionId = FA.RWQMActionId
          WHERE (RWQMA.RWQMRuleId = FA.RWQMRuleId OR RWQMA.AllChargeActions='Y')
          AND ISNULL(FA.RecordDeleted, 'N') = 'N'
          FOR xml PATH (''), TYPE)
          .value('.', 'nvarchar(max)'), 1, 2, ''), ''))
        AS Actions,

        (SELECT
          ISNULL(STUFF((SELECT
            ', ' + ISNULL(CR.CodeName, '')

          FROM GlobalCodes CR
          JOIN RWQMRuleChargeStatuses FA
            ON CR.GlobalCodeId = FA.ChargeStatuses
          WHERE (RWQMA.RWQMRuleId = FA.RWQMRuleId OR RWQMA.AllChargeStatuses='Y')
          AND ISNULL(FA.RecordDeleted, 'N') = 'N'
          FOR xml PATH (''), TYPE)
          .value('.', 'nvarchar(max)'), 1, 2, ''), ''))
        AS ChargeStatus,
        RWQMA.RuleType,
        FinancialAssignmentId,
        RCA.RWQMActionId,
        RCS.ChargeStatuses,
        AllChargeActions,
        AllChargeStatuses,
        AllFinancialAssignments
     FROM RWQMRules RWQMA
      LEFT JOIN RWQMRuleFinancialAssignments FAM
        ON RWQMA.RWQMRuleId = FAM.RWQMRuleId AND ISNULL(FAM.RecordDeleted, 'N') = 'N'
      LEFT JOIN RWQMRuleChargeActions RCA
        ON RWQMA.RWQMRuleId = RCA.RWQMRuleId AND  ISNULL(RCA.RecordDeleted, 'N') = 'N'
      LEFT JOIN RWQMRuleChargeStatuses RCS
        ON RWQMA.RWQMRuleId = RCS.RWQMRuleId AND ISNULL(RCS.RecordDeleted, 'N') = 'N'
      WHERE ISNULL(RWQMA.RecordDeleted, 'N') = 'N'


    INSERT INTO #ResultSet (RWQMRuleId
    , RuleName
    , FinancialAssignment
    , RuleType
    , RulePriority
    , Actions
    , ChargeStatus)
      SELECT DISTINCT 
        RWQMA.RWQMRuleId,
        RWQMA.RWQMRuleName,
        RWQMA.FinancialAssignments,
        RWQMA.RuleType,
        RWQMA.RulePriority,
        RWQMA.Actions,
        RWQMA.ChargeStatus
      FROM #RWQMRules RWQMA
      WHERE (
		  (
		  @CustomFiltersApplied = 'Y'
		  AND EXISTS (SELECT
			*
		  FROM #CustomFilters cf
		  WHERE cf.RWQMRuleId = RWQMA.RWQMRuleId)
		  )
		  OR (
		  @CustomFiltersApplied = 'N'
		  AND (
		  ISNULL(@RuleTypes, -1) = -1 
		  OR (
		  RWQMA.RuleTypeId = @RuleTypes
		  )
		  )
		  AND (
		  ISNULL(@ChargeStatus, -1) = -1
		  OR RWQMA.AllChargeStatuses = 'Y'
		  OR RWQMA.ChargeStatusId = @ChargeStatus
		  )

		  AND (
		  ISNULL(@RWQMActions, -1) = -1
		  OR RWQMA.AllChargeActions = 'Y'
		  OR RWQMA.RWQMActionsId = @RWQMActions
		  )

		  AND (
		  ISNULL(@FinancialAssignment, -1) = -1
		  OR RWQMA.AllFinancialAssignments = 'Y'
		  OR RWQMA.FinancialAssignmentId = @FinancialAssignment

		  )

		  AND (
		  ISNULL(@RuleName, '') = ''
		  OR RWQMA.RWQMRuleName LIKE '%' + @RuleName + '%'

		  )

		  AND (
		  ISNULL(@EffectiveAsOf, '') = ''
		  OR RWQMA.EffectiveAsOf >= CAST(@EffectiveAsOf AS datetime)
		  )
		  )
      );

    WITH Counts
    AS (SELECT
      COUNT(*) AS TotalRows
    FROM #ResultSet),
    RankResultSet
    AS (SELECT
      RWQMRuleId,
      RuleName,
      FinancialAssignment,
      RuleType,
      RulePriority,
      Actions,
      ChargeStatus,
      COUNT(*) OVER () AS TotalCount,
      RANK() OVER (
      ORDER BY CASE
        WHEN @SortExpression = 'RWQMRuleId' THEN RWQMRuleId
      END, CASE
        WHEN @SortExpression = 'RWQMRuleId desc' THEN RWQMRuleId
      END DESC, CASE
        WHEN @SortExpression = 'RuleName' THEN RuleName
      END, CASE
        WHEN @SortExpression = 'RuleName desc' THEN RuleName
      END DESC, CASE
        WHEN @SortExpression = 'FinancialAssignment' THEN FinancialAssignment
      END, CASE
        WHEN @SortExpression = 'FinancialAssignment desc' THEN FinancialAssignment
      END DESC, CASE
        WHEN @SortExpression = 'RuleType' THEN RuleType
      END, CASE
        WHEN @SortExpression = 'RuleType desc' THEN RuleType
      END DESC, CASE
        WHEN @SortExpression = 'RulePriority' THEN RulePriority
      END, CASE
        WHEN @SortExpression = 'RulePriority desc' THEN RulePriority
      END DESC, CASE
        WHEN @SortExpression = 'Actions' THEN Actions
      END, CASE
        WHEN @SortExpression = 'Actions desc' THEN Actions
      END DESC, CASE
        WHEN @SortExpression = 'ChargeStatus' THEN ChargeStatus
      END, CASE
        WHEN @SortExpression = 'ChargeStatus desc' THEN ChargeStatus
      END DESC

      ) AS RowNumber
    FROM #ResultSet)
    SELECT TOP (
    CASE
      WHEN (@PageNumber = -1) THEN (SELECT
          ISNULL(TotalRows, 0)
        FROM Counts)
      ELSE (@PageSize)
    END
    )
      RWQMRuleId,
      RuleName,
      FinancialAssignment,
      RuleType,
      RulePriority,
      Actions,
      ChargeStatus,
      TotalCount,
      RowNumber INTO #FinalResultSet
    FROM RankResultSet
    WHERE RowNumber > ((@PageNumber - 1) * @PageSize)

    IF (SELECT
        ISNULL(COUNT(*), 0)
      FROM #FinalResultSet)
      < 1
    BEGIN
      SELECT
        0 AS PageNumber,
        0 AS NumberOfPages,
        0 NumberofRows
    END
    ELSE
    BEGIN
      SELECT TOP 1
        @PageNumber AS PageNumber,
        CASE (Totalcount % @PageSize)
          WHEN 0 THEN ISNULL((Totalcount / @PageSize), 0)
          ELSE ISNULL((Totalcount / @PageSize), 0) + 1
        END AS NumberOfPages,
        ISNULL(Totalcount, 0) AS NumberofRows
      FROM #FinalResultSet
    END

    SELECT
      RWQMRuleId,
      RuleName,
      FinancialAssignment,
      RuleType,
      RulePriority,
      Actions,
      ChargeStatus

    FROM #FinalResultSet
    ORDER BY RowNumber
  END TRY

  BEGIN CATCH
    DECLARE @error varchar(8000)

    SET @error = CONVERT(varchar, ERROR_NUMBER()) + '*****' + CONVERT(varchar(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()), 'ssp_ListPageRWQMRules') + '*****' + CONVERT(varchar, ERROR_LINE()) + '*****' + CONVERT(varchar, ERROR_SEVERITY()) + '*****' + CONVERT(varchar, ERROR_STATE())

    RAISERROR (
    @error
    ,-- Message text.  
    16
    ,-- Severity.  
    1 -- State.  
    );
  END CATCH
END
GO