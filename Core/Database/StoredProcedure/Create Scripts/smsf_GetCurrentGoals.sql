/****** Object:  UserDefinedFunction [dbo].[smsf_GetCurrentGoals]    Script Date: 09/30/2016 18:06:04 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[smsf_GetCurrentGoals]')
			AND type IN (
				N'FN'
				,N'IF'
				,N'TF'
				,N'FS'
				,N'FT'
				)
		)
	DROP FUNCTION [dbo].[smsf_GetCurrentGoals]
GO

/****** Object:  UserDefinedFunction [dbo].[smsf_GetCurrentGoals]    Script Date: 09/30/2016 18:06:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[smsf_GetCurrentGoals] (@ClientId INT)
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
		,@GoalsEffectiveDate DATETIME
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
					SELECT T.NeedId AS GoalId
						,T.NeedNumber AS GoalNumber
						,T.GoalText AS GoalText
						,T.GoalActive AS CustomGoalActive
						,NULL AS ProcedureCodeId
						,NULL AS ProgramId
						,d.EffectiveDate AS EffectiveDate
					FROM TpNeeds T
					JOIN Documents d ON d.CurrentDocumentVersionId = T.DocumentVersionId
					WHERE T.DocumentVersionId = @RecentDocumentVersionId
						AND Isnull(T.RecordDeleted, 'N') = 'N'
						AND Isnull(d.RecordDeleted, 'N') = 'N'
						AND T.GoalActive = 'Y'
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
					SELECT CG.GoalId AS GoalId
						,CG.GoalNumber AS GoalNumber
						,CG.GoalText AS GoalText
						,CG.GoalActive AS CustomGoalActive
						,NULL AS ProcedureCodeId
						,CG.ProgramId AS ProgramId
						,d.EffectiveDate AS EffectiveDate
					FROM CustomDocumentTreatmentPlanGoals CG
					JOIN Documents d ON d.CurrentDocumentVersionId = cg.DocumentVersionId
					WHERE ISNull(CG.RecordDeleted, 'N') = 'N'
						AND ISNULL(CG.GoalActive, 'Y') = 'Y'
						AND CG.DocumentVersionId = @LatestCarePlanDocumentVersionID
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
				,@GoalsEffectiveDate = d.EffectiveDate
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
		END

		/* Goals Section */
		SELECT @JsonResult = dbo.smsf_FlattenedJSON((
					SELECT DISTINCT CDCPG.[GoalId] AS GoalId
						,CDCPG.[GoalNumber] AS GoalNumber
						,CCPDG.[GoalDescription] AS GoalText
						,CDCPG.[GoalActive] AS CustomGoalActive
						,NULL AS ProcedureCodeId
						,NULL AS ProgramId
						,@GoalsEffectiveDate AS EffectiveDate
					FROM [CustomDocumentCarePlanGoals] CDCPG
					LEFT JOIN CustomCarePlanDomainGoals CCPDG ON CDCPG.[DomainGoalId] = CCPDG.[DomainGoalId]
						AND ISNULL(CCPDG.RecordDeleted, 'N') = 'N'
					WHERE CDCPG.DocumentVersionId IN (
							@PreviousDocumentVersionId
							,@RecentDocumentVersionId
							)
						AND ISNULL(CDCPG.RecordDeleted, 'N') = 'N'
						-- Include each domain goal only once  
						AND NOT EXISTS (
							SELECT 1
							FROM CustomDocumentCarePlanGoals CDCPG2
							WHERE CDCPG.DocumentVersionId = @PreviousDocumentVersionId
								AND CDCPG2.DocumentVersionId = @RecentDocumentVersionId
								AND CDCPG.DomainGoalId = CDCPG2.DomainGoalId
							)
					ORDER BY CDCPG.DocumentVersionId
						,CDCPG.GoalNumber
					FOR XML path
						,root
					))
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
						SELECT DISTINCT CG.CarePlanGoalId AS GoalId
							,CG.GoalNumber AS GoalNumber
							,CG.ClientGoal AS GoalText
							,CG.GoalActive AS CustomGoalActive
							,AP.ProcedureCodeId AS ProcedureCodeId
							,NULL AS ProgramId
							,d.EffectiveDate AS EffectiveDate
						FROM CarePlanGoals CG
						JOIN Documents d ON d.CurrentDocumentVersionId = cg.DocumentVersionId
						JOIN CarePlanObjectives CO ON CG.CarePlanGoalId = co.CarePlanGoalId
						JOIN CarePlanPrescribedServiceObjectives PSO ON PSO.CarePlanObjectiveId = CO.CarePlanObjectiveId
						JOIN CarePlanPrescribedServices PS ON PS.CarePlanPrescribedServiceId = PSO.CarePlanPrescribedServiceId
						JOIN AuthorizationCodeProcedureCodes AP ON ap.AuthorizationCodeId = PS.AuthorizationCodeId
						JOIN ProcedureCodes PC ON PC.ProcedureCodeId = AP.ProcedureCodeId
						WHERE ISNull(CG.RecordDeleted, 'N') = 'N'
							AND ISNull(CG.GoalActive, 'N') = 'Y'
							AND ISNULL(PC.Mobile, 'N') = 'Y'
							AND ISNull(PC.RecordDeleted, 'N') = 'N'
							AND CG.DocumentVersionId = @LatestCarePlanDocumentVersionID
							AND CAST(isnull(CG.GoalEndDate, getdate()) AS DATE) >= cast(getDate() AS DATE)
						ORDER BY CG.GoalNumber
						FOR XML path
							,root
						))
		END
	END

	RETURN REPLACE(@JsonResult, '"', '''')
END
GO


