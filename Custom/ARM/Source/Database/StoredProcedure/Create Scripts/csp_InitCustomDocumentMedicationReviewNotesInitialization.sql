
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDocumentMedicationReviewNotesInitialization]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_InitCustomDocumentMedicationReviewNotesInitialization]
GO

/****** Object:  StoredProcedure [dbo].[csp_InitCustomDocumentMedicationReviewNotesInitialization]    Script Date: 01/16/2017 10:59:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_InitCustomDocumentMedicationReviewNotesInitialization] 
(
	@ClientID INT
	,@StaffID INT
	,@CustomParameters XML
)
AS
/**********************************************************************************************************************/
/* Stored Procedure: [csp_InitCustomDocumentMedicationReviewNotesInitialization]									  */
/* Creation Date:  11/July/2011																						  */
/* Purpose: To Initialize																							  */
/* Input Parameters:																								  */
/* Output Parameters:																								  */
/* Return:																											  */
/* Called By:CustomDocuments Class Of DataService																	  */
/* Calls:																											  */
/*======================================================================================================================																													  */
/* Data Modifications: ********************************************************************************************** */
/* Date					Author                  Purpose																  */
/* 20/July/2011			Jagdeep                 Creation															  */
/* 18/JAN/2012			Rohit Katoch            Modify : Change @clientName as   (LastName+','+ FirstName)			  */
/* 16-Apr-2012			T. Remisoski			Get latest diagnosis document from document code id 5.				  */
/* July 21, 2012		Pralyankar				Modified for implementing the Placeholder Concept					  */
/* July 21, 2012		T.Remisoski				Modified for new parameter added to medication list.				  */
/* July 22, 2012		AmitSr				    #1956, Harbor Go Live Issues, Medication Review Note: Showing wrong Information */
/* Aug 31, 2012			AmitSr				    #47, Harbor Development, Tom has changed the sp (csp_GetCustomHarborMedicationList) 
												due to this sp we need to change the parameter which was called by this sp */
/* 2012.11.14 -			T. Remisoski -			Changes for init request changes.									  */
/* 2012.12.20 -			T. Remisoski -			Added MoreThan50PercentTimeSpentCounseling check box.				  */
/* 12/12/2016           Ting-Yu Mu				To have the Billing Dx tab on the medication review note to pull from 
												the most recently signed DSM 5 Dx document                            */
/* 01/16/2017           Ting-Yu Mu              To have the information on the medication review note to pull from 
												the most recently signed DSM 5 Dx document, Psych Eval, and Med Review*/
/**********************************************************************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @LatestDocumentVersionID INT
		DECLARE @clientName VARCHAR(110)
		DECLARE @clientAge INT
		DECLARE @clientGender VARCHAR(10)
		DECLARE @Age VARCHAR(10)
		DECLARE @index INT
		DECLARE @PreviousDocumentType INT
		DECLARE @PreviousTreatmentRecommendationsAndOrders VARCHAR(max)
		DECLARE @PreviousChangesSinceLastVisit VARCHAR(max)
		DECLARE @TreatmentRecommendationsAndOrders VARCHAR(max)
		DECLARE @CurrentMedications VARCHAR(max)
		DECLARE @LatestDxVersionId INT
		DECLARE @LatestPsychEvalVersionId INT
		DECLARE @LatestLegacyNoteId INT
		
		DECLARE @constDocumentCodePsychEval INT = 1489
			,@constDocumentCodeMedReviewNote INT = 1490
			--,@constDocumentCodeDSM5Dx INT = 1601 -- tmu modified on 12/12/2016
			
		DECLARE @tMedications TABLE (MedicationList VARCHAR(MAX))

		INSERT INTO @tMedications (MedicationList)
		EXEC [dbo].[csp_GetCustomHarborMedicationList] @ClientId

		SELECT @CurrentMedications = MedicationList
		FROM @tMedications

		SET @clientName = (
				SELECT (LastName + ', ' + FirstName)
				FROM Clients
				WHERE ClientId = @ClientID
					AND IsNull(RecordDeleted, 'N') = 'N'
				)
		SET @clientGender = (
				SELECT CASE Sex
						WHEN 'M'
							THEN 'Male'
						WHEN 'F'
							THEN 'Female'
						ELSE ''
						END AS Sex
				FROM Clients
				WHERE ClientId = @ClientID
					AND IsNull(RecordDeleted, 'N') = 'N'
				)

		EXEC csp_CalculateAge @ClientId
			,@Age OUT

		SET @index = (
				SELECT CHARINDEX(' ', @Age)
				)
		SET @clientAge = substring(@Age, 0, @index)

		SELECT TOP 1 @LatestDocumentVersionID = d.CurrentDocumentVersionId
			,@PreviousDocumentType = d.DocumentCodeId
		FROM dbo.Documents AS d
		WHERE d.ClientId = @ClientID
			AND d.DocumentCodeId IN 
			(
				--@constDocumentCodeDSM5Dx -- tmu modified on 12/12/2016
				@constDocumentCodePsychEval
				,@constDocumentCodeMedReviewNote
			)
			AND d.STATUS = 22
			AND ISNULL(d.RecordDeleted, 'N') <> 'Y'
		ORDER BY d.EffectiveDate DESC
			,d.ModifiedDate DESC
			,d.DocumentId DESC

		SELECT TOP 1 @LatestLegacyNoteId = DocumentVersionId
		FROM dbo.DocumentVersions AS dv
		JOIN dbo.Documents AS d ON d.CurrentDocumentVersionId = dv.DocumentVersionId
		WHERE d.ClientId = @ClientId
			AND d.DocumentCodeId = 10012
			AND d.STATUS = 22
			AND ISNULL(d.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(dv.RecordDeleted, 'N') <> 'Y'
		ORDER BY d.EffectiveDate DESC
			,d.DocumentId DESC

		IF @LatestDocumentVersionID IS NOT NULL
		BEGIN
			IF @PreviousDocumentType = @constDocumentCodeMedReviewNote
				SELECT @PreviousTreatmentRecommendationsAndOrders = 'Date of Last Signed Med Note: ' + CONVERT(VARCHAR, d.EffectiveDate, 101) + '.' + CHAR(13) + CHAR(10) + mn.TreatmentRecommendationsAndOrders
					,@PreviousChangesSinceLastVisit = mn.ChangesSinceLastVisit
					,@TreatmentRecommendationsAndOrders = mn.TreatmentRecommendationsAndOrders
				FROM dbo.CustomDocumentMedicationReviewNotes AS mn
				JOIN dbo.DocumentVersions AS dv ON dv.DocumentVersionId = mn.DocumentVersionId
				JOIN dbo.Documents AS d ON d.DocumentId = dv.DocumentId
				WHERE mn.DocumentVersionId = @LatestDocumentVersionID
			ELSE IF @PreviousDocumentType = @constDocumentCodePsychEval
				SELECT @PreviousTreatmentRecommendationsAndOrders = 'Date of Last Signed Med Note: ' + CONVERT(VARCHAR, d.EffectiveDate, 101) + '.' + CHAR(13) + CHAR(10) + mn.TreatmentRecommendationsAndOrders
					,@PreviousChangesSinceLastVisit = NULL
					,@TreatmentRecommendationsAndOrders = mn.TreatmentRecommendationsAndOrders
				FROM dbo.CustomDocumentPsychiatricEvaluations AS mn
				JOIN dbo.DocumentVersions AS dv ON dv.DocumentVersionId = mn.DocumentVersionId
				JOIN dbo.Documents AS d ON d.DocumentId = dv.DocumentId
				WHERE mn.DocumentVersionId = @LatestDocumentVersionID
-- =====================================================================================================================
			--ELSE IF @PreviousDocumentType = @constDocumentCodeDSM5Dx -- tmu modified on 12/12/2016
			--	SELECT @PreviousTreatmentRecommendationsAndOrders = 'Date of Last Signed Med Note: ' + CONVERT(VARCHAR, d.EffectiveDate, 101) + '.' + CHAR(13) + CHAR(10) + dd.FactorComments
			--		,@PreviousChangesSinceLastVisit = NULL
			--		,@TreatmentRecommendationsAndOrders = dd.FactorComments
			--	FROM dbo.DocumentDiagnosis AS dd
			--	JOIN dbo.DocumentVersions AS dv ON dv.DocumentVersionId = dd.DocumentVersionId
			--	JOIN dbo.Documents AS d ON d.DocumentId = dv.DocumentId
			--	WHERE dd.DocumentVersionId = @LatestDocumentVersionID
-- =====================================================================================================================
		END
		ELSE
		BEGIN
			SELECT @PreviousTreatmentRecommendationsAndOrders = 'Date of Last Signed Med Note: ' + CONVERT(VARCHAR, d.EffectiveDate, 101) + '.' + CHAR(13) + CHAR(10) + n.TreatmentRecommendations
				,@PreviousChangesSinceLastVisit = ISNULL(n.ClinicalStatus, '') + CASE 
					WHEN n.ClinicalStatus IS NOT NULL
						THEN CHAR(13) + CHAR(10)
					ELSE ''
					END + ISNULL(n.ChangesResponse, '')
				,@TreatmentRecommendationsAndOrders = n.TreatmentRecommendations
			FROM dbo.CustomDocumentMedicationManagementNotes AS n
			JOIN dbo.DocumentVersions AS dv ON dv.DocumentVersionId = n.DocumentVersionId
			JOIN dbo.Documents AS d ON d.DocumentId = dv.DocumentId
			WHERE n.DocumentVersionId = @LatestLegacyNoteId
		END

		--CustomDocumentMedicationReviewNotes--
		IF (@PreviousDocumentType = @constDocumentCodeMedReviewNote)
			OR (@PreviousDocumentType IS NULL)
			SELECT Placeholder.TableName
				,ISNULL(cdmn.DocumentVersionId, - 1) AS DocumentVersionId
				,cdmn.[CreatedBy]
				,cdmn.[CreatedDate]
				,cdmn.[ModifiedBy]
				,cdmn.[ModifiedDate]
				,cdmn.[RecordDeleted]
				,cdmn.[DeletedBy]
				,cdmn.[DeletedDate]
				,@clientName AS [ClientName]
				,@clientAge AS [ClientAge]
				,@clientGender AS [ClientGender]
				,@CurrentMedications AS [CurrentMedications]
				,@PreviousTreatmentRecommendationsAndOrders AS [PreviousTreatmentRecommendationsAndOrders]
				,@PreviousChangesSinceLastVisit AS [PreviousChangesSinceLastVisit]
				,CAST(NULL AS VARCHAR(max)) AS [ChangesSinceLastVisit]
				,CAST(NULL AS VARCHAR(max)) AS [MedicationsPrescribed]
				,cdmn.[MedEducationSideEffectsDiscussed]
				,cdmn.[MedEducationAlternativesReviewed]
				,cdmn.[MedEducationAgreedRegimen]
				,cdmn.[MedEducationAwareOfSubstanceUseRisks]
				,cdmn.[MedEducationAwareOfEmergencySymptoms]
				,@TreatmentRecommendationsAndOrders AS TreatmentRecommendationsAndOrders
				,cdmn.[OtherInstructions]
				,CAST(NULL AS CHAR(1)) AS MoreThan50PercentTimeSpentCounseling
			FROM (
				SELECT 'CustomDocumentMedicationReviewNotes' AS TableName
				) AS Placeholder
			LEFT OUTER JOIN dbo.CustomDocumentMedicationReviewNotes AS cdmn ON cdmn.DocumentVersionId = @LatestDocumentVersionID
		ELSE IF (@PreviousDocumentType = @constDocumentCodePsychEval)
			--OR (@PreviousDocumentType = @constDocumentCodeDSM5Dx) -- tmu modified on 12/12/2016
			SELECT Placeholder.TableName
				,- 1 AS DocumentVersionId
				,CAST(NULL AS VARCHAR(30)) AS CreatedBy
				,CAST(NULL AS DATETIME) AS CreatedDate
				,CAST(NULL AS VARCHAR(30)) AS ModifiedBy
				,CAST(NULL AS DATETIME) AS ModifiedDate
				,CAST(NULL AS CHAR(1)) AS RecordDeleted
				,CAST(NULL AS VARCHAR(30)) AS DeletedBy
				,CAST(NULL AS DATETIME) AS DeletedDate
				,@clientName AS [ClientName]
				,@clientAge AS [ClientAge]
				,@clientGender AS [ClientGender]
				,@CurrentMedications AS [CurrentMedications]
				,@PreviousTreatmentRecommendationsAndOrders AS [PreviousTreatmentRecommendationsAndOrders]
				,@PreviousChangesSinceLastVisit AS [PreviousChangesSinceLastVisit]
				,CAST(NULL AS VARCHAR(max)) AS [ChangesSinceLastVisit]
				,CAST(NULL AS VARCHAR(max)) AS [MedicationsPrescribed]
				,CAST(NULL AS CHAR(1)) AS MedEducationSideEffectsDiscussed
				,CAST(NULL AS CHAR(1)) AS MedEducationAlternativesReviewed
				,CAST(NULL AS CHAR(1)) AS MedEducationAgreedRegimen
				,CAST(NULL AS CHAR(1)) AS MedEducationAwareOfSubstanceUseRisks
				,CAST(NULL AS CHAR(1)) AS MedEducationAwareOfEmergencySymptoms
				,@TreatmentRecommendationsAndOrders AS TreatmentRecommendationsAndOrders
				,CAST(NULL AS VARCHAR(max)) AS OtherInstructions
				,CAST(NULL AS CHAR(1)) AS MoreThan50PercentTimeSpentCounseling
			FROM (
				SELECT 'CustomDocumentMedicationReviewNotes' AS TableName
				) AS Placeholder

		SELECT @LatestDxVersionId = d.CurrentDocumentVersionId
		FROM dbo.Documents AS d
		WHERE d.ClientId = @ClientId
			AND d.DocumentCodeId = 5
			AND d.STATUS = 22
			AND ISNULL(d.RecordDeleted, 'N') <> 'Y'
			AND NOT EXISTS (
				SELECT *
				FROM dbo.Documents AS d2
				WHERE d2.ClientId = d.ClientId
					AND d2.DocumentCodeId = d.DocumentCodeId
					AND d2.STATUS = d.STATUS
					AND (
						(d2.EffectiveDate > d.EffectiveDate)
						OR (
							d2.EffectiveDate = d.EffectiveDate
							AND d2.DocumentId > d.DocumentId
							)
						)
					AND ISNULL(d2.RecordDeleted, 'N') <> 'Y'
				)

		-- Mental Status --
		SELECT Placeholder.TableName
			,ISNULL(CDMS.DocumentVersionId, - 1) AS DocumentVersionId
			,CDMS.CreatedBy
			,CDMS.CreatedDate
			,CDMS.ModifiedBy
			,CDMS.ModifiedDate
			,CDMS.RecordDeleted
			,CDMS.DeletedBy
			,CDMS.DeletedDate
			,CDMS.ConsciousnessNA
			,CDMS.ConsciousnessAlert
			,CDMS.ConsciousnessObtunded
			,CDMS.ConsciousnessSomnolent
			,CDMS.ConsciousnessOrientedX3
			,CDMS.ConsciousnessAppearsUnderInfluence
			,CDMS.ConsciousnessComment
			,CDMS.EyeContactNA
			,CDMS.EyeContactAppropriate
			,CDMS.EyeContactStaring
			,CDMS.EyeContactAvoidant
			,CDMS.EyeContactComment
			,CDMS.AppearanceNA
			,CDMS.AppearanceClean
			,CDMS.AppearanceNeatlyDressed
			,CDMS.AppearanceAppropriate
			,CDMS.AppearanceDisheveled
			,CDMS.AppearanceMalodorous
			,CDMS.AppearanceUnusual
			,CDMS.AppearancePoorlyGroomed
			,CDMS.AppearanceComment
			,CDMS.AgeNA
			,CDMS.AgeAppropriate
			,CDMS.AgeOlder
			,CDMS.AgeYounger
			,CDMS.AgeComment
			,CDMS.BehaviorNA
			,CDMS.BehaviorPleasant
			,CDMS.BehaviorGuarded
			,CDMS.BehaviorAgitated
			,CDMS.BehaviorImpulsive
			,CDMS.BehaviorWithdrawn
			,CDMS.BehaviorUncooperative
			,CDMS.BehaviorAggressive
			,CDMS.BehaviorComment
			,CDMS.PsychomotorNA
			,CDMS.PsychomotorNoAbnormalMovements
			,CDMS.PsychomotorAgitation
			,CDMS.PsychomotorAbnormalMovements
			,CDMS.PsychomotorRetardation
			,CDMS.PsychomotorComment
			,CDMS.MoodNA
			,CDMS.MoodEuthymic
			,CDMS.MoodDysphoric
			,CDMS.MoodIrritable
			,CDMS.MoodDepressed
			,CDMS.MoodExpansive
			,CDMS.MoodAnxious
			,CDMS.MoodElevated
			,CDMS.MoodComment
			,CDMS.ThoughtContentNA
			,CDMS.ThoughtContentWithinLimits
			,CDMS.ThoughtContentExcessiveWorries
			,CDMS.ThoughtContentOvervaluedIdeas
			,CDMS.ThoughtContentRuminations
			,CDMS.ThoughtContentPhobias
			,CDMS.ThoughtContentComment
			,CDMS.DelusionsNA
			,CDMS.DelusionsNone
			,CDMS.DelusionsBizarre
			,CDMS.DelusionsReligious
			,CDMS.DelusionsGrandiose
			,CDMS.DelusionsParanoid
			,CDMS.DelusionsComment
			,CDMS.ThoughtProcessNA
			,CDMS.ThoughtProcessLogical
			,CDMS.ThoughtProcessCircumferential
			,CDMS.ThoughtProcessFlightIdeas
			,CDMS.ThoughtProcessIllogical
			,CDMS.ThoughtProcessDerailment
			,CDMS.ThoughtProcessTangential
			,CDMS.ThoughtProcessSomatic
			,CDMS.ThoughtProcessCircumstantial
			,CDMS.ThoughtProcessComment
			,CDMS.HallucinationsNA
			,CDMS.HallucinationsNone
			,CDMS.HallucinationsAuditory
			,CDMS.HallucinationsVisual
			,CDMS.HallucinationsTactile
			,CDMS.HallucinationsOlfactory
			,CDMS.HallucinationsComment
			,CDMS.IntellectNA
			,CDMS.IntellectAverage
			,CDMS.IntellectAboveAverage
			,CDMS.IntellectBelowAverage
			,CDMS.IntellectComment
			,CDMS.SpeechNA
			,CDMS.SpeechRate
			,CDMS.SpeechTone
			,CDMS.SpeechVolume
			,CDMS.SpeechArticulation
			,CDMS.SpeechComment
			,CDMS.AffectNA
			,CDMS.AffectCongruent
			,CDMS.AffectReactive
			,CDMS.AffectIncongruent
			,CDMS.AffectLabile
			,CDMS.AffectComment
			,CDMS.RangeNA
			,CDMS.RangeBroad
			,CDMS.RangeBlunted
			,CDMS.RangeFlat
			,CDMS.RangeFull
			,CDMS.RangeConstricted
			,CDMS.RangeComment
			,CDMS.InsightNA
			,CDMS.InsightExcellent
			,CDMS.InsightGood
			,CDMS.InsightFair
			,CDMS.InsightPoor
			,CDMS.InsightImpaired
			,CDMS.InsightUnknown
			,CDMS.InsightComment
			,CDMS.JudgmentNA
			,CDMS.JudgmentExcellent
			,CDMS.JudgmentGood
			,CDMS.JudgmentFair
			,CDMS.JudgmentPoor
			,CDMS.JudgmentImpaired
			,CDMS.JudgmentUnknown
			,CDMS.JudgmentComment
			,CDMS.MemoryNA
			,CDMS.MemoryShortTerm
			,CDMS.MemoryLongTerm
			,CDMS.MemoryAttention
			,CDMS.MemoryComment
			,CDMS.BodyHabitusNA
			,CDMS.BodyHabitusAverage
			,CDMS.BodyHabitusThin
			,CDMS.BodyHabitusUnderweight
			,CDMS.BodyHabitusOverweight
			,CDMS.BodyHabitusObese
			,CDMS.BodyHabitusComment
		FROM (
			SELECT 'CustomDocumentMentalStatuses' AS TableName
			) AS Placeholder
		LEFT JOIN CustomDocumentMentalStatuses CDMS ON (
				CDMS.DocumentVersionId = @LatestDocumentVersionID
				AND ISNULL(CDMS.RecordDeleted, 'N') <> 'Y'
				)

		-- tmu modified on 12/12/2016
		EXEC csp_InitCustomDiagnosisMedicationReviewNote @ClientID
			,@StaffID
			,@CustomParameters
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_InitCustomDocumentMedicationReviewNotesInitialization') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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
