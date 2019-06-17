/****** Object:  StoredProcedure [dbo].[ssp_SCGetCourseDetails]    Script Date: 16/03/2018 11:54:00 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetCourseDetails]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetCourseDetails]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetCourseDetails]    Script Date: 16/03/2018 11:54:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetCourseDetails] @CourseId INT
	/*************************************************************/
	/* Stored Procedure: dbo.ssp_SCGetCourseDetails 14        */
	/* Creation Date:  Mar 16 2018                                */
	/* Purpose: To get the Couse details
			 */
	/*  Date                  Author                 Purpose     */
	/* Mar 16 2018           Chita Ranjan            To get the Couse details. PEP-Customizations #10005     */
	/* Oct 15 2018           Kavya.N            Added programid column and joining the program from programs table_PEP CUstomization#1005.7 */
	/*History*/
	
AS
BEGIN
	BEGIN TRY
		
		DECLARE @CurrentDate DateTime
		DECLARE @NextYearDate DateTime
		
		SET @CurrentDate = DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)
		SET @NextYearDate = DATEADD(MILLISECOND,- 3,DATEADD(YEAR, DATEDIFF(YEAR, 0, DATEADD(YEAR, 1, GETDATE())) + 1, 0))
		
		PRINT @CurrentDate
		PRINT @NextYearDate
		
		CREATE TABLE #CourseSchedules(CourseScheduleId INT,
									DaysList VARCHAR(MAX))
	INSERT INTO #CourseSchedules(CourseScheduleId,DaysList)
	SELECT  CourseScheduleId
			,Case WHEN ISNULL(Monday,'N')='Y' THEN 'Monday,'  ELSE '' END   +    
			Case WHEN ISNULL(Tuesday,'N')='Y' THEN  'Tuesday,' ELSE ''  END  +    
			Case WHEN ISNULL(Wednesday,'N')='Y'  THEN 'Wednesday,' ELSE ''  END   +    
			Case WHEN ISNULL(Thursday,'N')='Y'  THEN  'Thursday,'  ELSE '' END    +    
			Case WHEN ISNULL(Friday,'N')='Y'  THEN  'Friday,'  ELSE '' END    +    
			Case WHEN ISNULL(Saturday,'N')='Y'  THEN  'Saturday,' ELSE ''  END    +    
			Case WHEN ISNULL(Sunday,'N')='Y'  THEN  'Sunday,'  ELSE '' END   AS DaysList 
	FROM CourseSchedules CS
	 WHERE CS.CourseId= @CourseId    
	 AND  ISNULL(CS.RecordDeleted,'N')= 'N'
			
	SELECT C.CourseId
		,C.CreatedBy
		,C.CreatedDate
		,C.ModifiedBy
		,C.ModifiedDate
		,C.RecordDeleted
		,C.DeletedBy
		,C.DeletedDate
		,C.AcademicTermId
		,C.CourseType
		,C.CourseGroup
		,CT.TypeOfCourse AS CourseTypeName
		,C.NoOfCredits
		,C.CourseName
	FROM Courses C
	LEFT JOIN CourseTypes CT ON C.CourseType = CT.CourseTypeId AND ISNULL(CT.RecordDeleted, 'N') <> 'Y'
	WHERE C.CourseId = @CourseId
		AND ISNULL(C.RecordDeleted, 'N') <> 'Y'
	
SELECT		 CS.CourseScheduleId
			,CS.CreatedBy
			,CS.CreatedDate
			,CS.ModifiedBy
			,CS.ModifiedDate
			,CS.RecordDeleted
			,CS.DeletedBy
			,CS.DeletedDate
			,CS.CourseId
			,CS.RoomId
			,R.RoomName AS RoomIdText
			,CS.StartTime
			,CS.EndTime
			,CS.Monday
			,CS.Tuesday
			,CS.Wednesday
			,CS.Thursday
			,CS.Friday
			,CS.Saturday
			,CS.Sunday
			,CS.StartDate
		    ,CS.EndDate
		    ,CASE WHEN CS.StartDate > = @CurrentDate AND CS.EndDate < = @NextYearDate THEN 'C' 
		     ELSE 'N' END AS ShowCurrentNextYear
		    ,CASE T.DaysList WHEN null THEN null
				ELSE (
				 CASE LEN(T.DaysList) WHEN 0 THEN T.DaysList 
					ELSE LEFT(T.DaysList, LEN(T.DaysList) - 1) 
				 END 
				) END AS DaysOfWeek,
				CS.ProgramId ,  
                p.programname as ProgramIdText 
				 FROM #CourseSchedules T JOIN CourseSchedules CS ON T.CourseScheduleId=CS.CourseScheduleId
	             JOIN Rooms R On CS.RoomId=R.RoomId 
	             JOIN Programs p on CS.ProgramId= p.programid
	             Where CS.CourseId=@CourseId AND ISNULL(CS.RecordDeleted,'N')<>'Y' AND ISNULL(R.RecordDeleted,'N')<>'Y' AND ISNULL(p.RecordDeleted,'N')<>'Y'
	
	SELECT	CSA.CourseStaffAssignmentId
		,CSA.CreatedBy
		,CSA.CreatedDate
		,CSA.ModifiedBy
		,CSA.ModifiedDate
		,CSA.RecordDeleted
		,CSA.DeletedBy
		,CSA.DeletedDate
		,CSA.CourseId
		,CSA.StaffId
		,S.DisplayAs AS StaffName
		,CSA.IsPrimary
		,CASE WHEN CSA.IsPrimary = 'Y' THEN 'Yes' 
		      WHEN CSA.IsPrimary = 'N' THEN 'No'
		      END AS IsPrimaryStaff
	FROM CourseStaffAssignments CSA INNER JOIN Staff S On S.StaffId=CSA.StaffId Where CSA.CourseId=@CourseId AND ISNULL(CSA.RecordDeleted,'N')<>'Y' AND ISNULL(S.RecordDeleted,'N')<>'Y'
	
	
	SELECT	CCA.CourseClientAssignmentId
			,CCA.CreatedBy
			,CCA.CreatedDate
			,CCA.ModifiedBy
			,CCA.ModifiedDate
			,CCA.RecordDeleted
			,CCA.DeletedBy
			,CCA.DeletedDate
			,CCA.RoomId
			,CCA.ClientId
			,CCA.CourseId
			,(C.LastName+', '+C.FirstName + ' ' + '('+(CONVERT(varchar(20),C.ClientId))+')') AS ClientName
			,CCA.ClientsFromClassroom
			,CCA.Grade
			,CCA.QuarterOrSemester
			,CCA.AttemptedCredit
			,CCA.AwardedCredit
			,GC.CodeName AS GradeText, GC1.CodeName as QuarterOrSemesterText
			,GC2.CodeName as AttemptedCreditText, GC3.CodeName as  AwardedCreditText
			,R.Roomname as ClientsFromClassroomText
	 FROM CourseClientAssignments CCA INNER JOIN Clients C ON C.ClientID =CCA.ClientID 
	 LEFT  JOIN GlobalCodes GC ON  CCA.Grade = GC.Globalcodeid
                LEFT  JOIN GlobalCodes GC1 ON  CCA.QuarterOrSemester = GC1.Globalcodeid
                Left  JOIN GlobalCodes GC2 ON  CCA.AttemptedCredit = GC2.Globalcodeid
                Left  JOIN GlobalCodes GC3 ON CCA.AwardedCredit= GC3.Globalcodeid
                Left Join Rooms R ON R.Roomid = CCA.ClientsFromClassroom
                
	 Where CCA.CourseId=@CourseId AND ISNULL(CCA.RecordDeleted,'N')<>'Y' AND ISNULL(C.RecordDeleted,'N')<>'Y' AND ISNULL(R.RecordDeleted,'N')<>'Y'
	
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetCourseDetails') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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

