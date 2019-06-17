 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ssp_SCManageAttendanceStatus')
	BEGIN
		DROP  Procedure  ssp_SCManageAttendanceStatus
	END
GO
    
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCManageAttendanceStatus] (
	@ServiceId INT
	,@StaffId INT
	,@GroupId INT
	,@ClientId INT
	,@AttendanceDate DATETIME
	,@CheckInTime VARCHAR(20)
	,@Mode VARCHAR(20)
	,@UserCode VARCHAR(30)
	,@CancelReason INT
	)

/********************************************************************************                                                 
** Stored Procedure: ssp_SCManageAttendanceStatus                                                    
**                                                  
** Copyright: Streamline Healthcate Solutions                                                    
** Updates:                                                                                                         
** Date            Author              Purpose   
** 11-MAY-2015	   Akwinass			   What:Manage Attendance Status      
**									   Why:Task #829 in Woods - Customizations 
** 17-FEB-2016	   Akwinass			   What:Managed Attendance To Do Documents      
**									   Why:Task #167 in Valley - Support Go Live
** 22-Feb-2016	   Akwinass	           What:Included ssp_SCManageAttendanceToDoDocuments, To create To Do document for the Associated Attendance Group Service.          
**							           Why:task #167 Valley - Support Go Live 
** 22-Feb-2016	   Akwinass	           What:Included Select Query To Manage Document Link on Check_In.          
**							           Why:task #167 Valley - Support Go Live
** 04-MAR-2016	   Akwinass	           What:Included @ServiceId in ssf_SCGetAttendanceBannerDetails
**							           Why:task #17 Woods - Support Go Live   
** 13-APRIL-2016  Akwinass	           What:Included GroupNoteType Column.          
**							           Why:task #167.1 Valley - Support Go Live 
** 15-APRIL-2016  Akwinass	           What:Included "Complete" Services.          
							           Why:task #207 Valley - Support Go Live
*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		DECLARE @AttendanceStatus INT
		
		IF @Mode = 'Checked In'
		BEGIN
			SELECT TOP 1 @AttendanceStatus = GlobalCodeId
			FROM GlobalCodes
			WHERE Category = 'SERVICESTATUS'
				AND CodeName = 'Show'
				AND ISNULL(RecordDeleted, 'N') = 'N'

			
			IF EXISTS (SELECT ServiceId FROM Services WHERE ServiceId = @ServiceId AND ISNULL(RecordDeleted, 'N') = 'N')				
			BEGIN				
				UPDATE Services
				SET ModifiedBy = @UserCode
					,ModifiedDate = GETDATE()
					,[Status] = @AttendanceStatus
					,DateTimeIn = CAST(@AttendanceDate + ' ' + @CheckInTime AS DATETIME)
				WHERE ServiceId = @ServiceId
					AND ISNULL(RecordDeleted, 'N') = 'N'					
				
				SELECT TOP 1 @ClientId = ClientId FROM Services WHERE ServiceId = @ServiceId AND ISNULL(RecordDeleted, 'N') = 'N'
				EXEC ssp_SCManageAttendanceToDoDocuments @ServiceId,NULL,@UserCode,@ClientId				
			END			
		END
		ELSE IF @Mode = 'No Show'
		BEGIN
			SELECT TOP 1 @AttendanceStatus = GlobalCodeId
			FROM GlobalCodes
			WHERE Category = 'SERVICESTATUS'
				AND CodeName = 'No Show'
				AND ISNULL(RecordDeleted, 'N') = 'N'
				
			IF EXISTS (SELECT ServiceId FROM Services WHERE ServiceId = @ServiceId AND ISNULL(RecordDeleted, 'N') = 'N')				
			BEGIN				
				UPDATE Services
				SET ModifiedBy = @UserCode
					,ModifiedDate = GETDATE()
					,[Status] = @AttendanceStatus
					,DateTimeIn = NULL
				WHERE ServiceId = @ServiceId
					AND ISNULL(RecordDeleted, 'N') = 'N'
			END
		END
		ELSE IF @Mode = 'Cancel'
		BEGIN
			SELECT TOP 1 @AttendanceStatus = GlobalCodeId
			FROM GlobalCodes
			WHERE Category = 'SERVICESTATUS'
				AND CodeName = 'Cancel'
				AND ISNULL(RecordDeleted, 'N') = 'N'
				
			IF EXISTS (SELECT ServiceId FROM Services WHERE ServiceId = @ServiceId AND ISNULL(RecordDeleted, 'N') = 'N')				
			BEGIN				
				UPDATE Services
				SET ModifiedBy = @UserCode
					,ModifiedDate = GETDATE()
					,[Status] = @AttendanceStatus
					,DateTimeIn = NULL
					,CancelReason = @CancelReason
				WHERE ServiceId = @ServiceId
					AND ISNULL(RecordDeleted, 'N') = 'N'
			END
		END
		
		DECLARE @CurrentUserId INT
		SELECT TOP 1 @CurrentUserId = StaffId FROM Staff WHERE UserCode = @UserCode
		
		SELECT DISTINCT s.ServiceId
			,s.ClientId
			,dbo.ssf_SCGetAttendanceBannerDetails(@ServiceId,s.DateOfService, g.AttendanceScreenId, g.GroupNoteType, s.ClientId, C.LastName + ', ' + C.FirstName, g.GroupId, g.GroupNoteDocumentCodeId, g.GroupName, 0, @CurrentUserId) AS BannerDetails
		FROM GroupServices gs
		JOIN Groups g ON g.GroupId = gs.GroupId AND ISNULL(g.RecordDeleted, 'N') = 'N' AND ISNULL(g.UsesAttendanceFunctions, 'N') = 'Y' AND ISNULL(g.Active, 'N') = 'Y'
		JOIN Programs p ON p.ProgramId = gs.ProgramId AND ISNULL(p.RecordDeleted, 'N') = 'N' AND ISNULL(p.Active, 'N') = 'Y'
		JOIN Services s ON s.GroupServiceId = gs.GroupServiceId AND ISNULL(s.RecordDeleted, 'N') = 'N' 
		JOIN Clients C ON s.ClientId = C.ClientId AND ISNULL(C.RecordDeleted, 'N') = 'N' AND ISNULL(C.Active, 'N') = 'Y'
		JOIN StaffClients SC ON C.ClientId = SC.ClientId AND SC.StaffId = @CurrentUserId
		WHERE ISNULL(gs.RecordDeleted, 'N') = 'N'
			AND s.[Status] IN (70,71,72,73,75)
			AND s.ServiceId = @ServiceId
	END TRY

      BEGIN CATCH
          DECLARE @error VARCHAR(8000)

          SET @error= CONVERT(VARCHAR, Error_number()) + '*****'
                      + CONVERT(VARCHAR(4000), Error_message())
                      + '*****'
                      + Isnull(CONVERT(VARCHAR, Error_procedure()),
                      'ssp_SCManageAttendanceStatus')
                      + '*****' + CONVERT(VARCHAR, Error_line())
                      + '*****' + CONVERT(VARCHAR, Error_severity())
                      + '*****' + CONVERT(VARCHAR, Error_state())

          RAISERROR (@error,-- Message text.
                     16,-- Severity.
                     1 -- State.
          );
      END CATCH
  END 