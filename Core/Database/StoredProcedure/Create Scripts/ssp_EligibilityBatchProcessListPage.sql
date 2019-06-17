/****** Object:  StoredProcedure [dbo].[ssp_EligibilityBatchProcessListPage]    Script Date: 06/14/2012 11:40:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_EligibilityBatchProcessListPage]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_EligibilityBatchProcessListPage]
GO
/****** Object:  StoredProcedure [dbo].[ssp_EligibilityBatchProcessListPage]    Script Date: 06/14/2012 11:40:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
                                    
-- =============================================  
-- Author:  Kneale Alpers  
-- Create date: Feb 13, 2012  
-- Description: Returns the Eligibility Batch data  
-- Modified by pradeep to return the failed subbatch count.  
-- Date			Author			   Purpose
-- JUN.20.2016	Ravichandra		   Removed the physical table ListPageEligibilityBatchProcess from SP
--								   Why:Task #108, Engineering Improvement Initiatives- NBL(I)	
--								   108 - Do NOT use list page tables for remaining list pages (refer #107)	
-- =============================================  
CREATE PROCEDURE [dbo].[ssp_EligibilityBatchProcessListPage]  
    @SessionId VARCHAR(30) ,  
    @InstanceId INT ,  
    @PageNumber INT ,  
    @PageSize INT ,  
    @SortExpression VARCHAR(100) ,  
    @StartDate DATETIME ,  
    @EndDate DATETIME ,  
    @OtherFilter INT ,  
    @StaffId INT  
AS   
    BEGIN  
        BEGIN TRY   
            CREATE TABLE #ResultSet  
                (  
                 ElectronicEligibilityVerificationBatchId INT ,  
                  BatchName VARCHAR(100) ,  
                  StaffName VARCHAR(50) ,  
                  BatchDate DATETIME ,  
                  TotalRecords INT ,  
                  TotalErrors INT ,  
                  TotalSubBatchesFailed INT  
                )  
     
            DECLARE @CustomFilters TABLE  
                (  
                  ElectronicEligibilityVerificationBatchId INT  
                )                                                    
            DECLARE @ApplyFilterClicked CHAR(1)  
            DECLARE @CustomFiltersApplied CHAR(1)  
     
            SET @SortExpression = RTRIM(LTRIM(@SortExpression))  
            IF ISNULL(@SortExpression, '') = ''   
                SET @SortExpression = 'StaffName'  
   
       
  --   
  -- New retrieve - the request came by clicking on the Apply Filter button                     
  --  
            SET @ApplyFilterClicked = 'Y'   
            SET @CustomFiltersApplied = 'N'                                                   
               
            IF @OtherFilter > 10000   
                BEGIN  
                    SET @CustomFiltersApplied = 'Y'  
     
                    INSERT  INTO @CustomFilters  
                            ( ElectronicEligibilityVerificationBatchId  
                            )  
                            EXEC scsp_EligibilityBatchProcessListPage @StartDate = @StartDate,  
                                @EndDate = @EndDate,  
                                @OtherFilter = @OtherFilter,  
                                @StaffId = @StaffId  
                END
                
                ;WITH    BatchList  
                      AS ( SELECT   a.ElectronicEligibilityVerificationBatchId ,  
                                    a.BatchName ,  
                                    ISNULL(RTRIM(c.lastname) + ', '  
                                           + LTRIM(c.firstname), '') AS StaffName ,  
                                    a.CreatedDate  
                           FROM     ElectronicEligibilityVerificationBatches a  
                                    LEFT JOIN staff c ON ( a.createdby = c.usercode )  
                                    LEFT JOIN @CustomFilters cf ON ( @CustomFiltersApplied = 'Y'  
                                                              AND cf.ElectronicEligibilityVerificationBatchId = a.ElectronicEligibilityVerificationBatchId  
                                                              )  
                        WHERE    ( @CustomFiltersApplied = 'Y'  
                                      AND cf.ElectronicEligibilityVerificationBatchId IS NOT NULL  
                                    )  
                                    OR ( @CustomFiltersApplied = 'N'  
                                         AND a.createddate >= @StartDate  
                                         AND a.createddate <= DATEADD(day, 1,  
                                                              @EndDate)  
                                       )  
                         ),  
                    BatchListVerificationRequests  
                      AS ( SELECT   a.ElectronicEligibilityVerificationBatchId ,  
                                    a.BatchName ,  
                                    a.staffname ,  
                                    a.CreatedDate ,  
                                    COUNT(b.ElectronicEligibilityVerificationBatchId) AS TotalRecords ,  
                                    SUM(CASE WHEN ISNULL(b.requesterrormessage,  
                                                         '') = '' THEN 0  
                                             ELSE 1  
                                        END) AS TotalErrors  
                           FROM     BatchList a  
                                    JOIN ElectronicEligibilityVerificationRequests b ON ( a.ElectronicEligibilityVerificationBatchId = b.ElectronicEligibilityVerificationBatchId )  
                           GROUP BY a.ElectronicEligibilityVerificationBatchId ,  
                                    a.BatchName ,  
                                    a.staffname ,  
                                    a.CreatedDate  
                         ),  
                    BatchListFinal  
                      AS ( SELECT   a.ElectronicEligibilityVerificationBatchId ,  
                                    a.BatchName ,  
                                    a.staffname ,  
                                    a.CreatedDate ,  
                                    a.TotalRecords ,  
                                    a.TotalErrors ,  
                                    COUNT(v.ElectronicEligibilityVerificationBatchId) AS TotalSubBatchesFailed  
                           FROM     BatchListVerificationRequests a  
                                    LEFT JOIN ElectronicEligibilityVerificationSubBatches s with (nolock) ON ( a.ElectronicEligibilityVerificationBatchId = s.ElectronicEligibilityVerificationBatchId )  
                                    LEFT JOIN ElectronicEligibilityVerificationBatches v with (nolock) ON ( s.ProcessStatus = 0  
                                                              AND s.ElectronicEligibilityVerificationBatchId = v.ElectronicEligibilityVerificationBatchId  
                                                              )  
                           GROUP BY a.ElectronicEligibilityVerificationBatchId ,  
                                    a.BatchName ,  
                                    a.staffname ,  
                                    a.CreatedDate ,  
                                    a.TotalRecords ,  
                                    a.TotalErrors  
                         )  
                INSERT  INTO #ResultSet  
                        ( ElectronicEligibilityVerificationBatchId ,  
                          BatchName ,  
                          StaffName ,  
                          BatchDate ,  
                          TotalRecords ,  
                          TotalErrors ,  
                          TotalSubBatchesFailed   
                  )  
                        SELECT  ElectronicEligibilityVerificationBatchId ,  
                                BatchName ,  
                                staffname ,  
                                CreatedDate ,  
                                TotalRecords ,  
                                TotalErrors ,  
                                TotalSubBatchesFailed  
                        FROM    BatchListFinal  
  
                              
     
      ; WITH Counts
		AS (SELECT Count(*) AS TotalRows
			FROM #ResultSet)
			,RankResultSet
			AS (SELECT ElectronicEligibilityVerificationBatchId ,  
                          BatchName ,  
                          StaffName ,  
                          BatchDate ,  
                          TotalRecords ,  
                          TotalErrors ,  
                          TotalSubBatchesFailed  
				,Count(*) OVER () AS TotalCount
				 ,ROW_NUMBER() OVER ( ORDER BY CASE  
                                                  WHEN @SortExpression = 'StaffName'  
                                                  THEN StaffName  
                                                  END, 
                                                  CASE  
                                                  WHEN @SortExpression = 'StaffName DESC'  
                                                  THEN StaffName  
                                                  END DESC,
                                                   CASE  
                                                  WHEN @SortExpression = 'BatchName'  
                                                  THEN BatchName  
                                                  END, 
                                                  CASE  
                                                  WHEN @SortExpression = 'BatchName DESC'  
                                                  THEN BatchName  
                                                  END DESC, 
                                                  CASE  
                                                  WHEN @SortExpression = 'BatchDate'  
                                                  THEN BatchDate  
                                                  END, 
                                                  CASE  
                                                  WHEN @SortExpression = 'BatchDate DESC'  
                                                  THEN BatchDate  
                                                  END DESC, 
                                                  CASE  
                                                  WHEN @SortExpression = 'TotalRecords'  
                                                  THEN TotalRecords  
                                                  END,
                                                  CASE  
													WHEN @SortExpression = 'TotalRecords DESC'  
                                                  THEN TotalRecords  
                                                  END DESC, 
                                                  CASE  
                                                  WHEN @SortExpression = 'TotalErrors'  
                                                  THEN TotalErrors  
                                                  END, 
                                                  CASE  
                                                  WHEN @SortExpression = 'TotalErrors DESC'  
                                                  THEN TotalErrors  
                                                  END DESC, 
                                                  CASE  
                                                  WHEN @SortExpression = 'TotalFailedSubBatches'  
                                                  THEN TotalSubBatchesFailed  
                                                  END, 
                                                  CASE  
                                                  WHEN @SortExpression = 'TotalFailedSubBatches DESC'  
                                                  THEN TotalSubBatchesFailed  
                                                  END DESC, 
                                                  ElectronicEligibilityVerificationBatchId ) AS RowNumber    
												FROM #ResultSet	)
		SELECT TOP (CASE WHEN (@PageNumber = - 1)
						THEN (SELECT ISNULL(TotalRows, 0) FROM Counts)
					ELSE (@PageSize)
					END
				)	  ElectronicEligibilityVerificationBatchId ,  
                          BatchName ,  
                          StaffName ,  
                          BatchDate ,  
                          TotalRecords ,  
                          TotalErrors ,  
                          TotalSubBatchesFailed  as TotalFailedSubBatches
					,TotalCount
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

		SELECT  ElectronicEligibilityVerificationBatchId ,    
                    BatchName ,    
                    StaffName ,    
                    CONVERT(VARCHAR(10), BatchDate, 101) AS BatchDate ,    
                    TotalRecords ,    
                    TotalErrors ,    
                    TotalFailedSubBatches     
		FROM #FinalResultSet
		ORDER BY RowNumber  
	     
        END TRY   
   
        BEGIN CATCH  
            DECLARE @Error VARCHAR(8000)         
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'  
                + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'  
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),  
                         'ssp_EligibilityBatchProcessListPage') + '*****'  
                + CONVERT(VARCHAR, ERROR_LINE()) + '*****'  
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'  
                + CONVERT(VARCHAR, ERROR_STATE())  
            RAISERROR  
  (  
   @Error, -- Message text.  
   16,  -- Severity.  
   1  -- State.  
  );  
        END CATCH  
    END  
  
  
  
GO


