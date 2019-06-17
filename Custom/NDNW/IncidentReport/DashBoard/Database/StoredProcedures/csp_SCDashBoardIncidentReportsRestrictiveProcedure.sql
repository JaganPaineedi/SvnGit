IF EXISTS (
		SELECT *
		FROM sysobjects
		WHERE type = 'P'
			AND NAME = 'csp_SCDashBoardIncidentReportsRestrictiveProcedure'
		)
BEGIN
	DROP PROCEDURE csp_SCDashBoardIncidentReportsRestrictiveProcedure
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_SCDashBoardIncidentReportsRestrictiveProcedure] (@LoggedInStaffId INT)
	/********************************************************************************                                                 
** Stored Procedure: csp_SCDashBoardIncidentReportsRestrictiveProcedure                                                    
**                                                  
** Copyright: Streamline Healthcate Solutions                                                    
** Updates:                                                                                                         
** Date            Author              Purpose   
** 08-May-2015	   Revathi			   What:Task #818 Woods Customization  
*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		DECLARE @IncidentReportsProgress INT
		DECLARE @IncidentReportsAssignedReview INT
		DECLARE @RestrictiveProgress INT
		DECLARE @RestrictiveAssignedReview INT

		

		
			
				 
			

		SELECT @IncidentReportsProgress = COUNT(DISTINCT CIR.IncidentReportId)
		FROM CustomIncidentReportGenerals CIRG
		INNER JOIN CustomIncidentReports CIR ON CIR.IncidentReportId = CIRG.IncidentReportId
		LEFT JOIN Staff S ON S.UserCode = CIR.CreatedBy
			AND ISNULL(S.RecordDeleted, 'N') = 'N'
		JOIN StaffClients sc ON sc.StaffId = @LoggedInStaffId
			AND sc.ClientId = CIR.ClientId
		WHERE ISNULL(CIRG.RecordDeleted, 'N') = 'N'
			AND ISNULL(CIR.RecordDeleted, 'N') = 'N'
			AND S.StaffId = @LoggedInStaffId
			AND  (
-------------Incident In Progress----------------------------------------------------------------------------
					       (CIRG.GeneralIncidentCategory IN (
							SELECT GlobalCodeId
							FROM GlobalCodes
							WHERE (Code = 'INCIDENT')
								AND ISNULL(RecordDeleted, 'N') = 'N'
							) 
							AND  ISNULL(CIRG.GeneralSecondaryCategory,'') NOT IN (
									SELECT GlobalSubCodeId
									FROM GlobalSubCodes
									WHERE (
									        Code = 'FALL'
											OR Code = 'SEIZURE'
											OR Code = 'FALLSEIZURE'
											)
								AND ISNULL(RecordDeleted, 'N') = 'N'
							 )
							and CIR.DetailVersionStatus = 21)
--------------Fall In Progress-------------------------------------------------------------------------------
                            OR 
					        ( CIRG.GeneralIncidentCategory IN (
								SELECT GlobalCodeId
								FROM GlobalCodes
								WHERE (Code = 'INCIDENTFALL')
									AND ISNULL(RecordDeleted, 'N') = 'N'
								)
							 and CIR.FallDetailVersionStatus = 21) 

--------------Seizure In Progress----------------------------------------------------------------------------
                             OR (
                             CIRG.GeneralIncidentCategory IN (
								SELECT GlobalCodeId
								FROM GlobalCodes
								WHERE (Code = 'INCIDENTSEIZURE')
									AND ISNULL(RecordDeleted, 'N') = 'N'
							  )
							  and CIR.SeizureDetailVersionStatus = 21)
--------------Fall & Seizure In Progress---------------------------------------------------------------------
							  OR (
							  CIRG.GeneralIncidentCategory IN (
									SELECT GlobalCodeId
									FROM GlobalCodes
									WHERE (Code = 'INCIDENTOTHER')
										AND ISNULL(RecordDeleted, 'N') = 'N'
									)
									and (CIR.SeizureDetailVersionStatus = 21 
									or CIR.FallDetailVersionStatus = 21)
								)
--------------Incident & Fall In Progress --------------------------------------------------------------------
							  OR (
							   CIRG.GeneralIncidentCategory IN (
								SELECT GlobalCodeId
								FROM GlobalCodes
								WHERE (Code = 'INCIDENT')
									AND ISNULL(RecordDeleted, 'N') = 'N'
								)
								AND CIRG.GeneralSecondaryCategory IN (
									SELECT GlobalSubCodeId
									FROM GlobalSubCodes
									WHERE (
											Code = 'FALL'
											)
										AND ISNULL(RecordDeleted, 'N') = 'N'
									)
									and (CIR.DetailVersionStatus = 21 
									or CIR.FallDetailVersionStatus = 21)
								)
        
--------------Incident & Seizure In Progress -----------------------------------------------------------------	
							   OR (
								CIRG.GeneralIncidentCategory IN (
									SELECT GlobalCodeId
									FROM GlobalCodes
									WHERE (Code = 'INCIDENT')
										AND ISNULL(RecordDeleted, 'N') = 'N'
									)
								AND CIRG.GeneralSecondaryCategory IN (
									SELECT GlobalSubCodeId
									FROM GlobalSubCodes
									WHERE (
											Code = 'SEIZURE'
											)
										AND ISNULL(RecordDeleted, 'N') = 'N'
									)
									and (CIR.DetailVersionStatus = 21 
									or CIR.SeizureDetailVersionStatus = 21)
								 )
--------------Incident & Fall & Seizure In Progress ----------------------------------------------------------								
							    OR (
								CIRG.GeneralIncidentCategory IN (
									SELECT GlobalCodeId
									FROM GlobalCodes
									WHERE (Code = 'INCIDENT')
										AND ISNULL(RecordDeleted, 'N') = 'N'
									)
								AND CIRG.GeneralSecondaryCategory IN (
									SELECT GlobalSubCodeId
									FROM GlobalSubCodes
									WHERE (
											Code = 'FALLSEIZURE'
											)
										AND ISNULL(RecordDeleted, 'N') = 'N'
									)
								 and (CIR.SeizureDetailVersionStatus = 21
								      or CIR.FallDetailVersionStatus = 21
								      or CIR.DetailVersionStatus = 21)
								 ) 
	                        )
				
		SELECT @IncidentReportsAssignedReview = COUNT(DISTINCT CIR.IncidentReportId)
		FROM CustomIncidentReportGenerals CIRG
		INNER JOIN CustomIncidentReports CIR ON CIR.IncidentReportId = CIRG.IncidentReportId
		--LEFT JOIN Staff S ON S.UserCode = CIR.CreatedBy    
		-- AND ISNULL(S.RecordDeleted, 'N') = 'N'    
		INNER JOIN CustomIncidentReportSupervisorFollowUps CIRSF ON CIRSF.IncidentReportSupervisorFollowUpId = CIR.IncidentReportSupervisorFollowUpId
			AND CIRSF.IncidentReportId = CIR.IncidentReportId
			AND ISNULL(CIRSF.RecordDeleted, 'N') = 'N'
		INNER JOIN CustomIncidentReportFallSupervisorFollowUps CIRFSF ON CIRFSF.IncidentReportFallSupervisorFollowUpId = CIR.IncidentReportFallSupervisorFollowUpId
			AND CIRFSF.IncidentReportId = CIR.IncidentReportId
			AND ISNULL(CIRFSF.RecordDeleted, 'N') = 'N'
		INNER JOIN CustomIncidentReportSeizureSupervisorFollowUps CISF ON CISF.IncidentReportSeizureSupervisorFollowUpId = CIR.IncidentReportSeizureSupervisorFollowUpId
			AND CISF.IncidentReportId = CIR.IncidentReportId
			AND ISNULL(CISF.RecordDeleted, 'N') = 'N'
		INNER JOIN CustomIncidentReportFollowUpOfIndividualStatuses CIRFIS ON CIRFIS.IncidentReportFollowUpOfIndividualStatusId = CIR.IncidentReportFollowUpOfIndividualStatusId
			AND CIRFIS.IncidentReportId = CIR.IncidentReportId
			AND ISNULL(CIRFIS.RecordDeleted, 'N') = 'N'
		INNER JOIN CustomIncidentReportFallFollowUpOfIndividualStatuses CIRFFIS ON CIRFFIS.IncidentReportFallFollowUpOfIndividualStatusId = CIR.IncidentReportFallFollowUpOfIndividualStatusId
			AND CIRFFIS.IncidentReportId = CIR.IncidentReportId
			AND ISNULL(CIRFFIS.RecordDeleted, 'N') = 'N'
		INNER JOIN CustomIncidentReportSeizureFollowUpOfIndividualStatuses CIRFSIS ON CIRFSIS.IncidentReportSeizureFollowUpOfIndividualStatusId = CIR.IncidentReportSeizureFollowUpOfIndividualStatusId
			AND CIRFSIS.IncidentReportId = CIR.IncidentReportId
			AND ISNULL(CIRFSIS.RecordDeleted, 'N') = 'N'
		INNER JOIN CustomIncidentReportManagerFollowUps CIRMF ON CIRMF.IncidentReportManagerFollowUpId = CIR.IncidentReportManagerFollowUpId
			AND CIRMF.IncidentReportId = CIR.IncidentReportId
			AND ISNULL(CIRMF.RecordDeleted, 'N') = 'N'
		INNER JOIN CustomIncidentReportFallManagerFollowUps CIRFMF ON CIRFMF.IncidentReportFallManagerFollowUpId = CIR.IncidentReportFallManagerFollowUpId
			AND CIRFMF.IncidentReportId = CIR.IncidentReportId
			AND ISNULL(CIRFMF.RecordDeleted, 'N') = 'N'
		INNER JOIN CustomIncidentReportSeizureManagerFollowUps CIRSMF ON CIRSMF.IncidentReportSeizureManagerFollowUpId = CIR.IncidentReportSeizureManagerFollowUpId
			AND CIRSMF.IncidentReportId = CIR.IncidentReportId
			AND ISNULL(CIRSMF.RecordDeleted, 'N') = 'N'
		INNER JOIN CustomIncidentSeizureDetails CISD ON CISD.IncidentSeizureDetailId = CIR.IncidentSeizureDetailId
			AND CISD.IncidentReportId = CIR.IncidentReportId
			AND ISNULL(CISD.RecordDeleted, 'N') = 'N'
		INNER JOIN CustomIncidentReportDetails CIRD ON CIRD.IncidentReportDetailId = CIR.IncidentReportDetailId
				AND CIRD.IncidentReportId = CIR.IncidentReportId
				AND ISNULL(CIRD.RecordDeleted, 'N') = 'N'
		INNER JOIN CustomIncidentReportFallDetails CIRF ON CIRF.IncidentReportFallDetailId = CIR.IncidentReportFallDetailId
				AND CIRF.IncidentReportId = CIR.IncidentReportId
				AND ISNULL(CIRF.RecordDeleted, 'N') = 'N'
		JOIN StaffClients sc ON sc.StaffId = @LoggedInStaffId
			AND sc.ClientId = CIR.ClientId
		WHERE ISNULL(CIRG.RecordDeleted, 'N') = 'N'
			AND ISNULL(CIR.RecordDeleted, 'N') = 'N'
			-- AND S.StaffId = @LoggedInStaffId    
			AND (
				(
					( -- CustomIncidentReports
						(CIRSF.SupervisorFollowUpSupervisorName = @LoggedInStaffId  and CIR.SupervisorFollowUpVersionStatus<>22)
		             			
						OR (CIRSF.SupervisorFollowUpAdministrator = @LoggedInStaffId and CIR.AdministratorReviewVersionStatus<>22)
						OR (CIRSF.SupervisorFollowUpManager = @LoggedInStaffId and CIR.ManagerFollowUpStatus <> 22)
						
						)
					OR (
						(CIRFSF.FallSupervisorFollowUpSupervisorName = @LoggedInStaffId and CIR.FallSupervisorFollowUpVersionStatus<>22)
						OR (CIRFSF.FallSupervisorFollowUpAdministrator = @LoggedInStaffId and CIR.FallAdministratorReviewVersionStatus<>22)
						OR (CIRFSF.SupervisorFollowUpManager = @LoggedInStaffId and CIR.FallManagerFollowUpStatus<>22)
						
						)
					OR (
						(CISF.SeizureSupervisorFollowUpSupervisorName = @LoggedInStaffId and CIR.SeizureSupervisorFollowUpVersionStatus<>22)
						OR (CISF.SeizureSupervisorFollowUpAdministrator = @LoggedInStaffId and CIR.SeizureAdministratorReviewVersionStatus<>22)
						or (CISF.SupervisorFollowUpManager = @LoggedInStaffId and CIR.SeizureManagerFollowUpStatus<>22)
						)
					)
				OR (
					(CIRFSIS.SeizureFollowUpIndividualStatusNurseStaffEvaluating = @LoggedInStaffId and CIR.SeizureFollowUpOfIndividualStatusVersionStatus<>22)
					OR (CIRFIS.FollowUpIndividualStatusNurseStaffEvaluating = @LoggedInStaffId and  CIR.FollowUpOfIndividualStatusVersionStatus<>22)
					OR (CIRFFIS.FallFollowUpIndividualStatusNurseStaffEvaluating = @LoggedInStaffId and CIR.FallFollowUpOfIndividualStatusVersionStatus<>22)
					)
				OR((CIRMF.ManagerFollowUpManagerId = @LoggedInStaffId and CIR.ManagerFollowUpStatus<>22)
				   or (CIRMF.ManagerFollowUpAdministrator = @LoggedInStaffId and CIR.AdministratorReviewVersionStatus<>22)) 
				   OR((CIRFMF.ManagerFollowUpManagerId = @LoggedInStaffId and CIR.FallManagerFollowUpStatus<>22)
				   or (CIRFMF.ManagerFollowUpAdministrator = @LoggedInStaffId and CIR.FallAdministratorReviewVersionStatus<>22)) 
				   OR((CIRSMF.ManagerFollowUpManagerId = @LoggedInStaffId and CIR.SeizureManagerFollowUpStatus<>22)
				   or (CIRSMF.ManagerFollowUpAdministrator = @LoggedInStaffId and CIR.SeizureAdministratorReviewVersionStatus<>22)) 
				)
			AND (
			(
								 
								(
------------Incident Nursing -------------------------------------------------------------------------------	
                            (CIRG.GeneralIncidentCategory IN (
							SELECT GlobalCodeId
							FROM GlobalCodes
							WHERE (Code = 'INCIDENT')
								AND ISNULL(RecordDeleted, 'N') = 'N'
							) 
							AND  ISNULL(CIRG.GeneralSecondaryCategory,'') NOT IN (
									SELECT GlobalSubCodeId
									FROM GlobalSubCodes
									WHERE (
									        Code = 'FALL'
											OR Code = 'SEIZURE'
											OR Code = 'FALLSEIZURE'
											)
								AND ISNULL(RecordDeleted, 'N') = 'N'
							 )
							 and CIR.DetailVersionStatus = 22 
	                         and CIR.FollowUpOfIndividualStatusVersionStatus = 21
	                         and CIRD.DetailsStaffNotifiedForInjury is not null
							 )
------------Fall Nursing  ----------------------------------------------------------------------------------
                            OR 
					        ( CIRG.GeneralIncidentCategory IN (
								SELECT GlobalCodeId
								FROM GlobalCodes
								WHERE (Code = 'INCIDENTFALL')
								     AND ISNULL(RecordDeleted, 'N') = 'N'
							)
							 and CIR.FallDetailVersionStatus = 22
							 and CIR.FallFollowUpOfIndividualStatusVersionStatus = 21 
                             and CIRF.FallDetailsStaffNotifiedForInjury is not null
							)
------------Seizure Nursing --------------------------------------------------------------------------------
                            OR (
                             CIRG.GeneralIncidentCategory IN (
								SELECT GlobalCodeId
								FROM GlobalCodes
								WHERE (Code = 'INCIDENTSEIZURE')
									AND ISNULL(RecordDeleted, 'N') = 'N'
							  )
							  and CIR.SeizureDetailVersionStatus  = 22  
							  and cir.SeizureFollowUpOfIndividualStatusVersionStatus = 21 
	                          and CISD.IncidentSeizureDetailsStaffNotifiedForInjury Is Not null
							  )
------------Fall & Seizure Nursing -------------------------------------------------------------------------
							OR (
							  CIRG.GeneralIncidentCategory IN (
									SELECT GlobalCodeId
									FROM GlobalCodes
									WHERE (Code = 'INCIDENTOTHER')
										AND ISNULL(RecordDeleted, 'N') = 'N'
									)
							 and(( CIR.FallDetailVersionStatus = 22
								 and CIR.FallFollowUpOfIndividualStatusVersionStatus = 21 
								 and CIRF.FallDetailsStaffNotifiedForInjury is not null) 
                               OR (CIR.SeizureDetailVersionStatus  = 22  
							     and cir.SeizureFollowUpOfIndividualStatusVersionStatus = 21 
	                             and CISD.IncidentSeizureDetailsStaffNotifiedForInjury Is Not null))
	                             and CIR.FallDetailVersionStatus = 22
	                             and CIR.SeizureDetailVersionStatus  = 22
								)
------------Incident & Fall Nursing-------------------------------------------------------------------------  
							OR (
							   CIRG.GeneralIncidentCategory IN (
								SELECT GlobalCodeId
								FROM GlobalCodes
								WHERE (Code = 'INCIDENT')
									AND ISNULL(RecordDeleted, 'N') = 'N'
								)
								AND CIRG.GeneralSecondaryCategory IN (
									SELECT GlobalSubCodeId
									FROM GlobalSubCodes
									WHERE (
											Code = 'FALL'
											)
										AND ISNULL(RecordDeleted, 'N') = 'N'
									)
							     and ((CIR.DetailVersionStatus = 22 
	                             and CIR.FollowUpOfIndividualStatusVersionStatus = 21
	                             and CIRD.DetailsStaffNotifiedForInjury is not null)
	                              OR ( CIR.FallDetailVersionStatus = 22
								 and CIR.FallFollowUpOfIndividualStatusVersionStatus = 21 
								 and CIRF.FallDetailsStaffNotifiedForInjury is not null))
								 and CIR.DetailVersionStatus = 22
								 and CIR.FallDetailVersionStatus = 22
								)
------------Incident & Seizure Nursing----------------------------------------------------------------------
							 OR (
								CIRG.GeneralIncidentCategory IN (
									SELECT GlobalCodeId
									FROM GlobalCodes
									WHERE (Code = 'INCIDENT')
										AND ISNULL(RecordDeleted, 'N') = 'N'
									)
								AND CIRG.GeneralSecondaryCategory IN (
									SELECT GlobalSubCodeId
									FROM GlobalSubCodes
									WHERE (
											Code = 'SEIZURE'
											)
										AND ISNULL(RecordDeleted, 'N') = 'N'
									)
								 and ((CIR.DetailVersionStatus = 22 
	                             and CIR.FollowUpOfIndividualStatusVersionStatus = 21
	                             and CIRD.DetailsStaffNotifiedForInjury is not null)
	                             or (CIR.SeizureDetailVersionStatus  = 22  
							     and cir.SeizureFollowUpOfIndividualStatusVersionStatus = 21 
	                             and CISD.IncidentSeizureDetailsStaffNotifiedForInjury Is Not null)
	                             )
	                             and CIR.DetailVersionStatus = 22
	                             and CIR.SeizureDetailVersionStatus  = 22
								 )
------------Incident & Fall & Seizure Nursing---------------------------------------------------------------  
							OR (
								CIRG.GeneralIncidentCategory IN (
									SELECT GlobalCodeId
									FROM GlobalCodes
									WHERE (Code = 'INCIDENT')
										AND ISNULL(RecordDeleted, 'N') = 'N'
									)
								AND CIRG.GeneralSecondaryCategory IN (
									SELECT GlobalSubCodeId
									FROM GlobalSubCodes
									WHERE (
											Code = 'FALLSEIZURE'
											)
										AND ISNULL(RecordDeleted, 'N') = 'N'
									)
								 and ((CIR.DetailVersionStatus = 22 
	                             and CIR.FollowUpOfIndividualStatusVersionStatus = 21
	                             and CIRD.DetailsStaffNotifiedForInjury is not null)
	                             OR (CIR.SeizureDetailVersionStatus  = 22  
							     and cir.SeizureFollowUpOfIndividualStatusVersionStatus = 21 
	                             and CISD.IncidentSeizureDetailsStaffNotifiedForInjury Is Not null)
	                             OR ( CIR.FallDetailVersionStatus = 22
								 and CIR.FallFollowUpOfIndividualStatusVersionStatus = 21 
								 and CIRF.FallDetailsStaffNotifiedForInjury is not null)
	                             )
	                             and CIR.DetailVersionStatus = 22
	                             and CIR.SeizureDetailVersionStatus  = 22
	                             and CIR.FallDetailVersionStatus = 22
								 ))
	                            
	                            OR 
	                          (
				  
 ------------Incident Supervisor -------------------------------------------------------------------------------
								 (CIRG.GeneralIncidentCategory IN (
										SELECT GlobalCodeId
										FROM GlobalCodes
										WHERE (Code = 'INCIDENT')
											AND ISNULL(RecordDeleted, 'N') = 'N'
										) 
										AND  ISNULL(CIRG.GeneralSecondaryCategory,'') NOT IN (
												SELECT GlobalSubCodeId
												FROM GlobalSubCodes
												WHERE (
														Code = 'FALL'
														OR Code = 'SEIZURE'
														OR Code = 'FALLSEIZURE'
														)
											AND ISNULL(RecordDeleted, 'N') = 'N'
								  )
								  and CIR.DetailVersionStatus = 22  
	                              and CIR.FollowUpOfIndividualStatusVersionStatus = 22
	                              and CIR.SupervisorFollowUpVersionStatus = 21
	                              and CIRD.DetailsSupervisorFlaggedId  is not null
								  )
------------Fall Supervisor  ----------------------------------------------------------------------------------
								  OR 
								   ( CIRG.GeneralIncidentCategory IN (
										SELECT GlobalCodeId
										FROM GlobalCodes
										WHERE (Code = 'INCIDENTFALL')
											 AND ISNULL(RecordDeleted, 'N') = 'N'
									)
									and CIR.FallDetailVersionStatus = 22 
									and CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
									and CIR.FallSupervisorFollowUpVersionStatus = 21
									and CIRF.FallDetailsSupervisorFlaggedId is not null
									)
------------Seizure Supervisor --------------------------------------------------------------------------------
								 OR (
								 CIRG.GeneralIncidentCategory IN (
									SELECT GlobalCodeId
									FROM GlobalCodes
									WHERE (Code = 'INCIDENTSEIZURE')
										AND ISNULL(RecordDeleted, 'N') = 'N'
								  )
								  and CIR.SeizureDetailVersionStatus  = 22  
								  and cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22 
								  and cir.SeizureSupervisorFollowUpVersionStatus = 21
	                              and CISD.IncidentSeizureDetailsSupervisorFlaggedId Is Not null
								  )
------------Fall & Seizure Supervisor -------------------------------------------------------------------------
								  OR (
								  CIRG.GeneralIncidentCategory IN (
										SELECT GlobalCodeId
										FROM GlobalCodes
										WHERE (Code = 'INCIDENTOTHER')
											AND ISNULL(RecordDeleted, 'N') = 'N'
									)
								    and ((CIR.FallDetailVersionStatus = 22 
									and CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
									and CIR.FallSupervisorFollowUpVersionStatus = 21
									and CIRF.FallDetailsSupervisorFlaggedId is not null)
									or (CIR.SeizureDetailVersionStatus  = 22  
								    and cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22 
								    and cir.SeizureSupervisorFollowUpVersionStatus = 21
	                                and CISD.IncidentSeizureDetailsSupervisorFlaggedId Is Not null))
	                                and CIR.FallDetailVersionStatus = 22 
									and CIR.FallFollowUpOfIndividualStatusVersionStatus = 22
									and CIR.SeizureDetailVersionStatus  = 22  
								    and cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22
									)
------------Incident & Fall Supervisor-------------------------------------------------------------------------
								   OR (
								   CIRG.GeneralIncidentCategory IN (
									SELECT GlobalCodeId
									FROM GlobalCodes
									WHERE (Code = 'INCIDENT')
										AND ISNULL(RecordDeleted, 'N') = 'N'
									)
									AND CIRG.GeneralSecondaryCategory IN (
										SELECT GlobalSubCodeId
										FROM GlobalSubCodes
										WHERE (
												Code = 'FALL'
												)
											AND ISNULL(RecordDeleted, 'N') = 'N'
										)
									and((CIR.DetailVersionStatus = 22  
	                                and CIR.FollowUpOfIndividualStatusVersionStatus = 22
	                                and CIR.SupervisorFollowUpVersionStatus = 21
	                                and CIRD.DetailsSupervisorFlaggedId  is not null)
	                                or(CIR.FallDetailVersionStatus = 22 
									and CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
									and CIR.FallSupervisorFollowUpVersionStatus = 21
									and CIRF.FallDetailsSupervisorFlaggedId is not null))
									and CIR.DetailVersionStatus = 22  
	                                and CIR.FollowUpOfIndividualStatusVersionStatus = 22
	                                and CIR.FallDetailVersionStatus = 22 
									and CIR.FallFollowUpOfIndividualStatusVersionStatus = 22
									) 
------------Incident & Seizure Supervisor----------------------------------------------------------------------
								    OR (
									CIRG.GeneralIncidentCategory IN (
										SELECT GlobalCodeId
										FROM GlobalCodes
										WHERE (Code = 'INCIDENT')
											AND ISNULL(RecordDeleted, 'N') = 'N'
										)
									AND CIRG.GeneralSecondaryCategory IN (
										SELECT GlobalSubCodeId
										FROM GlobalSubCodes
										WHERE (
												Code = 'SEIZURE'
												)
											AND ISNULL(RecordDeleted, 'N') = 'N'
										)
									and((CIR.DetailVersionStatus = 22  
	                                and CIR.FollowUpOfIndividualStatusVersionStatus = 22
	                                and CIR.SupervisorFollowUpVersionStatus = 21
	                                and CIRD.DetailsSupervisorFlaggedId  is not null)
	                                or(CIR.SeizureDetailVersionStatus  = 22  
								    and cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22 
								    and cir.SeizureSupervisorFollowUpVersionStatus = 21
	                                and CISD.IncidentSeizureDetailsSupervisorFlaggedId Is Not null))
	                                and CIR.DetailVersionStatus = 22  
	                                and CIR.FollowUpOfIndividualStatusVersionStatus = 22
	                                and CIR.SeizureDetailVersionStatus  = 22  
								    and cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22
									)
------------Incident & Fall & Seizure Supervisor---------------------------------------------------------------  
									OR (
									CIRG.GeneralIncidentCategory IN (
										SELECT GlobalCodeId
										FROM GlobalCodes
										WHERE (Code = 'INCIDENT')
											AND ISNULL(RecordDeleted, 'N') = 'N'
										)
									AND CIRG.GeneralSecondaryCategory IN (
										SELECT GlobalSubCodeId
										FROM GlobalSubCodes
										WHERE (
												Code = 'FALLSEIZURE'
												)
											AND ISNULL(RecordDeleted, 'N') = 'N'
										)
									and((CIR.DetailVersionStatus = 22  
	                                and CIR.FollowUpOfIndividualStatusVersionStatus = 22
	                                and CIR.SupervisorFollowUpVersionStatus = 21
	                                and CIRD.DetailsSupervisorFlaggedId  is not null)
	                                or(CIR.FallDetailVersionStatus = 22 
									and CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
									and CIR.FallSupervisorFollowUpVersionStatus = 21
									and CIRF.FallDetailsSupervisorFlaggedId is not null)
									or (CIR.SeizureDetailVersionStatus  = 22  
								    and cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22 
								    and cir.SeizureSupervisorFollowUpVersionStatus = 21
	                                and CISD.IncidentSeizureDetailsSupervisorFlaggedId Is Not null))
	                                and CIR.DetailVersionStatus = 22  
	                                and CIR.FollowUpOfIndividualStatusVersionStatus = 22
	                                and CIR.FallDetailVersionStatus = 22 
									and CIR.FallFollowUpOfIndividualStatusVersionStatus = 22
									and CIR.SeizureDetailVersionStatus  = 22  
								    and cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22
									)
			                   )
	                          
	                          OR
	                          (
	       
----------Incident Manager---------------------------------------------------------------------------------
								   (CIRG.GeneralIncidentCategory IN (
										SELECT GlobalCodeId
										FROM GlobalCodes
										WHERE (Code = 'INCIDENT')
											AND ISNULL(RecordDeleted, 'N') = 'N'
										) 
										AND  ISNULL(CIRG.GeneralSecondaryCategory,'') NOT IN (
												SELECT GlobalSubCodeId
												FROM GlobalSubCodes
												WHERE (
														Code = 'FALL'
														OR Code = 'SEIZURE'
														OR Code = 'FALLSEIZURE'
														)
											AND ISNULL(RecordDeleted, 'N') = 'N'
								   )
								   and CIR.DetailVersionStatus = 22  
	                               and CIR.FollowUpOfIndividualStatusVersionStatus = 22
	                               and CIR.SupervisorFollowUpVersionStatus = 22
	                               and CIR.ManagerFollowUpStatus  = 21
	                               and isnull(CIRSF.SupervisorFollowUpManagerNotified,'N') = 'Y'
								   )
----------Fall Manager-------------------------------------------------------------------------------------
								   OR 
								   ( CIRG.GeneralIncidentCategory IN (
										SELECT GlobalCodeId
										FROM GlobalCodes
										WHERE (Code = 'INCIDENTFALL')
											 AND ISNULL(RecordDeleted, 'N') = 'N'
									)
									and CIR.FallDetailVersionStatus = 22 
								    and CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
								    and CIR.FallSupervisorFollowUpVersionStatus = 22
								    and CIR.FallManagerFollowUpStatus = 21
								    and isnull(CIRFSF.SupervisorFollowUpManagerNotified,'N')= 'Y'
									)
----------Seizure Manager----------------------------------------------------------------------------------
								OR (
								 CIRG.GeneralIncidentCategory IN (
									SELECT GlobalCodeId
									FROM GlobalCodes
									WHERE (Code = 'INCIDENTSEIZURE')
										AND ISNULL(RecordDeleted, 'N') = 'N'
								  )
								 and CIR.SeizureDetailVersionStatus  = 22  
								 and cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22 
								 and cir.SeizureSupervisorFollowUpVersionStatus = 22
								 and cir.SeizureManagerFollowUpStatus = 21
	                             and isnull(CISF.SupervisorFollowUpManagerNotified,'N')= 'Y'
								 )
----------Fall & Seizure Manager---------------------------------------------------------------------------
								  OR (
								  CIRG.GeneralIncidentCategory IN (
										SELECT GlobalCodeId
										FROM GlobalCodes
										WHERE (Code = 'INCIDENTOTHER')
											AND ISNULL(RecordDeleted, 'N') = 'N'
									)
								    and((CIR.FallDetailVersionStatus = 22 
								    and CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
								    and CIR.FallSupervisorFollowUpVersionStatus = 22
								    and CIR.FallManagerFollowUpStatus = 21
								    and isnull(CIRFSF.SupervisorFollowUpManagerNotified,'N')= 'Y')
								    or (CIR.SeizureDetailVersionStatus  = 22  
								    and cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22 
								    and cir.SeizureSupervisorFollowUpVersionStatus = 22
								    and cir.SeizureManagerFollowUpStatus = 21
	                                and isnull(CISF.SupervisorFollowUpManagerNotified,'N')= 'Y'))
	                                and CIR.FallDetailVersionStatus = 22 
								    and CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
								    and CIR.FallSupervisorFollowUpVersionStatus = 22
								    and CIR.SeizureDetailVersionStatus  = 22  
								    and cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22 
								    and cir.SeizureSupervisorFollowUpVersionStatus = 22
									)
----------Incident & Fall Manager--------------------------------------------------------------------------
								   OR (
								   CIRG.GeneralIncidentCategory IN (
									SELECT GlobalCodeId
									FROM GlobalCodes
									WHERE (Code = 'INCIDENT')
										AND ISNULL(RecordDeleted, 'N') = 'N'
									)
									AND CIRG.GeneralSecondaryCategory IN (
										SELECT GlobalSubCodeId
										FROM GlobalSubCodes
										WHERE (
												Code = 'FALL'
												)
											AND ISNULL(RecordDeleted, 'N') = 'N'
										)
							        and((CIR.DetailVersionStatus = 22  
	                               and CIR.FollowUpOfIndividualStatusVersionStatus = 22
	                               and CIR.SupervisorFollowUpVersionStatus = 22
	                               and CIR.ManagerFollowUpStatus  = 21
	                               and isnull(CIRSF.SupervisorFollowUpManagerNotified,'N') = 'Y')
								    OR(CIR.FallDetailVersionStatus = 22 
								    and CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
								    and CIR.FallSupervisorFollowUpVersionStatus = 22
								    and CIR.FallManagerFollowUpStatus = 21
								    and isnull(CIRFSF.SupervisorFollowUpManagerNotified,'N')= 'Y'))
								    and CIR.DetailVersionStatus = 22  
	                                and CIR.FollowUpOfIndividualStatusVersionStatus = 22
	                                and CIR.SupervisorFollowUpVersionStatus = 22
	                                and CIR.FallDetailVersionStatus = 22 
								    and CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
								    and CIR.FallSupervisorFollowUpVersionStatus = 22
									) 
----------Incident & Seizure Manager-----------------------------------------------------------------------
									OR (
									CIRG.GeneralIncidentCategory IN (
										SELECT GlobalCodeId
										FROM GlobalCodes
										WHERE (Code = 'INCIDENT')
											AND ISNULL(RecordDeleted, 'N') = 'N'
										)
									AND CIRG.GeneralSecondaryCategory IN (
										SELECT GlobalSubCodeId
										FROM GlobalSubCodes
										WHERE (
												Code = 'SEIZURE'
												)
											AND ISNULL(RecordDeleted, 'N') = 'N'
										)
								   and ((CIR.DetailVersionStatus = 22  
	                               and CIR.FollowUpOfIndividualStatusVersionStatus = 22
	                               and CIR.SupervisorFollowUpVersionStatus = 22
	                               and CIR.ManagerFollowUpStatus  = 21
	                               and isnull(CIRSF.SupervisorFollowUpManagerNotified,'N') = 'Y')
	                               or(CIR.SeizureDetailVersionStatus  = 22  
								   and cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22 
								   and cir.SeizureSupervisorFollowUpVersionStatus = 22
								   and cir.SeizureManagerFollowUpStatus = 21
	                               and isnull(CISF.SupervisorFollowUpManagerNotified,'N')= 'Y'))
	                               and CIR.DetailVersionStatus = 22  
	                               and CIR.FollowUpOfIndividualStatusVersionStatus = 22
	                               and CIR.SupervisorFollowUpVersionStatus = 22
	                               and CIR.SeizureDetailVersionStatus  = 22  
								   and cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22 
								   and cir.SeizureSupervisorFollowUpVersionStatus = 22
								   )
----------Incident & Fall & Seizure Manager----------------------------------------------------------------
								  OR (
									CIRG.GeneralIncidentCategory IN (
										SELECT GlobalCodeId
										FROM GlobalCodes
										WHERE (Code = 'INCIDENT')
											AND ISNULL(RecordDeleted, 'N') = 'N'
										)
									AND CIRG.GeneralSecondaryCategory IN (
										SELECT GlobalSubCodeId
										FROM GlobalSubCodes
										WHERE (
												Code = 'FALLSEIZURE'
												)
											AND ISNULL(RecordDeleted, 'N') = 'N'
										)
								   and((CIR.DetailVersionStatus = 22  
	                               and CIR.FollowUpOfIndividualStatusVersionStatus = 22
	                               and CIR.SupervisorFollowUpVersionStatus = 22
	                               and CIR.ManagerFollowUpStatus  = 21
	                               and isnull(CIRSF.SupervisorFollowUpManagerNotified,'N') = 'Y')
	                               or(CIR.SeizureDetailVersionStatus  = 22  
								   and cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22 
								   and cir.SeizureSupervisorFollowUpVersionStatus = 22
								   and cir.SeizureManagerFollowUpStatus = 21
	                               and isnull(CISF.SupervisorFollowUpManagerNotified,'N')= 'Y')
	                               OR (CIR.FallDetailVersionStatus = 22 
								   and CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
								   and CIR.FallSupervisorFollowUpVersionStatus = 22
								   and CIR.FallManagerFollowUpStatus = 21
								   and isnull(CIRFSF.SupervisorFollowUpManagerNotified,'N')= 'Y'))
								   and CIR.DetailVersionStatus = 22  
	                               and CIR.FollowUpOfIndividualStatusVersionStatus = 22
	                               and CIR.SupervisorFollowUpVersionStatus = 22
	                               and CIR.SeizureDetailVersionStatus  = 22  
								   and cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22 
								   and cir.SeizureSupervisorFollowUpVersionStatus = 22
								   and CIR.FallDetailVersionStatus = 22 
								   and CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
								   and CIR.FallSupervisorFollowUpVersionStatus = 22
								   )
	                             )
	                             
	                             OR
	                             (
----------Incident Administrator---------------------------------------------------------------------------------
								(CIRG.GeneralIncidentCategory IN (
										SELECT GlobalCodeId
										FROM GlobalCodes
										WHERE (Code = 'INCIDENT')
											AND ISNULL(RecordDeleted, 'N') = 'N'
										) 
										AND  ISNULL(CIRG.GeneralSecondaryCategory,'') NOT IN (
												SELECT GlobalSubCodeId
												FROM GlobalSubCodes
												WHERE (
														Code = 'FALL'
														OR Code = 'SEIZURE'
														OR Code = 'FALLSEIZURE'
														)
											AND ISNULL(RecordDeleted, 'N') = 'N'
								   )
								  and CIR.DetailVersionStatus = 22 
	                              and CIR.FollowUpOfIndividualStatusVersionStatus = 22
	                              and CIR.SupervisorFollowUpVersionStatus = 22
	                              and ((CIR.ManagerFollowUpStatus  = 22
	                              and isnull(CIRSF.SupervisorFollowUpManagerNotified ,'N') = 'Y') 
	                                  OR isnull(CIRSF.SupervisorFollowUpManagerNotified,'N') = 'N')
	                              and (isnull(CIRSF.SupervisorFollowUpAdministratorNotified,'N') = 'Y' 
	                                  OR ISNULL(CIRMF.ManagerFollowUpAdministratorNotified,'N') = 'Y' )  
	                              and CIR.AdministratorReviewVersionStatus = 21
								  )
----------Fall Administrator-------------------------------------------------------------------------------------
								   OR 
								   ( CIRG.GeneralIncidentCategory IN (
										SELECT GlobalCodeId
										FROM GlobalCodes
										WHERE (Code = 'INCIDENTFALL')
											 AND ISNULL(RecordDeleted, 'N') = 'N'
									)
									  and CIR.FallDetailVersionStatus = 22 
									  and CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
									  and CIR.FallSupervisorFollowUpVersionStatus = 22
									  and ((CIR.FallManagerFollowUpStatus = 22
									  and isnull(CIRFSF.SupervisorFollowUpManagerNotified,'N')= 'Y')
										  OR isnull(CIRFSF.SupervisorFollowUpManagerNotified,'N')= 'N')
									  and (ISNULL(CIRFSF.FallSupervisorFollowUpAdministratorNotified,'N')='Y'
										  OR ISNULL(CIRFMF.ManagerFollowUpAdministratorNotified,'N')='Y' )
									  and CIR.FallAdministratorReviewVersionStatus = 21
									)
----------Seizure Administrator----------------------------------------------------------------------------------
									OR (
									 CIRG.GeneralIncidentCategory IN (
										SELECT GlobalCodeId
										FROM GlobalCodes
										WHERE (Code = 'INCIDENTSEIZURE')
											AND ISNULL(RecordDeleted, 'N') = 'N'
									  )
									 and CIR.SeizureDetailVersionStatus  = 22  
									 and cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22 
									 and cir.SeizureSupervisorFollowUpVersionStatus = 22
									 and ((cir.SeizureManagerFollowUpStatus = 22
									 and isnull(CISF.SupervisorFollowUpManagerNotified,'N')= 'Y') 
									 OR isnull(CISF.SupervisorFollowUpManagerNotified,'N')= 'N')
									 and (ISNULL(CISF.SeizureSupervisorFollowUpAdministratorNotified,'N')='Y'
									 OR ISNULL(CIRSMF.ManagerFollowUpAdministratorNotified,'N')='Y' )
								     and CIR.SeizureAdministratorReviewVersionStatus = 21
									 )
----------Fall & Seizure Administrator---------------------------------------------------------------------------
								  OR (
								  CIRG.GeneralIncidentCategory IN (
										SELECT GlobalCodeId
										FROM GlobalCodes
										WHERE (Code = 'INCIDENTOTHER')
											AND ISNULL(RecordDeleted, 'N') = 'N'
									)
								     and((CIR.FallDetailVersionStatus = 22 
									 and CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
									 and CIR.FallSupervisorFollowUpVersionStatus = 22
									 and ((CIR.FallManagerFollowUpStatus = 22
									 and isnull(CIRFSF.SupervisorFollowUpManagerNotified,'N')= 'Y')
										  OR isnull(CIRFSF.SupervisorFollowUpManagerNotified,'N')= 'N')
									 and (ISNULL(CIRFSF.FallSupervisorFollowUpAdministratorNotified,'N')='Y'
										  OR ISNULL(CIRFMF.ManagerFollowUpAdministratorNotified,'N')='Y' )
									 and CIR.FallAdministratorReviewVersionStatus = 21)
									 or (CIR.SeizureDetailVersionStatus  = 22  
									 and cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22 
									 and cir.SeizureSupervisorFollowUpVersionStatus = 22
									 and ((cir.SeizureManagerFollowUpStatus = 22
									 and isnull(CISF.SupervisorFollowUpManagerNotified,'N')= 'Y') 
									 OR isnull(CISF.SupervisorFollowUpManagerNotified,'N')= 'N')
									 and (ISNULL(CISF.SeizureSupervisorFollowUpAdministratorNotified,'N')='Y'
									 OR ISNULL(CIRSMF.ManagerFollowUpAdministratorNotified,'N')='Y' )
								     and CIR.SeizureAdministratorReviewVersionStatus = 21))
								     and CIR.FallDetailVersionStatus = 22 
									 and CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
									 and CIR.FallSupervisorFollowUpVersionStatus = 22
									 and ((CIR.FallManagerFollowUpStatus = 22
									 and isnull(CIRFSF.SupervisorFollowUpManagerNotified,'N')= 'Y')
										  OR isnull(CIRFSF.SupervisorFollowUpManagerNotified,'N')= 'N')
								     and CIR.SeizureDetailVersionStatus  = 22  
									 and cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22 
									 and cir.SeizureSupervisorFollowUpVersionStatus = 22
									 and ((cir.SeizureManagerFollowUpStatus = 22
									 and isnull(CISF.SupervisorFollowUpManagerNotified,'N')= 'Y') 
									 OR isnull(CISF.SupervisorFollowUpManagerNotified,'N')= 'N')
									)
----------Incident & Fall Administrator -------------------------------------------------------------------------
								   OR (
								   CIRG.GeneralIncidentCategory IN (
									SELECT GlobalCodeId
									FROM GlobalCodes
									WHERE (Code = 'INCIDENT')
										AND ISNULL(RecordDeleted, 'N') = 'N'
									)
									AND CIRG.GeneralSecondaryCategory IN (
										SELECT GlobalSubCodeId
										FROM GlobalSubCodes
										WHERE (
												Code = 'FALL'
												)
											AND ISNULL(RecordDeleted, 'N') = 'N'
									)
									and ((CIR.DetailVersionStatus = 22 
	                                and CIR.FollowUpOfIndividualStatusVersionStatus = 22
	                                and CIR.SupervisorFollowUpVersionStatus = 22
	                                and ((CIR.ManagerFollowUpStatus  = 22
	                                and isnull(CIRSF.SupervisorFollowUpManagerNotified ,'N') = 'Y') 
	                                  OR isnull(CIRSF.SupervisorFollowUpManagerNotified,'N') = 'N')
	                                and (isnull(CIRSF.SupervisorFollowUpAdministratorNotified,'N') = 'Y' 
	                                  OR ISNULL(CIRMF.ManagerFollowUpAdministratorNotified,'N') = 'Y' )  
	                                and CIR.AdministratorReviewVersionStatus = 21)
	                                 or (CIR.FallDetailVersionStatus = 22 
									 and CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
									 and CIR.FallSupervisorFollowUpVersionStatus = 22
									 and ((CIR.FallManagerFollowUpStatus = 22
									 and isnull(CIRFSF.SupervisorFollowUpManagerNotified,'N')= 'Y')
										  OR isnull(CIRFSF.SupervisorFollowUpManagerNotified,'N')= 'N')
									 and (ISNULL(CIRFSF.FallSupervisorFollowUpAdministratorNotified,'N')='Y'
										  OR ISNULL(CIRFMF.ManagerFollowUpAdministratorNotified,'N')='Y' )
									 and CIR.FallAdministratorReviewVersionStatus = 21))
									 and CIR.DetailVersionStatus = 22 
	                                and CIR.FollowUpOfIndividualStatusVersionStatus = 22
	                                and CIR.SupervisorFollowUpVersionStatus = 22
	                                and ((CIR.ManagerFollowUpStatus  = 22
	                                and isnull(CIRSF.SupervisorFollowUpManagerNotified ,'N') = 'Y') 
	                                  OR isnull(CIRSF.SupervisorFollowUpManagerNotified,'N') = 'N')
	                                  and CIR.FallDetailVersionStatus = 22 
									 and CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
									 and CIR.FallSupervisorFollowUpVersionStatus = 22
									 and ((CIR.FallManagerFollowUpStatus = 22
									 and isnull(CIRFSF.SupervisorFollowUpManagerNotified,'N')= 'Y')
										  OR isnull(CIRFSF.SupervisorFollowUpManagerNotified,'N')= 'N')
									) 
---------- Incident & Seizure Administrator ---------------------------------------------------------------------
									OR (
									CIRG.GeneralIncidentCategory IN (
										SELECT GlobalCodeId
										FROM GlobalCodes
										WHERE (Code = 'INCIDENT')
											AND ISNULL(RecordDeleted, 'N') = 'N'
										)
									AND CIRG.GeneralSecondaryCategory IN (
										SELECT GlobalSubCodeId
										FROM GlobalSubCodes
										WHERE (
												Code = 'SEIZURE'
												)
											AND ISNULL(RecordDeleted, 'N') = 'N'
										)
								    and ((CIR.DetailVersionStatus = 22 
	                                and CIR.FollowUpOfIndividualStatusVersionStatus = 22
	                                and CIR.SupervisorFollowUpVersionStatus = 22
	                                and ((CIR.ManagerFollowUpStatus  = 22
	                                and isnull(CIRSF.SupervisorFollowUpManagerNotified ,'N') = 'Y') 
	                                  OR isnull(CIRSF.SupervisorFollowUpManagerNotified,'N') = 'N')
	                                and (isnull(CIRSF.SupervisorFollowUpAdministratorNotified,'N') = 'Y' 
	                                  OR ISNULL(CIRMF.ManagerFollowUpAdministratorNotified,'N') = 'Y' )  
	                                and CIR.AdministratorReviewVersionStatus = 21)
	                                 OR (CIR.SeizureDetailVersionStatus  = 22  
									 and cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22 
									 and cir.SeizureSupervisorFollowUpVersionStatus = 22
									 and ((cir.SeizureManagerFollowUpStatus = 22
									 and isnull(CISF.SupervisorFollowUpManagerNotified,'N')= 'Y') 
									 OR isnull(CISF.SupervisorFollowUpManagerNotified,'N')= 'N')
									 and (ISNULL(CISF.SeizureSupervisorFollowUpAdministratorNotified,'N')='Y'
									 OR ISNULL(CIRSMF.ManagerFollowUpAdministratorNotified,'N')='Y' )
								     and CIR.SeizureAdministratorReviewVersionStatus = 21))
								     and CIR.DetailVersionStatus = 22 
	                                and CIR.FollowUpOfIndividualStatusVersionStatus = 22
	                                and CIR.SupervisorFollowUpVersionStatus = 22
	                                and ((CIR.ManagerFollowUpStatus  = 22
	                                and isnull(CIRSF.SupervisorFollowUpManagerNotified ,'N') = 'Y') 
	                                  OR isnull(CIRSF.SupervisorFollowUpManagerNotified,'N') = 'N')
	                                and CIR.SeizureDetailVersionStatus  = 22  
									 and cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22 
									 and cir.SeizureSupervisorFollowUpVersionStatus = 22
									 and ((cir.SeizureManagerFollowUpStatus = 22
									 and isnull(CISF.SupervisorFollowUpManagerNotified,'N')= 'Y') 
									 OR isnull(CISF.SupervisorFollowUpManagerNotified,'N')= 'N')
								   )
----------Incident & Fall & Seizure Administrator----------------------------------------------------------------
									OR (
									CIRG.GeneralIncidentCategory IN (
										SELECT GlobalCodeId
										FROM GlobalCodes
										WHERE (Code = 'INCIDENT')
											AND ISNULL(RecordDeleted, 'N') = 'N'
										)
									AND CIRG.GeneralSecondaryCategory IN (
										SELECT GlobalSubCodeId
										FROM GlobalSubCodes
										WHERE (
												Code = 'FALLSEIZURE'
												)
											AND ISNULL(RecordDeleted, 'N') = 'N'
										)
								    and ((CIR.DetailVersionStatus = 22 
	                                and CIR.FollowUpOfIndividualStatusVersionStatus = 22
	                                and CIR.SupervisorFollowUpVersionStatus = 22
	                                and ((CIR.ManagerFollowUpStatus  = 22
	                                and isnull(CIRSF.SupervisorFollowUpManagerNotified ,'N') = 'Y') 
	                                  OR isnull(CIRSF.SupervisorFollowUpManagerNotified,'N') = 'N')
	                                and (isnull(CIRSF.SupervisorFollowUpAdministratorNotified,'N') = 'Y' 
	                                  OR ISNULL(CIRMF.ManagerFollowUpAdministratorNotified,'N') = 'Y' )  
	                                and CIR.AdministratorReviewVersionStatus = 21)
	                                 OR (CIR.SeizureDetailVersionStatus  = 22  
									 and cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22 
									 and cir.SeizureSupervisorFollowUpVersionStatus = 22
									 and ((cir.SeizureManagerFollowUpStatus = 22
									 and isnull(CISF.SupervisorFollowUpManagerNotified,'N')= 'Y') 
									 OR isnull(CISF.SupervisorFollowUpManagerNotified,'N')= 'N')
									 and (ISNULL(CISF.SeizureSupervisorFollowUpAdministratorNotified,'N')='Y'
									 OR ISNULL(CIRSMF.ManagerFollowUpAdministratorNotified,'N')='Y' )
								     and CIR.SeizureAdministratorReviewVersionStatus = 21)
								     OR(CIR.FallDetailVersionStatus = 22 
									 and CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
									 and CIR.FallSupervisorFollowUpVersionStatus = 22
									 and ((CIR.FallManagerFollowUpStatus = 22
									 and isnull(CIRFSF.SupervisorFollowUpManagerNotified,'N')= 'Y')
										  OR isnull(CIRFSF.SupervisorFollowUpManagerNotified,'N')= 'N')
									 and (ISNULL(CIRFSF.FallSupervisorFollowUpAdministratorNotified,'N')='Y'
										  OR ISNULL(CIRFMF.ManagerFollowUpAdministratorNotified,'N')='Y' )
									 and CIR.FallAdministratorReviewVersionStatus = 21))
									 and CIR.DetailVersionStatus = 22 
	                                and CIR.FollowUpOfIndividualStatusVersionStatus = 22
	                                and CIR.SupervisorFollowUpVersionStatus = 22
	                                and ((CIR.ManagerFollowUpStatus  = 22
	                                and isnull(CIRSF.SupervisorFollowUpManagerNotified ,'N') = 'Y') 
	                                  OR isnull(CIRSF.SupervisorFollowUpManagerNotified,'N') = 'N')
	                                 and CIR.SeizureDetailVersionStatus  = 22  
									 and cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22 
									 and cir.SeizureSupervisorFollowUpVersionStatus = 22
									 and ((cir.SeizureManagerFollowUpStatus = 22
									 and isnull(CISF.SupervisorFollowUpManagerNotified,'N')= 'Y') 
									 OR isnull(CISF.SupervisorFollowUpManagerNotified,'N')= 'N')
									 and CIR.FallDetailVersionStatus = 22 
									 and CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
									 and CIR.FallSupervisorFollowUpVersionStatus = 22
									 and ((CIR.FallManagerFollowUpStatus = 22
									 and isnull(CIRFSF.SupervisorFollowUpManagerNotified,'N')= 'Y')
										  OR isnull(CIRFSF.SupervisorFollowUpManagerNotified,'N')= 'N')
								   )
	                             )

	                           )
				)

		-- OR ISNULL(CIR.AdministratorReviewVersionStatus, 21) = @Status    
		SELECT @IncidentReportsProgress AS IncidentReportsProgress
			,@IncidentReportsAssignedReview AS IncidentReportsAssignedReview
			,@RestrictiveProgress AS RestrictiveProgress
			,@RestrictiveAssignedReview AS RestrictiveAssignedReview
	END TRY

	BEGIN CATCH
		DECLARE @error VARCHAR(8000)

		SET @error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'csp_SCListPageIncidentReportsRestrictiveProcedure') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())

		RAISERROR (
				@error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
	END CATCH
END
