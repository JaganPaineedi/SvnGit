/****** Object:  StoredProcedure [dbo].[ssp_SCGetAttendanceAssignmentDetailsUsingId]    Script Date: 03/12/2015 18:17:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetAttendanceAssignmentDetailsUsingId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetAttendanceAssignmentDetailsUsingId]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetAttendanceAssignmentDetailsUsingId]    Script Date: 03/12/2015 18:17:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetAttendanceAssignmentDetailsUsingId]
@AttendanceAssignmentId INT
AS
/****************************************************************************/
/* Stored Procedure: ssp_SCGetAttendanceAssignmentDetailsUsingId            */
/* Copyright: 2006 Streamline Healthcare Solutions                           */
/* Author: Akwinass                                                         */
/* Creation Date:  April 29,2015                                            */
/* Purpose: To Get Specific Attendance Assignment Record                    */
/* Input Parameters:@AttendanceAssignmentId                                 */
/* Output Parameters:None                                                   */
/* Return:                                                                  */
/* Calls:                                                                   */
/* Called From:                                                             */
/* Data Modifications:                                                      */
/*                                                                          */
/*-------------Modification History--------------------------               */
/*-------Date-----------Author------------Purpose---------------------------*/
/*       29-APRIL-2015  Akwinass          Created(Task #829 in Woods - Customizations).*/
/****************************************************************************/
BEGIN
	BEGIN TRY
		SELECT s.ServiceId AS AttendanceAssignmentId
			,s.CreatedBy
			,s.CreatedDate
			,s.ModifiedBy
			,s.ModifiedDate
			,s.ClientId
			,C.LastName + ', ' + C.FirstName AS ClientName
			,g.GroupId
			,G.GroupName
			,s.ProgramId
			,P.ProgramCode
			,s.ClinicianId AS StaffId
			,ST.LastName + ', ' + ST.FirstName AS StaffName
			,'Y' AS IsSaved
			,s.DateOfService AS AssignmentDate
			,s.DateOfService AS StartDateTime
			,s.EndDateOfService AS EndDateTime
			,s.GroupServiceId
			,g.GroupId AS CurrentGroupId
		FROM GroupServices gs
		JOIN Groups g ON g.GroupId = gs.GroupId AND ISNULL(g.RecordDeleted, 'N') = 'N' AND ISNULL(g.UsesAttendanceFunctions,'N') = 'Y' AND ISNULL(g.Active,'N') = 'Y'		
		JOIN Programs p ON p.ProgramId = gs.ProgramId AND ISNULL(p.RecordDeleted, 'N') = 'N' AND ISNULL(p.Active,'N') = 'Y'
		JOIN Services s ON s.GroupServiceId = gs.GroupServiceId AND ISNULL(s.RecordDeleted, 'N') = 'N'
		JOIN ProcedureCodes ON ProcedureCodes.ProcedureCodeId = s.ProcedureCodeId	
		JOIN Clients C ON s.ClientId = C.ClientId AND ISNULL(C.RecordDeleted, 'N') = 'N' AND ISNULL(C.Active,'N') = 'Y'	
		LEFT JOIN Staff ST ON s.ClinicianId = ST.StaffId AND ISNULL(S.RecordDeleted, 'N') = 'N' AND ISNULL(ST.Active,'N') = 'Y'
		WHERE ISNULL(gs.RecordDeleted, 'N') = 'N' AND s.ServiceId = @AttendanceAssignmentId
					
		SELECT [ServiceId]
			,[CreatedBy]
			,[CreatedDate]
			,[ModifiedBy]
			,[ModifiedDate]
			,[RecordDeleted]
			,[DeletedDate]
			,[DeletedBy]
			,[ClientId]
			,[GroupServiceId]
			,[ProcedureCodeId]
			,[DateOfService]
			,[EndDateOfService]
			,[RecurringService]
			,[Unit]
			,[UnitType]
			,[Status]
			,[CancelReason]
			,[ProviderId]
			,[ClinicianId]
			,[AttendingId]
			,[ProgramId]
			,[LocationId]
			,[Billable]
			,[ClientWasPresent]
			,[OtherPersonsPresent]
			,[AuthorizationsApproved]
			,[AuthorizationsNeeded]
			,[AuthorizationsRequested]
			,[Charge]
			,[NumberOfTimeRescheduled]
			,[NumberOfTimesCancelled]
			,[ProcedureRateId]
			,[DoNotComplete]
			,[Comment]
			,[Flag1]
			,[OverrideError]
			,[OverrideBy]
			,[ReferringId]
			,[DateTimeIn]
			,[DateTimeOut]
			,[NoteAuthorId]
			,[ModifierId1]
			,[ModifierId2]
			,[ModifierId3]
			,[ModifierId4]
			,[PlaceOfServiceId]
			,[SpecificLocation]
		FROM [Services]
		WHERE ISNULL(RecordDeleted, 'N') = 'N' AND ServiceId = @AttendanceAssignmentId
	END TRY

	BEGIN CATCH
		IF (@@error != 0)
		BEGIN
			RAISERROR 20006 'ssp_SCGetAttendanceAssignmentDetailsUsingId: An Error Occured'

			RETURN
		END
	END CATCH
END

GO