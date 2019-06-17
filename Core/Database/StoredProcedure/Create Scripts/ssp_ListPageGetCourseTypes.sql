          
IF object_id('ssp_ListPageGetCourseTypes', 'P') IS NOT NULL
	DROP PROCEDURE dbo.ssp_ListPageGetCourseTypes
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_ListPageGetCourseTypes] @PageNumber int = 0
, @PageSize int
, @SortExpression varchar(100)
, @TypeOfCourseFilter varchar(500)
, @CourseGroupFilter int
, @TeachersFilter int
, @StatusFilter int
, @CourseCodeFilter varchar(100)
, @CourseLevelFilter int
, @HSCreditFilter int
--, @LengthOfInstructionFilter int
, @OtherFilter int
	/********************************************************************************                                            
-- Stored Procedure:  dbo.ssp_ListPageGetCourseTypes  1,200,'','',-1,-1,-1,'',0,0,0,-1                                             
-- Copyright: Streamline Healthcare Solutions                                             
-- Purpose: Get Course Types LIST                                             
-- Updates:                                                                                                   
-- Date           Author      Purpose                                             
-- 22nd Mar 2018  Abhishek    Created.          
-- 18th July 2018 Chita --  What/Why : Modified the TypeOfCourse to varchar(500) and removed join with GlobalCodes table. PEP - Customizations #10198
*********************************************************************************/
AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from            
  -- interfering with SELECT statements.            
  BEGIN TRY

    DECLARE @CustomFiltersApplied char(1) = 'N'

    CREATE TABLE #CustomFilters (
      CourseTypeId int NOT NULL
    )

    IF @OtherFilter > 10000
    BEGIN
      IF OBJECT_ID('dbo.scsp_ListPageGetCourseTypes', 'P') IS NOT NULL
      BEGIN
        SET @CustomFiltersApplied = 'Y'

        INSERT INTO #CustomFilters (CourseTypeId)
        EXEC scsp_ListPageGetCourseTypes @TypeOfCourseFilter = @TypeOfCourseFilter,
                                         @CourseGroupFilter = @CourseGroupFilter,
                                         @TeachersFilter = @TeachersFilter,
                                         @StatusFilter = @StatusFilter,
                                         @CourseCodeFilter = @CourseCodeFilter,
                                         @CourseLevelFilter = @CourseLevelFilter,
                                         --@HSCreditFilter = @HSCreditFilter,
                                         --@LengthOfInstructionFilter = @LengthOfInstructionFilter,
                                         @OtherFilter = @OtherFilter
      END
    END;
    CREATE TABLE #ResultSet (
      ListPageSSPCourseTypeId [bigint] IDENTITY (1, 1) NOT NULL,
      RowNumber int,
      PageNumber int,
      CourseTypeId int,
      ClassroomCourseType varchar(500),
      CourseGroup varchar(100),
      NoOfCredits varchar(100),
      Active char,
      HighlyQualifiedTeacher char,
      Points decimal(18, 2),
      ClassroomCourseLevel varchar(100)
     -- ClassroomHSCredit varchar(100),
      --ClassroomInstruction varchar(100)
    )

    SET @SortExpression = RTRIM(LTRIM(@SortExpression))

    IF ISNULL(@SortExpression, '') = ''
      SET @SortExpression = 'ClassroomCourseType asc'

    INSERT INTO #ResultSet (CourseTypeId
    , ClassroomCourseType
    , CourseGroup
    , NoOfCredits
    , Active
    , HighlyQualifiedTeacher
    , Points
    , ClassroomCourseLevel
    --, ClassroomHSCredit
    --, ClassroomInstruction
	)

      SELECT 
        d.CourseTypeId,
        d.TypeOfCourse,
        e.CodeName,
        h.CodeName,
        d.Active,
        d.HighlyQualifiedTeacher,
        d.RequiredPoints,
        f.CodeName
       -- c.CodeName,
        --g.CodeName
      FROM CourseTypes d LEFT
       JOIN CourseTypeHighlyQualifiedTeachers a
        ON a.CourseTypeId =
        d.CourseTypeId       
        AND ISNULL(a.RecordDeleted, 'N') <> 'Y'
      --LEFT JOIN GlobalCodes c
      --  ON c.GlobalCodeId =
      --  d.HSCredit
      --  AND ISNULL(c.RecordDeleted, 'N') <> 'Y'
      LEFT JOIN GlobalCodes f
        ON f.GlobalCodeId =
        d.CourseLevel
        AND ISNULL(f.RecordDeleted, 'N') <> 'Y'
      LEFT JOIN GlobalCodes g
        ON g.GlobalCodeId = d.LengthOfInstruction
        AND ISNULL(g.RecordDeleted, 'N') <> 'Y'
      LEFT JOIN GlobalCodes e
        ON e.GlobalCodeId = d.CourseGroup
        AND ISNULL(e.RecordDeleted, 'N') <> 'Y'
      
       LEFT JOIN GlobalCodes h
        ON h.GlobalCodeId = d.NoOfCredits
        AND ISNULL(h.RecordDeleted, 'N') <> 'Y'  
     
      WHERE (a.StaffId = @TeachersFilter
        OR ISNULL(@TeachersFilter, -1) = -1) AND (d.TypeOfCourse like '%'+@TypeOfCourseFilter+'%' 
      OR ISNULL(@TypeOfCourseFilter, '') = '')
      AND (@StatusFilter = -1 OR          --   All  
      (@StatusFilter = 1 AND ISNULL(d.Active,'N') = 'Y') OR  --   Active  
      (@StatusFilter = 0  AND ISNULL(d.Active,'N') = 'N'))   --   InActive         --   All status   
      AND ISNULL(d.RecordDeleted, 'N') <> 'Y'
      AND (d.CourseGroup =
      @CourseGroupFilter
      OR ISNULL(@CourseGroupFilter, -1) = -1)
      AND (d.CourseCode like '%'+@CourseCodeFilter+'%' 
      OR ISNULL(@CourseCodeFilter, '') = '')
      AND (d.CourseLevel = @CourseLevelFilter
      OR ISNULL(@CourseLevelFilter, 0)
      = 0)
      --AND (d.HSCredit = @HSCreditFilter
      --OR ISNULL(@HSCreditFilter, 0) = 0)
      AND (d.NoOfCredits =
      @HSCreditFilter
      OR ISNULL(@HSCreditFilter, 0) = 0)
      --AND (d.LengthOfInstruction =
      --@LengthOfInstructionFilter
      --OR ISNULL(@LengthOfInstructionFilter, 0) = 0)
      GROUP BY d.CourseTypeId,d.TypeOfCourse,e.CodeName,
        h.CodeName,
        d.Active,
        d.HighlyQualifiedTeacher,
        d.RequiredPoints,
        f.CodeName,
      --  c.CodeName,
        g.CodeName;
    WITH Counts
    AS (SELECT
      COUNT(*) AS totalrows
    FROM #ResultSet),
    RankResultSet
    AS (SELECT
      CourseTypeId,
      ClassroomCourseType,
      CourseGroup,
      NoOfCredits,
      Active,
      HighlyQualifiedTeacher,
      Points,
      ClassroomCourseLevel,
      --ClassroomHSCredit,
      --ClassroomInstruction,
      COUNT(*) OVER () AS TotalCount,
      RANK() OVER (
      ORDER BY CASE
        WHEN @SortExpression = 'ClassroomCourseType' THEN ClassroomCourseType
      END, CASE
        WHEN @SortExpression = 'ClassroomCourseType desc' THEN ClassroomCourseType
      END DESC, CASE
        WHEN @SortExpression = 'CourseGroup' THEN CourseGroup
      END, CASE
        WHEN @SortExpression = 'CourseGroup desc' THEN CourseGroup
      END DESC, CASE
        WHEN @SortExpression = 'NoOfCredits' THEN NoOfCredits
      END, CASE
        WHEN @SortExpression = 'NoOfCredits desc' THEN NoOfCredits
      END DESC, CASE
        WHEN @SortExpression = 'Active' THEN Active
      END, CASE
        WHEN @SortExpression = 'Active desc' THEN Active
      END DESC, CASE
        WHEN @SortExpression = 'HighlyQualifiedTeacher' THEN HighlyQualifiedTeacher
      END, CASE
        WHEN @SortExpression = 'HighlyQualifiedTeacher desc' THEN HighlyQualifiedTeacher
      END DESC, CASE
        WHEN @SortExpression = 'ClassroomCourseLevel' THEN ClassroomCourseLevel
      END, CASE
        WHEN @SortExpression = 'ClassroomCourseLevel desc' THEN ClassroomCourseLevel
      END DESC, 
      --CASE
      --  WHEN @SortExpression = 'ClassroomHSCredit' THEN ClassroomHSCredit
      --END, CASE
      --  WHEN @SortExpression = 'ClassroomHSCredit desc' THEN ClassroomHSCredit
      --END DESC, 
      --CASE
      --  WHEN @SortExpression = 'ClassroomInstruction' THEN ClassroomInstruction
      --END, CASE
      --  WHEN @SortExpression = 'ClassroomInstruction desc' THEN ClassroomInstruction
      --END DESC, 
	  CASE
        WHEN @SortExpression = 'Points' THEN Points
      END, CASE
        WHEN @SortExpression = 'Points desc' THEN Points
      END DESC, CourseTypeId
      ) AS RowNumber
    FROM #ResultSet
    WHERE CourseTypeId IS NOT NULL)
    SELECT TOP (
    CASE
      WHEN (@PageNumber = -1) THEN (SELECT
          ISNULL(totalrows, 0)
        FROM counts)
      ELSE (@PageSize)
    END
    )
      CourseTypeId,
      ClassroomCourseType,
      CourseGroup,
      NoOfCredits,
      Active,
      HighlyQualifiedTeacher,
      Points,
      ClassroomCourseLevel,
      --ClassroomHSCredit,
      --ClassroomInstruction,
      RowNumber,
      TotalCount INTO #FinalResultSet
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
        0 NumberOfRows
    END
    ELSE
    BEGIN
      SELECT TOP 1
        @PageNumber AS PageNumber,
        CASE (TotalCount % @PageSize)
          WHEN 0 THEN ISNULL((TotalCount / @PageSize), 0)
          ELSE ISNULL((TotalCount / @PageSize), 0) + 1
        END AS NumberOfPages,
        ISNULL(TotalCount, 0) AS NumberOfRows
      FROM #FinalResultSet
    END

    SELECT
      CourseTypeId,
      ClassroomCourseType,
      CourseGroup,
      NoOfCredits,
      Active,
      HighlyQualifiedTeacher,
      Points,
      ClassroomCourseLevel
      --ClassroomHSCredit,
      --ClassroomInstruction
    FROM #FinalResultSet
    ORDER BY RowNumber


  END TRY

  BEGIN CATCH
    DECLARE @Error varchar(8000)

    SET @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****' + CONVERT(varchar(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()), 'ssp_ListPageGetCourseTypes') + '*****' + CONVERT(varchar, ERROR_LINE()) + '*****' + CONVERT(varchar,


    ERROR_SEVERITY()) + '*****' + CONVERT(varchar, ERROR_STATE())

    RAISERROR (
    @Error
    ,-- Message text.                                                                                                              
    16
    ,-- Severity.                                                                                                              
    1 -- State.                                                                                                              
    );
  END CATCH
END