IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'csp_RDLPsychiatricEvaluation')
BEGIN
	DROP PROCEDURE csp_RDLPsychiatricEvaluation
END
GO

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[csp_RDLPsychiatricEvaluation] (@DocumentVersionId INT = 0)
	/*************************************************
  Date:			Author:       Description:                            
  
  -------------------------------------------------------------------------            
 09-JAN-2015    Akwinass      What:Get Psychiatric Evaluation Service Note Informations
                              Why:task #822 Woods-Customizations
16-DEC-2016		RQuigley	  Fix Column lengths to match source table NDNW Support #526
************************************************/
AS
BEGIN
	BEGIN TRY
		DECLARE @AgeOut VARCHAR(10)
		DECLARE @ProgramName VARCHAR(250)
		DECLARE @PrimaryEpisodeWorker VARCHAR(250)
		DECLARE @ClientName VARCHAR(100)
		DECLARE @ClinicianName VARCHAR(100)
		DECLARE @ClientID INT
		DECLARE @EffectiveDate VARCHAR(10)
		DECLARE @DOB VARCHAR(10)
		DECLARE @DocumentName VARCHAR(100)
		DECLARE @ServiceId INT
		DECLARE @AutherId INT

		SELECT TOP 1 @ClientId = C.ClientId
			,@ClientName = C.LastName + ', ' + C.FirstName
			,@EffectiveDate = CONVERT(VARCHAR(10), Dv.EffectiveDate, 101)
			,@DOB = CONVERT(VARCHAR(10), C.DOB, 101)
			,@ProgramName = P.ProgramName
			,@DocumentName = DC.DocumentName
			,@PrimaryEpisodeWorker = ISNULL(St.LastName, '') + coalesce(', ' + St.firstname, '')
			,@ServiceId = S.ServiceId
			,@AutherId = Dv.AuthorId
		FROM CustomDocumentPsychiatricEvaluations CD
		INNER JOIN Documents Dv ON Dv.CurrentDocumentVersionId = CD.DocumentVersionId
		INNER JOIN Clients C ON C.ClientId = Dv.ClientId
		INNER JOIN Services S ON S.ServiceId = DV.ServiceId
		INNER JOIN Programs P ON P.ProgramId = S.ProgramId
		INNER JOIN DocumentCodes DC ON DC.DocumentCodeid = Dv.DocumentCodeId
		LEFT JOIN Staff st ON C.PrimaryClinicianId = st.StaffId
		WHERE ISNULL(CD.RecordDeleted, 'N') = 'N'
			AND ISNULL(Dv.RecordDeleted, 'N') = 'N'
			AND ISNULL(C.RecordDeleted, 'N') = 'N'
			AND CD.DocumentVersionId = @DocumentVersionId

		EXEC csp_CalculateAge @ClientId
			,@AgeOut out
			
		DECLARE @IntegerCodeId INT

		SET @IntegerCodeId = (
				SELECT integercodeid
				FROM dbo.Ssf_recodevaluescurrent('XPSYCHIATRICEVALUATIONVITAL')
				)

		CREATE TABLE #tempvitals (
			rowid INT PRIMARY KEY IDENTITY(1, 1)
			,healthdatatemplateid INT
			,healthdatasubtemplateid INT
			,healthdataattributeid INT
			,subtemplatename VARCHAR(200)
			,attributename VARCHAR(200)
			,value VARCHAR(200)
			,healthrecorddate DATETIME
			,clienthealthdataattributeid INT
			,datatype INT
			)

		INSERT INTO #tempvitals
		SELECT ta.healthdatatemplateid
			,ta.healthdatasubtemplateid
			,st.healthdataattributeid
			,s.NAME
			,a.NAME
			,chd.value
			,chd.healthrecorddate
			,chd.clienthealthdataattributeid
			,a.datatype
		FROM healthdatatemplateattributes ta
		INNER JOIN healthdatasubtemplateattributes st ON ta.healthdatasubtemplateid = st.healthdatasubtemplateid
		INNER JOIN healthdatasubtemplates s ON ta.healthdatasubtemplateid = s.healthdatasubtemplateid
		INNER JOIN healthdataattributes a ON a.healthdataattributeid = st.healthdataattributeid
		INNER JOIN clienthealthdataattributes chd ON chd.healthdataattributeid = st.healthdataattributeid
		WHERE ta.healthdatatemplateid = @IntegerCodeId
			AND Isnull(ta.recorddeleted, 'N') <> 'Y'
			AND chd.clientid = @ClientID
			AND chd.healthrecorddate = (
				SELECT Max(healthrecorddate)
				FROM clienthealthdataattributes
				WHERE clientid = @ClientID
				)
			AND Isnull(st.recorddeleted, 'N') <> 'Y'
			AND Isnull(s.recorddeleted, 'N') <> 'Y'
			AND Isnull(a.recorddeleted, 'N') <> 'Y'
			AND Isnull(chd.recorddeleted, 'N') <> 'Y'

		DECLARE @Currentvitals VARCHAR(max)
		DECLARE @CurrentVitalDate AS DATETIME
		DECLARE @CurrentLatestHealthRecordFormated VARCHAR(max)

		SET @CurrentVitalDate = (
				SELECT Max(healthrecorddate)
				FROM clienthealthdataattributes
				WHERE clientid = @ClientID
				)
		SET @Currentvitals = ''
		SET @CurrentLatestHealthRecordFormated = ''

		SELECT @Currentvitals = @Currentvitals + ' ' + attributename + ': ' + Isnull(CASE 
					WHEN datatype = 8081
						THEN dbo.Getglobalcodename(value)
					ELSE value
					END, '') + '#'
		FROM #tempvitals
		ORDER BY attributename

		SET @CurrentLatestHealthRecordFormated = (
				SELECT CONVERT(VARCHAR, @CurrentVitalDate, 101)
				)

		IF NOT (
				--NULLIF(@CurrentLatestHealthRecordFormated, '') IS NULL  
				--AND   
				NULLIF(@Currentvitals, '') IS NULL
				)
		BEGIN
			SET @Currentvitals = @Currentvitals
		END
		ELSE
		BEGIN
			SET @Currentvitals = ''
		END

		--SELECT  LEFT(@Currentvitals,LEN(@Currentvitals)-1) AS Value   
		DECLARE @CountofPrevious AS INT
		DECLARE @SecondLatestHealthRecord AS DATETIME
		DECLARE @PreviousVitalsWithDate VARCHAR(max)

		SET @PreviousVitalsWithDate = ''

		DECLARE @SecondLatestHealthRecordFormated VARCHAR(max)

		SET @SecondLatestHealthRecordFormated = ''

		DECLARE @PreviousVitals VARCHAR(max)

		SET @PreviousVitals = ''
		SET @CountofPrevious = (
				SELECT Count(DISTINCT healthrecorddate)
				FROM clienthealthdataattributes
				WHERE clientid = @ClientID
				)

		IF (@CountofPrevious > 1)
		BEGIN
			SET @SecondLatestHealthRecord = (
					SELECT DISTINCT healthrecorddate
					FROM clienthealthdataattributes
					WHERE clientid = @ClientID
						AND healthrecorddate = (
							SELECT Min(healthrecorddate)
							FROM (
								SELECT DISTINCT TOP (2) healthrecorddate
								FROM clienthealthdataattributes
								WHERE clientid = @ClientID
								ORDER BY healthrecorddate DESC
								) T
							)
					)

			DELETE
			FROM #tempvitals

			INSERT INTO #tempvitals
			SELECT ta.healthdatatemplateid
				,ta.healthdatasubtemplateid
				,st.healthdataattributeid
				,s.NAME
				,a.NAME
				,chd.value
				,chd.healthrecorddate
				,chd.clienthealthdataattributeid
				,a.datatype
			FROM healthdatatemplateattributes ta
			INNER JOIN healthdatasubtemplateattributes st ON ta.healthdatasubtemplateid = st.healthdatasubtemplateid
			INNER JOIN healthdatasubtemplates s ON ta.healthdatasubtemplateid = s.healthdatasubtemplateid
			INNER JOIN healthdataattributes a ON a.healthdataattributeid = st.healthdataattributeid
			INNER JOIN clienthealthdataattributes chd ON chd.healthdataattributeid = st.healthdataattributeid
			WHERE ta.healthdatatemplateid = @IntegerCodeId
				AND Isnull(ta.recorddeleted, 'N') <> 'Y'
				AND chd.clientid = @ClientID
				AND chd.healthrecorddate = @SecondLatestHealthRecord
				AND Isnull(st.recorddeleted, 'N') <> 'Y'
				AND Isnull(s.recorddeleted, 'N') <> 'Y'
				AND Isnull(a.recorddeleted, 'N') <> 'Y'
				AND Isnull(chd.recorddeleted, 'N') <> 'Y'

			SELECT @PreviousVitals = @PreviousVitals + ' ' + attributename + ': ' + Isnull(CASE 
						WHEN datatype = 8081
							THEN dbo.Getglobalcodename(value)
						ELSE value
						END, '') + '#'
			FROM #tempvitals
			ORDER BY attributename

			SET @SecondLatestHealthRecordFormated = (
					SELECT CONVERT(VARCHAR, @SecondLatestHealthRecord, 101)
					)
		END

		IF NOT (NULLIF(@PreviousVitals, '') IS NULL)
		BEGIN
			SET @PreviousVitalsWithDate = @PreviousVitals
		END
		ELSE
		BEGIN
			SET @PreviousVitalsWithDate = ''
		END
		
		DECLARE @NextPsychiatricAppointment VARCHAR(max)
		SELECT @NextPsychiatricAppointment = ISNULL(@NextPsychiatricAppointment,'') + (A.[Subject] +', '+(CONVERT(VARCHAR(20), A.StartTime, 101) + ' ' + RIGHT(CONVERT(VARCHAR, A.StartTime, 0), 6)) +' (' + S.LastName + ', ' + S.FirstName+')') + '$$'
		FROM Appointments A
		INNER JOIN Services SR ON SR.ServiceId = A.ServiceId
		INNER JOIN Staff S ON A.StaffId = S.StaffId
		WHERE SR.ClinicianId = @AutherId
			AND SR.ClientId = @ClientId
			AND A.StartTime > (SELECT DateOfService FROM Services WHERE ServiceId = @ServiceId)
			AND (SR.ServiceId IS NULL OR SR.[Status] IN (70,71,75))
			AND SR.ProcedureCodeId IN (SELECT ProcedureCodeId FROM ProcedureCodes WHERE AssociatedNoteId = (SELECT DocumentCodeId FROM Documents WHERE ServiceId = @ServiceId))
			AND ISNULL(A.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(S.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(SR.RecordDeleted, 'N') <> 'Y'


		SELECT @ClientID AS ClientId
			,@ClientName AS ClientName
			,@EffectiveDate AS EffectiveDate
			,@DOB AS DOB
			,CDPE.[DocumentVersionId]
			,@ProgramName AS ProgramName
			,@DocumentName AS DocumentName
			,@PrimaryEpisodeWorker AS PrimaryEpisodeWorker
			,@AgeOut AS ClientAge
			,@ServiceId AS ServiceId
			,CDPE.[CreatedBy]
			,CDPE.[CreatedDate]
			,CDPE.[ModifiedBy]
			,CDPE.[ModifiedDate]
			,CDPE.[RecordDeleted]
			,CDPE.[DeletedBy]
			,CDPE.[DeletedDate]
			,ISNULL(St1.LastName, '') + coalesce(', ' + St1.firstname, '') AS NotifyStaff1
			,ISNULL(St2.LastName, '') + coalesce(', ' + St2.firstname, '') AS NotifyStaff2
			,ISNULL(St3.LastName, '') + coalesce(', ' + St3.firstname, '') AS NotifyStaff3
			,@NextPsychiatricAppointment AS NextPsychiatricAppointment
			,CDPE.[SummaryAndRecommendations]
			,CDPE.[MedicationListAtTheTimeOfTransition]
			,CDPE.[IdentifyingInformation]
			,CDPE.[FamilyHistory]
			,CDPE.[PastPsychiatricHistory]
			,CDPE.[DevelopmentalHistory]
			,CDPE.[SubstanceAbuseHistory]
			,CDPE.[MedicalHistory]
			,CDPE.[HistoryofPresentIllness]
			,CDPE.[SocialHistory]
			,CDPE.[ReviewOfSystemPsych]
			,CDPE.[ReviewOfSystemSomaticConcerns]
			,CDPE.[ReviewOfSystemConstitutional]
			,CDPE.[ReviewOfSystemEarNoseMouthThroat]
			,CDPE.[ReviewOfSystemGI]
			,CDPE.[ReviewOfSystemGU]
			,CDPE.[ReviewOfSystemIntegumentary]
			,CDPE.[ReviewOfSystemEndo]
			,CDPE.[ReviewOfSystemNeuro]
			,CDPE.[ReviewOfSystemImmune]
			,CDPE.[ReviewOfSystemEyes]
			,CDPE.[ReviewOfSystemResp]
			,CDPE.[ReviewOfSystemCardioVascular]
			,CDPE.[ReviewOfSystemHemLymph]
			,CDPE.[ReviewOfSystemMusculo]
			,CDPE.[ReviewOfSystemAllOthersNegative]
			,CDPE.[ReviewOfSystemComments]
			,CDPE.[AppropriatelyDressed]
			,CDPE.[GeneralAppearanceUnkept]
			,CDPE.[GeneralAppearanceOther]
			,CDPE.[GeneralAppearanceOtherText]
			,CDPE.[MuscleStrengthNormal]
			,CDPE.[MuscleStrengthAbnormal]
			,CDPE.[MusculoskeletalTone]
			,CDPE.[GaitNormal]
			,CDPE.[GaitAbnormal]
			,CDPE.[TicsTremorsAbnormalMovements]
			,CDPE.[EPS]
			,case when isnull(CDPE.[Suicidal],'') = 'Y' then 'Yes' when isnull(CDPE.[Suicidal],'') = 'N' then 'No' else '' end Suicidal
			,case when isnull(CDPE.[Homicidal],'') = 'Y' then 'Yes' when isnull(CDPE.[Homicidal],'') = 'N' then 'No' else '' end Homicidal
			,CDPE.[IndicateIdeation]
			,CDPE.[AppearanceBehavior]
			,CDPE.[AppearanceBehaviorComments]
			,CDPE.[Speech]
			,CDPE.[SpeechComments]
			,CDPE.[ThoughtProcess]
			,CDPE.[ThoughtProcessComments]
			,CDPE.[Associations]
			,CDPE.[AssociationsComments]
			,CDPE.[AbnormalPsychoticThoughts]
			,CDPE.[AbnormalPsychoticThoughtsComments]
			,CDPE.[JudgmentAndInsight]
			,CDPE.[JudgmentAndInsightComments]
			,CDPE.[Orientation]
			,CDPE.[OrientationComments]
			,CDPE.[RecentRemoteMemory]
			,CDPE.[RecentRemoteMemoryComments]
			,CDPE.[AttentionConcentration]
			,CDPE.[AttentionConcentrationComments]
			,CDPE.[Language]
			,CDPE.[LanguageCommments]
			,CDPE.[FundOfKnowledge]
			,CDPE.[FundOfKnowledgeComments]
			,CDPE.[MoodAndAffect]
			,CDPE.[MoodAndAffectComments]
			,CDPE.[MedicalRecords]
			,CDPE.[DiagnosticTest]
			,CDPE.[Labs]
			,CDPE.[LabsSelected]
			,CASE WHEN O.OrderName IS NOT NULL THEN (O.OrderName + CASE WHEN CO.OrderStartDateTime IS NOT NULL THEN '(' + (CONVERT(VARCHAR(20), CO.OrderStartDateTime, 101) + ' ' + RIGHT(CONVERT(VARCHAR(20), CO.OrderStartDateTime, 0), 6)) + ')'	ELSE '' END) ELSE '' END LabsSelectedText
			,CDPE.[MedicalRecordsComments]
			,CDPE.[OrderedMedications]
			,CDPE.[RisksBenefits]
			,CDPE.[NewlyEmergentSideEffects]
			,CDPE.[LabOrder]
			,CDPE.[RadiologyOrder]
			,CDPE.[Consultations]
			,CDPE.[OrdersComments]
			,('Current Vitals '+@CurrentLatestHealthRecordFormated) AS CurrentvitalDate
	   		,('Previous Vitals '+@SecondLatestHealthRecordFormated) AS PreviousvitalDate
	   		,@Currentvitals AS  Currentvitals
			,@PreviousVitalsWithDate AS Prevoiusvitals
		FROM [CustomDocumentPsychiatricEvaluations] CDPE
		LEFT JOIN Staff st1 ON CDPE.NotifyStaff1 = st1.StaffId
		LEFT JOIN Staff st2 ON CDPE.NotifyStaff2 = st2.StaffId
		LEFT JOIN Staff st3 ON CDPE.NotifyStaff3 = st3.StaffId
		LEFT JOIN ClientOrders CO ON CDPE.LabsSelected = CO.ClientOrderId
		LEFT JOIN Orders O on CO.OrderId = O.OrderId
		WHERE CDPE.DocumentVersionId = @DocumentVersionId
			AND ISNULL(CDPE.RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLPsychiatricEvaluation') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,/* Message text.*/ 16
				,/* Severity.*/ 1 /*State.*/
				);
	END CATCH
END

GO

