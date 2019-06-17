IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetSureScriptOutboundPrescription]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetSureScriptOutboundPrescription]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetSureScriptOutboundPrescription] @StaffId INT
	,-- always pass the logged-in Staff Identifier    
	@PrescriberId INT -- Pass 0 for all prescribers, otherwise pass PrescriberId from the drop-down    
AS
BEGIN TRY
	/*********************************************************************/
	/* Stored Procedure: dbo.ssp_SCGetSureScriptOutboundPrescription      */
	/* Copyright: 2005 Provider Claim Management System      */
	/* Creation Date:  17 feb, 2010                */
	/*                                                                   */
	/* Purpose: Gets Prescriber proxies staff        */
	/*                                                                   */
	/* Input Parameters: None  @StaffId                         */
	/*                                                                   */
	/* Output Parameters:             */
	/*                                                                   */
	/* Return:                */
	/*                                                                   */
	/* Called By:               */
	/*                  */
	/*                                                                   */
	/* Calls:                                                            */
	/*                                                                   */
	/* Data Modifications:                                               */
	/*                                                                   */
	/*   Updates:                                                        */
	/*       Date				Author				Purpose           */
	/*		17Feb,2010			Anuj Tomar			Created           
		05/14/2012			dharvey				Added Order by on CreatedDate desc and limited results to only last 30 days
		Nov 15 2012			CBlaine				Added status of Successful to "Status" output
		July 3				CBlaine				Added success status to date range logic so that success statuses show for 30 days
												instead of only for the date that they were sent out
		January 11, 2014    Kalpers             Added check for electronic cancelled records, wrapped outbound in CT and sorted by created date
		January 22, 2014    Kalpers             Added logic to pull in cancel rx records that had a Cancel Rx response
		January 22, 2014    Kalpers             Combined the table that returned the instructions
		APR-7-2014			dharvey				Modified join conditions and added ClientMedicationScriptDrugId 
												to final select to prevent duplicated records
		3/25/2015			Steczynski			Format Quantity to drop trailing zeros, applied dbo.ssf_RemoveTrailingZeros, Task 215 
		MAR-31-2015			dharvey				Updated join to prevent duplicates
												AND cmsds.StrengthId = cmi.StrengthId
	--	20 Oct 2015			Revathi				what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.        
	--											why:task #609, Network180 Customization  
	    11 Dec 2018         Jyothi             What/Why:Journey-Support Go Live-#1566 - If Client doesn't have access to client,respective client records will not show.
	*/
	/*                  */
	/*********************************************************************/
		;

	WITH outbound
	AS (
		SELECT CASE 
				WHEN scr.createddate IS NOT NULL
					THEN scr.createddate
				ELSE cmsa.CreatedDate
				END AS createddate
			,CASE 
				WHEN cmsa.Method = 'E'
					AND scr.SurescriptsOutgoingMessageId IS NOT NULL
					THEN 'Elec-' + CASE 
							WHEN scr.ChangeOfPrescriptionStatusFlag = 'C'
								THEN 'Cancel'
							ELSE 'Discontinued'
							END
				WHEN cmsa.Method = 'E'
					AND scr.SurescriptsOutgoingMessageId IS NULL
					THEN 'Elec.'
				WHEN cmsa.Method = 'P'
					THEN 'Print'
				WHEN cmsa.Method = 'F'
					THEN 'Fax'
				END AS Method
			,CASE 
				WHEN cmsa.STATUS = 5564
					THEN 'Failed'
				WHEN cmsa.STATUS = 5561
					THEN 'Queued'
				WHEN cmsa.STATUS = 5541
					THEN 'Waiting'
				WHEN cmsa.STATUS = 5562
					THEN 'Pending'
				WHEN cmsa.STATUS = 5563
					THEN 'Successful'
				END AS STATUS
			,cmsa.StatusDescription
			,cms.OrderingPrescriberName
			,cms.ClientId
			,
			-- Added by   Revathi   20  Oct 2015
			CASE 
				WHEN ISNULL(C.ClientType, 'I') = 'I'
					THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')
				ELSE ISNULL(C.OrganizationName, '')
				END AS PatientName
			,md.MedicationName
			,cmsa.PharmacyId
			,cm.ClientMedicationId
			,cmsap.ClientMedicationScriptActivityId
			,cms.ClientMedicationScriptId
			,p.PharmacyName
			,cmsd.ClientMedicationScriptDrugId
		FROM ClientMedicationScriptActivitiesPending cmsap
		INNER JOIN ClientMedicationScriptActivities cmsa ON cmsa.ClientMedicationScriptActivityId = cmsap.ClientMedicationScriptActivityId
		INNER JOIN ClientMedicationScripts cms ON cms.ClientMedicationScriptId = cmsa.ClientMedicationScriptId
		INNER JOIN dbo.ClientMedicationScriptDrugs cmsd ON cmsa.ClientMedicationScriptId = cmsd.ClientMedicationScriptId
		INNER JOIN dbo.ClientMedicationInstructions cmi ON cmsd.ClientMedicationInstructionId = cmi.ClientMedicationInstructionId
		INNER JOIN Clients c ON c.ClientId = cms.ClientId
		INNER JOIN StaffClients sc on sc.StaffId = @PrescriberId  and sc.ClientId = cms.ClientId 
		INNER JOIN ClientMedicationScriptDrugStrengths cmsds ON cmsds.ClientMedicationScriptId = cms.ClientMedicationScriptId
			AND cmsds.ClientMedicationId = cmi.ClientMedicationId
			/** dharvey - added to prevent duplicates **/
			AND cmsds.StrengthId = cmi.StrengthId
		INNER JOIN ClientMedications cm ON cm.ClientMedicationId = cmsds.ClientMedicationId
		INNER JOIN MDMedicationNames md ON md.MedicationNameId = cm.MedicationNameId
		INNER JOIN Staff s ON s.StaffId = cms.OrderingPrescriberId
		 
		LEFT JOIN Pharmacies p ON p.PharmacyId = cmsa.PharmacyId
		LEFT JOIN dbo.SurescriptsCancelRequests scr ON (scr.SurescriptsOutgoingMessageId = cmsa.SureScriptsOutgoingMessageId)
		WHERE (
				(
					(s.StaffId = @PrescriberId)
					OR (@PrescriberId = 0)
					)
				AND (
					s.StaffId = @StaffId -- logged-in staff is the prescriber    
					OR (
						EXISTS (
							-- logged-in staff is a proxy for the prescriber    
							SELECT *
							FROM PrescriberProxies AS pp
							WHERE pp.PrescriberId = s.StaffId
								AND pp.ProxyStaffId = @StaffId
								AND ISNULL(pp.RecordDeleted, 'N') <> 'Y'
							)
						)
					)
				)
			AND ISNULL(cms.WaitingPrescriberApproval, 'N') <> 'Y'
			AND ISNULL(cmsap.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(cmsa.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(cms.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(c.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(cmsds.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(cm.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(md.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(s.RecordDeleted, 'N') <> 'Y'
			AND cmsa.CreatedDate >= DATEADD(dd, CASE 
					WHEN cmsa.STATUS IN (
							5561
							,5541
							)
						THEN - 7
					WHEN cmsa.STATUS IN (
							5564
							,5562
							,5563
							)
						THEN - 30
					ELSE 0
					END, dbo.RemoveTimeStamp(GETDATE()))
		
		UNION ALL
		
		SELECT scr.ModifiedDate
			,CASE 
				WHEN cmsa.Method = 'E'
					AND scr.SurescriptsOutgoingMessageId IS NOT NULL
					THEN 'Elec-' + CASE 
							WHEN scr.ChangeOfPrescriptionStatusFlag = 'C'
								THEN 'Cancel-Response'
							ELSE 'Discontinued-Response'
							END
				WHEN cmsa.Method = 'E'
					AND scr.SurescriptsOutgoingMessageId IS NULL
					THEN 'Elec.'
				WHEN cmsa.Method = 'P'
					THEN 'Print'
				WHEN cmsa.Method = 'F'
					THEN 'Fax'
				END AS Method
			,CASE 
				WHEN cmsa.STATUS = 5564
					THEN 'Failed'
				WHEN cmsa.STATUS = 5561
					THEN 'Queued'
				WHEN cmsa.STATUS = 5541
					THEN 'Waiting'
				WHEN cmsa.STATUS = 5562
					THEN 'Pending'
				WHEN cmsa.STATUS = 5563
					THEN 'Received'
				END AS STATUS
			,scr.CancelRxResponse AS StatusDescription
			,cms.OrderingPrescriberName
			,cms.ClientId
			,
			-- Added by   Revathi   20  Oct 2015
			CASE 
				WHEN ISNULL(C.ClientType, 'I') = 'I'
					THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')
				ELSE ISNULL(C.OrganizationName, '')
				END AS PatientName
			,md.MedicationName
			,cmsa.PharmacyId
			,cm.ClientMedicationId
			,cmsap.ClientMedicationScriptActivityId
			,cms.ClientMedicationScriptId
			,p.PharmacyName
			,cmsd.ClientMedicationScriptDrugId
		FROM ClientMedicationScriptActivitiesPending cmsap
		INNER JOIN ClientMedicationScriptActivities cmsa ON cmsa.ClientMedicationScriptActivityId = cmsap.ClientMedicationScriptActivityId
		INNER JOIN ClientMedicationScripts cms ON cms.ClientMedicationScriptId = cmsa.ClientMedicationScriptId
		INNER JOIN dbo.ClientMedicationScriptDrugs cmsd ON cmsa.ClientMedicationScriptId = cmsd.ClientMedicationScriptId
		INNER JOIN dbo.ClientMedicationInstructions cmi ON cmsd.ClientMedicationInstructionId = cmi.ClientMedicationInstructionId
		INNER JOIN Clients c ON c.ClientId = cms.ClientId
		INNER JOIN StaffClients sc on sc.StaffId = @PrescriberId  and sc.ClientId = cms.ClientId 
		INNER JOIN ClientMedicationScriptDrugStrengths cmsds ON cmsds.ClientMedicationScriptId = cms.ClientMedicationScriptId
			AND cmsds.ClientMedicationId = cmi.ClientMedicationId
			/** dharvey - added to prevent duplicates **/
			AND cmsds.StrengthId = cmi.StrengthId
		INNER JOIN ClientMedications cm ON cm.ClientMedicationId = cmsds.ClientMedicationId
		INNER JOIN MDMedicationNames md ON md.MedicationNameId = cm.MedicationNameId
		INNER JOIN Staff s ON s.StaffId = cms.OrderingPrescriberId
		
		LEFT JOIN Pharmacies p ON p.PharmacyId = cmsa.PharmacyId
		INNER JOIN dbo.SurescriptsCancelRequests scr ON (
				scr.SurescriptsOutgoingMessageId = cmsa.SureScriptsOutgoingMessageId
				AND scr.CancelRxResponse IS NOT NULL
				)
		WHERE (
				(
					(s.StaffId = @PrescriberId)
					OR (@PrescriberId = 0)
					)
				AND (
					s.StaffId = @StaffId -- logged-in staff is the prescriber    
					OR (
						EXISTS (
							-- logged-in staff is a proxy for the prescriber    
							SELECT *
							FROM PrescriberProxies AS pp
							WHERE pp.PrescriberId = s.StaffId
								AND pp.ProxyStaffId = @StaffId
								AND ISNULL(pp.RecordDeleted, 'N') <> 'Y'
							)
						)
					)
				)
			AND ISNULL(cms.WaitingPrescriberApproval, 'N') <> 'Y'
			AND ISNULL(cmsap.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(cmsa.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(cms.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(c.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(cmsds.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(cm.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(md.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(s.RecordDeleted, 'N') <> 'Y'
			AND scr.ModifiedDate >= DATEADD(dd, CASE 
					WHEN cmsa.STATUS IN (
							5561
							,5541
							)
						THEN - 7
					WHEN cmsa.STATUS IN (
							5564
							,5562
							,5563
							)
						THEN - 30
					ELSE 0
					END, dbo.RemoveTimeStamp(GETDATE()))
		)
	SELECT o.ClientMedicationScriptActivityId
		,o.ClientMedicationScriptId
		,o.OrderingPrescriberName
		,o.ClientId
		,o.PatientName
		,o.CreatedDate
		,o.ClientMedicationId
		,o.MedicationName
		,(ISNULL(mdm.StrengthDescription, '') + ' ' + ISNULL(dbo.ssf_RemoveTrailingZeros(CMI.Quantity), '') + ' ' + ISNULL(gc.CodeName, '') + ' ' + ISNULL(gc1.CodeName, '')) AS Instruction
		,o.PharmacyName
		,o.Method
		,o.[Status]
		,o.StatusDescription
	FROM outbound o
	INNER JOIN ClientMedicationScriptDrugs cmsd ON cmsd.ClientMedicationScriptId = o.ClientMedicationScriptId
		AND o.ClientMedicationScriptDrugId = cmsd.ClientMedicationScriptDrugId
	INNER JOIN ClientMedicationInstructions AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId
	INNER JOIN ClientMedications cm ON cm.ClientMedicationId = cmi.ClientMedicationId
	INNER JOIN MDMedicationNames md ON md.MedicationNameId = cm.MedicationNameId
	INNER JOIN MDMedications AS mdm ON mdm.MedicationId = cmi.StrengthId
	LEFT JOIN globalcodes AS gc ON gc.category = 'MEDICATIONUNIT'
		AND gc.GlobalCodeId = cmi.unit
	LEFT JOIN globalcodes AS gc1 ON gc1.category = 'MEDICATIONSCHEDULE'
		AND gc1.GlobalCodeId = cmi.Schedule
	ORDER BY createddate DESC
END TRY

BEGIN CATCH
	DECLARE @err_msg NVARCHAR(4000)
	DECLARE @err_severity INT
		,@err_state INT

	SET @err_msg = 'ssp_SCGetSureScriptOutboundPrescription: ' + ERROR_MESSAGE()
	SET @err_severity = ERROR_SEVERITY()
	SET @err_state = ERROR_STATE()

	RAISERROR (
			@err_msg
			,@err_severity
			,@err_state
			)
END CATCH
GO

