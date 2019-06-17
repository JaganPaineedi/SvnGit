/****** Object:  StoredProcedure [dbo].[ssp_ListPageAcademicYears]    Script Date: Mar 16 2018 11:54:00 ******/ 
IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_ListPageAcademicYears]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_ListPageAcademicYears] 

go 

/****** Object:  StoredProcedure [dbo].[ssp_ListPageAcademicYears]    Script Date: Mar 16 2018 11:54:00 ******/ 
SET ansi_nulls ON 

go 

SET quoted_identifier ON 

go 

CREATE PROCEDURE [dbo].[ssp_ListPageAcademicYears] 
/*************************************************************/ 
/* Stored Procedure: dbo.ssp_ListPageAcademicYears 0,200,'',NULL,NULL,'-1',-1,0          */ 
/* Creation Date:  Mar 16 2018                                */ 
/* Purpose: To get the list of Academic Years for class room    
   */ 
/*  Date                  Author                 Purpose     */ 
/* Mar 16 2018           Chita Ranjan            To get the list of Academic Years. PEP-Customizations #20005     */ 
/*History*/ 
  /*************************************************************/ 
  @PageNumber      INT, 
  @PageSize        INT, 
  @SortExpression  VARCHAR(200), 
  @StartDate       DATETIME, 
  @EndDate         DATETIME, 
  @Active          CHAR(10), 
  @AcademicName    INT,
  @OtherFilter  INT
AS 
  BEGIN 
      BEGIN try 
       DECLARE @CustomFiltersApplied CHAR(1) = 'N'  
       
       CREATE TABLE #CustomFilters 
                (AcademicYearId INT NOT NULL)  
  
  IF @OtherFilter > 20000  
  BEGIN  
   IF OBJECT_ID('dbo.scsp_ListPageAcademicYears', 'P') IS NOT NULL  
   BEGIN  
    SET @CustomFiltersApplied = 'Y'  
      
    INSERT INTO #CustomFilters (AcademicYearId)  
     EXEC scsp_ListPageAcademicYears @StartDate = @StartDate,  
                                  @EndDate = @EndDate, 
                                  @AcademicYearId = @AcademicName, 
                                  @Active=@Active, 
                                  @OtherFilter = @OtherFilter  
  
   END  
  END;  
  
          CREATE TABLE #resultset 
            ( 
               AcademicYearId    INT, 
               StartDate         DATETIME, 
               EndDate           DATETIME, 
               AcademicName      VARCHAR(250), 
               QuarterOrSemester CHAR(20), 
               Active            VARCHAR(10), 
            ) 

          INSERT INTO #resultset 
                      ( AcademicYearId 
                       ,StartDate
			           ,EndDate 
                       ,AcademicName
                       ,QuarterOrSemester 
                       ,Active
                       ) 
          SELECT AcademicYearId, 
                 CONVERT(VARCHAR(10),StartDate,101) AS StartDate
				 ,CONVERT(VARCHAR(10),EndDate,101) AS EndDate
                 ,AcademicName, 
                 CASE 
                   WHEN QuarterOrSemester = 'Q' THEN 'Quarters' 
                   WHEN QuarterOrSemester = 'S' THEN 'Semesters' 
                 END AS QuarterOrSemester,
                 CASE 
                   WHEN Active = 'Y' THEN 'Active' 
                   WHEN Active = 'N' THEN 'Inactive' 
                 END AS Active
                 
                  
          FROM   AcademicYears 
          WHERE  ( @StartDate IS NULL 
                    OR StartDate >= @StartDate ) 
                 AND ( @EndDate IS NULL 
                        OR EndDate <= @EndDate ) 
                   AND ( @AcademicName = -1
                        OR AcademicYearId = @AcademicName ) 
                 AND ( @Active = '-1' 
                        OR Active = @Active) 
                 AND ISNULL(RecordDeleted, 'N') <> 'Y'; 



          WITH counts 
               AS (SELECT Count(*) AS TotalRows 
                   FROM   #resultset), 
               rankresultset 
               AS (SELECT AcademicYearId, 
                          CONVERT(VARCHAR(10),StartDate,101) AS StartDate
				          ,CONVERT(VARCHAR(10),EndDate,101) AS EndDate
                          ,AcademicName, 
                          QuarterOrSemester, 
                          Active,
                         
                          Count(*) 
                            OVER ()                 AS TotalCount, 
                          row_number() 
                            OVER ( 
                              ORDER BY CASE WHEN @SortExpression = 'StartDate' 
                            THEN 
                            StartDate 
                            END, 
                            CASE 
                            WHEN @SortExpression = 'StartDate DESC' THEN 
                            StartDate 
                            END 
                            DESC, 
                            CASE 
                            WHEN 
                            @SortExpression = 'EndDate' THEN EndDate END, CASE 
                            WHEN 
                            @SortExpression = 
                            'EndDate DESC' THEN EndDate END DESC, CASE WHEN 
                            @SortExpression = 
                            'QuarterOrSemester' THEN QuarterOrSemester END, CASE 
                            WHEN 
                            @SortExpression = 
                            'QuarterOrSemester DESC' THEN QuarterOrSemester END 
                            DESC, 
                            CASE 
                            WHEN 
                            @SortExpression = 'Active' THEN Active END, CASE 
                            WHEN 
                            @SortExpression 
                            = 
                            'Active DESC' THEN Active END DESC, CASE WHEN 
                            @SortExpression 
                            = 
                            'AcademicName' 
                            THEN AcademicName END, CASE WHEN @SortExpression = 
                            'AcademicName DESC' 
                            THEN 
                            AcademicName END DESC ) AS RowNumber 
                   FROM   #resultset) 
          SELECT TOP (CASE WHEN (@PageNumber = - 1) THEN (SELECT ISNULL( 
          TotalRows, 
          0) 
          FROM counts 
          ) ELSE (@PageSize) END) AcademicYearId, 
                                   CONVERT(VARCHAR(10),StartDate,101) AS StartDate
				                  ,CONVERT(VARCHAR(10),EndDate,101) AS EndDate
                                  ,AcademicName, 
                                  QuarterOrSemester, 
                                  Active, 
                                  Totalcount, 
                                  RowNumber 
          INTO   #finalresultset 
          FROM   rankresultset 
          WHERE  RowNumber > ( ( @PageNumber - 1 ) * @PageSize ) 

          IF (SELECT ISNULL(Count(*), 0) 
              FROM   #finalresultset) < 1 
            BEGIN 
                SELECT 0 AS PageNumber, 
                       0 AS NumberOfPages, 
                       0 NumberofRows 
            END 
          ELSE 
            BEGIN 
                SELECT TOP 1 @PageNumber           AS PageNumber, 
                             CASE ( Totalcount % @PageSize ) 
                               WHEN 0 THEN ISNULL(( Totalcount / @PageSize ), 0) 
                               ELSE ISNULL((Totalcount / @PageSize), 0) + 1 
                             END                   AS NumberOfPages, 
                             ISNULL(Totalcount, 0) AS NumberofRows 
                FROM   #finalresultset 
            END 

          SELECT AcademicYearId
                 ,CONVERT(VARCHAR(10),StartDate,101) AS StartDate
				 ,CONVERT(VARCHAR(10),EndDate,101) AS EndDate 
                 ,AcademicName, 
                 QuarterOrSemester, 
                 Active 
          FROM   #finalresultset 
          ORDER  BY RowNumber 
      END try 

      BEGIN catch 
          DECLARE @Error VARCHAR(8000) 

          SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
                       + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) 
                       + '*****' 
                       + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 
                       'ssp_ListPageAcademicYears') 
                       + '*****' + CONVERT(VARCHAR, ERROR_LINE()) 
                       + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) 
                       + '*****' + CONVERT(VARCHAR, ERROR_STATE()) 

          RAISERROR ( @Error,-- Message text.             
                      16,-- Severity.             
                      1 -- State.             
          ); 
      END catch 
  END 