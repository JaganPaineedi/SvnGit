IF EXISTS (SELECT
    *
  FROM sys.objects
  WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageActions]')
  AND type IN (
  N'P'
  , N'PC'
  ))
  DROP PROCEDURE [dbo].[ssp_ListPageActions]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_ListPageActions] (@PageNumber int
, @PageSize int
, @SortExpression varchar(100)
, @RWQMAssignmentRWQMActionId int
, @ChargeStatus int
, @Active char(2)
, @OtherFilter int)
/********************************************************************************                                                   
** Stored Procedure: ssp_ListPageActions                                                      
**                                                    
** Copyright: Streamline Healthcate Solutions                                                      
** Updates:                                                                                                           
** Date            Author              Purpose     
  26/July/2017      Ajay       What/why: Get list for Action list page for AHN-Customization: #44  
  8/April/2017		Ponnin		What : Added case statement to show all Charge Status and Previous Actions on selection of AllAllowedPreviousAction/AllAllowedChargeStatus. Why: For task #44.1 of AHN-Customizations										
*********************************************************************************/
AS
BEGIN
  BEGIN TRY
    DECLARE @CustomFiltersApplied char(1) = 'N'
    DECLARE @ApplyFilterClick AS char(1)

	IF(@RWQMAssignmentRWQMActionId = 0 ) SET @RWQMAssignmentRWQMActionId = -1

    SET @SortExpression = RTRIM(LTRIM(@SortExpression))

    IF ISNULL(@SortExpression, '') = ''
      SET @SortExpression = 'RWQMActionId desc'

    CREATE TABLE #ResultSet (
      RWQMActionId int,
      ActionName varchar(500),
      ChargeStatus varchar(500),
      PreviousAction varchar(500)
    )

    CREATE TABLE #CustomFilters (
      RWQMActionId int
    )

    --Get custom filters                                                      
    IF @OtherFilter > 10000
    BEGIN
      IF OBJECT_ID('dbo.scsp_ListPageActions', 'P') IS NOT NULL
      BEGIN
        SET @CustomFiltersApplied = 'Y'

        INSERT INTO #CustomFilters (RWQMActionId)
        EXEC scsp_ListPageActions @RWQMAssignmentRWQMActionId = @RWQMAssignmentRWQMActionId,
                                  @ChargeStatus = @ChargeStatus,
                                  @Active = @Active,
                                  @OtherFilter = @OtherFilter
      END
    END

    ----added by Ajay on  16-June-2017
    CREATE TABLE #RWQMActions (
      RWQMActionId int,
      ActionName varchar(500),
      PreviousAction varchar(500),
      ChargeStatusText varchar(500),
      ChargeStatus int,
      Active char(1),
      AllAllowedChargeStatus char(1) 
    )

    INSERT INTO #RWQMActions
      SELECT
        RWQMA.RWQMActionId,
        RWQMA.ActionName,
        
        CASE WHEN ISNULL(RWQMA.AllAllowedPreviousAction,'N')='Y' THEN  (SELECT
          ISNULL(STUFF((SELECT
            ', ' + ISNULL(RA.ActionName, '')
          FROM RWQMActions RA WHERE ISNULL(RA.Active,'N')= 'Y'  
			AND RA.RWQMActionId <> ISNULL(RWQMA.RWQMActionId,-1)  
			AND ISNULL(RA.RecordDeleted,'N')='N'  
			FOR xml PATH (''), TYPE)
          .value('.', 'nvarchar(max)'), 1, 2, ''), ''))
          
		ELSE  (SELECT
          ISNULL(STUFF((SELECT
            ', ' + ISNULL(CR.ActionName, '')
          FROM RWQMActions CR
          WHERE CR.RWQMActionId IN (SELECT
            PA.PreviousActionId
          FROM RWQMPreviousActions PA
          WHERE (PA.RWQMActionId = RWQMA.RWQMActionId) AND ISNULL(PA.RecordDeleted,'N')='N')
          FOR xml PATH (''), TYPE)
          .value('.', 'nvarchar(max)'), 1, 2, ''), '')) END AS PreviousAction,
        
        
        
        CASE WHEN ISNULL(RWQMA.AllAllowedChargeStatus,'N')='Y' THEN  (SELECT
          ISNULL(STUFF((SELECT
            ', ' + ISNULL(CR.CodeName, '')
          FROM GlobalCodes CR WHERE (CR.Category = 'CHARGESTATUS' AND ISNULL(CR.RecordDeleted,'N')='N' AND ISNULL(CR.Active,'N')= 'Y')
          FOR xml PATH (''), TYPE)
          .value('.', 'nvarchar(max)'), 1, 2, ''), '')) 
          
          ELSE
          (SELECT
          ISNULL(STUFF((SELECT
            ', ' + ISNULL(CR.CodeName, '')

          FROM GlobalCodes CR
          WHERE CR.GlobalCodeId IN (SELECT
            CS.ChargeStatus
          FROM RWQMActionChargeStatuses CS
          WHERE (CS.RWQMActionId = RWQMA.RWQMActionId) AND ISNULL(CS.RecordDeleted,'N')='N')
          FOR xml PATH (''), TYPE)
          .value('.', 'nvarchar(max)'), 1, 2, ''), '')) END AS ChargeStatusText, 
          
          
        CS.ChargeStatus,
        RWQMA.Active,
        RWQMA.AllAllowedChargeStatus 
      FROM RWQMActions RWQMA
      LEFT JOIN RWQMActionChargeStatuses CS 
        ON RWQMA.RWQMActionId = CS.RWQMActionId AND ISNULL(CS.RecordDeleted, 'N') = 'N'
      WHERE ISNULL(RWQMA.RecordDeleted, 'N') = 'N'
      

    INSERT INTO #ResultSet (RWQMActionId
    , ActionName
    , ChargeStatus
    , PreviousAction)
      SELECT DISTINCT
        RWQMA.RWQMActionId,
        RWQMA.ActionName,
        RWQMA.ChargeStatusText,
        RWQMA.PreviousAction
      FROM #RWQMActions RWQMA
      WHERE (
      (
      @CustomFiltersApplied = 'Y'
      AND EXISTS (SELECT
        *
      FROM #CustomFilters cf
      WHERE cf.RWQMActionId = RWQMA.RWQMActionId)
      )
      OR (
      @CustomFiltersApplied = 'N'
      AND (
      ISNULL(@RWQMAssignmentRWQMActionId, -1) = -1 
      OR --   Active                   
      (
      RWQMA.RWQMActionId = @RWQMAssignmentRWQMActionId
      --AND isnull(RWQMA.Active, 'N') = 'N'
      )
      )
      AND (
      ISNULL(@ChargeStatus, -1) = -1
      OR RWQMA.ChargeStatus = @ChargeStatus
      OR RWQMA.AllAllowedChargeStatus='Y'
      )

      AND (
      ISNULL(@Active, '-1') = '-1'
      OR RWQMA.Active = @Active

      )
      )


      );

    WITH Counts
    AS (SELECT
      COUNT(*) AS TotalRows
    FROM #ResultSet),
    RankResultSet
    AS (SELECT
      RWQMActionId,
      ActionName,
      ChargeStatus,
      PreviousAction,
      COUNT(*) OVER () AS TotalCount,
      RANK() OVER (
      ORDER BY CASE
        WHEN @SortExpression = 'RWQMActionId' THEN RWQMActionId
      END, CASE
        WHEN @SortExpression = 'RWQMActionId desc' THEN RWQMActionId
      END DESC, CASE
        WHEN @SortExpression = 'ActionName' THEN ActionName
      END, CASE
        WHEN @SortExpression = 'ActionName desc' THEN ActionName
      END DESC, CASE
        WHEN @SortExpression = 'ChargeStatus' THEN ChargeStatus
      END, CASE
        WHEN @SortExpression = 'ChargeStatus desc' THEN ChargeStatus
      END DESC, CASE
        WHEN @SortExpression = 'PreviousAction' THEN PreviousAction
      END, CASE
        WHEN @SortExpression = 'PreviousAction desc' THEN PreviousAction
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
      RWQMActionId,
      ActionName,
      ChargeStatus,
      PreviousAction,
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
      RWQMActionId,
      ActionName,
      ChargeStatus,
      PreviousAction

    FROM #FinalResultSet
    ORDER BY RowNumber
  END TRY

  BEGIN CATCH
    DECLARE @error varchar(8000)

    SET @error = CONVERT(varchar, ERROR_NUMBER()) + '*****' + CONVERT(varchar(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()), 'ssp_ListPageActions') + '*****' + CONVERT(varchar, ERROR_LINE()) + '*****' + CONVERT(varchar, ERROR_SEVERITY()) + '*****' + CONVERT(varchar, ERROR_STATE())

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