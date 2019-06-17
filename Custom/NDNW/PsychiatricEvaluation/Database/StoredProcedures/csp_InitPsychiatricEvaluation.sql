/****** Object:  StoredProcedure [dbo].[csp_InitPsychiatricEvaluation]    Script Date: 06/30/2014 18:06:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitPsychiatricEvaluation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitPsychiatricEvaluation]
GO

/****** Object:  StoredProcedure [dbo].[csp_InitPsychiatricEvaluation]    Script Date: 06/30/2014 18:06:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_InitPsychiatricEvaluation] (
	@ClientID INT
	,@StaffID INT
	,@CustomParameters XML
	)
AS
-- =============================================    
-- Author      : Akwinass.D 
-- Date        : 06/JAN/2015  
-- Purpose     : Initializing SP Created. 
-- =============================================   
BEGIN
	BEGIN TRY
	DECLARE @LatestDocumentVersionID INT
	DECLARE @EffectiveDate DATETIME	
	DECLARE @Months DECIMAL(10,5)
	
	SELECT TOP 1 @LatestDocumentVersionID = CurrentDocumentVersionId, @EffectiveDate = EffectiveDate
	FROM CustomDocumentPsychiatricEvaluations CDPE
	INNER JOIN Documents Doc ON CDPE.DocumentVersionId = Doc.CurrentDocumentVersionId
	WHERE Doc.ClientId = @ClientID
		AND Doc.[Status] = 22
		AND ISNULL(CDPE.RecordDeleted, 'N') = 'N'
		AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
	ORDER BY Doc.EffectiveDate DESC
		,Doc.ModifiedDate DESC
			
	SELECT 'CustomDocumentPsychiatricEvaluations' AS TableName
		,- 1 AS DocumentVersionId
		,'' AS CreatedBy
		,GETDATE() AS CreatedDate
		,'' AS ModifiedBy
		,GETDATE() AS ModifiedDate
		,CDPE.IdentifyingInformation
		,CDPE.FamilyHistory
		,CDPE.PastPsychiatricHistory
		,CDPE.DevelopmentalHistory
		,CDPE.SubstanceAbuseHistory
		,CDPE.MedicalHistory
		,CDPE.HistoryofPresentIllness
		,CDPE.SocialHistory
		,CDPE.AppropriatelyDressed
		,CDPE.GeneralAppearanceUnkept
		,CDPE.GeneralAppearanceOther
		,CDPE.GeneralAppearanceOtherText
		,CDPE.MuscleStrengthNormal
		,CDPE.MuscleStrengthAbnormal
		,CDPE.MusculoskeletalTone
		,CDPE.GaitNormal
		,CDPE.GaitAbnormal
		,CDPE.TicsTremorsAbnormalMovements
		,CDPE.EPS
		,CDPE.AppearanceBehaviorComments
		,CDPE.SpeechComments
		,CDPE.ThoughtProcessComments
		,CDPE.AssociationsComments
		,CDPE.AbnormalPsychoticThoughtsComments
		,CDPE.JudgmentAndInsightComments
		,CDPE.OrientationComments
		,CDPE.RecentRemoteMemoryComments
		,CDPE.AttentionConcentrationComments
		,CDPE.LanguageCommments
		,CDPE.FundOfKnowledgeComments
		,CDPE.MoodAndAffectComments
	FROM systemconfigurations s
	LEFT OUTER JOIN CustomDocumentPsychiatricEvaluations CDPE ON CDPE.DocumentVersionId = @LatestDocumentVersionID
	
	SELECT 'CustomPsychiatricEvaluationProblems' AS TableName
			,- 1 AS DocumentVersionId
			,'' AS CreatedBy
			,GETDATE() AS CreatedDate
			,'' AS ModifiedBy
			,GETDATE() AS ModifiedDate	
			,ProblemText
			,Severity
			,Duration
			,Intensity
			,TimeOfDayMorning
			,TimeOfDayNoon
			,TimeOfDayAfternoon
			,TimeOfDayEvening
			,TimeOfDayNight
			,ContextHome
			,ContextSchool
			,ContextWork
			,ContextCommunity
			,ContextOther
			,ContextOtherText
			,AssociatedSignsSymptoms
			,AssociatedSignsSymptomsOtherText
			,ModifyingFactors
			,ReasonResolved
	FROM systemconfigurations s
	LEFT OUTER JOIN CustomPsychiatricEvaluationProblems CDS ON CDS.DocumentVersionId = @LatestDocumentVersionID
	
	EXEC ssp_InitCustomDiagnosisStandardInitializationNew @ClientID, @StaffID, @CustomParameters 
 
 	-----NoteEMCodeOptions
	SELECT TOP 1 'NoteEMCodeOptions' AS TableName
		,- 1 AS 'DocumentVersionId'
		,'' AS CreatedBy
		,getdate() AS CreatedDate
		,'' AS ModifiedBy
		,getdate() AS ModifiedDate
	FROM systemconfigurations s
	LEFT JOIN NoteEMCodeOptions ON s.Databaseversion = - 1 
	END TRY

	BEGIN CATCH
	END CATCH

END

GO


