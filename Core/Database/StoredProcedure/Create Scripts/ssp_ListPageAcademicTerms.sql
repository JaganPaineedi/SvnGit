/****** Object:  StoredProcedure [dbo].[ssp_ListPageAcademicTerms]    Script Date: 16/03/2018 11:54:00 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageAcademicTerms]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_ListPageAcademicTerms]
GO

/****** Object:  StoredProcedure [dbo].[ssp_ListPageAcademicTerms]    Script Date: 16/03/2018 11:54:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_ListPageAcademicTerms]
	/*************************************************************/
	/* Stored Procedure: dbo.ssp_ListPageAcademicTerms	0,200,'DESC','','','-1','Y',-1,-1,0          */
	/* Creation Date:  Mar 16 2018                                */
	/* Purpose: To get the list of Academic Years for class room 
			 */
	/*  Date                  Author                 Purpose     */
	/* Mar 16 2018           Chita Ranjan            To get the list of Academic Terms. PEP-Customizations #10005     */
	/*History*/
	/*************************************************************/
	 @PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@StartDate DateTime
	,@EndDate Datetime
	,@QuarterSemester INT
	,@Active          CHAR(10) 
	,@AcademicTermName INT
	,@AcademicYears INT
	,@OtherFilter  INT
AS
BEGIN
	BEGIN TRY
	 DECLARE @CustomFiltersApplied CHAR(1) = 'N'  
	 
	 CREATE TABLE #CustomFilters 
                (AcademicTermId INT NOT NULL)
                
                 IF @OtherFilter > 10000  
  BEGIN  
   IF OBJECT_ID('dbo.scsp_ListPageAcademicTerms', 'P') IS NOT NULL  
   BEGIN  
    SET @CustomFiltersApplied = 'Y'  
      
    INSERT INTO #CustomFilters (AcademicTermId)  
     EXEC scsp_ListPageAcademicTerms @StartDate = @StartDate,  
                                  @EndDate = @EndDate, 
                                   @Active=@Active, 
                                  @QuarterSemester = @QuarterSemester,
                                  @AcademicTermName=@AcademicTermName, 
                                  @AcademicYears=@AcademicYears, 
                                  @OtherFilter = @OtherFilter  
  
   END  
  END;  
  
	CREATE TABLE #ResultSET (
			AcademicTermId INT
			,StartDate DATETIME
			,EndDate DATETIME
			,AcademicTermName VARCHAR(250)
			,QuarterOrSemester VARCHAR(50)
			,AcademicYears VARCHAR(250)
			,Active VARCHAR(10), 
			)
			
			
		INSERT INTO #ResultSET (
			 AcademicTermId
			,StartDate
			,EndDate
			,AcademicTermName
			,AcademicYears
			,QuarterOrSemester
			,Active
			)
			
			SELECT AT.AcademicTermId
			,CONVERT(VARCHAR(10),AT.StartDate,101)AS StartDate
			,CONVERT(VARCHAR(10),AT.EndDate,101) AS EndDate
		    ,AcademicTermName
			,AY.AcademicName as AcademicYears
		    ,GC.CodeName AS QuarterOrSemester
		    ,CASE 
                   WHEN AT.Active = 'Y' THEN 'Active' 
                   WHEN AT.Active = 'N' THEN 'Inactive' 
                 END AS Active
		FROM AcademicTerms  AT INNER JOIN AcademicYears AY ON AT.AcademicYearId=AY.AcademicYearId
		INNER JOIN GlobalCodes GC ON GC.GlobalCodeId=AT.QuarterOrSemester
		WHERE   ((  
      @StartDate IS NULL  
      OR AT.StartDate >= @StartDate  
      )  
     AND (  
      @EndDate IS NULL  
      OR AT.EndDate IS NULL  
      OR AT.EndDate <= @EndDate  
      ) 
      AND (@QuarterSemester = '-1' OR AT.QuarterOrSemester = @QuarterSemester)	
      AND (@AcademicTermName = '-1' OR AT.AcademicTermId = @AcademicTermName)
	  AND (@AcademicYears = '-1' OR AT.AcademicYearId = @AcademicYears)	
	   AND (@Active = '-1' OR AT.Active = @Active) 
	  AND AY.Active='Y'
	  AND ISNULL(AT.RecordDeleted,'N')='N' AND  ISNULL(AY.RecordDeleted,'N')='N')
			

        ;WITH Counts
		AS (SELECT Count(*) AS TotalRows
			FROM #ResultSet)
			,RankResultSet
			AS (SELECT AcademicTermId
						,CONVERT(VARCHAR(10),StartDate,101) AS StartDate
						,CONVERT(VARCHAR(10),EndDate,101) AS EndDate
						,AcademicTermName
				        ,AcademicYears
				        ,QuarterOrSemester
				        ,Active
					,Count(*) OVER () AS TotalCount
					,row_number() OVER (ORDER BY CASE WHEN @SortExpression = 'StartDate' THEN StartDate END
												,CASE WHEN @SortExpression = 'StartDate DESC' THEN StartDate END DESC
												,CASE WHEN @SortExpression = 'EndDate' THEN EndDate END
												,CASE WHEN @SortExpression = 'EndDate DESC' THEN EndDate END DESC
												,CASE WHEN @SortExpression = 'QuarterOrSemester' THEN QuarterOrSemester END
												,CASE WHEN @SortExpression = 'QuarterOrSemester DESC' THEN QuarterOrSemester END DESC
												,CASE WHEN @SortExpression = 'AcademicTermName' THEN AcademicTermName END
												,CASE WHEN @SortExpression = 'AcademicTermName DESC' THEN AcademicTermName END DESC
												,CASE WHEN @SortExpression = 'AcademicYears' THEN AcademicYears END
												,CASE WHEN @SortExpression = 'AcademicYears DESC' THEN AcademicYears END DESC
												,CASE WHEN @SortExpression = 'Active' THEN Active END
												,CASE WHEN @SortExpression = 'Active DESC' THEN Active END DESC
												) AS RowNumber   
													FROM #ResultSet)
																		
			SELECT TOP (CASE WHEN (@PageNumber = - 1)
							THEN (SELECT ISNULL(TotalRows, 0) FROM Counts)
						ELSE (@PageSize)
						END)
						AcademicTermId
						,CONVERT(VARCHAR(10),StartDate,101)AS StartDate
						,CONVERT(VARCHAR(10),EndDate,101) AS EndDate
						,AcademicTermName
						,AcademicYears
						,QuarterOrSemester
						,Active
						,Totalcount
						,RowNumber
			INTO #FinalResultSet   
			FROM RankResultSet
		   WHERE RowNumber > ((@PageNumber - 1) * @PageSize)  
		   
		   
		   IF (SELECT ISNULL(Count(*), 0)	FROM #FinalResultSet) < 1
		  BEGIN
			SELECT 0 AS PageNumber
				,0 AS NumberOfPages
				,0 NumberofRows
		END
		ELSE
		BEGIN
			SELECT TOP 1 @PageNumber AS PageNumber
				,CASE (Totalcount % @PageSize)
					WHEN 0
						THEN ISNULL((Totalcount / @PageSize), 0)
					ELSE ISNULL((Totalcount / @PageSize), 0) + 1
					END AS NumberOfPages
				,ISNULL(Totalcount, 0) AS NumberofRows
			FROM #FinalResultSet
		END
		SELECT AcademicTermId
						,CONVERT(VARCHAR(10),StartDate,101)AS StartDate
						,CONVERT(VARCHAR(10),EndDate,101) AS EndDate
						,AcademicTermName
						,AcademicYears
						,QuarterOrSemester
						,Active 
						FROM #FinalResultSet  
		    ORDER BY RowNumber  
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_ListPageAcademicTerms') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.          
				16
				,-- Severity.          
				1 -- State.          
				);
	END CATCH
END
GO

