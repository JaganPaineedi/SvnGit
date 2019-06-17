/****** Object:  UserDefinedFunction [dbo].[smsf_GetCurrentObjectives]    Script Date: 09/30/2016 18:06:04 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[smsf_GetCurrentObjectives]')
			AND type IN (
				N'FN'
				,N'IF'
				,N'TF'
				,N'FS'
				,N'FT'
				)
		)
	DROP FUNCTION [dbo].[smsf_GetCurrentObjectives]
GO

/****** Object:  UserDefinedFunction [dbo].[smsf_GetCurrentObjectives]    Script Date: 09/30/2016 18:06:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[smsf_GetCurrentObjectives] (@ClientId INT)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @JsonResult VARCHAR(MAX)
		,@ConfiguredType VARCHAR(100)
	DECLARE @RecentDocumentVersionId AS INT
		,@RecentDocumentEffectiveDate DATETIME
	DECLARE @PreviousDocumentVersionId AS INT
	DECLARE @EpisodeRegistrationDate DATE
	DECLARE @HasCarePlan CHAR(1)
	DECLARE @CarePlanEffectiveDate DATETIME
	DECLARE @LatestCarePlanDocumentVersionID INT

	SELECT @ConfiguredType = [VALUE]
	FROM SystemConfigurationKeys
	WHERE [KEY] = 'INITIALIZEGOALSOBJECTIVESFORTYPE'
		AND ISNull(RecordDeleted, 'N') = 'N'

	IF @ConfiguredType = 'MICHIGAN'
	BEGIN
		SELECT TOP 1 @RecentDocumentVersionId = CurrentDocumentVersionId
		FROM documents
		WHERE documentcodeid IN (
				350
				,503
				,2
				)
			AND ClientId = @ClientId
			AND STATUS = 22
			AND CAST(EffectiveDate AS DATE) <= cast(getDate() AS DATE)
			AND isnull(RecordDeleted, 'N') = 'N'
		ORDER BY effectivedate DESC
			,modifieddate DESC

		SELECT @JsonResult = dbo.smsf_FlattenedJSON((
					SELECT o.NeedId AS GoalId
						,o.ObjectiveNumber AS ObjectiveNumber
						,o.ObjectiveText AS ObjectiveText
						,'Y' AS CustomObjectiveActive
					FROM TPObjectives o
					JOIN TPNeeds n ON n.NeedId = o.NeedId
					WHERE ISNULL(n.GoalActive, 'N') = 'Y'
						AND o.DocumentVersionId = @RecentDocumentVersionId
						AND o.ObjectiveStatus IN (191)
						AND ISNULL(o.RecordDeleted, 'N') = 'N'
						AND ISNULL(n.RecordDeleted, 'N') = 'N'
					ORDER BY o.DocumentVersionId
						,O.NeedId
					FOR XML path
						,root
					))
	END
	ELSE IF @ConfiguredType = 'PHILHAVEN'
	BEGIN
		SET @LatestCarePlanDocumentVersionID = (
				SELECT TOP 1 CurrentDocumentVersionId
				FROM Documents d
				JOIN CustomDocumentTreatmentPlanGeneral cdtpg ON d.CurrentDocumentVersionId = cdtpg.DocumentVersionId
					AND ISNull(cdtpg.RecordDeleted, 'N') = 'N'
				WHERE d.ClientId = @ClientID
					AND CAST(d.EffectiveDate AS DATE) <= cast(getDate() AS DATE)
					AND d.STATUS = 22
					AND d.DocumentCodeId = 10515 --Philhaven treatment plan 					
					AND isNull(d.RecordDeleted, 'N') <> 'Y'
				ORDER BY d.EffectiveDate DESC
					,d.ModifiedDate DESC
				)

		SELECT @JsonResult = dbo.smsf_FlattenedJSON((
					SELECT CDTPO.GoalId AS GoalId
						,CDTPO.ObjectiveNumber AS ObjectiveNumber
						,CDTPO.ObjectiveText AS ObjectiveText
						,'Y' AS CustomObjectiveActive
					FROM CustomDocumentTreatmentPlanObjectives AS CDTPO
					LEFT JOIN CustomDocumentTreatmentPlanGoals CDTPG ON CDTPO.GoalId = CDTPG.GoalId
						AND ISNULL(CDTPG.RecordDeleted, 'N') = 'N'
						AND ISNULL(CDTPG.GoalActive, 'Y') = 'Y'
					WHERE ISNULL(CDTPO.RecordDeleted, 'N') = 'N'
						AND CDTPO.ObjectiveStatus = 191
						AND CDTPG.DocumentVersionId = @LatestCarePlanDocumentVersionID
					FOR XML path
						,root
					))
	END
	ELSE IF @ConfiguredType = 'THRESHOLDS'
	BEGIN
		-- Get open date of current episode            
		SELECT @EpisodeRegistrationDate = ce.RegistrationDate
		FROM ClientEpisodes ce
		WHERE ce.ClientId = @ClientId
			AND (
				ce.DischargeDate IS NULL
				OR CAST(ce.DischargeDate AS DATE) > cast(getDate() AS DATE)
				)
			AND ISNULL(ce.RecordDeleted, 'N') = 'N'

		-- Check if there was an initial/annual Care Plan in last 6 months      
		IF EXISTS (
				SELECT 1
				FROM Documents d
				LEFT JOIN CustomDocumentCarePlans cp ON cp.DocumentVersionId = d.CurrentDocumentVersionId
					AND ISNULL(cp.CarePlanType, 'IN') IN (
						'IN'
						,'AN'
						)
					AND ISNULL(cp.RecordDeleted, 'N') = 'N'
				WHERE d.ClientId = @ClientId
					AND d.DocumentCodeId IN (1501)
					AND d.STATUS = 22
					AND CAST(d.EffectiveDate AS DATE) >= CAST(@EpisodeRegistrationDate AS DATE)
					AND CAST(d.EffectiveDate AS DATE) <= cast(getDate() AS DATE)
					AND cast(dateadd(month, 6, d.EffectiveDate) AS DATE) >= cast(getDate() AS DATE)
					AND ISNULL(d.RecordDeleted, 'N') = 'N'
				)
		BEGIN
			SET @HasCarePlan = 'Y'
		END

		-- Get DocumentVersionId of current Care Plan          
		IF @HasCarePlan = 'Y'
		BEGIN
			SELECT TOP 1 @RecentDocumentVersionId = d.CurrentDocumentVersionId
				,@RecentDocumentEffectiveDate = d.EffectiveDate
			FROM Documents d
			WHERE d.DocumentCodeId IN (1501)
				AND -- Care Plan or Converted Care Plan      
				d.ClientId = @ClientId
				AND d.STATUS = 22
				AND -- Signed      
				cast(d.EffectiveDate AS DATE) >= cast(@EpisodeRegistrationDate AS DATE)
				AND -- Current Episode      
				cast(d.EffectiveDate AS DATE) <= cast(getDate() AS DATE)
				AND -- Before date of service      
				cast(dateadd(month, 6, d.EffectiveDate) AS DATE) >= cast(getDate() AS DATE)
				AND -- In last 6 months 
				ISNULL(d.RecordDeleted, 'N') = 'N'
			ORDER BY d.EffectiveDate DESC
				,d.DocumentId DESC

			IF CAST(@RecentDocumentEffectiveDate AS DATE) = CAST(getDate() AS DATE)
			BEGIN
				SELECT TOP 1 @PreviousDocumentVersionId = d.CurrentDocumentVersionId
				FROM Documents d
				WHERE d.DocumentCodeId IN (
						1501
						,10514
						)
					AND -- Care Plan or Converted Care Plan      
					d.ClientId = @ClientId
					AND d.STATUS = 22
					AND -- Signed      
					cast(d.EffectiveDate AS DATE) >= cast(@EpisodeRegistrationDate AS DATE)
					AND -- Current Episode      
					cast(d.EffectiveDate AS DATE) <= cast(getDate() AS DATE)
					AND -- Before date of service    
					cast(dateadd(month, 6, d.EffectiveDate) AS DATE) >= cast(getDate() AS DATE)
					AND ISNULL(d.RecordDeleted, 'N') = 'N'
					AND d.CurrentDocumentVersionId <> @RecentDocumentVersionId
				ORDER BY d.EffectiveDate DESC
					,d.DocumentId DESC
			END

			SELECT @JsonResult = dbo.smsf_FlattenedJSON((
						SELECT DISTINCT CDCPO.[GoalId] AS GoalId
							,CDCPO.[ObjectiveNumber] AS ObjectiveNumber
							,CCPDO.[ObjectiveDescription] AS ObjectiveText
							,'Y' AS CustomObjectiveActive
						FROM CustomDocumentCarePlanObjectives CDCPO
						LEFT JOIN CustomCarePlanDomainObjectives CCPDO ON CDCPO.[DomainObjectiveId] = CCPDO.[DomainObjectiveId]
							AND ISNULL(CCPDO.RecordDeleted, 'N') <> 'Y'
						INNER JOIN CustomDocumentCarePlanPrescribedServiceObjectives CDCPSO ON CDCPSO.ObjectiveId = CDCPO.[ObjectiveId]
						INNER JOIN CustomDocumentCarePlanPrescribedServices CDCPS ON CDCPS.PrescribedServiceId = CDCPSO.PrescribedServiceId
						WHERE CDCPS.DocumentVersionId IN (
								@RecentDocumentVersionId
								,@PreviousDocumentVersionId
								)
							AND ISNULL(CDCPO.RecordDeleted, 'N') <> 'Y'
							AND ISNULL(CDCPS.RecordDeleted, 'N') <> 'Y'
							AND ISNULL(CDCPSO.RecordDeleted, 'N') <> 'Y'
							-- Include each domain objective only once  
							AND NOT EXISTS (
								SELECT 1
								FROM CustomDocumentCarePlanPrescribedServices CDCPS2
								JOIN CustomDocumentCarePlanPrescribedServiceObjectives CDCPSO2 ON CDCPS2.PrescribedServiceId = CDCPSO2.PrescribedServiceId
								JOIN CustomDocumentCarePlanObjectives CDCPO2 ON CDCPSO2.ObjectiveId = CDCPO2.ObjectiveId
								WHERE CDCPS.DocumentVersionId = @PreviousDocumentVersionId
									AND CDCPS2.DocumentVersionId = @RecentDocumentVersionId
									AND CDCPO.DomainObjectiveId = CDCPO2.DomainObjectiveId
								)
						ORDER BY CDCPO.ObjectiveNumber
						FOR XML path
							,root
						))
		END
	END
	ELSE
	BEGIN
		SET @LatestCarePlanDocumentVersionID = (
				SELECT TOP 1 CurrentDocumentVersionId
				FROM Documents d
				JOIN DocumentCarePlans DCP ON d.CurrentDocumentVersionId = DCP.DocumentVersionId
				WHERE d.ClientId = @ClientID
					AND CAST(d.EffectiveDate AS DATE) <= cast(getDate() AS DATE)
					AND d.STATUS = 22
					AND d.DocumentCodeId = 1620 -- Core Care Plan
					AND isNull(d.RecordDeleted, 'N') = 'N'
					AND ISNull(DCP.RecordDeleted, 'N') = 'N'
				ORDER BY d.EffectiveDate DESC
					,d.ModifiedDate DESC
				)

		IF @LatestCarePlanDocumentVersionID > 0
		BEGIN
			SELECT @JsonResult = dbo.smsf_FlattenedJSON((
						SELECT DISTINCT CDTPO.CarePlanGoalId AS GoalId
							,CDTPO.ObjectiveNumber AS ObjectiveNumber
							,CASE 
								WHEN ISNULL(CDTPO.CarePlanDomainObjectiveId, '') = ''
									THEN CDTPO.AssociatedObjectiveDescription
								ELSE DCP.NameInGoalDescriptions + ' ' + CarePlanDomainObjectives.ObjectiveDescription + ' ' + CDTPO.AssociatedObjectiveDescription
								END AS ObjectiveText
							,'Y' AS CustomObjectiveActive
						FROM CarePlanObjectives AS CDTPO
						JOIN CarePlanPrescribedServiceObjectives PSO ON PSO.CarePlanObjectiveId = CDTPO.CarePlanObjectiveId
						JOIN CarePlanPrescribedServices PS ON PS.CarePlanPrescribedServiceId = PSO.CarePlanPrescribedServiceId
						JOIN AuthorizationCodeProcedureCodes AP ON ap.AuthorizationCodeId = PS.AuthorizationCodeId
						JOIN ProcedureCodes PC ON PC.ProcedureCodeId = AP.ProcedureCodeId
						LEFT JOIN CarePlanGoals CDTPG ON CDTPO.CarePlanGoalId = CDTPG.CarePlanGoalId
							AND ISNULL(CDTPG.RecordDeleted, 'N') = 'N'
							AND ISNULL(CDTPG.GoalActive, 'Y') = 'Y'
						LEFT JOIN CarePlanDomainObjectives ON CDTPO.CarePlanDomainObjectiveId = CarePlanDomainObjectives.CarePlanDomainObjectiveId
							AND ISNULL(CarePlanDomainObjectives.RecordDeleted, 'N') = 'N'
						LEFT JOIN DocumentCarePlans DCP ON CDTPG.DocumentVersionId = DCP.DocumentVersionId
						LEFT JOIN GlobalCodes GC ON GC.Code = (
								CASE 
									WHEN CDTPO.ProgressTowardsObjective = 'D'
										THEN 'Deterioration'
									ELSE CASE 
											WHEN CDTPO.ProgressTowardsObjective = 'N'
												THEN 'No Change'
											ELSE CASE 
													WHEN CDTPO.ProgressTowardsObjective = 'S'
														THEN 'Some Improvement'
													ELSE CASE 
															WHEN CDTPO.ProgressTowardsObjective = 'M'
																THEN 'Moderate Improvement'
															ELSE CASE 
																	WHEN CDTPO.ProgressTowardsObjective = 'A'
																		THEN 'Achieved'
																	END
															END
													END
											END
									END
								)
						WHERE ISNULL(CDTPO.RecordDeleted, 'N') = 'N'
							AND CAST(isnull(CDTPG.GoalEndDate, getdate()) AS DATE) >= cast(getDate() AS DATE)
							AND CDTPG.DocumentVersionId = @LatestCarePlanDocumentVersionID
							AND ISNULL(PC.Mobile, 'N') = 'Y'
							AND ISNull(PC.RecordDeleted, 'N') = 'N'
						ORDER BY CDTPO.ObjectiveNumber
						FOR XML path
							,root
						))
		END
	END

	RETURN REPLACE(@JsonResult, '"', '''')
END
GO


