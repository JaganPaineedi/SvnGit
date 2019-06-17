INSERT INTO DocumentValidations 
( Active, DocumentCodeId, DocumentType, TabName, TabOrder, ValidationOrder, ValidationDescription, 
  TableName, ColumnName, ErrorMessage, ValidationLogic)
VALUES 
('Y', 12500, 10, 'Document Type', 1, 1, '',
'CustomDocumentCANSGenerals', 'DocumentType', 'Document Type is missing', 
'FROM CustomDocumentCANSGenerals WHERE ISNULL(DocumentType,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId')


INSERT INTO DocumentValidations 
( Active, DocumentCodeId, DocumentType, TabName, TabOrder, ValidationOrder, ValidationDescription, 
  TableName, ColumnName, ErrorMessage, ValidationLogic)
VALUES 
('Y', 12500, 10, 'Problem Presentation', 2, 1, '',
'CustomDocumentCANSGenerals', 'Psychosis', 'Psychosis is missing',
'FROM CustomDocumentCANSGenerals WHERE ISNULL(Psychosis,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Problem Presentation', 2, 2, '',
'CustomDocumentCANSGenerals', 'AngerManagement', 'Anger Management is missing',
'FROM CustomDocumentCANSGenerals WHERE ISNULL(AngerManagement,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Problem Presentation', 2, 3, '',
'CustomDocumentCANSGenerals', 'SubstanceAbuse', 'Substance Abuse is missing',
'FROM CustomDocumentCANSGenerals WHERE ISNULL(SubstanceAbuse,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Problem Presentation', 2, 4, '',
'CustomDocumentCANSGenerals', 'DepressionAnxiety', 'Depression Anxiety is missing',
'FROM CustomDocumentCANSGenerals WHERE ISNULL(DepressionAnxiety,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Problem Presentation', 2, 5, '',
'CustomDocumentCANSGenerals', 'Attachment', 'Attachment is missing',
'FROM CustomDocumentCANSGenerals WHERE ISNULL(Attachment,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Problem Presentation', 2, 6, '',
'CustomDocumentCANSGenerals', 'AttentionDefictImpluse', 'Attention Defict Impluse is missing',
'FROM CustomDocumentCANSGenerals WHERE ISNULL(AttentionDefictImpluse,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Problem Presentation', 2, 7, '',
'CustomDocumentCANSGenerals', 'AdjustmenttoTrauma', 'Adjustment to Trauma is missing',
'FROM CustomDocumentCANSGenerals WHERE ISNULL(AdjustmenttoTrauma,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Problem Presentation', 2, 8, '',
'CustomDocumentCANSGenerals', 'OppositionalBehavior', 'Oppositional Behavior is missing',
'FROM CustomDocumentCANSGenerals WHERE ISNULL(OppositionalBehavior,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Problem Presentation', 2, 9, '',
'CustomDocumentCANSGenerals', 'AntisocialBehavior', 'Antisocial Behavior is missing',
'FROM CustomDocumentCANSGenerals WHERE ISNULL(AntisocialBehavior,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId')



INSERT INTO DocumentValidations 
( Active, DocumentCodeId, DocumentType, TabName, TabOrder, ValidationOrder, ValidationDescription, 
  TableName, ColumnName, ErrorMessage, ValidationLogic)
VALUES 
('Y', 12500, 10, 'Life Domain Functioning', 3, 1, '',
'CustomDocumentCANSGenerals', 'LDFJobFunctioning', 'Job Functioning is missing',
'FROM CustomDocumentCANSGenerals WHERE ISNULL(LDFJobFunctioning,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Life Domain Functioning', 3, 2, '',
'CustomDocumentCANSGenerals', 'LDFPhysicalMedical', 'Physical/Medical is missing',
'FROM CustomDocumentCANSGenerals WHERE ISNULL(LDFPhysicalMedical,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Life Domain Functioning', 3, 3, '',
'CustomDocumentCANSGenerals', 'LDFLivingSituation', 'Living Situation is missing',
'FROM CustomDocumentCANSGenerals WHERE ISNULL(LDFLivingSituation,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Life Domain Functioning', 3, 4, '',
'CustomDocumentCANSGenerals', 'LDFSchoolBehavior', 'School Behavior is missing',
'FROM CustomDocumentCANSGenerals WHERE ISNULL(LDFSchoolBehavior,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Life Domain Functioning', 3, 5, '',
'CustomDocumentCANSGenerals', 'LDFSexualDevelopment', 'Sexual Development is missing',
'FROM CustomDocumentCANSGenerals WHERE ISNULL(LDFSexualDevelopment,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Life Domain Functioning', 3, 6, '',
'CustomDocumentCANSGenerals', 'LDFSleep', 'Sleep is missing',
'FROM CustomDocumentCANSGenerals WHERE ISNULL(LDFSleep,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Life Domain Functioning', 3, 7, '',
'CustomDocumentCANSGenerals', 'LDFFamily', 'Family is missing',
'FROM CustomDocumentCANSGenerals WHERE ISNULL(LDFFamily,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Life Domain Functioning', 3, 8, '',
'CustomDocumentCANSGenerals', 'LDFSchoolAchievement', 'School Achievement is missing',
'FROM CustomDocumentCANSGenerals WHERE ISNULL(LDFSchoolAchievement,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Life Domain Functioning', 3, 9, '',
'CustomDocumentCANSGenerals', 'LDFSchoolAttendance', 'School Attendance is missing',
'FROM CustomDocumentCANSGenerals WHERE ISNULL(LDFSchoolAttendance,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Life Domain Functioning', 3, 10, '',
'CustomDocumentCANSGenerals', 'LDFIntellectualDevelopmental', 'Intellectual Developmental is missing',
'FROM CustomDocumentCANSGenerals WHERE ISNULL(LDFIntellectualDevelopmental,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId')



INSERT INTO DocumentValidations 
( Active, DocumentCodeId, DocumentType, TabName, TabOrder, ValidationOrder, ValidationDescription, 
  TableName, ColumnName, ErrorMessage, ValidationLogic)
VALUES 
('Y', 12500, 10, 'Caregiver Needs & Strengths', 4, 1, '',
'CustomDocumentCANSGenerals', 'Safety', 'Safety is missing',
'FROM CustomDocumentCANSGenerals WHERE ISNULL(Safety,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Caregiver Needs & Strengths', 4, 2, '',
'CustomDocumentCANSGenerals', 'Resources', 'Resources is missing',
'FROM CustomDocumentCANSGenerals WHERE ISNULL(Resources,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Caregiver Needs & Strengths', 4, 3, '',
'CustomDocumentCANSGenerals', 'Supervision', 'Supervision is missing',
'FROM CustomDocumentCANSGenerals WHERE ISNULL(Supervision,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Caregiver Needs & Strengths', 4, 4, '',
'CustomDocumentCANSGenerals', 'Knowledge', 'Knowledge is missing',
'FROM CustomDocumentCANSGenerals WHERE ISNULL(Knowledge,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Caregiver Needs & Strengths', 4, 5, '',
'CustomDocumentCANSGenerals', 'Involvement', 'Involvement is missing',
'FROM CustomDocumentCANSGenerals WHERE ISNULL(Involvement,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Caregiver Needs & Strengths', 4, 6, '',
'CustomDocumentCANSGenerals', 'Organization', 'Organization is missing',
'FROM CustomDocumentCANSGenerals WHERE ISNULL(Organization,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Caregiver Needs & Strengths', 4, 7, '',
'CustomDocumentCANSGenerals', 'Development', 'Development is missing',
'FROM CustomDocumentCANSGenerals WHERE ISNULL(Development,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Caregiver Needs & Strengths', 4, 8, '',
'CustomDocumentCANSGenerals', 'PhysicalBehavioralHealth', 'Physical Behavioral Health is missing',
'FROM CustomDocumentCANSGenerals WHERE ISNULL(PhysicalBehavioralHealth,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Caregiver Needs & Strengths', 4, 9, '',
'CustomDocumentCANSGenerals', 'ResidentialStability', 'Residential Stability is missing',
'FROM CustomDocumentCANSGenerals WHERE ISNULL(ResidentialStability,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId')


INSERT INTO DocumentValidations 
( Active, DocumentCodeId, DocumentType, TabName, TabOrder, ValidationOrder, ValidationDescription, 
  TableName, ColumnName, ErrorMessage, ValidationLogic)
VALUES 
('Y', 12500, 10, 'Child Safety', 5, 1, '',
'CustomDocumentCANSGenerals', 'Abuse', 'Abuse is missing',
'FROM CustomDocumentCANSGenerals WHERE ISNULL(Abuse,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Child Safety', 5, 2, '',
'CustomDocumentCANSGenerals', 'Neglect', 'Neglect is missing',
'FROM CustomDocumentCANSGenerals WHERE ISNULL(Neglect,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Child Safety', 5, 3, '',
'CustomDocumentCANSGenerals', 'Exploitation', 'Exploitation is missing',
'FROM CustomDocumentCANSGenerals WHERE ISNULL(Exploitation,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Child Safety', 5, 4, '',
'CustomDocumentCANSGenerals', 'Permanency', 'Permanency is missing',
'FROM CustomDocumentCANSGenerals WHERE ISNULL(Permanency,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Child Safety', 5, 5, '',
'CustomDocumentCANSGenerals', 'ChildSafety', 'Child Safety is missing',
'FROM CustomDocumentCANSGenerals WHERE ISNULL(ChildSafety,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Child Safety', 5, 6, '',
'CustomDocumentCANSGenerals', 'EmotionalCloseness', 'Emotional Closeness is missing',
'FROM CustomDocumentCANSGenerals WHERE ISNULL(EmotionalCloseness,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId')




INSERT INTO DocumentValidations 
( Active, DocumentCodeId, DocumentType, TabName, TabOrder, ValidationOrder, ValidationDescription, 
  TableName, ColumnName, ErrorMessage, ValidationLogic)
VALUES 
('Y', 12500, 10, 'Youth Strengths', 6, 1, '',
'CustomDocumentCANSYouthStrengths', 'Family', 'Family is missing', 
'FROM CustomDocumentCANSYouthStrengths WHERE ISNULL(Family,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Youth Strengths', 6, 2, '',
'CustomDocumentCANSYouthStrengths', 'Optimism', 'Optimism is missing', 
'FROM CustomDocumentCANSYouthStrengths WHERE ISNULL(Optimism,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Youth Strengths', 6, 3, '',
'CustomDocumentCANSYouthStrengths', 'Vocational', 'Vocational is missing', 
'FROM CustomDocumentCANSYouthStrengths WHERE ISNULL(Vocational,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Youth Strengths', 6, 4, '',
'CustomDocumentCANSYouthStrengths', 'Resiliency', 'Resiliency is missing', 
'FROM CustomDocumentCANSYouthStrengths WHERE ISNULL(Resiliency,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Youth Strengths', 6, 5, '',
'CustomDocumentCANSYouthStrengths', 'Educational', 'Educational is missing', 
'FROM CustomDocumentCANSYouthStrengths WHERE ISNULL(Educational,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Youth Strengths', 6, 6, '',
'CustomDocumentCANSYouthStrengths', 'Interpersonal', 'Interpersonal is missing', 
'FROM CustomDocumentCANSYouthStrengths WHERE ISNULL(Interpersonal,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Youth Strengths', 6, 7, '',
'CustomDocumentCANSYouthStrengths', 'Resourcefulness', 'Resourcefulness is missing', 
'FROM CustomDocumentCANSYouthStrengths WHERE ISNULL(Resourcefulness,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Youth Strengths', 6, 8, '',
'CustomDocumentCANSYouthStrengths', 'CommunityLife', 'Community Life is missing', 
'FROM CustomDocumentCANSYouthStrengths WHERE ISNULL(CommunityLife,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Youth Strengths', 6, 9, '',
'CustomDocumentCANSYouthStrengths', 'TalentInterests', 'Talents/Interests is missing', 
'FROM CustomDocumentCANSYouthStrengths WHERE ISNULL(TalentInterests,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Youth Strengths', 6, 10, '',
'CustomDocumentCANSYouthStrengths', 'SpiritualReligious', 'Spiritual/Religious is missing', 
'FROM CustomDocumentCANSYouthStrengths WHERE ISNULL(SpiritualReligious,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Youth Strengths', 6, 11, '',
'CustomDocumentCANSYouthStrengths', 'RelationPerformance', 'Relation Performance is missing', 
'FROM CustomDocumentCANSYouthStrengths WHERE ISNULL(RelationPerformance,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId')


INSERT INTO DocumentValidations 
( Active, DocumentCodeId, DocumentType, TabName, TabOrder, ValidationOrder, ValidationDescription, 
  TableName, ColumnName, ErrorMessage, ValidationLogic)
VALUES 
('Y', 12500, 10, 'Risk Behaviors', 7, 1, '',
'CustomDocumentCANSYouthStrengths', 'DangertoSelf', 'Danger to Self is missing', 
'FROM CustomDocumentCANSYouthStrengths WHERE ISNULL(DangertoSelf,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Risk Behaviors', 7, 2, '',
'CustomDocumentCANSYouthStrengths', 'ViolentThinking', 'Violent Thinking is missing', 
'FROM CustomDocumentCANSYouthStrengths WHERE ISNULL(ViolentThinking,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Risk Behaviors', 7, 3, '',
'CustomDocumentCANSYouthStrengths', 'Elopement', 'Elopement is missing', 
'FROM CustomDocumentCANSYouthStrengths WHERE ISNULL(Elopement,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Risk Behaviors', 7, 4, '',
'CustomDocumentCANSYouthStrengths', 'SocialBehavior', 'Social Behavior is missing', 
'FROM CustomDocumentCANSYouthStrengths WHERE ISNULL(SocialBehavior,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Risk Behaviors', 7, 5, '',
'CustomDocumentCANSYouthStrengths', 'OtherSelfHarm', 'Other Self Harm is missing', 
'FROM CustomDocumentCANSYouthStrengths WHERE ISNULL(OtherSelfHarm,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Risk Behaviors', 7, 6, '',
'CustomDocumentCANSYouthStrengths', 'DangertoOthers', 'Danger to Others is missing', 
'FROM CustomDocumentCANSYouthStrengths WHERE ISNULL(DangertoOthers,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Risk Behaviors', 7, 7, '',
'CustomDocumentCANSYouthStrengths', 'CrimeDelinquency', 'Crime/Delinquency is missing', 
'FROM CustomDocumentCANSYouthStrengths WHERE ISNULL(CrimeDelinquency,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Risk Behaviors', 7, 8, '',
'CustomDocumentCANSYouthStrengths', 'Commitment', 'Commitment to Self-Control is missing', 
'FROM CustomDocumentCANSYouthStrengths WHERE ISNULL(Commitment,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Risk Behaviors', 7, 9, '',
'CustomDocumentCANSYouthStrengths', 'SexuallyAbusive', 'Sexually Abusive Behavior is missing', 
'FROM CustomDocumentCANSYouthStrengths WHERE ISNULL(SexuallyAbusive,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Risk Behaviors', 7, 10, '',
'CustomDocumentCANSYouthStrengths', 'SchoolBehavior', 'School Behavior is missing', 
'FROM CustomDocumentCANSYouthStrengths WHERE ISNULL(SchoolBehavior,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId'),
('Y', 12500, 10, 'Risk Behaviors', 7, 11, '',
'CustomDocumentCANSYouthStrengths', 'SexualDevelopment', 'Sexual Development is missing', 
'FROM CustomDocumentCANSYouthStrengths WHERE ISNULL(SexualDevelopment,'''')='''' AND ISNULL (RecordDeleted,''N'')=''N'' AND DocumentVersionId = @DocumentVersionId')



INSERT INTO DocumentValidations 
( Active, DocumentCodeId, DocumentType, TabName, TabOrder, ValidationOrder, ValidationDescription, 
  TableName, ColumnName, ErrorMessage, ValidationLogic)
VALUES 
('Y', 12500, 10, 'Substance Abuse Module', 8, 1, '',
'CustomDocumentCANSModules', 'SeverityofUse', 'Severity of Use is missing', 
'FROM CustomDocumentCANSModules a JOIN CustomDocumentCANSGenerals b ON a.DocumentVersionId = b.DocumentVersionId
WHERE ISNULL(a.SeverityofUse,'''')='''' AND b.SubstanceAbuse in (''1'',''2'',''3'') AND a.DocumentVersionId = @DocumentVersionId
AND ISNULL (a.RecordDeleted,''N'')=''N'' AND ISNULL (b.RecordDeleted,''N'')=''N'''),
('Y', 12500, 10, 'Substance Abuse Module', 8, 2, '',
'CustomDocumentCANSModules', 'DurationofUse', 'Duration of Use is missing', 
'FROM CustomDocumentCANSModules a JOIN CustomDocumentCANSGenerals b ON a.DocumentVersionId = b.DocumentVersionId
WHERE ISNULL(a.DurationofUse,'''')='''' AND b.SubstanceAbuse in (''1'',''2'',''3'') AND a.DocumentVersionId = @DocumentVersionId
AND ISNULL (a.RecordDeleted,''N'')=''N'' AND ISNULL (b.RecordDeleted,''N'')=''N'''),
('Y', 12500, 10, 'Substance Abuse Module', 8, 3, '',
'CustomDocumentCANSModules', 'PeerInfluences', 'Peer Influences is missing', 
'FROM CustomDocumentCANSModules a JOIN CustomDocumentCANSGenerals b ON a.DocumentVersionId = b.DocumentVersionId
WHERE ISNULL(a.PeerInfluences,'''')='''' AND b.SubstanceAbuse in (''1'',''2'',''3'') AND a.DocumentVersionId = @DocumentVersionId
AND ISNULL (a.RecordDeleted,''N'')=''N'' AND ISNULL (b.RecordDeleted,''N'')=''N'''),
('Y', 12500, 10, 'Substance Abuse Module', 8, 4, '',
'CustomDocumentCANSModules', 'StageofRecovery', 'Stage of Recovery is missing', 
'FROM CustomDocumentCANSModules a JOIN CustomDocumentCANSGenerals b ON a.DocumentVersionId = b.DocumentVersionId
WHERE ISNULL(a.StageofRecovery,'''')='''' AND b.SubstanceAbuse in (''1'',''2'',''3'') AND a.DocumentVersionId = @DocumentVersionId
AND ISNULL (a.RecordDeleted,''N'')=''N'' AND ISNULL (b.RecordDeleted,''N'')=''N'''),
('Y', 12500, 10, 'Substance Abuse Module', 8, 5, '',
'CustomDocumentCANSModules', 'ParentalInfluences', 'Parental Influences is missing', 
'FROM CustomDocumentCANSModules a JOIN CustomDocumentCANSGenerals b ON a.DocumentVersionId = b.DocumentVersionId
WHERE ISNULL(a.ParentalInfluences,'''')='''' AND b.SubstanceAbuse in (''1'',''2'',''3'') AND a.DocumentVersionId = @DocumentVersionId
AND ISNULL (a.RecordDeleted,''N'')=''N'' AND ISNULL (b.RecordDeleted,''N'')=''N''')


INSERT INTO DocumentValidations 
( Active, DocumentCodeId, DocumentType, TabName, TabOrder, ValidationOrder, ValidationDescription, 
  TableName, ColumnName, ErrorMessage, ValidationLogic)
VALUES 
('Y', 12500, 10, 'Trauma Module', 9, 1, '',
'CustomDocumentCANSModules', 'PhysicalAbuse', 'Physical Abuse is missing', 
'FROM CustomDocumentCANSModules a JOIN CustomDocumentCANSGenerals b ON a.DocumentVersionId = b.DocumentVersionId
WHERE ISNULL(a.PhysicalAbuse,'''')='''' AND b.AdjustmenttoTrauma in (''1'',''2'',''3'') AND a.DocumentVersionId = @DocumentVersionId
AND ISNULL (a.RecordDeleted,''N'')=''N'' AND ISNULL (b.RecordDeleted,''N'')=''N'''),
('Y', 12500, 10, 'Trauma Module', 9, 2, '',
'CustomDocumentCANSModules', 'EmotionalAbuse', 'Emotional Abuse is missing', 
'FROM CustomDocumentCANSModules a JOIN CustomDocumentCANSGenerals b ON a.DocumentVersionId = b.DocumentVersionId
WHERE ISNULL(a.EmotionalAbuse,'''')='''' AND b.AdjustmenttoTrauma in (''1'',''2'',''3'') AND a.DocumentVersionId = @DocumentVersionId
AND ISNULL (a.RecordDeleted,''N'')=''N'' AND ISNULL (b.RecordDeleted,''N'')=''N'''),
('Y', 12500, 10, 'Trauma Module', 9, 3, '',
'CustomDocumentCANSModules', 'WitnessofViolence', 'Witness of Violence is missing', 
'FROM CustomDocumentCANSModules a JOIN CustomDocumentCANSGenerals b ON a.DocumentVersionId = b.DocumentVersionId
WHERE ISNULL(a.WitnessofViolence,'''')='''' AND b.AdjustmenttoTrauma in (''1'',''2'',''3'') AND a.DocumentVersionId = @DocumentVersionId
AND ISNULL (a.RecordDeleted,''N'')=''N'' AND ISNULL (b.RecordDeleted,''N'')=''N'''),
('Y', 12500, 10, 'Trauma Module', 9, 4, '',
'CustomDocumentCANSModules', 'SexualAbuse', 'Sexual Abuse is missing', 
'FROM CustomDocumentCANSModules a JOIN CustomDocumentCANSGenerals b ON a.DocumentVersionId = b.DocumentVersionId
WHERE ISNULL(a.SexualAbuse,'''')='''' AND b.AdjustmenttoTrauma in (''1'',''2'',''3'') AND a.DocumentVersionId = @DocumentVersionId
AND ISNULL (a.RecordDeleted,''N'')=''N'' AND ISNULL (b.RecordDeleted,''N'')=''N'''),
('Y', 12500, 10, 'Trauma Module', 9, 5, '',
'CustomDocumentCANSModules', 'MedicalTrauma', 'Medical Trauma is missing', 
'FROM CustomDocumentCANSModules a JOIN CustomDocumentCANSGenerals b ON a.DocumentVersionId = b.DocumentVersionId
WHERE ISNULL(a.MedicalTrauma,'''')='''' AND b.AdjustmenttoTrauma in (''1'',''2'',''3'') AND a.DocumentVersionId = @DocumentVersionId
AND ISNULL (a.RecordDeleted,''N'')=''N'' AND ISNULL (b.RecordDeleted,''N'')=''N''')