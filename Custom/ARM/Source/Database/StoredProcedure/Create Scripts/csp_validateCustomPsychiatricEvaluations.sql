/****** Object:  StoredProcedure [dbo].[csp_validateCustomPsychiatricEvaluations]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomPsychiatricEvaluations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomPsychiatricEvaluations]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomPsychiatricEvaluations]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE       PROCEDURE [dbo].[csp_validateCustomPsychiatricEvaluations]
@DocumentVersionId	Int
as


--Load the document data into a temporary table to prevent multiple seeks on the document table
CREATE TABLE #CustomPsychiatricEvaluations
(
DocumentVersionId int,
IdentifyingData varchar(max),
ChiefComplaint varchar(max),
HistoryOfPresentIllness varchar(max),
PastPsychiatricHistory varchar(max),
MedicalHistory varchar(max),
SocialHistory varchar(max),
MentalStatusExam varchar(max),
Prognosis varchar(max),
OtherTherapyInterventionsPlanned1 varchar(max),
OtherTherapyInterventionsPlanned2 varchar(max),
MedicationCompliance varchar(max),
OtherConcernsNotAddressed varchar(max),
OtherIndividuals varchar(max),
PlanReviewFrequency varchar(max)
)
insert into #CustomPsychiatricEvaluations
(
DocumentVersionId ,
IdentifyingData,
ChiefComplaint ,
HistoryOfPresentIllness,
PastPsychiatricHistory ,
MedicalHistory,
SocialHistory ,
MentalStatusExam ,
Prognosis,
OtherTherapyInterventionsPlanned1 ,
OtherTherapyInterventionsPlanned2 ,
MedicationCompliance,
OtherConcernsNotAddressed ,
OtherIndividuals ,
PlanReviewFrequency 
)
select
a.DocumentVersionId,
a.IdentifyingData,
a.ChiefComplaint ,
a.HistoryOfPresentIllness,
a.PastPsychiatricHistory ,
a.MedicalHistory,
a.SocialHistory ,
a.MentalStatusExam ,
a.Prognosis,
a.OtherTherapyInterventionsPlanned1 ,
a.OtherTherapyInterventionsPlanned2 ,
a.MedicationCompliance,
a.OtherConcernsNotAddressed ,
a.OtherIndividuals ,
a.PlanReviewFrequency 
from CustomPsychiatricEvaluations a
where a.DocumentVersionId = @DocumentVersionId


Insert into #validationReturnTable
(TableName,
ColumnName,
ErrorMessage
)

--This validation returns three fields
--Field1 = TableName
--Field2 = ColumnName
--Field3 = ErrorMessage

SELECT ''CustomPsychiatricEvaluations'' , ''IdentifyingData'', ''Note - Identifying Data must be specified.''
From #CustomPsychiatricEvaluations
Where isnull(IdentifyingData,'''')=''''
UNION
SELECT ''CustomPsychiatricEvaluations'' , ''ChiefComplaint'', ''Note - Chief Complaint must be specified.''
From #CustomPsychiatricEvaluations
Where isnull(ChiefComplaint,'''')=''''
UNION
SELECT ''CustomPsychiatricEvaluations'' , ''HistoryofPresentIllness'', ''Note - Hisory of Present Illness must be specified.''
From #CustomPsychiatricEvaluations
Where isnull(HistoryofPresentIllness,'''')=''''
UNION
SELECT ''CustomPsychiatricEvaluations'' , ''PastPsychiatricHistory'', ''Note - Past Psychiactric History must be specified.''
From #CustomPsychiatricEvaluations
Where isnull(PastPsychiatricHistory,'''')=''''
UNION
SELECT ''CustomPsychiatricEvaluations'' , ''MedicalHistory'', ''Note - Medical History must be specified.''
From #CustomPsychiatricEvaluations
Where isnull(MedicalHistory,'''')=''''
UNION
SELECT ''CustomPsychiatricEvaluations'' , ''SocialHistory'', ''Note - Social History must be specified.''
From #CustomPsychiatricEvaluations
Where isnull(SocialHistory,'''')=''''
UNION
SELECT ''CustomPsychiatricEvaluations'' , ''MentalStatusExam'', ''Note - Mental Status Exam must be specified.''
From #CustomPsychiatricEvaluations
Where isnull(MentalStatusExam,'''')=''''
UNION
SELECT ''CustomPsychiatricEvaluations'' , ''Prognosis'', ''Prognosis - Prognosis must be specified.''
From #CustomPsychiatricEvaluations
Where isnull(Prognosis,'''')=''''
UNION
SELECT ''CustomPsychiatricEvaluations'' , ''OtherTherapyInterventionsPlanned1'', ''Prognosis - Plan of Care # 1 must be specified.''
From #CustomPsychiatricEvaluations
Where isnull(OtherTherapyInterventionsPlanned1,'''')=''''
UNION
SELECT ''CustomPsychiatricEvaluations'' , ''MedicationCompliance'', ''Prognosis - Plan of Care # 3 must be specified.''
From #CustomPsychiatricEvaluations
Where isnull(MedicationCompliance,'''')=''''
--UNION
--SELECT ''CustomPsychiatricEvaluations'' , ''OtherConcernsNotAddressed'', ''Prognosis - Plan of Care # 4 must be specified.''
UNION
SELECT ''CustomPsychiatricEvaluations'' , ''OtherIndividuals'', ''Prognosis - Plan of Care # 5 must be specified.''
From #CustomPsychiatricEvaluations
Where isnull(OtherIndividuals,'''')=''''
UNION
SELECT ''CustomPsychiatricEvaluations'' , ''PlanReviewFrequency'', ''Prognosis - Plan of Care # 6 must be specified.''
From #CustomPsychiatricEvaluations
Where isnull(PlanReviewFrequency,'''')=''''
Union
Select ''CustomPsychiatricEvaluations'', ''DeletedBy'', ''Service - Attending physician must be specified.''
From services s
join documents d on d.serviceid = s.serviceId
Where s.AttendingId is null
and isnull(d.RecordDeleted, ''N'') = ''N''
and isnull(s.RecordDeleted, ''N'') = ''N''
and d.CurrentDocumentVersionId = @DocumentVersionId
Union
Select ''CustomPsychiatricEvaluations'', ''DeletedBy'', ''Service - Location must be specified.''
From services s
join documents d on d.serviceid = s.serviceId
Where s.LocationId is null
and isnull(d.RecordDeleted, ''N'') = ''N''
and isnull(s.RecordDeleted, ''N'') = ''N''
and d.CurrentDocumentVersionId = @DocumentVersionId
--Diagnosis Validation
exec csp_validateDiagnosis @DocumentVersionId
if @@error <> 0 goto error


--
--Check to make sure record exists in custom table for @DocumentCodeId
--
If not exists (Select * from #CustomPsychiatricEvaluations)
begin 

Insert into CustomBugTracking
(DocumentVersionId, Description, CreatedDate)
Values
(@DocumentVersionId, ''No record exists in custom table.'', GETDATE())

Insert into #validationReturnTable
(TableName,
ColumnName,
ErrorMessage
)

Select ''CustomPsychiatricEvaluations'', ''DeletedBy'', ''Error occurred. Please contact your system administrator. No record exists in custom table.''
Where not exists  (Select * from #CustomPsychiatricEvaluations)
end



if @@error <> 0 goto error

return

error:
raiserror 50000 ''csp_validateCustomPsychiatricEvaluations failed.  Contact your system administrator.''
' 
END
GO
