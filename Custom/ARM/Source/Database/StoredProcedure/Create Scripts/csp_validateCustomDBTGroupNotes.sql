/****** Object:  StoredProcedure [dbo].[csp_validateCustomDBTGroupNotes]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomDBTGroupNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomDBTGroupNotes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomDBTGroupNotes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE        PROCEDURE [dbo].[csp_validateCustomDBTGroupNotes]
@DocumentVersionId	Int--,@documentCodeId	Int
as




--Load the document data into a temporary table to prevent multiple seeks on the document table
CREATE TABLE #CustomDBTGroupNotes
(AxisV int,
BillingClinician int,
CompletedDiaryCard char(2),
CompletedHomework char(2),
CreatedBy varchar(30),
CreatedDate datetime,
CurrentDiagnosis varchar(max),
CurrentTreatmentPlan varchar(max),
DeletedBy varchar(30),
DeletedDate datetime,
DiaryCardNote varchar(max),
DocumentVersionId int,
GoalsAddressed varchar(100),
HandsOutReiviewed varchar(max),
HomeworkAssigned varchar(max),
Intervention varchar(max),
ModifiedBy varchar(30),
ModifiedDate datetime,
Module varchar(30),
ModuleNote varchar(max),
MoodAnger char(1),
MoodDepression char(1),
MoodEuthymic char(1),
MoodMania char(1),
MoodNote varchar(max),
MoodSuicidal char(1),
OptionalComments varchar(max),
RecordDeleted char(1)
)
insert into #CustomDBTGroupNotes
(AxisV,
BillingClinician,
CompletedDiaryCard,
CompletedHomework,
CreatedBy,
CreatedDate,
CurrentDiagnosis,
CurrentTreatmentPlan,
DeletedBy,
DeletedDate,
DiaryCardNote,
DocumentVersionId,
GoalsAddressed,
HandsOutReiviewed,
HomeworkAssigned,
Intervention,
ModifiedBy,
ModifiedDate,
Module,
ModuleNote,
MoodAnger,
MoodDepression,
MoodEuthymic,
MoodMania,
MoodNote,
MoodSuicidal,
OptionalComments,
RecordDeleted
)
select
a.AxisV,
a.BillingClinician,
a.CompletedDiaryCard,
a.CompletedHomework,
a.CreatedBy,
a.CreatedDate,
a.CurrentDiagnosis,
a.CurrentTreatmentPlan,
a.DeletedBy,
a.DeletedDate,
a.DiaryCardNote,
a.DocumentVersionId,
a.GoalsAddressed,
a.HandsOutReiviewed,
a.HomeworkAssigned,
a.Intervention,
a.ModifiedBy,
a.ModifiedDate,
a.Module,
a.ModuleNote,
a.MoodAnger,
a.MoodDepression,
a.MoodEuthymic,
a.MoodMania,
a.MoodNote,
a.MoodSuicidal,
a.OptionalComments,
a.RecordDeleted
from CustomDBTGroupNotes a
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

Select ''CustomDBTGroupNotes'', ''AxisV'', ''AxisV must be specified.''
	From #CustomDBTGroupNotes
	Where AxisV is null
Union
Select ''CustomDBTGroupNotes'', ''CompletedDiaryCard'', ''Did Client complete weekly diary card?''
	From #CustomDBTGroupNotes
	Where isnull(CompletedDiaryCard,'''')=''''
Union
Select ''CustomDBTGroupNotes'', ''CompletedHomework'', ''Did Client complete weekly homework?''
	From #CustomDBTGroupNotes
	Where isnull(CompletedHomework,'''')=''''
Union
Select ''CustomDBTGroupNotes'', ''GoalsAddressed'', ''Specify which goals addressed.''
	from #CustomDBTGroupNotes a
	where isnull(GoalsAddressed,''NNNNNN'') = ''NNNNNN''
Union
Select ''CustomDBTGroupNotes'', ''HandsOutReiviewed'', ''List handouts reviewed.''
	From #CustomDBTGroupNotes
	Where isnull(HandsOutReiviewed,'''')=''''
Union
Select ''CustomDBTGroupNotes'', ''HomeworkAssigned'', ''List homework assigned.''
	From #CustomDBTGroupNotes
	Where isnull(HomeworkAssigned,'''')=''''
Union
Select ''CustomDBTGroupNotes'', ''Intervention'', ''List intervention.''
	From #CustomDBTGroupNotes
	Where isnull(Intervention,'''')=''''
Union
Select ''CustomDBTGroupNotes'', ''Module'', ''List module covered.''
	From #CustomDBTGroupNotes
	Where isnull(Module,'''')=''''
Union
Select ''CustomDBTGroupNotes'', ''MoodAnger'', ''Specify customer''''s mood.''
	from #CustomDBTGroupNotes a
	where isnull(MoodAnger,''N'') = ''N'' and isnull(MoodDepression,''N'') = ''N'' and isnull(MoodEuthymic,''N'') = ''N'' and isnull(MoodMania,''N'') = ''N'' and isnull(convert(varchar(max),MoodNote),'''') = '''' and isnull(MoodSuicidal,''N'') = ''N''
UNION
Select ''CustomDBTGroupNotes'', ''DeletedBy'', ''Specify Masters Level Billing Clinician.''
	from #CustomDBTGroupNotes a
	where not exists (select 1 from staff s 
			where s.staffid = a.billingclinician
--			Replaced Master Level lookup with CustomDegreePriorities
			and s.Degree in (Select p.DegreeID From CustomDegreePriorities p
							 Where isnull(p.Priority, 0) >= 1 )
						)
--			and isnull(s.degree, 0) in ( 10060, --D.O.
--				10149, --L.C.S.W.
--				10151, --L.L.P.
--				10153, --L.M.S.W.
--				10170 --MSW/CSW
--				))
Union
Select ''CustomDBTGroupNotes'', ''DeletedBy'', ''Service - Location must be specified.''
From services s
join documents d on d.serviceid = s.serviceId
Where s.LocationId is null
and isnull(d.RecordDeleted, ''N'') = ''N''
and isnull(s.RecordDeleted, ''N'') = ''N''
and d.CurrentDocumentVersionId = @DocumentVersionId

/*
UNION
SELECT ''CustomDBTGroupNotes'', ''DeletedDate'', ''Service - Number of Group Participants must be specified.''
From Documents d 
Join Services s on s.ServiceId = d.ServiceId
join procedureCodes pc on pc.ProcedureCodeId = s.ProcedureCodeId and pc.GroupCode=''Y''
where  d.CurrentDocumentVersionId = @DocumentVersionId 
and pc.procedurecodeid not in (38) --Anger Group
and not exists (select 1 from CustomFieldsData cfd
				where cfd.DocumentType = 4943
				and cfd.PrimaryKey1 = s.ServiceId
				and isnull(cfd.ColumnInt1, 0) > 1
				)

*/
exec [csp_validateCustomServicesTab] @DocumentVersionId--, @DocumentCodeId


--
--Check to make sure record exists in custom table for @DocumentCodeId
--
If not exists (Select 1 from #CustomDBTGroupNotes)
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

Select ''CustomDBTGroupNotes'', ''DeletedBy'', ''Error occurred. Please contact your system administrator. No record exists in custom table.''
Where not exists  (Select 1 from #CustomDBTGroupNotes)
end


if @@error <> 0 goto error

return

error:
raiserror 50000 ''csp_validateDBTGroupNotes failed.  Contact your system administrator.''
' 
END
GO
