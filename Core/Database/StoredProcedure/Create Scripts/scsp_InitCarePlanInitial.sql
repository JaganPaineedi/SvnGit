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

*/
/* 2016.05.11    Veena S Mani       Review changes Valley Support Go live #390               */
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
--Added by Veena on 05/11/16 for CarePlan Review changes Valley Support Go live #390
						,'RE'
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
		
		 SET @EffectiveDate = ISNULL(@EffectiveDate,DATEADD(YEAR,-100,GETDATE()))  
		
     DECLARE @ReviewEntireCareType char(1)
		         DECLARE @ReviewEntireCarePlan INT
		         DECLARE @ReviewEntireCarePlanDate DateTime
		         DECLARE @LatestDocumentVersionIdCarePlan INT
		         DECLARE @CarePlanType varchar(5)
		         IF (@LatestCarePlanDocumentVersionID IS NULL AND @LatestCarePlanANDocumentVersionID IS NULL)
		         SET @CarePlanType='IN'
		         ELSE
		         SET @CarePlanType='AD'
		         
		    IF (dbo.ssf_GetSystemConfigurationKeyValue('SetReviewInCarePlan') = 'Y')
		    BEGIN
		        
		         SELECT TOP 1
                    @LatestDocumentVersionIdCarePlan = ISNULL(InProgressDocumentVersionId, 0) 
            FROM    Documents 
            WHERE   ClientId = @ClientID
                    AND CONVERT(DATE, EffectiveDate) <= CONVERT(DATE, GETDATE(), 101)
                    AND STATUS = 22
                    AND DocumentCodeId IN ( 1620 )
                    AND ISNULL(RecordDeleted, 'N') <> 'Y'
            ORDER BY EffectiveDate DESC ,
                    ModifiedDate DESC
                    IF ( @LatestDocumentVersionIdCarePlan IS NOT NULL) 
                 BEGIN
		         Select @ReviewEntireCareType=ReviewEntireCareType,@ReviewEntireCarePlan=ReviewEntireCarePlan,@ReviewEntireCarePlanDate=ReviewEntireCarePlanDate
		         From  DocumentCarePlans where DocumentVersionId = @LatestDocumentVersionIdCarePlan
		         IF(CONVERT(DATE, @ReviewEntireCarePlanDate) <= CONVERT(DATE, GETDATE(), 101))
		         SET @ReviewEntireCarePlanDate = NULL
		         END
		       
		    END
		IF (ISNULL(@LatestCarePlanDocumentVersionID,0)<=0)
		BEGIN
			SELECT TOP 1 Placeholder.TableName
				,-1 AS DocumentVersionId
				,CASE 
					WHEN @LatestCarePlanDocumentVersionID IS NULL
						AND @LatestCarePlanANDocumentVersionID IS NULL
						THEN 'IN'
					WHEN @LatestCarePlanDocumentVersionID IS NOT NULL
						 AND (dbo.ssf_GetSystemConfigurationKeyValue('SetReviewInCarePlan') = 'Y')
					THEN NULL
					ELSE 'AD'
					END AS CarePlanType
				,@Adult AS [Adult]
				,@ClientFirstName AS NameInGoalDescriptions
				,'' AS 'Strengths'
				,@NeedNames AS 'Needs'
				,'' AS Abilities
				,'' AS 'Preferences'
				,'' AS MHAssessmentLevelOfCare
				,'' AS ASAMLevelOfCare
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
				--,'S' AS ReviewEntireCareType
				  --Added by Veena
                           , CASE WHEN (@CarePlanType = 'AD' and dbo.ssf_GetSystemConfigurationKeyValue('SetReviewInCarePlan') = 'Y')
                            THEN @ReviewEntireCareType ELSE
                            'S' END AS ReviewEntireCareType,
                             CASE WHEN (@CarePlanType = 'AD' and dbo.ssf_GetSystemConfigurationKeyValue('SetReviewInCarePlan') = 'Y')
                            THEN @ReviewEntireCarePlan ELSE NULL END AS ReviewEntireCarePlan,
                             CASE WHEN (@CarePlanType = 'AD' and dbo.ssf_GetSystemConfigurationKeyValue('SetReviewInCarePlan') = 'Y')
                            THEN @ReviewEntireCarePlanDate ELSE NULL END AS ReviewEntireCarePlanDate
                            --code ends here
				,CASE 
					WHEN @LatestCarePlanDocumentVersionID IS NULL
					THEN 'N' else 'Y' end as PreviousCP
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
						WHEN @LatestCarePlanDocumentVersionID IS NOT NULL
						 AND  (dbo.ssf_GetSystemConfigurationKeyValue('SetReviewInCarePlan') = 'Y')
					THEN NULL
					ELSE 'AD'
					
					END AS CarePlanType
				,@Adult AS [Adult]
				,@ClientFirstName AS NameInGoalDescriptions
				,CSLD.[Strengths]
				,CSLD.[Barriers]
				,CSLD.[Abilities]
				,CSLD.[Preferences]
				 ,'' AS MHAssessmentLevelOfCare  
				 ,'' AS ASAMLevelOfCare  
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
  ,CASE WHEN (@CarePlanType = 'AD' and dbo.ssf_GetSystemConfigurationKeyValue('SetReviewInCarePlan') = 'Y')
                            THEN @ReviewEntireCareType ELSE
                            'S' END AS ReviewEntireCareType,
                             CASE WHEN (@CarePlanType = 'AD' and dbo.ssf_GetSystemConfigurationKeyValue('SetReviewInCarePlan') = 'Y')
                            THEN @ReviewEntireCarePlan ELSE NULL END AS ReviewEntireCarePlan,
                             CASE WHEN (@CarePlanType = 'AD' and dbo.ssf_GetSystemConfigurationKeyValue('SetReviewInCarePlan') = 'Y')
                            THEN @ReviewEntireCarePlanDate ELSE NULL END AS ReviewEntireCarePlanDate

				,CASE 
					WHEN @LatestCarePlanDocumentVersionID IS NULL
					THEN 'N' else 'Y' end as PreviousCP
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

		EXEC ssp_InitCarePlanNeeds @ClientID
			,@LatestCarePlanDocumentVersionID
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
		LEFT JOIN Programs P ON CP.ProgramId = P.ProgramId
		LEFT JOIN Staff S ON S.StaffId = CP.AssignedStaffId
			AND S.Active = 'Y'
		WHERE ISNULL(CP.RecordDeleted, 'N') <> 'Y'
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

