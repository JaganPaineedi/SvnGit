/****** Object:  StoredProcedure [dbo].[scsp_InitCarePlanInitial]    Script Date: 01/13/2015 15:24:58 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[scsp_InitCarePlanInitial]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].scsp_InitCarePlanInitial
GO

/****** Object:  StoredProcedure [dbo].[scsp_InitCarePlanInitial]    Script Date: 01/13/2015 15:24:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[scsp_InitCarePlanInitial] --5,560,NULL
	@ClientID INT
	,@StaffID INT
	,@CustomParameters XML
AS
-- =============================================      
-- Author:  Pradeep      
-- Create date: Sept 23, 2014      
-- Description:   
/*      
 Author			Modified Date			Reason      
 Pradeep.A		Apr/16/2015				ProgramType configurations has been moved to Recodes
 Remisoski.T	Sep/02/2015				Grab needs from most recent document that has them.
 jcarlson	  11/12/2015				added in missing initlizations for asam and mha level of care, most recent document after the episode reg date     
 MD Hussain   07/11/2016				Changed the Left Join to Inner Join Staff table with ClientPrograms table for initialization of 'CarePlanPrograms' table
										to avoid creation of bad data. Ref task #401 New Directions - Support Go Live
 MD Hussain   10/27/2016				Added record deleted check for Staff and Programs table for initialization of CarePlanPrograms table. Ref task #401 New Directions - Support Go Live 	
 Neelima		03/25/2109				What: Initializing InterventionDetails of CarePlanPrescribedServices table.  Why: New Directions - Support Go Live #932					
*/
-- =============================================      
BEGIN
	BEGIN TRY
		DECLARE @LatestCarePlanDocumentVersionID INT
			,@DocumentCodeID INT
			,@LatestHRMDocumentVersionID INT
			,@LatestMHADocumentVersionID INT
			,@LatestDocumentVersionID INT
			,@LatestCarePlanINDocumentVersionID INT
			,@LatestASAMDocumentVersionID INT
			
		DECLARE @EffectiveDate DATETIME
			,@EffectiveDateMHA DATETIME
			,@EffectiveDateASAM DATETIME
			
		DECLARE @Adult CHAR(1)
		DECLARE @EffectiveDateDifference INT
		DECLARE @CurrentDate DATETIME
		DECLARE @NeedNames VARCHAR(MAX)
			,@ClientFirstName VARCHAR(30)
		DECLARE @CarePlanAddendumInfo VARCHAR(MAX)
		DECLARE @CarePlanAddendumText VARCHAR(MAX)
		DECLARE @GenralAddendumDate DATE;
		DECLARE @LatestDocumentVersionFor1501100011002410357 INT = 0
			,@DocumentCodeIdFor1501100011002410357 INT = 0;
		DECLARE @EpisodeRegistrationDate DATETIME

		SET @CurrentDate = GetDate()
		SET @EffectiveDateDifference = 0
		SET @DocumentCodeID = @CustomParameters.value('(/Root/Parameters/@DocumentCodeID)[1]', 'int')

		SELECT @EpisodeRegistrationDate = ce.RegistrationDate
		FROM Clients c
		INNER JOIN ClientEpisodes ce ON ce.ClientId = c.ClientId
			AND ce.EpisodeNumber = c.CurrentEpisodeNumber
		WHERE ISNULL(ce.RecordDeleted, 'N') = 'N'
			AND c.ClientId = @ClientId

		SELECT TOP 1 @LatestDocumentVersionFor1501100011002410357 = ISNULL(CurrentDocumentVersionId, 0)
			,@DocumentCodeIdFor1501100011002410357 = ISNULL(DocumentCodeId, 0)
		FROM Documents
		WHERE ClientId = @ClientID
			AND CONVERT(DATE, EffectiveDate) <= CONVERT(DATE, GETDATE(), 101)
			AND CONVERT(DATE, EffectiveDate) >= CONVERT(DATE, @EpisodeRegistrationDate, 101)
			AND STATUS = 22
			AND DocumentCodeId IN (1620
				)
			AND ISNULL(RecordDeleted, 'N') <> 'Y'
		ORDER BY EffectiveDate DESC
			,ModifiedDate DESC

		DECLARE @LevelOfCare VARCHAR(MAX) = NULL
			,@ReductionInSymptoms CHAR(1) = NULL
			,@ReductionInSymptomsDescription VARCHAR(MAX) = NULL
			,@AttainmentOfHigherFunctioning CHAR(1) = NULL
			,@AttainmentOfHigherFunctioningDescription VARCHAR(MAX) = NULL
			,@TreatmentNotNecessary CHAR(1) = NULL
			,@TreatmentNotNecessaryDescription VARCHAR(MAX) = NULL
			,@OtherTransitionCriteria CHAR(1) = NULL
			,@OtherTransitionCriteriaDescription VARCHAR(MAX) = NULL
			,@EstimatedDischargeDate DATE = NULL;

		IF (@LatestDocumentVersionFor1501100011002410357 > 0)
		BEGIN
			IF (@DocumentCodeIdFor1501100011002410357 = 1620)
			BEGIN
				SELECT TOP 1 @LevelOfCare = LevelOfCare
					,@ReductionInSymptoms = ReductionInSymptoms
					,@ReductionInSymptomsDescription = ReductionInSymptomsDescription
					,@AttainmentOfHigherFunctioning = AttainmentOfHigherFunctioning
					,@AttainmentOfHigherFunctioningDescription = AttainmentOfHigherFunctioningDescription
					,@TreatmentNotNecessary = TreatmentNotNecessary
					,@TreatmentNotNecessaryDescription = TreatmentNotNecessaryDescription
					,@OtherTransitionCriteria = OtherTransitionCriteria
					,@OtherTransitionCriteriaDescription = OtherTransitionCriteriaDescription
					,@EstimatedDischargeDate = CONVERT(DATE, EstimatedDischargeDate, 101)
				FROM DocumentCarePlans
				WHERE DocumentVersionId = @LatestDocumentVersionFor1501100011002410357
					AND ISNULL(RecordDeleted, 'N') = 'N'
			END
		END

		
		SELECT @ClientFirstName = CA.FirstName
		FROM ClientAliases CA
		INNER JOIN GlobalCodes GC ON GC.GlobalCodeId = CA.AliasType
		WHERE GC.Category LIKE 'ALIASTYPE'
			AND GC.CodeName = 'Alias'
			AND CA.ClientId = @ClientID
			AND ISNULL(CA.RecordDeleted, 'N') = 'N'
			AND ISNULL(GC.RecordDeleted, 'N') = 'N'
		
		IF (@ClientFirstName IS NULL)
			SELECT @ClientFirstName = FirstName
			FROM Clients
			WHERE ClientId = @ClientID
				AND ISNULL(RecordDeleted, 'N') = 'N'
						
		SELECT TOP 1 @LatestCarePlanDocumentVersionID = CurrentDocumentVersionId
			,@EffectiveDate = Doc.EffectiveDate
			,@EffectiveDateDifference = DATEDIFF(YEAR, Doc.EffectiveDate, GETDATE())
		FROM Documents Doc
		WHERE EXISTS (
				SELECT 1
				FROM DocumentCarePlans CDCP
				INNER JOIN Clients C ON C.ClientId = Doc.ClientId
				INNER JOIN ClientEpisodes CE ON CE.ClientId = C.ClientId
					AND CONVERT(DATE, DOC.EffectiveDate) >= CONVERT(DATE, CE.RegistrationDate)
				WHERE CDCP.DocumentVersionId = Doc.CurrentDocumentVersionId
					AND CDCP.CarePlanType IN (
						'IN'
						,'AD'
						)
					AND ISNULL(CDCP.RecordDeleted, 'N') = 'N'
				)
			AND Doc.ClientId = @ClientID
			AND DocumentCodeId IN (
				1620
				)
			AND Doc.STATUS = 22 
			AND DATEDIFF(MONTH, Doc.EffectiveDate, GETDATE()) <= 6
			AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
			AND CONVERT(DATE, DOC.EffectiveDate) <= CONVERT(DATE, GETDATE())
			AND CONVERT(DATE, DOC.EffectiveDate) >= CONVERT(DATE, @EpisodeRegistrationDate, 101)
		ORDER BY Doc.EffectiveDate DESC
			,Doc.ModifiedDate DESC
		
		
		
		DECLARE @LatestCarePlanANDocumentVersionID INT;
		DECLARE @EffectiveDateAN DATE;
		DECLARE @EffectiveDateDifferenceAN INT;
		
		
		SELECT TOP 1 @LatestCarePlanANDocumentVersionID = CurrentDocumentVersionId
			,@EffectiveDateAN = Doc.EffectiveDate
			,@EffectiveDateDifferenceAN = DATEDIFF(YEAR, Doc.EffectiveDate, GETDATE())
		FROM Documents Doc
		WHERE EXISTS (
				SELECT 1
				FROM DocumentCarePlans CDCP
				INNER JOIN Clients C ON C.ClientId = Doc.ClientId
				INNER JOIN ClientEpisodes CE ON CE.ClientId = C.ClientId
					AND CONVERT(DATE, DOC.EffectiveDate) >= CONVERT(DATE, CE.RegistrationDate)
				WHERE CDCP.DocumentVersionId = Doc.CurrentDocumentVersionId
					AND CDCP.CarePlanType = 'IN'
					AND ISNULL(CDCP.RecordDeleted, 'N') = 'N'
				)
			AND Doc.ClientId = @ClientID
			AND DocumentCodeId IN (
				1620
				)
			AND Doc.STATUS = 22
			AND DATEDIFF(MONTH, Doc.EffectiveDate, GETDATE()) <= 6
			AND CONVERT(DATE, Doc.EffectiveDate, 101) >= CONVERT(DATE, @EpisodeRegistrationDate, 101)
			AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
			AND CONVERT(DATE, DOC.EffectiveDate) <= CONVERT(DATE, GETDATE())
			ORDER BY Doc.EffectiveDate DESC
			,Doc.ModifiedDate DESC
			
		
		IF (@LatestCarePlanANDocumentVersionID IS NOT NULL)
		BEGIN
			SELECT @CarePlanAddendumInfo = 'Addendum to:' + CHAR(13) + 'Care Plan Document Dated ' + convert(VARCHAR, Doc.EffectiveDate, 101) + ' - ' + convert(VARCHAR, DateAdd(Month, 6, Doc.EffectiveDate), 101)
				,@GenralAddendumDate = CONVERT(VARCHAR(10), DATEADD(MONTH, 6, Doc.EffectiveDate), 101)
			FROM DOCUMENTS Doc
			WHERE Doc.CurrentDocumentVersionId = @LatestCarePlanANDocumentVersionID

			SELECT @CarePlanAddendumText = COALESCE(@CarePlanAddendumText + CHAR(13), '') + 'Care Plan Addendum Document Dated ' + CONVERT(VARCHAR, Doc.EffectiveDate, 101) + ' - ' + CONVERT(VARCHAR(10), @GenralAddendumDate, 101)
			FROM DOCUMENTS Doc
			INNER JOIN DocumentCarePlans C ON doc.CurrentDocumentVersionId = c.DocumentVersionId
			WHERE Doc.ClientId = @ClientID
				AND ISNULL(C.RecordDeleted, 'N') = 'N'
				AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
				AND C.CarePlanType = 'AD'
				AND DATEDIFF(MONTH, Doc.EffectiveDate, GETDATE()) <= 6
				AND (
					Convert(DATE, Doc.EffectiveDate) >= @EffectiveDateAN
					AND CONVERT(DATE, GETDATE()) >= (Convert(DATE, Doc.EffectiveDate))
					)

			SET @CarePlanAddendumInfo = ISNULL(@CarePlanAddendumInfo, '') + CHAR(13) + ISNULL(@CarePlanAddendumText, '')
		END
		ELSE IF (@LatestCarePlanINDocumentVersionID IS NOT NULL)
		BEGIN
			SELECT @CarePlanAddendumInfo = 'Addendum to:' + CHAR(13) + 'Care Plan Document Dated ' + convert(VARCHAR, Doc.EffectiveDate, 101) + ' - ' + convert(VARCHAR, DateAdd(Month, 6, Doc.EffectiveDate), 101)
				,@GenralAddendumDate = CONVERT(VARCHAR(10), DATEADD(MONTH, 6, Doc.EffectiveDate), 101)
			FROM DOCUMENTS Doc
			WHERE Doc.CurrentDocumentVersionId = @LatestCarePlanINDocumentVersionID

			SELECT @CarePlanAddendumText = COALESCE(@CarePlanAddendumText + CHAR(13), '') + 'Care Plan Addendum Document Dated ' + CONVERT(VARCHAR, Doc.EffectiveDate, 101) + ' - '
				+ CONVERT(VARCHAR(10), @GenralAddendumDate, 101)
			FROM DOCUMENTS Doc
			INNER JOIN DocumentCarePlans C ON doc.CurrentDocumentVersionId = c.DocumentVersionId
			WHERE Doc.ClientId = @ClientID
				AND ISNULL(C.RecordDeleted, 'N') = 'N'
				AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
				AND C.CarePlanType = 'AD'
				AND DATEDIFF(MONTH, Doc.EffectiveDate, GETDATE()) <= 6
				AND CONVERT(DATE, Doc.EffectiveDate, 101) >= CONVERT(DATE, @EpisodeRegistrationDate, 101)

			SET @CarePlanAddendumInfo = ISNULL(@CarePlanAddendumInfo, '') + CHAR(13) + ISNULL(@CarePlanAddendumText, '')
		END		
		
		---grab most recent mha document
		DECLARE @MHAssessmentLevelOfCare VARCHAR(MAX)
		DECLARE @ASAMLevelOfCare VARCHAR(MAX)
		SELECT 
		@ASAMLevelOfCare = dbo.ssf_GetGlobalCodeNameById(ca.ProvidedLevel)
		FROM Documents d
		JOIN CustomDocumentASAMs ca ON d.CurrentDocumentVersionId = ca.DocumentVersionId
		AND ISNULL(ca.RecordDeleted,'N')='N'
		WHERE d.DocumentCodeId = 40034
		AND d.Status = 22
		AND d.ClientId = @ClientId
		AND CONVERT(DATE, d.EffectiveDate) >= CONVERT(DATE, @EpisodeRegistrationDate, 101)
					and not exists (
						select *
						from Documents as d2
						where d2.ClientId = d.ClientId
						AND ISNULL(d2.RecordDeleted,'N') ='N'
						and d2.DocumentCodeId = d.DocumentCodeId
						and d2.Status = 22
						AND d2.ClientId = d.ClientId
						and ((DATEDIFF(day, d2.EffectiveDate, d.EffectiveDate) < 0) 
						or (DATEDIFF(day, d2.EffectiveDate, d.EffectiveDate) = 0 and d2.DocumentId > d.DocumentId))
						AND CONVERT(DATE, d2.EffectiveDate) >= CONVERT(DATE, @EpisodeRegistrationDate, 101)
						)
		AND ISNULL(d.RecordDeleted,'N')='N'
		
		SELECT 
		 @MHAssessmentLevelOfCare =  ca.TransitionLevelOfCare
		FROM Documents d
		JOIN CustomHRMAssessments ca ON d.CurrentDocumentVersionId = ca.DocumentVersionId
		AND ISNULL(ca.RecordDeleted,'N')='N'
		WHERE d.DocumentCodeId = 10018
		AND d.Status = 22
		AND d.ClientId = @ClientId
		AND CONVERT(DATE, d.EffectiveDate) >= CONVERT(DATE, @EpisodeRegistrationDate, 101)
					and not exists (
						select *
						from Documents as d2
						where d2.ClientId = d.ClientId
						AND ISNULL(d2.RecordDeleted,'N') ='N'
						and d2.DocumentCodeId = d.DocumentCodeId
						and d2.Status = 22
						AND d2.ClientId = d.ClientId
						and ((DATEDIFF(day, d2.EffectiveDate, d.EffectiveDate) < 0) 
						or (DATEDIFF(day, d2.EffectiveDate, d.EffectiveDate) = 0 and d2.DocumentId > d.DocumentId))
						AND CONVERT(DATE, d2.EffectiveDate) >= CONVERT(DATE, @EpisodeRegistrationDate, 101)
						)
		AND ISNULL(d.RecordDeleted,'N')='N'				
						
		
		
		
		 SET @EffectiveDate = ISNULL(@EffectiveDate,DATEADD(YEAR,-100,GETDATE()))  
		
		IF (ISNULL(@LatestCarePlanDocumentVersionID,0)<=0)
		BEGIN
			SELECT TOP 1 Placeholder.TableName
				,-1 AS DocumentVersionId
				,CASE 
					WHEN @LatestCarePlanDocumentVersionID IS NULL
						AND @LatestCarePlanANDocumentVersionID IS NULL
						THEN 'IN'
					ELSE 'AD'
					END AS CarePlanType
				,@Adult AS [Adult]
				,@ClientFirstName AS NameInGoalDescriptions
				,'' AS 'Strengths'
				,@NeedNames AS 'Needs'
				,'' AS Abilities
				,'' AS 'Preferences'
				,@MHAssessmentLevelOfCare AS MHAssessmentLevelOfCare
				,@ASAMLevelOfCare AS ASAMLevelOfCare
				,@CarePlanAddendumInfo AS CarePlanAddendumInfo
				,'' AS 'LevelOfCare'
				,'N' AS 'ReductionInSymptoms'
				,@ReductionInSymptomsDescription AS 'ReductionInSymptomsDescription'
				,'N' AS 'AttainmentOfHigherFunctioning'
				,@AttainmentOfHigherFunctioningDescription AS 'AttainmentOfHigherFunctioningDescription'
				,'N' AS 'TreatmentNotNecessary'
				,@TreatmentNotNecessaryDescription AS 'TreatmentNotNecessaryDescription'
				,'N' AS 'OtherTransitionCriteria'
				,@OtherTransitionCriteriaDescription AS 'OtherTransitionCriteriaDescription'
				--,NULL AS 'EstimatedDischargeDate'
				,0 AS SupportsInvolvement
				,'S' AS ReviewEntireCareType
			FROM (
				SELECT 'DocumentCarePlans' AS TableName
				) AS Placeholder			
		END
		ELSE
		BEGIN
			SELECT TOP 1 Placeholder.TableName
				,ISNULL(CSLD.DocumentVersionId, - 1) AS DocumentVersionId
				,CASE 
					WHEN @LatestCarePlanDocumentVersionID IS NULL
						AND @LatestCarePlanANDocumentVersionID IS NULL
						THEN 'IN'
					ELSE 'AD'
					END AS CarePlanType
				,@Adult AS [Adult]
				,@ClientFirstName AS NameInGoalDescriptions
				,CSLD.[Strengths]
				,CSLD.[Barriers]
				,CSLD.[Abilities]
				,CSLD.[Preferences]
				 ,@MHAssessmentLevelOfCare AS MHAssessmentLevelOfCare  
				 ,@ASAMLevelOfCare AS ASAMLevelOfCare  
				,@LevelOfCare AS 'LevelOfCare'
				,@ReductionInSymptoms AS 'ReductionInSymptoms'
				,@ReductionInSymptomsDescription AS 'ReductionInSymptomsDescription'
				,@AttainmentOfHigherFunctioning AS 'AttainmentOfHigherFunctioning'
				,@AttainmentOfHigherFunctioningDescription AS 'AttainmentOfHigherFunctioningDescription'
				,@TreatmentNotNecessary AS 'TreatmentNotNecessary'
				,@TreatmentNotNecessaryDescription AS 'TreatmentNotNecessaryDescription'
				,@OtherTransitionCriteria AS 'OtherTransitionCriteria'
				,@OtherTransitionCriteriaDescription AS 'OtherTransitionCriteriaDescription'
				,@EstimatedDischargeDate AS 'EstimatedDischargeDate'
				,@CarePlanAddendumInfo AS CarePlanAddendumInfo
				--,0 AS SupportsInvolvement  
				,CSLD.SupportsInvolvement AS SupportsInvolvement
				,'S' AS ReviewEntireCareType
			FROM (
				SELECT 'DocumentCarePlans' AS TableName
				) AS Placeholder
			LEFT JOIN DocumentCarePlans CSLD ON (
					CSLD.DocumentVersionId = @LatestCarePlanDocumentVersionID
					AND ISNULL(CSLD.RecordDeleted, 'N') = 'N'
					)	   
		END

		----For CarePlanDomains      
		--SELECT 'CarePlanDomains' AS TableName
		--	,CPD.[CarePlanDomainId]
		--	,CPD.[CreatedBy]
		--	,CPD.[CreatedDate]
		--	,CPD.[ModifiedBy]
		--	,CPD.[ModifiedDate]
		--	,CPD.[RecordDeleted]
		--	,CPD.[DeletedBy]
		--	,CPD.[DeletedDate]
		--	,CPD.[DomainName]
		--FROM CarePlanDomains AS CPD
		--WHERE ISNull(CPD.RecordDeleted, 'N') = 'N'
		--ORDER BY CPD.DomainName

		----CarePlanDomainNeeds      
		--SELECT 'CarePlanDomainNeeds' AS TableName
		--	,CPDN.CarePlanDomainNeedId
		--	,CPDN.CreatedBy
		--	,CPDN.CreatedDate
		--	,CPDN.ModifiedBy
		--	,CPDN.ModifiedDate
		--	,CPDN.RecordDeleted
		--	,CPDN.DeletedBy
		--	,CPDN.DeletedDate
		--	,CPDN.NeedName
		--	,CPDN.CarePlanDomainId
		--	,CPDN.MHAFieldIdentifierCode
		--	,CPDN.MHANeedDescription
		--FROM CarePlanDomainNeeds AS CPDN
		--WHERE ISNull(CPDN.RecordDeleted, 'N') = 'N'

		----CarePlanDomainGoals      
		--SELECT 'CarePlanDomainGoals' AS TableName
		--	,CPDG.CarePlanDomainGoalId
		--	,CPDG.CreatedBy
		--	,CPDG.CreatedDate
		--	,CPDG.ModifiedBy
		--	,CPDG.ModifiedDate
		--	,CPDG.RecordDeleted
		--	,CPDG.DeletedBy
		--	,CPDG.DeletedDate
		--	,CPDG.CarePlanDomainNeedId
		--	,CPDG.GoalDescription
		--	,CPDG.Adult
		--FROM CarePlanDomainGoals AS CPDG
		--WHERE ISNull(CPDG.RecordDeleted, 'N') = 'N'

		----CarePlanDomainObjectives       
		--SELECT 'CarePlanDomainObjectives' AS TableName
		--	,CPDO.[CarePlanDomainObjectiveId]
		--	,CPDO.[CreatedBy]
		--	,CPDO.[CreatedDate]
		--	,CPDO.[ModifiedBy]
		--	,CPDO.[ModifiedDate]
		--	,CPDO.[RecordDeleted]
		--	,CPDO.[DeletedBy]
		--	,CPDO.[DeletedDate]
		--	,CPDO.[CarePlanDomainGoalId]
		--	,CPDO.[ObjectiveDescription]
		--	,CPDO.[Adult]
		--FROM [CarePlanDomainObjectives] CPDO
		--WHERE ISNULL(CPDO.RecordDeleted, 'N') = 'N'

		-- 2015.09.02 - T.Remisoski - Pull Needs from any document (including assessment) that has care plan needs.
		declare @LatestNeedsDocumentVersionId int
		select top 1 @LatestNeedsDocumentVersionId = cpn.DocumentVersionId, @EffectiveDateDifference = datediff(year, d.EffectiveDate, getdate())
		from CarePlanNeeds as cpn
		join Documents as d on d.CurrentDocumentVersionId = cpn.DocumentVersionId
		where d.ClientId = @ClientID
		and d.Status = 22
		and isnull(d.RecordDeleted, 'N') = 'N'
		and isnull(cpn.RecordDeleted, 'N') = 'N'
		order by d.EffectiveDate desc, d.CurrentDocumentVersionId desc
 
		EXEC scsp_InitCarePlanNeeds 
			@ClientID
			,@LatestNeedsDocumentVersionId
			,@EffectiveDateDifference;

		CREATE TABLE #TempAuthorizationCodes (
			AuthorizationCodeId INT
			,AuthorizationCodeName VARCHAR(100)
			,CarePlanPrescribedServiceId INT
			,DocumentVersionId INT
			,NumberOfSessions INT
			,[Units] DECIMAL
			,[UnitType] INT
			,[FrequencyType] INT
			,[PersonResponsible] INT
			,[IsChecked] CHAR(1)
			,InterventionDetails VARCHAR(MAX) 
			,TableName VARCHAR(100)
			)

		EXEC ssp_GetCarePlanPrescribedServicesAuthorizationCodes @ClientID
			,@LatestCarePlanDocumentVersionID
			,'I';

		SELECT AuthorizationCodeId
			,AuthorizationCodeName
			,CarePlanPrescribedServiceId
			,DocumentVersionId
			,NumberOfSessions
			,[Units]
			,[UnitType]
			,[FrequencyType]
			,[PersonResponsible]
			,[IsChecked]
			,InterventionDetails  
			,TableName
		FROM #TempAuthorizationCodes

		SELECT 'CarePlanPrescribedServiceObjectives' AS TableName
			,CPSO.CarePlanPrescribedServiceObjectiveId
			,CPS.CarePlanPrescribedServiceId
			,CPSO.CarePlanObjectiveId
			,CAST(CPO.ObjectiveNumber AS VARCHAR(100)) ObjectiveNumber
			,CDO.ObjectiveDescription
		FROM CarePlanPrescribedServiceObjectives CPSO
		LEFT JOIN CarePlanPrescribedServices CPS ON CPS.CarePlanPrescribedServiceId = CPSO.CarePlanPrescribedServiceId
			AND ISNULL(CPS.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(CPSO.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN CarePlanObjectives CPO ON CPO.CarePlanObjectiveId = CPSO.CarePlanObjectiveId
			AND ISNULL(CPO.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN CarePlanDomainObjectives CDO ON CDO.CarePlanDomainObjectiveId = CPO.CarePlanDomainObjectiveId
		WHERE CPS.DocumentVersionID = @LatestCarePlanDocumentVersionID;

		EXEC ssp_InitCustomDiagnosisStandardInitializationNew @ClientID
			,@StaffID
			,@CustomParameters;

		EXEC ssp_InitCarePlanGoals @LatestCarePlanDocumentVersionID

		SELECT 'CarePlanPrograms' AS TableName
			,P.ProgramId
			,P.ProgramName
			,CP.AssignedStaffId AS StaffId
			,COALESCE(S.LastName, '') + ', ' + COALESCE(S.FirstName, '') AS [StaffName]
			,- 1 AS DocumentVersionId
			,CAST(NULL AS CHAR(1)) AS AssignForContribution
		--CAST(NULL AS INT) AS DocumentAssignedTaskId   
		FROM ClientPrograms CP
		LEFT JOIN Programs P ON CP.ProgramId = P.ProgramId AND ISNULL(P.RecordDeleted, 'N') <> 'Y'
		INNER JOIN Staff S ON S.StaffId = CP.AssignedStaffId 
			AND S.Active = 'Y'
		WHERE ISNULL(CP.RecordDeleted, 'N') <> 'Y' AND ISNULL(S.RecordDeleted, 'N') <> 'Y'
			AND CP.AssignedStaffId IS NOT NULL
			AND CP.ClientId = @ClientID
			AND CP.STATUS IN (
				1
				,4
				) /*GloablCodeId - 1-'Requested',4-'Enrolled' Status*/
			AND EXISTS (
						SELECT *
						FROM dbo.ssf_RecodeValuesCurrent('CAREPLANPROGRAMTYPE') AS CD
						WHERE CD.IntegerCodeId = P.ProgramType
						)
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'scsp_InitCarePlanInitial') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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

--exec [scsp_InitCarePlanInitial] 2671, 1, '<Root><Parameters DocumentCodeID="1620" /></Root>'
--go