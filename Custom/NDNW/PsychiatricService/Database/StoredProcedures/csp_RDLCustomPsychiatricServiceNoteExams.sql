IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomPsychiatricServiceNoteExams]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomPsychiatricServiceNoteExams]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[csp_RDLCustomPsychiatricServiceNoteExams] 
(@DocumentVersionId INT=0)
/*************************************************
  Date:			Author:       Description:                            
  
  -------------------------------------------------------------------------            
 02-Jan-2015    Revathi      What: Get Psychiatric Service Note Exams information
                             Why:task #823 Woods-Customizations 
************************************************/
  AS 
 BEGIN
				
	BEGIN TRY
	
declare @EffectiveDate datetime
declare @currentvitalDate datetime
declare @previousvitalDate datetime
declare @Currentvitals varchar(max)
declare @Prevoiusvitals varchar(max)
declare @ClinetId int 

	SELECT TOP 1 @EffectiveDate = EffectiveDate	,
			@ClinetId=ClientId	
			FROM Documents
			WHERE InProgressDocumentVersionId = @DocumentVersionId 
			AND ISNULL(RecordDeleted,'N')='N'
			
		SELECT @currentvitalDate = Max(CH.healthrecorddate)
			FROM ClientHealthDataAttributes CH
			INNER JOIN HealthDataSubtemplateAttributes HDA ON CH.HealthDataAttributeId = HDA.HealthDataAttributeId
			INNER JOIN HealthDataTemplateAttributes HDT ON HDT.HealthDataSubTemplateId = HDA.HealthDataSubTemplateId
			WHERE ClientId = @ClinetId
				AND CAST(CH.healthrecorddate AS DATE) <= CAST(@EffectiveDate AS DATE)
				AND HDT.HealthDataTemplateId in (Select IntegerCodeId from  dbo.ssf_RecodeValuesCurrent('MEANINGFULUSEVITALS'))
				AND ISNULL(CH.RecordDeleted,'N')='N'	
					
		SELECT @previousvitalDate = Max(CH.healthrecorddate)
			FROM ClientHealthDataAttributes CH
			INNER JOIN HealthDataSubtemplateAttributes HDA ON CH.HealthDataAttributeId = HDA.HealthDataAttributeId
			INNER JOIN HealthDataTemplateAttributes HDT ON HDT.HealthDataSubTemplateId = HDA.HealthDataSubTemplateId
			WHERE ClientId = @ClinetId
				AND CAST(CH.healthrecorddate AS DATE) < CAST(@currentvitalDate AS DATE)
				AND HDT.HealthDataTemplateId in (Select IntegerCodeId from  dbo.ssf_RecodeValuesCurrent('MEANINGFULUSEVITALS'))
				AND ISNULL(CH.RecordDeleted,'N')='N'
				print @currentvitalDate
				
				CREATE TABLE #TempVitals (	
				vital varchar(max)
				,HealthRecordDate DATETIME
				,ClientHealthdataAttributeId INT
				,OrderInFlowSheet INT
				,EntryDisplayOrder INT
				,Row int				
				)	
				
		insert into #TempVitals		
				SELECT DISTINCT 
				a.NAME + '-' + (CASE   
				WHEN datatype = 8081  
				THEN dbo.Getglobalcodename(chd.value)  
				ELSE value  
				END)				
				,chd.HealthRecordDate
				,chd.ClientHealthDataAttributeId
				,st.OrderInFlowSheet
				,ta.EntryDisplayOrder	
				,Row_number() over(PARTITION BY chd.HealthdataAttributeId ORDER BY chd.healthRecordDate DESC) row	
			FROM HealthDataTemplateAttributes ta
			INNER JOIN HealthDataSubtemplateAttributes st ON ta.HealthdataSubtemplateId = st.HealthdataSubtemplateId
			INNER JOIN HealthDataSubtemplates s ON ta.HealthdataSubtemplateId = s.HealthdataSubtemplateId
			INNER JOIN HealthDataAttributes a ON a.HealthDataAttributeId = st.HealthDataAttributeId
			INNER JOIN ClientHealthDataAttributes chd ON chd.HealthdataAttributeid = st.HealthdataAttributeid		
			WHERE ta.HealthDataTemplateId in (Select IntegerCodeId from  dbo.ssf_RecodeValuesCurrent('MEANINGFULUSEVITALS'))			
				AND a.HealthDataAttributeId NOT In  (Select IntegerCodeId from  dbo.ssf_RecodeValuesCurrent('SMOKINGSTATUS'))				
				AND ISNULL(ta.recorddeleted, 'N') <> 'Y'
				AND chd.ClientId = @ClinetId
				AND chd.HealthRecordDate in (@currentvitalDate,@previousvitalDate)			
				AND ISNULL(st.recorddeleted, 'N') <> 'Y'
				AND ISNULL(s.recorddeleted, 'N') <> 'Y'
				AND ISNULL(a.recorddeleted, 'N') <> 'Y'
				AND ISNULL(chd.recorddeleted, 'N') <> 'Y'
				
				SELECT @Currentvitals = COALESCE(@Currentvitals + ',#', '') + vital FROM #TempVitals 
							WHERE row=1						
							ORDER BY EntryDisplayOrder ASC,	OrderInFlowSheet ASC
							
				SELECT @Prevoiusvitals = COALESCE(@Prevoiusvitals + ',#', '') + vital FROM #TempVitals 
							WHERE row=2						
							ORDER BY EntryDisplayOrder ASC,	OrderInFlowSheet ASC
										
		
						
						 
	   	SELECT 
	   ('Current Vitals'+CONVERT(varchar,@currentvitalDate,101)) as CurrentvitalDate
	   	,('Previous Vitals'+CONVERT(varchar,@previousvitalDate,101)) as PreviousvitalDate
	   	,@Currentvitals as  Currentvitals
		,@Prevoiusvitals as Prevoiusvitals
	   	,ISNULL(CE.AppropriatelyDressed,'N') as AppropriatelyDressed,
	   	ISNULL(CE.GeneralAppearanceUnkept,'N') as GeneralAppearanceUnkept,
	   	ISNULL(CE.GeneralAppearanceOther,'N') as GeneralAppearanceOther,
	   	CE.GeneralAppearanceOtherText,
		ISNULL(CE.MuscleStrengthNormal, 'N') as MuscleStrengthNormal,
		ISNULL(CE.MuscleStrengthAbnormal, 'N') as MuscleStrengthAbnormal,
		ISNULL(CE.MusculoskeletalTone, 'N') as MusculoskeletalTone,
		ISNULL(CE.GaitNormal, 'N') as GaitNormal,
		ISNULL(CE.GaitAbnormal, 'N') as GaitAbnormal,
		ISNULL(CE.TicsTremorsAbnormalMovements, 'N') as TicsTremorsAbnormalMovements,
		ISNULL(CE.EPS, 'N') as EPS,
		ISNULL(CE.AppearanceBehavior, 'N') as AppearanceBehavior,
		AppearanceBehaviorComments,
		ISNULL(CE.AbnormalPsychoticThoughts, 'N') as AbnormalPsychoticThoughts,
		CE.AbnormalPsychoticThoughtsComments,
		ISNULL(CE.Speech, 'N') as Speech,
		CE.SpeechComments,
		ISNULL(CE.ThoughtProcess, 'N') as ThoughtProcess,
		CE.ThoughtProcessComments,
		ISNULL(CE.Associations, 'N') as Associations,
		CE.AssociationsComments,		
		ISNULL(CE.JudgmentAndInsight, 'N') as JudgmentAndInsight,
		CE.JudgmentAndInsightComments,
		ISNULL(CE.Orientation, 'N') as Orientation,
		CE.OrientationComments,
		ISNULL(CE.RecentRemoteMemory,'N') as RecentRemoteMemory,
		CE.RecentRemoteMemoryComments,
		ISNULL(CE.AttentionConcentration,'N') as AttentionConcentration,
		CE.AttentionConcentrationComments,
		ISNULL(CE.[Language],'N') as [Language],
		CE.LanguageCommments,
		ISNULL(CE.FundOfKnowledge,'N') as FundOfKnowledge,
		CE.FundOfKnowledgeComments,
		ISNULL(CE.MoodAndAffect,'N') as MoodAndAffect,
		CE.MoodAndAffectComments		
	   	FROM CustomDocumentPsychiatricServiceNoteExams CE  
	   	WHERE  CE.DocumentVersionId=@DocumentVersionId
	   	AND ISNULL(CE.RecordDeleted,'N')='N'
	   	End Try
 
  BEGIN CATCH          
   DECLARE @Error varchar(8000)                                                 
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                        
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RDLCustomPsychiatricServiceNoteExams')                                                                               
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                
   + '*****' + Convert(varchar,ERROR_STATE())                                           
   RAISERROR ( @Error, /* Message text.*/16, /* Severity.*/ 1 /*State.*/ );             
 END CATCH          
END
	   	