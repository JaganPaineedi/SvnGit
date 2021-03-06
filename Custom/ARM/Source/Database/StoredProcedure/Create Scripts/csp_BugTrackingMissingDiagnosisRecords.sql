/****** Object:  StoredProcedure [dbo].[csp_BugTrackingMissingDiagnosisRecords]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_BugTrackingMissingDiagnosisRecords]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_BugTrackingMissingDiagnosisRecords]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_BugTrackingMissingDiagnosisRecords]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_BugTrackingMissingDiagnosisRecords]

as

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


--
-- Insert Missing Records For Psych Evals
--
insert into DiagnosesIII
(DocumentVersionId, CreatedBy)
select dv.DocumentVersionId, ''AxisIII'' from Documents d1
Join DocumentVersions dv on dv.DocumentVersionId=d1.CurrentDocumentVersionId
where d1.DocumentCodeId = 121
and Status in ( 21)
and Not exists (select 1 from DiagnosesIII iii
				where iii.DocumentVersionId = d1.CurrentDocumentVersionId
				and isnull(iii.RecordDeleted, ''N'')= ''N''
				)
and exists (Select 1 From CustomPsychiatricEvaluations r
			Where r.DocumentVersionId = d1.CurrentDocumentVersionId
			and ISNULL(r.RecordDeleted, ''N'')= ''N''
			)
and ISNULL(d1.recorddeleted, ''N'')=''N''



insert into DiagnosesIV
(DocumentVersionId, CreatedBy)
select dv.DocumentVersionId, ''AxisIV'' from Documents d1
Join DocumentVersions dv on dv.DocumentVersionId=d1.CurrentDocumentVersionId
where d1.DocumentCodeId = 121
and Status in ( 21)
and Not exists (select 1 from DiagnosesIV iii
				where iii.DocumentVersionId = d1.CurrentDocumentVersionId
				and isnull(iii.RecordDeleted, ''N'')= ''N''
				)
and exists (Select 1 From CustomPsychiatricEvaluations r
			Where r.DocumentVersionId = d1.CurrentDocumentVersionId
			and ISNULL(r.RecordDeleted, ''N'')= ''N''
			)
and ISNULL(d1.recorddeleted, ''N'')=''N''


insert into DiagnosesV
(DocumentVersionId, CreatedBy)
select dv.DocumentVersionId, ''AxisV'' from Documents d1
Join DocumentVersions dv on dv.DocumentVersionId=d1.CurrentDocumentVersionId
where d1.DocumentCodeId = 121
and Status in ( 21)
and Not exists (select 1 from DiagnosesV iii
				where iii.DocumentVersionId = d1.CurrentDocumentVersionId
				and isnull(iii.RecordDeleted, ''N'')= ''N''
				)
and exists (Select 1 From CustomPsychiatricEvaluations r
			Where r.DocumentVersionId = d1.CurrentDocumentVersionId
			and ISNULL(r.RecordDeleted, ''N'')= ''N''
			)				
and ISNULL(d1.recorddeleted, ''N'')=''N''


--
-- Insert Missing Records For Med Reviews
--
insert into DiagnosesIII
(DocumentVersionId, CreatedBy)
select dv.DocumentVersionId, ''AxisIII'' from Documents d1
Join DocumentVersions dv on dv.DocumentVersionId=d1.CurrentDocumentVersionId
where d1.DocumentCodeId = 117
and Status in ( 21)
and Not exists (select 1 from DiagnosesIII iii
				where iii.DocumentVersionId = d1.CurrentDocumentVersionId
				and isnull(iii.RecordDeleted, ''N'')= ''N''
				)
and exists (Select 1 From CustomMedicationReviews r
			Where r.DocumentVersionId = d1.CurrentDocumentVersionId
			and ISNULL(r.RecordDeleted, ''N'')= ''N''
			)
and ISNULL(d1.recorddeleted, ''N'')=''N''



insert into DiagnosesIV
(DocumentVersionId, CreatedBy)
select dv.DocumentVersionId, ''AxisIV'' from Documents d1
Join DocumentVersions dv on dv.DocumentVersionId=d1.CurrentDocumentVersionId
where d1.DocumentCodeId = 117
and Status in ( 21)
and Not exists (select 1 from DiagnosesIV iii
				where iii.DocumentVersionId = d1.CurrentDocumentVersionId
				and isnull(iii.RecordDeleted, ''N'')= ''N''
				)
and exists (Select 1 From CustomMedicationReviews r
			Where r.DocumentVersionId = d1.CurrentDocumentVersionId
			and ISNULL(r.RecordDeleted, ''N'')= ''N''
			)
and ISNULL(d1.recorddeleted, ''N'')=''N''


insert into DiagnosesV
(DocumentVersionId, CreatedBy)
select dv.DocumentVersionId, ''AxisV'' from Documents d1
Join DocumentVersions dv on dv.DocumentVersionId=d1.CurrentDocumentVersionId
where d1.DocumentCodeId = 117
and Status in ( 21)
and Not exists (select 1 from DiagnosesV iii
				where iii.DocumentVersionId = d1.CurrentDocumentVersionId
				and isnull(iii.RecordDeleted, ''N'')= ''N''
				)
and exists (Select 1 From CustomMedicationReviews r
			Where r.DocumentVersionId = d1.CurrentDocumentVersionId
			and ISNULL(r.RecordDeleted, ''N'')= ''N''
			)				
and ISNULL(d1.recorddeleted, ''N'')=''N''




--
-- Insert Missing Records For Assessments
--
insert into DiagnosesIII
(DocumentVersionId, CreatedBy)
select dv.DocumentVersionId, ''AxisIII'' from Documents d1
Join DocumentVersions dv on dv.DocumentVersionId=d1.CurrentDocumentVersionId
where d1.DocumentCodeId = 1469
and Status in ( 21)
and Not exists (select 1 from DiagnosesIII iii
				where iii.DocumentVersionId = d1.CurrentDocumentVersionId
				and isnull(iii.RecordDeleted, ''N'')= ''N''
				)

and ISNULL(d1.recorddeleted, ''N'')=''N''



insert into DiagnosesIV
(DocumentVersionId, CreatedBy)
select dv.DocumentVersionId, ''AxisIV'' from Documents d1
Join DocumentVersions dv on dv.DocumentVersionId=d1.CurrentDocumentVersionId
where d1.DocumentCodeId = 1469
and Status in ( 21)
and Not exists (select 1 from DiagnosesIV iii
				where iii.DocumentVersionId = d1.CurrentDocumentVersionId
				and isnull(iii.RecordDeleted, ''N'')= ''N''
				)
and ISNULL(d1.recorddeleted, ''N'')=''N''


insert into DiagnosesV
(DocumentVersionId, CreatedBy)
select dv.DocumentVersionId, ''AxisV'' from Documents d1
Join DocumentVersions dv on dv.DocumentVersionId=d1.CurrentDocumentVersionId
where d1.DocumentCodeId = 1469
and Status in ( 21)
and Not exists (select 1 from DiagnosesV iii
				where iii.DocumentVersionId = d1.CurrentDocumentVersionId
				and isnull(iii.RecordDeleted, ''N'')= ''N''
				)			
and ISNULL(d1.recorddeleted, ''N'')=''N''



--
--Insert into bug tracking log
--
Insert into CustomBugTracking
(Description, CreatedDate, DocumentVersionId)

Select distinct ''Missing Axis III'' + '' - '' + ISNULL(dc.DocumentName, ''''), i.CreatedDate, i.DocumentVersionId
From DiagnosesIII  i
join Documents d on d.CurrentDocumentVersionId = i.DocumentVersionId
join DocumentCodes dc on dc.DocumentCodeId = d.DocumentCodeId
Where i.CreatedBy = ''AxisIII''
and CONVERT(varchar(20), i.CreatedDate, 101) = DATEADD(dd, 0, convert(varchar(20), getdate(), 101))
and d.DocumentCodeId not in (5)


Insert into CustomBugTracking
(Description, CreatedDate, DocumentVersionId)

Select distinct ''Missing Axis IV'' + '' - '' + ISNULL(dc.DocumentName, ''''), i.CreatedDate, i.DocumentVersionId
From DiagnosesIV  i
join Documents d on d.CurrentDocumentVersionId = i.DocumentVersionId
join DocumentCodes dc on dc.DocumentCodeId = d.DocumentCodeId
Where i.CreatedBy = ''AxisIV''
and CONVERT(varchar(20), i.CreatedDate, 101) = DATEADD(dd, 0, convert(varchar(20), getdate(), 101))
and d.DocumentCodeId not in (5)

Insert into CustomBugTracking
(Description, CreatedDate, DocumentVersionId)

Select distinct ''Missing Axis V'' + '' - '' + ISNULL(dc.DocumentName, ''''), i.CreatedDate, i.DocumentVersionId
From DiagnosesV  i
join Documents d on d.CurrentDocumentVersionId = i.DocumentVersionId
join DocumentCodes dc on dc.DocumentCodeId = d.DocumentCodeId
Where i.CreatedBy = ''AxisV''
and CONVERT(varchar(20), i.CreatedDate, 101) = DATEADD(dd, 0, convert(varchar(20), getdate(), 101))
and d.DocumentCodeId not in (5)



SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
' 
END
GO
