--Select *  from DocumentValidations where DocumentCodeId=60000
--FROM CustomDocumentPsychiatricNoteExams WHERE DocumentVersionId=@DocumentVersionId AND   ISNULL(MusculoskeletalMuscleNormal,'N')='N' And  ISNULL(MusculoskeletalMuscleAbnormal,'N')='N' And ISNULL(MusculoskeletalMuscleTicsTremors,'N')='N' And ISNULL(MusculoskeletalMuscleEPS,'N')='N' And  ISNULL(MusculoskeletalMuscleTone,'N')='N'
--FROM CustomDocumentPsychiatricNoteExams WHERE DocumentVersionId=@DocumentVersionId AND   ISNULL(GaitStationNormal,'N')='N' And  ISNULL(GaitStationAbnormal,'N')='N'  

UPDATE DocumentValidations SET Active='N',RecordDeleted='Y' WHERE DocumentCodeId=60000 AND TableName='CustomDocumentPsychiatricNoteGenerals' AND  ErrorMessage='Review of Systems – at least one check box is required' 
UPDATE DocumentValidations SET ValidationLogic='FROM CustomDocumentPsychiatricNoteExams WHERE DocumentVersionId=@DocumentVersionId AND 
ISNULL(MusculoskeletalMuscleNormal,''N'')=''N'' And
ISNULL(MusculoskeletalMuscleAbnormal,''N'')=''N'' And ISNULL(MusculoskeletalMuscleTicsTremors,''N'')=''N'' And ISNULL(MusculoskeletalMuscleEPS,''N'')=''N'' And
ISNULL(MusculoskeletalMuscleTone,''N'')=''N'' AND 
ISNULL(GaitStationNormal,''N'')=''N'' And
ISNULL(GaitStationAbnormal,''N'')=''N'' ' WHERE DocumentCodeId=60000 AND TableName='CustomDocumentPsychiatricNoteExams' AND  ErrorMessage='Musculoskeletal is required' 
UPDATE DocumentValidations SET ValidationLogic='FROM CustomDocumentPsychiatricNoteExams WHERE DocumentVersionId=@DocumentVersionId AND 
ISNULL(GaitStationNormal,''N'')=''N'' And
ISNULL(GaitStationAbnormal,''N'')=''N'' AND 
ISNULL(MusculoskeletalMuscleNormal,''N'')=''N'' And
ISNULL(MusculoskeletalMuscleAbnormal,''N'')=''N'' And ISNULL(MusculoskeletalMuscleTicsTremors,''N'')=''N'' And ISNULL(MusculoskeletalMuscleEPS,''N'')=''N'' And
ISNULL(MusculoskeletalMuscleTone,''N'')=''N'' ' WHERE DocumentCodeId=60000 AND TableName='CustomDocumentPsychiatricNoteExams' AND  ErrorMessage='Gait and Station is required' 
