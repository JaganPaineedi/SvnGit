IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCValidateIncidentReport]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_SCValidateIncidentReport]
GO

/****** Object:  StoredProcedure [dbo].[csp_SCValidateIncidentReport]    Script Date: 11/27/2013 16:30:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_SCValidateIncidentReport] --550,113         
	@CurrentUserId INT
	,@ScreenKeyId INT
	,@CustomParameters XML
AS
/******************************************************************************                                          
**  File: [csp_SCValidateRP]                                      
**  Name: [csp_SCValidateRP]                  
**  Desc: For Validation  on Disclosure Detail Page      
**  Return values: Resultset having validation messages                                          
**  Called by:                                           
**  Parameters:                      
**  Auth:  Vamsi                         
**  Date:  May 07 2015                                     
*******************************************************************************                                          
**  Change History                                          
*******************************************************************************                                          
**  Date:       Author:       Description:                                          
  May 07 2015   Vamsi      Validations For Incident Reports detail Page
  June 26 2015	Vithobha	Implemented CustomParameters for Sign buttons 
*******************************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @ButtonClicked VARCHAR(30)

		SET @ButtonClicked = @CustomParameters.value('(/Root/Parameters/@ButtonClicked)[1]', 'varchar(30)')

		IF @ButtonClicked = 'undefined'
		BEGIN
			SET @ButtonClicked = ''
		END

		DECLARE @validationReturnTable TABLE (
			TableName VARCHAR(200)
			,ColumnName VARCHAR(200)
			,ErrorMessage VARCHAR(1000)
			,TabOrder INT NULL
			,ValidationOrder INT NULL
			)

		INSERT INTO @validationReturnTable
		SELECT 'CustomIncidentReportGenerals'
			,'GeneralProgram'
			,'Incident - General- Individual program is required'
			,1
			,1
		FROM CustomIncidentReportGenerals
		WHERE GeneralProgram IS NULL
			AND IncidentReportId = @ScreenKeyId
			AND (
				@ButtonClicked = 'Details'
				OR @ButtonClicked = ''
				OR @ButtonClicked = 'FallDetails'
				OR @ButtonClicked = 'SeizureDetails'
				)
		
		UNION
		
		SELECT 'CustomIncidentReportGenerals'
			,'GeneralDateOfIncident'
			,'Incident - General- Date of incident is required'
			,1
			,2
		FROM CustomIncidentReportGenerals
		WHERE ISNULL(GeneralDateOfIncident, '') = ''
			AND IncidentReportId = @ScreenKeyId
			AND (
				@ButtonClicked = 'Details'
				OR @ButtonClicked = ''
				OR @ButtonClicked = 'FallDetails'
				OR @ButtonClicked = 'SeizureDetails'
				)
		
		UNION
		
		SELECT 'CustomIncidentReportGenerals'
			,'GeneralTimeOfIncident'
			,'Incident - General- Time of incident is required'
			,1
			,3
		FROM CustomIncidentReportGenerals
		WHERE ISNULL(GeneralTimeOfIncident, '') = ''
			AND IncidentReportId = @ScreenKeyId
			AND (
				@ButtonClicked = 'Details'
				OR @ButtonClicked = ''
				OR @ButtonClicked = 'FallDetails'
				OR @ButtonClicked = 'SeizureDetails'
				)
		
		UNION
		
		SELECT 'CustomIncidentReportGenerals'
			,'GeneralResidence'
			,'Incident - General- Individual residence is required'
			,1
			,4
		FROM CustomIncidentReportGenerals
		WHERE ISNULL(GeneralResidence, '') = ''
			AND IncidentReportId = @ScreenKeyId
			AND (
				@ButtonClicked = 'Details'
				OR @ButtonClicked = ''
				OR @ButtonClicked = 'FallDetails'
				OR @ButtonClicked = 'SeizureDetails'
				)
		
		UNION
		
		SELECT 'CustomIncidentReportGenerals'
			,'GeneralDateStaffNotified'
			,'Incident - General- Date staff notified is required'
			,1
			,5
		FROM CustomIncidentReportGenerals
		WHERE ISNULL(GeneralDateStaffNotified, '') = ''
			AND IncidentReportId = @ScreenKeyId
			AND (
				@ButtonClicked = 'Details'
				OR @ButtonClicked = ''
				OR @ButtonClicked = 'FallDetails'
				OR @ButtonClicked = 'SeizureDetails'
				)
		
		UNION
		
		SELECT 'CustomIncidentReportGenerals'
			,'GeneralTimeStaffNotified'
			,'Incident - General- Time staff notified is required'
			,1
			,6
		FROM CustomIncidentReportGenerals
		WHERE ISNULL(GeneralTimeStaffNotified, '') = ''
			AND IncidentReportId = @ScreenKeyId
			AND (
				@ButtonClicked = 'Details'
				OR @ButtonClicked = ''
				OR @ButtonClicked = 'FallDetails'
				OR @ButtonClicked = 'SeizureDetails'
				)
		
		UNION
		
		SELECT 'CustomIncidentReportGenerals'
			,'GeneralLocationOfIncident'
			,'Incident - General- Location of incident is required'
			,1
			,7
		FROM CustomIncidentReportGenerals
		WHERE ISNULL(GeneralLocationOfIncident, '') = ''
			AND IncidentReportId = @ScreenKeyId
			AND (
				@ButtonClicked = 'Details'
				OR @ButtonClicked = ''
				OR @ButtonClicked = 'FallDetails'
				OR @ButtonClicked = 'SeizureDetails'
				)
		
		UNION
		
		SELECT 'CustomIncidentReportGenerals'
			,'GeneralLocationDetails'
			,'Incident - General- Location details is required'
			,1
			,8
		FROM CustomIncidentReportGenerals
		WHERE ISNULL(GeneralLocationDetails, '') = ''
			AND IncidentReportId = @ScreenKeyId
			AND (
				@ButtonClicked = 'Details'
				OR @ButtonClicked = ''
				OR @ButtonClicked = 'FallDetails'
				OR @ButtonClicked = 'SeizureDetails'
				)
		
		UNION
		
		SELECT 'CustomIncidentReportGenerals'
			,'GeneralIncidentCategory'
			,'Incident - General- Incident Category is required'
			,1
			,9
		FROM CustomIncidentReportGenerals
		WHERE ISNULL(GeneralIncidentCategory, '') = ''
			AND IncidentReportId = @ScreenKeyId
			AND (
				@ButtonClicked = 'Details'
				OR @ButtonClicked = ''
				OR @ButtonClicked = 'FallDetails'
				OR @ButtonClicked = 'SeizureDetails'
				)
		----Incident Details
		
		UNION
		
		SELECT 'CustomIncidentReportDetails'
			,'DetailsDescriptionOfincident'
			,'Incident - Details- Description of incident is required'
			,1
			,10
		FROM CustomIncidentReportDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(D.DetailsDescriptionOfincident, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'Details')
		
		UNION
		
		SELECT 'CustomIncidentReportDetails'
			,'DetailsActionsTakenByStaff'
			,'Incident - Details- Actions taken by staff is required'
			,1
			,11
		FROM CustomIncidentReportDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(D.DetailsActionsTakenByStaff, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'Details')
		
		UNION
		
		SELECT 'CustomIncidentReportDetails'
			,'DetailsStaffNotifiedForInjury'
			,'Incident -Details- Staff notification  for injury is required'
			,1
			,12
		FROM CustomIncidentReportDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		LEFT JOIN CustomIncidentReportSupervisorFollowUps S ON S.IncidentReportId = D.IncidentReportId
		WHERE ISNULL(D.DetailsStaffNotifiedForInjury, '') = ''
			AND S.SupervisorFollowUpInjury = 'Y'
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'Details')
		
		UNION
		
		SELECT 'CustomIncidentReportDetails'
			,'DetailsDateStaffNotified'
			,'Incident - Details- Date staff notified is required'
			,1
			,13
		FROM CustomIncidentReportDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		LEFT JOIN CustomIncidentReportSupervisorFollowUps S ON S.IncidentReportId = D.IncidentReportId
		WHERE ISNULL(D.DetailsDateStaffNotified, '') = ''
			AND S.SupervisorFollowUpInjury = 'Y'
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'Details')
			UNION
		
		SELECT 'CustomIncidentReportDetails'
			,'DetailsSupervisorFlaggedId'
			,'Incident - Details-Supervisor to be Flagged for Review is required'
			,1
			,14
		FROM CustomIncidentReportDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		LEFT JOIN CustomIncidentReportSupervisorFollowUps S ON S.IncidentReportId = D.IncidentReportId
		WHERE ISNULL(D.DetailsSupervisorFlaggedId, '') = ''			
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'Details')
		
		UNION
		
		SELECT 'CustomIncidentReportDetails'
			,'DetailsTimestaffNotified'
			,'Incident - Details- Time staff notified is required'
			,1
			,14
		FROM CustomIncidentReportDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		LEFT JOIN CustomIncidentReportSupervisorFollowUps S ON S.IncidentReportId = D.IncidentReportId
		WHERE ISNULL(D.DetailsTimestaffNotified, '') = ''
			AND S.SupervisorFollowUpInjury = 'Y'
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'Details')
		
		-------------Incident Tab --Follow Up of Individual Status--------------------------------------
		
		UNION
		
		SELECT 'CustomIncidentReportFollowUpOfIndividualStatuses'
			,'FollowUpIndividualStatusNurseStaffEvaluating'
			,'Incident -Follow up of Individual status- Nurse/staff evaluating is required '
			,1
			,15
		FROM CustomIncidentReportFollowUpOfIndividualStatuses D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		LEFT JOIN CustomIncidentReportSupervisorFollowUps S ON S.IncidentReportId = D.IncidentReportId
		LEFT JOIN Programs P ON P.ProgramId = G.GeneralProgram
		WHERE ISNULL(D.FollowUpIndividualStatusNurseStaffEvaluating, '') = ''
			AND S.SupervisorFollowUpInjury = 'Y'
			AND P.ProgramName NOT IN (
				'Brain''s House'
				,'Brian’s House'
				,'Allies'
				)
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'IndividualStatus')
		
		UNION
		
		SELECT 'CustomIncidentReportFollowUpOfIndividualStatuses'
			,'FollowUpIndividualStatusCredentialTitle'
			,'Incident - Follow up of Individual status- Credential/title is required'
			,1
			,15
		FROM CustomIncidentReportFollowUpOfIndividualStatuses D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		LEFT JOIN CustomIncidentReportSupervisorFollowUps S ON S.IncidentReportId = D.IncidentReportId
		LEFT JOIN Programs P ON P.ProgramId = G.GeneralProgram
		WHERE ISNULL(D.FollowUpIndividualStatusCredentialTitle, '') = ''
			AND S.SupervisorFollowUpInjury = 'Y'
			AND P.ProgramName NOT IN (
				'Brain''s House'
				,'Brian’s House'
				,'Allies'
				)
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'IndividualStatus')
		
		UNION
		
		SELECT 'CustomIncidentReportFollowUpOfIndividualStatuses'
			,'FollowUpIndividualStatusDetailsOfInjury'
			,'Incident -Follow up of Individual status- Details of injury/illness and treatment provided is required'
			,1
			,17
		FROM CustomIncidentReportFollowUpOfIndividualStatuses D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		LEFT JOIN CustomIncidentReportSupervisorFollowUps S ON S.IncidentReportId = D.IncidentReportId
		WHERE ISNULL(D.FollowUpIndividualStatusDetailsOfInjury, '') = ''
			AND S.SupervisorFollowUpInjury = 'Y'
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'IndividualStatus')
		
		UNION
		
		SELECT 'CustomIncidentReportFollowUpOfIndividualStatuses'
			,'FollowUpIndividualStatusFamilyGuardianCustodianNotified'
			,'Incident - Follow up of Individual status-Family/Guardian/Custodian notified is required'
			,1
			,18
		FROM CustomIncidentReportFollowUpOfIndividualStatuses D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(D.FollowUpIndividualStatusFamilyGuardianCustodianNotified, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'IndividualStatus')
		
		UNION
		
		SELECT 'CustomIncidentReportFollowUpOfIndividualStatuses'
			,'FollowUpIndividualStatusDateOfNotification'
			,'Incident - Follow up of Individual status – Date of Notification is required'
			,1
			,19
		FROM CustomIncidentReportFollowUpOfIndividualStatuses D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(D.FollowUpIndividualStatusDateOfNotification, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'IndividualStatus')
			AND FollowUpIndividualStatusFamilyGuardianCustodianNotified = 'Y'
		
		UNION
		
		SELECT 'CustomIncidentReportFollowUpOfIndividualStatuses'
			,'FollowUpIndividualStatusTimeOfNotification'
			,'Incident - Follow up of Individual status – Time of Notification is required'
			,1
			,20
		FROM CustomIncidentReportFollowUpOfIndividualStatuses D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(D.FollowUpIndividualStatusTimeOfNotification, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
			
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'IndividualStatus')
			AND FollowUpIndividualStatusFamilyGuardianCustodianNotified = 'Y'
		
		UNION
		
		SELECT 'CustomIncidentReportFollowUpOfIndividualStatuses'
			,'FollowUpIndividualStatusStaffCompletedNotification'
			,'Incident - Follow up of Individual status – Staff who completed notification is required'
			,1
			,21
		FROM CustomIncidentReportFollowUpOfIndividualStatuses D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(D.FollowUpIndividualStatusStaffCompletedNotification, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
			
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'IndividualStatus')
			AND FollowUpIndividualStatusFamilyGuardianCustodianNotified = 'Y'
		
		UNION
		
		SELECT 'CustomIncidentReportFollowUpOfIndividualStatuses'
			,'FollowUpIndividualStatusNameOfFamilyGuardianCustodian'
			,'Incident - Follow up of Individual status – Name of the family/guardian/custodian notified is required'
			,1
			,22
		FROM CustomIncidentReportFollowUpOfIndividualStatuses D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(D.FollowUpIndividualStatusNameOfFamilyGuardianCustodian, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'IndividualStatus')
			AND FollowUpIndividualStatusFamilyGuardianCustodianNotified = 'Y'
			
		UNION
		
		SELECT 'CustomIncidentReportFollowUpOfIndividualStatuses'
			,'FollowUpIndividualStatusDetailsOfNotification'
			,'Incident - Follow up of Individual status – Details of Notification is required'
			,1
			,23
		FROM CustomIncidentReportFollowUpOfIndividualStatuses D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(D.FollowUpIndividualStatusDetailsOfNotification, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
			
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'IndividualStatus')
			AND FollowUpIndividualStatusFamilyGuardianCustodianNotified = 'Y'
			
			UNION
		
		SELECT 'CustomIncidentReportFollowUpOfIndividualStatuses'
			,'FollowUpIndividualStatusDetailsOfNotification'
			,'Incident - Follow up of Individual status – Details of Notification is required'
			,1
			,23
		FROM CustomIncidentReportFollowUpOfIndividualStatuses D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(D.FollowUpIndividualStatusDetailsOfNotification, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
			
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'IndividualStatus')
			AND FollowUpIndividualStatusFamilyGuardianCustodianNotified = 'Y'
			
			UNION
		
		SELECT 'CustomIncidentReportFollowUpOfIndividualStatuses'
			,'FollowUpIndividualStatusDetailsOfNotification'
			,'Incident - Follow up of Individual status – Note Start date is required when Note Type is selected'
			,1
			,23
		FROM CustomIncidentReportFollowUpOfIndividualStatuses D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE D.NoteStart is null
		    AND isnull(NoteType,0) >0
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'IndividualStatus')
			
				UNION
		
		SELECT 'CustomIncidentReportFollowUpOfIndividualStatuses'
			,'FollowUpIndividualStatusDetailsOfNotification'
			,'Incident - Follow up of Individual status – Note End date is required when Note Type is selected'
			,1
			,23
		FROM CustomIncidentReportFollowUpOfIndividualStatuses D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE D.NoteEnd is null
		    AND isnull(NoteType,0) >0
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'IndividualStatus')
			
				UNION
		
		SELECT 'CustomIncidentReportFollowUpOfIndividualStatuses'
			,'FollowUpIndividualStatusDetailsOfNotification'
			,'Incident - Follow up of Individual status – Note Comment is required when Note Type is selected'
			,1
			,24
		FROM CustomIncidentReportFollowUpOfIndividualStatuses D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE isnull(D.NoteComment,'') = ''
		    AND isnull(NoteType,0) >0
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'IndividualStatus')
			
			
			
		----Supervisor Follow Up 
		UNION
		
		SELECT 'CustomIncidentReportSupervisorFollowUps'
			,'SupervisorFollowUpSupervisorName'
			,'Incident -Supervisor follow up- Supervisor name is required '
			,1
			,23
		FROM CustomIncidentReportSupervisorFollowUps U
		LEFT JOIN CustomIncidentReportGenerals G ON U.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(U.SupervisorFollowUpSupervisorName, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				)
			AND G.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SupervisorFollowUp')
		
		UNION
		
		SELECT 'CustomIncidentReportSupervisorFollowUps'
			,'SupervisorFollowUpFollowUp'
			,'Incident - Supervisor follow up-Follow up is required'
			,1
			,24
		FROM CustomIncidentReportSupervisorFollowUps U
		LEFT JOIN CustomIncidentReportGenerals G ON U.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(U.SupervisorFollowUpFollowUp, '') = ''
			AND SupervisorFollowUpInjury = 'Y'
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				)
			AND G.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SupervisorFollowUp')
		
		UNION
		
		SELECT 'CustomIncidentReportSupervisorFollowUps'
			,'SupervisorFollowUpAdministratorNotified'
			,'Incident -Supervisor follow up-Administrator notified is required'
			,1
			,25
		FROM CustomIncidentReportSupervisorFollowUps U
		LEFT JOIN CustomIncidentReportGenerals G ON U.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(U.SupervisorFollowUpAdministratorNotified, '') = ''
			AND SupervisorFollowUpInjury = 'Y'
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
			
				)
			AND G.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SupervisorFollowUp')
		
		UNION
		
		SELECT 'CustomIncidentReportSupervisorFollowUps'
			,'SupervisorFollowUpAdministrator'
			,'Incident - Supervisor follow up-Administrator is required'
			,1
			,26
		FROM CustomIncidentReportSupervisorFollowUps U
		LEFT JOIN CustomIncidentReportGenerals G ON U.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(U.SupervisorFollowUpAdministrator, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				
				)
			AND G.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SupervisorFollowUp')
			AND SupervisorFollowUpAdministratorNotified='Y'
	
		UNION
		
		SELECT 'CustomIncidentReportSupervisorFollowUps'
			,'SupervisorFollowUpAdminDateOfNotification'
			,'Incident - Supervisor follow up- Date of notification is required'
			,1
			,27
		FROM CustomIncidentReportSupervisorFollowUps U
		LEFT JOIN CustomIncidentReportGenerals G ON U.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(U.SupervisorFollowUpAdminDateOfNotification, '') = ''
			AND SupervisorFollowUpAdministratorNotified = 'Y'
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
			
				)
			AND G.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SupervisorFollowUp')
			AND SupervisorFollowUpAdministratorNotified='Y'
		
		UNION
		
		SELECT 'CustomIncidentReportSupervisorFollowUps'
			,'SupervisorFollowUpAdminTimeOfNotification'
			,'Incident - Supervisor follow up- Time of notification is required'
			,1
			,28
		FROM CustomIncidentReportSupervisorFollowUps U
		LEFT JOIN CustomIncidentReportGenerals G ON U.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(U.SupervisorFollowUpAdminTimeOfNotification, '') = ''
			AND SupervisorFollowUpAdministratorNotified = 'Y'
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				
				)
			AND G.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SupervisorFollowUp')
			AND SupervisorFollowUpAdministratorNotified='Y'
		
		UNION
		
		SELECT 'CustomIncidentReportSupervisorFollowUps'
			,'SupervisorFollowUpFamilyGuardianCustodianNotified'
			,'Incident - Supervisor follow up-Family/Guardian/Custodian notified is required'
			,1
			,29
		FROM CustomIncidentReportSupervisorFollowUps U
		LEFT JOIN CustomIncidentReportGenerals G ON U.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(U.SupervisorFollowUpFamilyGuardianCustodianNotified, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				
				)
			AND G.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SupervisorFollowUp')
		
		UNION
		
		SELECT 'CustomIncidentReportSupervisorFollowUps'
			,'SupervisorFollowUpFGCDateOfNotification'
			,'Incident - Supervisor follow up- Date of notification is required'
			,1
			,30
		FROM CustomIncidentReportSupervisorFollowUps U
		LEFT JOIN CustomIncidentReportGenerals G ON U.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(U.SupervisorFollowUpFGCDateOfNotification, '') = ''
			AND SupervisorFollowUpFamilyGuardianCustodianNotified = 'Y'
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				
				)
			AND G.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SupervisorFollowUp')
		
		UNION
		
		SELECT 'CustomIncidentReportSupervisorFollowUps'
			,'SupervisorFollowUpFGCTimeOfNotification'
			,'Incident - Supervisor follow up- Time of notification is required'
			,1
			,31
		FROM CustomIncidentReportSupervisorFollowUps U
		LEFT JOIN CustomIncidentReportGenerals G ON U.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(U.SupervisorFollowUpFGCTimeOfNotification, '') = ''
			AND SupervisorFollowUpFamilyGuardianCustodianNotified = 'Y'
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
			
				)
			AND G.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SupervisorFollowUp')
		
		UNION
		
		SELECT 'CustomIncidentReportSupervisorFollowUps'
			,'SupervisorFollowUpStaffCompletedNotification'
			,'Incident - Supervisor follow up- Staff who completed notification is required'
			,1
			,32
		FROM CustomIncidentReportSupervisorFollowUps U
		LEFT JOIN CustomIncidentReportGenerals G ON U.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(U.SupervisorFollowUpStaffCompletedNotification, '') = ''
			AND SupervisorFollowUpFamilyGuardianCustodianNotified = 'Y'
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				
				)
			AND G.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SupervisorFollowUp')
		
		UNION
		
		SELECT 'CustomIncidentReportSupervisorFollowUps'
			,'SupervisorFollowUpNameOfFamilyGuardianCustodian'
			,'Incident - Supervisor follow up- Name of the Family/Guardian/Custodian notified is required'
			,1
			,33
		FROM CustomIncidentReportSupervisorFollowUps U
		LEFT JOIN CustomIncidentReportGenerals G ON U.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(U.SupervisorFollowUpNameOfFamilyGuardianCustodian, '') = ''
		AND SupervisorFollowUpFamilyGuardianCustodianNotified = 'Y'
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				
				)
			AND G.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SupervisorFollowUp')
			
			UNION
		
		SELECT 'CustomIncidentReportSupervisorFollowUps'
			,'SupervisorFollowUpDetailsOfNotification'
			,'Incident - Supervisor follow up - Details of Notification is required'
			,1
			,33
		FROM CustomIncidentReportSupervisorFollowUps U
		LEFT JOIN CustomIncidentReportGenerals G ON U.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(U.SupervisorFollowUpDetailsOfNotification, '') = ''
		AND SupervisorFollowUpFamilyGuardianCustodianNotified = 'Y'
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				
				)
			AND G.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SupervisorFollowUp')
			--END
			
			UNION
		
		SELECT 'CustomIncidentReportSupervisorFollowUps'
			,'SupervisorFollowUpManagerNotified'
			,'Incident - Supervisor follow up - Manager Notified is required'
			,1
			,33
		FROM CustomIncidentReportSupervisorFollowUps U
		LEFT JOIN CustomIncidentReportGenerals G ON U.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(U.SupervisorFollowUpManagerNotified, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				
				)
			AND G.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SupervisorFollowUp')
			
			UNION
		
		SELECT 'CustomIncidentReportSupervisorFollowUps'
			,'SupervisorFollowUpManagerNotified'
			,'Incident - Supervisor follow up - Manager is required'
			,1
			,33
		FROM CustomIncidentReportSupervisorFollowUps U
		LEFT JOIN CustomIncidentReportGenerals G ON U.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(U.SupervisorFollowUpManagerNotified, '') = 'Y'
		    AND U.SupervisorFollowUpManager is null
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				
				)
			AND G.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SupervisorFollowUp')
			
			UNION
		
		SELECT 'CustomIncidentReportSupervisorFollowUps'
			,'SupervisorFollowUpManagerNotified'
			,'Incident - Supervisor follow up - Manager Date of notification is required'
			,1
			,33
		FROM CustomIncidentReportSupervisorFollowUps U
		LEFT JOIN CustomIncidentReportGenerals G ON U.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(U.SupervisorFollowUpManagerNotified, '') = 'Y'
		    AND U.SupervisorFollowUpManagerDateOfNotification is null
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				
				)
			AND G.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SupervisorFollowUp')
			UNION
		
		SELECT 'CustomIncidentReportSupervisorFollowUps'
			,'SupervisorFollowUpManagerNotified'
			,'Incident - Supervisor follow up - Manager Time of Notification is required'
			,1
			,33
		FROM CustomIncidentReportSupervisorFollowUps U
		LEFT JOIN CustomIncidentReportGenerals G ON U.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(U.SupervisorFollowUpManagerNotified, '') = 'Y'
		    AND U.SupervisorFollowUpManagerTimeOfNotification is null
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				
				)
			AND G.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SupervisorFollowUp')
		
		UNION
		
		SELECT 'CustomIncidentReportSupervisorFollowUps'
			,NULL
			,'Incident - Supervisor follow up- at least one check box is required'
			,1
			,34
		FROM CustomIncidentReportSupervisorFollowUps U
		LEFT JOIN CustomIncidentReportGenerals G ON U.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(U.SupervisorFollowUpAggressionPhysical, '') = ''
			AND ISNULL(U.SupervisorFollowUpAggressionVerbal, '') = ''
			AND ISNULL(U.SupervisorFollowUpBehavioralRestraint, '') = ''
			AND ISNULL(U.SupervisorFollowUpElopementOffCampus, '') = ''
			AND ISNULL(U.SupervisorFollowUpElopementOnCampus, '') = ''
			AND ISNULL(U.SupervisorFollowUpContraband, '') = ''
			AND ISNULL(U.SupervisorFollowUpPropertyDamage, '') = ''
			AND ISNULL(U.SupervisorFollowUpPropertyDestruction, '') = ''
			AND ISNULL(U.SupervisorFollowUpSearchSeizure, '') = ''
			AND ISNULL(U.SupervisorFollowUpSelfInjury, '') = ''
			AND ISNULL(U.SupervisorFollowUpSuicideAttempt, '') = ''
			AND ISNULL(U.SupervisorFollowUpSuicideThreatGesture, '') = ''
			AND ISNULL(U.SupervisorFollowUpOutbreakOfDisease, '') = ''
			AND ISNULL(U.SupervisorFollowUpIllness, '') = ''
			AND ISNULL(U.SupervisorFollowUpHospitalizationMedical, '') = ''
			AND ISNULL(U.SupervisorFollowUpHospitalizationPsychiatric, '') = ''
			AND ISNULL(U.SupervisorFollowUpTripToER, '') = ''
			AND ISNULL(U.SupervisorFollowUpAllegedAbuse, '') = ''
			AND ISNULL(U.SupervisorFollowUpMisuseOfFundsProperty, '') = ''
			AND ISNULL(U.SupervisorFollowUpViolationOfRights, '') = ''
			AND ISNULL(U.SupervisorFollowUpIndividualToIndividualInjury, '') = ''
			AND ISNULL(U.SupervisorFollowUpInjury, '') = ''
			AND ISNULL(U.SupervisorFollowUpInjuryFromRestraint, '') = ''
			AND ISNULL(U.SupervisorFollowUpFireDepartmentInvolvement, '') = ''
			AND ISNULL(U.SupervisorFollowUpPoliceInvolvement, '') = ''
			AND ISNULL(U.SupervisorFollowUpChokingSwallowingDifficulty, '') = ''
			AND ISNULL(U.SupervisorFollowUpDeath, '') = ''
			AND ISNULL(U.SupervisorFollowUpDrugUsePossession, '') = ''
			AND ISNULL(U.SupervisorFollowUpOutOfProgramArea, '') = ''
			AND ISNULL(U.SupervisorFollowUpSexualIncident, '') = ''
			AND ISNULL(U.SupervisorFollowUpOther, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
			
				)
			AND G.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SupervisorFollowUp')
			
		---------------- Manager Review ------------------------------
		UNION
		SELECT 'CustomIncidentReportManagerFollowUps'
			,'ManagerFollowUpManagerId'
			,'Incident - Manager Review – Manager is required'
			,1
			,33
		FROM CustomIncidentReportSupervisorFollowUps U
		LEFT JOIN CustomIncidentReportGenerals G ON U.IncidentReportId = G.IncidentReportId
		left join CustomIncidentReportManagerFollowUps mf on u.IncidentReportId = mf.IncidentReportId 
		WHERE ISNULL(U.SupervisorFollowUpManagerNotified, '') = 'Y'
		    AND mf.ManagerFollowUpManagerId is null
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				
				)
			AND G.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'IncidentReportManagerFollowUp')
			
		UNION
		SELECT 'CustomIncidentReportManagerFollowUps'
			,'ManagerFollowUpAdministrator'
			,'Incident - Manager Review – Administrator is required when Administrator Notified is answered Yes. '
			,1
			,33
		FROM CustomIncidentReportManagerFollowUps U
		LEFT JOIN CustomIncidentReportGenerals G ON U.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(U.ManagerFollowUpAdministratorNotified, '') = 'Y'
		    AND U.ManagerFollowUpAdministrator is null
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				
				)
			AND G.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'IncidentReportManagerFollowUp')
			
		UNION
		SELECT 'CustomIncidentReportManagerFollowUps'
			,'ManagerFollowUpAdminDateOfNotification'
			,'Incident - Manager Review – Date of Notification is required when Administrator Notified is answered Yes.'
			,1
			,33
		FROM CustomIncidentReportManagerFollowUps U
		LEFT JOIN CustomIncidentReportGenerals G ON U.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(U.ManagerFollowUpAdministratorNotified, '') = 'Y'
		    AND U.ManagerFollowUpAdminDateOfNotification is null
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				
				)
			AND G.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'IncidentReportManagerFollowUp')
			
		UNION
		SELECT 'CustomIncidentReportManagerFollowUps'
			,'ManagerFollowUpAdminTimeOfNotification'
			,'Incident - Manager Review – Time of Notification is required when Administrator Notified is answered Yes.'
			,1
			,33
		FROM CustomIncidentReportManagerFollowUps U
		LEFT JOIN CustomIncidentReportGenerals G ON U.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(U.ManagerFollowUpAdministratorNotified, '') = 'Y'
		    AND U.ManagerFollowUpAdminTimeOfNotification is null
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				
				)
			AND G.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'IncidentReportManagerFollowUp')
			
		----Administrator Review
		
		UNION
		
		SELECT 'CustomIncidentReportAdministratorReviews'
			,'AdministratorReviewAdministrator'
			,'Incident - Administrator Review- Administrator is required'
			,1
			,35
		FROM CustomIncidentReportAdministratorReviews A
		LEFT JOIN CustomIncidentReportGenerals G ON A.IncidentReportId = G.IncidentReportId
		LEFT JOIN CustomIncidentReportSupervisorFollowUps U ON U.IncidentReportId = A.IncidentReportId
		WHERE ISNULL(A.AdministratorReviewAdministrator, '') = ''
			AND U.SupervisorFollowUpAdministratorNotified = 'Y'
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				
				)
			AND A.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'AdministratorReview')
		
		UNION
		
		SELECT 'CustomIncidentReportAdministratorReviews'
			,'AdministratorReviewAdministrativeReview'
			,'Incident - Administrator Review- Administrator review is required'
			,1
			,36
		FROM CustomIncidentReportAdministratorReviews A
		LEFT JOIN CustomIncidentReportGenerals G ON A.IncidentReportId = G.IncidentReportId
		LEFT JOIN CustomIncidentReportSupervisorFollowUps U ON U.IncidentReportId = A.IncidentReportId
		WHERE ISNULL(A.AdministratorReviewAdministrativeReview, '') = ''
			AND U.SupervisorFollowUpAdministratorNotified = 'Y'
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				
				)
			AND A.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'AdministratorReview')
		
		UNION
		
		SELECT 'CustomIncidentReportAdministratorReviews'
			,'AdministratorReviewFiledReportableIncident'
			,'Incident - Administrator Review-Filed Reportable Incident is required'
			,1
			,37
		FROM CustomIncidentReportAdministratorReviews A
		LEFT JOIN CustomIncidentReportGenerals G ON A.IncidentReportId = G.IncidentReportId
		LEFT JOIN CustomIncidentReportSupervisorFollowUps U ON U.IncidentReportId = A.IncidentReportId
		WHERE ISNULL(A.AdministratorReviewFiledReportableIncident, '') = ''
			AND U.SupervisorFollowUpAdministratorNotified = 'Y'
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				
				)
			AND A.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'AdministratorReview')
		/********************************************************************Fall Tab*************************************************************************/
		----Fall Details
		
		UNION
		
		SELECT 'CustomIncidentReportFallDetails'
			,'FallDetailsDescribeIncident'
			,'Fall - Details – Describe incident is required'
			,2
			,1
		FROM CustomIncidentReportFallDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(D.FallDetailsDescribeIncident, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallDetails')
		
		UNION
		
		SELECT 'CustomIncidentReportFallDetails'
			,'FallDetailsCauseOfIncident'
			,'Fall - Details- Cause of incident is required'
			,2
			,2
		FROM CustomIncidentReportFallDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(D.FallDetailsCauseOfIncident, '') = ''
		AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallDetails')
		
		UNION
		
		SELECT 'CustomIncidentReportFallDetails'
			,'FallDetailsCauseOfIncidentText'
			,'Fall- Details - Cause of Incident –(' + (GG.CodeName) + ') – other is required'
			,2
			,3
		FROM CustomIncidentReportFallDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		LEFT JOIN GlobalCodes GG ON GG.GlobalCodeId = D.FallDetailsCauseOfIncident
		WHERE ISNULL(D.FallDetailsCauseOfIncidentText, '') = ''
			AND (
				GG.Code = 'SLIPPED'
				OR GG.Code = 'EQUIPMENTMALFUNCTION'
				OR GG.Code = 'ENVIRONMENTALFACTOR'
				OR GG.Code = 'OTHER'
				)
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallDetails')
		
		UNION
		
		SELECT 'CustomIncidentReportFallDetails'
			,NULL
			,'Fall - Details- Personal/Safety Protective Device(s) use at time of incident is required'
			,2
			,4
		FROM CustomIncidentReportFallDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE (
				ISNULL(D.FallDetailsNone, '') = ''
				OR D.FallDetailsNone = 'N'
				)
			AND (
				ISNULL(D.FallDetailsCane, '') = ''
				OR D.FallDetailsCane = 'N'
				)
			AND (
				ISNULL(D.FallDetailsSeatLapBelt, '') = ''
				OR D.FallDetailsSeatLapBelt = 'N'
				)
			AND (
				ISNULL(D.FallDetailsWheelchair, '') = ''
				OR D.FallDetailsWheelchair = 'N'
				)
			AND (
				ISNULL(D.FallDetailsGaitBelt, '') = ''
				OR D.FallDetailsGaitBelt = 'N'
				)
			AND (
				ISNULL(D.FallDetailsWheellchairTray, '') = ''
				OR D.FallDetailsWheellchairTray = 'N'
				)
			AND (
				ISNULL(D.FallDetailsWalker, '') = ''
				OR D.FallDetailsWalker = 'N'
				)
			AND (
				ISNULL(D.FallDetailsMafosBraces, '') = ''
				OR D.FallDetailsMafosBraces = 'N'
				)
			AND (
				ISNULL(D.FallDetailsHelmet, '') = ''
				OR D.FallDetailsHelmet = 'N'
				)
			AND (
				ISNULL(D.FallDetailsChestHarness, '') = ''
				OR D.FallDetailsChestHarness = 'N'
				)
			AND (
				ISNULL(D.FallDetailsOther, '') = ''
				OR D.FallDetailsOther = 'N'
				)
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallDetails')
		
		UNION
		
		SELECT 'CustomIncidentReportFallDetails'
			,'FallDetailsOtherText'
			,'Fall - Details- Personal/Safety Protective Device(s) Used at Time of Fall -other is required'
			,2
			,5
		FROM CustomIncidentReportFallDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(D.FallDetailsOtherText, '') = ''
			AND D.FallDetailsOther = 'Y'
		AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallDetails')
		
		UNION
		
		SELECT 'CustomIncidentReportFallDetails'
			,'FallDetailsIncidentOccurredWhile'
			,'Fall - Details- Incident occurred while is required'
			,2
			,6
		FROM CustomIncidentReportFallDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(D.FallDetailsIncidentOccurredWhile, '') = ''
		AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallDetails')
		
		UNION
		
		SELECT 'CustomIncidentReportFallDetails'
			,'FallDetailsWheelsLocked'
			,'Fall - Details- Wheels Locked is required'
			,2
			,7
		FROM CustomIncidentReportFallDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		LEFT JOIN GlobalCodes GG ON GG.GlobalCodeId = D.FallDetailsIncidentOccurredWhile
		WHERE ISNULL(D.FallDetailsWheelsLocked, '') = ''
			AND GG.Code = 'GETTINGUPFROMWHEELCHAIR'
		AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallDetails')
		
		UNION
		
		SELECT 'CustomIncidentReportFallDetails'
			,NULL
			,'Fall - Details- Getting in/out of bed is required'
			,2
			,8
		FROM CustomIncidentReportFallDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		LEFT JOIN GlobalCodes GG ON GG.GlobalCodeId = D.FallDetailsIncidentOccurredWhile
		WHERE (
				ISNULL(D.FallDetailsNA, '') = ''
				OR D.FallDetailsNA = 'N'
				)
			AND (
				ISNULL(D.FallDetailsFullLength, '') = ''
				OR D.FallDetailsFullLength = 'N'
				)
			AND (
				ISNULL(D.FallDetails2Half, '') = ''
				OR D.FallDetails2Half = 'N'
				)
			AND (
				ISNULL(D.FallDetails4Half, '') = ''
				OR D.FallDetails4Half = 'N'
				)
			AND (
				ISNULL(D.FallDetailsBothSidesUp, '') = ''
				OR D.FallDetailsBothSidesUp = 'N'
				)
			AND (
				ISNULL(D.FallDetailsOneSideUp, '') = ''
				OR D.FallDetailsOneSideUp = 'N'
				)
			AND (
				ISNULL(D.FallDetailsBumperPads, '') = ''
				OR D.FallDetailsBumperPads = 'N'
				)
			AND (
				ISNULL(D.FallDetailsFurtherDescription, '') = ''
				OR D.FallDetailsFurtherDescription = 'N'
				)
			AND GG.Code = 'GETTINGINOUTBED'
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallDetails')
		
		UNION
		
		SELECT 'CustomIncidentReportFallDetails'
			,'FallDetailsFurtherDescriptiontext'
			,'Fall - Details- Getting in/out of bed - Further description text box is required'
			,2
			,9
		FROM CustomIncidentReportFallDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(D.FallDetailsFurtherDescriptiontext, '') = ''
			AND FallDetailsFurtherDescription = 'Y'
		AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallDetails')
		
		UNION
		
		SELECT 'CustomIncidentReportFallDetails'
			,'FallDetailsFootwearAtTimeOfIncident'
			,'Fall - Details- Footwear at time of incident is required'
			,2
			,10
		FROM CustomIncidentReportFallDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(D.FallDetailsFootwearAtTimeOfIncident, '') = ''
		AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallDetails')
		
		UNION
		
		SELECT 'CustomIncidentReportFallDetails'
			,'FallDetailsWasAnAlarmPresent'
			,'Fall - Details- Was an alarm present is required'
			,2
			,11
		FROM CustomIncidentReportFallDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(D.FallDetailsWasAnAlarmPresent, '') = ''
		AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallDetails')
		
		UNION
		
		SELECT 'CustomIncidentReportFallDetails'
			,NULL
			,'Fall - Details- Type of alarm at least one checkbox is required'
			,2
			,12
		FROM CustomIncidentReportFallDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE (
				ISNULL(D.FallDetailsAlarmSoundedDuringIncident, '') = ''
				OR D.FallDetailsAlarmSoundedDuringIncident = 'N'
				)
			AND (
				ISNULL(D.FallDetailsAlarmDidNotSoundDuringIncident, '') = ''
				OR D.FallDetailsAlarmDidNotSoundDuringIncident = 'N'
				)
			AND (
				ISNULL(D.FallDetailsBedMat, '') = ''
				OR D.FallDetailsBedMat = 'N'
				)
			AND (
				ISNULL(D.FallDetailsBeam, '') = ''
				OR D.FallDetailsBeam = 'N'
				)
			AND (
				ISNULL(D.FallDetailsBabyMonitor, '') = ''
				OR D.FallDetailsBabyMonitor = 'N'
				)
			AND (
				ISNULL(D.FallDetailsFloorMat, '') = ''
				OR D.FallDetailsFloorMat = 'N'
				)
			AND (
				ISNULL(D.FallDetailsMagneticClip, '') = ''
				OR D.FallDetailsMagneticClip = 'N'
				)
			AND (
				ISNULL(D.FallDetailsTypeOfAlarmOtherText, '') = ''
				OR D.FallDetailsTypeOfAlarmOtherText = 'N'
				)
			AND FallDetailsWasAnAlarmPresent = 'Y'
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallDetails')
		
		UNION
		
		SELECT 'CustomIncidentReportFallDetails'
			,'FallDetailsTypeOfAlarmOther'
			,'Fall - Details- Type of alarm – other- text field is required'
			,2
			,13
		FROM CustomIncidentReportFallDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(D.FallDetailsTypeOfAlarmOther, '') = ''
			AND FallDetailsTypeOfAlarmOtherText = 'Y'
		AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallDetails')
		
		UNION
		
		SELECT 'CustomIncidentReportFallDetails'
			,'FallDetailsTypeOfAlarmOther'
			,'Fall - Details- Type of alarm – other- text field is required'
			,2
			,13
		FROM CustomIncidentReportFallDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(D.FallDetailsTypeOfAlarmOther, '') = ''
			AND FallDetailsTypeOfAlarmOtherText = 'Y'
		AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallDetails')
		
		UNION
		
		SELECT 'CustomIncidentReportFallDetails'
			,'FallDetailsDescriptionOfincident'
			,'Fall - Details- Description of incident is required'
			,2
			,14
		FROM CustomIncidentReportFallDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(D.FallDetailsDescriptionOfincident, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallDetails')
		
		UNION
		
		SELECT 'CustomIncidentReportFallDetails'
			,'FallDetailsActionsTakenByStaff'
			,'Fall - Details- Actions taken by staff is required'
			,2
			,15
		FROM CustomIncidentReportFallDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(D.FallDetailsActionsTakenByStaff, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallDetails')
		
		UNION
		
		SELECT 'CustomIncidentReportFallDetails'
			,'FallDetailsStaffNotifiedForInjury'
			,'Fall - Details- Staff notification  for injury is required'
			,2
			,16
		FROM CustomIncidentReportFallDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(D.FallDetailsStaffNotifiedForInjury, '') = ''
		AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallDetails')
		
		UNION
		
		SELECT 'CustomIncidentReportFallDetails'
			,'FallDetailsDateStaffNotified'
			,'Fall - Details- Date staff notified is required'
			,2
			,17
		FROM CustomIncidentReportFallDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(D.FallDetailsDateStaffNotified, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallDetails')
		
		UNION
		
		SELECT 'CustomIncidentReportFallDetails'
			,'FallDetailsTImeStaffNotified'
			,'Fall - Details- time staff notified is required'
			,2
			,18
		FROM CustomIncidentReportFallDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(D.FallDetailsTImeStaffNotified, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallDetails')
			
			UNION
		
		SELECT 'CustomIncidentReportFallDetails'
			,'FallDetailsSupervisorFlaggedId'
			,'Fall - Details– Supervisor to be Flagged for Review is required'
			,2
			,18
		FROM CustomIncidentReportFallDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(D.FallDetailsSupervisorFlaggedId, '') = ''
		AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallDetails')
		----Follow Up of Individual Status 
		
		UNION
		
		SELECT 'CustomIncidentReportFallFollowUpOfIndividualStatuses'
			,'FallFollowUpIndividualStatusNurseStaffEvaluating'
			,'Fall -Follow up of Individual status- Nurse/staff evaluating is required '
			,2
			,19
		FROM CustomIncidentReportFallFollowUpOfIndividualStatuses D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(D.FallFollowUpIndividualStatusNurseStaffEvaluating, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallIndividualStatus')
		
		UNION
		
		SELECT 'CustomIncidentReportFallFollowUpOfIndividualStatuses'
			,'FallFollowUpIndividualStatusCredentialTitle'
			,'Fall -Follow up of Individual status- Credential/title is required'
			,2
			,19
		FROM CustomIncidentReportFallFollowUpOfIndividualStatuses D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(D.FallFollowUpIndividualStatusCredentialTitle, '') = ''
		AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallIndividualStatus')
		
		UNION
		
		SELECT 'CustomIncidentReportFallFollowUpOfIndividualStatuses'
			,NULL
			,'Fall – Follow up of individual status – Treatment – is required'
			,2
			,20
		FROM CustomIncidentReportFallFollowUpOfIndividualStatuses D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE (
				ISNULL(D.FallFollowUpIndividualStatusNoTreatmentNoInjury, '') = ''
				OR D.FallFollowUpIndividualStatusNoTreatmentNoInjury = 'N'
				)
			AND (
				ISNULL(D.FallFollowUpIndividualStatusFirstAidOnly, '') = ''
				OR D.FallFollowUpIndividualStatusFirstAidOnly = 'N'
				)
			AND (
				ISNULL(D.FallFollowUpIndividualStatusMonitor, '') = ''
				OR D.FallFollowUpIndividualStatusMonitor = 'N'
				)
			AND (
				ISNULL(D.FallFollowUpIndividualStatusToPrimaryCareProviderClinicEvaluation, '') = ''
				OR D.FallFollowUpIndividualStatusToPrimaryCareProviderClinicEvaluation = 'N'
				)
			AND (
				ISNULL(D.FallFollowUpIndividualStatusToEmergencyRoom, '') = ''
				OR D.FallFollowUpIndividualStatusToEmergencyRoom = 'N'
				)
			AND (
				ISNULL(D.FallFollowUpIndividualStatusOther, '') = ''
				OR D.FallFollowUpIndividualStatusOther = 'N'
				)
		AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallIndividualStatus')
		
		UNION
		
		SELECT 'CustomIncidentReportFallFollowUpOfIndividualStatuses'
			,'FallFollowUpIndividualStatusOtherText'
			,'Fall – Follow up of individual status – Treatment –Other Text- is required'
			,2
			,20
		FROM CustomIncidentReportFallFollowUpOfIndividualStatuses D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(D.FallFollowUpIndividualStatusOtherText, '') = ''
			AND D.FallFollowUpIndividualStatusOther = 'Y'
		AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallIndividualStatus')
		
		UNION
		
		SELECT 'CustomIncidentReportFallFollowUpOfIndividualStatuses'
			,'FallFollowUpIndividualStatusDetailsOfInjury'
			,'Fall -Follow up of Individual status- Details of injury/illness and treatment provided is required'
			,2
			,21
		FROM CustomIncidentReportFallFollowUpOfIndividualStatuses D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(D.FallFollowUpIndividualStatusDetailsOfInjury, '') = ''
		AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallIndividualStatus')
		
		UNION
		
		SELECT 'CustomIncidentReportFallFollowUpOfIndividualStatuses'
			,'FallFollowUpIndividualStatusFamilyGuardianCustodianNotified'
			,'Fall - Follow up of Individual status-Family/Guardian/Custodian notified is required'
			,2
			,22
		FROM CustomIncidentReportFallFollowUpOfIndividualStatuses D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(D.FallFollowUpIndividualStatusFamilyGuardianCustodianNotified, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallIndividualStatus')
		
		UNION
		
		SELECT 'CustomIncidentReportFallFollowUpOfIndividualStatuses'
			,'FallFollowUpIndividualStatusDateOfNotification'
			,'Fall - Follow up of Individual status – Date of Notification is required'
			,2
			,23
		FROM CustomIncidentReportFallFollowUpOfIndividualStatuses D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(D.FallFollowUpIndividualStatusDateOfNotification, '') = ''
		AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND D.FallFollowUpIndividualStatusFamilyGuardianCustodianNotified = 'Y'
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallIndividualStatus')
		
		UNION
		
		SELECT 'CustomIncidentReportFallFollowUpOfIndividualStatuses'
			,'FollowUpIndividualStatusTimeOfNotification'
			,'Fall - Follow up of Individual status – Time of Notification is required'
			,2
			,24
		FROM CustomIncidentReportFallFollowUpOfIndividualStatuses D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(D.FallFollowUpIndividualStatusTimeOfNotification, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND D.FallFollowUpIndividualStatusFamilyGuardianCustodianNotified = 'Y'
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallIndividualStatus')
		
		UNION
		
		SELECT 'CustomIncidentReportFallFollowUpOfIndividualStatuses'
			,'FollowUpIndividualStatusStaffCompletedNotification'
			,'Fall - Follow up of Individual status – Staff who completed notification is required'
			,2
			,25
		FROM CustomIncidentReportFallFollowUpOfIndividualStatuses D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(D.FallFollowUpIndividualStatusStaffCompletedNotification, '') = ''
		AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND D.FallFollowUpIndividualStatusFamilyGuardianCustodianNotified = 'Y'
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallIndividualStatus')
		
		UNION
		
		SELECT 'CustomIncidentReportFallFollowUpOfIndividualStatuses'
			,'FollowUpIndividualStatusNameOfFamilyGuardianCustodian'
			,'Fall - Follow up of Individual status – Name of the family/guardian/custodian notified is required'
			,2
			,26
		FROM CustomIncidentReportFallFollowUpOfIndividualStatuses D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(D.FallFollowUpIndividualStatusNameOfFamilyGuardianCustodian, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallIndividualStatus')
			AND D.FallFollowUpIndividualStatusFamilyGuardianCustodianNotified = 'Y'
			UNION
		
		SELECT 'CustomIncidentReportFallFollowUpOfIndividualStatuses'
			,'FollowUpIndividualStatusNameOfFamilyGuardianCustodian'
			,'Fall - Follow up of Individual status – Details of Notification is required'
			,2
			,27
		FROM CustomIncidentReportFallFollowUpOfIndividualStatuses D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(D.FallFollowUpIndividualStatusDetailsOfNotification, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallIndividualStatus')
			AND D.FallFollowUpIndividualStatusFamilyGuardianCustodianNotified = 'Y'
		----Fall Supervisor Follow Up 
		
		UNION
		
		SELECT 'CustomIncidentReportFallSupervisorFollowUps'
			,'FallSupervisorFollowUpSupervisorName'
			,'Fall -Supervisor follow up- Supervisor name is required '
			,2
			,28
		FROM CustomIncidentReportFallSupervisorFollowUps D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(FallSupervisorFollowUpSupervisorName, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallSupervisorFollowUp')
		
		UNION
		
		SELECT 'CustomIncidentReportFallSupervisorFollowUps'
			,'FallSupervisorFollowUpFollowUp'
			,'Fall - Supervisor follow up-Follow up is required'
			,2
			,29
		FROM CustomIncidentReportFallSupervisorFollowUps D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(FallSupervisorFollowUpFollowUp, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallSupervisorFollowUp')
		
			UNION
		
		SELECT 'CustomIncidentReportFallSupervisorFollowUps'
			,'SupervisorFollowUpManagerNotified'
			,'Fall - Supervisor follow up - Manager Notified is required'
			,1
			,33
		FROM CustomIncidentReportFallSupervisorFollowUps U
		LEFT JOIN CustomIncidentReportGenerals G ON U.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(U.SupervisorFollowUpManagerNotified, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND G.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallSupervisorFollowUp')
			
			UNION
		
		SELECT 'CustomIncidentReportFallSupervisorFollowUps'
			,'SupervisorFollowUpManagerNotified'
			,'Fall - Supervisor follow up - Manager is required'
			,1
			,33
		FROM CustomIncidentReportFallSupervisorFollowUps U
		LEFT JOIN CustomIncidentReportGenerals G ON U.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(U.SupervisorFollowUpManagerNotified, '') = 'Y'
		    AND U.SupervisorFollowUpManager is null
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND G.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallSupervisorFollowUp')
			
			UNION
		
		SELECT 'CustomIncidentReportFallSupervisorFollowUps'
			,'SupervisorFollowUpManagerNotified'
			,'Fall - Supervisor follow up - Manager Date of notification is required'
			,1
			,33
		FROM CustomIncidentReportFallSupervisorFollowUps U
		LEFT JOIN CustomIncidentReportGenerals G ON U.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(U.SupervisorFollowUpManagerNotified, '') = 'Y'
		    AND U.SupervisorFollowUpManagerDateOfNotification is null
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND G.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallSupervisorFollowUp')
			UNION
		
		SELECT 'CustomIncidentReportFallSupervisorFollowUps'
			,'SupervisorFollowUpManagerNotified'
			,'Fall - Supervisor follow up - Manager Time of Notification is required'
			,1
			,33
		FROM CustomIncidentReportFallSupervisorFollowUps U
		LEFT JOIN CustomIncidentReportGenerals G ON U.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(U.SupervisorFollowUpManagerNotified, '') = 'Y'
		    AND U.SupervisorFollowUpManagerTimeOfNotification is null
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND G.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallSupervisorFollowUp')
		
		UNION
		
		SELECT 'CustomIncidentReportFallSupervisorFollowUps'
			,'FallSupervisorFollowUpAdministratorNotified'
			,'Fall -Supervisor follow up-Administrator notified is required'
			,2
			,30
		FROM CustomIncidentReportFallSupervisorFollowUps D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(FallSupervisorFollowUpAdministratorNotified, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallSupervisorFollowUp')
		
		UNION
		
		SELECT 'CustomIncidentReportFallSupervisorFollowUps'
			,'FallSupervisorFollowUpAdministrator'
			,'Fall - Supervisor follow up-Administrator is required'
			,2
			,31
		FROM CustomIncidentReportFallSupervisorFollowUps D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(FallSupervisorFollowUpAdministrator, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
				AND FallSupervisorFollowUpAdministratorNotified = 'Y'
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallSupervisorFollowUp')
		
		UNION
		
		SELECT 'CustomIncidentReportFallSupervisorFollowUps'
			,'FallSupervisorFollowUpAdminDateOfNotification'
			,'Fall - Supervisor follow up- Date of notification is required'
			,2
			,32
		FROM CustomIncidentReportFallSupervisorFollowUps D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(FallSupervisorFollowUpAdminDateOfNotification, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND FallSupervisorFollowUpAdministratorNotified = 'Y'
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallSupervisorFollowUp')
		
		UNION
		
		SELECT 'CustomIncidentReportFallSupervisorFollowUps'
			,'FallSupervisorFollowUpAdminTimeOfNotification'
			,'Fall - Supervisor follow up- Time of notification is required'
			,2
			,33
		FROM CustomIncidentReportFallSupervisorFollowUps D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(FallSupervisorFollowUpAdminTimeOfNotification, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND FallSupervisorFollowUpAdministratorNotified = 'Y'
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallSupervisorFollowUp')
		
		UNION
		
		SELECT 'CustomIncidentReportFallSupervisorFollowUps'
			,'FallSupervisorFollowUpFamilyGuardianCustodianNotified'
			,'Fall - Supervisor follow up-Family/Guardian/Custodian notified is required'
			,2
			,34
		FROM CustomIncidentReportFallSupervisorFollowUps D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(FallSupervisorFollowUpFamilyGuardianCustodianNotified, '') = ''
		AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallSupervisorFollowUp')
		
		UNION
		
		SELECT 'CustomIncidentReportFallSupervisorFollowUps'
			,'FallSupervisorFollowUpFGCDateOfNotification'
			,'Fall - Supervisor follow up- Date of notification is required'
			,2
			,35
		FROM CustomIncidentReportFallSupervisorFollowUps D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(FallSupervisorFollowUpFGCDateOfNotification, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND FallSupervisorFollowUpFamilyGuardianCustodianNotified = 'Y'
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallSupervisorFollowUp')
		
		UNION
		
		SELECT 'CustomIncidentReportFallSupervisorFollowUps'
			,'FallSupervisorFollowUpFGCTimeOfNotification'
			,'Fall - Supervisor follow up- Time of notification is required'
			,2
			,36
		FROM CustomIncidentReportFallSupervisorFollowUps D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(FallSupervisorFollowUpFGCTimeOfNotification, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND FallSupervisorFollowUpFamilyGuardianCustodianNotified = 'Y'
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallSupervisorFollowUp')
		
		UNION
		
		SELECT 'CustomIncidentReportFallSupervisorFollowUps'
			,'FallSupervisorFollowUpStaffCompletedNotification'
			,'Fall  - Supervisor follow up- Staff who completed notification is required'
			,2
			,37
		FROM CustomIncidentReportFallSupervisorFollowUps D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(FallSupervisorFollowUpStaffCompletedNotification, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND FallSupervisorFollowUpFamilyGuardianCustodianNotified = 'Y'
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallSupervisorFollowUp')
		
		UNION
		
		SELECT 'CustomIncidentReportFallSupervisorFollowUps'
			,'FallSupervisorFollowUpNameOfFamilyGuardianCustodian'
			,'Fall  - Supervisor follow up- Name of the family/guardian/custodian notified is required'
			,2
			,38
		FROM CustomIncidentReportFallSupervisorFollowUps D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(FallSupervisorFollowUpNameOfFamilyGuardianCustodian, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
				AND FallSupervisorFollowUpFamilyGuardianCustodianNotified = 'Y'
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallSupervisorFollowUp')
		UNION	
			SELECT 'CustomIncidentReportFallSupervisorFollowUps'
			,'FallSupervisorFollowUpNameOfFamilyGuardianCustodian'
			,'Fall  - Supervisor follow up- Details of Notification is required'
			,2
			,39
		FROM CustomIncidentReportFallSupervisorFollowUps D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(FallSupervisorFollowUpDetailsOfNotification, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
				AND FallSupervisorFollowUpFamilyGuardianCustodianNotified = 'Y'
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallSupervisorFollowUp')
		----Administrator Review 
		---------------- Manager Review ------------------------------
		UNION
		SELECT 'CustomIncidentReportFallManagerFollowUps'
			,'ManagerFollowUpManagerId'
			,'Fall - Manager Review – Manager is required'
			,1
			,33
		FROM CustomIncidentReportFallSupervisorFollowUps U
		LEFT JOIN CustomIncidentReportGenerals G ON U.IncidentReportId = G.IncidentReportId
		left join CustomIncidentReportFallManagerFollowUps mf on u.IncidentReportId = mf.IncidentReportId 
		WHERE ISNULL(U.SupervisorFollowUpManagerNotified, '') = 'Y'
		    AND mf.ManagerFollowUpManagerId is null
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND G.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallManagerFollowUp')
			
		UNION
		SELECT 'CustomIncidentReportFallManagerFollowUps'
			,'ManagerFollowUpAdministrator'
			,'Fall - Manager Review – Administrator is required when Administrator Notified is answered Yes. '
			,1
			,33
		FROM CustomIncidentReportFallManagerFollowUps U
		LEFT JOIN CustomIncidentReportGenerals G ON U.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(U.ManagerFollowUpAdministratorNotified, '') = 'Y'
		    AND U.ManagerFollowUpAdministrator is null
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					 
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND G.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallManagerFollowUp')
			
		UNION
		SELECT 'CustomIncidentReportFallManagerFollowUps'
			,'ManagerFollowUpAdminDateOfNotification'
			,'Fall - Manager Review – Date of Notification is required when Administrator Notified is answered Yes.'
			,1
			,33
		FROM CustomIncidentReportFallManagerFollowUps U
		LEFT JOIN CustomIncidentReportGenerals G ON U.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(U.ManagerFollowUpAdministratorNotified, '') = 'Y'
		    AND U.ManagerFollowUpAdminDateOfNotification is null
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					 
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND G.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallManagerFollowUp')
			
		UNION
		SELECT 'CustomIncidentReportFallManagerFollowUps'
			,'ManagerFollowUpAdminTimeOfNotification'
			,'Fall - Manager Review – Time of Notification is required when Administrator Notified is answered Yes.'
			,1
			,33
		FROM CustomIncidentReportFallManagerFollowUps U
		LEFT JOIN CustomIncidentReportGenerals G ON U.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(U.ManagerFollowUpAdministratorNotified, '') = 'Y'
		    AND U.ManagerFollowUpAdminTimeOfNotification is null
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTOTHER')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
				   G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENT')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
					 
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				
				)
			AND G.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallManagerFollowUp')
		UNION
		
		SELECT 'CustomIncidentReportFallAdministratorReviews'
			,'FallAdministratorReviewAdministrator'
			,'Fall - Administrator Review- Administrator is required'
			,2
			,40
		FROM CustomIncidentReportFallAdministratorReviews A
		LEFT JOIN CustomIncidentReportFallSupervisorFollowUps S ON S.IncidentReportId = A.IncidentReportId
		LEFT JOIN CustomIncidentReportGenerals G ON A.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(A.FallAdministratorReviewAdministrator, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTSEIZURE')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLOTHER'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND S.FallSupervisorFollowUpAdministratorNotified = 'Y'
			AND A.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallAdministrators')
		
		UNION
		
		SELECT 'CustomIncidentReportFallAdministratorReviews'
			,'FallAdministratorReviewAdministrativeReview'
			,'Fall - Administrator Review- Administrator review is required'
			,2
			,41
		FROM CustomIncidentReportFallAdministratorReviews A
		LEFT JOIN CustomIncidentReportFallSupervisorFollowUps S ON S.IncidentReportId = A.IncidentReportId
		LEFT JOIN CustomIncidentReportGenerals G ON A.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(A.FallAdministratorReviewAdministrativeReview, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTSEIZURE')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLOTHER'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND S.FallSupervisorFollowUpAdministratorNotified = 'Y'
			AND A.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallAdministrators')
		
		UNION
		
		SELECT 'CustomIncidentReportFallAdministratorReviews'
			,'FallAdministratorReviewFiledReportableIncident'
			,'Fall - Administrator Review-Filed Reportable Incident is required'
			,2
			,42
		FROM CustomIncidentReportFallAdministratorReviews D
		LEFT JOIN CustomIncidentReportFallSupervisorFollowUps S ON S.IncidentReportId = D.IncidentReportId
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(FallAdministratorReviewFiledReportableIncident, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTFALL')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTSEIZURE')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'FALL'
								OR Code = 'FALLOTHER'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'FallAdministrators')
			AND S.FallSupervisorFollowUpAdministratorNotified = 'Y'
		--/********************************************************************SeizureTab**********************************************************************/ --Seizure
		
		UNION
		
		SELECT 'CustomIncidentReportSeizureDetails'
			,'SeizureDetailsSweating'
			,'Seizure - General– Sweating is required'
			,3
			,1
		FROM CustomIncidentReportSeizureDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(SeizureDetailsSweating, '') = ''
		AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'SEIZUREOTHER'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (
				@ButtonClicked = 'SeizureDetails'
				)
		
		UNION
		
		SELECT 'CustomIncidentReportSeizureDetails'
			,'SeizureDetailsUrinaryFecalIncontinence'
			,'Seizure - General- Urinary/Fecal Incontinence is required'
			,3
			,2
		FROM CustomIncidentReportSeizureDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(SeizureDetailsUrinaryFecalIncontinence, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'SEIZUREOTHER'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (
				@ButtonClicked = 'SeizureDetails'
				)
		
		UNION
		
		SELECT 'CustomIncidentReportSeizureDetails'
			,'SeizureDetailsTonicStiffnessOfArms'
			,'Seizure - General-(Tonic) Stiffness of Arms is required'
			,3
			,3
		FROM CustomIncidentReportSeizureDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(SeizureDetailsTonicStiffnessOfArms, '') = ''
		AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'SEIZUREOTHER'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (
				@ButtonClicked = 'SeizureDetails'
				)
		
		UNION
		
		SELECT 'CustomIncidentReportSeizureDetails'
			,'SeizureDetailsTonicStiffnessOfLegs'
			,'Seizure - General- (Tonic) Stiffness of Legs is required'
			,3
			,4
		FROM CustomIncidentReportSeizureDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(SeizureDetailsTonicStiffnessOfLegs, '') = ''
		AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'SEIZUREOTHER'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (
				@ButtonClicked = 'SeizureDetails'
				)
		
		UNION
		
		SELECT 'CustomIncidentReportSeizureDetails'
			,'SeizureDetailsClonicTwitchingOfArms'
			,'Seizure - General- (Clonic) Twitching of Arms is required'
			,3
			,5
		FROM CustomIncidentReportSeizureDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(SeizureDetailsClonicTwitchingOfArms, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'SEIZUREOTHER'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (
				@ButtonClicked = 'SeizureDetails'
				)
		
		UNION
		
		SELECT 'CustomIncidentReportSeizureDetails'
			,'SeizureDetailsClonicTwitchingOfLegs'
			,'Seizure - General- (Clonic) Twitching of Legs is required'
			,3
			,6
		FROM CustomIncidentReportSeizureDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(SeizureDetailsClonicTwitchingOfLegs, '') = ''
		AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'SEIZUREOTHER'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (
				@ButtonClicked = 'SeizureDetails'
				)
		
		UNION
		
		SELECT 'CustomIncidentReportSeizureDetails'
			,'SeizureDetailsPupilsDilated'
			,'Seizure - General-Pupils Dilated is required'
			,3
			,7
		FROM CustomIncidentReportSeizureDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(SeizureDetailsPupilsDilated, '') = ''
		AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'SEIZUREOTHER'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (
				@ButtonClicked = 'SeizureDetails'
				)
		
		UNION
		
		SELECT 'CustomIncidentReportSeizureDetails'
			,'SeizureDetailsAnyAbnormalEyeMovements'
			,'Seizure - General- Any abnormal eye movements is required'
			,3
			,8
		FROM CustomIncidentReportSeizureDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(SeizureDetailsAnyAbnormalEyeMovements, '') = ''
		AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'SEIZUREOTHER'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (
				@ButtonClicked = 'SeizureDetails'
				)
		
		UNION
		
		SELECT 'CustomIncidentReportSeizureDetails'
			,'SeizureDetailsPostictalPeriod'
			,'Seizure - General - Postictal period is required'
			,3
			,9
		FROM CustomIncidentReportSeizureDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(SeizureDetailsPostictalPeriod, '') = ''
		AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'SEIZUREOTHER'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (
				@ButtonClicked = 'SeizureDetails'
				)
		
		UNION
		
		SELECT 'CustomIncidentReportSeizureDetails'
			,'SeizureDetailsVagalNerveStimulator'
			,'Seizure - General -  Vagal nerve stimulator (VNS) is required'
			,3
			,10
		FROM CustomIncidentReportSeizureDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(SeizureDetailsVagalNerveStimulator, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'SEIZUREOTHER'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (
				@ButtonClicked = 'SeizureDetails'
				)
		
		UNION
		
		SELECT 'CustomIncidentReportSeizureDetails'
			,'SeizureDetailsSwipedMagnet'
			,'Seizure - General - Swiped magnet is required'
			,3
			,11
		FROM CustomIncidentReportSeizureDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(SeizureDetailsSwipedMagnet, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'SEIZUREOTHER'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (
				@ButtonClicked = 'SeizureDetails'
				)
		
		UNION
		
		SELECT 'CustomIncidentReportSeizureDetails'
			,'SeizureDetailsNumberOfSwipes'
			,'Seizure - General -  Number of swipes is required'
			,3
			,12
		FROM CustomIncidentReportSeizureDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		Left Join GlobalCodes GG ON GG.GlobalCodeId=D.SeizureDetailsSwipedMagnet
		WHERE ISNULL(SeizureDetailsNumberOfSwipes, '') = ''
		    AND GG.Code='YES'
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'SEIZUREOTHER'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (
				@ButtonClicked = 'SeizureDetails'
				)
		
		UNION
		
		--SELECT 'CustomIncidentReportSeizureDetails'
		--	,'SeizureDetailsPulseRate'
		--	,'Seizure - General - Pulse rate is required'
		--	,3
		--	,13
		--FROM CustomIncidentReportSeizureDetails D
		--LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		--WHERE ISNULL(SeizureDetailsPulseRate, '') = ''
		--	AND (
		--		G.GeneralIncidentCategory IN (
		--			SELECT GlobalCodeId
		--			FROM GlobalCodes
		--			WHERE (Code = 'INCIDENTSEIZURE')
		--				AND ISNULL(RecordDeleted, 'N') = 'N'
		--			)
		--		OR (
		--			G.GeneralIncidentCategory IN (
		--				SELECT GlobalCodeId
		--				FROM GlobalCodes
		--				WHERE (Code = 'INCIDENTOTHER')
		--					AND ISNULL(RecordDeleted, 'N') = 'N'
		--				)
		--			)
		--		OR (
		--			G.GeneralIncidentCategory IN (
		--				SELECT GlobalCodeId
		--				FROM GlobalCodes
		--				WHERE (Code = 'INCIDENT')
		--					AND ISNULL(RecordDeleted, 'N') = 'N'
		--				)
		--			AND G.GeneralSecondaryCategory IN (
		--				SELECT GlobalSubCodeId
		--				FROM GlobalSubCodes
		--				WHERE (
		--						Code = 'SEIZURE'
		--						OR Code = 'SEIZUREOTHER'
		--						)
		--					AND ISNULL(RecordDeleted, 'N') = 'N'
		--				)
		--			)
		--		)
		--	AND D.IncidentReportId = @ScreenKeyId
		--	AND (
		--		@ButtonClicked = 'SeizureDetails'
		--		)
		
		--UNION
		
		SELECT 'CustomIncidentReportSeizureDetails'
			,'SeizureDetailsBreathing'
			,'Seizure - General - Breathing is required'
			,3
			,14
		FROM CustomIncidentReportSeizureDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(SeizureDetailsBreathing, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'SEIZUREOTHER'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (
				@ButtonClicked = 'SeizureDetails'
				)
		
		UNION
		
		SELECT 'CustomIncidentReportSeizureDetails'
			,'SeizureDetailsColor'
			,'Seizure - General - Color is required'
			,3
			,15
		FROM CustomIncidentReportSeizureDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(SeizureDetailsColor, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'SEIZUREOTHER'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (
				@ButtonClicked = 'SeizureDetails'
				)
		
		UNION
		
		SELECT 'CustomIncidentReportSeizureDetails'
			,NULL
			,'Seizure - General - Seizure action taken is required'
			,3
			,16
		FROM CustomIncidentReportSeizureDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(SeizureDetailsTurnClientsHeadSide, 'N') = 'N'
			AND ISNULL(SeizureDetailsClientSuctioned, 'N') = 'N'
			AND ISNULL(SeizureDetailsClothingLoosended, 'N') = 'N'
			AND ISNULL(SeizureDetailsAirwayCleared, 'N') = 'N'
			--AND ISNULL(SeizureDetailsO2Given, 'N') = 'N'
			AND ISNULL(SeizureDetailsPlacedClientOnTheFloor, 'N') = 'N'
			--AND ISNULL(SeizureDetailsEmergencyMedicationsGiven, 'N') = 'N'
			AND ISNULL(SeizureDetailsPutClientToBed, 'N') = 'N'
			AND ISNULL(SeizureDetailsAreaCleared, 'N') = 'N'
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'SEIZUREOTHER'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (
				@ButtonClicked = 'SeizureDetails'
				)
		
	
		----Custom Grid
		
		UNION
		
		SELECT 'CustomIncidentReportSeizureDetails'
			,'TimeOfSeizure'
			,'Seizure - General – Time of seizure is required'
			,3
			,18
		FROM CustomIncidentReportSeizures CIS
		LEFT JOIN CustomIncidentReportSeizureDetails CID ON CID.IncidentReportSeizureDetailId = CIS.IncidentReportSeizureDetailId
		LEFT JOIN CustomIncidentReportGenerals G ON CID.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(CIS.TimeOfSeizure, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'SEIZUREOTHER'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND G.IncidentReportId = @ScreenKeyId
			AND (
				@ButtonClicked = 'SeizureDetails'
				)
			AND ISNULL(CIS.RecordDeleted, 'N') = 'N'
		--UNION
		--SELECT 'CustomIncidentReportSeizureDetails'
		--	,NULL
		--	,'Seizure - General – Duration of seizure is required in either minutes or seconds'
		--	,3
		--	,19
		--FROM CustomIncidentReportSeizures CIS
		--LEFT JOIN CustomIncidentReportSeizureDetails CID ON CID.IncidentReportSeizureDetailId = CIS.IncidentReportSeizureDetailId
		--LEFT JOIN CustomIncidentReportGenerals G ON CID.IncidentReportId = G.IncidentReportId
		--WHERE ISNULL(CIS.DurationOfSeizureMin, '') = ''
		--	AND ISNULL(CIS.DurationOfSeizureSec, '') = ''
		--	AND (
		--		G.GeneralIncidentCategory IN (
		--			SELECT GlobalCodeId
		--			FROM GlobalCodes
		--			WHERE (Code = 'INCIDENTSEIZURE')
		--				AND ISNULL(RecordDeleted, 'N') = 'N'
		--			)
		--		OR (
		--			G.GeneralIncidentCategory IN (
		--				SELECT GlobalCodeId
		--				FROM GlobalCodes
		--				WHERE (Code = 'INCIDENTOTHER')
		--					AND ISNULL(RecordDeleted, 'N') = 'N'
		--				)
		--			AND G.GeneralSecondaryCategory IN (
		--				SELECT GlobalSubCodeId
		--				FROM GlobalSubCodes
		--				WHERE (
		--						Code = 'SEIZURE'
		--						OR Code = 'FALLSEIZURE'
		--						)
		--					AND ISNULL(RecordDeleted, 'N') = 'N'
		--				)
		--			)
		--		OR (
		--			G.GeneralIncidentCategory IN (
		--				SELECT GlobalCodeId
		--				FROM GlobalCodes
		--				WHERE (Code = 'INCIDENTFALL')
		--					AND ISNULL(RecordDeleted, 'N') = 'N'
		--				)
		--			AND G.GeneralSecondaryCategory IN (
		--				SELECT GlobalSubCodeId
		--				FROM GlobalSubCodes
		--				WHERE (
		--						Code = 'SEIZURE'
		--						OR Code = 'SEIZUREOTHER'
		--						)
		--					AND ISNULL(RecordDeleted, 'N') = 'N'
		--				)
		--			)
		--		)
		--	AND CID.IncidentReportId = @ScreenKeyId
		--	AND ISNULL(CIS.RecordDeleted, 'N') = 'N'
		----Details   
		
		UNION
		
		SELECT 'CustomIncidentSeizureDetails'
			,'IncidentSeizureDetailsDescriptionOfIncident'
			,'Seizure - Details- Description of incident is required'
			,3
			,20
		FROM CustomIncidentSeizureDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(IncidentSeizureDetailsDescriptionOfIncident, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'SEIZUREOTHER'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (
				@ButtonClicked = 'SeizureDetails'
				)
		
		UNION
		
		SELECT 'CustomIncidentSeizureDetails'
			,'IncidentSeizureDetailsActionsTakenByStaff'
			,'Seizure - Details- Actions taken by staff is required'
			,3
			,21
		FROM CustomIncidentSeizureDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(IncidentSeizureDetailsActionsTakenByStaff, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'SEIZUREOTHER'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (
				@ButtonClicked = 'SeizureDetails'
				)
		
		UNION
		
		SELECT 'CustomIncidentSeizureDetails'
			,'IncidentSeizureDetailsStaffNotifiedForInjury'
			,'Seizure - Details- Staff notification  for injury is required'
			,3
			,22
		FROM CustomIncidentSeizureDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(IncidentSeizureDetailsStaffNotifiedForInjury, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'SEIZUREOTHER'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (
				@ButtonClicked = 'SeizureDetails'
				)
		
		UNION
		
		SELECT 'CustomIncidentSeizureDetails'
			,'IncidentSeizureDetailsDateStaffNotified'
			,'Seizure - Details- Date staff notified is required'
			,3
			,23
		FROM CustomIncidentSeizureDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(IncidentSeizureDetailsDateStaffNotified, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'SEIZUREOTHER'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (
				@ButtonClicked = 'SeizureDetails'
				)
			
					
			UNION
		
		SELECT 'CustomIncidentSeizureDetails'
			,'IncidentSeizureDetailsSupervisorFlaggedId'
			,'Seizure - Details– Supervisor to be Flagged for Review is required'
			,3
			,24
		FROM CustomIncidentSeizureDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(IncidentSeizureDetailsSupervisorFlaggedId, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'SEIZUREOTHER'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (
				@ButtonClicked = 'SeizureDetails'
				)
		
		UNION
		
		SELECT 'CustomIncidentSeizureDetails'
			,'IncidentSeizureDetailsTimeStaffNotified'
			,'Seizure - Details- Time staff notified is required'
			,3
			,24
		FROM CustomIncidentSeizureDetails D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(IncidentSeizureDetailsTimeStaffNotified, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'SEIZUREOTHER'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (
				@ButtonClicked = 'SeizureDetails'
				)
		---------------Seizure--------------------Follow Up of Individual Status-----------  
		
		UNION
		
		SELECT 'CustomIncidentReportSeizureFollowUpOfIndividualStatuses'
			,'SeizureFollowUpIndividualStatusNurseStaffEvaluating'
			,'Seizure - Follow up of Individual status- Nurse/staff evaluating is required '
			,3
			,25
		FROM CustomIncidentReportSeizureFollowUpOfIndividualStatuses D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(SeizureFollowUpIndividualStatusNurseStaffEvaluating, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SeizureIndividualStatus')
		
		UNION
		
		SELECT 'CustomIncidentReportSeizureFollowUpOfIndividualStatuses'
			,'SeizureFollowUpIndividualStatusCredentialTitle'
			,'Seizure - Follow up of Individual status- Credential/title is required'
			,3
			,26
		FROM CustomIncidentReportSeizureFollowUpOfIndividualStatuses D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(SeizureFollowUpIndividualStatusCredentialTitle, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SeizureIndividualStatus')
		
		UNION
		
		SELECT 'CustomIncidentReportSeizureFollowUpOfIndividualStatuses'
			,'SeizureFollowUpIndividualStatusDetailsOfInjury'
			,'Seizure - Follow up of Individual status- Details of injury/illness and treatment provided is required'
			,3
			,27
		FROM CustomIncidentReportSeizureFollowUpOfIndividualStatuses D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(SeizureFollowUpIndividualStatusDetailsOfInjury, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SeizureIndividualStatus')
		
		UNION
		
		SELECT 'CustomIncidentReportSeizureFollowUpOfIndividualStatuses'
			,'SeizureDetailsLiterMin'
			,'Seizure - General - O2 Liter/Min is required'
			,3
			,17
		FROM CustomIncidentReportSeizureFollowUpOfIndividualStatuses D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(SeizureDetailsLiterMin, '') = ''
			AND SeizureDetailsO2Given = 'Y'
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (
				@ButtonClicked = 'SeizureDetails'
				)
		
		UNION
		
		SELECT 'CustomIncidentReportSeizureFollowUpOfIndividualStatuses'
			,'SeizureFollowUpIndividualStatusFamilyGuardianCustodianNotified'
			,'Seizure - Follow up of Individual status-Family/Guardian/Custodian notified is required'
			,3
			,28
		FROM CustomIncidentReportSeizureFollowUpOfIndividualStatuses D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(SeizureFollowUpIndividualStatusFamilyGuardianCustodianNotified, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SeizureIndividualStatus')
		
		UNION
		
		SELECT 'CustomIncidentReportSeizureFollowUpOfIndividualStatuses'
			,'SeizureFollowUpIndividualStatusDateOfNotification'
			,'Seizure - Follow up of Individual status – Date of Notification is required'
			,3
			,29
		FROM CustomIncidentReportSeizureFollowUpOfIndividualStatuses D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(SeizureFollowUpIndividualStatusDateOfNotification, '') = ''
			AND SeizureFollowUpIndividualStatusFamilyGuardianCustodianNotified = 'Y'
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SeizureIndividualStatus')
		
		UNION
		
		SELECT 'CustomIncidentReportSeizureFollowUpOfIndividualStatuses'
			,'FollowUpIndividualStatusTimeOfNotification'
			,'Seizure - Follow up of Individual status – Time of Notification is required'
			,3
			,30
		FROM CustomIncidentReportSeizureFollowUpOfIndividualStatuses D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(SeizureFollowUpIndividualStatusTimeOfNotification, '') = ''
			AND SeizureFollowUpIndividualStatusFamilyGuardianCustodianNotified = 'Y'
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SeizureIndividualStatus')
		
		UNION
		
		SELECT 'CustomIncidentReportSeizureFollowUpOfIndividualStatuses'
			,'FollowUpIndividualStatusStaffCompletedNotification'
			,'Seizure - Follow up of Individual status – Staff who completed notification is required'
			,3
			,31
		FROM CustomIncidentReportSeizureFollowUpOfIndividualStatuses D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(SeizureFollowUpIndividualStatusStaffCompletedNotification, '') = ''
		AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND SeizureFollowUpIndividualStatusFamilyGuardianCustodianNotified = 'Y'
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SeizureIndividualStatus')
		
		UNION
		
		SELECT 'CustomIncidentReportSeizureFollowUpOfIndividualStatuses'
			,'FollowUpIndividualStatusNameOfFamilyGuardianCustodian'
			,'Seizure - Follow up of Individual status – Name of the family/guardian/custodian notified is required'
			,3
			,32
		FROM CustomIncidentReportSeizureFollowUpOfIndividualStatuses D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(SeizureFollowUpIndividualStatusNameOfFamilyGuardianCustodian, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND SeizureFollowUpIndividualStatusFamilyGuardianCustodianNotified = 'Y'
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SeizureIndividualStatus')
			
		UNION
		
		SELECT 'CustomIncidentReportSeizureFollowUpOfIndividualStatuses'
			,'FollowUpIndividualStatusNameOfFamilyGuardianCustodian'
			,'Seizure - Follow up of Individual status – Details of Notification is required'
			,3
			,33
		FROM CustomIncidentReportSeizureFollowUpOfIndividualStatuses D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(SeizureFollowUpIndividualStatusDetailsOfNotification, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND SeizureFollowUpIndividualStatusFamilyGuardianCustodianNotified = 'Y'
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SeizureIndividualStatus')
			
			UNION
		
		SELECT 'CustomIncidentReportSeizureFollowUpOfIndividualStatuses'
			,'FollowUpIndividualStatusNameOfFamilyGuardianCustodian'
			,'Seizure - Follow up of Individual status – Note Start date is required when Note Type is selected.'
			,3
			,33
		FROM CustomIncidentReportSeizureFollowUpOfIndividualStatuses D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE D.NoteStart is null
		    AND isnull(NoteType,0) >0
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SeizureIndividualStatus')
			
			UNION
			
			SELECT 'CustomIncidentReportSeizureFollowUpOfIndividualStatuses'
			,'FollowUpIndividualStatusNameOfFamilyGuardianCustodian'
			,'Seizure - Follow up of Individual status – Note End date is required when Note Type is selected.'
			,3
			,33
		FROM CustomIncidentReportSeizureFollowUpOfIndividualStatuses D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE D.NoteEnd is null
		    AND isnull(NoteType,0) >0
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SeizureIndividualStatus')
			
				UNION
			
			SELECT 'CustomIncidentReportSeizureFollowUpOfIndividualStatuses'
			,'FollowUpIndividualStatusNameOfFamilyGuardianCustodian'
			,'Seizure - Follow up of Individual status – Note Comment is required when Note Type is selected.'
			,3
			,34
		FROM CustomIncidentReportSeizureFollowUpOfIndividualStatuses D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE isnull(D.NoteComment,'') = ''
		    AND isnull(NoteType,0) >0
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SeizureIndividualStatus')
			
			
		----Fall Supervisor Follow Up
		
		UNION
		
		SELECT 'CustomIncidentReportSeizureSupervisorFollowUps'
			,'SeizureSupervisorFollowUpSupervisorName'
			,'Seizure - Supervisor follow up- Supervisor name is required '
			,3
			,34
		FROM CustomIncidentReportSeizureSupervisorFollowUps D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(SeizureSupervisorFollowUpSupervisorName, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SeizureSupervisorFollowUp')
		
		UNION
		
		SELECT 'CustomIncidentReportSeizureSupervisorFollowUps'
			,'SeizureSupervisorFollowUpFollowUp'
			,'Seizure - Supervisor follow up-Follow up is required'
			,3
			,35
		FROM CustomIncidentReportSeizureSupervisorFollowUps D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(SeizureSupervisorFollowUpFollowUp, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SeizureSupervisorFollowUp')
		
		UNION
		
		SELECT 'CustomIncidentReportSeizureSupervisorFollowUps'
			,'SeizureSupervisorFollowUpAdministratorNotified'
			,'Seizure - Supervisor follow up-Administrator notified is required'
			,3
			,36
		FROM CustomIncidentReportSeizureSupervisorFollowUps D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(SeizureSupervisorFollowUpAdministratorNotified, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SeizureSupervisorFollowUp')
		
		UNION
		
		SELECT 'CustomIncidentReportSeizureSupervisorFollowUps'
			,'SeizureSupervisorFollowUpAdministrator'
			,'Seizure - Supervisor follow up-Administrator is required'
			,3
			,37
		FROM CustomIncidentReportSeizureSupervisorFollowUps D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(SeizureSupervisorFollowUpAdministrator, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
				AND SeizureSupervisorFollowUpAdministratorNotified = 'Y'
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SeizureSupervisorFollowUp')
		
		UNION
		
		SELECT 'CustomIncidentReportSeizureSupervisorFollowUps'
			,'SeizureSupervisorFollowUpAdminDateOfNotification'
			,'Seizure - Supervisor follow up- Date of notification is required'
			,3
			,38
		FROM CustomIncidentReportSeizureSupervisorFollowUps D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(SeizureSupervisorFollowUpAdminDateOfNotification, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND SeizureSupervisorFollowUpAdministratorNotified = 'Y'
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SeizureSupervisorFollowUp')
		
		UNION
		
		SELECT 'CustomIncidentReportSeizureSupervisorFollowUps'
			,'SeizureSupervisorFollowUpAdminTimeOfNotification'
			,'Seizure - Supervisor follow up- Time of notification is required'
			,3
			,39
		FROM CustomIncidentReportSeizureSupervisorFollowUps D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(SeizureSupervisorFollowUpAdminTimeOfNotification, '') = ''
		AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND SeizureSupervisorFollowUpAdministratorNotified = 'Y'
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SeizureSupervisorFollowUp')
		
		UNION
		
		SELECT 'CustomIncidentReportSeizureSupervisorFollowUps'
			,'SeizureSupervisorFollowUpFamilyGuardianCustodianNotified'
			,'Seizure - Supervisor follow up-Family/Guardian/Custodian notified is required'
			,3
			,40
		FROM CustomIncidentReportSeizureSupervisorFollowUps D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(SeizureSupervisorFollowUpFamilyGuardianCustodianNotified, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SeizureSupervisorFollowUp')
		
		UNION
		
		SELECT 'CustomIncidentReportSeizureSupervisorFollowUps'
			,'SeizureSupervisorFollowUpFGCDateOfNotification'
			,'Seizure - Supervisor follow up- Date of notification is required'
			,3
			,41
		FROM CustomIncidentReportSeizureSupervisorFollowUps D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(SeizureSupervisorFollowUpFGCDateOfNotification, '') = ''
			AND SeizureSupervisorFollowUpFamilyGuardianCustodianNotified = 'Y'
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SeizureSupervisorFollowUp')
		
		UNION
		
		SELECT 'CustomIncidentReportSeizureSupervisorFollowUps'
			,'SeizureSupervisorFollowUpFGCTimeOfNotification'
			,'Seizure - Supervisor follow up- Time of notification is required'
			,3
			,42
		FROM CustomIncidentReportSeizureSupervisorFollowUps D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(SeizureSupervisorFollowUpFGCTimeOfNotification, '') = ''
			AND SeizureSupervisorFollowUpFamilyGuardianCustodianNotified = 'Y'
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SeizureSupervisorFollowUp')
		
		UNION
		
		SELECT 'CustomIncidentReportSeizureSupervisorFollowUps'
			,'SeizureSupervisorFollowUpStaffCompletedNotification'
			,'Seizure - Supervisor follow up- Staff who completed notification is required'
			,3
			,43
		FROM CustomIncidentReportSeizureSupervisorFollowUps D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(SeizureSupervisorFollowUpStaffCompletedNotification, '') = ''
			AND SeizureSupervisorFollowUpFamilyGuardianCustodianNotified = 'Y'
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SeizureSupervisorFollowUp')
		
		UNION
		
		SELECT 'CustomIncidentReportSeizureSupervisorFollowUps'
			,'SeizureSupervisorFollowUpNameOfFamilyGuardianCustodian'
			,'Seizure - Supervisor follow up- Name of the family/guardian/custodian notified is required'
			,3
			,44
		FROM CustomIncidentReportSeizureSupervisorFollowUps D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(SeizureSupervisorFollowUpNameOfFamilyGuardianCustodian, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
				AND SeizureSupervisorFollowUpFamilyGuardianCustodianNotified = 'Y'
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SeizureSupervisorFollowUp')
		
		UNION
		
		SELECT 'CustomIncidentReportSeizureSupervisorFollowUps'
			,'SeizureSupervisorFollowUpNameOfFamilyGuardianCustodian'
			,'Seizure - Supervisor follow up- Details of Notification is required'
			,3
			,45
		FROM CustomIncidentReportSeizureSupervisorFollowUps D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(SeizureSupervisorFollowUpDetailsOfNotification, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
				AND SeizureSupervisorFollowUpFamilyGuardianCustodianNotified = 'Y'
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SeizureSupervisorFollowUp')
			
			UNION
		
		SELECT 'CustomIncidentReportSeizureSupervisorFollowUps'
			,'SupervisorFollowUpManagerNotified'
			,'Seizure - Supervisor follow up- Manager Notified is required'
			,3
			,45
		FROM CustomIncidentReportSeizureSupervisorFollowUps D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(SupervisorFollowUpManagerNotified, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SeizureSupervisorFollowUp')
			
			UNION 
				SELECT 'CustomIncidentReportSeizureSupervisorFollowUps'
			,'SupervisorFollowUpManager'
			,'Seizure - Supervisor Follow Up – Manager is required.'
			,3
			,45
		FROM CustomIncidentReportSeizureSupervisorFollowUps D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(SupervisorFollowUpManagerNotified, '') = 'Y'
		    AND SupervisorFollowUpManager IS NULL
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SeizureSupervisorFollowUp')
			
			
			UNION 
				SELECT 'CustomIncidentReportSeizureSupervisorFollowUps'
			,'SupervisorFollowUpManager'
			,'Seizure - Supervisor Follow Up – Manager Date of notification is required.'
			,3
			,45
		FROM CustomIncidentReportSeizureSupervisorFollowUps D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(SupervisorFollowUpManagerNotified, '') = 'Y'
		    AND SupervisorFollowUpManagerDateOfNotification IS NULL
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SeizureSupervisorFollowUp')
			
		UNION 
				SELECT 'CustomIncidentReportSeizureSupervisorFollowUps'
			,'SupervisorFollowUpManagerTimeOfNotification'
			,'Seizure - Supervisor Follow Up – Manager Time of notification is required.'
			,3
			,45
		FROM CustomIncidentReportSeizureSupervisorFollowUps D
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(SupervisorFollowUpManagerNotified, '') = 'Y'
		    AND SupervisorFollowUpManagerTimeOfNotification IS NULL
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SeizureSupervisorFollowUp')
		---------------- Manager Review ------------------------------
		UNION
		SELECT 'CustomIncidentReportSeizureManagerFollowUps'
			,'ManagerFollowUpManagerId'
			,'Seizure - Manager Review – Manager is required'
			,1
			,33
		FROM CustomIncidentReportSeizureSupervisorFollowUps U
		LEFT JOIN CustomIncidentReportGenerals G ON U.IncidentReportId = G.IncidentReportId
		left join CustomIncidentReportSeizureManagerFollowUps mf on u.IncidentReportId = mf.IncidentReportId 
		WHERE ISNULL(U.SupervisorFollowUpManagerNotified, '') = 'Y'
		    AND mf.ManagerFollowUpManagerId is null
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND G.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SeizuretManagerFollowUp')
			
		UNION
		SELECT 'CustomIncidentReportSeizureManagerFollowUps'
			,'ManagerFollowUpAdministrator'
			,'Seizure - Manager Review – Administrator is required when Administrator Notified is answered Yes. '
			,1
			,33
		FROM CustomIncidentReportSeizureManagerFollowUps U
		LEFT JOIN CustomIncidentReportGenerals G ON U.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(U.ManagerFollowUpAdministratorNotified, '') = 'Y'
		    AND U.ManagerFollowUpAdministrator is null
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND G.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SeizuretManagerFollowUp')
			
		UNION
		SELECT 'CustomIncidentReportSeizureManagerFollowUps'
			,'ManagerFollowUpAdminDateOfNotification'
			,'Seizure - Manager Review – Date of Notification is required when Administrator Notified is answered Yes.'
			,1
			,33
		FROM CustomIncidentReportSeizureManagerFollowUps U
		LEFT JOIN CustomIncidentReportGenerals G ON U.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(U.ManagerFollowUpAdministratorNotified, '') = 'Y'
		    AND U.ManagerFollowUpAdminDateOfNotification is null
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND G.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SeizuretManagerFollowUp')
			
		UNION
		SELECT 'CustomIncidentReportSeizureManagerFollowUps'
			,'ManagerFollowUpAdminTimeOfNotification'
			,'Seizure - Manager Review – Time of Notification is required when Administrator Notified is answered Yes.'
			,1
			,33
		FROM CustomIncidentReportSeizureManagerFollowUps U
		LEFT JOIN CustomIncidentReportGenerals G ON U.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(U.ManagerFollowUpAdministratorNotified, '') = 'Y'
		    AND U.ManagerFollowUpAdminTimeOfNotification is null
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENT')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND G.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SeizuretManagerFollowUp')	
			
		----Administrator Review
		
		UNION
		
		SELECT 'CustomIncidentReportSeizureAdministratorReviews'
			,'SeizureAdministratorReviewAdministrator'
			,'Seizure - Administrator Review- Administrator is required'
			,3
			,46
		FROM CustomIncidentReportSeizureAdministratorReviews A
		LEFT JOIN CustomIncidentReportSeizureSupervisorFollowUps S ON S.IncidentReportId = A.IncidentReportId
		LEFT JOIN CustomIncidentReportGenerals G ON A.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(A.SeizureAdministratorReviewAdministrator, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTFALL')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'SEIZUREOTHER'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND S.SeizureSupervisorFollowUpAdministratorNotified = 'Y'
			AND A.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SeizureAdministrators')
		
		UNION
		
		SELECT 'CustomIncidentReportSeizureAdministratorReviews'
			,'SeizureAdministratorReviewAdministrativeReview'
			,'Seizure - Administrator Review- Administrator review is required'
			,3
			,47
		FROM CustomIncidentReportSeizureAdministratorReviews A
		LEFT JOIN CustomIncidentReportSeizureSupervisorFollowUps S ON S.IncidentReportId = A.IncidentReportId
		LEFT JOIN CustomIncidentReportGenerals G ON A.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(A.SeizureAdministratorReviewAdministrativeReview, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTFALL')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'SEIZUREOTHER'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND S.SeizureSupervisorFollowUpAdministratorNotified = 'Y'
			AND A.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SeizureAdministrators')
		
		UNION
		
		SELECT 'CustomIncidentReportSeizureAdministratorReviews'
			,'SeizureAdministratorReviewFiledReportableIncident'
			,'Seizure - Administrator Review-Filed Reportable Incident is required'
			,3
			,48
		FROM CustomIncidentReportSeizureAdministratorReviews D
		LEFT JOIN CustomIncidentReportSeizureSupervisorFollowUps S ON S.IncidentReportId = D.IncidentReportId
		LEFT JOIN CustomIncidentReportGenerals G ON D.IncidentReportId = G.IncidentReportId
		WHERE ISNULL(SeizureAdministratorReviewFiledReportableIncident, '') = ''
			AND (
				G.GeneralIncidentCategory IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE (Code = 'INCIDENTSEIZURE')
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTOTHER')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'FALLSEIZURE'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					G.GeneralIncidentCategory IN (
						SELECT GlobalCodeId
						FROM GlobalCodes
						WHERE (Code = 'INCIDENTFALL')
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND G.GeneralSecondaryCategory IN (
						SELECT GlobalSubCodeId
						FROM GlobalSubCodes
						WHERE (
								Code = 'SEIZURE'
								OR Code = 'SEIZUREOTHER'
								)
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND S.SeizureSupervisorFollowUpAdministratorNotified = 'Y'
			AND D.IncidentReportId = @ScreenKeyId
			AND (@ButtonClicked = 'SeizureAdministrators')

		SELECT TableName
			,ColumnName
			,ErrorMessage
			,TabOrder
			,ValidationOrder
		FROM @validationReturnTable
		ORDER BY taborder
			,ValidationOrder

		IF EXISTS (
				SELECT *
				FROM @validationReturnTable
				)
		BEGIN
			SELECT 1 AS ValidationStatus
		END
		ELSE
		BEGIN
			SELECT 0 AS ValidationStatus
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[csp_SCValidateIncidentReport]') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                          
				16
				,-- Severity.                                                                                          
				1 -- State.                                                                                          
				);
	END CATCH
END
