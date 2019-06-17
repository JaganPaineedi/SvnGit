/****** Object:  StoredProcedure [dbo].[ssp_SCGetCarePlanInitial]    Script Date: 12/15/2014 16:14:52 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[ssp_SCGetCarePlanInitial]')
			AND TYPE IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetCarePlanInitial]-- 320
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetCarePlanInitial]    Script Date: 12/15/2014 16:14:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetCarePlanInitial] (@DocumentVersionId INT)
AS
-- =============================================
-- Author:		Pradeep.A
-- Create date: 01/19/2015
-- Description:	Get Saved CarePlan document data.
-- jun 04 2015	Pradeep		Added 'S' Source column for Old ASAM Needs
/* Data Modifications:                                               */    
/*                                                                   */    
/*   Date			Author					Purpose                                    */    
/* 01-Sep-2015  R.M.Manikandan   Added Two Column(Number and Duration) in CarePlanPrescribedServices Table  Task #30 -New Directions - Support Go Live                             */    
/* 2016.05.11    Veena S Mani       Review changes Valley Support Go live #390               */
/*01 July 2016	Vithobha			Added @ScreenName to get the screen name dynamically instead of hard code, Bradford - Support Go Live: #134  */
/*08-08-2016	 Lakshmi	        Inteventions altered by alphabatical order for pathway support go live #12.21	
/* 2017.03.06    Neelima	        Added the IsNewCarePlanGoal column in CarePlanGoals table as per AspenPointe-Customizations #86            */
											*/													
/* 04/27/2018    Neha		        Added a new column called Intervention Details in the intervention section. 
									Task #10004 Porter Starke Customization */		
/*  01/30/2109	Ponnin				What:  Changed length of InterventionDetails to VARCHAR(MAX) for the temp table #TempAuthorizationCodes. 	Why: HighPlains - Environment Issues Tracking - Task #8  */										
/* 22/03/2019	Vandana				What : Added source name for Needs in ISP from CANS(Birth-5),CANS(5-17) and ANSA
									Why: PSS-Enhancements #10004.12*/

/*********************************************************************/       

-- =============================================
BEGIN TRY
	DECLARE @ClientId INT
	DECLARE @EffectiveDate DATETIME
	DECLARE @EpisodeRegistrationDate DATETIME
	DECLARE @LatestCarePlanDocumentVersionID INT
	DECLARE @ScreenName varchar(100)
	
	Select @ScreenName=Screenname From Screens Where ScreenId=1077   

	SELECT @ClientId = ClientId
		,@EffectiveDate = EffectiveDate
	FROM Documents
	WHERE InProgressDocumentVersionId = @DocumentVersionId
	
		SELECT @EpisodeRegistrationDate = ce.RegistrationDate
		FROM Clients c
		INNER JOIN ClientEpisodes ce ON ce.ClientId = c.ClientId
			AND ce.EpisodeNumber = c.CurrentEpisodeNumber
		WHERE ISNULL(ce.RecordDeleted, 'N') = 'N'
			AND c.ClientId = @ClientId
					
		SELECT TOP 1 @LatestCarePlanDocumentVersionID = CurrentDocumentVersionId
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
			
	--DocumentCarePlans                        
	SELECT SLD.[DocumentVersionId]
		,SLD.[CreatedBy]
		,SLD.[CreatedDate]
		,SLD.[ModifiedBy]
		,SLD.[ModifiedDate]
		,SLD.[RecordDeleted]
		,SLD.[DeletedBy]
		,SLD.[DeletedDate]
		,SLD.[CarePlanType]
		,SLD.[CarePlanAddendumInfo]
		,SLD.[NameInGoalDescriptions]
		,SLD.[Strengths]
		,SLD.[Barriers]
		,SLD.[Abilities]
		,SLD.[Preferences]
		,SLD.[MHAssessmentLevelOfCare]
		,SLD.[ASAMLevelOfCare]
		,SLD.[LevelOfCare]
		,SLD.[ReductionInSymptoms]
		,SLD.[ReductionInSymptomsDescription]
		,SLD.[AttainmentOfHigherFunctioning]
		,SLD.[AttainmentOfHigherFunctioningDescription]
		,SLD.[TreatmentNotNecessary]
		,SLD.[TreatmentNotNecessaryDescription]
		,SLD.[OtherTransitionCriteria]
		,SLD.[OtherTransitionCriteriaDescription]
		,SLD.[EstimatedDischargeDate]
		,SLD.[CarePlanProgressReviewDate]
		,SLD.[ReviewEntireCarePlanDate]
		,SLD.[SupportsInvolvement]
		,SLD.[ReviewEntireCareType]
		,SLD.[ReviewEntireCarePlan]
		,SLD.[CarePlanReviewComments]
		,CASE WHEN @LatestCarePlanDocumentVersionID IS NULL
		THEN 'N' else 'Y' end as PreviousCP
	FROM [DocumentCarePlans] SLD
	WHERE ISNULL(SLD.RecordDeleted, 'N') = 'N'
		AND SLD.DocumentVersionId = @DocumentVersionId

	--For CarePlanDomains    
	SELECT CPD.[CarePlanDomainId]
		,CPD.[CreatedBy]
		,CPD.[CreatedDate]
		,CPD.[ModifiedBy]
		,CPD.[ModifiedDate]
		,CPD.[RecordDeleted]
		,CPD.[DeletedBy]
		,CPD.[DeletedDate]
		,CPD.[DomainName]
	FROM CarePlanDomains AS CPD
	WHERE ISNULL(CPD.RecordDeleted, 'N') = 'N'
	AND CPD.[CarePlanDomainId] = -1
	ORDER BY CPD.DomainName

	--CarePlanDomainNeeds    
	SELECT CPDN.CarePlanDomainNeedId
		,CPDN.CreatedBy
		,CPDN.CreatedDate
		,CPDN.ModifiedBy
		,CPDN.ModifiedDate
		,CPDN.RecordDeleted
		,CPDN.DeletedBy
		,CPDN.DeletedDate
		,CPDN.NeedName
		,CPDN.CarePlanDomainId
		,CPDN.MHAFieldIdentifierCode
		,CPDN.MHANeedDescription
	FROM CarePlanDomainNeeds AS CPDN
	WHERE ISNULL(CPDN.RecordDeleted, 'N') = 'N'
	AND CPDN.CarePlanDomainNeedId = -1

	--CarePlanDomainGoals    
	SELECT CPDG.CarePlanDomainGoalId
		,CPDG.CreatedBy
		,CPDG.CreatedDate
		,CPDG.ModifiedBy
		,CPDG.ModifiedDate
		,CPDG.RecordDeleted
		,CPDG.DeletedBy
		,CPDG.DeletedDate
		,CPDG.CarePlanDomainNeedId
		,CPDG.GoalDescription
		,CPDG.Adult
	FROM CarePlanDomainGoals AS CPDG
	WHERE ISNULL(CPDG.RecordDeleted, 'N') = 'N'
	AND CPDG.CarePlanDomainGoalId = -1

	--CarePlanNeeds
	SELECT CPN.[CarePlanNeedId]
		,CPN.[CreatedBy]
		,CPN.[CreatedDate]
		,CPN.[ModifiedBy]
		,CPN.[ModifiedDate]
		,CPN.[RecordDeleted]
		,CPN.[DeletedBy]
		,CPN.[DeletedDate]
		,CPN.[DocumentVersionId]
		,CPN.[CarePlanDomainNeedId]
		,CPN.[NeedDescription]
		,CPN.[AddressOnCarePlan]
		,CPN.[Source]
		,CPD.[CarePlanDomainId]
		,CPDN.[NeedName]
		,CASE CPN.[Source]
			WHEN 'C'
				THEN @ScreenName
			WHEN 'A'
				THEN 'ASAM'
			WHEN 'M'
				THEN 'MHA'
			WHEN 'O'
				THEN 'Old MHA'
			WHEN 'S'
				THEN 'Old ASAM'
				--PSS-Enhancements #10004.12--
			WHEN 'F'
				THEN 'CANS (5 - 17)'
			WHEN  'B'
				THEN 'CANS (Birth - 5)'
			WHEN  'I'
				THEN 'ANSA - Indiana'
			END AS SourceName
	FROM CarePlanNeeds CPN
	INNER JOIN CarePlanDomainNeeds CPDN ON CPDN.CarePlanDomainNeedId = CPN.CarePlanDomainNeedId
	INNER JOIN CarePlanDomains CPD ON CPD.CarePlanDomainId = CPDN.CarePlanDomainId
	WHERE ISNULL(CPN.RecordDeleted, 'N') = 'N'
		AND CPN.DocumentVersionId = @DocumentVersionId

	--CarePlanGoals
	SELECT CPG.[CarePlanGoalId]
		,CPG.[CreatedBy]
		,CPG.[CreatedDate]
		,CPG.[ModifiedBy]
		,CPG.[ModifiedDate]
		,CPG.[RecordDeleted]
		,CPG.[DeletedBy]
		,CPG.[DeletedDate]
		,CPG.[DocumentVersionId]
		,CPG.[CarePlanDomainGoalId]
		,CPG.[GoalNumber]
		,CPG.[ClientGoal]
		,CPG.[GoalActive]
		,CPG.[ProgressTowardsGoal]
		,CPG.[GoalReviewUpdate]
		,CPG.[InitializedFromPreviousCarePlan]
		,CPG.[GoalStartDate]
		,CPG.[GoalEndDate]
		,CPG.[MonitoredByType]
		,CPG.[MonitoredBy]
		,CPG.[MonitoredByOtherDescription]
		,CPG.[IsError]
		,CPG.[IsErrorUpdatedDate]
		,CPG.[IsErrorUpdatedBy]
		,CPG.[AssociatedGoalDescription]
		,CPDG.[GoalDescription]	
		--Added by Veena Valley Support Go live #390
		,CPG.IsNewGoal	
		,CPG.IsNewCarePlanGoal	 --Added by Neelima
	FROM CarePlanGoals CPG
	LEFT JOIN CarePlanDomainGoals CPDG ON CPG.CarePlanDomainGoalId = CPDG.CarePlanDomainGoalId
	WHERE ISNULL(CPG.RecordDeleted, 'N') = 'N'
		AND CPG.DocumentVersionId = @DocumentVersionId

	--CarePlanGoalNeeds
	SELECT CPGN.[CarePlanGoalNeedId]
		,CPGN.[CreatedBy]
		,CPGN.[CreatedDate]
		,CPGN.[ModifiedBy]
		,CPGN.[ModifiedDate]
		,CPGN.[RecordDeleted]
		,CPGN.[DeletedBy]
		,CPGN.[DeletedDate]
		,CPGN.[CarePlanGoalId]
		,CPGN.[CarePlanNeedId]
		,CPGN.[AssociatedNeedDescription]
	FROM CarePlanGoalNeeds CPGN
	INNER JOIN CarePlanGoals CPG ON CPG.CarePlanGoalId = CPGN.CarePlanGoalId
	WHERE ISNULL(CPGN.RecordDeleted, 'N') = 'N' AND ISNULL(CPG.RecordDeleted, 'N') = 'N'
		AND CPG.DocumentVersionId = @DocumentVersionId;

	--CarePlanObjectives
	SELECT CPO.[CarePlanObjectiveId]
		,CPO.[CreatedBy]
		,CPO.[CreatedDate]
		,CPO.[ModifiedBy]
		,CPO.[ModifiedDate]
		,CPO.[RecordDeleted]
		,CPO.[DeletedBy]
		,CPO.[DeletedDate]
		,CPO.[CarePlanGoalId]
		,CPO.[CarePlanDomainObjectiveId]
		,CPO.[ObjectiveNumber]
		,CDO.[ObjectiveDescription]
		,CPO.[StaffSupports]
		,CPO.[MemberActions]
		,CPO.[UseOfNaturalSupports]
		,CPO.[Status]
		,CPO.[InitializedFromPreviousCarePlan]
		,CPO.[ProgressTowardsObjective]
		,CPO.[ObjectiveReview]
		,CPO.[ObjectiveStartDate]
		,CPO.[ObjectiveEndDate]
		,CPO.[IsError]
		,CPO.[IsErrorUpdatedDate]
		,CPO.[IsErrorUpdatedBy]
		,CPO.[ScoreDate]
		,CPO.[AssociatedObjectiveDescription]	
		--Added by Veena Valley Support Go live #390
		,CPO.IsNewObjective	
	FROM CarePlanObjectives CPO
	LEFT JOIN CarePLanGoals CPG ON CPG.CarePlanGoalId = CPO.CarePlanGoalId
    LEFT JOIN CarePlanDomainObjectives AS CDO ON CPO.CarePlanDomainObjectiveId = CDO.CarePlanDomainObjectiveId  
	WHERE ISNULL(CPG.RecordDeleted, 'N') = 'N'
		AND ISNULL(CDO.RecordDeleted, 'N') = 'N'
		AND ISNULL(CPO.RecordDeleted, 'N') = 'N'
		AND CPG.DocumentVersionId = @DocumentVersionId

	--CarePlanPrescribedServices
	SELECT  
		CPPS.[CarePlanPrescribedServiceId]
		,CPPS.[CreatedBy]
		,CPPS.[CreatedDate]
		,CPPS.[ModifiedBy]
		,CPPS.[ModifiedDate]
		,CPPS.[RecordDeleted]
		,CPPS.[DeletedBy]
		,CPPS.[DeletedDate]
		,CPPS.[DocumentVersionId]
		,CPPS.[AuthorizationCodeId]
		,CPPS.[NumberOfSessions]
		,CPPS.[Units]
		,CPPS.[UnitType]
		,CPPS.[FrequencyType]
--01-09-2015  R.M.Manikandan		
		,CPPS.[Number]
		,CPPS.[Duration]
-- Changes End  
		,CPPS.[PersonResponsible]
		,AC.AuthorizationCodeId   
		,AC.DisplayAs As AuthorizationCodeName  
		,'Y' AS [IsChecked] 
		,CPPS.InterventionDetails 
	FROM CarePlanPrescribedServices CPPS
	LEFT JOIN AuthorizationCodes AC ON AC.AuthorizationCodeId = CPPS.AuthorizationCodeId  
	WHERE CPPS.[DocumentVersionId] = @DocumentVersionId
		AND ISNULL(CPPS.RecordDeleted, 'N') = 'N'
		AND ISNULL(AC.RecordDeleted, 'N') = 'N'
		AND AC.Active = 'Y' AND AC.Internal = 'Y'   
		ORDER BY AC.DisplayAs  

	--CarePlanPrescribedServiceObjectives
	SELECT CPPSO.[CarePlanPrescribedServiceObjectiveId]
		,CPPSO.[CreatedBy]
		,CPPSO.[CreatedDate]
		,CPPSO.[ModifiedBy]
		,CPPSO.[ModifiedDate]
		,CPPSO.[RecordDeleted]
		,CPPSO.[DeletedBy]
		,CPPSO.[DeletedDate]
		,CPPSO.[CarePlanPrescribedServiceId]
		,CPPSO.[CarePlanObjectiveId]
		,CPO.ObjectiveNumber
		,CPDO.ObjectiveDescription AS ObjectiveDescription  
	FROM CarePlanPrescribedServiceObjectives CPPSO
	INNER JOIN CarePlanPrescribedServices CPPS ON CPPSO.CarePlanPrescribedServiceId = CPPS.CarePlanPrescribedServiceId
	LEFT JOIN CarePlanObjectives CPO ON CPPSO.CarePlanObjectiveId = CPO.CarePlanObjectiveId  
	LEFT JOIN CarePlanDomainObjectives CPDO ON CPDO.CarePlanDomainObjectiveId = CPO.CarePlanDomainObjectiveId  
	WHERE CPPS.[DocumentVersionId] = @DocumentVersionId
		AND ISNULL(CPPSO.RecordDeleted, 'N') = 'N'
		AND ISNULL(CPPS.RecordDeleted, 'N') = 'N'
		AND ISNULL(CPO.RecordDeleted, 'N') = 'N'
		AND ISNULL(CPDO.RecordDeleted, 'N') = 'N'
		AND CPO.Status = 'A'  

	--CarePlanPrograms
	SELECT CPP.[CarePlanProgramId]
		,CPP.[CreatedBy]
		,CPP.[CreatedDate]
		,CPP.[ModifiedBy]
		,CPP.[ModifiedDate]
		,CPP.[RecordDeleted]
		,CPP.[DeletedBy]
		,CPP.[DeletedDate]
		,CPP.[DocumentVersionId]
		,CPP.[ProgramId]
		,CPP.[StaffId]
		,CPP.[AssignForContribution]
		,CPP.[Completed]
		,CPP.[DocumentAssignedTaskId]
		,P.[ProgramName]
		,COALESCE(S.LastName, '') + ', ' + COALESCE(S.FirstName, '') AS [StaffName]
	FROM CarePlanPrograms CPP
	LEFT JOIN Programs P ON CPP.ProgramId = P.ProgramId
	LEFT JOIN Staff S ON S.StaffId = CPP.StaffId
	WHERE CPP.[DocumentVersionId] = @DocumentVersionId
		AND ISNULL(CPP.RecordDeleted, 'N') = 'N'
		AND ISNULL(S.RecordDeleted, 'N') = 'N'
		AND ISNULL(P.RecordDeleted, 'N') = 'N'

	--CarePlanDomainObjectives    	
	SELECT CPDO.[CarePlanDomainObjectiveId]
		,CPDO.[CreatedBy]
		,CPDO.[CreatedDate]
		,CPDO.[ModifiedBy]
		,CPDO.[ModifiedDate]
		,CPDO.[RecordDeleted]
		,CPDO.[DeletedBy]
		,CPDO.[DeletedDate]
		,CPDO.[CarePlanDomainGoalId]
		,CPDO.[ObjectiveDescription]
		,CPDO.[Adult]
	FROM [CarePlanDomainObjectives] CPDO
	WHERE ISNULL(CPDO.RecordDeleted, 'N') = 'N'
	AND CPDO.[CarePlanDomainObjectiveId] = -1

	IF EXISTS (
			SELECT *
			FROM sys.objects
			WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[#TempAuthorizationCodes]')
				AND TYPE IN (N'U')
			)
		DROP TABLE #TempAuthorizationCodes

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

	EXEC [ssp_GetCarePlanPrescribedServicesAuthorizationCodes] @ClientId
		,@DocumentVersionId
		,'G';

	SELECT AuthorizationCodeId
		,LTRIM(RTRIM(AuthorizationCodeName)) AS AuthorizationCodeName -- Added Ltrim and trim by Lakshmi 08-08-2016 Pathway support go live #12.21
	FROM #TempAuthorizationCodes ORDER BY AuthorizationCodeName ASC

	--Diagnosis
	EXEC ssp_SCGetDataDiagnosisNew @DocumentVersionId;

	--CarePlanGoalHistory
	SELECT CPGH.[CarePlanGoalHistoryId]
		,CPGH.[CreatedBy]
		,CPGH.[CreatedDate]
		,CPGH.[ModifiedBy]
		,CPGH.[ModifiedDate]
		,CPGH.[RecordDeleted]
		,CPGH.[DeletedBy]
		,CPGH.[DeletedDate]
		,CPGH.[CarePlanGoalId]
		,CPGH.[ClientGoal]
		,CPGH.[GoalStartDate]
		,CPGH.[GoalEndDate]
		,CPGH.[MonitoredBy]
		,CPGH.[MonitoredByType]
		,CPGH.[MonitoredByOtherDescription]
		,CPGH.[CarePlanDomainGoalId ]
	FROM CarePlanGoalHistory CPGH
	INNER JOIN CarePlanGoals CPG ON CPG.CarePlanGoalId = CPGH.CarePlanGoalId
	WHERE CPG.DocumentVersionId = @DocumentVersionId
		AND ISNULL(CPGH.RecordDeleted, 'N') = 'N'
		AND ISNULL(CPG.RecordDeleted, 'N') = 'N'

	SELECT CPOH.[CarePlanObjectiveHistoryId]
		,CPOH.[CreatedBy]
		,CPOH.[CreatedDate]
		,CPOH.[ModifiedBy]
		,CPOH.[ModifiedDate]
		,CPOH.[RecordDeleted]
		,CPOH.[DeletedBy]
		,CPOH.[DeletedDate]
		,CPOH.[CarePlanObjectiveId]
		,CPOH.[ObjectiveStartDate]
		,CPOH.[ObjectiveEndDate]
		,CPOH.[MonitoredBy]
		,CPOH.[MonitoredByType]
		,CPOH.[MonitoredByOtherDescription]
		,CPOH.[CarePlanDomainObjectiveId]
	FROM CarePlanObjectiveHistory CPOH
	INNER JOIN CarePlanObjectives CPO ON CPO.CarePlanObjectiveId = CPOH.CarePlanObjectiveId
	INNER JOIN CarePlanGoals CPG ON CPG.CarePlanGoalId = CPO.CarePlanGoalId
	WHERE CPG.DocumentVersionId = @DocumentVersionId
		AND ISNULL(CPO.RecordDeleted, 'N') = 'N'
		AND ISNULL(CPG.RecordDeleted, 'N') = 'N'
		AND ISNULL(CPOH.RecordDeleted, 'N') = 'N'
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetCarePlanInitial') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.                                    
			16
			,-- Severity.                                    
			1 -- State.                                    
			);
END CATCH
GO

