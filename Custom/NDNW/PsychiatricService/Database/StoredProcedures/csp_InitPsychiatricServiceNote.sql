USE [NDNWProdSmartcare]
GO

/****** Object:  StoredProcedure [dbo].[csp_InitPsychiatricServiceNote]    Script Date: 07/09/2015 15:24:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitPsychiatricServiceNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitPsychiatricServiceNote]
GO

USE [NDNWProdSmartcare]
GO

/****** Object:  StoredProcedure [dbo].[csp_InitPsychiatricServiceNote]    Script Date: 07/09/2015 15:24:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_InitPsychiatricServiceNote] (
	@ClientID INT
	,@StaffID INT
	,@CustomParameters XML
	)
AS
/*********************************************************************/
/* Stored Procedure: [csp_InitPsychiatricServiceNote]   */
/*       Date              Author                  Purpose                   */
/*      12-18-2014     Dhanil Manuel               To Initialize          */
/*********************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @LatestDocumentVersionID INT
		declare @PrimaryEpisodeWorkerID int
		declare @PrimaryEpisodeWorker Varchar(250)  
		declare @PrimaryEpisodeWorkerAge int  
		DECLARE @AgeOut varchar(10)    
		DECLARE @index int
		SELECT @PrimaryEpisodeWorkerID = PrimaryClinicianId from Clients where                                                                                                                                                                                         
		ClientId = @ClientID and IsNull(RecordDeleted,'N')= 'N'      

		Exec csp_CalculateAge @ClientID, @AgeOut out    

		set @index=(select CHARINDEX(' ', @AgeOut ))    
		set @PrimaryEpisodeWorkerAge = substring(@AgeOut,0,@index)    


		select @PrimaryEpisodeWorker=S.lastname +', '+ S.firstname  from Staff S
		where S.StaffId=@PrimaryEpisodeWorkerID and Isnull(S.RecordDeleted,'N') ='N'
		
			SET @LatestDocumentVersionID = (
				SELECT TOP 1 CurrentDocumentVersionId
				FROM CustomDocumentPsychiatricServiceNoteGenerals CDNA
				INNER JOIN Documents Doc ON CDNA.DocumentVersionId = Doc.CurrentDocumentVersionId
				WHERE Doc.ClientId = @ClientID
					AND Doc.[Status] = 22
					AND ISNULL(CDNA.RecordDeleted, 'N') = 'N'
					AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
					and Doc.DocumentCodeId = 21300
				ORDER BY Doc.EffectiveDate DESC
					,Doc.ModifiedDate DESC
				)
		SET @LatestDocumentVersionId = ISNULL(@LatestDocumentVersionId, - 1)
		
		SELECT 'CustomDocumentPsychiatricServiceNoteGenerals' AS TableName
			,- 1 AS DocumentVersionId
			,'' AS CreatedBy
			,GETDATE() AS CreatedDate
			,'' AS ModifiedBy
			,GETDATE() AS ModifiedDate
			,cast(@PrimaryEpisodeWorker as varchar) as PrimaryEpisodeWorker
            ,cast(@AgeOut as varchar) as Age	
			
			
		FROM systemconfigurations s
		LEFT OUTER JOIN CustomDocumentPsychiatricServiceNoteGenerals CDS ON CDS.DocumentVersionId = @LatestDocumentVersionID
	
	SELECT 'CustomDocumentPsychiatricServiceNoteHistory' AS TableName
			,- 1 AS DocumentVersionId
			,'' AS CreatedBy
			,GETDATE() AS CreatedDate
			,'' AS ModifiedBy
			,GETDATE() AS ModifiedDate	
			,ChiefComplaint
			,SubjectiveAndObjective
			,AssessmentAndPlan
			,MedicalHistoryReviewedNoChanges
			,MedicalHistoryReviewedWithChanges
			,MedicalHistoryComments
			,FamilyHistoryReviewedNoChanges
			,FamilyHistoryReviewedWithChanges
			,FamilyHistoryComments
			,SocialHistoryReviewedNoChanges
			,SocialHistoryReviewedWithChanges
			,SocialHistoryComments
			,ReviewOfSystemPsych
			,ReviewOfSystemSomaticConcerns
			,ReviewOfSystemConstitutional
			,ReviewOfSystemEarNoseMouthThroat
			,ReviewOfSystemGI
			,ReviewOfSystemGU
			,ReviewOfSystemIntegumentary
			,ReviewOfSystemEndo
			,ReviewOfSystemNeuro
			,ReviewOfSystemImmune
			,ReviewOfSystemEyes
			,ReviewOfSystemResp
			,ReviewOfSystemCardioVascular
			,ReviewOfSystemHemLymph
			,ReviewOfSystemMusculo
			,ReviewOfSystemAllOthersNegative
			,ReviewOfSystemComments
			
			
		FROM systemconfigurations s
		LEFT OUTER JOIN CustomDocumentPsychiatricServiceNoteHistory CDS ON CDS.DocumentVersionId = @LatestDocumentVersionID	
	
	SELECT 'CustomPsychiatricServiceNoteProblems' AS TableName
			,- 1 AS DocumentVersionId
			,'' AS CreatedBy
			,GETDATE() AS CreatedDate
			,'' AS ModifiedBy
			,GETDATE() AS ModifiedDate	
			,ProblemText
			,Severity
			,Duration
			,Intensity
			,IntensityText
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
			,'' as ContextOtherText
			,AssociatedSignsSymptoms
			,AssociatedSignsSymptomsOtherText
			,ModifyingFactors
			
		FROM systemconfigurations s
		LEFT OUTER JOIN CustomPsychiatricServiceNoteProblems CDS ON CDS.DocumentVersionId = @LatestDocumentVersionID			
	
	SELECT 'CustomDocumentPsychiatricServiceNoteExams' AS TableName
			,- 1 AS DocumentVersionId
			,'' AS CreatedBy
			,GETDATE() AS CreatedDate
			,'' AS ModifiedBy
			,GETDATE() AS ModifiedDate
			,AppropriatelyDressed
			,GeneralAppearanceOther
			,GeneralAppearanceOtherText
			,MuscleStrengthNormal
			,MuscleStrengthAbnormal
			,MusculoskeletalTone
			,GaitNormal
			,GaitAbnormal
			,TicsTremorsAbnormalMovements
			,EPS
			,AppearanceBehaviorComments
			,SpeechComments
			,ThoughtProcessComments
			,AssociationsComments
			,AbnormalPsychoticThoughtsComments
			,JudgmentAndInsightComments
			,OrientationComments
			,RecentRemoteMemoryComments
			,AttentionConcentrationComments
			,[Language]
			,LanguageCommments
			,FundOfKnowledge
			,FundOfKnowledgeComments
			,MoodAndAffect
			,MoodAndAffectComments	
			
		FROM systemconfigurations s
		LEFT OUTER JOIN CustomDocumentPsychiatricServiceNoteExams CDS ON CDS.DocumentVersionId = @LatestDocumentVersionID		
	
	SELECT 'CustomDocumentPsychiatricServiceNoteMDMs' AS TableName
			,- 1 AS DocumentVersionId
			,'' AS CreatedBy
			,GETDATE() AS CreatedDate
			,'' AS ModifiedBy
			,GETDATE() AS ModifiedDate	
			
		FROM systemconfigurations s
		LEFT OUTER JOIN CustomDocumentPsychiatricServiceNoteMDMs CDS ON CDS.DocumentVersionId = @LatestDocumentVersionID			
		
 exec ssp_InitCustomDiagnosisStandardInitializationNew @ClientID, @StaffID, @CustomParameters 
 
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
DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_InitPsychiatricServiceNote') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


