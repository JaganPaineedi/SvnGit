
IF EXISTS (
		SELECT *
		FROM SYS.objects
		WHERE object_id = Object_id(N'[dbo].[csp_SCPostUpdateIncidentReport]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_SCPostUpdateIncidentReport]
GO

CREATE PROCEDURE [dbo].[csp_SCPostUpdateIncidentReport] --352, 550,'ADMIN', ''                        
	(
	@ScreenKeyId INT
	,@StaffId INT
	,@CurrentUser VARCHAR(30)
	,@CustomParameters XML
	)
AS
/*********************************************************************/
/* Stored Procedure: [csp_SCPostUpdateIncidentReport]               */
/* Creation Date:  08 May 2015                                    */
/* Author:  Vamsi                     */
/* Purpose: To update data after sign */
/* Data Modifications:                   */
/*  Modified By    Modified Date    Purpose        */
/*                                                                   */
/*********************************************************************/
BEGIN
SET QUOTED_IDENTIFIER ON;
	BEGIN TRY
		DECLARE @SupervisorInjury CHAR(1)
		DECLARE @SupervisorAdiminNotified CHAR(1)
		DECLARE @ManagerAdiminNotified CHAR(1)
		DECLARE @FallSupervisorAdiminNotified CHAR(1)
		DECLARE @FallManagerAdiminNotified CHAR(1)
		DECLARE @SeizureSupervisorAdiminNotified CHAR(1)
		DECLARE @SeizureManagerAdiminNotified CHAR(1)
		DECLARE @Incident VARCHAR(max)
		DECLARE @secondary VARCHAR(max)
		DECLARE @ButtonClicked VARCHAR(30)

		SET @ButtonClicked = @CustomParameters.value('(/Root/Parameters/@ButtonClicked)[1]', 'varchar(30)')

		IF @ButtonClicked = 'undefined'
		BEGIN
			SET @ButtonClicked = ''
		END

		SET @SupervisorInjury = (
				SELECT TOP 1 SupervisorFollowUpInjury
				FROM CustomIncidentReportSupervisorFollowUps
				WHERE IncidentReportId = @ScreenKeyId
				)
		SET @SupervisorAdiminNotified = (
				SELECT TOP 1 SupervisorFollowUpAdministratorNotified
				FROM CustomIncidentReportSupervisorFollowUps
				WHERE IncidentReportId = @ScreenKeyId
				)
		SET @ManagerAdiminNotified = (
				SELECT TOP 1 ManagerFollowUpAdministratorNotified
				FROM CustomIncidentReportManagerFollowUps
				WHERE IncidentReportId = @ScreenKeyId
				)
		SET @FallSupervisorAdiminNotified = (
				SELECT TOP 1 FallSupervisorFollowUpAdministratorNotified
				FROM CustomIncidentReportFallSupervisorFollowUps
				WHERE IncidentReportId = @ScreenKeyId
				)
		SET @FallManagerAdiminNotified = (
				SELECT TOP 1 ManagerFollowUpAdministratorNotified
				FROM CustomIncidentReportFallManagerFollowUps
				WHERE IncidentReportId = @ScreenKeyId
				)
		SET @SeizureSupervisorAdiminNotified = (
				SELECT TOP 1 SeizureSupervisorFollowUpAdministratorNotified
				FROM CustomIncidentReportSeizureSupervisorFollowUps
				WHERE IncidentReportId = @ScreenKeyId
				)
		SET @SeizureManagerAdiminNotified = (
				SELECT TOP 1 ManagerFollowUpAdministratorNotified
				FROM CustomIncidentReportSeizureManagerFollowUps
				WHERE IncidentReportId = @ScreenKeyId
				)
		SET @Incident = (
				SELECT TOP 1 G.code
				FROM CustomIncidentReportGenerals
				LEFT JOIN GlobalCodes G ON G.GlobalCodeId = (
						SELECT TOP 1 GeneralIncidentCategory
						FROM CustomIncidentReportGenerals
						WHERE IncidentReportId = @ScreenKeyId
						)
				)
		SET @secondary = (
				SELECT TOP 1 G.code
				FROM CustomIncidentReportGenerals
				LEFT JOIN GlobalSubCodes G ON G.GlobalSubCodeId = (
						SELECT TOP 1 GeneralSecondaryCategory
						FROM CustomIncidentReportGenerals
						WHERE IncidentReportId = @ScreenKeyId
						)
				)

		UPDATE CustomIncidentReports
		SET IncidentReportDetailId = (
				SELECT TOP 1 IncidentReportDetailId
				FROM CustomIncidentReportDetails
				WHERE IncidentReportId = @ScreenKeyId
				ORDER BY IncidentReportDetailId DESC
				)
			,DetailVersionStatus = (
				SELECT TOP 1 CASE 
						WHEN ISNULL(InProgressStatus, 0) = 0
							THEN 21
						ELSE InProgressStatus
						END
				FROM CustomIncidentReportDetails
				WHERE IncidentReportId = @ScreenKeyId
				ORDER BY IncidentReportDetailId DESC
				)
		WHERE IncidentReportId = @ScreenKeyId

		UPDATE CustomIncidentReports
		SET IncidentReportFollowUpOfIndividualStatusId = (
				SELECT TOP 1 IncidentReportFollowUpOfIndividualStatusId
				FROM CustomIncidentReportFollowUpOfIndividualStatuses
				WHERE IncidentReportId = @ScreenKeyId
				ORDER BY IncidentReportFollowUpOfIndividualStatusId DESC
				)
			,FollowUpOfIndividualStatusVersionStatus = (
				SELECT TOP 1 CASE 
						WHEN ISNULL(InProgressStatus, 0) = 0
							THEN 21
						ELSE InProgressStatus
						END
				FROM CustomIncidentReportFollowUpOfIndividualStatuses
				WHERE IncidentReportId = @ScreenKeyId
				ORDER BY IncidentReportFollowUpOfIndividualStatusId DESC
				)
		WHERE IncidentReportId = @ScreenKeyId

		UPDATE CustomIncidentReports
		SET IncidentReportSupervisorFollowUpId = (
				SELECT TOP 1 IncidentReportSupervisorFollowUpId
				FROM CustomIncidentReportSupervisorFollowUps
				WHERE IncidentReportId = @ScreenKeyId
				ORDER BY IncidentReportSupervisorFollowUpId DESC
				)
			,SupervisorFollowUpVersionStatus = (
				SELECT TOP 1 CASE 
						WHEN ISNULL(InProgressStatus, 0) = 0
							THEN 21
						ELSE InProgressStatus
						END
				FROM CustomIncidentReportSupervisorFollowUps
				WHERE IncidentReportId = @ScreenKeyId
				ORDER BY IncidentReportSupervisorFollowUpId DESC
				)
		WHERE IncidentReportId = @ScreenKeyId
		
		UPDATE CustomIncidentReports
		SET IncidentReportManagerFollowUpId = (
				SELECT TOP 1 IncidentReportManagerFollowUpId
				FROM CustomIncidentReportManagerFollowUps
				WHERE IncidentReportId = @ScreenKeyId
				ORDER BY IncidentReportManagerFollowUpId DESC
				)
			,ManagerFollowUpStatus = (
				SELECT TOP 1 CASE 
						WHEN ISNULL(InProgressStatus, 0) = 0
							THEN 21
						ELSE InProgressStatus
						END
				FROM CustomIncidentReportManagerFollowUps
				WHERE IncidentReportId = @ScreenKeyId
				ORDER BY IncidentReportManagerFollowUpId DESC
				)
		WHERE IncidentReportId = @ScreenKeyId
		
		UPDATE CustomIncidentReports
		SET IncidentReportAdministratorReviewId = (
				SELECT TOP 1 IncidentReportAdministratorReviewId
				FROM CustomIncidentReportAdministratorReviews
				WHERE IncidentReportId = @ScreenKeyId
				ORDER BY IncidentReportAdministratorReviewId DESC
				)
			,AdministratorReviewVersionStatus = (
				SELECT TOP 1 CASE 
						WHEN ISNULL(InProgressStatus, 0) = 0
							THEN 21
						ELSE InProgressStatus
						END
				FROM CustomIncidentReportAdministratorReviews
				WHERE IncidentReportId = @ScreenKeyId
				ORDER BY IncidentReportAdministratorReviewId DESC
				)
		WHERE IncidentReportId = @ScreenKeyId

		UPDATE CustomIncidentReports
		SET IncidentReportFallDetailId = (
				SELECT TOP 1 IncidentReportFallDetailId
				FROM CustomIncidentReportFallDetails
				WHERE IncidentReportId = @ScreenKeyId
				ORDER BY IncidentReportFallDetailId DESC
				)
			,FallDetailVersionStatus = (
				SELECT TOP 1 CASE 
						WHEN ISNULL(InProgressStatus, 0) = 0
							THEN 21
						ELSE InProgressStatus
						END
				FROM CustomIncidentReportFallDetails
				WHERE IncidentReportId = @ScreenKeyId
				ORDER BY IncidentReportFallDetailId DESC
				)
		WHERE IncidentReportId = @ScreenKeyId

		UPDATE CustomIncidentReports
		SET IncidentReportFallFollowUpOfIndividualStatusId = (
				SELECT TOP 1 IncidentReportFallFollowUpOfIndividualStatusId
				FROM CustomIncidentReportFallFollowUpOfIndividualStatuses
				WHERE IncidentReportId = @ScreenKeyId
				ORDER BY IncidentReportFallFollowUpOfIndividualStatusId DESC
				)
			,FallFollowUpOfIndividualStatusVersionStatus = (
				SELECT TOP 1 CASE 
						WHEN ISNULL(InProgressStatus, 0) = 0
							THEN 21
						ELSE InProgressStatus
						END
				FROM CustomIncidentReportFallFollowUpOfIndividualStatuses
				WHERE IncidentReportId = @ScreenKeyId
				ORDER BY IncidentReportFallFollowUpOfIndividualStatusId DESC
				)
		WHERE IncidentReportId = @ScreenKeyId

		UPDATE CustomIncidentReports
		SET IncidentReportFallSupervisorFollowUpId = (
				SELECT TOP 1 IncidentReportFallSupervisorFollowUpId
				FROM CustomIncidentReportFallSupervisorFollowUps
				WHERE IncidentReportId = @ScreenKeyId
				ORDER BY IncidentReportFallSupervisorFollowUpId DESC
				)
			,FallSupervisorFollowUpVersionStatus = (
				SELECT TOP 1 CASE 
						WHEN ISNULL(InProgressStatus, 0) = 0
							THEN 21
						ELSE InProgressStatus
						END
				FROM CustomIncidentReportFallSupervisorFollowUps
				WHERE IncidentReportId = @ScreenKeyId
				ORDER BY IncidentReportFallSupervisorFollowUpId DESC
				)
		WHERE IncidentReportId = @ScreenKeyId
		
		
		
		UPDATE CustomIncidentReports
		SET IncidentReportFallManagerFollowUpId = (
				SELECT TOP 1 IncidentReportFallManagerFollowUpId
				FROM CustomIncidentReportFallManagerFollowUps
				WHERE IncidentReportId = @ScreenKeyId
				ORDER BY IncidentReportFallManagerFollowUpId DESC
				)
			,FallManagerFollowUpStatus = (
				SELECT TOP 1 CASE 
						WHEN ISNULL(InProgressStatus, 0) = 0
							THEN 21
						ELSE InProgressStatus
						END
				FROM CustomIncidentReportFallManagerFollowUps
				WHERE IncidentReportId = @ScreenKeyId
				ORDER BY IncidentReportFallManagerFollowUpId DESC
				)
		WHERE IncidentReportId = @ScreenKeyId


		UPDATE CustomIncidentReports
		SET IncidentReportFallAdministratorReviewId = (
				SELECT TOP 1 IncidentReportFallAdministratorReviewId
				FROM CustomIncidentReportFallAdministratorReviews
				WHERE IncidentReportId = @ScreenKeyId
				ORDER BY IncidentReportFallAdministratorReviewId DESC
				)
			,FallAdministratorReviewVersionStatus = (
				SELECT TOP 1 CASE 
						WHEN ISNULL(InProgressStatus, 0) = 0
							THEN 21
						ELSE InProgressStatus
						END
				FROM CustomIncidentReportFallAdministratorReviews
				WHERE IncidentReportId = @ScreenKeyId
				ORDER BY IncidentReportFallAdministratorReviewId DESC
				)
		WHERE IncidentReportId = @ScreenKeyId

		UPDATE CustomIncidentReports
		SET IncidentSeizureDetailId = (
				SELECT TOP 1 IncidentSeizureDetailId
				FROM CustomIncidentSeizureDetails
				WHERE IncidentReportId = @ScreenKeyId
				ORDER BY IncidentSeizureDetailId DESC
				)
			,SeizureDetailVersionStatus = (
				SELECT TOP 1 CASE 
						WHEN ISNULL(InProgressStatus, 0) = 0
							THEN 21
						ELSE InProgressStatus
						END
				FROM CustomIncidentSeizureDetails
				WHERE IncidentReportId = @ScreenKeyId
				ORDER BY IncidentSeizureDetailId DESC
				)
		WHERE IncidentReportId = @ScreenKeyId

		UPDATE CustomIncidentReports
		SET IncidentReportSeizureFollowUpOfIndividualStatusId = (
				SELECT TOP 1 IncidentReportSeizureFollowUpOfIndividualStatusId
				FROM CustomIncidentReportSeizureFollowUpOfIndividualStatuses
				WHERE IncidentReportId = @ScreenKeyId
				ORDER BY IncidentReportSeizureFollowUpOfIndividualStatusId DESC
				)
			,SeizureFollowUpOfIndividualStatusVersionStatus = (
				SELECT TOP 1 CASE 
						WHEN ISNULL(InProgressStatus, 0) = 0
							THEN 21
						ELSE InProgressStatus
						END
				FROM CustomIncidentReportSeizureFollowUpOfIndividualStatuses
				WHERE IncidentReportId = @ScreenKeyId
				ORDER BY IncidentReportSeizureFollowUpOfIndividualStatusId DESC
				)
		WHERE IncidentReportId = @ScreenKeyId

		UPDATE CustomIncidentReports
		SET IncidentReportSeizureSupervisorFollowUpId = (
				SELECT TOP 1 IncidentReportSeizureSupervisorFollowUpId
				FROM CustomIncidentReportSeizureSupervisorFollowUps
				WHERE IncidentReportId = @ScreenKeyId
				ORDER BY IncidentReportSeizureSupervisorFollowUpId DESC
				)
			,SeizureSupervisorFollowUpVersionStatus = (
				SELECT TOP 1 CASE 
						WHEN ISNULL(InProgressStatus, 0) = 0
							THEN 21
						ELSE InProgressStatus
						END
				FROM CustomIncidentReportSeizureSupervisorFollowUps
				WHERE IncidentReportId = @ScreenKeyId
				ORDER BY IncidentReportSeizureSupervisorFollowUpId DESC
				)
		WHERE IncidentReportId = @ScreenKeyId
		
		UPDATE CustomIncidentReports
		SET IncidentReportSeizureManagerFollowUpId = (
				SELECT TOP 1 IncidentReportSeizureManagerFollowUpId
				FROM CustomIncidentReportSeizureManagerFollowUps
				WHERE IncidentReportId = @ScreenKeyId
				ORDER BY IncidentReportSeizureManagerFollowUpId DESC
				)
			,SeizureManagerFollowUpStatus = (
				SELECT TOP 1 CASE 
						WHEN ISNULL(InProgressStatus, 0) = 0
							THEN 21
						ELSE InProgressStatus
						END
				FROM CustomIncidentReportSeizureManagerFollowUps
				WHERE IncidentReportId = @ScreenKeyId
				ORDER BY IncidentReportSeizureManagerFollowUpId DESC
				)
		WHERE IncidentReportId = @ScreenKeyId

		UPDATE CustomIncidentReports
		SET IncidentReportSeizureAdministratorReviewId = (
				SELECT TOP 1 IncidentReportSeizureAdministratorReviewId
				FROM CustomIncidentReportSeizureAdministratorReviews
				WHERE IncidentReportId = @ScreenKeyId
				ORDER BY IncidentReportSeizureAdministratorReviewId DESC
				)
			,SeizureAdministratorReviewVersionStatus = (
				SELECT TOP 1 CASE 
						WHEN ISNULL(InProgressStatus, 0) = 0
							THEN 21
						ELSE InProgressStatus
						END
				FROM CustomIncidentReportSeizureAdministratorReviews
				WHERE IncidentReportId = @ScreenKeyId
				ORDER BY IncidentReportSeizureAdministratorReviewId DESC
				)
		WHERE IncidentReportId = @ScreenKeyId

		--Intialise DropDown
		DECLARE @ITitle VARCHAR(max)
		DECLARE @FTitle VARCHAR(max)
		DECLARE @STitle VARCHAR(max)

		SET @ITitle = (
				SELECT SigningSuffix
				FROM staff
				WHERE StaffId = (
						SELECT TOP 1 DetailsStaffNotifiedForInjury
						FROM CustomIncidentReportDetails
						WHERE IncidentReportId = @ScreenKeyId
						ORDER BY IncidentReportDetailId DESC
						)
				)
		SET @FTitle = (
				SELECT SigningSuffix
				FROM staff
				WHERE StaffId = (
						SELECT TOP 1 FallDetailsStaffNotifiedForInjury
						FROM CustomIncidentReportFallDetails
						WHERE IncidentReportId = @ScreenKeyId
						ORDER BY IncidentReportFallDetailId DESC
						)
				)
		SET @STitle = (
				SELECT SigningSuffix
				FROM staff
				WHERE StaffId = (
						SELECT TOP 1 IncidentSeizureDetailsStaffNotifiedForInjury
						FROM CustomIncidentseizureDetails
						WHERE IncidentReportId = @ScreenKeyId
						ORDER BY IncidentSeizureDetailId DESC
						)
				)

		IF @ButtonClicked <> ''
		BEGIN
			--Incident
			UPDATE CustomIncidentReportFollowUpOfIndividualStatuses
			SET FollowUpIndividualStatusNurseStaffEvaluating = (
					SELECT TOP 1 DetailsStaffNotifiedForInjury
					FROM CustomIncidentReportDetails
					WHERE IncidentReportId = @ScreenKeyId
					ORDER BY IncidentReportDetailId DESC
					)
			WHERE IncidentReportId = @ScreenKeyId
				AND @ButtonClicked = 'Details'

			UPDATE CustomIncidentReportSupervisorFollowUps
			SET SupervisorFollowUpSupervisorName = (
					SELECT TOP 1 DetailsSupervisorFlaggedId
					FROM CustomIncidentReportDetails
					WHERE IncidentReportId = @ScreenKeyId
					ORDER BY IncidentReportDetailId DESC
					)
			WHERE IncidentReportId = @ScreenKeyId
				AND @ButtonClicked = 'Details'
				
			UPDATE CustomIncidentReportManagerFollowUps
			SET ManagerFollowUpManagerId = (
					SELECT TOP 1 SupervisorFollowUpManager
					FROM CustomIncidentReportSupervisorFollowUps
					WHERE IncidentReportId = @ScreenKeyId
					ORDER BY IncidentReportSupervisorFollowUpId DESC
					)
			WHERE IncidentReportId = @ScreenKeyId
				AND @ButtonClicked = 'SupervisorFollowUp'
				
				UPDATE CustomIncidentReportAdministratorReviews
			SET AdministratorReviewAdministrator = (
					SELECT TOP 1 ManagerFollowUpAdministrator
					FROM CustomIncidentReportManagerFollowUps
					WHERE IncidentReportId = @ScreenKeyId
					ORDER BY IncidentReportManagerFollowUpId DESC
					)
			WHERE IncidentReportId = @ScreenKeyId
				AND @ButtonClicked = 'IncidentReportManagerFollowUp'

			IF (@ITitle IS NOT NULL)
			BEGIN
				UPDATE CustomIncidentReportFollowUpOfIndividualStatuses
				SET FollowUpIndividualStatusCredentialTitle = (@ITitle)
				WHERE IncidentReportId = @ScreenKeyId
					AND @ButtonClicked = 'Details'
			END

			--Fall				
			UPDATE CustomIncidentReportFallFollowUpOfIndividualStatuses
			SET FallFollowUpIndividualStatusNurseStaffEvaluating = (
					SELECT TOP 1 FallDetailsStaffNotifiedForInjury
					FROM CustomIncidentReportFallDetails
					WHERE IncidentReportId = @ScreenKeyId
					ORDER BY IncidentReportFallDetailId DESC
					)
			WHERE IncidentReportId = @ScreenKeyId
				AND @ButtonClicked = 'FallDetails'

			UPDATE CustomIncidentReportFallSupervisorFollowUps
			SET FallSupervisorFollowUpSupervisorName = (
					SELECT TOP 1 FallDetailsSupervisorFlaggedId
					FROM CustomIncidentReportFallDetails
					WHERE IncidentReportId = @ScreenKeyId
					ORDER BY IncidentReportFallDetailId DESC
					)
			WHERE IncidentReportId = @ScreenKeyId
				AND @ButtonClicked = 'FallDetails'
				
			UPDATE CustomIncidentReportFallManagerFollowUps
			SET ManagerFollowUpManagerId = (
					SELECT TOP 1 SupervisorFollowUpManager
					FROM CustomIncidentReportFallSupervisorFollowUps
					WHERE IncidentReportId = @ScreenKeyId
					ORDER BY IncidentReportFallSupervisorFollowUpId DESC
					)
			WHERE IncidentReportId = @ScreenKeyId
				AND @ButtonClicked = 'FallSupervisorFollowUp'
				
			UPDATE CustomIncidentReportFallAdministratorReviews
			SET FallAdministratorReviewAdministrator = (
					SELECT TOP 1 ManagerFollowUpAdministrator
					FROM CustomIncidentReportFallManagerFollowUps 
					WHERE IncidentReportId = @ScreenKeyId
					ORDER BY IncidentReportFallManagerFollowUpId DESC
					)
			WHERE IncidentReportId = @ScreenKeyId
				AND @ButtonClicked = 'FallManagerFollowUp'


			IF (@FTitle IS NOT NULL)
			BEGIN
				UPDATE CustomIncidentReportFallFollowUpOfIndividualStatuses
				SET FallFollowUpIndividualStatusCredentialTitle = (@FTitle)
				WHERE IncidentReportId = @ScreenKeyId
					AND @ButtonClicked = 'FallDetails'
			END

			--Seizure				
			UPDATE CustomIncidentReportSeizureFollowUpOfIndividualStatuses
			SET SeizureFollowUpIndividualStatusNurseStaffEvaluating = (
					SELECT TOP 1 IncidentSeizureDetailsStaffNotifiedForInjury
					FROM CustomIncidentSeizureDetails
					WHERE IncidentReportId = @ScreenKeyId
					ORDER BY IncidentSeizureDetailId DESC
					)
			WHERE IncidentReportId = @ScreenKeyId
				AND @ButtonClicked = 'SeizureDetails'

			UPDATE CustomIncidentReportSeizureSupervisorFollowUps
			SET SeizureSupervisorFollowUpSupervisorName = (
					SELECT TOP 1 IncidentSeizureDetailsSupervisorFlaggedId
					FROM CustomIncidentSeizureDetails
					WHERE IncidentReportId = @ScreenKeyId
					ORDER BY IncidentSeizureDetailId DESC
					)
			WHERE IncidentReportId = @ScreenKeyId
				AND @ButtonClicked = 'SeizureDetails'
				
			UPDATE CustomIncidentReportSeizureManagerFollowUps
			SET ManagerFollowUpManagerId = (
					SELECT TOP 1 SupervisorFollowUpManager
					FROM CustomIncidentReportSeizureSupervisorFollowUps
					WHERE IncidentReportId = @ScreenKeyId
					ORDER BY IncidentReportSeizureSupervisorFollowUpId DESC
					)
			WHERE IncidentReportId = @ScreenKeyId
				AND @ButtonClicked = 'SeizureSupervisorFollowUp'
				
				UPDATE CustomIncidentReportSeizureAdministratorReviews
			SET SeizureAdministratorReviewAdministrator = (
					SELECT TOP 1 ManagerFollowUpAdministrator
					FROM CustomIncidentReportSeizureManagerFollowUps 
					WHERE IncidentReportId = @ScreenKeyId
					ORDER BY IncidentReportSeizureManagerFollowUpId DESC
					)
			WHERE IncidentReportId = @ScreenKeyId
				AND @ButtonClicked = 'SeizuretManagerFollowUp'
		END

		IF (@STitle IS NOT NULL)
		BEGIN
			UPDATE CustomIncidentReportSeizureFollowUpOfIndividualStatuses
			SET SeizureFollowUpIndividualStatusCredentialTitle = (@STitle)
			WHERE IncidentReportId = @ScreenKeyId
				AND @ButtonClicked = 'SeizureDetails'
		END

		-- Alert
		DECLARE @RecodeProgramId INT
		DECLARE @ProgramId INT
		DECLARE @AdminNotified CHAR(1)
		DECLARE @Supervisor INT
		DECLARE @ClientId INT

		SET @RecodeProgramId = (
				SELECT TOP 1 IntegerCodeId
				FROM recodes
				WHERE RecodeCategoryId IN (
						SELECT RecodeCategoryId
						FROM RecodeCategories
						WHERE CategoryCode = 'XBrian’s House'
						)
				)
		SET @ProgramId = (
				SELECT GeneralProgram
				FROM CustomIncidentReportGenerals
				WHERE IncidentReportId = @ScreenKeyId
				)
		SET @AdminNotified = (
				SELECT TOP 1 SupervisorFollowUpAdministratorNotified
				FROM CustomIncidentReportSupervisorFollowUps
				WHERE IncidentReportId = @ScreenKeyId
				ORDER BY SupervisorFollowUpAdministratorNotified DESC
				)
		SET @ClientId = (
				SELECT ClientId
				FROM CustomIncidentReports
				WHERE IncidentReportId = @ScreenKeyId
				)

		IF @RecodeProgramId = @ProgramId
			AND @AdminNotified = 'Y'
		BEGIN
			SET @Supervisor = (
					SELECT TOP 1 OLSup.ManagerId
					FROM OrganizationLevels OL
					INNER JOIN OrganizationLevels OLSup ON OL.ParentLevelId = OLSup.OrganizationLevelId
					WHERE OL.ProgramId = @ProgramId
					ORDER BY OLSup.OrganizationLevelId
					)

			IF @Supervisor IS NOT NULL
			BEGIN
				INSERT INTO [Alerts] (
					[ToStaffId]
					,[ClientId]
					,[Unread]
					,[DateReceived]
					,[Subject]
					,[Message]
					,[AlertType]
					,[Reference]
					,[ReferenceLink]
					)
				VALUES (
					@Supervisor
					,@ClientId
					,'Y'
					,GETDATE()
					,'Incident Report'
					,'Incident was completed for the associated individual'
					,(
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE Category = 'ALERTTYPE'
							AND Code = 'INCIDENT'
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					,NULL
					,NULL
					)
			END
		END
		--------Client Note Seizure Individual Status------------------------
	   declare @NoteType int;
	   declare @NoteStart datetime;
	   declare @NoteEnd datetime;
	   declare @NoteComment varchar(max)
		if( @ButtonClicked = 'SeizureIndividualStatus')
		begin
		 
		
		select @NoteType= NoteType,@NoteEnd = NoteEnd,@NoteStart = NoteStart, @NoteComment = NoteComment  from
		CustomIncidentReportSeizureFollowUpOfIndividualStatuses WHERE IncidentReportId = @ScreenKeyId
		if(isnull(@NoteType,0) >0 and isnull(@ClientId,0) > 0)
		begin
		if not exists(select * from ClientNotes where ClientId= @ClientId and NoteType = @NoteType and NoteLevel = 4501 and StartDate = @NoteStart and EndDate = @NoteEnd and Note = 'Incident Report Seizure Follow Up Of Individual Status' and cast(Comment as varchar) = @NoteComment)
		begin
		  insert into ClientNotes (ClientId,NoteType,NoteLevel,StartDate,EndDate,Note,Comment,Active )
		  values(@ClientId,@NoteType,4501,@NoteStart,@NoteEnd,'Incident Report Seizure Follow Up Of Individual Status',@NoteComment,'Y')
		end	  
		end
		end
		--------Client Note Fall Individual Status------------------------
		if( @ButtonClicked = 'FallIndividualStatus')
		begin
		 
		select @NoteType= NoteType,@NoteEnd = NoteEnd,@NoteStart = NoteStart, @NoteComment = NoteComment  from
		CustomIncidentReportFallFollowUpOfIndividualStatuses WHERE IncidentReportId = @ScreenKeyId
		if(isnull(@NoteType,0) >0 and isnull(@ClientId,0) > 0)
		begin
		if not exists(select * from ClientNotes where ClientId= @ClientId and NoteType = @NoteType and NoteLevel = 4501 and StartDate = @NoteStart and EndDate = @NoteEnd and Note = 'Incident Report Fall Follow Up Of Individual Status' and cast(Comment as varchar) = @NoteComment)
		begin
		  insert into ClientNotes (ClientId,NoteType,NoteLevel,StartDate,EndDate,Note,Comment,Active )
		  values(@ClientId,@NoteType,4501,@NoteStart,@NoteEnd,'Incident Report Fall Follow Up Of Individual Status',@NoteComment,'Y')
		end	  
		end
		end
		
		--------Client Note Incident Individual Status------------------------
		if( @ButtonClicked = 'IndividualStatus')
		begin
		 
		select @NoteType= NoteType,@NoteEnd = NoteEnd,@NoteStart = NoteStart, @NoteComment = NoteComment  from
		CustomIncidentReportFollowUpOfIndividualStatuses WHERE IncidentReportId = @ScreenKeyId
		if(isnull(@NoteType,0) >0 and isnull(@ClientId,0) > 0)
		begin
		if not exists(select * from ClientNotes where ClientId= @ClientId and NoteType = @NoteType and NoteLevel = 4501 and StartDate = @NoteStart and EndDate = @NoteEnd and Note = 'Incident Report Follow Up Of Individual Status' and cast(Comment as varchar) = @NoteComment)
		begin
		  insert into ClientNotes (ClientId,NoteType,NoteLevel,StartDate,EndDate,Note,Comment,Active )
		  values(@ClientId,@NoteType,4501,@NoteStart,@NoteEnd,'Incident Report Follow Up Of Individual Status',@NoteComment,'Y')
		end	  
		end
		end
		
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_SCPostUpdateIncidentReport') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,
				-- Message text.                                                                        
				16
				,
				-- Severity.                                                               
				1
				-- State.                                                            
				);
	END CATCH
END
