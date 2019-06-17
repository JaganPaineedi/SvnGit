/****** Object:  StoredProcedure [dbo].[ssp_SCDeleteGroupServiceRecurrence]    Script Date: 07/25/2016 14:55:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCDeleteGroupServiceRecurrence]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCDeleteGroupServiceRecurrence]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCDeleteGroupServiceRecurrence]    Script Date: 07/25/2016 14:55:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[ssp_SCDeleteGroupServiceRecurrence] @GroupServiceId INT
	,@UserCode VARCHAR(30)
	,@Mode VARCHAR(30)
AS
/****************************************************************************/
/* Stored Procedure: ssp_SCDeleteGroupServiceRecurrence                     */
/* Copyright: 2006 Streamlin Healthcare Solutions                           */
/* Author: Akwinass                                                         */
/* Creation Date:  25 July 2016												*/
/* Purpose: To Delete Recurrence of Group Service                           */
/* Input Parameters:@GroupServiceId,@UserCode,@Mode                         */
/* Output Parameters:None                                                   */
/* Return:                                                                  */
/* Calls:                                                                   */
/* Called From:                                                             */
/* Data Modifications:                                                      */
/*                                                                          */
/*-------------Modification History--------------------------               */
/*-------Date-----------Author------------Purpose---------------------------*/
/*       25 July 2016	Akwinass		  Created(Task #377 in Engineering Improvement Initiatives- NBL(I)).*/
/****************************************************************************/
BEGIN
	BEGIN TRY		
		DECLARE @RecurringGroupServiceId INT = 0
		DECLARE @DateOfService DATETIME
		DECLARE @AppointmentStartDate DATETIME
		DECLARE @RecurrenceStartDate DATETIME
		DECLARE @EndDate DATETIME
		
		IF OBJECT_ID('tempdb..#GroupServiceAppointments') IS NOT NULL
			DROP TABLE #GroupServiceAppointments
		CREATE TABLE #GroupServiceAppointments (AppointmentId INT,GroupServiceId INT, StartTime DATETIME) 
		
		IF OBJECT_ID('tempdb..#RecurringAppointments') IS NOT NULL
			DROP TABLE #RecurringAppointments
		CREATE TABLE #RecurringAppointments (AppointmentId INT,GroupServiceId INT, StartTime DATETIME, EndTime DATETIME) 
		
		SELECT TOP 1 @DateOfService = DateOfService
		FROM GroupServices GS
		WHERE GS.GroupServiceId = @GroupServiceId
			AND ISNULL(GS.RecordDeleted, 'N') = 'N'

		SELECT TOP 1 @RecurringGroupServiceId = RecurringGroupServiceId
		FROM RecurringGroupServicesProcessLog
		WHERE ISNULL(RecordDeleted, 'N') = 'N'
			AND GroupServiceId = @GroupServiceId
			
		SELECT TOP 1 @RecurrenceStartDate = RecurrenceStartDate
		FROM RecurringGroupServices
		WHERE ISNULL(RecordDeleted, 'N') = 'N'
			AND RecurringGroupServiceId = @RecurringGroupServiceId

		IF ISNULL(@Mode,'') = 'FUTURE'
		BEGIN
			INSERT INTO #GroupServiceAppointments(AppointmentId,GroupServiceId,StartTime)
			SELECT DISTINCT Appointments.AppointmentId,Appointments.GroupServiceId,Appointments.StartTime
			FROM dbo.Appointments 
			JOIN dbo.RecurringGroupServicesProcessLog AS RGSPL ON RGSPL.RecurringGroupServiceId = dbo.Appointments.RecurringGroupServiceId
			INNER JOIN dbo.RecurringGroupServices AS RGS ON RGSPL.RecurringGroupServiceId = RGS.RecurringGroupServiceId
			WHERE (ISNULL(RGSPL.RecordDeleted, 'N') = 'N')
				AND (ISNULL(RGS.RecordDeleted, 'N') = 'N')
				AND (ISNULL(Appointments.RecordDeleted, 'N') = 'N')
				AND (RGS.RecurringGroupServiceId = @RecurringGroupServiceId)			
				AND (ISNULL(RGSPL.GroupServiceId, 0) <> 0)
				AND Appointments.AppointmentType = 4763
				AND Appointments.StartTime > @DateOfService
		END
			
		DELETE
		FROM #GroupServiceAppointments
		WHERE GroupServiceId = @GroupServiceId
		
		SELECT TOP 1 @AppointmentStartDate = StartTime
		FROM #GroupServiceAppointments
		ORDER BY StartTime ASC		
		
		IF @AppointmentStartDate IS NOT NULL AND @RecurrenceStartDate IS NOT NULL
		BEGIN
			IF CAST(@AppointmentStartDate AS DATE) <> CAST(@RecurrenceStartDate AS DATE) AND ISNULL(@Mode,'') = 'FUTURE'
			BEGIN						
				INSERT INTO #RecurringAppointments(AppointmentId,GroupServiceId,StartTime,EndTime)
				SELECT DISTINCT Appointments.AppointmentId,Appointments.GroupServiceId,Appointments.StartTime,Appointments.EndTime
				FROM dbo.Appointments 
				JOIN dbo.RecurringGroupServicesProcessLog AS RGSPL ON RGSPL.RecurringGroupServiceId = dbo.Appointments.RecurringGroupServiceId
				INNER JOIN dbo.RecurringGroupServices AS RGS ON RGSPL.RecurringGroupServiceId = RGS.RecurringGroupServiceId
				WHERE (ISNULL(RGSPL.RecordDeleted, 'N') = 'N')
					AND (ISNULL(RGS.RecordDeleted, 'N') = 'N')
					AND (ISNULL(Appointments.RecordDeleted, 'N') = 'N')
					AND (RGS.RecurringGroupServiceId = @RecurringGroupServiceId)			
					AND (ISNULL(RGSPL.GroupServiceId, 0) <> 0)
					AND Appointments.AppointmentType = 4763
					AND Appointments.StartTime < @DateOfService
					AND NOT EXISTS(SELECT 1 FROM #GroupServiceAppointments TSA WHERE TSA.AppointmentId = Appointments.AppointmentId)
				ORDER BY Appointments.StartTime ASC
						
				SELECT TOP 1 @EndDate = EndTime
				FROM #RecurringAppointments
				ORDER BY EndTime DESC				
			END
		END
		
		IF OBJECT_ID('tempdb..#GroupServiceIds') IS NOT NULL
			DROP TABLE #GroupServiceIds
		CREATE TABLE #GroupServiceIds (GroupServiceId INT)
		
		IF ISNULL(@Mode,'') = 'FUTURE'
		BEGIN
			INSERT INTO #GroupServiceIds(GroupServiceId)
			SELECT DISTINCT GS.GroupServiceId
			FROM GroupServices GS
			JOIN #GroupServiceAppointments GSA ON GS.GroupServiceId = GSA.GroupServiceId
			WHERE ISNULL(GS.RecordDeleted, 'N') = 'N'
				AND GSA.GroupServiceId IS NOT NULL
				AND NOT EXISTS (
					SELECT 1
					FROM Services S
					LEFT JOIN Documents D ON S.ServiceId = D.ServiceId AND ISNULL(D.RecordDeleted, 'N') = 'N'
					WHERE S.GroupServiceId = GS.GroupServiceId
						AND ISNULL(S.RecordDeleted, 'N') = 'N'
						AND S.[Status] = 75
						AND (D.[Status] = 22 OR D.[Status] IS NULL)
					)
			
			UPDATE A
			SET A.RecordDeleted = 'Y'
				,A.DeletedBy = @UserCode
				,A.DeletedDate = GETDATE()
			FROM Appointments A
			JOIN #GroupServiceAppointments GSA ON A.AppointmentId = GSA.AppointmentId
				AND ISNULL(RecordDeleted, 'N') = 'N'
				AND GSA.GroupServiceId IS NULL
				AND A.RecurringGroupServiceId = @RecurringGroupServiceId		
					
			UPDATE A
			SET A.RecordDeleted = 'Y'
				,A.DeletedBy = @UserCode
				,A.DeletedDate = GETDATE()
			FROM Appointments A
			JOIN #GroupServiceIds GS ON A.GroupServiceId = GS.GroupServiceId
			JOIN #GroupServiceAppointments GSA ON A.AppointmentId = GSA.AppointmentId
				AND ISNULL(RecordDeleted, 'N') = 'N'
				AND GSA.GroupServiceId IS NOT NULL
				AND A.RecurringGroupServiceId = @RecurringGroupServiceId
					
			UPDATE DV
			SET DV.RecordDeleted = 'Y'
				,DV.DeletedBy = @UserCode
				,DV.DeletedDate = GETDATE()
			FROM DocumentVersions DV
			JOIN Documents D ON DV.DocumentVersionId = D.CurrentDocumentVersionId
			JOIN Services S ON D.ServiceId = S.ServiceId
			JOIN GroupServices GS ON S.GroupServiceId = GS.GroupServiceId
			JOIN #GroupServiceIds TGS ON GS.GroupServiceId = TGS.GroupServiceId
			WHERE ISNULL(DV.RecordDeleted, 'N') = 'N'
				AND ISNULL(D.RecordDeleted, 'N') = 'N'
				AND ISNULL(S.RecordDeleted, 'N') = 'N'
				AND ISNULL(GS.RecordDeleted, 'N') = 'N'

			UPDATE D
			SET D.RecordDeleted = 'Y'
				,D.DeletedBy = @UserCode
				,D.DeletedDate = GETDATE()
			FROM Documents D
			JOIN Services S ON D.ServiceId = S.ServiceId
			JOIN GroupServices GS ON S.GroupServiceId = GS.GroupServiceId
			JOIN #GroupServiceIds TGS ON GS.GroupServiceId = TGS.GroupServiceId
			WHERE ISNULL(D.RecordDeleted, 'N') = 'N'
				AND ISNULL(S.RecordDeleted, 'N') = 'N'
				AND ISNULL(GS.RecordDeleted, 'N') = 'N'

			UPDATE S
			SET S.RecordDeleted = 'Y'
				,S.DeletedBy = @UserCode
				,S.DeletedDate = GETDATE()
			FROM Services S
			JOIN GroupServices GS ON S.GroupServiceId = GS.GroupServiceId
			JOIN #GroupServiceIds TGS ON GS.GroupServiceId = TGS.GroupServiceId
			WHERE ISNULL(S.RecordDeleted, 'N') = 'N'
				AND ISNULL(GS.RecordDeleted, 'N') = 'N'

			UPDATE GS
			SET GS.RecordDeleted = 'Y'
				,GS.DeletedBy = @UserCode
				,GS.DeletedDate = GETDATE()
			FROM GroupServices GS
			JOIN #GroupServiceIds TGS ON GS.GroupServiceId = TGS.GroupServiceId
			WHERE ISNULL(GS.RecordDeleted, 'N') = 'N'
		END
		
		IF ISNULL(@Mode,'') = 'THIS'			
		BEGIN			
			INSERT INTO #RecurringAppointments(AppointmentId,GroupServiceId,StartTime,EndTime)
			SELECT DISTINCT Appointments.AppointmentId,Appointments.GroupServiceId,Appointments.StartTime,Appointments.EndTime
			FROM dbo.Appointments 
			JOIN dbo.RecurringGroupServicesProcessLog AS RGSPL ON RGSPL.RecurringGroupServiceId = dbo.Appointments.RecurringGroupServiceId
			INNER JOIN dbo.RecurringGroupServices AS RGS ON RGSPL.RecurringGroupServiceId = RGS.RecurringGroupServiceId
			WHERE (ISNULL(RGSPL.RecordDeleted, 'N') = 'N')
				AND (ISNULL(RGS.RecordDeleted, 'N') = 'N')
				AND ISNULL(RGS.Processed, 'N') = 'Y'
				AND (ISNULL(Appointments.RecordDeleted, 'N') = 'N')
				AND (RGS.RecurringGroupServiceId = @RecurringGroupServiceId)			
				AND (ISNULL(RGSPL.GroupServiceId, 0) <> 0)
				AND (ISNULL(Appointments.GroupServiceId, 0) <> @GroupServiceId)
				AND EXISTS(SELECT 1 FROM GroupServices GS WHERE GS.GroupServiceId = Appointments.GroupServiceId AND ISNULL(RecordDeleted,'N') = 'N')
				AND Appointments.AppointmentType = 4763
			ORDER BY Appointments.StartTime ASC			
			
			SELECT TOP 1 @EndDate = EndTime
			FROM #RecurringAppointments
			ORDER BY EndTime DESC
		END
		
		IF @EndDate IS NOT NULL AND @RecurrenceStartDate IS NOT NULL
		BEGIN
			IF @EndDate > @RecurrenceStartDate
			BEGIN
				UPDATE RecurringGroupServices
				SET EndDate = @EndDate
					,ModifiedBy = @UserCode
					,ModifiedDate = GETDATE()
				WHERE RecurringGroupServiceId = @RecurringGroupServiceId
					AND ISNULL(RecordDeleted, 'N') = 'N'
			END
		END		
			
		IF CAST(@AppointmentStartDate AS DATE) = CAST(@RecurrenceStartDate AS DATE) AND ISNULL(@Mode,'') = 'FUTURE'
		BEGIN
			UPDATE RecurringGroupServicesProcessLog
			SET RecordDeleted = 'Y'
				,DeletedBy = @UserCode
				,DeletedDate = GETDATE()
			WHERE RecurringGroupServiceId = @RecurringGroupServiceId
				AND ISNULL(RecordDeleted, 'N') = 'N'

			UPDATE RecurringGroupServicesUnprocessed
			SET RecordDeleted = 'Y'
				,DeletedBy = @UserCode
				,DeletedDate = GETDATE()
			WHERE RecurringGroupServiceId = @RecurringGroupServiceId
				AND ISNULL(RecordDeleted, 'N') = 'N'

			UPDATE RecurringGroupServiceStaff
			SET RecordDeleted = 'Y'
				,DeletedBy = @UserCode
				,DeletedDate = GETDATE()
			WHERE RecurringGroupServiceId = @RecurringGroupServiceId
				AND ISNULL(RecordDeleted, 'N') = 'N'

			UPDATE RecurringGroupServices
			SET RecordDeleted = 'Y'
				,DeletedBy = @UserCode
				,DeletedDate = GETDATE()
				,Processed = 'Y'
			WHERE RecurringGroupServiceId = @RecurringGroupServiceId
				AND ISNULL(RecordDeleted, 'N') = 'N'
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCDeleteGroupServiceRecurrence') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


