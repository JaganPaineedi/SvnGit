--Validation scripts for Task #3 in New Directions - Customizations (Crisis Service Note)
/******************************************************************************** 

-- *****History****  
/*       Date           Author				Purpose                   */
/*       08/APR/2015	Vichee			    Created                   */
*********************************************************************************/
DELETE
FROM DocumentValidations
WHERE DocumentCodeId = 60006

INSERT [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	N'Y'
	,60006
	,NULL
	,'Note'
	,1
	,N'CustomAcuteServicesPrescreens'
	,N'RiskSuicideHomicidePlanDetails'
	,N'FROM CustomAcuteServicesPrescreens WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(RiskSuicideHomicidePlanDetails,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Crisis Note – Suicide/Homicide Plan details is required.'
	,CAST(1 AS DECIMAL(18, 0))
	,N'Crisis Note – Suicide/Homicide Plan details is required.'
	)
   ,(
	N'Y'
	,60006
	,NULL
	,'Note'
	,2
	,N'CustomAcuteServicesPrescreens'
	,N'RiskSuicideHomicidePlanAvailability'
	,N'FROM CustomAcuteServicesPrescreens WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(RiskSuicideHomicidePlanAvailability,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Crisis Note - Suicide/Homicide plan availability of means is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'Crisis Note - Suicide/Homicide plan availability of means is required.'
	)	
	,(
	N'Y'
	,60006
	,NULL
	,'Note'
	,3
	,N'CustomAcuteServicesPrescreens'
	,N'RiskSuicideHomicidePlanTime'
	,N'FROM CustomAcuteServicesPrescreens WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(RiskSuicideHomicidePlanTime,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Crisis Note - Suicide/Homicide plan time is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'Crisis Note - Suicide/Homicide plan time is required.'
	)	
	,(
	N'Y'
	,60006
	,NULL
	,'Note'
	,4
	,N'CustomAcuteServicesPrescreens'
	,N'RiskSuicideHomicidePlanLethalityMethod'
	,N'FROM CustomAcuteServicesPrescreens WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(RiskSuicideHomicidePlanLethalityMethod,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Crisis Note - Suicide/Homicide Plan Lethality of Method is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'Crisis Note - Suicide/Homicide Plan Lethality of Method is required.'
	)
	
	,(
	N'Y'
	,60006
	,NULL
	,'Note'
	,5
	,N'CustomAcuteServicesPrescreens'
	,N'RiskSuicideHomisideAttempts'
	,N'FROM CustomAcuteServicesPrescreens WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(RiskSuicideHomisideAttempts,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Crisis Note - Previous Suicide/Homicide Attempts is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'Crisis Note - Previous Suicide/Homicide Attempts is required.'
	)
	
	,(
	N'Y'
	,60006
	,NULL
	,'Note'
	,6
	,N'CustomAcuteServicesPrescreens'
	,N'RiskSuicideHomisideIsolation'
	,N'FROM CustomAcuteServicesPrescreens WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(RiskSuicideHomisideIsolation,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Crisis Note - Isolation.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'Crisis Note - Isolation.'
	)
	
	,(
	N'Y'
	,60006
	,NULL
	,'Note'
	,7
	,N'CustomAcuteServicesPrescreens'
	,N'RiskSuicideHomisideProbabilityTiming'
	,N'FROM CustomAcuteServicesPrescreens WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(RiskSuicideHomisideProbabilityTiming,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Crisis Note - Intervention Probability/Timing is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'Crisis Note - Intervention Probability/Timing is required.'
	)
	
	,(
	N'Y'
	,60006
	,NULL
	,'Note'
	,8
	,N'CustomAcuteServicesPrescreens'
	,N'RiskSuicideHomisidePrecaution'
	,N'FROM CustomAcuteServicesPrescreens WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(RiskSuicideHomisidePrecaution,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Crisis Note - Precautions against discovery/interventions is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'Crisis Note - Precautions against discovery/interventions is required.'
	)
	
	,(
	N'Y'
	,60006
	,NULL
	,'Note'
	,9
	,N'CustomAcuteServicesPrescreens'
	,N'RiskSuicideHomisideActingToGetHelp'
	,N'FROM CustomAcuteServicesPrescreens WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(RiskSuicideHomisideActingToGetHelp,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Crisis Note - Acting to get help during/after attempt is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'Crisis Note - Acting to get help during/after attempt is required.'
	)
	
	,(
	N'Y'
	,60006
	,NULL
	,'Note'
	,10
	,N'CustomAcuteServicesPrescreens'
	,N'RiskSuicideHomisideFinalAct'
	,N'FROM CustomAcuteServicesPrescreens WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(RiskSuicideHomisideFinalAct,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Crisis Note - Final acts in anticipation of death (e.g. will, gifts, insurance) is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'Crisis Note - Final acts in anticipation of death (e.g. will, gifts, insurance) is required.'
	)
	
	,(
	N'Y'
	,60006
	,NULL
	,'Note'
	,11
	,N'CustomAcuteServicesPrescreens'
	,N'RiskSuicideHomisideActiveForAttempt'
	,N'FROM CustomAcuteServicesPrescreens WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(RiskSuicideHomisideActiveForAttempt,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Crisis Note - Active preparation for attempt (e.g. note, messages/texts, noose, recent purchase of lethal items) is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'Crisis Note - Active preparation for attempt (e.g. note, messages/texts, noose, recent purchase of lethal items) is required.'
	)
	
	,(
	N'Y'
	,60006
	,NULL
	,'Note'
	,12
	,N'CustomAcuteServicesPrescreens'
	,N'RiskSuicideHomisideSucideNote'
	,N'FROM CustomAcuteServicesPrescreens WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(RiskSuicideHomisideSucideNote,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Crisis Note - Suicide Note/Message is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'Crisis Note - Suicide Note/Message is required.'
	)
	
	,(
	N'Y'
	,60006
	,NULL
	,'Note'
	,13
	,N'CustomAcuteServicesPrescreens'
	,N'RiskSuicideHomisideOvertCommunication'
	,N'FROM CustomAcuteServicesPrescreens WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(RiskSuicideHomisideOvertCommunication,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Crisis Note - Overt communication of intent before attempt is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'Crisis Note - Overt communication of intent before attempt is required.'
	)
	,(
	N'Y'
	,60006
	,NULL
	,'Note'
	,14
	,N'CustomAcuteServicesPrescreens'
	,N'RiskSuicideHomisideAllegedPurposed'
	,N'FROM CustomAcuteServicesPrescreens WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(RiskSuicideHomisideAllegedPurposed,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Crisis Note - Alleged purpose of intent is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'Crisis Note - Alleged purpose of intent is required.'
	)
	
	,(
	N'Y'
	,60006
	,NULL
	,'Note'
	,15
	,N'CustomAcuteServicesPrescreens'
	,N'RiskSuicideHomisideExpectationFatality'
	,N'FROM CustomAcuteServicesPrescreens WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(RiskSuicideHomisideExpectationFatality,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Crisis Note - Expectations of fatality is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'Crisis Note - Expectations of fatality is required.'
	)
	
	,(
	N'Y'
	,60006
	,NULL
	,'Note'
	,16
	,N'CustomAcuteServicesPrescreens'
	,N'RiskSuicideHomisideConceptionOfMethod'
	,N'FROM CustomAcuteServicesPrescreens WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(RiskSuicideHomisideConceptionOfMethod,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Crisis Note - Conception of method’s lethality is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'Crisis Note - Conception of method’s lethality is required.'
	)
	
	,(
	N'Y'
	,60006
	,NULL
	,'Note'
	,17
	,N'CustomAcuteServicesPrescreens'
	,N'RiskSuicideHomisideSeriousnessOfAttempt'
	,N'FROM CustomAcuteServicesPrescreens WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(RiskSuicideHomisideSeriousnessOfAttempt,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Crisis Note - Seriousness of attempt is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'Crisis Note - Seriousness of attempt is required.'
	)
	
	,(
	N'Y'
	,60006
	,NULL
	,'Note'
	,18
	,N'CustomAcuteServicesPrescreens'
	,N'RiskSuicideHomisideAttitudeLivingDying'
	,N'FROM CustomAcuteServicesPrescreens WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(RiskSuicideHomisideAttitudeLivingDying,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Crisis Note - Attitude toward living/dying is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'Crisis Note - Attitude toward living/dying is required.'
	)
	
	
	,(
	N'Y'
	,60006
	,NULL
	,'Note'
	,19
	,N'CustomAcuteServicesPrescreens'
	,N'RiskSuicideHomisideMedicalStatus'
	,N'FROM CustomAcuteServicesPrescreens WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(RiskSuicideHomisideMedicalStatus,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Crisis Note - Medical Status is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'Crisis Note - Medical Status is required.'
	)	
	
	,(
	N'Y'
	,60006
	,NULL
	,'Note'
	,20
	,N'CustomAcuteServicesPrescreens'
	,N'RiskSuicideHomisideConceptMedicalRescue'
	,N'FROM CustomAcuteServicesPrescreens WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(RiskSuicideHomisideConceptMedicalRescue,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Crisis Note - Conception of medical rescue ability is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'Crisis Note - Conception of medical rescue ability is required.'
	)
	
	,(
	N'Y'
	,60006
	,NULL
	,'Note'
	,21
	,N'CustomAcuteServicesPrescreens'
	,N'RiskSuicideHomisideDegreePremeditation'
	,N'FROM CustomAcuteServicesPrescreens WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(RiskSuicideHomisideDegreePremeditation,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Crisis Note - Degree of premeditation is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'Crisis Note - Degree of premeditation is required.'
	)
	
	,(
	N'Y'
	,60006
	,NULL
	,'Note'
	,22
	,N'CustomAcuteServicesPrescreens'
	,N'RiskSuicideHomisideStress'
	,N'FROM CustomAcuteServicesPrescreens WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(RiskSuicideHomisideStress,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Crisis Note - Stress is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'Crisis Note - Stress is required.'
	)
	
	,(
	N'Y'
	,60006
	,NULL
	,'Note'
	,23
	,N'CustomAcuteServicesPrescreens'
	,N'RiskSuicideHomisideCopingBehavior'
	,N'FROM CustomAcuteServicesPrescreens WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(RiskSuicideHomisideCopingBehavior,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Crisis Note - Coping Behavior is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'Crisis Note - Coping Behavior is required.'
	)
	
	,(
	N'Y'
	,60006
	,NULL
	,'Note'
	,24
	,N'CustomAcuteServicesPrescreens'
	,N'RiskSuicideHomisideDepression'
	,N'FROM CustomAcuteServicesPrescreens WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(RiskSuicideHomisideDepression,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Crisis Note - Depression is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'Crisis Note - Depression is required.'
	)	
	
	,(
	N'Y'
	,60006
	,NULL
	,'Note'
	,25
	,N'CustomAcuteServicesPrescreens'
	,N'RiskSuicideHomisideResource'
	,N'FROM CustomAcuteServicesPrescreens WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(RiskSuicideHomisideResource,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Crisis Note - Resource is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'Crisis Note - Resource is required.'
	)	
	
	
	,(
	N'Y'
	,60006
	,NULL
	,'Note'
	,26
	,N'CustomAcuteServicesPrescreens'
	,N'RiskSuicideHomisideLifeStyle'
	,N'FROM CustomAcuteServicesPrescreens WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(RiskSuicideHomisideLifeStyle,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Crisis Note - Life Style is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'Crisis Note - Life Style is required.'
	)	
	
	
	,(
	N'Y'
	,60006
	,NULL
	,'Note'
	,27
	,N'CustomAcuteServicesPrescreens'
	,N'Recommendations'
	,N'FROM CustomAcuteServicesPrescreens WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(Recommendations,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Crisis Note - Suicide/Homicide Risk Assessment – recommendation is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'Crisis Note - Suicide/Homicide Risk Assessment – recommendation is required.'
	)	
	
	
	--- Action Taken 
	
	
	,(
	N'Y'
	,60006
	,NULL
	,'Action Taken'
	,28
	,N'CustomAcuteServicesPrescreens'
	,N'RiskActionTakenPsychiatricPlacementVoluntary'
	,N'FROM CustomAcuteServicesPrescreens WHERE DocumentVersionId=@DocumentVersionId AND  ISNULL(RiskActionTakenMedicalER,''N'') = ''N'' AND ISNULL(RiskActionTakenPsychiatricPlacement,''N'') = ''N'' AND ISNULL(RiskActionDirectorsHoldPlaced,''N'') = ''N''AND ISNULL(RiskActionSecureTransport,''N'') = ''N''AND ISNULL(RiskActionTakenCrisisRespiteBed,''N'') = ''N''AND ISNULL(RiskActionTakenJail,''N'') = ''N''AND ISNULL(RiskActionSocialDextorBed,''N'') = ''N''AND ISNULL(RiskSentHomeAlone,''N'') = ''N''AND ISNULL(RiskReferedToPrivateProvider,''N'') = ''N''AND ISNULL(RiskRefferedPyschiatristPMNHP,''N'') = ''N'' AND ISNULL(RiskReferedToOther,''N'') = ''N''  AND ISNULL(RiskRefferedToFollowNextDay,''N'') = ''N'' AND ISNULL(RiskSentHomeWithRelative,''N'') = ''N'' and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'– at least one checkbox is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'– at least one checkbox is required.'
	)
	
	
	
	,(
	N'Y'
	,60006
	,NULL
	,'Action Taken'
	,29
	,N'CustomAcuteServicesPrescreens'
	,N'RiskActionTakenPsychiatricPlacementVoluntary'
	,N'FROM CustomAcuteServicesPrescreens WHERE DocumentVersionId=@DocumentVersionId AND RiskActionTakenPsychiatricPlacement = ''Y'' AND ISNULL(RiskActionTakenPsychiatricPlacementVoluntary,''N'') = ''N'' AND ISNULL(RiskActionTakenPsychiatricPlacementInVoluntary,''N'') = ''N'' and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'– Psychiatric Placement – Voluntary/Involuntary is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'– Psychiatric Placement – Voluntary/Involuntary is required.'
	)	
	
	
	
	,(
	N'Y'
	,60006
	,NULL
	,'Action Taken'
	,30
	,N'CustomAcuteServicesPrescreens'
	,N'ActionTakenPsychiatricPlacementHospital'
	,N'FROM CustomAcuteServicesPrescreens WHERE DocumentVersionId=@DocumentVersionId AND RiskActionTakenPsychiatricPlacement = ''Y''  AND  ISNULL(ActionTakenPsychiatricPlacementHospital,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'- Psychiatric Placement – text field is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'- Psychiatric Placement – text field is required.'
	)	
	
	
	,(
	N'Y'
	,60006
	,NULL
	,'Action Taken'
	,31
	,N'CustomAcuteServicesPrescreens'
	,N'RiskActionSecureTransportCompanyName'
	,N'FROM CustomAcuteServicesPrescreens WHERE DocumentVersionId=@DocumentVersionId AND RiskActionSecureTransport = ''Y''  AND  ISNULL(RiskActionSecureTransportCompanyName,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'– Secure Transport Used – text field is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'– Secure Transport Used – text field is required.'
	)	
	
	,(
	N'Y'
	,60006
	,NULL
	,'Action Taken'
	,32
	,N'CustomAcuteServicesPrescreens'
	,N'RiskActionTakenCrisisRespiteBedWithPsych'
	,N'FROM CustomAcuteServicesPrescreens WHERE DocumentVersionId=@DocumentVersionId AND RiskActionTakenCrisisRespiteBed = ''Y'' AND ISNULL(RiskActionTakenCrisisRespiteBedWithPsych,''N'') = ''N'' AND ISNULL(RiskActionTakenCrisisRespiteBedWithoutPsych,''N'') = ''N'' and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'– Crisis Respite Bed – With Psych Sitter/Without Psych Sitter is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'– Crisis Respite Bed – With Psych Sitter/Without Psych Sitter is required.'
	)	
	
	
	,(
	N'Y'
	,60006
	,NULL
	,'Action Taken'
	,33
	,N'CustomAcuteServicesPrescreens'
	,N'RiskActionSecureTransportCompanyName'
	,N'FROM CustomAcuteServicesPrescreens WHERE DocumentVersionId=@DocumentVersionId AND RiskReferedToPrivateProvider = ''Y''  AND  ISNULL(RiskReferedToPrivateProviderName,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'– Private Provider for Follow up – text field is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'– Private Provider for Follow up – text field is required.'
	)	
	
	,(
	N'Y'
	,60006
	,NULL
	,'Action Taken'
	,34
	,N'CustomAcuteServicesPrescreens'
	,N'RiskReferedToOtherSpecify'
	,N'FROM CustomAcuteServicesPrescreens WHERE DocumentVersionId=@DocumentVersionId AND RiskReferedToOther = ''Y''  AND  ISNULL(RiskReferedToOtherSpecify,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'– Other – text field is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'– Other – text field is required.'
	)	
	
	
	,(
	N'Y'
	,60006
	,NULL
	,'Note'
	,35
	,N'CustomAcuteServicesPrescreens'
	,N'RiskSuicidePresentingDangersSuicide'
	,N'FROM CustomAcuteServicesPrescreens WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(RiskSuicidePresentingDangersSuicide,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Crisis Note - Suicide/Homicide Risk Assessment Presenting Dangers –Self is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'Crisis Note - Suicide/Homicide Risk Assessment Presenting Dangers –Self is required.'
	)	
	
	
	,(
	N'Y'
	,60006
	,NULL
	,'Note'
	,36
	,N'CustomAcuteServicesPrescreens'
	,N'RiskSuicidePresentingDangersOtherHarmToSelf'
	,N'FROM CustomAcuteServicesPrescreens WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(RiskSuicidePresentingDangersOtherHarmToSelf,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Crisis Note - Suicide/Homicide Risk Assessment Presenting Dangers –Other Harm To Self is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'Crisis Note - Suicide/Homicide Risk Assessment Presenting Dangers –Other Harm To Self is required.'
	)	
	
	
	,(
	N'Y'
	,60006
	,NULL
	,'Note'
	,37
	,N'CustomAcuteServicesPrescreens'
	,N'RiskSuicidePresentingDangersHarmToOthers'
	,N'FROM CustomAcuteServicesPrescreens WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(RiskSuicidePresentingDangersHarmToOthers,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Crisis Note - Suicide/Homicide Risk Assessment Presenting Dangers –Harm To Others is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'Crisis Note - Suicide/Homicide Risk Assessment Presenting Dangers –Harm To Others is required.'
	)	
	
	
	,(
	N'Y'
	,60006
	,NULL
	,'Note'
	,38
	,N'CustomAcuteServicesPrescreens'
	,N'RiskSuicidePresentingDangersHarmToProperty'
	,N'FROM CustomAcuteServicesPrescreens WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(RiskSuicidePresentingDangersHarmToProperty,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Crisis Note - Suicide/Homicide Risk Assessment Presenting Dangers –Harm To Property is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'Crisis Note - Suicide/Homicide Risk Assessment Presenting Dangers –Harm To Property is required.'
	)	
	
	