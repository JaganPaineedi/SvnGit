IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomScreening]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomScreening]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_validateCustomScreening]          
@DocumentVersionId INT

AS    
/******************************************************************************                                          
**  File: [csp_validateCustomScreening]                                      
**  Name: [csp_validateCustomScreening]                  
**  Desc: For Validation  on Screening
**  Return values: Resultset having validation messages                                          
**  Called by:                                           
**  Parameters:                      
**  Auth:  Shruthi.S                        
**  Date:  May 11 2015                                     
*******************************************************************************/                                        
          
Begin                                                        
                  
  Begin try
  ----------------------------Table for validation ----------------------------
  
  ---Substance Abuse Screening temp table------------
  
  CREATE TABLE #CustomDocumentSubstanceAbuseScreenings
  (
    DocumentVersionId int NULL,
	RecordDeleted char(1)	NULL,
	Inhalants int Null,
	MissedSchool int Null,
	PastYearDrunk int Null,
	RiskyWhenHigh int Null,
	ProblemWithDrinking int Null,
	ThingsWithoutThinking int Null,
	MissFamilyActivities int Null,
	WorryAboutUsingAlcohol int Null,
	HurtLovedOne int Null,
	ToFeelNormal int Null,
	MakeYouMad int Null,
	GuiltyAboutAlcohol int Null,
	WorryAboutGamblingActivities int Null,
	HasMotherConsumedAlcohol int Null,
	DidMotherDrinkInPregnancy int Null
  )
  
  
  Insert into #CustomDocumentSubstanceAbuseScreenings
  (
    DocumentVersionId,
	RecordDeleted,
	Inhalants,
	MissedSchool,
	PastYearDrunk,
	RiskyWhenHigh,
	ProblemWithDrinking,
	ThingsWithoutThinking,
	MissFamilyActivities,
	WorryAboutUsingAlcohol,
	HurtLovedOne,
	ToFeelNormal,
	MakeYouMad,
	GuiltyAboutAlcohol,
	WorryAboutGamblingActivities,
	HasMotherConsumedAlcohol,
	DidMotherDrinkInPregnancy
  )
  Select
    DocumentVersionId,
	RecordDeleted,
	Inhalants,
	MissedSchool,
	PastYearDrunk,
	RiskyWhenHigh,
	ProblemWithDrinking,
	ThingsWithoutThinking,
	MissFamilyActivities,
	WorryAboutUsingAlcohol,
	HurtLovedOne,
	ToFeelNormal,
	MakeYouMad,
	GuiltyAboutAlcohol,
	WorryAboutGamblingActivities,
	HasMotherConsumedAlcohol,
	DidMotherDrinkInPregnancy
	from CustomDocumentSubstanceAbuseScreenings C where C.DocumentVersionId=@DocumentVersionId and  isnull(C.RecordDeleted,'N')<>'Y'   
	
	
	---Mental Health Screening table-------------
	
	  CREATE TABLE #CustomDocumentMentalHealthScreenings
	  (
	    DocumentVersionId int NULL,
		RecordDeleted char(1)	NULL,
		PayingAttentionAtSchool int Null,
		CanNotGetRidOfThought int Null,
		HearVoices int Null,
		SpendTimeKilling int Null,
		TriedToCommitSuicide int Null,
		WatchYourStep int Null,
		FeelAnxious int Null,
		ThoughtsComeQuickly int Null,
		DestroyedProperty int Null,
		FeelTrapped int Null,
		DissatifiedWithLife int Null,
		UnPleasantThoughts int Null,
		DifficultyInSleeping int Null,
		PhysicallyHarmed int Null,
		LostInterest int Null,
		FeelAngry int Null,
		GetIntoTrouble int Null,
		FeelAfraid int Null,
		FeelDepressed int Null,
		SpendTimeOnThinkingAboutWeight int Null
	  )
	  
	  Insert into #CustomDocumentMentalHealthScreenings
	  (
	    DocumentVersionId,
		RecordDeleted,
		PayingAttentionAtSchool,
		CanNotGetRidOfThought,
		HearVoices,
		SpendTimeKilling,
		TriedToCommitSuicide,
		WatchYourStep,
		FeelAnxious,
		ThoughtsComeQuickly,
		DestroyedProperty,
		FeelTrapped,
		DissatifiedWithLife,
		UnPleasantThoughts,
		DifficultyInSleeping,
		PhysicallyHarmed,
		LostInterest,
		FeelAngry,
		GetIntoTrouble,
		FeelAfraid,
		FeelDepressed,
		SpendTimeOnThinkingAboutWeight
	  )
	  Select
	    DocumentVersionId,
		RecordDeleted,
		PayingAttentionAtSchool,
		CanNotGetRidOfThought,
		HearVoices,
		SpendTimeKilling,
		TriedToCommitSuicide,
		WatchYourStep,
		FeelAnxious,
		ThoughtsComeQuickly,
		DestroyedProperty,
		FeelTrapped,
		DissatifiedWithLife,
		UnPleasantThoughts,
		DifficultyInSleeping,
		PhysicallyHarmed,
		LostInterest,
		FeelAngry,
		GetIntoTrouble,
		FeelAfraid,
		FeelDepressed,
		SpendTimeOnThinkingAboutWeight
		From CustomDocumentMentalHealthScreenings M where M.DocumentVersionId=@DocumentVersionId and  isnull(M.RecordDeleted,'N')<>'Y'  
		
		
   ---------Brain table------------
   
   CREATE TABLE #CustomDocumentTraumaticBrainInjuryScreenings
   (
		DocumentVersionId int NULL,
		RecordDeleted char(1)	NULL,
		BlowToTheHead int Null,
		HeadBlowWhenDidItOccur varchar(max),
		HowLongUnconscious varchar(max),
		CauseAConcussion int Null,
		ConcussionWhenDidItOccur varchar(max),
		HowLongConcussionLast varchar(max),
		ReceiveTreatmentForHeadInjury int Null,
		PhysicalAbilities int Null,
		Mood int Null,
		CareForYourSelf int Null,
		Temper int Null,
		Speech int Null,
		RelationshipWithOthers int Null,
		Hearing int Null,
		Memory int Null,
		AbilityToConcentrate int Null,
		UseOfAlcohol int Null,
		AbilityToWork int Null,
		ChangedAfterInjury int Null
   )
   
   Insert into #CustomDocumentTraumaticBrainInjuryScreenings
   (
    DocumentVersionId,
	RecordDeleted,
	BlowToTheHead,
	HeadBlowWhenDidItOccur,
	HowLongUnconscious,
	CauseAConcussion,
	ConcussionWhenDidItOccur,
	HowLongConcussionLast,
	ReceiveTreatmentForHeadInjury,
	PhysicalAbilities,
	Mood,
	CareForYourSelf,
	Temper,
	Speech,
	RelationshipWithOthers,
	Hearing,
	Memory,
	AbilityToConcentrate,
	UseOfAlcohol,
	AbilityToWork,
	ChangedAfterInjury
   )
   select 
    DocumentVersionId,
	RecordDeleted,
	BlowToTheHead,
	HeadBlowWhenDidItOccur,
	HowLongUnconscious,
	CauseAConcussion,
	ConcussionWhenDidItOccur,
	HowLongConcussionLast,
	ReceiveTreatmentForHeadInjury,
	PhysicalAbilities,
	Mood,
	CareForYourSelf,
	Temper,
	Speech,
	RelationshipWithOthers,
	Hearing,
	Memory,
	AbilityToConcentrate,
	UseOfAlcohol,
	AbilityToWork,
	ChangedAfterInjury
   from 	CustomDocumentTraumaticBrainInjuryScreenings B where 	B.DocumentVersionId=@DocumentVersionId and  isnull(B.RecordDeleted,'N')<>'Y'
   
   
   ---Table for Outcomes tab   ---------------------------
   
     CREATE TABLE #CustomDocumentOutComesScreenings
     (
        DocumentVersionId int Null,
		RecordDeleted char(1)	NULL,
		SubstanceAbuseConsumer int Null,
		SubstanceAbuseConsumerSteps varchar(max),
		MentalHealthConsumer int Null,
		MentalHealthConsumerSteps varchar(max),
		FASDAssessment int Null,
		FASDAssessmentSteps varchar(max),
		MHAndSAConsumer int Null,
		MHAndSAConsumerSteps varchar(max),
		EvidenceOfInjury int Null,
		EvidenceOfInjurySteps varchar(max)
     )
     
     Insert into #CustomDocumentOutComesScreenings
     (
        DocumentVersionId,
		RecordDeleted,
		SubstanceAbuseConsumer,
		SubstanceAbuseConsumerSteps,
		MentalHealthConsumer,
		MentalHealthConsumerSteps,
		FASDAssessment,
		FASDAssessmentSteps,
		MHAndSAConsumer,
		MHAndSAConsumerSteps,
		EvidenceOfInjury,
		EvidenceOfInjurySteps
     )
     select
        DocumentVersionId,
		RecordDeleted,
		SubstanceAbuseConsumer,
		SubstanceAbuseConsumerSteps,
		MentalHealthConsumer,
		MentalHealthConsumerSteps,
		FASDAssessment,
		FASDAssessmentSteps,
		MHAndSAConsumer,
		MHAndSAConsumerSteps,
		EvidenceOfInjury,
		EvidenceOfInjurySteps
     
     from CustomDocumentOutComesScreenings O where O.DocumentVersionId=@DocumentVersionId and  isnull(O.RecordDeleted,'N')<>'Y'
	
	---Validation temp table
	
	DECLARE @validationReturnTable TABLE        
	(          
		TableName varchar(200),              
		ColumnName varchar(200),      
		ErrorMessage varchar(1000),
		PageIndex    int,        
		TabOrder int,        
		ValidationOrder int          
	)     
    Insert into @validationReturnTable        
	(          
		TableName,              
		ColumnName,              
		ErrorMessage,
		ValidationOrder             
	)    
	------------Validations for Substance Abuse Screening tab------------------
Select 'CustomDocumentSubstanceAbuseScreenings', 'Inhalants', 'Substance Abuse Screening – 1. Have you gotten in trouble at home, at school, at work, or in the community because of using alcohol, drugs, or inhalants is required.',1  
FROM #CustomDocumentSubstanceAbuseScreenings  
WHERE IsNULL (Inhalants,-1)=-1
union
Select 'CustomDocumentSubstanceAbuseScreenings', 'MissedSchool', 'Substance Abuse Screening – 2. Have you missed school or work because of using alcohol, drugs, or inhalants is required.',2 
FROM #CustomDocumentSubstanceAbuseScreenings  
WHERE IsNULL (MissedSchool,-1) =-1
union
Select 'CustomDocumentSubstanceAbuseScreenings', 'PastYearDrunk', 'Substance Abuse Screening – 3. In the past year have you ever had 6 or more drinks at any one time is required.',3 
FROM #CustomDocumentSubstanceAbuseScreenings  
WHERE IsNULL (PastYearDrunk,-1)=-1 
union
Select 'CustomDocumentSubstanceAbuseScreenings', 'RiskyWhenHigh', 'Substance Abuse Screening – 4. Have you done harmful or risky things when you were high is required.',4 
FROM #CustomDocumentSubstanceAbuseScreenings  
WHERE IsNULL (RiskyWhenHigh,-1)=-1 
union
Select 'CustomDocumentSubstanceAbuseScreenings', 'ProblemWithDrinking', 'Substance Abuse Screening – 5. Do you think you might have a problem with your drinking, drugs, or inhalant use is required.',5 
FROM #CustomDocumentSubstanceAbuseScreenings  
WHERE IsNULL (ProblemWithDrinking,-1)=-1
union

Select 'CustomDocumentSubstanceAbuseScreenings', 'ThingsWithoutThinking', 'Substance Abuse Screening – 6. When using alcohol, drugs, or inhalants have you done things without thinking and later wished you had not is required.',6 
FROM #CustomDocumentSubstanceAbuseScreenings  
WHERE IsNULL (ThingsWithoutThinking,-1) = -1
union

Select 'CustomDocumentSubstanceAbuseScreenings', 'MissFamilyActivities', 'Substance Abuse Screening – 7. Do you miss family activities, after school activities, community events, traditional ceremonies potlatches, or feasts because of using alcohol, drugs, or inhalants is required.',7
FROM #CustomDocumentSubstanceAbuseScreenings  
WHERE IsNULL (MissFamilyActivities,-1) =-1 
union
Select 'CustomDocumentSubstanceAbuseScreenings', 'WorryAboutUsingAlcohol', 'Substance Abuse Screening – 8. Does anyone close to you worry or complain about using alcohol, drugs, or inhalants is required.',8
FROM #CustomDocumentSubstanceAbuseScreenings  
WHERE IsNULL (WorryAboutUsingAlcohol,-1) = -1
union
Select 'CustomDocumentSubstanceAbuseScreenings', 'HurtLovedOne', 'Substance Abuse Screening – 9. Have you lost a friend or hurt a loved one because of your using alcohol, drugs, or inhalants is required.',9
FROM #CustomDocumentSubstanceAbuseScreenings  
WHERE IsNULL (HurtLovedOne,-1) = -1 
union
Select 'CustomDocumentSubstanceAbuseScreenings', 'ToFeelNormal', 'Substance Abuse Screening – 10. Do you use alcohol, drugs, or inhalants to make you feel normal is required.',10
FROM #CustomDocumentSubstanceAbuseScreenings  
WHERE IsNULL (ToFeelNormal,-1) = -1
union
Select 'CustomDocumentSubstanceAbuseScreenings', 'MakeYouMad', 'Substance Abuse Screening – 11. Does it make you mad if someone tells you that you drink, use drugs, or use inhalants too much is required.',11
FROM #CustomDocumentSubstanceAbuseScreenings  
WHERE IsNULL (MakeYouMad,-1) = -1
union
Select 'CustomDocumentSubstanceAbuseScreenings', 'GuiltyAboutAlcohol', 'Substance Abuse Screening – 12. Do you feel guilty about your alcohol, drug, or inhalant use is required.',12
FROM #CustomDocumentSubstanceAbuseScreenings  
WHERE IsNULL (GuiltyAboutAlcohol,-1) = -1 
union
Select 'CustomDocumentSubstanceAbuseScreenings', 'WorryAboutGamblingActivities', 'Substance Abuse Screening – 13. Do you or other people worry about the amount of money or time you spend at Bingo, pull tabs, or other gambling activities is required.',13
FROM #CustomDocumentSubstanceAbuseScreenings  
WHERE IsNULL (WorryAboutGamblingActivities,-1) = -1
union
Select 'CustomDocumentSubstanceAbuseScreenings', 'HasMotherConsumedAlcohol', 'Substance Abuse Screening – 14. Has your mother ever consumed alcohol is required.',14
FROM #CustomDocumentSubstanceAbuseScreenings  
WHERE IsNULL (HasMotherConsumedAlcohol,-1) = -1
union
Select 'CustomDocumentSubstanceAbuseScreenings', 'DidMotherDrinkInPregnancy', 'Substance Abuse Screening – 15. If yes, did she drink during her pregnancy with you is required.',15
FROM #CustomDocumentSubstanceAbuseScreenings  
WHERE IsNULL (DidMotherDrinkInPregnancy,-1) = -1
union
-----------Mental Health tab validations

Select 'CustomDocumentMentalHealthScreenings', 'PayingAttentionAtSchool', 'Mental Health  – 1. Do you often have difficulty sitting still and paying attention at school, work, or social setting is required.',16
FROM #CustomDocumentMentalHealthScreenings  
WHERE IsNULL (PayingAttentionAtSchool,-1) = -1
union
Select 'CustomDocumentMentalHealthScreenings', 'CanNotGetRidOfThought', 'Mental Health  – 2. Do disturbing thoughts that you can’t get rid of come into your mind is required.',17
FROM #CustomDocumentMentalHealthScreenings  
WHERE IsNULL (CanNotGetRidOfThought,-1) = -1
union
Select 'CustomDocumentMentalHealthScreenings', 'HearVoices', 'Mental Health  – 3. Do you ever hear voices or see things that other people tell you they don’t see or hear is required.',18
FROM #CustomDocumentMentalHealthScreenings  
WHERE IsNULL (HearVoices,-1) =-1
union
Select 'CustomDocumentMentalHealthScreenings', 'SpendTimeKilling', 'Mental Health  – 4. Do you spend time thinking about hurting or killing yourself or anyone else is required.',19
FROM #CustomDocumentMentalHealthScreenings  
WHERE IsNULL (SpendTimeKilling,-1) = -1
union
Select 'CustomDocumentMentalHealthScreenings', 'TriedToCommitSuicide', 'Mental Health  – 5. Have you ever tried to hurt yourself or commit suicide is required.',20
FROM #CustomDocumentMentalHealthScreenings 
WHERE IsNULL (TriedToCommitSuicide,-1) = -1
union
Select 'CustomDocumentMentalHealthScreenings', 'WatchYourStep', 'Mental Health  – 6. Do you think people are out to get you and you have to watch your step is required.',21
FROM #CustomDocumentMentalHealthScreenings 
WHERE IsNULL (WatchYourStep,-1) =-1

union
Select 'CustomDocumentMentalHealthScreenings', 'FeelAnxious', 'Mental Health  – 7. Do you often find yourself in situations where your heart pounds and you feel anxious and want to get away is required.',22
FROM #CustomDocumentMentalHealthScreenings 
WHERE IsNULL (FeelAnxious,-1) = -1 
union
Select 'CustomDocumentMentalHealthScreenings', 'ThoughtsComeQuickly', 'Mental Health  – 8. Do you sometimes have so much energy that your thoughts come quickly, you jump from one activity to another, you feel like you don’t need sleep, like you can do anyting is required.',23
FROM #CustomDocumentMentalHealthScreenings 
WHERE IsNULL (ThoughtsComeQuickly,-1) = -1
union
Select 'CustomDocumentMentalHealthScreenings', 'DestroyedProperty', 'Mental Health  – 9. Have you destroyed property or set a fire that caused damage is required.',24
FROM #CustomDocumentMentalHealthScreenings 
WHERE IsNULL (DestroyedProperty,-1) = -1 
union
Select 'CustomDocumentMentalHealthScreenings', 'FeelTrapped', 'Mental Health  – 10. Do you feel trapped, lonely, confused, lost, or hopeless about your futurre is required.',25
FROM #CustomDocumentMentalHealthScreenings 
WHERE IsNULL (FeelTrapped,-1) =-1 
union
Select 'CustomDocumentMentalHealthScreenings', 'DissatifiedWithLife', 'Mental Health  – 11. Do you feel dissatisfied with your life and relationships is required.',26
FROM #CustomDocumentMentalHealthScreenings 
WHERE IsNULL (DissatifiedWithLife,-1) =-1 
union
Select 'CustomDocumentMentalHealthScreenings', 'UnPleasantThoughts', 'Mental Health  – 12. Do you have nightmares, flashbacks, or unpleasant thoughts because of a terrible event like rape, domestic violence, incest/unwanted touching, warfare, a bad accident, fights, being or seeing someone shot or stabbed, knowing or seeing someone who has committed suicide, fire, or natural disasters like earthquake or flood is required.',27
FROM #CustomDocumentMentalHealthScreenings 
WHERE IsNULL (UnPleasantThoughts,-1) =-1
union

Select 'CustomDocumentMentalHealthScreenings', 'DifficultyInSleeping', 'Mental Health  – 13. Do you have difficulty sleeping or eating is required.',28
FROM #CustomDocumentMentalHealthScreenings 
WHERE IsNULL (DifficultyInSleeping,-1) = -1 
union
Select 'CustomDocumentMentalHealthScreenings', 'PhysicallyHarmed', 'Mental Health  – 14. Have you physically harmed or threatened to harm an animal or person on purpose is required.',29
FROM #CustomDocumentMentalHealthScreenings 
WHERE IsNULL (PhysicallyHarmed,-1) = -1
union
Select 'CustomDocumentMentalHealthScreenings', 'LostInterest', 'Mental Health  – 15. Have you lost interest or pleasure in school, work, friends, activities, or other things that you once cared about is required.',30
FROM #CustomDocumentMentalHealthScreenings 
WHERE IsNULL (LostInterest,-1) = -1
union
Select 'CustomDocumentMentalHealthScreenings', 'FeelAngry', 'Mental Health  – 16. Do you feel angry and think about doing things that you know are wrong is required.',31
FROM #CustomDocumentMentalHealthScreenings 
WHERE IsNULL (FeelAngry,-1) = -1 
union
Select 'CustomDocumentMentalHealthScreenings', 'GetIntoTrouble', 'Mental Health  – 17. Do you often get into trouble because of breaking the rules is required.',32
FROM #CustomDocumentMentalHealthScreenings 
WHERE IsNULL (GetIntoTrouble,-1) = -1
union
Select 'CustomDocumentMentalHealthScreenings', 'FeelAfraid', 'Mental Health  – 18. Do you sometimes feel afraid, panicky, nervous, or scared is required.',33
FROM #CustomDocumentMentalHealthScreenings 
WHERE IsNULL (FeelAfraid,-1) = -1
union
Select 'CustomDocumentMentalHealthScreenings', 'FeelDepressed', 'Mental Health  – 19. Do you feel sad or depressed much of the time is required.',34
FROM #CustomDocumentMentalHealthScreenings 
WHERE IsNULL (FeelDepressed,-1) = -1
union

Select 'CustomDocumentMentalHealthScreenings', 'SpendTimeOnThinkingAboutWeight', 'Mental Health  – 20. Do you spend a lot of time thinking about your weight or how much you eat is required.',35
FROM #CustomDocumentMentalHealthScreenings 
WHERE IsNULL (SpendTimeOnThinkingAboutWeight,-1) = -1 
union
------------Validations for Brain tab---------------------------
Select 'CustomDocumentTraumaticBrainInjuryScreenings', 'BlowToTheHead', 'Traumatic Brain Injury Screening  – 1. Have you ever had a blow to the head that was severe enough to make you lose consciousness is required.',36
FROM #CustomDocumentTraumaticBrainInjuryScreenings 
WHERE IsNULL (BlowToTheHead,-1) = -1 
union
Select 'CustomDocumentTraumaticBrainInjuryScreenings', 'CauseAConcussion', 'Traumatic Brain Injury Screening  – 2. Have you ever had a blow to the head that was severe enough to cause a concussion is required.',37
FROM #CustomDocumentTraumaticBrainInjuryScreenings 
WHERE IsNULL (CauseAConcussion,-1) =-1

union
Select 'CustomDocumentTraumaticBrainInjuryScreenings', 'ReceiveTreatmentForHeadInjury', 'Traumatic Brain Injury Screening  – 3. Did you receive treatment for the head injury is required.',38
FROM #CustomDocumentTraumaticBrainInjuryScreenings 
WHERE IsNULL (ReceiveTreatmentForHeadInjury,-1) = -1
union
Select 'CustomDocumentTraumaticBrainInjuryScreenings', 'PhysicalAbilities', 'Traumatic Brain Injury Screening  – Physical Abilities is required.',39
FROM #CustomDocumentTraumaticBrainInjuryScreenings 
WHERE IsNULL (PhysicalAbilities,-1) = -1
union
Select 'CustomDocumentTraumaticBrainInjuryScreenings', 'Mood', 'Traumatic Brain Injury Screening  – Mood is required.',40
FROM #CustomDocumentTraumaticBrainInjuryScreenings 
WHERE IsNULL (Mood,-1) = -1 
union

Select 'CustomDocumentTraumaticBrainInjuryScreenings', 'CareForYourSelf', 'Traumatic Brain Injury Screening  – Ability to care for yourself is required.',41
FROM #CustomDocumentTraumaticBrainInjuryScreenings 
WHERE IsNULL (CareForYourSelf,-1) = -1
union
Select 'CustomDocumentTraumaticBrainInjuryScreenings', 'Temper', 'Traumatic Brain Injury Screening  – Temper is required.',42
FROM #CustomDocumentTraumaticBrainInjuryScreenings 
WHERE IsNULL (Temper,-1) = -1
union
Select 'CustomDocumentTraumaticBrainInjuryScreenings', 'Speech', 'Traumatic Brain Injury Screening  – Speech is required.',43
FROM #CustomDocumentTraumaticBrainInjuryScreenings 
WHERE IsNULL (Speech,-1) = -1
union
Select 'CustomDocumentTraumaticBrainInjuryScreenings', 'RelationshipWithOthers', 'Traumatic Brain Injury Screening  – Relationships with others is required.',44
FROM #CustomDocumentTraumaticBrainInjuryScreenings 
WHERE IsNULL (RelationshipWithOthers,-1) = -1 
union
Select 'CustomDocumentTraumaticBrainInjuryScreenings', 'Hearing', 'Traumatic Brain Injury Screening  – Hearing, vision, or other senses is required.',45
FROM #CustomDocumentTraumaticBrainInjuryScreenings 
WHERE IsNULL (Hearing,-1) = -1 
union
Select 'CustomDocumentTraumaticBrainInjuryScreenings', 'AbilityToWork', 'Traumatic Brain Injury Screening  – Ability to work, or do school work is required.',46
FROM #CustomDocumentTraumaticBrainInjuryScreenings 
WHERE IsNULL (AbilityToWork,-1) = -1 
union
Select 'CustomDocumentTraumaticBrainInjuryScreenings', 'Memory', 'Traumatic Brain Injury Screening  – Memory is required.',47
FROM #CustomDocumentTraumaticBrainInjuryScreenings 
WHERE IsNULL (Memory,-1) = -1 
union
Select 'CustomDocumentTraumaticBrainInjuryScreenings', 'UseOfAlcohol', 'Traumatic Brain Injury Screening  – Use of alcohol or other drugs is required.',48
FROM #CustomDocumentTraumaticBrainInjuryScreenings 
WHERE IsNULL (UseOfAlcohol,-1) = -1 
union
Select 'CustomDocumentTraumaticBrainInjuryScreenings', 'AbilityToConcentrate', 'Traumatic Brain Injury Screening  – Ability to concentrate is required.',48
FROM #CustomDocumentTraumaticBrainInjuryScreenings 
WHERE IsNULL (AbilityToConcentrate,-1) = -1 
union
Select 'CustomDocumentTraumaticBrainInjuryScreenings', 'ChangedAfterInjury', 'Traumatic Brain Injury Screening  – 5. Did you receive treatment for any of the things that changed after head injury is required.',49
FROM #CustomDocumentTraumaticBrainInjuryScreenings 
WHERE IsNULL (ChangedAfterInjury,-1) = -1 
union
----textbox validation if Yes chosen

Select 'CustomDocumentTraumaticBrainInjuryScreenings', 'HeadBlowWhenDidItOccur', 'Traumatic Brain Injury Screening  – If yes, when did it occur is required.',50
FROM #CustomDocumentTraumaticBrainInjuryScreenings 
where ISNULL(HeadBlowWhenDidItOccur,'') = '' and IsNULL(BlowToTheHead,0) = 5350  
union
Select 'CustomDocumentTraumaticBrainInjuryScreenings', 'HowLongUnconscious', 'Traumatic Brain Injury Screening  – How long were you unconscious is required.',51
FROM #CustomDocumentTraumaticBrainInjuryScreenings 
where ISNULL(HowLongUnconscious,'') = '' and IsNULL(BlowToTheHead,0) = 5350
union
---OutComes tab 

Select 'CustomDocumentOutComesScreenings', 'SubstanceAbuseConsumer', 'OutComes  – Potential Substance Abuse Consumer is required.',52
FROM #CustomDocumentOutComesScreenings 
WHERE IsNULL (SubstanceAbuseConsumer,-1) = -1
union
Select 'CustomDocumentOutComesScreenings', 'MentalHealthConsumer', 'OutComes  – Potential Mental Health Consumer is required.',53
FROM #CustomDocumentOutComesScreenings 
WHERE IsNULL (MentalHealthConsumer,-1) = -1 
union
Select 'CustomDocumentOutComesScreenings', 'FASDAssessment', 'OutComes  – Does Consumer need FASD assessment is required.',54
FROM #CustomDocumentOutComesScreenings 
WHERE IsNULL (FASDAssessment,-1) = -1 
union
Select 'CustomDocumentOutComesScreenings', 'MHAndSAConsumer', 'OutComes  – Potential Dual Diagnosed (MH and SA)  Consumer is required.',55
FROM #CustomDocumentOutComesScreenings 
WHERE IsNULL (MHAndSAConsumer,-1) = -1 
union
Select 'CustomDocumentOutComesScreenings', 'EvidenceOfInjury', 'OutComes  – Evidence of Traumatic Brain Injury is required.',56
FROM #CustomDocumentOutComesScreenings 
WHERE IsNULL (EvidenceOfInjury,-1) = -1 
union
Select 'CustomDocumentOutComesScreenings', 'SubstanceAbuseConsumerSteps', 'OutComes  – Potential Substance Abuse Consumer follow-up steps is required.',57
FROM #CustomDocumentOutComesScreenings 
WHERE  IsNULL(SubstanceAbuseConsumerSteps,'') = '' and IsNULL (SubstanceAbuseConsumer,0) = 5350
union
Select 'CustomDocumentOutComesScreenings', 'MentalHealthConsumerSteps', 'OutComes  – Potential Mental Health Consumer follow-up steps is required.',58
FROM #CustomDocumentOutComesScreenings 
WHERE IsNULL (MentalHealthConsumer,0) = 5350 and  IsNULL (MentalHealthConsumerSteps,'') = ''
union
Select 'CustomDocumentOutComesScreenings', 'FASDAssessmentSteps', 'OutComes  – Does Consumer need FASD assessment follow-up steps is required.',59
FROM #CustomDocumentOutComesScreenings 
WHERE IsNULL (FASDAssessment,0) = 5350 and  IsNULL (FASDAssessmentSteps,'') = ''
union
Select 'CustomDocumentOutComesScreenings', 'MHAndSAConsumerSteps', 'OutComes  – Potential Dual Diagnosed (MH and SA)  Consumer follow-up steps is required.',60
FROM #CustomDocumentOutComesScreenings 
WHERE IsNULL (MHAndSAConsumer,0) = 5350 and  IsNULL (MHAndSAConsumerSteps,'') = ''
union
Select 'CustomDocumentOutComesScreenings', 'EvidenceOfInjurySteps', 'OutComes  – Evidence of Traumatic Brain Injury follow-up steps is required.',61
FROM #CustomDocumentOutComesScreenings 
WHERE IsNULL (EvidenceOfInjury,0) = 5350 and  IsNULL (EvidenceOfInjurySteps,'') = ''

select * from @validationReturnTable order by ValidationOrder asc
  
End try

BEGIN CATCH                
              
DECLARE @Error varchar(8000)                                                             
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                           
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[csp_validateCustomScreening]')                                                                                           
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                            
    + '*****' + Convert(varchar,ERROR_STATE())                                  RAISERROR                                                                                           
 (                                                             
  @Error, -- Message text.                                                                                          
  16, -- Severity.                                                                                          
  1 -- State.                                                                                          
 );                                                                                       
END CATCH                                      
END             
            