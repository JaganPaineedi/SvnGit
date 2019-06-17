--SELECT * FROM Documentvalidations where ERRORMessage like '%Medical History comment box is required%' and DocumentcodeId=60000
--SELECT * FROM Documentvalidations where ERRORMessage like '%Musculoskeletal is required%' and DocumentcodeId=60000
--SELECT * FROM Documentvalidations where ERRORMessage like '%Gait and Station is required%' and DocumentcodeId=60000
--SELECT * FROM Documentvalidations where ERRORMessage like '%Alert and Oriented X4 is required%' and DocumentcodeId=60000
--SELECT * FROM Documentvalidations where ERRORMessage like '%Grooming and Hygiene is required%' and DocumentcodeId=60000
--SELECT * FROM Documentvalidations where ERRORMessage like '%Eye contact is required%' and DocumentcodeId=60000
--SELECT * FROM Documentvalidations where ERRORMessage like '%Cooperative/Pleasant is required%' and DocumentcodeId=60000
--SELECT * FROM Documentvalidations where ERRORMessage like '%Psychomotor is required%' and DocumentcodeId=60000
--SELECT * FROM Documentvalidations where ERRORMessage like '%Affect is required%' and DocumentcodeId=60000
--SELECT * FROM Documentvalidations where ERRORMessage like '%Thought Processes is required%' and DocumentcodeId=60000
--SELECT * FROM Documentvalidations where ERRORMessage like '%Suicidal is required%' and DocumentcodeId=60000
--SELECT * FROM Documentvalidations where ERRORMessage like '%Homicidal is required%' and DocumentcodeId=60000
--SELECT * FROM Documentvalidations where ERRORMessage like '%Memory and Recall is required%' and DocumentcodeId=60000
--SELECT * FROM Documentvalidations where ERRORMessage like '%Intelligence is required%' and DocumentcodeId=60000
--SELECT * FROM Documentvalidations where ERRORMessage like '%Mood is required%' and DocumentcodeId=60000

Update Documentvalidations set ValidationLogic='FROM CustomDocumentPsychiatricNoteExams WHERE DocumentVersionId=@DocumentVersionId AND InsightAndJudgement is null'  where ERRORMessage like '%Insight and judgment is required%' and DocumentcodeId=60000

Update Documentvalidations set ValidationLogic='FROM CustomDocumentPsychiatricNoteExams WHERE DocumentVersionId=@DocumentVersionId AND 
ISNULL(MoodHappy,''N'')=''N'' And
ISNULL(MoodSad,''N'')=''N'' And
ISNULL(MoodAnxious,''N'')=''N'' And
ISNULL(MoodAngry,''N'')=''N'' And
ISNULL(MoodIrritable,''N'')=''N'' And
ISNULL(MoodElation,''N'')=''N'' And
ISNULL(MoodNormal,''N'')=''N'' '  where ERRORMessage like '%Mood is required%' and DocumentcodeId=60000


Update Documentvalidations set ValidationLogic='FROM CustomDocumentPsychiatricNoteExams WHERE DocumentVersionId=@DocumentVersionId AND 
ISNULL(AffectEuthymic,''N'')=''N'' And
ISNULL(AffectDysphoric,''N'')=''N'' And
ISNULL(AffectAnxious,''N'')=''N'' And
ISNULL(AffectIrritable,''N'')=''N'' And
ISNULL(AffectBlunted,''N'')=''N'' And
ISNULL(AffectLabile,''N'')=''N'' And
ISNULL(AffectEuphoric,''N'')=''N'' And
ISNULL(AffectCongruent,''N'')=''N'' ' where ERRORMessage like '%Mood and affect is required%' and DocumentcodeId=60000
Update Documentvalidations Set ERRORMessage='Affect is required'  where ERRORMessage like '%Mood and affect is required%' and DocumentcodeId=60000

UPDATE Documentvalidations set Active='N' WHERE ERRORMessage like '%Medical History comment box is required%' and DocumentcodeId=60000
UPDATE Documentvalidations set Active='N' where ERRORMessage like '%Musculoskeletal is required%' and DocumentcodeId=60000
UPDATE Documentvalidations set Active='N' where ERRORMessage like '%Gait and Station is required%' and DocumentcodeId=60000
UPDATE Documentvalidations set Active='N' where ERRORMessage like '%Alert and Oriented X4 is required%' and DocumentcodeId=60000
UPDATE Documentvalidations set Active='N' where ERRORMessage like '%Grooming and Hygiene is required%' and DocumentcodeId=60000
UPDATE Documentvalidations set Active='N' where ERRORMessage like '%Eye contact is required%' and DocumentcodeId=60000
UPDATE Documentvalidations set Active='N' where ERRORMessage like '%Cooperative/Pleasant is required%' and DocumentcodeId=60000
UPDATE Documentvalidations set Active='N' where ERRORMessage like '%Psychomotor is required%' and DocumentcodeId=60000
--UPDATE Documentvalidations set Active='Y' where ERRORMessage like '%Mood and affect is required%' and DocumentcodeId=60000
UPDATE Documentvalidations set Active='N' where ERRORMessage like '%Thought Processes is required%' and DocumentcodeId=60000
UPDATE Documentvalidations set Active='N' where ERRORMessage like '%Suicidal is required%' and DocumentcodeId=60000
UPDATE Documentvalidations set Active='N' where ERRORMessage like '%Homicidal is required%' and DocumentcodeId=60000
UPDATE Documentvalidations set Active='N' where ERRORMessage like '%Memory and Recall is required%' and DocumentcodeId=60000
UPDATE Documentvalidations set Active='N' where ERRORMessage like '%Intelligence is required%' and DocumentcodeId=60000
UPDATE Documentvalidations set Active='N' where ERRORMessage like '%Insight and judgment is required%' and DocumentcodeId=60000