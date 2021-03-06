/****** Object:  StoredProcedure [dbo].[csp_RDLCustomMedicationCheckup]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomMedicationCheckup]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomMedicationCheckup]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomMedicationCheckup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create PROCEDURE  [dbo].[csp_RDLCustomMedicationCheckup]  
(                                  
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010
)                                  
As                                  
                                          
Begin                                          
/************************************************************************/                                            
/* Stored Procedure: csp_RDLCustomMedicationAdministrations				*/                                   
/* Copyright: 2006 Streamline SmartCare									*/                                            
/* Creation Date:  May 21 ,2007											*/                                            
/*																		*/                                            
/* Purpose: Gets Data for CustomMedicationCheckup						*/                                           
/*																		*/                                          
/* Input Parameters: DocumentID,Version									*/                                          
/* Output Parameters:													*/                                            
/* Purpose: Use For Rdl Report											*/                                  
/* Calls:																*/                                            
/* Author: Rupali Patil													*/                                            
/************************************************************************/                         
          
SELECT	d.ClientID
		,[Diagnosis]
		,[BloodPressure]
		,[Height]
		,[Respiratory]
		,[Waist]
		,[Pulse]
		,[Weight]
		,[BloodSugar]
		,[Temperature]
		,[ChiefComplaint]
		,[PastHistory]
		,[Summary]
		,[PlanOtherText]
		,[AxisV]
		,case [MuscleNormal] 
			when ''N'' then ''Normal''
			when ''A'' then ''Abnormal''
		 end as [MuscleNormal]
		,[MuscleTics]
		,[MuscleInvoluntaryMovement]
		,[MuscleRestlessness]
		,[MuscleTremorsShaking]
		,[MuscleOther]
		,[MuscleOtherText]
		,CASE WHEN ([MuscleTics] is null
					and [MuscleInvoluntaryMovement] is null
					and [MuscleRestlessness] is null
					and [MuscleTremorsShaking] is null
					and [MuscleOther] is null
					and [MuscleOther] is null
					and isnull(convert(Varchar(2000), [MuscleOtherText]), '''') = '''') Then ''N'' ELSE ''Y''
		END AS DisplayMuscle

		,case [GaitNormal]
			when ''N'' then ''Normal''
			when ''A'' then ''Abnormal''
		 end as [GaitNormal]
		,[GaitShuffling]
		,[GaitWideBased]
		,[GaitFestinating]
		,[GaitAtaxia]
		,[GaitWeakness]
		,[GaitSteady]
		,[GaitUnsteady]
		,[GaitPropelling]
		,[GaitOther]
		,[GaitOtherText]
		,CASE WHEN ([GaitShuffling] is null
					and [GaitWideBased] is null
					and [GaitFestinating] is null
					and [GaitAtaxia] is null
					and [GaitWeakness] is null
					and [GaitSteady] is null
					and [GaitUnsteady] is null
					and [GaitPropelling] is null
					and [GaitOther] is null
					and isnull(convert(Varchar(2000), [GaitOtherText]), '''') = '''') Then ''N'' ELSE ''Y''
		END AS DisplayGait

		,case [SpeechNormal]
			when ''N'' then ''Normal''
			when ''A'' then ''Abnormal''
		 end as [SpeechNormal]
		,[SpeechSlurred]
		,[SpeechIncomprehensible]
		,[SpeechNonVerbal]
		,[SpeechDisorganized]
		,[SpeechPressured]
		,[SpeechAphasic]
		,[SpeechOther]
		,[SpeechOtherText]
		,CASE WHEN ([SpeechSlurred] is null
					and [SpeechIncomprehensible] is null
					and [SpeechNonVerbal] is null
					and [SpeechDisorganized] is null
					and [SpeechPressured] is null
					and [SpeechAphasic] is null
					and [SpeechOther] is null
					and isnull(convert(Varchar(2000), [SpeechOtherText]), '''') = '''') Then ''N'' ELSE ''Y''
		END AS DisplaySpeech

		,case [PainNormal]
			when ''N'' then ''Normal''
			when ''A'' then ''Abnormal''
		 end as [PainNormal]
		,[PainAching]
		,[PainStabbing]
		,[PainOther]
		,[PainOtherText]
		,CASE WHEN ([PainAching] is null
					and [PainStabbing] is null
					and [PainOther] is null
					and isnull(convert(Varchar(2000), [PainOtherText]), '''') = '''') Then ''N'' ELSE ''Y''
		END AS DisplayPain

		,case [ThoughtProcessNormal]
			when ''N'' then ''Normal''
			when ''A'' then ''Abnormal''
		 end as [ThoughtProcessNormal]
		,[ThoughtProcessTangential]
		,[ThoughtProcessCircumstantial]
		,[ThoughtProcessRacing]
		,[ThoughtProcessOther]
		,[ThoughtProcessOtherText]
		,CASE WHEN ([ThoughtProcessTangential] is null
					and [ThoughtProcessCircumstantial] is null
					and [ThoughtProcessRacing] is null
					and [ThoughtProcessOther] is null					
					and isnull(convert(Varchar(2000), [ThoughtProcessOtherText]), '''') = '''') Then ''N'' ELSE ''Y''
		END AS DisplayThoughtProcess

		,case [AssociationsNormal]
			when ''N'' then ''Normal''
			when ''A'' then ''Abnormal''
		 end as [AssociationsNormal]
		,[AssociationsLoose]
		,[AssociationsFlight]
		,[AssociationsOther]
		,[AssociationsOtherText]
		,CASE WHEN ([AssociationsLoose] is null
					and [AssociationsFlight] is null
					and [AssociationsOther] is null					
					and isnull(convert(Varchar(2000), [AssociationsOtherText]), '''') = '''') Then ''N'' ELSE ''Y''
		END AS DisplayAssociations

		,case [JudgementNormal]
			when ''N'' then ''Normal''
			when ''A'' then ''Abnormal''
		 end as [JudgementNormal]
		,[JudgementPoor]
		,[JudgementFair]
		,[JudgementGrosslyImpaired]
		,[JudgementDifficultyProblemSolving]
		,[JudgementDifficultyConsequenceActions]
		,[JudgementIncreasedRisk]
		,[JudgementOther]
		,[JudgementOtherText]
		,CASE WHEN ([JudgementPoor] is null
					and [JudgementFair] is null
					and [JudgementGrosslyImpaired] is null					
					and [JudgementDifficultyProblemSolving] is null					
					and [JudgementDifficultyConsequenceActions] is null					
					and [JudgementIncreasedRisk] is null
					and [JudgementOther] is null					
					and isnull(convert(Varchar(2000), [JudgementOtherText]), '''') = '''') Then ''N'' ELSE ''Y''
		END AS DisplayJudgement

		,case [AbnormalThoughts]
			when ''Y'' then ''Yes''
			when ''N'' then ''No''
		 end as [AbnormalThoughts]
		,[AbnormalThoughtsDelusional]
		,[AbnormalThoughtsImpoverished]
		,[AbnormalThoughtsBizarre]
		,[AbnormalThoughtsVisual]
		,[AbnormalThoughtsAuditory]
		,[AbnormalThoughtsGrandiosity]
		,[AbnormalThoughtsOthers]
		,[AbnormalThoughtsOtherText]
		,CASE WHEN [AbnormalThoughts] = ''N'' Then ''N'' ELSE ''Y''
		END AS DisplayAbnormalThoughts

		,case [OrientationNormal]
			when ''N'' then ''Normal''
			when ''A'' then ''Abnormal''
		 end as [OrientationNormal]
		,[OrientationPerson]
		,[OrientationPlace]
		,[OrientationTime]
		,[OrientationPurposeOtherText]
		,CASE WHEN ([OrientationPerson] is null
					and [OrientationPlace] is null
					and [OrientationTime] is null								
					and isnull(convert(Varchar(2000), [OrientationPurposeOtherText]), '''') = '''') Then ''N'' ELSE ''Y''
		END AS DisplayOrientation

		,case [FundOfKnowledgeNormal]
			when ''N'' then ''Normal''
			when ''A'' then ''Abnormal''
		 end as [FundOfKnowledgeNormal]
		,[FundOfKnowledgeText]
		,CASE WHEN [FundOfKnowledgeNormal] = ''A'' THEN ''Y'' Else ''N''
		END AS DisplayFundOfKnowledge

		,case [RRMemoryNormal]
			when ''N'' then ''Normal''
			when ''A'' then ''Abnormal''
		 end as [RRMemoryNormal]
		,[RRMemoryShortTerm]
		,[RRMemoryAbstracting]
		,[RRMemorySequencing]
		,[RRMemoryOrganizing]
		,[RRMemoryLongTerm]
		,[RRMemoryPlanning]
		,[RRMemoryThinking]
		,[RRMemoryOther]
		,[RRMemoryOtherText]
		,CASE WHEN ([RRMemoryShortTerm] is null
					and [RRMemoryAbstracting] is null
					and [RRMemorySequencing] is null								
					and [RRMemoryOrganizing] is null								
					and [RRMemoryLongTerm] is null								
					and [RRMemoryPlanning] is null								
					and [RRMemoryThinking] is null			
					and [RRMemoryOther] is null
					and isnull(convert(Varchar(2000), [RRMemoryOtherText]), '''') = '''') Then ''N'' ELSE ''Y''
		END AS DisplayRRMemory

		,case [AttentionNormal]
			when ''N'' then ''Normal''
			when ''A'' then ''Abnormal''
		 end as [AttentionNormal]
		,[AttentionFollowsDirections]
		,[AttentionDistracted]
		,[AttentionImpulsive]
		,[AttentionPoorImpulseControl]
		,[AttentionOther]
		,[AttentionOtherText]
		,CASE WHEN ([AttentionFollowsDirections] is null
					and [AttentionDistracted] is null
					and [AttentionImpulsive] is null								
					and [AttentionPoorImpulseControl] is null								
					and [AttentionOther] is null								
					and isnull(convert(Varchar(2000), [AttentionOtherText]), '''') = '''') Then ''N'' ELSE ''Y''
		END AS DisplayAttention

		,case [LanguageNormal]
			when ''N'' then ''Normal''
			when ''A'' then ''Abnormal''
		 end as [LanguageNormal]
		,[LanguageRepetitive]
		,[LanguageInappropriate]
		,[LanguageOther]
		,[LanguageOtherText]
		,CASE WHEN ([LanguageRepetitive] is null
					and [LanguageInappropriate] is null
					and [LanguageOther] is null								
					and isnull(convert(Varchar(2000), [LanguageOtherText]), '''') = '''') Then ''N'' ELSE ''Y''
		END AS DisplayLanguage

		,case [MoodAffectNormal]
			when ''N'' then ''Normal''
			when ''A'' then ''Abnormal''
		 end as [MoodAffectNormal]
		,[MoodAffectAppropriate]
		,[MoodAffectEuthymic]
		,[MoodAffectRestricted]
		,[MoodAffectBroad]
		,[MoodAffectAlogia]
		,[MoodAffectIrritable]
		,[MoodAffectSad]
		,[MoodAffectTearful]
		,[MoodAffectAnxious]
		,[MoodAffectCooperative]
		,[MoodAffectFlat]
		,[MoodAffectOther]
		,[MoodAffectOtherText]
		,CASE WHEN ([MoodAffectAppropriate] is null
					and [MoodAffectEuthymic] is null
					and [MoodAffectRestricted] is null								
					and [MoodAffectBroad] is null								
					and [MoodAffectAlogia] is null								
					and [MoodAffectIrritable] is null								
					and [MoodAffectSad] is null								
					and [MoodAffectTearful] is null								
					and [MoodAffectAnxious] is null								
					and [MoodAffectCooperative] is null								
					and [MoodAffectFlat] is null								
					and [MoodAffectOther] is null								
					and isnull(convert(Varchar(2000), [MoodAffectOtherText]), '''') = '''') Then ''N'' ELSE ''Y''
		END AS DisplayMoodAffect

		,case [SleepNormal]
			when ''N'' then ''Normal''
			when ''A'' then ''Abnormal''
		 end as [SleepNormal]
		,convert(varchar(10), [SleepHoursPerDay]) as [SleepHoursPerDay]
		,[SleepDifficultyMaintaining]
		,[SleepDifficultyFalling]
		,[SleepNonRestorative]
		,[SleepAbnormal]
		,[SleepNightmares]
		,[SleepOther]
		,[SleepOtherText]
		,CASE WHEN ([SleepHoursPerDay] is null
					and [SleepDifficultyMaintaining] is null
					and [SleepDifficultyFalling] is null								
					and [SleepNonRestorative] is null								
					and [SleepAbnormal] is null								
					and [SleepNightmares] is null								
					and [SleepOther] is null								
					and isnull(convert(Varchar(2000), [SleepOtherText]), '''') = '''') Then ''N'' ELSE ''Y''
		END AS DisplaySleep

		,case [AppetiteNormal]
			when ''N'' then ''Normal''
			when ''A'' then ''Abnormal''
		 end as [AppetiteNormal]
		,[AppetiteIncreased]
		,[AppetiteDecreased]
		,[AppetiteOther]
		,[AppetiteOtherText]
		,CASE WHEN ([AppetiteIncreased] is null
					and [AppetiteDecreased] is null
					and [AppetiteOther] is null								
					and isnull(convert(Varchar(2000), [AppetiteOtherText]), '''') = '''') Then ''N'' ELSE ''Y''
		END AS DisplayAppetite
		,case [AIMS]
			when ''N'' then ''No''
			when ''A'' then ''N/A''
			when ''Y'' then ''Yes''
		 end as [AIMS]
		,[AIMSText]
		,CASE WHEN ([AIMS] is null
					and isnull(convert(Varchar(2000), [AIMSText]), '''') = '''') Then ''N'' ELSE ''Y''
		END AS DisplayAIMS
		,[MedicationInformation]
		,Case [MedicationReviewGiven]
			When ''Y'' Then ''Yes''
			When ''N'' Then ''No''
			Else ''''
		 End as [MedicationReviewGiven]
		,[MedicationReviewDetail]
		,''Y'' as DisplayMedicalStatus 		

FROM Documents d
Join DocumentVersions dv on dv.DocumentId=d.DocumentId and isnull(dv.RecordDeleted,''N'')=''N''
--left join CustomMedicationCheckups CMC on d.DocumentId = CMC.DocumentId 
left join CustomMedicationCheckups CMC on dv.DocumentVersionId = CMC.DocumentVersionId   --Modified by Anuj Dated 03-May-2010
										and ISNull(CMC.RecordDeleted,''N'')=''N''    
										--and CMC.DocumentId=d.DocumentId 
										--and CMC.Version=@Version 
--where d.DocumentId = @DocumentId
where dv.DocumentVersionId = @DocumentVersionId  --Modified by Anuj Dated 03-May-2010
and isnull(d.recorddeleted, ''N'')= ''N''
      
                
--Checking For Errors                                  
If (@@error!=0)                                  
	Begin                                  
		RAISERROR  20006   ''csp_RDLCustomMedicationCheckup : An Error Occured''                                   
		Return                                  
	End
End
' 
END
GO
