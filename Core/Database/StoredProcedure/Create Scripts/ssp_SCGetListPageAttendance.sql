 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ssp_SCGetListPageAttendance')
	BEGIN
		DROP  Procedure  ssp_SCGetListPageAttendance
	END
GO
    
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetListPageAttendance]
 (	
	@PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@Date DATETIME
	,@ProgramId INT
	,@StaffId INT
	,@GroupId INT
	,@NoteType INT
	,@OtherFilter INT
	,@CurrentUserId INT
	)
	/********************************************************************************                                                 
** Stored Procedure: ssp_SCGetListPageAttendance   -1,0,'DocumentationScreen','10/26/2017 03:12 PM',0,0,30862,0,0,13324                                                 
**                                                  
** Copyright: Streamline Healthcate Solutions                                                    
** Updates:                                                                                                         
** Date            Author              Purpose   
** 11-MAY-2015	   Akwinass			   What:Get Attandance Groups      
**									   Why:Task #829 in Woods - Customizations   
** 23-JUNE-2015	   Akwinass			   What:Next Appointment not displaying bug is fixed.       
**									   Why:Task #829.02 in Woods - Environment Issues Tracking 
** 20-JULY-2015	   Akwinass			   What:Documentation/Screen not displaying bug is fixed.       
**									   Why:Task #829 in Woods - Customizations
** 06-Aug-2015	   Akwinass			   What:Checked Out Column Changes Included.       
**									   Why:Task #829.09 in Woods - Customizations
** 29-SEP-2015	   Akwinass			   What:Displaying Documentation/Screen Logic Modified
**									   Why:Task #829.06 in Core Bugs
** 30-OCT-2015	   Akwinass			   What:Modified the logic to display one client per group service.
**									   Why:Task #17 in Valley - Support Go Live
** 30-OCT-2015	   Akwinass			   What:Removed Staff Active Check.
**									   Why:Task #121 in Valley - Support Go Live
** 15-Dec-2015     Basudev sahu        Modified For Task #609 Network180 Customization
** 22-Feb-2016	   Akwinass	           What:Modified to check Associated Document is Signed or Not for the Filtered Date
**							           Why:task #167 Valley - Support Go Live
** 22-Feb-2016	   Akwinass	           What:Included @ServiceId in ssf_SCAttendanceDocumentStatus
**							           Why:task #167 Valley - Support Go Live
** 23-Feb-2016	   Akwinass	           What:Included @ServiceId in ssf_SCGetAttendanceNextAppointmentDetails
**							           Why:task #829.04 Woods - Customizations
** 04-MAR-2016	   Akwinass	           What:Included @ServiceId in ssf_SCGetAttendanceBannerDetails
**							           Why:task #17 Woods - Support Go Live
** 13-APRIL-2016  Akwinass	           What:Included GroupNoteType Column.          
							           Why:task #167.1 Valley - Support Go Live
** 15-APRIL-2016  Akwinass	           What:Included "Complete" Services.          
							           Why:task #207 Valley - Support Go Live
** 28-April-2017  Gautam               What: Modify code to first get service details on date and Removed the function call from select stat and later updated on temp table
									   Why : Performance issue.,Woods support go live - #602 
** 06-Nov-2017	  Vandana			   What: Modified 'DocumentSigned' datatype from Varchar(10) to Varchar(max)
									   Why : Srting truncating issue ,Core Bugs- #2433	     							           
*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		DECLARE @CustomFiltersApplied CHAR(1) = 'N'
		DECLARE @ApplyFilterClick AS CHAR(1)

		SET @SortExpression = RTRIM(LTRIM(@SortExpression))

		IF ISNULL(@SortExpression, '') = ''
			SET @SortExpression = 'EffectiveDate desc'
		--28-April-2017  Gautam 	
		CREATE TABLE #ServiceData (
			ServiceId INT
			,ClientId INT
			,StaffId INT
			,ProgramId INT
			,GroupServiceId INT
			,CheckInTime DATETIME
			,ServiceStatus INT
			,CancelReason int
			,ProcedureCodeId int
			)		
			
		CREATE TABLE #ResultSet (
			ServiceId INT
			,ClientId INT
			,ClientName VARCHAR(250)
			,StaffId INT
			,Staff VARCHAR(250)
			,GroupId INT
			,GroupName VARCHAR(250)
			,ProgramId INT
			,ProgramCode VARCHAR(250)			
			,BannerDetails VARCHAR(MAX)
			,NextMedDue VARCHAR(MAX)
			,NextAppointment VARCHAR(MAX)
			,LocationCode VARCHAR(250)
			,ColorCode VARCHAR(15)
			,GroupServiceId INT
			,CheckInTime DATETIME
			,CheckOutTime DATETIME
			,ServiceStatus INT
			,CancelReason VARCHAR(250)
			,AttendanceScreenId INT
			,GroupNoteType INT
			,GroupNoteDocumentCodeId INT
			,ServiceCount INT
			,DocumentSigned VARCHAR(max)  ---Core Bugs- #2433, modified datatype from varchar(10) to varchar(max)
			,ServiceGroupServiceId int
			)		
		
		CREATE TABLE #CustomFilters (
			ServiceId INT
			,ClientId INT
			,ClientName VARCHAR(250)
			,StaffId INT
			,Staff VARCHAR(250)
			,GroupId INT
			,GroupName VARCHAR(250)
			,ProgramId INT
			,ProgramCode VARCHAR(250)
			,BannerDetails VARCHAR(MAX)
			,NextMedDue VARCHAR(MAX)
			,NextAppointment VARCHAR(MAX)
			,LocationCode VARCHAR(250)
			,ColorCode VARCHAR(15)
			,GroupServiceId INT
			,CheckInTime DATETIME
			,CheckOutTime DATETIME
			,ServiceStatus INT
			,CancelReason VARCHAR(250)
			,AttendanceScreenId INT
			,GroupNoteType INT
			,GroupNoteDocumentCodeId INT
			,ServiceCount INT
			,DocumentSigned INT
			)

		--Get custom filters                                                    
		IF @OtherFilter > 10000
		BEGIN
			IF OBJECT_ID('dbo.scsp_SCListPageAttendance', 'P') IS NOT NULL
			BEGIN
				SET @CustomFiltersApplied = 'Y'
				
				
				INSERT INTO #CustomFilters (
					ServiceId
					,ClientId
					,ClientName
					,StaffId
					,Staff
					,GroupId
					,GroupName
					,ProgramId
					,ProgramCode
					,BannerDetails
					,NextMedDue
					,NextAppointment
					,LocationCode
					,ColorCode
					,GroupServiceId
					,CheckInTime
					,CheckOutTime
					,ServiceStatus
					,CancelReason
					,AttendanceScreenId
					,GroupNoteType
					,GroupNoteDocumentCodeId
					,ServiceCount
					,DocumentSigned
					)
				EXEC scsp_SCListPageAttendance @PageNumber = @PageNumber
					,@PageSize = @PageSize
					,@SortExpression = @SortExpression
					,@Date = @Date
					,@ProgramId = @ProgramId
					,@StaffId = @StaffId
					,@GroupId = @GroupId
					,@NoteType = @NoteType
					,@OtherFilter = @OtherFilter
					,@CurrentUserId = @CurrentUserId

			END
		END
 
		IF CONVERT(VARCHAR(10), @Date, 101) <> '01/01/1900'
		BEGIN
			--28-April-2017  Gautam 
			Insert into #ServiceData (
			ServiceId,ClientId,StaffId ,ProgramId ,GroupServiceId ,CheckInTime  
			,ServiceStatus 	,CancelReason,ProcedureCodeId )		
			SELECT  s.ServiceId	,s.ClientId	,s.ClinicianId AS StaffId,s.ProgramId
				,s.GroupServiceId as ServiceGroupServiceId
				,s.DateTimeIn AS CheckInTime
				,s.status
			,s.CancelReason,s.ProcedureCodeId
			FROM Services s 
			WHERE  ISNULL(s.RecordDeleted, 'N') = 'N' 
						AND s.[Status] IN(70,71,72,73,75)
						AND CAST(s.DateOfService AS DATE) = CAST(@Date AS DATE)
						AND (ISNULL(s.ProgramId, -1) = @ProgramId OR @ProgramId = 0)
						AND (ISNULL(s.ClinicianId, -1) = @StaffId OR @StaffId = 0)
							
			;WITH CTEResultSet
			AS (
				SELECT DISTINCT s.ServiceId	
							,s.ClientId
							,CASE     -- modify by Basudev  for  network 180 task #609
						WHEN ISNULL(C.ClientType, 'I') = 'I'
						 THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')
						ELSE ISNULL(C.OrganizationName, '')
						END AS ClientName
							--,C.LastName + ', ' + C.FirstName AS ClientName
							,s.StaffId AS StaffId
							,ST.LastName + ', ' + ST.FirstName AS Staff
							,g.GroupId
							,g.GroupName
							,s.ProgramId
							,P.ProgramCode
							,L.LocationCode
							,gs.GroupServiceId
							,s.CheckInTime AS CheckInTime
							,s.ServiceStatus AS ServiceStatus
							,ISNULL(GC1.CodeName,'') AS CancelReason
							,g.AttendanceScreenId
							,g.GroupNoteType
							,g.GroupNoteDocumentCodeId
							,s.GroupServiceId as ServiceGroupServiceId
							,(SELECT COUNT(SS.ServiceId) FROM Services SS WHERE SS.ClientId = s.ClientId AND SS.GroupServiceId = s.GroupServiceId AND ISNULL(SS.RecordDeleted, 'N') = 'N') AS ServiceCount
							--22-Feb-2016    Akwinass
							,ROW_NUMBER() OVER (PARTITION BY gs.GroupServiceId,s.ClientId ORDER BY s.ServiceId ASC) AS rn
						FROM GroupServices gs
						JOIN Groups g ON g.GroupId = gs.GroupId AND ISNULL(g.RecordDeleted, 'N') = 'N' AND ISNULL(g.UsesAttendanceFunctions,'N') = 'Y' AND ISNULL(g.Active,'N') = 'Y'		
						JOIN Programs p ON p.ProgramId = gs.ProgramId AND ISNULL(p.RecordDeleted, 'N') = 'N' AND ISNULL(p.Active,'N') = 'Y'
						JOIN #ServiceData s ON s.GroupServiceId = gs.GroupServiceId 
						JOIN ProcedureCodes ON ProcedureCodes.ProcedureCodeId = s.ProcedureCodeId	
						JOIN Clients C ON s.ClientId = C.ClientId AND ISNULL(C.RecordDeleted, 'N') = 'N' AND ISNULL(C.Active,'N') = 'Y'	
						LEFT JOIN Staff ST ON s.StaffId = ST.StaffId --AND ISNULL(S.RecordDeleted, 'N') = 'N' AND ISNULL(ST.Active,'N') = 'Y'
						LEFT JOIN Locations L ON g.LocationId = L.LocationId AND ISNULL(L.RecordDeleted, 'N') = 'N'
						LEFT JOIN GlobalCodes GC1 ON GC1.GlobalCodeId = s.CancelReason AND ISNULL(GC1.RecordDeleted, 'N') = 'N'
						WHERE ((@CustomFiltersApplied = 'Y' AND EXISTS (SELECT * FROM #CustomFilters cf))
								OR (@CustomFiltersApplied = 'N'
									AND ISNULL(gs.RecordDeleted, 'N') = 'N' 
									and exists(Select 1 from StaffClients SC where C.ClientId = SC.ClientId AND SC.StaffId = @CurrentUserId)
									AND (ISNULL(g.GroupId, -1) = @GroupId OR @GroupId = 0)	
									AND (CHARINDEX(CAST(@NoteType AS VARCHAR(100)), dbo.GetNoteTypeByClientId(s.ClientId)) > 0 OR @NoteType = 0)				
									)
								)
			)			
			INSERT INTO #ResultSet (
				ServiceId
				,ClientId
				,ClientName
				,StaffId
				,Staff
				,GroupId
				,GroupName
				,ProgramId
				,ProgramCode
				,LocationCode
				,GroupServiceId
				,CheckInTime
				,ServiceStatus
				,CancelReason
				,AttendanceScreenId
				,GroupNoteType
				,GroupNoteDocumentCodeId
				,ServiceCount
				,ServiceGroupServiceId
				)
			SELECT ServiceId
				,ClientId
				,ClientName
				,StaffId
				,Staff
				,GroupId
				,GroupName
				,ProgramId
				,ProgramCode
				,LocationCode
				,GroupServiceId
				,CheckInTime
				,ServiceStatus
				,CancelReason
				,AttendanceScreenId
				,GroupNoteType
				,GroupNoteDocumentCodeId
				,ServiceCount
				,ServiceGroupServiceId
			FROM CTEResultSet
			WHERE rn = 1			
		END
		--28-April-2017  Gautam 
		Update R
		Set BannerDetails=dbo.ssf_SCGetAttendanceBannerDetails(R.ServiceId,@Date,R.AttendanceScreenId,R.GroupNoteType,R.ClientId,R.ClientName,R.GroupId,R.GroupNoteDocumentCodeId,R.GroupName,@PageNumber,@CurrentUserId) 
			,NextMedDue= dbo.ssf_SCGetAttendanceNextMedDueDetails(R.ClientId,R.ClientName, @Date) 
			,NextAppointment= dbo.ssf_SCGetAttendanceNextAppointmentDetails(R.ServiceId,R.ClientId,R.ClientName,@Date,@PageNumber)
			,DocumentSigned=dbo.ssf_SCAttendanceDocumentStatus(R.ServiceId,@Date,R.AttendanceScreenId,R.GroupNoteType,R.ClientId,R.ClientName,R.GroupId,R.GroupNoteDocumentCodeId,R.GroupName,@PageNumber,@CurrentUserId)
			,ColorCode =CASE WHEN R.ServiceStatus IN(71,75) THEN CASE WHEN dbo.ssf_GetAttendanceLastCheckOutTime(R.ServiceGroupServiceId,R.ClientId) IS NOT NULL THEN '#909090' WHEN R.CheckInTime IS NOT NULL THEN '#00a048' ELSE 'transparent' END WHEN R.ServiceStatus = 72 THEN '#ea0000' WHEN R.ServiceStatus= 73 THEN '#fffe46' ELSE 'transparent' END 
			,CheckOutTime= dbo.ssf_GetAttendanceLastCheckOutTime(R.ServiceGroupServiceId,R.ClientId) 
		From #ResultSet R
	
		;

		WITH Counts
		AS (SELECT Count(*) AS TotalRows FROM #ResultSet)
			,RankResultSet
		AS (SELECT ServiceId 
				,ClientId
				,ClientName
				,StaffId
				,Staff
				,GroupId
				,GroupName
				,ProgramId
				,ProgramCode
				,BannerDetails
				,NextMedDue
				,NextAppointment
				,LocationCode
				,ColorCode
				,GroupServiceId
				,CheckInTime
				,CheckOutTime
				,ServiceStatus
				,CancelReason
				,ServiceCount
				,DocumentSigned
				,Count(*) OVER () AS TotalCount
				,Rank() OVER (ORDER BY   CASE WHEN @SortExpression = 'GroupName' THEN GroupName END
										,CASE WHEN @SortExpression = 'GroupName DESC' THEN GroupName END DESC
										,CASE WHEN @SortExpression = 'ClientName' THEN ClientName END
										,CASE WHEN @SortExpression = 'ClientName DESC' THEN ClientName END DESC
										,CASE WHEN @SortExpression = 'CheckInTime' THEN CheckInTime END
										,CASE WHEN @SortExpression = 'CheckInTime DESC' THEN CheckInTime END DESC
										,CASE WHEN @SortExpression = 'CheckOutTime' THEN CheckOutTime END
										,CASE WHEN @SortExpression = 'CheckOutTime DESC' THEN CheckOutTime END DESC										
										,CASE WHEN @SortExpression = 'NextMedDue' THEN CAST(NextMedDue AS DATETIME) END
										,CASE WHEN @SortExpression = 'NextMedDue DESC' THEN CAST(NextMedDue AS DATETIME) END DESC
										,CASE WHEN @SortExpression = 'NextAppointment' THEN CAST(dbo.ssf_SCGetAttendanceNextAppointmentDetails(ServiceId,ClientId,ClientName,@Date,-1) AS DATETIME) END
										,CASE WHEN @SortExpression = 'NextAppointment DESC' THEN CAST(dbo.ssf_SCGetAttendanceNextAppointmentDetails(ServiceId,ClientId,ClientName,@Date,-1) AS DATETIME) END DESC
										,CASE WHEN @SortExpression = 'DocumentationScreen' THEN dbo.ssf_SCGetAttendanceBannerDetails(ServiceId,@Date,AttendanceScreenId,GroupNoteType,ClientId,ClientName,GroupId,GroupNoteDocumentCodeId,GroupName,-1,@CurrentUserId) END
										,CASE WHEN @SortExpression = 'DocumentationScreen DESC' THEN dbo.ssf_SCGetAttendanceBannerDetails(ServiceId,@Date,AttendanceScreenId,GroupNoteType,ClientId,ClientName,GroupId,GroupNoteDocumentCodeId,GroupName,-1,@CurrentUserId) END DESC
										,CASE WHEN @SortExpression = 'Staff' THEN Staff END
										,CASE WHEN @SortExpression = 'Staff DESC' THEN Staff END DESC
										,CASE WHEN @SortExpression = 'GroupName' THEN GroupName END
										,CASE WHEN @SortExpression = 'GroupName DESC' THEN GroupName END DESC
										,CASE WHEN @SortExpression = 'ProgramCode' THEN ProgramCode END
										,CASE WHEN @SortExpression = 'ProgramCode DESC' THEN ProgramCode END DESC
										,CASE WHEN @SortExpression = 'Flags' THEN (SELECT dbo.GetNoteTypeByClientId(ClientId)) END
										,CASE WHEN @SortExpression = 'Flags desc' THEN (SELECT dbo.GetNoteTypeByClientId(ClientId))	END DESC
					,ServiceId) AS RowNumber
			FROM #ResultSet
			)
		SELECT TOP (CASE WHEN (@PageNumber = - 1)THEN (SELECT Isnull(TotalRows, 0) FROM Counts)ELSE (@PageSize)END) ClientId
			,ClientName
			,StaffId
			,Staff
			,GroupId
			,GroupName
			,ProgramId
			,ProgramCode
			,BannerDetails
			,NextMedDue
			,NextAppointment
			,LocationCode
			,ColorCode
			,GroupServiceId
			,CheckInTime
			,CheckOutTime
			,ServiceStatus
			,CancelReason
			,ServiceCount
			,DocumentSigned
			,ServiceId
			,TotalCount
			,RowNumber
		INTO #FinalResultSet
		FROM RankResultSet
		WHERE RowNumber > ((@PageNumber - 1) * @PageSize)
		
		IF @PageSize=0 OR @PageSize=-1
		BEGIN
			SELECT @PageSize=COUNT(*) FROM #FinalResultSet
		END
		
		IF (SELECT Isnull(Count(*), 0) FROM #FinalResultSet) < 1
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
						THEN Isnull((Totalcount / @PageSize), 0)
					ELSE Isnull((Totalcount / @PageSize), 0) + 1
					END AS NumberOfPages
				,Isnull(Totalcount, 0) AS NumberofRows
			FROM #FinalResultSet
		END

		SELECT ServiceId
			,ClientId
			,ClientName
			,CASE WHEN CheckInTime IS NOT NULL THEN LTRIM(RIGHT(CONVERT(VARCHAR(20), convert(DATETIME, CheckInTime), 100), 7)) ELSE NULL END CheckInTime
			,CASE WHEN CheckOutTime IS NOT NULL THEN LTRIM(RIGHT(CONVERT(VARCHAR(20), convert(DATETIME, CheckOutTime), 100), 7)) ELSE NULL END CheckOutTime
			,BannerDetails
			,CASE WHEN NextMedDue IS NOT NULL THEN LTRIM(RIGHT(CONVERT(VARCHAR(20), convert(DATETIME, NextMedDue), 100), 7)) ELSE NULL END NextMedDue
			,NextAppointment			
			,Staff
			,GroupName
			,ProgramCode
			,StaffId
			,GroupId			
			,ProgramId					
			,LocationCode
			,ColorCode
			,GroupServiceId			
			,ServiceStatus
			,CancelReason
			,ServiceCount			
			,(SELECT dbo.GetNoteTypeByClientId(ClientId)) AS TypeId
			,DocumentSigned
		FROM #FinalResultSet
		ORDER BY RowNumber
	END TRY

      BEGIN CATCH
          DECLARE @error VARCHAR(8000)

          SET @error= CONVERT(VARCHAR, Error_number()) + '*****'
                      + CONVERT(VARCHAR(4000), Error_message())
                      + '*****'
                      + Isnull(CONVERT(VARCHAR, Error_procedure()),
                      'ssp_SCGetListPageAttendance')
                      + '*****' + CONVERT(VARCHAR, Error_line())
                      + '*****' + CONVERT(VARCHAR, Error_severity())
                      + '*****' + CONVERT(VARCHAR, Error_state())

          RAISERROR (@error,-- Message text.
                     16,-- Severity.
                     1 -- State.
          );
      END CATCH
  END 