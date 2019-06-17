/****** Object:  StoredProcedure [dbo].[ssp_SCCheckAttendanceScheduledAlready]    Script Date: 03/12/2015 18:17:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCCheckAttendanceScheduledAlready]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCCheckAttendanceScheduledAlready]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCCheckAttendanceScheduledAlready]    Script Date: 03/12/2015 18:17:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCCheckAttendanceScheduledAlready]
@AttendanceAssignments XML
AS
/****************************************************************************/
/* Stored Procedure: ssp_SCCheckAttendanceScheduledAlready                  */
/* Copyright: 2006 Streamline Healthcare Solutions                           */
/* Author: Akwinass                                                         */
/* Creation Date:  April 29,2015                                            */
/* Purpose: To check if the client is already scheduled for the day         */
/* Input Parameters:@AttendanceAssignments                                  */
/* Output Parameters:None                                                   */
/* Data Modifications:                                                      */
/*                                                                          */
/*-------------Modification History--------------------------               */
/*-------Date-----------Author------------Purpose---------------------------*/
/*       29-MAY-2015  Akwinass          Created(Task #829 in Woods - Customizations).*/
/****************************************************************************/
BEGIN
	BEGIN TRY
		IF OBJECT_ID('tempdb..#AttendanceChangeServices') IS NOT NULL
				DROP TABLE #AttendanceChangeServices
		
		CREATE TABLE #AttendanceChangeServices (
				ServiceId INT
				,GroupId INT
				,ClientId INT				
				,ProgramId INT				
				,StaffId INT
				,AssignmentDate DATETIME
				,StartDateTime DATETIME
				,EndDateTime DATETIME
				,GroupServiceId INT
				)	
				
		INSERT INTO #AttendanceChangeServices(ServiceId,GroupId,ClientId,ProgramId,StaffId,AssignmentDate,StartDateTime,EndDateTime,GroupServiceId)	
		SELECT a.b.value('AttendanceAssignmentId[1]', 'INT')
			,a.b.value('GroupId[1]', 'INT')
			,a.b.value('ClientId[1]', 'INT')
			,a.b.value('ProgramId[1]', 'INT')
			,a.b.value('StaffId[1]', 'INT')				
			,a.b.value('xs:dateTime(AssignmentDate[1])', 'DATETIME')
			,a.b.value('xs:dateTime(StartDateTime[1])', 'DATETIME')
			,a.b.value('xs:dateTime(EndDateTime[1])', 'DATETIME')
			,a.b.value('GroupServiceId[1]', 'INT')
		FROM @AttendanceAssignments.nodes('NewDataSet/Services') a(b)		
		
		IF OBJECT_ID('tempdb..#AttendanceGroupServices') IS NOT NULL
				DROP TABLE #AttendanceGroupServices
						
		CREATE TABLE #AttendanceGroupServices (
				ServiceId INT
				,GroupId INT
				,ClientId INT				
				,ProgramId INT				
				,StaffId INT
				,AssignmentDate DATETIME
				,StartDateTime DATETIME
				,EndDateTime DATETIME
				)
		
		INSERT INTO #AttendanceGroupServices(GroupId,ClientId,ProgramId,StaffId,AssignmentDate,StartDateTime,EndDateTime)			
		SELECT a.b.value('GroupId[1]', 'INT')
			,a.b.value('ClientId[1]', 'INT')
			,a.b.value('ProgramId[1]', 'INT')
			,a.b.value('StaffId[1]', 'INT')				
			,a.b.value('xs:dateTime(AssignmentDate[1])', 'DATETIME')
			,a.b.value('xs:dateTime(StartDateTime[1])', 'DATETIME')
			,a.b.value('xs:dateTime(EndDateTime[1])', 'DATETIME')
		FROM @AttendanceAssignments.nodes('NewDataSet/AttendanceAssignments') a(b)
		
		INSERT INTO #AttendanceGroupServices(ServiceId,GroupId,ClientId,ProgramId,StaffId,AssignmentDate,StartDateTime,EndDateTime)
		SELECT ACS.ServiceId
			,ACS.GroupId
			,ACS.ClientId
			,ACS.ProgramId
			,ACS.StaffId
			,ACS.AssignmentDate
			,ACS.StartDateTime
			,ACS.EndDateTime
		FROM #AttendanceChangeServices ACS
		WHERE NOT EXISTS (
				SELECT 1
				FROM #AttendanceGroupServices ACG
				WHERE ACG.GroupId = ACS.GroupId
				)		
		
		SELECT DISTINCT C.LastName + ', ' + C.FirstName AS ClientName
		FROM Services S
		JOIN #AttendanceGroupServices AGS ON S.ClientId = AGS.ClientId AND CAST(CONVERT(VARCHAR(10), S.DateOfService, 101) AS DATETIME) = CAST(CONVERT(VARCHAR(10), AGS.AssignmentDate, 101) AS DATETIME)
		JOIN Clients C ON S.ClientId = C.ClientId AND ISNULL(C.Active,'N') = 'Y'
		WHERE S.[Status] IN (70,71,75)
			AND ISNULL(S.RecordDeleted, 'N') = 'N'
			AND ISNULL(S.GroupServiceId, 0) > 0
			AND ISNULL(C.RecordDeleted, 'N') = 'N'
		
		IF OBJECT_ID('tempdb..#AttendanceChangeServices') IS NOT NULL
				DROP TABLE #AttendanceChangeServices
				
		IF OBJECT_ID('tempdb..#AttendanceGroupServices') IS NOT NULL
				DROP TABLE #AttendanceGroupServices
	END TRY

	BEGIN CATCH
		IF (@@error != 0)
		BEGIN
			RAISERROR 20006 'ssp_SCCheckAttendanceScheduledAlready: An Error Occured'

			RETURN
		END
	END CATCH
END

GO


