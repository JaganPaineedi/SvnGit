/****** Object:  StoredProcedure [dbo].[csp_validateCustomHRMServiceNotes]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomHRMServiceNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomHRMServiceNotes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomHRMServiceNotes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE     PROCEDURE [dbo].[csp_validateCustomHRMServiceNotes]
@DocumentVersionId INT
as



DECLARE @DocumentCodeId INT
SET @DocumentCodeId = (Select DocumentCodeId From Documents Where CurrentDocumentVersionId = @DocumentVersionId)

IF exists (Select 1 From Services s 
			Join Documents d on s.ServiceId=d.ServiceId
			Where d.CurrentDocumentVersionId=@DocumentVersionId
			and s.Status in (72,73, 76)
			)
	Return
	
ELSE 




CREATE TABLE [#CustomHRMServiceNotes] (

DocumentVersionId int, 
ServiceType int,
ServiceModality int,
ServiceModalityComment text,
Diagnosis text,
ChangeMoodAffect char(1),
ChangeMoodAffectComment text,
ChangeThoughtProcess char(1),
ChangeThoughtProcessComment text,
ChangeBehavior char(1),
ChangeBehaviorComment text,
ChangeMedicalCondition char(1),
ChangeMedicalConditionComment text,
ChangeSubstanceUse char(1),
ChangeSubstanceUseComment text,
RiskNoneReported char(1),
RiskSelf char(1),
RiskOthers char(1),
RiskProperty char(1),
RiskIdeation char(1),
RiskPlan char(1),
RiskIntent char(1),
RiskAttempt char(1),
RiskOther char(1),
RiskOtherComment text,
RiskResponseComment text,
MedicationConcerns char(1),
MedicationConcernsComment text,
ProgressTowardOutcomeComment text,
ClinicalInterventionComment text,
AxisV int	)

INSERT INTO  [#CustomHRMServiceNotes](
DocumentVersionId, 
ServiceType,
ServiceModality,
ServiceModalityComment,
Diagnosis,
ChangeMoodAffect,
ChangeMoodAffectComment,
ChangeThoughtProcess,
ChangeThoughtProcessComment,
ChangeBehavior,
ChangeBehaviorComment,
ChangeMedicalCondition,
ChangeMedicalConditionComment,
ChangeSubstanceUse,
ChangeSubstanceUseComment,
RiskNoneReported,
RiskSelf,
RiskOthers,
RiskProperty,
RiskIdeation,
RiskPlan,
RiskIntent,
RiskAttempt,
RiskOther,
RiskOtherComment,
RiskResponseComment,
MedicationConcerns,
MedicationConcernsComment,
ProgressTowardOutcomeComment,
ClinicalInterventionComment,
AxisV
	)
select 
a.DocumentVersionId,
a.ServiceType,
a.ServiceModality,
a.ServiceModalityComment,
a.Diagnosis,
a.ChangeMoodAffect,
a.ChangeMoodAffectComment,
a.ChangeThoughtProcess,
a.ChangeThoughtProcessComment,
a.ChangeBehavior,
a.ChangeBehaviorComment,
a.ChangeMedicalCondition,
a.ChangeMedicalConditionComment,
a.ChangeSubstanceUse,
a.ChangeSubstanceUseComment,
a.RiskNoneReported,
a.RiskSelf,
a.RiskOthers,
a.RiskProperty,
a.RiskIdeation,
a.RiskPlan,
a.RiskIntent,
a.RiskAttempt,
a.RiskOther,
a.RiskOtherComment,
a.RiskResponseComment,
a.MedicationConcerns,
a.MedicationConcernsComment,
a.ProgressTowardOutcomeComment,
a.ClinicalInterventionComment,
a.AxisV
from CustomHRMServiceNotes a 
where a.DocumentVersionId = @DocumentVersionId

/* Summit Only 
--
-- Determine Coverage
--
Declare @BCBSCoverage char(1)

if exists (select d.DocumentId From documents d
				join ClientCoveragePlans ccp on ccp.clientid = d.clientid
				join ClientCoverageHistory cch on cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
				join CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId
				join Payers p on p.PayerId = cp.PayerId
				where d.CurrentDocumentVersionId = @DocumentVersionId
				and cch.StartDate <= d.EffectiveDate
				and (cch.EndDate >= d.EffectiveDate or cch.EndDate is null)
				and p.PayerType in (10317) -- Blue Cross Blue Shield
				and isnull(ccp.RecordDeleted, ''N'')= ''N''
				and isnull(cch.RecordDeleted, ''N'')= ''N''
				and isnull(cp.RecordDeleted, ''N'')= ''N''
				)
begin 
Set @BCBSCoverage = ''Y''
end

If @BCBSCoverage is null
begin
Set @BCBSCoverage = ''N''
end
*/


DECLARE @ProgramId int
Select @ProgramId = s.ProgramId
From services s
join Documents d on d.ServiceId = s.ServiceId
where d.CurrentDocumentVersionId = @DocumentVersionId


Insert into #validationReturnTable
(TableName,
ColumnName,
ErrorMessage
)

--This validation returns three fields
--Field1 = TableName
--Field2 = ColumnName
--Field3 = ErrorMessage

--Select ''CustomHRMServiceNotes'', ''ServiceType'', ''Note - Service Type must be specified.''
--Union
--Select ''CustomHRMServiceNotes'', ''DeletedBy'', ''Note - Modality of Therapy must be specified.''
--From #CustomHRMServiceNotes
--Where ServiceType in (4844)
--and isnull(ServiceModality, '''') = ''''

Select ''CustomHRMServiceNotes'', ''ChangeMoodAffect'', ''Note - Change: Mood/Affect must be specified.''
From #CustomHRMServiceNotes
Where ChangeMoodAffect is null
and @ProgramId not in (4) --DD

Union
Select ''CustomHRMServiceNotes'', ''DeletedBy'', ''Note - Change: Mood/Affect comment must be specified.''
From #CustomHRMServiceNotes
Where isnull(ChangeMoodAffect, ''N'') = ''Y''
and isnull(Convert(varchar(8000), ChangeMoodAffectComment), '''') = ''''
and @ProgramId not in (4) --DD

Union
Select ''CustomHRMServiceNotes'', ''ChangeThoughtProcess'', ''Note - Change: Thought Process/Orientation must be specified.''
From #CustomHRMServiceNotes
Where ChangeThoughtProcess  is null
and @ProgramId not in (4) --DD

Union
Select ''CustomHRMServiceNotes'', ''DeletedBy'', ''Note - Change: Thought Process/Orientation comment must be specified.''
From #CustomHRMServiceNotes
Where isnull(ChangeThoughtProcess, ''N'') = ''Y''
and isnull(Convert(varchar(8000), ChangeThoughtProcessComment), '''') = ''''
and @ProgramId not in (4) --DD

Union
Select ''CustomHRMServiceNotes'', ''ChangeBehavior'', ''Note - Change: Behavior/Functioning must be specified.''
From #CustomHRMServiceNotes
Where ChangeBehavior is null
and @ProgramId not in (4) --DD

Union
Select ''CustomHRMServiceNotes'', ''DeletedBy'', ''Note - Change: Behavior/Functioning comment must be specified.''
From #CustomHRMServiceNotes
Where isnull(ChangeBehavior, ''N'') = ''Y''
and isnull(Convert(varchar(8000), ChangeBehaviorComment), '''') = ''''
and @ProgramId not in (4) --DD

Union
Select ''CustomHRMServiceNotes'', ''ChangeMedicalCondition'', ''Note - Change: Medical Condition must be specified.''
From #CustomHRMServiceNotes
Where ChangeMedicalCondition is null
and @ProgramId not in (4) --DD

Union
Select ''CustomHRMServiceNotes'', ''DeletedBy'', ''Note - Change: Medical Condition comment must be specified.''
From #CustomHRMServiceNotes
Where isnull(ChangeMedicalCondition, ''N'') = ''Y''
and isnull(Convert(varchar(8000), ChangeMedicalConditionComment), '''') = ''''
and @ProgramId not in (4) --DD

Union
Select ''CustomHRMServiceNotes'', ''ChangeSubstanceUse'', ''Note - Change: Substance Use must be specified.''
From #CustomHRMServiceNotes
Where ChangeSubstanceUse is null
and @ProgramId not in (4) --DD

Union
Select ''CustomHRMServiceNotes'', ''DeletedBy'', ''Note - Change: Substance Use comment must be specified.''
From #CustomHRMServiceNotes
Where isnull(ChangeSubstanceUse, ''N'') = ''Y''
and isnull(Convert(varchar(8000), ChangeSubstanceUseComment), '''') = ''''
and @ProgramId not in (4) --DD

Union
Select ''CustomHRMServiceNotes'', ''DeletedBy'', ''Note - Change: Risk checkbox must be specified.''
From #CustomHRMServiceNotes
where isnull(RiskNoneReported, ''N'')= ''N''
and isnull(RiskSelf, ''N'')= ''N''
and isnull(RiskOthers, ''N'')= ''N''
and isnull(RiskProperty, ''N'')= ''N''
and isnull(RiskIdeation, ''N'')= ''N''
and isnull(RiskPlan, ''N'')= ''N''
and isnull(RiskIntent, ''N'')= ''N''
and isnull(RiskAttempt, ''N'')= ''N''
and isnull(RiskOther, ''N'')= ''N''
and @ProgramId not in (4) --DD

Union
Select ''CustomHRMServiceNotes'', ''DeletedBy'', ''Note - Change: Risk Other comment must be specified.''
From #CustomHRMServiceNotes
where isnull(RiskOther, ''N'')= ''Y''
and isnull(convert(varchar(8000), RiskOtherComment), '''') = ''''


Union
Select ''CustomHRMServiceNotes'', ''DeletedBy'', ''Note - Change: Risk Response comment must be specified.''
From #CustomHRMServiceNotes
where isnull(convert(varchar(8000), RiskResponseComment), '''') = ''''
and (
isnull(RiskSelf, ''N'')= ''Y''
or isnull(RiskOthers, ''N'')= ''Y''
or isnull(RiskProperty, ''N'')= ''Y''
or isnull(RiskIdeation, ''N'')= ''Y''
or isnull(RiskPlan, ''N'')= ''Y''
or isnull(RiskIntent, ''N'')= ''Y''
or isnull(RiskAttempt, ''N'')= ''Y''
or isnull(RiskOther, ''N'')= ''Y''
)



Union
Select ''CustomHRMServiceNotes'', ''MedicationConcerns'', ''Note - Change: Medication Concern must be specified.''
From #CustomHRMServiceNotes
where  MedicationConcerns is  null
and @ProgramId not in (4) --DD


Union
Select ''CustomHRMServiceNotes'', ''DeletedBy'', ''Note - Change: Medication Concern comment must be specified.''
From #CustomHRMServiceNotes
Where isnull(MedicationConcerns, ''N'') = ''Y''
and isnull(Convert(varchar(8000), MedicationConcernsComment), '''') = ''''



--Union
--Select ''CustomHRMServiceNotes'', ''ProgressTowardOutcomeComment'', ''Note - Progress Toward Measurable Outcome must be specified.''
--Union
--Select ''CustomHRMServiceNotes'', ''ClinicalInterventionComment'', ''Note - Clinical Intervetion/Homework/Handouts must be specified.''


--Union
--Select ''CustomHRMServiceNotes'', ''DeletedBy'', ''Service - Attending physician must be specified.''
--From services s
--join documents d on d.serviceid = s.serviceId
--Where s.AttendingId is null
--and isnull(d.RecordDeleted, ''N'') = ''N''
--and isnull(s.RecordDeleted, ''N'') = ''N''
--and d.CurrentDocumentVersionId = @DocumentVersionId
Union
Select ''CustomHRMServiceNotes'', ''DeletedBy'', ''Service - Location must be specified.''
From services s
join documents d on d.serviceid = s.serviceId
Where s.LocationId is null
and isnull(d.RecordDeleted, ''N'') = ''N''
and isnull(s.RecordDeleted, ''N'') = ''N''
and d.CurrentDocumentVersionId = @DocumentVersionId

/*
union 
Select ''CustomHRMServiceNotes'', ''DeletedBy'', ''Service - Goal must be specified.''
From services s
join documents d on d.serviceid = s.serviceId
Where isnull(d.RecordDeleted, ''N'') = ''N''
and isnull(s.RecordDeleted, ''N'') = ''N''
and d.CurrentDocumentVersionId = @DocumentVersionId
and not exists (Select sg.ServiceId from ServiceGoals	sg
				where sg.ServiceId = s.ServiceId
				and isnull(sg.RecordDeleted, ''N'')= ''N'')
and not exists (select cfd.PrimaryKey1 from CustomFieldsData cfd
				where  cfd.DocumentType = 4943
				and cfd.PrimaryKey1 = s.ServiceId
				and cfd.ColumnGlobalCode5 is not null
				and isnull(cfd.RecordDeleted, ''N'') = ''N''
)
--select * from customfieldsdata
--where createddate >= ''9/12/2008''
/*
union 
Select ''CustomHRMServiceNotes'', ''DeletedBy'', ''Service - Stage Of Treatment must be specified.''
From services s
join documents d on d.serviceid = s.serviceId
Where isnull(d.RecordDeleted, ''N'') = ''N''
and isnull(s.RecordDeleted, ''N'') = ''N''
and d.CurrentDocumentVersionId = @DocumentVersionId
and exists (Select sg.ServiceId from ServiceGoals	sg
				where sg.ServiceId = s.ServiceId
				and isnull(StageOfTreatment, '''') = ''''
				and isnull(sg.RecordDeleted, ''N'')= ''N'')
				*/

UNION
SELECT ''CustomHRMServiceNotes'', ''DeletedDate'', ''Service - Number of Group Participants must be specified.''
From Documents d 
Join Services s on s.ServiceId = d.ServiceId
join procedureCodes pc on pc.ProcedureCodeId = s.ProcedureCodeId and pc.GroupCode=''Y''
where  d.CurrentDocumentVersionId = @DocumentVersionId 
and pc.procedurecodeid not in (38, 166) --Anger Group, DVG Group
and not exists (select cfd.PrimaryKey1 from CustomFieldsData cfd
				where cfd.DocumentType = 4943
				and cfd.PrimaryKey1 = s.ServiceId
				and isnull(cfd.ColumnInt1, 0) > 1
				)

--union 
--Select ''CustomHRMServiceNotes'', ''DeletedBy'', ''Service - Objective must be specified.''
--From services s
--join documents d on d.serviceid = s.serviceId
--
--Where isnull(d.RecordDeleted, ''N'') = ''N''
--and isnull(s.RecordDeleted, ''N'') = ''N''
--and d.CurrentdocumentVersionId = @DocumentVersionId
--and exists (Select sg3.ServiceId from ServiceGoals	sg3
--				where sg3.ServiceId = s.ServiceId
--				and isnull(sg3.RecordDeleted, ''N'')= ''N'')
--and not exists (Select sg2.NeedId from  ServiceGoals sg2
--				join ServiceObjectives	so2 on so2.ServiceId = sg2.ServiceId
--				where sg2.NeedId = sg.NeedId
--				and isnull(sg2.RecordDeleted, ''N'')= ''N''
--				and isnull(so2.RecordDeleted, ''N'')= ''N'')
--and isnull(sg.RecordDeleted, ''N'')= ''N''

*/


exec [csp_validateCustomServicesTab] @DocumentVersionId


--
--Check to make sure record exists in custom table for @DocumentCodeId
--
If not exists (Select 1 from #CustomHRMServiceNotes)
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

Select ''CustomHRMServiceNotes'', ''DeletedBy'', ''Error occurred. Please contact your system administrator. No record exists in custom table.''
Where not exists (Select 1 from #CustomHRMServiceNotes)
end



if @@error <> 0 goto error

return

error:
raiserror 50000 ''csp_validateCustomHRMServiceNotes failed.  Please contact your system administrator. We apologize for the inconvenience.''
' 
END
GO
