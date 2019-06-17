 IF object_id('ssp_ListPageGetSchoolDistrictAssignmentList', 'P') IS NOT NULL
	DROP PROCEDURE dbo.ssp_ListPageGetSchoolDistrictAssignmentList
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_ListPageGetSchoolDistrictAssignmentList] @PageNumber int = 0    
, @PageSize int    
, @SortExpression varchar(100)    
, @StartDateFilter datetime    
, @EndDateFilter datetime    
, @AllSchoolDistrictsFilter int    
,@ClientIdFilter int    
, @OtherFilter int    
 /********************************************************************************                                                
-- Stored Procedure: dbo.ssp_ListPageGetSchoolDistrictAssignmentList                                                   
-- Copyright: Streamline Healthcare Solutions                                                 
-- Purpose: Get School District Assignment LIST                                                 
-- Updates:                                                                                                       
-- Date          Author      Purpose                                                 
-- 9th Apr 2018  Abhishek    Created.              
*********************************************************************************/    
AS    
BEGIN    
  -- SET NOCOUNT ON added to prevent extra result sets from            
  -- interfering with SELECT statements.            
  BEGIN TRY    
    DECLARE @CustomFiltersApplied char(1) = 'N'    
    
    CREATE TABLE #CustomFilters (    
      SchoolDistrictAssignmentId int NOT NULL    
    )    
    
    IF @OtherFilter > 10000    
    BEGIN    
      IF OBJECT_ID('dbo.scsp_ListPageGetSchoolDistrictAssignmentList', 'P') IS NOT NULL    
      BEGIN    
        SET @CustomFiltersApplied = 'Y'    
    
        INSERT INTO #CustomFilters (SchoolDistrictAssignmentId)    
        EXEC scsp_ListPageGetSchoolDistrictAssignmentList @StartDateFilter = @StartDateFilter,    
                                                          @EndDateFilter = @EndDateFilter,    
                                                          @AllSchoolDistrictsFilter = @AllSchoolDistrictsFilter,   
                                                          @OtherFilter = @OtherFilter    
      END    
    END;    
    
    CREATE TABLE #ResultSet (    
      ListPageSSPSchoolDistrictAssignmentId [bigint] IDENTITY (1, 1) NOT NULL,    
      RowNumber int,    
      PageNumber int,    
      SchoolDistrictAssignmentId int,    
      StartDate datetime,    
      EndDate datetime,    
      EducatingSchoolDistrict varchar(250),    
      ResidentialSchoolDistrict varchar(250),    
      ClientName varchar(100),  
      ClientId int,     
      --StudentId varchar(250),
      SSDI varchar(250)
    )    
    
    SET @SortExpression = RTRIM(LTRIM(@SortExpression))    
    
    IF ISNULL(@SortExpression, '') = ''    
      SET @SortExpression = 'StartDate asc'    
    
    --                                        
    -- New retrieve - the request came by clicking on the Apply Filter button                                                   
    --            
    
    INSERT INTO #ResultSet (SchoolDistrictAssignmentId    
    , StartDate    
    , EndDate    
    , EducatingSchoolDistrict    
    , ResidentialSchoolDistrict    
    ,ClientName  
    ,ClientId    
    --,StudentId
    ,SSDI)    
    
      SELECT    
        d.SchoolDistrictAssignmentId,    
        d.StartDate,    
        d.EndDate,    
        a.DistrictName,    
        b.DistrictName,    
        c.LastName + ', ' + c.FirstName,  
        d.ClientId, d.SSDI
      FROM SchoolDistrictAssignments d    
      LEFT JOIN SchoolDistricts a    
        ON a.SchoolDistrictId = d.EducatingSchoolDistrictId    
        AND ISNULL(a.RecordDeleted, 'N') <> 'Y'          
      LEFT JOIN SchoolDistricts b    
        ON b.SchoolDistrictId = d.ResidentialSchoolDistrictId    
        AND ISNULL(b.RecordDeleted, 'N') <> 'Y'      
         LEFT JOIN Clients c    
        ON c.ClientId = d.ClientId        
    
      WHERE (d.EducatingSchoolDistrictId = @AllSchoolDistrictsFilter    
      OR ISNULL(@AllSchoolDistrictsFilter, 0) = 0    
       OR d.ResidentialSchoolDistrictId = @AllSchoolDistrictsFilter    
      OR ISNULL(@AllSchoolDistrictsFilter, 0) = 0)    
      AND (d.StartDate >= @StartDateFilter    
      OR ISNULL(@StartDateFilter, '') = '')    
      AND (d.EndDate <= @EndDateFilter    
      OR ISNULL(@EndDateFilter, '') = '')    
       
      AND ISNULL(d.RecordDeleted, 'N') <> 'Y'    
       AND (c.ClientId = @ClientIdFilter    
      OR ISNULL(@ClientIdFilter, 0) = 0);    
    WITH Counts    
    AS (SELECT    
      COUNT(*) AS totalrows    
    FROM #ResultSet),    
    RankResultSet    
    AS (SELECT    
      SchoolDistrictAssignmentId,    
      StartDate,    
      EndDate,    
      EducatingSchoolDistrict,    
      ResidentialSchoolDistrict,    
      ClientName,    
      ClientId, 
      --StudentId,
      SSDI,     
      COUNT(*) OVER () AS TotalCount,    
      RANK() OVER (    
      ORDER BY CASE    
        WHEN @SortExpression = 'StartDate' THEN StartDate    
      END, CASE    
        WHEN @SortExpression = 'StartDate desc' THEN StartDate    
      END DESC, CASE    
        WHEN @SortExpression = 'EndDate' THEN EndDate    
      END, CASE    
        WHEN @SortExpression = 'EndDate desc' THEN EndDate    
      END DESC, CASE    
        WHEN @SortExpression = 'EducatingSchoolDistrict' THEN EducatingSchoolDistrict    
      END, CASE    
        WHEN @SortExpression = 'EducatingSchoolDistrict desc' THEN EducatingSchoolDistrict    
      END DESC, CASE    
        WHEN @SortExpression = 'ResidentialSchoolDistrict' THEN ResidentialSchoolDistrict    
      END, CASE    
        WHEN @SortExpression = 'ResidentialSchoolDistrict desc' THEN ResidentialSchoolDistrict    
      END DESC, CASE    
        WHEN @SortExpression = 'ClientName' THEN ClientName    
      END, CASE    
        WHEN @SortExpression = 'ClientName desc' THEN ClientName    
      END DESC,   
      --CASE    
      --  WHEN @SortExpression = 'StudentId' THEN StudentId    
      --END, CASE    
      --  WHEN @SortExpression = 'StudentId desc' THEN StudentId    
      --END DESC, 
       CASE    
        WHEN @SortExpression = 'SSDI' THEN SSDI    
      END, CASE    
        WHEN @SortExpression = 'SSDI desc' THEN SSDI    
      END DESC,  
      SchoolDistrictAssignmentId    
      ) AS RowNumber    
    FROM #ResultSet    
    WHERE SchoolDistrictAssignmentId IS NOT NULL)    
    SELECT TOP (    
    CASE    
      WHEN (@PageNumber = -1) THEN (SELECT    
          ISNULL(totalrows, 0)    
        FROM counts)    
      ELSE (@PageSize)    
    END    
    )    
      SchoolDistrictAssignmentId,    
      StartDate,    
      EndDate,    
      EducatingSchoolDistrict,    
      ResidentialSchoolDistrict,    
      ClientName,    
      ClientId,  
      --StudentId,
      SSDI,
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
      SchoolDistrictAssignmentId,    
      CONVERT(VARCHAR(10),StartDate,101) AS StartDate,    
      CONVERT(VARCHAR(10),EndDate,101) AS EndDate,    
      EducatingSchoolDistrict,    
      ResidentialSchoolDistrict,    
      ClientName,  
      ClientId,
      --StudentId,
      SSDI    
    FROM #FinalResultSet    
    ORDER BY RowNumber    
  END TRY    
    
  BEGIN CATCH    
    DECLARE @Error varchar(8000)    
    
    SET @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****' + CONVERT(varchar(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()), 'ssp_ListPageGetSchoolDistrictAssignmentList') + '*****' + CONVERT(varchar, ERROR_LINE()) + '****
  
*'    
    + CONVERT(varchar,    
    
    
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