IF EXISTS (
		SELECT *
		FROM sysobjects
		WHERE type = 'P'
			AND NAME = 'csp_SCListPageIncidentReportsRestrictiveProcedure'
		)
BEGIN
	DROP PROCEDURE csp_SCListPageIncidentReportsRestrictiveProcedure
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_SCListPageIncidentReportsRestrictiveProcedure] (
	@PageNumber INT
	,@PageSize INT
	,@ClientId INT
	,@SortExpression VARCHAR(100)
	,@FromDate DATETIME
	,@ToDate DATETIME
	,@ProgramId INT
	,@FormId INT
	,@LocationOfIncident INT
	,@IncidentCategory INT
	,@SecondaryCategory INT
	,@IndividualName VARCHAR(MAX)
	,@RecordedBy INT
	,@Status INT
	,@Recorder CHAR(1)
	,@Nursing CHAR(1)
	,@Supervisior CHAR(1)
	,@Administrator CHAR(1)
	,@FromDashboard CHAR(1)
	,@LoggedInUser INT
	,@ResidentialUnit INT = NULL
	)
	/********************************************************************************                                                 
** Stored Procedure: ssp_SCListPageLevelOfCare                                                    
**                                                  
** Copyright: Streamline Healthcate Solutions                                                    
** Updates:                                                                                                         
** Date            Author              Purpose   
** 08-May-2015	   Revathi			   What:Task #818 Woods Customization  
** 18-Jun-2015	   Malathi Shiva	   Added StaffClients check 
*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		DECLARE @CustomFiltersApplied CHAR(1) = 'N'
		DECLARE @ApplyFilterClick AS CHAR(1)

		SET @SortExpression = RTRIM(LTRIM(@SortExpression))

		IF ISNULL(@SortExpression, '') = ''
			SET @SortExpression = 'DateTime desc'
			
		IF OBJECT_ID('tempdb..#ClientInpatientVisits') IS NOT NULL
			DROP TABLE #ClientInpatientVisits
		CREATE TABLE #ClientInpatientVisits (ClientId INT)

		INSERT INTO #ClientInpatientVisits(ClientId)
		SELECT DISTINCT CIV.ClientId
		FROM ClientInpatientVisits CIV
		JOIN BedAssignments BA ON CIV.ClientInpatientVisitId = BA.ClientInpatientVisitId
			AND CIV.[Status] IN (4982,4983)
			AND CIV.DischargedDate IS NULL
			AND ISNULL(CIV.RecordDeleted, 'N') = 'N'
			AND ISNULL(BA.RecordDeleted, 'N') = 'N'
			AND BA.[Status] IN (5002,5006)
			AND BA.Disposition IS NULL		
		WHERE EXISTS (
				SELECT 1
				FROM Units U
				JOIN UnitAvailabilityHistory UAH ON U.UnitId = UAH.UnitId AND UAH.EndDate IS NULL
				JOIN Rooms R ON UAH.UnitId = R.UnitId
				JOIN RoomAvailabilityHistory RAH ON R.RoomId = RAH.RoomId AND RAH.EndDate IS NULL
				JOIN Beds B ON RAH.RoomId = B.RoomId
				JOIN BedAvailabilityHistory BAH ON B.BedId = BAH.BedId AND BAH.EndDate IS NULL
				JOIN Programs P ON BAH.ProgramId = P.ProgramId
				WHERE ISNULL(B.RecordDeleted, 'N') = 'N'
					AND ISNULL(B.Active, 'N') = 'Y'
					AND ISNULL(BAH.RecordDeleted, 'N') = 'N'
					AND ISNULL(P.RecordDeleted, 'N') = 'N'
					AND ISNULL(U.RecordDeleted, 'N') = 'N'
					AND ISNULL(R.RecordDeleted, 'N') = 'N'
					AND ISNULL(P.ResidentialProgram, 'N') = 'Y'
					AND U.UnitId = @ResidentialUnit
					AND B.BedId = BA.BedId
				)

		--WHERE (ISNULL(@FromDate,'') = '' OR CAST(CONVERT(VARCHAR(10), BA.StartDate, 101) AS DATETIME) >= CAST(CONVERT(VARCHAR(10), @FromDate, 101) AS DATETIME))
		--	AND (ISNULL(@ToDate,'') = '' OR CAST(CONVERT(VARCHAR(10), BA.StartDate, 101) AS DATETIME) <= CAST(CONVERT(VARCHAR(10), @ToDate, 101) AS DATETIME))

	
		CREATE TABLE #ResultSet (
			FormId INT
			,IncidentReportId INT
			,RestrictiveProcedureId INT
			,DateTimes DATETIME
			,Times VARCHAR(50)
			,Individual VARCHAR(500)
			,ClientId INT
			,Program VARCHAR(500)
			,LocationOfIncident VARCHAR(500)
			,[Status] VARCHAR(500)
			,RecordedBy VARCHAR(500)
			,Form VARCHAR(500)
			)

		CREATE TABLE #SignedByStaff (
			StaffId INT
			,Roles CHAR(1)
			)

		INSERT INTO #SignedByStaff
		SELECT S.StaffId
			,'R'
		FROM Staff S
		JOIN staffRoles Sr ON s.StaffId = Sr.StaffId
		WHERE (
				ISNULL(@Recorder, 'N') = 'Y'
				AND sr.RoleId IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE category = 'StaffRole'
						AND Code = 'RECORDER'
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				AND ISNULL(S.RecordDeleted, 'N') = 'N'
				AND ISNULL(Sr.RecordDeleted, 'N') = 'N'
				)
		
		UNION
		
		SELECT S.StaffId
			,'n'
		FROM Staff S
		JOIN staffRoles Sr ON s.StaffId = Sr.StaffId
		WHERE (
				ISNULL(@Nursing, 'N') = 'Y'
				AND sr.RoleId IN (
					SELECT GlobalCodeId
					FROM GlobalCodes
					WHERE category = 'StaffRole'
						AND Code = 'NURSE'
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				AND ISNULL(S.RecordDeleted, 'N') = 'N'
				AND ISNULL(Sr.RecordDeleted, 'N') = 'N'
				)
		
		UNION
		
		SELECT S.StaffId
			,'S'
		FROM Staff S
		JOIN staffRoles Sr ON s.StaffId = Sr.StaffId
		WHERE ISNULL(@Supervisior, 'N') = 'Y'
			AND sr.RoleId = 4008
			AND ISNULL(S.RecordDeleted, 'N') = 'N'
			AND ISNULL(Sr.RecordDeleted, 'N') = 'N'
		
		UNION
		
		SELECT S.StaffId
			,'A'
		FROM staff s
		WHERE ISNULL(@Administrator, 'N') = 'Y'
			AND s.AdminStaff = 'Y'
			AND ISNULL(S.RecordDeleted, 'N') = 'N'

		IF (
				ISNULL(@FormId, - 1) = - 1
				OR @FormId = 1
				)
		BEGIN
			INSERT INTO #ResultSet (
				FormId
				,IncidentReportId
				,DateTimes
				,Times
				,Individual
				,ClientId
				,Program
				,LocationOfIncident
				,[Status]
				,RecordedBy
				,Form
				)
			SELECT DISTINCT 1
				,CIR.IncidentReportId
				,CIRG.GeneralDateOfIncident
				,(right('0' + LTRIM(SUBSTRING(CONVERT(VARCHAR, CIRG.GeneralTimeOfIncident, 100), 13, 2)), 2) + ':' +
				 SUBSTRING(CONVERT(VARCHAR, CIRG.GeneralTimeOfIncident, 100), 16, 2) + ' ' + 
				 SUBSTRING(CONVERT(VARCHAR, CIRG.GeneralTimeOfIncident, 100), 18, 2)) AS GeneralTimeOfIncident
				,(IsNull(C.LastName, '') + coalesce(' , ' + C.FirstName, '')) AS ClientName
				,CIR.ClientId
				,P.ProgramName
				,dbo.csf_GetGlobalCodeNameById(CIRG.GeneralLocationOfIncident) AS LocationOfIncident
				
------------ In Progress -----------------------------------------------------------------------------------
					,(case when ( 
			
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
				 then 'In Progress'

------------ Nursing ---------------------------------------------------------------------------------------
	              else case when (
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
								 )   
	
	             ) then 'Nursing'

-----------Supervisor  ---------------------------------------------------------------------------              
	             else case when (
	             
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
	                              and (CIR.FollowUpOfIndividualStatusVersionStatus = 22
									  or CIRD.DetailsStaffNotifiedForInjury is null
									  or isnull(CIRD.DetailsNoMedicalStaffNotified,'N') = 'Y' 
	                              )
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
									and (CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
										OR isnull(CIRF.FallDetailsNoMedicalStaffNotified,'N') = 'Y'
										OR CIRF.FallDetailsStaffNotifiedForInjury IS null
									)
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
								  and (cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22
									  or CISD.IncidentSeizureDetailsStaffNotifiedForInjury Is null
									  OR isnull(CISD.IncidentSeizureDetailsNoMedicalStaffNotified,'N') = 'Y' 
								   )
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
									and (CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
										OR isnull(CIRF.FallDetailsNoMedicalStaffNotified,'N') = 'Y'
										OR CIRF.FallDetailsStaffNotifiedForInjury IS null) 
									and CIR.FallSupervisorFollowUpVersionStatus = 21
									and CIRF.FallDetailsSupervisorFlaggedId is not null)
									or (CIR.SeizureDetailVersionStatus  = 22  
								    and (cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22
									  or CISD.IncidentSeizureDetailsStaffNotifiedForInjury Is null
									  OR isnull(CISD.IncidentSeizureDetailsNoMedicalStaffNotified,'N') = 'Y') 
								    and cir.SeizureSupervisorFollowUpVersionStatus = 21
	                                and CISD.IncidentSeizureDetailsSupervisorFlaggedId Is Not null))
	                                and CIR.FallDetailVersionStatus = 22 
									and (CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
										OR isnull(CIRF.FallDetailsNoMedicalStaffNotified,'N') = 'Y'
										OR CIRF.FallDetailsStaffNotifiedForInjury IS null)
									and CIR.SeizureDetailVersionStatus  = 22  
								      and (cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22
									  or CISD.IncidentSeizureDetailsStaffNotifiedForInjury Is null
									  OR isnull(CISD.IncidentSeizureDetailsNoMedicalStaffNotified,'N') = 'Y')
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
	                                and (CIR.FollowUpOfIndividualStatusVersionStatus = 22
									  or CIRD.DetailsStaffNotifiedForInjury is null
									  or isnull(CIRD.DetailsNoMedicalStaffNotified,'N') = 'Y' )
	                                and CIR.SupervisorFollowUpVersionStatus = 21
	                                and CIRD.DetailsSupervisorFlaggedId  is not null)
	                                or(CIR.FallDetailVersionStatus = 22 
									and (CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
										OR isnull(CIRF.FallDetailsNoMedicalStaffNotified,'N') = 'Y'
										OR CIRF.FallDetailsStaffNotifiedForInjury IS null)
									and CIR.FallSupervisorFollowUpVersionStatus = 21
									and CIRF.FallDetailsSupervisorFlaggedId is not null))
									and CIR.DetailVersionStatus = 22  
	                                and (CIR.FollowUpOfIndividualStatusVersionStatus = 22
									  or CIRD.DetailsStaffNotifiedForInjury is null
									  or isnull(CIRD.DetailsNoMedicalStaffNotified,'N') = 'Y' 
	                                )
	                                and CIR.FallDetailVersionStatus = 22 
									and (CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
										OR isnull(CIRF.FallDetailsNoMedicalStaffNotified,'N') = 'Y'
										OR CIRF.FallDetailsStaffNotifiedForInjury IS null)
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
	                                and (CIR.FollowUpOfIndividualStatusVersionStatus = 22
									  or CIRD.DetailsStaffNotifiedForInjury is null
									  or isnull(CIRD.DetailsNoMedicalStaffNotified,'N') = 'Y')
	                                and CIR.SupervisorFollowUpVersionStatus = 21
	                                and CIRD.DetailsSupervisorFlaggedId  is not null)
	                                or(CIR.SeizureDetailVersionStatus  = 22  
								      and (cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22
									  or CISD.IncidentSeizureDetailsStaffNotifiedForInjury Is null
									  OR isnull(CISD.IncidentSeizureDetailsNoMedicalStaffNotified,'N') = 'Y')
								    and cir.SeizureSupervisorFollowUpVersionStatus = 21
	                                and CISD.IncidentSeizureDetailsSupervisorFlaggedId Is Not null))
	                                and CIR.DetailVersionStatus = 22  
	                                and (CIR.FollowUpOfIndividualStatusVersionStatus = 22
									  or CIRD.DetailsStaffNotifiedForInjury is null
									  or isnull(CIRD.DetailsNoMedicalStaffNotified,'N') = 'Y')
	                                and CIR.SeizureDetailVersionStatus  = 22  
								      and (cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22
									  or CISD.IncidentSeizureDetailsStaffNotifiedForInjury Is null
									  OR isnull(CISD.IncidentSeizureDetailsNoMedicalStaffNotified,'N') = 'Y')
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
	                                and (CIR.FollowUpOfIndividualStatusVersionStatus = 22
									  or CIRD.DetailsStaffNotifiedForInjury is null
									  or isnull(CIRD.DetailsNoMedicalStaffNotified,'N') = 'Y')
	                                and CIR.SupervisorFollowUpVersionStatus = 21
	                                and CIRD.DetailsSupervisorFlaggedId  is not null)
	                                or(CIR.FallDetailVersionStatus = 22 
									and (CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
										OR isnull(CIRF.FallDetailsNoMedicalStaffNotified,'N') = 'Y'
										OR CIRF.FallDetailsStaffNotifiedForInjury IS null)
									and CIR.FallSupervisorFollowUpVersionStatus = 21
									and CIRF.FallDetailsSupervisorFlaggedId is not null)
									or (CIR.SeizureDetailVersionStatus  = 22  
								      and (cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22
									  or CISD.IncidentSeizureDetailsStaffNotifiedForInjury Is null
									  OR isnull(CISD.IncidentSeizureDetailsNoMedicalStaffNotified,'N') = 'Y')
								    and cir.SeizureSupervisorFollowUpVersionStatus = 21
	                                and CISD.IncidentSeizureDetailsSupervisorFlaggedId Is Not null))
	                                and CIR.DetailVersionStatus = 22  
	                                and (CIR.FollowUpOfIndividualStatusVersionStatus = 22
									  or CIRD.DetailsStaffNotifiedForInjury is null
									  or isnull(CIRD.DetailsNoMedicalStaffNotified,'N') = 'Y')
	                                and CIR.FallDetailVersionStatus = 22 
									and (CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
										OR isnull(CIRF.FallDetailsNoMedicalStaffNotified,'N') = 'Y'
										OR CIRF.FallDetailsStaffNotifiedForInjury IS null)
									and CIR.SeizureDetailVersionStatus  = 22  
								      and (cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22
									  or CISD.IncidentSeizureDetailsStaffNotifiedForInjury Is null
									  OR isnull(CISD.IncidentSeizureDetailsNoMedicalStaffNotified,'N') = 'Y')
									)

	            ) then 'Supervisor' 

----------Manager -----------------------------------------------------------------------------------------              
	             else case when (
	             
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
             then 'Manager' 
             
----------Administrator------------------------------------------------------------------------------------              
	        else case when (
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
			 then 'Administrator' 


---------- Complete  -----------------------------------------------------------------------------------------              
	         else case when (

----------Incident Complete---------------------------------------------------------------------------------
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
	                              and (((isnull(CIRSF.SupervisorFollowUpAdministratorNotified,'N') = 'Y' 
	                                  OR ISNULL(CIRMF.ManagerFollowUpAdministratorNotified,'N') = 'Y') 
	                              and CIR.AdministratorReviewVersionStatus = 22)
	                              OR(isnull(CIRSF.SupervisorFollowUpAdministratorNotified,'N') = 'N' 
	                              and ISNULL(CIRMF.ManagerFollowUpAdministratorNotified,'N') = 'N') )  
								  )
----------Fall Complete-------------------------------------------------------------------------------------
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
								   and (((ISNULL(CIRFSF.FallSupervisorFollowUpAdministratorNotified,'N')='Y'
									  OR ISNULL(CIRFMF.ManagerFollowUpAdministratorNotified,'N')='Y' )
								   and CIR.FallAdministratorReviewVersionStatus = 22)
								   or (ISNULL(CIRFSF.FallSupervisorFollowUpAdministratorNotified,'N')='N'
								   AND ISNULL(CIRFMF.ManagerFollowUpAdministratorNotified,'N')='N') ) 
								   )
----------Seizure Complete----------------------------------------------------------------------------------
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
									 and (((ISNULL(CISF.SeizureSupervisorFollowUpAdministratorNotified,'N')='Y'
									  OR ISNULL(CIRSMF.ManagerFollowUpAdministratorNotified,'N')='Y' )
									 and CIR.SeizureAdministratorReviewVersionStatus = 22)
									  or (ISNULL(CISF.SeizureSupervisorFollowUpAdministratorNotified,'N')='N'
									 and ISNULL(CIRSMF.ManagerFollowUpAdministratorNotified,'N')='N' ))     
									 )
----------Fall & Seizure Complete---------------------------------------------------------------------------
								   OR (
								   CIRG.GeneralIncidentCategory IN (
										SELECT GlobalCodeId
										FROM GlobalCodes
										WHERE (Code = 'INCIDENTOTHER')
											AND ISNULL(RecordDeleted, 'N') = 'N'
									)
								    and ((CIR.FallDetailVersionStatus = 22 
								    and CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
								    and CIR.FallSupervisorFollowUpVersionStatus = 22
								    and ((CIR.FallManagerFollowUpStatus = 22
								    and isnull(CIRFSF.SupervisorFollowUpManagerNotified,'N')= 'Y')
									  OR isnull(CIRFSF.SupervisorFollowUpManagerNotified,'N')= 'N')
								    and (((ISNULL(CIRFSF.FallSupervisorFollowUpAdministratorNotified,'N')='Y'
									  OR ISNULL(CIRFMF.ManagerFollowUpAdministratorNotified,'N')='Y' )
								    and CIR.FallAdministratorReviewVersionStatus = 22)
								     or (ISNULL(CIRFSF.FallSupervisorFollowUpAdministratorNotified,'N')='N'
								     AND ISNULL(CIRFMF.ManagerFollowUpAdministratorNotified,'N')='N') ))
								     and (CIR.SeizureDetailVersionStatus  = 22  
									 and cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22 
									 and cir.SeizureSupervisorFollowUpVersionStatus = 22
									 and ((cir.SeizureManagerFollowUpStatus = 22
									 and isnull(CISF.SupervisorFollowUpManagerNotified,'N')= 'Y') 
										 OR isnull(CISF.SupervisorFollowUpManagerNotified,'N')= 'N')
									 and (((ISNULL(CISF.SeizureSupervisorFollowUpAdministratorNotified,'N')='Y'
									  OR ISNULL(CIRSMF.ManagerFollowUpAdministratorNotified,'N')='Y' )
									 and CIR.SeizureAdministratorReviewVersionStatus = 22)
									  or (ISNULL(CISF.SeizureSupervisorFollowUpAdministratorNotified,'N')='N'
									 and ISNULL(CIRSMF.ManagerFollowUpAdministratorNotified,'N')='N' ))))
									)
----------Incident & Fall Complete--------------------------------------------------------------------------
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
	                              and (((isnull(CIRSF.SupervisorFollowUpAdministratorNotified,'N') = 'Y' 
	                                  OR ISNULL(CIRMF.ManagerFollowUpAdministratorNotified,'N') = 'Y') 
	                              and CIR.AdministratorReviewVersionStatus = 22)
	                              OR(isnull(CIRSF.SupervisorFollowUpAdministratorNotified,'N') = 'N' 
	                              and ISNULL(CIRMF.ManagerFollowUpAdministratorNotified,'N') = 'N') ))
								   and (CIR.FallDetailVersionStatus = 22 
								   and CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
								   and CIR.FallSupervisorFollowUpVersionStatus = 22
								   and ((CIR.FallManagerFollowUpStatus = 22
								   and isnull(CIRFSF.SupervisorFollowUpManagerNotified,'N')= 'Y')
									  OR isnull(CIRFSF.SupervisorFollowUpManagerNotified,'N')= 'N')
								   and (((ISNULL(CIRFSF.FallSupervisorFollowUpAdministratorNotified,'N')='Y'
									  OR ISNULL(CIRFMF.ManagerFollowUpAdministratorNotified,'N')='Y' )
								   and CIR.FallAdministratorReviewVersionStatus = 22)
								   or (ISNULL(CIRFSF.FallSupervisorFollowUpAdministratorNotified,'N')='N'
								   AND ISNULL(CIRFMF.ManagerFollowUpAdministratorNotified,'N')='N') )))
								   ) 
----------Incident & Seizure Complete-----------------------------------------------------------------------
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
	                              and (((isnull(CIRSF.SupervisorFollowUpAdministratorNotified,'N') = 'Y' 
	                                  OR ISNULL(CIRMF.ManagerFollowUpAdministratorNotified,'N') = 'Y') 
	                              and CIR.AdministratorReviewVersionStatus = 22)
	                              OR(isnull(CIRSF.SupervisorFollowUpAdministratorNotified,'N') = 'N' 
	                              and ISNULL(CIRMF.ManagerFollowUpAdministratorNotified,'N') = 'N') ))
								   and (CIR.SeizureDetailVersionStatus  = 22  
									 and cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22 
									 and cir.SeizureSupervisorFollowUpVersionStatus = 22
									 and ((cir.SeizureManagerFollowUpStatus = 22
									 and isnull(CISF.SupervisorFollowUpManagerNotified,'N')= 'Y') 
										 OR isnull(CISF.SupervisorFollowUpManagerNotified,'N')= 'N')
									 and (((ISNULL(CISF.SeizureSupervisorFollowUpAdministratorNotified,'N')='Y'
									  OR ISNULL(CIRSMF.ManagerFollowUpAdministratorNotified,'N')='Y' )
									 and CIR.SeizureAdministratorReviewVersionStatus = 22)
									  or (ISNULL(CISF.SeizureSupervisorFollowUpAdministratorNotified,'N')='N'
									 and ISNULL(CIRSMF.ManagerFollowUpAdministratorNotified,'N')='N' ))))
								   )
----------Incident & Fall & Seizure Complete----------------------------------------------------------------
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
	                              and (((isnull(CIRSF.SupervisorFollowUpAdministratorNotified,'N') = 'Y' 
	                                  OR ISNULL(CIRMF.ManagerFollowUpAdministratorNotified,'N') = 'Y') 
	                              and CIR.AdministratorReviewVersionStatus = 22)
	                              OR(isnull(CIRSF.SupervisorFollowUpAdministratorNotified,'N') = 'N' 
	                              and ISNULL(CIRMF.ManagerFollowUpAdministratorNotified,'N') = 'N') ))
								   and (CIR.SeizureDetailVersionStatus  = 22  
									 and cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22 
									 and cir.SeizureSupervisorFollowUpVersionStatus = 22
									 and ((cir.SeizureManagerFollowUpStatus = 22
									 and isnull(CISF.SupervisorFollowUpManagerNotified,'N')= 'Y') 
										 OR isnull(CISF.SupervisorFollowUpManagerNotified,'N')= 'N')
									 and (((ISNULL(CISF.SeizureSupervisorFollowUpAdministratorNotified,'N')='Y'
									  OR ISNULL(CIRSMF.ManagerFollowUpAdministratorNotified,'N')='Y' )
									 and CIR.SeizureAdministratorReviewVersionStatus = 22)
									  or (ISNULL(CISF.SeizureSupervisorFollowUpAdministratorNotified,'N')='N'
									 and ISNULL(CIRSMF.ManagerFollowUpAdministratorNotified,'N')='N' )))
									 and (CIR.FallDetailVersionStatus = 22 
								   and CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
								   and CIR.FallSupervisorFollowUpVersionStatus = 22
								   and ((CIR.FallManagerFollowUpStatus = 22
								   and isnull(CIRFSF.SupervisorFollowUpManagerNotified,'N')= 'Y')
									  OR isnull(CIRFSF.SupervisorFollowUpManagerNotified,'N')= 'N')
								   and (((ISNULL(CIRFSF.FallSupervisorFollowUpAdministratorNotified,'N')='Y'
									  OR ISNULL(CIRFMF.ManagerFollowUpAdministratorNotified,'N')='Y' )
								   and CIR.FallAdministratorReviewVersionStatus = 22)
								   or (ISNULL(CIRFSF.FallSupervisorFollowUpAdministratorNotified,'N')='N'
								   AND ISNULL(CIRFMF.ManagerFollowUpAdministratorNotified,'N')='N') )))
								   )

			) then 'Complete' 
---------------------------------------------------------------------------------------------------	             
				end end end end end end
				)as [Status]
				
				,(IsNull(S.LastName, '') + coalesce(' , ' + S.FirstName, '')) AS RecordedBy
				,'Incident Report' AS Form
			FROM CustomIncidentReportGenerals CIRG
			INNER JOIN CustomIncidentReports CIR ON CIR.IncidentReportId = CIRG.IncidentReportId
			LEFT JOIN Clients C ON C.ClientId = CIR.ClientId
				AND ISNULL(C.RecordDeleted, 'N') = 'N'
			LEFT JOIN Programs P ON P.ProgramId = CIRG.GeneralProgram
				AND ISNULL(P.RecordDeleted, 'N') = 'N'
			LEFT JOIN Staff S ON S.UserCode = CIR.CreatedBy
				AND ISNULL(S.RecordDeleted, 'N') = 'N'
			LEFT JOIN CustomIncidentReportDetails CIRD ON CIRD.IncidentReportDetailId = CIR.IncidentReportDetailId
				AND CIRD.IncidentReportId = CIR.IncidentReportId
				AND ISNULL(CIRD.RecordDeleted, 'N') = 'N'
			LEFT JOIN CustomIncidentReportFollowUpOfIndividualStatuses CIRFI ON CIRFI.IncidentReportFollowUpOfIndividualStatusId = CIR.IncidentReportFollowUpOfIndividualStatusId
				AND CIRFI.IncidentReportId = CIR.IncidentReportId
				AND ISNULL(CIRFI.RecordDeleted, 'N') = 'N'
			LEFT JOIN CustomIncidentReportSupervisorFollowUps CIRSF ON CIRSF.IncidentReportSupervisorFollowUpId = CIR.IncidentReportSupervisorFollowUpId
				AND CIRSF.IncidentReportId = CIR.IncidentReportId
				AND ISNULL(CIRSF.RecordDeleted, 'N') = 'N'
		    LEFT JOIN CustomIncidentReportManagerFollowUps CIRMF ON CIRMF.IncidentReportManagerFollowUpId = CIR.IncidentReportManagerFollowUpId
				AND CIRMF.IncidentReportId = CIR.IncidentReportId
				AND ISNULL(CIRMF.RecordDeleted, 'N') = 'N'
			LEFT JOIN CustomIncidentReportAdministratorReviews CIRAR ON CIRAR.IncidentReportAdministratorReviewId = CIR.IncidentReportAdministratorReviewId
				AND CIRAR.IncidentReportId = CIR.IncidentReportId
				AND ISNULL(CIRAR.RecordDeleted, 'N') = 'N'
			LEFT JOIN CustomIncidentReportFallDetails CIRF ON CIRF.IncidentReportFallDetailId = CIR.IncidentReportFallDetailId
				AND CIRF.IncidentReportId = CIR.IncidentReportId
				AND ISNULL(CIRF.RecordDeleted, 'N') = 'N'
			LEFT JOIN CustomIncidentReportFallFollowUpOfIndividualStatuses CIRFS ON CIRFS.IncidentReportFallFollowUpOfIndividualStatusId = CIR.IncidentReportFallFollowUpOfIndividualStatusId
				AND CIRFS.IncidentReportId = CIR.IncidentReportId
				AND ISNULL(CIRFS.RecordDeleted, 'N') = 'N'
			LEFT JOIN CustomIncidentReportFallSupervisorFollowUps CIRFSF ON CIRFSF.IncidentReportFallSupervisorFollowUpId = CIR.IncidentReportFallSupervisorFollowUpId
				AND CIRFSF.IncidentReportId = CIR.IncidentReportId
				AND ISNULL(CIRFSF.RecordDeleted, 'N') = 'N'
		    LEFT JOIN CustomIncidentReportFallManagerFollowUps  CIRFMF ON CIRFMF.IncidentReportFallManagerFollowUpId = CIR.IncidentReportFallManagerFollowUpId
				AND CIRFMF.IncidentReportId = CIR.IncidentReportId
				AND ISNULL(CIRFMF.RecordDeleted, 'N') = 'N'
			LEFT JOIN CustomIncidentReportFallAdministratorReviews CIRFAR ON CIRFAR.IncidentReportFallAdministratorReviewId = CIR.IncidentReportFallAdministratorReviewId
				AND CIRFAR.IncidentReportId = CIR.IncidentReportId
				AND ISNULL(CIRFAR.RecordDeleted, 'N') = 'N'
			LEFT JOIN CustomIncidentSeizureDetails CISD ON CISD.IncidentSeizureDetailId = CIR.IncidentSeizureDetailId
				AND CISD.IncidentReportId = CIR.IncidentReportId
				AND ISNULL(CISD.RecordDeleted, 'N') = 'N'
			LEFT JOIN CustomIncidentReportSeizureFollowUpOfIndividualStatuses CISFI ON CISFI.IncidentReportSeizureFollowUpOfIndividualStatusId = CIR.IncidentReportSeizureFollowUpOfIndividualStatusId
				AND CISFI.IncidentReportId = CIR.IncidentReportId
				AND ISNULL(CISFI.RecordDeleted, 'N') = 'N'
			LEFT JOIN CustomIncidentReportSeizureSupervisorFollowUps CISF ON CISF.IncidentReportSeizureSupervisorFollowUpId = CIR.IncidentReportSeizureSupervisorFollowUpId
				AND CISF.IncidentReportId = CIR.IncidentReportId
				AND ISNULL(CISF.RecordDeleted, 'N') = 'N'
		    LEFT JOIN CustomIncidentReportSeizureManagerFollowUps   CIRSMF ON CIRSMF.IncidentReportSeizureManagerFollowUpId = CIR.IncidentReportSeizureManagerFollowUpId
				AND CIRSMF.IncidentReportId = CIR.IncidentReportId
				AND ISNULL(CIRSMF.RecordDeleted, 'N') = 'N'
			LEFT JOIN CustomIncidentReportSeizureAdministratorReviews CISFR ON CISFR.IncidentReportSeizureAdministratorReviewId = CIR.IncidentReportSeizureAdministratorReviewId
				AND CISFR.IncidentReportId = CIR.IncidentReportId
				AND ISNULL(CISFR.RecordDeleted, 'N') = 'N'
			JOIN StaffClients sc ON sc.StaffId = @LoggedInUser
				AND sc.ClientId = CIR.ClientId
			WHERE ISNULL(CIRG.RecordDeleted, 'N') = 'N'
				AND (ISNULL(@ResidentialUnit,0) <=0 OR EXISTS(SELECT 1 FROM #ClientInpatientVisits CIV WHERE CIV.ClientId = CIR.ClientId))
				AND ISNULL(CIR.RecordDeleted, 'N') = 'N'
				AND (
					ISNULL(@ClientId, - 1) = - 1
					OR CIR.ClientId = @ClientId
					)
				AND (
					ISNULL(@FromDate, '') = ''
					OR CAST(CIRG.GeneralDateOfIncident AS DATE) >= CAST(@FromDate AS DATE)
					)
				AND (
					ISNULL(@ToDate, '') = ''
					OR CAST(CIRG.GeneralDateOfIncident AS DATE) <= CAST(@ToDate AS DATE)
					)
				AND (
					ISNULL(@ProgramId, - 1) = - 1
					OR CIRG.GeneralProgram = @ProgramId
					)
				AND (
					ISNULL(@LocationOfIncident, - 1) = - 1
					OR CIRG.GeneralLocationOfIncident = @LocationOfIncident
					)
				AND (
					ISNULL(@IncidentCategory, - 1) = - 1
					OR CIRG.GeneralIncidentCategory = @IncidentCategory
					)
				AND (
					ISNULL(@SecondaryCategory, 0) = 0
					OR CIRG.GeneralSecondaryCategory = @SecondaryCategory
					)
				AND (
					ISNULL(@FormId, - 1) = - 1
					OR @FormId = 1
					)
				AND (
					ISNULL(@IndividualName, '') = ''
					OR (
						C.LastName LIKE '%' + @IndividualName + '%'
						OR C.FirstName LIKE '%' + @IndividualName + '%'
						)
					)
				AND (
					(
						(
							ISNULL(@RecordedBy, - 1) = - 1
							OR S.StaffId = @RecordedBy
							)
						AND ISNULL(@FromDashboard, 'N') = 'N'
						)
					OR ISNULL(@FromDashboard, 'N') = 'Y'
					)
				--AND (EXISTS (Select SC.ClientId from StaffClients SC  where SC.StaffId = @LoggedInUser and SC.ClientId = C.ClientId ) )    
	           
	            AND (
	               
-------------In Progress Status = 21 -------------------------------------------------------------------- 	            
	                     (@Status = 21 AND 
	                        (
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
	                     )
--------- Review =9 ----------------------------------------------------------------------------------------
								 OR @Status = 9 and (
								 
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
	                              and (CIR.FollowUpOfIndividualStatusVersionStatus = 22
									  or CIRD.DetailsStaffNotifiedForInjury is null
									  or isnull(CIRD.DetailsNoMedicalStaffNotified,'N') = 'Y' 
	                              )
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
									and (CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
										OR isnull(CIRF.FallDetailsNoMedicalStaffNotified,'N') = 'Y'
										OR CIRF.FallDetailsStaffNotifiedForInjury IS null
									)
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
								  and (cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22
									  or CISD.IncidentSeizureDetailsStaffNotifiedForInjury Is null
									  OR isnull(CISD.IncidentSeizureDetailsNoMedicalStaffNotified,'N') = 'Y' 
								   )
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
									and (CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
										OR isnull(CIRF.FallDetailsNoMedicalStaffNotified,'N') = 'Y'
										OR CIRF.FallDetailsStaffNotifiedForInjury IS null) 
									and CIR.FallSupervisorFollowUpVersionStatus = 21
									and CIRF.FallDetailsSupervisorFlaggedId is not null)
									or (CIR.SeizureDetailVersionStatus  = 22  
								    and (cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22
									  or CISD.IncidentSeizureDetailsStaffNotifiedForInjury Is null
									  OR isnull(CISD.IncidentSeizureDetailsNoMedicalStaffNotified,'N') = 'Y') 
								    and cir.SeizureSupervisorFollowUpVersionStatus = 21
	                                and CISD.IncidentSeizureDetailsSupervisorFlaggedId Is Not null))
	                                and CIR.FallDetailVersionStatus = 22 
									and (CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
										OR isnull(CIRF.FallDetailsNoMedicalStaffNotified,'N') = 'Y'
										OR CIRF.FallDetailsStaffNotifiedForInjury IS null)
									and CIR.SeizureDetailVersionStatus  = 22  
								      and (cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22
									  or CISD.IncidentSeizureDetailsStaffNotifiedForInjury Is null
									  OR isnull(CISD.IncidentSeizureDetailsNoMedicalStaffNotified,'N') = 'Y')
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
	                                and (CIR.FollowUpOfIndividualStatusVersionStatus = 22
									  or CIRD.DetailsStaffNotifiedForInjury is null
									  or isnull(CIRD.DetailsNoMedicalStaffNotified,'N') = 'Y' )
	                                and CIR.SupervisorFollowUpVersionStatus = 21
	                                and CIRD.DetailsSupervisorFlaggedId  is not null)
	                                or(CIR.FallDetailVersionStatus = 22 
									and (CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
										OR isnull(CIRF.FallDetailsNoMedicalStaffNotified,'N') = 'Y'
										OR CIRF.FallDetailsStaffNotifiedForInjury IS null)
									and CIR.FallSupervisorFollowUpVersionStatus = 21
									and CIRF.FallDetailsSupervisorFlaggedId is not null))
									and CIR.DetailVersionStatus = 22  
	                                and (CIR.FollowUpOfIndividualStatusVersionStatus = 22
									  or CIRD.DetailsStaffNotifiedForInjury is null
									  or isnull(CIRD.DetailsNoMedicalStaffNotified,'N') = 'Y' 
	                                )
	                                and CIR.FallDetailVersionStatus = 22 
									and (CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
										OR isnull(CIRF.FallDetailsNoMedicalStaffNotified,'N') = 'Y'
										OR CIRF.FallDetailsStaffNotifiedForInjury IS null)
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
	                                and (CIR.FollowUpOfIndividualStatusVersionStatus = 22
									  or CIRD.DetailsStaffNotifiedForInjury is null
									  or isnull(CIRD.DetailsNoMedicalStaffNotified,'N') = 'Y')
	                                and CIR.SupervisorFollowUpVersionStatus = 21
	                                and CIRD.DetailsSupervisorFlaggedId  is not null)
	                                or(CIR.SeizureDetailVersionStatus  = 22  
								      and (cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22
									  or CISD.IncidentSeizureDetailsStaffNotifiedForInjury Is null
									  OR isnull(CISD.IncidentSeizureDetailsNoMedicalStaffNotified,'N') = 'Y')
								    and cir.SeizureSupervisorFollowUpVersionStatus = 21
	                                and CISD.IncidentSeizureDetailsSupervisorFlaggedId Is Not null))
	                                and CIR.DetailVersionStatus = 22  
	                                and (CIR.FollowUpOfIndividualStatusVersionStatus = 22
									  or CIRD.DetailsStaffNotifiedForInjury is null
									  or isnull(CIRD.DetailsNoMedicalStaffNotified,'N') = 'Y')
	                                and CIR.SeizureDetailVersionStatus  = 22  
								      and (cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22
									  or CISD.IncidentSeizureDetailsStaffNotifiedForInjury Is null
									  OR isnull(CISD.IncidentSeizureDetailsNoMedicalStaffNotified,'N') = 'Y')
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
	                                and (CIR.FollowUpOfIndividualStatusVersionStatus = 22
									  or CIRD.DetailsStaffNotifiedForInjury is null
									  or isnull(CIRD.DetailsNoMedicalStaffNotified,'N') = 'Y')
	                                and CIR.SupervisorFollowUpVersionStatus = 21
	                                and CIRD.DetailsSupervisorFlaggedId  is not null)
	                                or(CIR.FallDetailVersionStatus = 22 
									and (CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
										OR isnull(CIRF.FallDetailsNoMedicalStaffNotified,'N') = 'Y'
										OR CIRF.FallDetailsStaffNotifiedForInjury IS null)
									and CIR.FallSupervisorFollowUpVersionStatus = 21
									and CIRF.FallDetailsSupervisorFlaggedId is not null)
									or (CIR.SeizureDetailVersionStatus  = 22  
								      and (cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22
									  or CISD.IncidentSeizureDetailsStaffNotifiedForInjury Is null
									  OR isnull(CISD.IncidentSeizureDetailsNoMedicalStaffNotified,'N') = 'Y')
								    and cir.SeizureSupervisorFollowUpVersionStatus = 21
	                                and CISD.IncidentSeizureDetailsSupervisorFlaggedId Is Not null))
	                                and CIR.DetailVersionStatus = 22  
	                                and (CIR.FollowUpOfIndividualStatusVersionStatus = 22
									  or CIRD.DetailsStaffNotifiedForInjury is null
									  or isnull(CIRD.DetailsNoMedicalStaffNotified,'N') = 'Y')
	                                and CIR.FallDetailVersionStatus = 22 
									and (CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
										OR isnull(CIRF.FallDetailsNoMedicalStaffNotified,'N') = 'Y'
										OR CIRF.FallDetailsStaffNotifiedForInjury IS null)
									and CIR.SeizureDetailVersionStatus  = 22  
								      and (cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22
									  or CISD.IncidentSeizureDetailsStaffNotifiedForInjury Is null
									  OR isnull(CISD.IncidentSeizureDetailsNoMedicalStaffNotified,'N') = 'Y')
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
								 
----------Nursing Status = 13-----------------------------------------------------------------------------------
	      OR (@Status = 13 and (
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
								 ))) 
--------- Supervisor -----------------------------------------------------------------------------	                             
				  OR (@Status = 15 AND (
				  
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
	                              and (CIR.FollowUpOfIndividualStatusVersionStatus = 22
									  or CIRD.DetailsStaffNotifiedForInjury is null
									  or isnull(CIRD.DetailsNoMedicalStaffNotified,'N') = 'Y' 
	                              )
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
									and (CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
										OR isnull(CIRF.FallDetailsNoMedicalStaffNotified,'N') = 'Y'
										OR CIRF.FallDetailsStaffNotifiedForInjury IS null
									)
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
								  and (cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22
									  or CISD.IncidentSeizureDetailsStaffNotifiedForInjury Is null
									  OR isnull(CISD.IncidentSeizureDetailsNoMedicalStaffNotified,'N') = 'Y' 
								   )
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
									and (CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
										OR isnull(CIRF.FallDetailsNoMedicalStaffNotified,'N') = 'Y'
										OR CIRF.FallDetailsStaffNotifiedForInjury IS null) 
									and CIR.FallSupervisorFollowUpVersionStatus = 21
									and CIRF.FallDetailsSupervisorFlaggedId is not null)
									or (CIR.SeizureDetailVersionStatus  = 22  
								    and (cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22
									  or CISD.IncidentSeizureDetailsStaffNotifiedForInjury Is null
									  OR isnull(CISD.IncidentSeizureDetailsNoMedicalStaffNotified,'N') = 'Y') 
								    and cir.SeizureSupervisorFollowUpVersionStatus = 21
	                                and CISD.IncidentSeizureDetailsSupervisorFlaggedId Is Not null))
	                                and CIR.FallDetailVersionStatus = 22 
									and (CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
										OR isnull(CIRF.FallDetailsNoMedicalStaffNotified,'N') = 'Y'
										OR CIRF.FallDetailsStaffNotifiedForInjury IS null)
									and CIR.SeizureDetailVersionStatus  = 22  
								      and (cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22
									  or CISD.IncidentSeizureDetailsStaffNotifiedForInjury Is null
									  OR isnull(CISD.IncidentSeizureDetailsNoMedicalStaffNotified,'N') = 'Y')
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
	                                and (CIR.FollowUpOfIndividualStatusVersionStatus = 22
									  or CIRD.DetailsStaffNotifiedForInjury is null
									  or isnull(CIRD.DetailsNoMedicalStaffNotified,'N') = 'Y' )
	                                and CIR.SupervisorFollowUpVersionStatus = 21
	                                and CIRD.DetailsSupervisorFlaggedId  is not null)
	                                or(CIR.FallDetailVersionStatus = 22 
									and (CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
										OR isnull(CIRF.FallDetailsNoMedicalStaffNotified,'N') = 'Y'
										OR CIRF.FallDetailsStaffNotifiedForInjury IS null)
									and CIR.FallSupervisorFollowUpVersionStatus = 21
									and CIRF.FallDetailsSupervisorFlaggedId is not null))
									and CIR.DetailVersionStatus = 22  
	                                and (CIR.FollowUpOfIndividualStatusVersionStatus = 22
									  or CIRD.DetailsStaffNotifiedForInjury is null
									  or isnull(CIRD.DetailsNoMedicalStaffNotified,'N') = 'Y' 
	                                )
	                                and CIR.FallDetailVersionStatus = 22 
									and (CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
										OR isnull(CIRF.FallDetailsNoMedicalStaffNotified,'N') = 'Y'
										OR CIRF.FallDetailsStaffNotifiedForInjury IS null)
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
	                                and (CIR.FollowUpOfIndividualStatusVersionStatus = 22
									  or CIRD.DetailsStaffNotifiedForInjury is null
									  or isnull(CIRD.DetailsNoMedicalStaffNotified,'N') = 'Y')
	                                and CIR.SupervisorFollowUpVersionStatus = 21
	                                and CIRD.DetailsSupervisorFlaggedId  is not null)
	                                or(CIR.SeizureDetailVersionStatus  = 22  
								      and (cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22
									  or CISD.IncidentSeizureDetailsStaffNotifiedForInjury Is null
									  OR isnull(CISD.IncidentSeizureDetailsNoMedicalStaffNotified,'N') = 'Y')
								    and cir.SeizureSupervisorFollowUpVersionStatus = 21
	                                and CISD.IncidentSeizureDetailsSupervisorFlaggedId Is Not null))
	                                and CIR.DetailVersionStatus = 22  
	                                and (CIR.FollowUpOfIndividualStatusVersionStatus = 22
									  or CIRD.DetailsStaffNotifiedForInjury is null
									  or isnull(CIRD.DetailsNoMedicalStaffNotified,'N') = 'Y')
	                                and CIR.SeizureDetailVersionStatus  = 22  
								      and (cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22
									  or CISD.IncidentSeizureDetailsStaffNotifiedForInjury Is null
									  OR isnull(CISD.IncidentSeizureDetailsNoMedicalStaffNotified,'N') = 'Y')
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
	                                and (CIR.FollowUpOfIndividualStatusVersionStatus = 22
									  or CIRD.DetailsStaffNotifiedForInjury is null
									  or isnull(CIRD.DetailsNoMedicalStaffNotified,'N') = 'Y')
	                                and CIR.SupervisorFollowUpVersionStatus = 21
	                                and CIRD.DetailsSupervisorFlaggedId  is not null)
	                                or(CIR.FallDetailVersionStatus = 22 
									and (CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
										OR isnull(CIRF.FallDetailsNoMedicalStaffNotified,'N') = 'Y'
										OR CIRF.FallDetailsStaffNotifiedForInjury IS null)
									and CIR.FallSupervisorFollowUpVersionStatus = 21
									and CIRF.FallDetailsSupervisorFlaggedId is not null)
									or (CIR.SeizureDetailVersionStatus  = 22  
								      and (cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22
									  or CISD.IncidentSeizureDetailsStaffNotifiedForInjury Is null
									  OR isnull(CISD.IncidentSeizureDetailsNoMedicalStaffNotified,'N') = 'Y')
								    and cir.SeizureSupervisorFollowUpVersionStatus = 21
	                                and CISD.IncidentSeizureDetailsSupervisorFlaggedId Is Not null))
	                                and CIR.DetailVersionStatus = 22  
	                                and (CIR.FollowUpOfIndividualStatusVersionStatus = 22
									  or CIRD.DetailsStaffNotifiedForInjury is null
									  or isnull(CIRD.DetailsNoMedicalStaffNotified,'N') = 'Y')
	                                and CIR.FallDetailVersionStatus = 22 
									and (CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
										OR isnull(CIRF.FallDetailsNoMedicalStaffNotified,'N') = 'Y'
										OR CIRF.FallDetailsStaffNotifiedForInjury IS null)
									and CIR.SeizureDetailVersionStatus  = 22  
								      and (cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22
									  or CISD.IncidentSeizureDetailsStaffNotifiedForInjury Is null
									  OR isnull(CISD.IncidentSeizureDetailsNoMedicalStaffNotified,'N') = 'Y')
									)
			           )
				  )
---------- Manager ---------------------------------------------------------------------------------------------------
	       or  (@Status = 16 and (
	       
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
	                             )
------------ Administrator -----------------------------------------------------------------------------
	                             OR (@Status = 17 AND (
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
	                             ))
------- Complete --------------------------------------------------------------------------------------
	                             OR (@Status = 22 
	                             and
	                             (
----------Incident Complete---------------------------------------------------------------------------------
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
	                              and (((isnull(CIRSF.SupervisorFollowUpAdministratorNotified,'N') = 'Y' 
	                                  OR ISNULL(CIRMF.ManagerFollowUpAdministratorNotified,'N') = 'Y') 
	                              and CIR.AdministratorReviewVersionStatus = 22)
	                              OR(isnull(CIRSF.SupervisorFollowUpAdministratorNotified,'N') = 'N' 
	                              and ISNULL(CIRMF.ManagerFollowUpAdministratorNotified,'N') = 'N') )  
								  )
----------Fall Complete-------------------------------------------------------------------------------------
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
								   and (((ISNULL(CIRFSF.FallSupervisorFollowUpAdministratorNotified,'N')='Y'
									  OR ISNULL(CIRFMF.ManagerFollowUpAdministratorNotified,'N')='Y' )
								   and CIR.FallAdministratorReviewVersionStatus = 22)
								   or (ISNULL(CIRFSF.FallSupervisorFollowUpAdministratorNotified,'N')='N'
								   AND ISNULL(CIRFMF.ManagerFollowUpAdministratorNotified,'N')='N') ) 
								   )
----------Seizure Complete----------------------------------------------------------------------------------
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
									 and (((ISNULL(CISF.SeizureSupervisorFollowUpAdministratorNotified,'N')='Y'
									  OR ISNULL(CIRSMF.ManagerFollowUpAdministratorNotified,'N')='Y' )
									 and CIR.SeizureAdministratorReviewVersionStatus = 22)
									  or (ISNULL(CISF.SeizureSupervisorFollowUpAdministratorNotified,'N')='N'
									 and ISNULL(CIRSMF.ManagerFollowUpAdministratorNotified,'N')='N' ))     
									 )
----------Fall & Seizure Complete---------------------------------------------------------------------------
								   OR (
								   CIRG.GeneralIncidentCategory IN (
										SELECT GlobalCodeId
										FROM GlobalCodes
										WHERE (Code = 'INCIDENTOTHER')
											AND ISNULL(RecordDeleted, 'N') = 'N'
									)
								    and ((CIR.FallDetailVersionStatus = 22 
								    and CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
								    and CIR.FallSupervisorFollowUpVersionStatus = 22
								    and ((CIR.FallManagerFollowUpStatus = 22
								    and isnull(CIRFSF.SupervisorFollowUpManagerNotified,'N')= 'Y')
									  OR isnull(CIRFSF.SupervisorFollowUpManagerNotified,'N')= 'N')
								    and (((ISNULL(CIRFSF.FallSupervisorFollowUpAdministratorNotified,'N')='Y'
									  OR ISNULL(CIRFMF.ManagerFollowUpAdministratorNotified,'N')='Y' )
								    and CIR.FallAdministratorReviewVersionStatus = 22)
								     or (ISNULL(CIRFSF.FallSupervisorFollowUpAdministratorNotified,'N')='N'
								     AND ISNULL(CIRFMF.ManagerFollowUpAdministratorNotified,'N')='N') ))
								     and (CIR.SeizureDetailVersionStatus  = 22  
									 and cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22 
									 and cir.SeizureSupervisorFollowUpVersionStatus = 22
									 and ((cir.SeizureManagerFollowUpStatus = 22
									 and isnull(CISF.SupervisorFollowUpManagerNotified,'N')= 'Y') 
										 OR isnull(CISF.SupervisorFollowUpManagerNotified,'N')= 'N')
									 and (((ISNULL(CISF.SeizureSupervisorFollowUpAdministratorNotified,'N')='Y'
									  OR ISNULL(CIRSMF.ManagerFollowUpAdministratorNotified,'N')='Y' )
									 and CIR.SeizureAdministratorReviewVersionStatus = 22)
									  or (ISNULL(CISF.SeizureSupervisorFollowUpAdministratorNotified,'N')='N'
									 and ISNULL(CIRSMF.ManagerFollowUpAdministratorNotified,'N')='N' ))))
									)
----------Incident & Fall Complete--------------------------------------------------------------------------
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
	                              and (((isnull(CIRSF.SupervisorFollowUpAdministratorNotified,'N') = 'Y' 
	                                  OR ISNULL(CIRMF.ManagerFollowUpAdministratorNotified,'N') = 'Y') 
	                              and CIR.AdministratorReviewVersionStatus = 22)
	                              OR(isnull(CIRSF.SupervisorFollowUpAdministratorNotified,'N') = 'N' 
	                              and ISNULL(CIRMF.ManagerFollowUpAdministratorNotified,'N') = 'N') ))
								   and (CIR.FallDetailVersionStatus = 22 
								   and CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
								   and CIR.FallSupervisorFollowUpVersionStatus = 22
								   and ((CIR.FallManagerFollowUpStatus = 22
								   and isnull(CIRFSF.SupervisorFollowUpManagerNotified,'N')= 'Y')
									  OR isnull(CIRFSF.SupervisorFollowUpManagerNotified,'N')= 'N')
								   and (((ISNULL(CIRFSF.FallSupervisorFollowUpAdministratorNotified,'N')='Y'
									  OR ISNULL(CIRFMF.ManagerFollowUpAdministratorNotified,'N')='Y' )
								   and CIR.FallAdministratorReviewVersionStatus = 22)
								   or (ISNULL(CIRFSF.FallSupervisorFollowUpAdministratorNotified,'N')='N'
								   AND ISNULL(CIRFMF.ManagerFollowUpAdministratorNotified,'N')='N') )))
								   ) 
----------Incident & Seizure Complete-----------------------------------------------------------------------
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
	                              and (((isnull(CIRSF.SupervisorFollowUpAdministratorNotified,'N') = 'Y' 
	                                  OR ISNULL(CIRMF.ManagerFollowUpAdministratorNotified,'N') = 'Y') 
	                              and CIR.AdministratorReviewVersionStatus = 22)
	                              OR(isnull(CIRSF.SupervisorFollowUpAdministratorNotified,'N') = 'N' 
	                              and ISNULL(CIRMF.ManagerFollowUpAdministratorNotified,'N') = 'N') ))
								   and (CIR.SeizureDetailVersionStatus  = 22  
									 and cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22 
									 and cir.SeizureSupervisorFollowUpVersionStatus = 22
									 and ((cir.SeizureManagerFollowUpStatus = 22
									 and isnull(CISF.SupervisorFollowUpManagerNotified,'N')= 'Y') 
										 OR isnull(CISF.SupervisorFollowUpManagerNotified,'N')= 'N')
									 and (((ISNULL(CISF.SeizureSupervisorFollowUpAdministratorNotified,'N')='Y'
									  OR ISNULL(CIRSMF.ManagerFollowUpAdministratorNotified,'N')='Y' )
									 and CIR.SeizureAdministratorReviewVersionStatus = 22)
									  or (ISNULL(CISF.SeizureSupervisorFollowUpAdministratorNotified,'N')='N'
									 and ISNULL(CIRSMF.ManagerFollowUpAdministratorNotified,'N')='N' ))))
								   )
----------Incident & Fall & Seizure Complete----------------------------------------------------------------
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
	                              and (((isnull(CIRSF.SupervisorFollowUpAdministratorNotified,'N') = 'Y' 
	                                  OR ISNULL(CIRMF.ManagerFollowUpAdministratorNotified,'N') = 'Y') 
	                              and CIR.AdministratorReviewVersionStatus = 22)
	                              OR(isnull(CIRSF.SupervisorFollowUpAdministratorNotified,'N') = 'N' 
	                              and ISNULL(CIRMF.ManagerFollowUpAdministratorNotified,'N') = 'N') ))
								   and (CIR.SeizureDetailVersionStatus  = 22  
									 and cir.SeizureFollowUpOfIndividualStatusVersionStatus = 22 
									 and cir.SeizureSupervisorFollowUpVersionStatus = 22
									 and ((cir.SeizureManagerFollowUpStatus = 22
									 and isnull(CISF.SupervisorFollowUpManagerNotified,'N')= 'Y') 
										 OR isnull(CISF.SupervisorFollowUpManagerNotified,'N')= 'N')
									 and (((ISNULL(CISF.SeizureSupervisorFollowUpAdministratorNotified,'N')='Y'
									  OR ISNULL(CIRSMF.ManagerFollowUpAdministratorNotified,'N')='Y' )
									 and CIR.SeizureAdministratorReviewVersionStatus = 22)
									  or (ISNULL(CISF.SeizureSupervisorFollowUpAdministratorNotified,'N')='N'
									 and ISNULL(CIRSMF.ManagerFollowUpAdministratorNotified,'N')='N' )))
									 and (CIR.FallDetailVersionStatus = 22 
								   and CIR.FallFollowUpOfIndividualStatusVersionStatus = 22 
								   and CIR.FallSupervisorFollowUpVersionStatus = 22
								   and ((CIR.FallManagerFollowUpStatus = 22
								   and isnull(CIRFSF.SupervisorFollowUpManagerNotified,'N')= 'Y')
									  OR isnull(CIRFSF.SupervisorFollowUpManagerNotified,'N')= 'N')
								   and (((ISNULL(CIRFSF.FallSupervisorFollowUpAdministratorNotified,'N')='Y'
									  OR ISNULL(CIRFMF.ManagerFollowUpAdministratorNotified,'N')='Y' )
								   and CIR.FallAdministratorReviewVersionStatus = 22)
								   or (ISNULL(CIRFSF.FallSupervisorFollowUpAdministratorNotified,'N')='N'
								   AND ISNULL(CIRFMF.ManagerFollowUpAdministratorNotified,'N')='N') )))
								   )
	                             )
	                             )
-----------------------------------------------------------------------------------------------------	                             
	                             OR  @Status = -1 )  		
				AND (
					ISNULL(@Status, -1) = -1
					and
					( 
					(
						ISNULL(@FromDashboard, 'N') = 'N'
					)
					OR (
						ISNULL(@FromDashboard, 'N') = 'Y'
						
						AND 
						 (
				(
					( -- CustomIncidentReports
						(CIRSF.SupervisorFollowUpSupervisorName = @LoggedInUser  and CIR.SupervisorFollowUpVersionStatus<>22)
		             			
						OR (CIRSF.SupervisorFollowUpAdministrator = @LoggedInUser and CIR.AdministratorReviewVersionStatus<>22)
						OR (CIRSF.SupervisorFollowUpManager = @LoggedInUser and CIR.ManagerFollowUpStatus <> 22)
						
						)
					OR (
						(CIRFSF.FallSupervisorFollowUpSupervisorName = @LoggedInUser and CIR.FallSupervisorFollowUpVersionStatus<>22)
						OR (CIRFSF.FallSupervisorFollowUpAdministrator = @LoggedInUser and CIR.FallAdministratorReviewVersionStatus<>22)
						OR (CIRFSF.SupervisorFollowUpManager = @LoggedInUser and CIR.FallManagerFollowUpStatus<>22)
						
						)
					OR (
						(CISF.SeizureSupervisorFollowUpSupervisorName = @LoggedInUser and CIR.SeizureSupervisorFollowUpVersionStatus<>22)
						OR (CISF.SeizureSupervisorFollowUpAdministrator = @LoggedInUser and CIR.SeizureAdministratorReviewVersionStatus<>22)
						or (CISF.SupervisorFollowUpManager = @LoggedInUser and CIR.SeizureManagerFollowUpStatus<>22)
						)
					)
				OR (
					(CISFI.SeizureFollowUpIndividualStatusNurseStaffEvaluating = @LoggedInUser and CIR.SeizureFollowUpOfIndividualStatusVersionStatus<>22)
					OR (CIRFI.FollowUpIndividualStatusNurseStaffEvaluating = @LoggedInUser and  CIR.FollowUpOfIndividualStatusVersionStatus<>22)
					OR (CIRFS.FallFollowUpIndividualStatusNurseStaffEvaluating = @LoggedInUser and CIR.FallFollowUpOfIndividualStatusVersionStatus<>22)
					)
				OR((CIRMF.ManagerFollowUpManagerId = @LoggedInUser and CIR.ManagerFollowUpStatus<>22)
				   or (CIRMF.ManagerFollowUpAdministrator = @LoggedInUser and CIR.AdministratorReviewVersionStatus<>22)) 
				   OR((CIRFMF.ManagerFollowUpManagerId = @LoggedInUser and CIR.FallManagerFollowUpStatus<>22)
				   or (CIRFMF.ManagerFollowUpAdministrator = @LoggedInUser and CIR.FallAdministratorReviewVersionStatus<>22)) 
				   OR((CIRSMF.ManagerFollowUpManagerId = @LoggedInUser and CIR.SeizureManagerFollowUpStatus<>22)
				   or (CIRSMF.ManagerFollowUpAdministrator = @LoggedInUser and CIR.SeizureAdministratorReviewVersionStatus<>22)) 
				)
					)
				
					)
				OR (
					(
						ISNULL(@FromDashboard, 'N') = 'Y'
						AND (
				(
					( -- CustomIncidentReports
						(CIRSF.SupervisorFollowUpSupervisorName = @LoggedInUser  and CIR.SupervisorFollowUpVersionStatus<>22)
		             			
						OR (CIRSF.SupervisorFollowUpAdministrator = @LoggedInUser and CIR.AdministratorReviewVersionStatus<>22)
						OR (CIRSF.SupervisorFollowUpManager = @LoggedInUser and CIR.ManagerFollowUpStatus <> 22)
						
						)
					OR (
						(CIRFSF.FallSupervisorFollowUpSupervisorName = @LoggedInUser and CIR.FallSupervisorFollowUpVersionStatus<>22)
						OR (CIRFSF.FallSupervisorFollowUpAdministrator = @LoggedInUser and CIR.FallAdministratorReviewVersionStatus<>22)
						OR (CIRFSF.SupervisorFollowUpManager = @LoggedInUser and CIR.FallManagerFollowUpStatus<>22)
						
						)
					OR (
						(CISF.SeizureSupervisorFollowUpSupervisorName = @LoggedInUser and CIR.SeizureSupervisorFollowUpVersionStatus<>22)
						OR (CISF.SeizureSupervisorFollowUpAdministrator = @LoggedInUser and CIR.SeizureAdministratorReviewVersionStatus<>22)
						or (CISF.SupervisorFollowUpManager = @LoggedInUser and CIR.SeizureManagerFollowUpStatus<>22)
						)
					)
				OR (
					(CISFI.SeizureFollowUpIndividualStatusNurseStaffEvaluating = @LoggedInUser and CIR.SeizureFollowUpOfIndividualStatusVersionStatus<>22)
					OR (CIRFI.FollowUpIndividualStatusNurseStaffEvaluating = @LoggedInUser and  CIR.FollowUpOfIndividualStatusVersionStatus<>22)
					OR (CIRFS.FallFollowUpIndividualStatusNurseStaffEvaluating = @LoggedInUser and CIR.FallFollowUpOfIndividualStatusVersionStatus<>22)
					)
				OR((CIRMF.ManagerFollowUpManagerId = @LoggedInUser and CIR.ManagerFollowUpStatus<>22)
				   or (CIRMF.ManagerFollowUpAdministrator = @LoggedInUser and CIR.AdministratorReviewVersionStatus<>22)) 
				   OR((CIRFMF.ManagerFollowUpManagerId = @LoggedInUser and CIR.FallManagerFollowUpStatus<>22)
				   or (CIRFMF.ManagerFollowUpAdministrator = @LoggedInUser and CIR.FallAdministratorReviewVersionStatus<>22)) 
				   OR((CIRSMF.ManagerFollowUpManagerId = @LoggedInUser and CIR.SeizureManagerFollowUpStatus<>22)
				   or (CIRSMF.ManagerFollowUpAdministrator = @LoggedInUser and CIR.SeizureAdministratorReviewVersionStatus<>22)) 
				)
						)
						)
					OR ISNULL(@FromDashboard, 'N') = 'N'
					)
				
				
			
		END

		;WITH Counts
		AS (
			SELECT Count(*) AS TotalRows
			FROM #ResultSet
			)
			,RankResultSet
		AS (
			SELECT FormId
				,CASE 
					WHEN IncidentReportId IS NULL
						THEN - 1
					ELSE IncidentReportId
					END AS IncidentReportId
				,CASE 
					WHEN RestrictiveProcedureId IS NULL
						THEN - 1
					ELSE RestrictiveProcedureId
					END AS RestrictiveProcedureId
				,DateTimes
				,Times
				,Individual
				,Program
				,LocationOfIncident
				,[Status]
				,RecordedBy
				,Form
				,ClientId
				,Count(*) OVER () AS TotalCount
				,Rank() OVER (
					ORDER BY CASE 
							WHEN @SortExpression = 'DateTime'
								THEN DateTimes
							END
						,CASE 
							WHEN @SortExpression = 'DateTime desc'
								THEN DateTimes
							END DESC
						,CASE 
							WHEN @SortExpression = 'DateTime'
								THEN Times
							END
						,CASE 
							WHEN @SortExpression = 'DateTime desc'
								THEN Times
							END DESC
						,CASE 
							WHEN @SortExpression = 'Individual'
								THEN Individual
							END
						,CASE 
							WHEN @SortExpression = 'Individual desc'
								THEN Individual
							END DESC
						,CASE 
							WHEN @SortExpression = 'Program'
								THEN Program
							END
						,CASE 
							WHEN @SortExpression = 'Program desc'
								THEN Program
							END DESC
						,CASE 
							WHEN @SortExpression = 'LocationOfIncident'
								THEN LocationOfIncident
							END
						,CASE 
							WHEN @SortExpression = 'LocationOfIncident desc'
								THEN LocationOfIncident
							END DESC
						,CASE 
							WHEN @SortExpression = 'Status'
								THEN [Status]
							END
						,CASE 
							WHEN @SortExpression = 'Status desc'
								THEN [Status]
							END DESC
						,CASE 
							WHEN @SortExpression = 'RecordedBy'
								THEN RecordedBy
							END
						,CASE 
							WHEN @SortExpression = 'RecordedBy desc'
								THEN RecordedBy
							END DESC
						,CASE 
							WHEN @SortExpression = 'Form'
								THEN Form
							END
						,CASE 
							WHEN @SortExpression = 'Form desc'
								THEN Form
							END DESC
						,FormId
					) AS RowNumber
			FROM #ResultSet
			)
		SELECT TOP (
				CASE 
					WHEN (@PageNumber = - 1)
						THEN (
								SELECT Isnull(TotalRows, 0)
								FROM Counts
								)
					ELSE (@PageSize)
					END
				) FormId
			,IncidentReportId
			,RestrictiveProcedureId
			,DateTimes
			,Times
			,Individual
			,ClientId
			,Program
			,LocationOfIncident
			,[Status]
			,RecordedBy
			,Form
			,RowNumber
			,totalcount
		INTO #FinalResultSet
		FROM RankResultSet
		WHERE RowNumber > ((@PageNumber - 1) * @PageSize)

		IF (
				SELECT Isnull(Count(*), 0)
				FROM #FinalResultSet
				) < 1
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

		SELECT IncidentReportId
			,RestrictiveProcedureId
			,convert(VARCHAR, DateTimes, 101) + ' ' + Times AS DateTimes
			,Individual
			,ClientId
			,Program
			,LocationOfIncident
			,[Status]
			,RecordedBy
			,Form
		FROM #FinalResultSet
		ORDER BY RowNumber
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
