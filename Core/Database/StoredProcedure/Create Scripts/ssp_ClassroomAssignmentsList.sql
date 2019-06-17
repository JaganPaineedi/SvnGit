IF EXISTS (SELECT *
  FROM sys.objects
  WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ClassroomAssignmentsList]')
  AND type IN (N'P', N'PC'))
  DROP PROCEDURE [dbo].[ssp_ClassroomAssignmentsList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE ssp_ClassroomAssignmentsList 
 @PageNumber INT    
 ,@PageSize INT    
 ,@SortExpression VARCHAR(100)  
 ,@StartDate varchar(20)
 ,@EndDate varchar(20)
 ,@ClassroomId int
 ,@AcademicTermId int
 ,@GradeLevel int
 ,@ClientId INT
 ,@OtherFilter  INT  
  /********************************************************************************                                                
-- Stored Procedure: ssp_ClassroomAssignmentsList                                                
--                                                
-- Copyright: Streamline Healthcare Solutions                                                
--                                                
-- Purpose: Used By Classroom Assignments List Page                                              
--                                                
-- Updates:                                                                                                       
-- Date         Author                  Purpose                                                
-- 29.03.2018   Pradeep Kumar Yadav     CREATED.      
                 
*********************************************************************************/   

 As
 Begin
	Begin Try
		DECLARE @CustomFiltersApplied CHAR(1) = 'N'    
    
  CREATE TABLE #CustomFilters   
                (ClassroomAssignmentId INT NOT NULL)  
                  
                 IF @OtherFilter > 10000    
  BEGIN    
   IF OBJECT_ID('dbo.scsp_ClassroomAssignmentsList', 'P') IS NOT NULL    
   BEGIN    
    SET @CustomFiltersApplied = 'Y'    
        
    INSERT INTO #CustomFilters (ClassroomAssignmentId)    
     EXEC scsp_ClassroomAssignmentsList @StartDate = @StartDate,    
                                  @EndDate = @EndDate,   
                                  @ClassroomId = @ClassroomId,  
                                  @AcademicTermId=@AcademicTermId,   
                                  @GradeLevel=@GradeLevel,   
                                  @OtherFilter = @OtherFilter    
    
   END    
  END;  
		CREATE TABLE #ResultSET (
		   ClassroomAssignmentId int
			,StartDate DateTime
			,EndDate DateTime
			,Classroom Varchar(50)
			,AcademicTerms VARCHAR(200)
			,GradeLevel Varchar(50)
			,ClientId INT
			
			)
			INSERT INTO #ResultSET (
			ClassroomAssignmentId
			,StartDate 
			,EndDate 
			,Classroom
			,AcademicTerms
			,GradeLevel
			,ClientId
			)
			
			Select
			CA.ClassroomAssignmentId
			,CA.StartDate
			,CA.EndDate
			,R.RoomName
			,AT.AcademicTermName
			,GC.CodeName
			,CA.ClientId
		From ClassroomAssignments CA
		Left Join Rooms R On CA.ClassroomId=R.RoomId AND ISNULL(R.RecordDeleted,'N')='N'
		
		Left Join AcademicTerms AT ON CA.AcademicTermId=AT.AcademicTermId AND ISNULL(AT.RecordDeleted,'N')='N'
		Left Join GlobalCodes GC ON CA.GradeLevel=GC.GlobalCodeId AND ISNULL(GC.RecordDeleted,'N')='N'
		Where ISNULL(CA.RecordDeleted,'N')='N' 
		AND (@StartDate Is Null
			or CA.StartDate>= @StartDate
			)
		AND (@EndDate Is Null
			or CA.EndDate<=@EndDate
			)
		AND( 
				CA.ClassroomId=@ClassroomId
				OR @ClassroomId=-1
			)	
		AND (
				CA.AcademicTermId=@AcademicTermId
				OR @AcademicTermId=-1
			) 
		AND (
				CA.GradeLevel=@GradeLevel
				OR @GradeLevel=-1			
			)
		AND (@ClientId = 0   
            OR (CA.ClientId = @ClientId))
            
;with Counts
	AS (SELECT Count(*) AS TotalRows
			FROM #ResultSet)
			,RankResultSet	
			As (Select ClassroomAssignmentId
			,StartDate 
			,EndDate 
			,Classroom
			,AcademicTerms
			,GradeLevel
			,ClientId
			,Count(*) OVER () AS TotalCount    
     ,row_number() OVER (ORDER BY CASE     
       WHEN @SortExpression = 'StartDate'    
        THEN StartDate    
       END    
      ,CASE     
       WHEN @SortExpression = 'StartDate DESC'    
        THEN StartDate    
       END DESC
       ,CASE
        When @SortExpression = 'EndDate'
          THEN EndDate    
       END    
      ,CASE     
       WHEN @SortExpression = 'EndDate DESC'    
        THEN EndDate    
       END DESC
       ,CASE
        When @SortExpression = 'Classroom'
          THEN Classroom    
       END    
      ,CASE     
       WHEN @SortExpression = 'Classroom DESC'    
        THEN Classroom    
       END DESC
       ,CASE
        When @SortExpression = 'AcademicTerms'
          THEN AcademicTerms    
       END    
      ,CASE     
       WHEN @SortExpression = 'AcademicTerms DESC'    
        THEN AcademicTerms    
       END DESC
        ,CASE
        When @SortExpression = 'GradeLevel'
          THEN GradeLevel    
       END    
      ,CASE     
       WHEN @SortExpression = 'GradeLevel DESC'    
        THEN GradeLevel    
       END DESC
       )AS RowNumber          
       FROM #ResultSet ) 
  SELECT TOP (CASE WHEN (@PageNumber = - 1)    
      THEN (SELECT ISNULL(TotalRows, 0) FROM Counts)    
     ELSE (@PageSize)    
     END    
   )ClassroomAssignmentId
    ,StartDate    
   ,EndDate    
   ,Classroom    
   ,AcademicTerms    
   ,GradeLevel
   ,ClientId
   ,TotalCount  
   ,RowNumber      
  INTO #FinalResultSet    
  FROM RankResultSet    
  WHERE RowNumber > ((@PageNumber - 1) * @PageSize)
   IF (SELECT ISNULL(Count(*), 0) FROM #FinalResultSet) < 1    
  BEGIN    
   SELECT 0 AS PageNumber    
    ,0 AS NumberOfPages    
    ,0 NumberofRows    
  END    
  ELSE    
  BEGIN    
   SELECT TOP 1 @PageNumber AS PageNumber    
    ,CASE (TotalCount % @PageSize)    
     WHEN 0    
      THEN ISNULL((TotalCount / @PageSize), 0)    
     ELSE ISNULL((TotalCount / @PageSize), 0) + 1    
     END AS NumberOfPages    
    ,ISNULL(TotalCount, 0) AS NumberofRows    
   FROM #FinalResultSet    
  END    	
  
  SELECT ClassroomAssignmentId
  ,StartDate    
   ,EndDate    
   ,Classroom    
   ,AcademicTerms    
   ,GradeLevel  
   ,ClientId  
  FROM #FinalResultSet RS    
  ORDER BY RowNumber  	
			
 END TRY    
    
 BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)    
    
  SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_ListPageClientReminders') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())    
    
  RAISERROR (    
    @Error    
    ,-- Message text.                                                                                  
    16    
    ,-- Severity.                                                                                  
    1 -- State.                                                                                  
    );    
 END CATCH    
End
 
