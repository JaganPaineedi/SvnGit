IF EXISTS (SELECT *
  FROM sys.objects
  WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ClassroomAssignmentsMyOfficeList]')
  AND type IN (N'P', N'PC'))
  DROP PROCEDURE [dbo].[ssp_ClassroomAssignmentsMyOfficeList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Create Proc ssp_ClassroomAssignmentsMyOfficeList 
 @PageNumber INT    
 ,@PageSize INT    
 ,@SortExpression VARCHAR(100)  
 ,@StartDate varchar(20)
 ,@EndDate varchar(20)
 ,@ClassroomId int
 ,@AcademicTermId int
 ,@GradeLevel int
 ,@ClientId INT
 ,@CourseGroupFilter INT
 ,@CourseTypeFilter VARCHAR(500)
 ,@OtherFilter  INT  
  /********************************************************************************                                                
-- Stored Procedure: ssp_ClassroomAssignmentsMyOfficeList                                                
--                                                
-- Copyright: Streamline Healthcare Solutions                                                
--                                                
-- Purpose: Used By Classroom Assignments MyOffice List Page                                              
--                                                
-- Updates:                                                                                                       
-- Date         Author                  Purpose                                                
-- 29.03.2018   Pradeep Kumar Yadav     CREATED.   
-- 28.01.2019   Veena S Mani            What:Corrected the max length of the columns of resultset
                                        Why: PEP - Support Go Live #135      
                  
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
                                  @CourseGroupFilter = @CourseGroupFilter,
                                  @CourseTypeFilter = @CourseTypeFilter,
                                  @OtherFilter = @OtherFilter    
    
   END    
  END;  
		CREATE TABLE #ResultSET (
		    ClassroomAssignmentId int
		   ,ClientId INT
		   ,ClientName VARCHAR(250) 
			,StartDate DateTime
			,EndDate DateTime
			,Classroom Varchar(100)
			,AcademicTerms VARCHAR(250)
			,GradeLevel Varchar(250)
			,CourseGroup VARCHAR(250)
			,TypeOfCourse VARCHAR(500)
			)
			INSERT INTO #ResultSET (
			ClassroomAssignmentId
			,ClientId
			,ClientName
			,StartDate 
			,EndDate 
			,Classroom
			,AcademicTerms
			,GradeLevel
			,CourseGroup
			,TypeOfCourse
			)
			
			Select
			CA.ClassroomAssignmentId
			,C.ClientId  
			,(C.LastName + ', ' + C.FirstName) AS ClientName 
			,CA.StartDate
			,CA.EndDate
			,R.RoomName
			,AT.AcademicTermName
			,GC.CodeName
			,G.CodeName AS CourseGroup
			,CT.TypeOfCourse AS TypeOfCourse
			
		From ClassroomAssignments CA
		Left Join Rooms R On CA.ClassroomId=R.RoomId AND ISNULL(R.RecordDeleted,'N')='N'
		INNER JOIN Clients C ON C.ClientId = CA.ClientId AND ISNULL(C.RecordDeleted,'N') <> 'Y' 
		Left Join AcademicTerms AT ON CA.AcademicTermId=AT.AcademicTermId AND ISNULL(AT.RecordDeleted,'N')='N'
		Left Join Courses CR ON CR.AcademicTermId = AT.AcademicTermId AND ISNULL(CR.RecordDeleted, 'N') = 'N'
		LEFT JOIN CourseTypes CT  ON CT.CourseTypeId = CR.CourseType AND ISNULL(CT.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes G ON G.GlobalCodeId = CR.CourseGroup AND ISNULL(G.RecordDeleted, 'N') = 'N'
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
		AND (@ClientId = -1  Or @ClientId=0
            OR (CA.ClientId = @ClientId))
            
            AND (
			    @CourseGroupFilter = '-1'
				OR CR.CourseGroup = @CourseGroupFilter
			)
        AND (
				@CourseTypeFilter = '-1'
				OR CT.TypeOfCourse = @CourseTypeFilter
			)
		
            
;with Counts
	AS (SELECT Count(*) AS TotalRows
			FROM #ResultSet)
			,RankResultSet	
			As (Select ClassroomAssignmentId
			,ClientId
			,ClientName
			,StartDate 
			,EndDate 
			,Classroom
			,AcademicTerms
			,GradeLevel
			,CourseGroup
			,TypeOfCourse
			,Count(*) OVER () AS TotalCount    
     ,row_number() OVER (ORDER BY 
     CASE WHEN @SortExpression= 'ClientName' THEN ClientName END      
             ,CASE WHEN @SortExpression= 'ClientName desc' THEN ClientName END DESC  
     ,CASE     
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
       ,CASE     
       WHEN @SortExpression = 'CourseGroup'    
        THEN CourseGroup 
        END   
        ,CASE     
       WHEN @SortExpression = 'CourseGroup DESC'    
        THEN GradeLevel
       END DESC
       ,CASE     
       WHEN @SortExpression = 'TypeOfCourse'    
        THEN TypeOfCourse   
        END
        ,CASE     
       WHEN @SortExpression = 'TypeOfCourse DESC'    
        THEN TypeOfCourse 
       END DESC
       )AS RowNumber          
       FROM #ResultSet ) 
  SELECT TOP (CASE WHEN (@PageNumber = - 1)    
      THEN (SELECT ISNULL(TotalRows, 0) FROM Counts)    
     ELSE (@PageSize)    
     END    
   )ClassroomAssignmentId
   ,ClientId
   ,ClientName
   ,StartDate    
   ,EndDate    
   ,Classroom    
   ,AcademicTerms    
   ,GradeLevel
   ,CourseGroup
   ,TypeOfCourse
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
   ,ClientId
   ,ClientName
   ,CONVERT(VARCHAR(10), StartDate, 101) AS StartDate
   ,CONVERT(VARCHAR(10), EndDate, 101) AS EndDate    
   ,Classroom    
   ,AcademicTerms    
   ,GradeLevel  
   ,CourseGroup
   ,TypeOfCourse
  FROM #FinalResultSet RS    
  ORDER BY RowNumber  	
			
 END TRY    
    
 BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)    
    
  SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_ClassroomAssignmentsMyOfficeList') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())    
    
  RAISERROR (    
    @Error    
    ,-- Message text.                                                                                  
    16    
    ,-- Severity.                                                                                  
    1 -- State.                                                                                  
    );    
 END CATCH    
End
 
