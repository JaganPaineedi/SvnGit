DELETE
FROM DocumentValidations WHERE DocumentCodeId = 11145

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
	--N'Y'
	--,11145
	--,NULL
	--,'Service'
	--,1
	--,N'CustomServices'
	--,N'ModeOfDelivery'
	--,N'FROM Services s inner join CustomServices cs on s.ServiceId=cs.ServiceId where cs.ServiceId = @ServiceId and (s.Status not in (72,73,76)) and isnull(cs.ModeOfDelivery, 0)= 0'
	--,N'Custom Fields – Mode of delivery is required'
	--,CAST(1 AS DECIMAL(18, 0))
	--,N'Custom Fields – Mode of delivery is required'
	--)
	--,
	--(
	--N'Y'
	--,11145
	--,NULL
	--,'Service'
	--,2
	--,N'CustomServices'
	--,N'MemberParticipated'
	--,N'FROM Services s inner join CustomServices cs on s.ServiceId=cs.ServiceId where cs.ServiceId = @ServiceId and (s.[Status] not in (72,73,76)) and isnull(cs.MemberParticipated, ''N'')= ''N'''
	--,N'Custom Fields – Client Participated is required'
	--,CAST(2 AS DECIMAL(18, 0))
	--,N'Custom Fields – Client Participated is required'
	--),
	--(
	--N'Y'
	--,11145
	--,NULL
	--,'Service'
	--,3
	--,N'CustomServices'
	--,N'CancelNoShowComment'
	--,N'FROM CustomServices cs  JOIN Services s ON s.ServiceId = cs.ServiceId   where cs.ServiceId = @ServiceId and  isnull(CancelNoShowComment, '''')= '''' AND  s.[Status] IN (72,73)'
	--,N'Custom Fields – Cancel/No Show comment is required'
	--,CAST(3 AS DECIMAL(18, 0))
	--,N'Custom Fields – Cancel/No Show comment is required'
	--),
	--(
	--N'Y'
	--,11145
	--,NULL
	--,'Service'
	--,4
	--,N'CustomServices'
	--,N'Specify'
	--,N'FROM CustomServices cs  JOIN Services s ON s.ServiceId = cs.ServiceId   where cs.ServiceId = @ServiceId AND isnull(cs.Specify, '''')= '''' and  (cs.FamilyMembers = ''Y'' OR cs.InternalCollateral = ''Y'' OR cs.ExternalCollateral = ''Y'')'
	--,N'Custom Fields – Specify: The names of the attendees is required'
	--,CAST(4 AS DECIMAL(18, 0))
	--,N'Custom Fields – Specify: The names of the attendees is required'
	--),
	--(
	--N'Y'
	--,11145
	--,NULL
	--,'General'
	--,5
	--,N'CustomIndividualServiceNoteDiagnoses'
	--,N'IndividualServiceNoteDiagnosisId'
	--,N'FROM CustomIndividualServiceNoteDiagnoses WHERE DocumentVersionId=@DocumentVersionId AND (Select Count(IndividualServiceNoteDiagnosisId) from CustomIndividualServiceNoteDiagnoses WHERE ISNULL(RecordDeleted,''N'')  = ''N'' AND DocumentVersionId=@DocumentVersionId) = 0'
	--,N'Note – Billing Diagnosis – at least one billing diagnosis is required'
	--,CAST(5 AS DECIMAL(18, 0))
	--,N'Note – Billing Diagnosis – at least one billing diagnosis is required'
	--),
	--(
	--N'Y'
	--,11145
	--,NULL
	--,'General'
	--,6
	--,N'CustomIndividualServiceNoteDiagnoses'
	--,N'Order'
	--,N'FROM CustomIndividualServiceNoteDiagnoses WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,''N'') = ''N'' AND (SELECT Count(IndividualServiceNoteDiagnosisId) FROM CustomIndividualServiceNoteDiagnoses WHERE ISNULL(RecordDeleted,''N'')  = ''N'' AND DocumentVersionId=@DocumentVersionId AND [Order] IS NOT NULL AND [Order] <> 9) = 0'
	--,N'Note – Billing Diagnosis – at least one billing diagnosis is required'
	--,CAST(6 AS DECIMAL(18, 0))
	--,N'Note – Billing Diagnosis – at least one billing diagnosis is required'
	--),
	--( 
	N'Y'
	,11145
	,NULL
	,'General'
	,7
	,N'CustomIndividualServiceNoteGoals'
	,N'ProgramId'
	,N'FROM CustomIndividualServiceNoteGoals WHERE DocumentVersionId=@DocumentVersionId AND (Select Count(IndividualServiceNoteGoalId) from CustomIndividualServiceNoteGoals WHERE ISNULL(RecordDeleted,''N'')  = ''N'' AND DocumentVersionId=@DocumentVersionId) = 0			AND EXISTS (
							 SELECT * FROM dbo.Clients c 
							 WHERE ISNULL(c.RecordDeleted,''N'')=''N''
							 AND c.ClientId = @ClientId 
							 AND (  c.ExternalClientId IS NULL --means client was not migrated in	
								OR ( c.ExternalClientId is NOT NULL AND CONVERT(DATE,GETDATE()) > ''7/1/2016'') 	)	
							and c.clientid not in (3006,3009)
							 
							
						  )'
	,N'General – Care Plan - At least one goal must be selected'
	,CAST(7 AS DECIMAL(18, 0))
	,N'General – Care Plan - At least one goal must be selected'
	),
	--( 
	--N'Y'
	--,11145
	--,NULL
	--,'General'
	--,3
	--,N'CustomIndividualServiceNoteObjectives'
	--,N'ProgramId'
	--,N'FROM CustomIndividualServiceNoteObjectives WHERE DocumentVersionId=@DocumentVersionId AND (Select Count(IndividualServiceNoteObjectiveId) from CustomIndividualServiceNoteObjectives WHERE ISNULL(RecordDeleted,''N'')  = ''N'' AND DocumentVersionId=@DocumentVersionId) = 0'
	--,N'General – Care Plan - At least one objective must be selected'
	--,CAST(3 AS DECIMAL(18, 0))
	--,N'General – Care Plan - At least one objective must be selected'
	--)
	(
	N'Y'
	,11145
	,NULL
	,'General'
	,8
	,N'CustomIndividualServiceNoteObjectives'
	,N'Status'
	,N'FROM CustomIndividualServiceNoteObjectives WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,''N'') = ''N'' AND CustomObjectiveActive = ''Y'' AND Status IS NULL'
	,N'Goals/Objectives – Objective status is required'
	,CAST(8 AS DECIMAL(18, 0))
	,N'Goals/Objectives – Objective status is required'
	),
	(
	N'Y'
	,11145
	,NULL
	,'General'
	,9
	,N'CustomDocumentIndividualServiceNoteGenerals'
	,N'MoodAffect'
	,N'FROM CustomDocumentIndividualServiceNoteGenerals WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,''N'') = ''N'' AND MoodAffect IS NULL'
	,N'General – Client''''s Current Condition - Mood/Affect must be specified'
	,CAST(9 AS DECIMAL(18, 0))
	,N'General – Client''''s Current Condition - Mood/Affect must be specified'
	),
	(
	N'Y'
	,11145
	,NULL
	,'General'
	,10
	,N'CustomDocumentIndividualServiceNoteGenerals'
	,N'MoodAffectComments'
	,N'FROM CustomDocumentIndividualServiceNoteGenerals WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,''N'') = ''N'' AND MoodAffect = ''Y'' AND MoodAffectComments IS NULL'
	,N'General– Client''''s Current Condition - Mood/Affect comment must be specified'
	,CAST(10 AS DECIMAL(18, 0))
	,N'General– Client''''s Current Condition - Mood/Affect comment must be specified'
	),
	(
	N'Y'
	,11145
	,NULL
	,'General'
	,11
	,N'CustomDocumentIndividualServiceNoteGenerals'
	,N'ThoughtProcess'
	,N'FROM CustomDocumentIndividualServiceNoteGenerals WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,''N'') = ''N'' AND ThoughtProcess IS NULL'
	,N'General – Client''''s Current Condition - Thought Process/Orientation must be specified'
	,CAST(11 AS DECIMAL(18, 0))
	,N'General – Client''''s Current Condition - Thought Process/Orientation must be specified'
	),
	(
	N'Y'
	,11145
	,NULL
	,'General'
	,12
	,N'CustomDocumentIndividualServiceNoteGenerals'
	,N'ThoughtProcessComments'
	,N'FROM CustomDocumentIndividualServiceNoteGenerals WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,''N'') = ''N'' AND ThoughtProcess = ''Y'' AND ThoughtProcessComments IS NULL'
	,N'General – Client''''s Current Condition - Thought Process/Orientation comment must be specified'
	,CAST(12 AS DECIMAL(18, 0))
	,N'General – Client''''s Current Condition - Thought Process/Orientation comment must be specified'
	),
	(
	N'Y'
	,11145
	,NULL
	,'General'
	,13
	,N'CustomDocumentIndividualServiceNoteGenerals'
	,N'Behavior'
	,N'FROM CustomDocumentIndividualServiceNoteGenerals WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,''N'') = ''N'' AND Behavior IS NULL'
	,N'General– Client''''s Current Condition - Behavior/Functioning must be specified'
	,CAST(13 AS DECIMAL(18, 0))
	,N'General– Client''''s Current Condition - Behavior/Functioning must be specified'
	),
	(
	N'Y'
	,11145
	,NULL
	,'General'
	,14
	,N'CustomDocumentIndividualServiceNoteGenerals'
	,N'BehaviorComments'
	,N'FROM CustomDocumentIndividualServiceNoteGenerals WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,''N'') = ''N'' AND Behavior = ''Y'' AND BehaviorComments IS NULL'
	,N'General– Client''''s Current Condition - Behavior/Functioning comment must be specified'
	,CAST(14 AS DECIMAL(18, 0))
	,N'General– Client''''s Current Condition - Behavior/Functioning comment must be specified'
	),
	(
	N'Y'
	,11145
	,NULL
	,'General'
	,15
	,N'CustomDocumentIndividualServiceNoteGenerals'
	,N'MedicalCondition'
	,N'FROM CustomDocumentIndividualServiceNoteGenerals WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,''N'') = ''N'' AND MedicalCondition IS NULL'
	,N'General –Client''''s Current Condition -  Medical Condition must be specified'
	,CAST(15 AS DECIMAL(18, 0))
	,N'General –Client''''s Current Condition -  Medical Condition must be specified'
	),
	(
	N'Y'
	,11145
	,NULL
	,'General'
	,16
	,N'CustomDocumentIndividualServiceNoteGenerals'
	,N'MedicalConditionComments'
	,N'FROM CustomDocumentIndividualServiceNoteGenerals WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,''N'') = ''N'' AND MedicalCondition = ''Y'' AND MedicalConditionComments IS NULL'
	,N'General –Client''''s Current Condition -  Medical Condition comments must be specified'
	,CAST(16 AS DECIMAL(18, 0))
	,N'General –Client''''s Current Condition -  Medical Condition comments must be specified'
	),
	(
	N'Y'
	,11145
	,NULL
	,'General'
	,17
	,N'CustomDocumentIndividualServiceNoteGenerals'
	,N'SubstanceAbuse'
	,N'FROM CustomDocumentIndividualServiceNoteGenerals WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,''N'') = ''N'' AND SubstanceAbuse IS NULL'
	,N'General –Client''''s Current Condition - Substance Abuse must be specified'
	,CAST(17 AS DECIMAL(18, 0))
	,N'General –Client''''s Current Condition - Substance Abuse must be specified'
	),
	(
	N'Y'
	,11145
	,NULL
	,'General'
	,18
	,N'CustomDocumentIndividualServiceNoteGenerals'
	,N'SubstanceAbuseComments'
	,N'FROM CustomDocumentIndividualServiceNoteGenerals WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,''N'') = ''N'' AND SubstanceAbuse = ''Y'' AND SubstanceAbuseComments IS NULL'
	,N'General –Client''''s Current Condition - Substance Abuse comment must be specified'
	,CAST(18 AS DECIMAL(18, 0))
	,N'General –Client''''s Current Condition - Substance Abuse comment must be specified'
	),
	(
	N'Y'
	,11145
	,NULL
	,'General'
	,19
	,N'CustomDocumentIndividualServiceNoteGenerals'
	,N'SelfHarm'
	,N'FROM CustomDocumentIndividualServiceNoteGenerals WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,''N'') = ''N'' AND SelfHarm = ''Y'' AND ISNULL(SelfHarmIdeation,''N'') = ''N'' AND ISNULL(SelfHarmIntent,''N'') = ''N'' AND ISNULL(SelfHarmAttempt,''N'') = ''N'' AND ISNULL(SelfHarmMeans,''N'') = ''N'' AND ISNULL(SelfHarmPlan,''N'') = ''N'' AND ISNULL(selfHarmOther,''N'') = ''N'' AND ISNULL(SelfHarmInformed,''N'') = ''N'''
	,N'General – Client''''s Current Condition – Self-Harm is required'
	,CAST(19 AS DECIMAL(18, 0))
	,N'General – Client''''s Current Condition – Self-Harm is required'
	),
	(
	N'Y'
	,11145
	,NULL
	,'General'
	,20
	,N'CustomDocumentIndividualServiceNoteGenerals'
	,N'SelfHarmOtherComments'
	,N'FROM CustomDocumentIndividualServiceNoteGenerals WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,''N'') = ''N'' AND selfHarmOther = ''Y'' AND SelfHarmOtherComments IS NULL'
	,N'General – Client''''s Current Condition – Self-Harm textbox is required'
	,CAST(20 AS DECIMAL(18, 0))
	,N'General – Client''''s Current Condition – Self-Harm textbox is required'
	),
	(
	N'Y'
	,11145
	,NULL
	,'General'
	,21
	,N'CustomDocumentIndividualServiceNoteGenerals'
	,N'SelfHarmInformedComments'
	,N'FROM CustomDocumentIndividualServiceNoteGenerals WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,''N'') = ''N'' AND SelfHarmInformed = ''Y'' AND SelfHarmInformedComments IS NULL'
	,N'General – Client''''s Current Condition – Self-Harm - I informed is required'
	,CAST(21 AS DECIMAL(18, 0))
	,N'General – Client''''s Current Condition – Self-Harm - I informed is required'
	),
	(
	N'Y'
	,11145
	,NULL
	,'General'
	,22
	,N'CustomDocumentIndividualServiceNoteGenerals'
	,N'HarmToOthersIdeation'
	,N'FROM CustomDocumentIndividualServiceNoteGenerals WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,''N'') = ''N'' AND HarmToOthers = ''Y'' AND ISNULL(HarmToOthersIdeation,''N'') = ''N'' AND ISNULL(HarmToOthersIntent,''N'') = ''N'' AND ISNULL(HarmToOthersAttempt,''N'') = ''N'' AND ISNULL(HarmToOthersMeans,''N'') = ''N'' AND ISNULL(HarmToOthersPlan,''N'') = ''N'' AND ISNULL(HarmToOthersOther,''N'') = ''N'' AND ISNULL(HarmToOthersInformed,''N'') = ''N'''
	,N'General – Client''''s Current Condition – Harm to Others is required'
	,CAST(22 AS DECIMAL(18, 0))
	,N'General – Client''''s Current Condition – Harm to Others is required'
	),
	(
	N'Y'
	,11145
	,NULL
	,'General'
	,23
	,N'CustomDocumentIndividualServiceNoteGenerals'
	,N'HarmToOthersOtherComments'
	,N'FROM CustomDocumentIndividualServiceNoteGenerals WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,''N'') = ''N'' AND HarmToOthersOther = ''Y'' AND HarmToOthersOtherComments IS NULL'
	,N'General – Client''''s Current Condition – Harm to Others textbox is required'
	,CAST(23 AS DECIMAL(18, 0))
	,N'General – Client''''s Current Condition – Harm to Others textbox is required'
	),
	(
	N'Y'
	,11145
	,NULL
	,'General'
	,24
	,N'CustomDocumentIndividualServiceNoteGenerals'
	,N'HarmToOthersInformedComments'
	,N'FROM CustomDocumentIndividualServiceNoteGenerals WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,''N'') = ''N'' AND HarmToOthersInformed = ''Y'' AND HarmToOthersInformedComments IS NULL'
	,N'General – Client''''s Current Condition – Harm to Others - I informed is required'
	,CAST(24 AS DECIMAL(18, 0))
	,N'General – Client''''s Current Condition – Harm to Others - I informed is required'
	),
	(
	N'Y'
	,11145
	,NULL
	,'General'
	,25
	,N'CustomDocumentIndividualServiceNoteGenerals'
	,N'HarmToPropertyIdeation'
	,N'FROM CustomDocumentIndividualServiceNoteGenerals WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,''N'') = ''N'' AND HarmToProperty = ''Y'' AND ISNULL(HarmToPropertyIdeation,''N'') = ''N'' AND ISNULL(HarmToPropertyIntent,''N'') = ''N'' AND ISNULL(HarmToPropertyAttempt,''N'') = ''N'' AND ISNULL(HarmToPropertyMeans,''N'') = ''N'' AND ISNULL(HarmToPropertyPlan,''N'') = ''N'' AND ISNULL(HarmToPropertyOther,''N'') = ''N'' AND ISNULL(HarmToPropertyInformed,''N'') = ''N'''
	,N'General – Client''''s Current Condition – Harm to Property is required'
	,CAST(25 AS DECIMAL(18, 0))
	,N'General – Client''''s Current Condition – Harm to Property is required'
	),
	(
	N'Y'
	,11145
	,NULL
	,'General'
	,26
	,N'CustomDocumentIndividualServiceNoteGenerals'
	,N'HarmToPropertyOtherComments'
	,N'FROM CustomDocumentIndividualServiceNoteGenerals WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,''N'') = ''N'' AND HarmToPropertyOther = ''Y'' AND HarmToPropertyOtherComments IS NULL'
	,N'General – Client''''s Current Condition – Harm to Property textbox is required'
	,CAST(26 AS DECIMAL(18, 0))
	,N'General – Client''''s Current Condition – Harm to Property textbox is required'
	),
	(
	N'Y'
	,11145
	,NULL
	,'General'
	,27
	,N'CustomDocumentIndividualServiceNoteGenerals'
	,N'HarmToPropertyInformedComments'
	,N'FROM CustomDocumentIndividualServiceNoteGenerals WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,''N'') = ''N'' AND HarmToPropertyInformed = ''Y'' AND HarmToPropertyInformedComments IS NULL'
	,N'General – Client''''s Current Condition – Harm to Property - I informed is required'
	,CAST(27 AS DECIMAL(18, 0))
	,N'General – Client''''s Current Condition – Harm to Property - I informed is required'
	),
	(
	N'Y'
	,11145
	,NULL
	,'General'
	,28
	,N'CustomDocumentIndividualServiceNoteGenerals'
	,N'SafetyPlanwasReviewed'
	,N'FROM CustomDocumentIndividualServiceNoteGenerals WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,''N'') = ''N'' AND (SelfHarm = ''Y'' OR HarmToOthers = ''Y'' OR HarmToProperty = ''Y'') AND ISNULL(SafetyPlanwasReviewed,''N'') = ''N'''
	,N'General – Safety Plan – The Safety Plan was Reviewed is required'
	,CAST(28 AS DECIMAL(18, 0))
	,N'General – Safety Plan – The Safety Plan was Reviewed is required'
	),
	(
	N'Y'
	,11145
	,NULL
	,'General'
	,29
	,N'CustomDocumentIndividualServiceNoteGenerals'
	,N'WithOrWithOutClient'
	,N'FROM CustomDocumentIndividualServiceNoteGenerals WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,''N'') = ''N'' AND WithOrWithOutClient IS NULL'
	,N'General – Safety Plan – With the client or Without the client is required'
	,CAST(29 AS DECIMAL(18, 0))
	,N'General – Safety Plan – With the client or Without the client is required'
	),
	(
	N'Y'
	,11145
	,NULL
	,'General'
	,30
	,N'CustomDocumentIndividualServiceNoteGenerals'
	,N'NextSteps'
	,N'FROM CustomDocumentIndividualServiceNoteGenerals WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,''N'') = ''N'' AND ISNULL(SafetyPlanwasReviewed,''N'') = ''Y'' AND NextSteps IS NULL'
	,N'General – Safety Plan – Next Steps is required'
	,CAST(30 AS DECIMAL(18, 0))
	,N'General – Safety Plan – Next Steps is required'
	),
	(
	N'Y'
	,11145
	,NULL
	,'General'
	,31
	,N'CustomDocumentIndividualServiceNoteGenerals'
	,N'FocusOfTheSession'
	,N'FROM CustomDocumentIndividualServiceNoteGenerals WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,''N'') = ''N'' AND FocusOfTheSession IS NULL'
	,N'General – Intervention/Progress – What was the focus of the session is required'
	,CAST(31 AS DECIMAL(18, 0))
	,N'General – Intervention/Progress – What was the focus of the session is required'
	),
	(
	N'Y'
	,11145
	,NULL
	,'General'
	,32
	,N'CustomDocumentIndividualServiceNoteGenerals'
	,N'InterventionsProvided'
	,N'FROM CustomDocumentIndividualServiceNoteGenerals WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,''N'') = ''N'' AND InterventionsProvided IS NULL'
	,N'General – Intervention/Progress - Describe the interventions provided is required'
	,CAST(32 AS DECIMAL(18, 0))
	,N'General – Intervention/Progress - Describe the interventions provided is required'
	),
	(
	N'Y'
	,11145
	,NULL
	,'General'
	,33
	,N'CustomDocumentIndividualServiceNoteGenerals'
	,N'ProgressMade'
	,N'FROM CustomDocumentIndividualServiceNoteGenerals WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,''N'') = ''N'' AND ProgressMade IS NULL'
	,N'General – Intervention/Progress - Describe the client''''s response to the intervention is required'
	,CAST(33 AS DECIMAL(18, 0))
	,N'General – Intervention/Progress - Describe the client''''s response to the intervention is required'
	),
	(
	N'Y'
	,11145
	,NULL
	,'General'
	,34
	,N'CustomDocumentIndividualServiceNoteGenerals'
	,N'Overcome'
	,N'FROM CustomDocumentIndividualServiceNoteGenerals WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,''N'') = ''N'' AND Overcome IS NULL'
	,N'General – Intervention/Progress - Document the need for continued services and the plan is required'
	,CAST(34 AS DECIMAL(18, 0))
	,N'General – Intervention/Progress - Document the need for continued services and the plan is required'
	)