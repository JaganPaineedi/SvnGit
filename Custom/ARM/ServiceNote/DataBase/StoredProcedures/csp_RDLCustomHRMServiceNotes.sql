IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'csp_RDLCustomHRMServiceNotes')
	BEGIN
		DROP  Procedure csp_RDLCustomHRMServiceNotes 
		                 
	END
GO

CREATE procedure [dbo].[csp_RDLCustomHRMServiceNotes]
	@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010
AS

/*
Modified by		Modified Date	Reason
avoss			08.27.2010		corrected joins and sp to show each version correctly , added version to rdl to allow displaying of previous layout of notes
rcaffrey        01.16.2015      To comply with Service Diagnosis Data Model
*/
declare @GoLiveDate datetime
set @GoLiveDate = '09/27/2015'

declare @DocumentId int
select @DocumentId = documentID from DocumentVersions where DocumentVersionId = @DocumentVersionId

declare @RDLVersion int
set @RDLVersion = 2

if exists (
	select *
	from DocumentSignatures ds
	where isnull(ds.RecordDeleted,'N')<>'Y'
	and ds.DocumentId = @DocumentId
	and ds.SignatureOrder = 1
	and ds.SignatureDate is not null
	and ds.SignatureDate < @GoLiveDate
	and Not exists ( 
		select * 
		from DocumentVersions dv 
		where dv.DocumentVersionId= @DocumentVersionId
		--and dv.CreatedDate >= @GoLiveDate 
		 AND dv.ModifiedDate >= @GoLiveDate 
		)
	)
	Begin
	Set @RDLVersion = 1
	End

if exists ( 
	select * 
	from DocumentVersions dv 
	where dv.DocumentVersionId= @DocumentVersionId
	--and dv.CreatedDate >= @GoLiveDate 
	 AND dv.ModifiedDate >= @GoLiveDate
	)
	Begin
	Set @RDLVersion = 2
	End
	
	
begin
select
 d.ClientId,
 d.DocumentId,
 dv.Version,
 --csn.HRMServiceNoteId,  --Commented by Jitender on 05 August 2010
 csn.DocumentVersionId,
 gc.CodeName as ServiceType,  --Commented by Jitender on 04 August 2010
 --csn.ServiceType,
 gc1.CodeName as ServiceModality,  --Commented by Jitender on 04 August 2010
 --csn.ServiceModality,
 csn.ServiceModalityComment,
 csn.Diagnosis,
 csn.ChangeMoodAffect,
 csn.ChangeMoodAffectComment,
 case when ( csn.ChangeMoodAffect is null and csn.ChangeMoodAffectComment is null ) then 'N'
 else 'Y' end as displayChangeMoodAffect,
 csn.ChangeThoughtProcess,
 csn.ChangeThoughtProcessComment,
 case when ( csn.ChangeThoughtProcess is null and csn.ChangeThoughtProcessComment is null ) then 'N'
 else 'Y' end as displayChangeThoughtProcess,
 csn.ChangeBehavior,
 csn.ChangeBehaviorComment,
 case when ( csn.ChangeBehavior is null and csn.ChangeThoughtProcessComment is null ) then 'N'
 else 'Y' end as displayChangeBehavior,
 csn.ChangeMedicalCondition,
 csn.ChangeMedicalConditionComment,
 case when ( csn.ChangeMedicalCondition is null and csn.ChangeMedicalConditionComment is null ) then 'N'
 else 'Y' end as displayChangeMedicalCondition,
 csn.ChangeSubstanceUse,
 csn.ChangeSubstanceUseComment,
 case when ( csn.ChangeSubstanceUse is null and csn.ChangeSubstanceUseComment is null ) then 'N'
 else 'Y' end as displayChangeSubstanceUse,
 csn.RiskNoneReported,
 csn.RiskSelf,
 csn.RiskOthers,
 csn.RiskProperty,
 csn.RiskIdeation,
 csn.RiskPlan,
 csn.RiskIntent,
 csn.RiskAttempt,
 csn.RiskOther,
 csn.RiskOtherComment,
 csn.RiskResponseComment,
 csn.MedicationConcerns,
 csn.MedicationConcernsComment,
 csn.ProgressTowardOutcomeComment,
 csn.ClinicalInterventionComment,
 csn.AxisV as GAF,
 csn.ProgressTowardOutcomeAndClinicalInterventionComment, -- Added by Jitender on 04 August 2010
 l.LocationName,
 sd1.DSMCode,
 sd2.DSMCode,
 sd3.DSMCode,
 s.OtherPersonsPresent,
 @RDLVersion as RDLVersion
from DocumentVersions dv
join Documents as d   on d.DocumentId = dv.DocumentId and isnull(d.RecordDeleted, 'N')<>'Y'
join services as s on s.ServiceId = d.ServiceId and isnull(s.RecordDeleted,'N')<>'Y'
LEFT JOIN dbo.ServiceDiagnosis sd1 ON sd1.ServiceId = S.ServiceId AND sd1.[Order] = 1 AND ISNULL(sd1.RecordDeleted, 'N') <> 'Y'
LEFT JOIN dbo.ServiceDiagnosis sd2 ON sd2.ServiceId = S.ServiceId AND sd2.[Order] = 2 AND ISNULL(sd2.RecordDeleted, 'N') <> 'Y'
LEFT JOIN dbo.ServiceDiagnosis sd3 ON sd3.ServiceId = S.ServiceId AND sd3.[Order] = 3 AND ISNULL(sd3.RecordDeleted, 'N') <> 'Y'
left join locations as l on l.LocationId = s.LocationId
--left join CustomHRMServiceNotes as csn on csn.DocumentId = d.DocumentId and csn.Version = @Version
left join CustomHRMServiceNotes as csn on csn.DocumentVersionId = dv.DocumentVersionId  --THIS WAS WRONG JOINING ON d.CurrentDocumentVersionId do not to this--Modified by Anuj Dated 03-May-2010
	and isnull(csn.RecordDeleted,'N')<>'Y'
left join globalCodes as gc on gc.GlobalCodeId = csn.ServiceType  --Commented by Jitender on 04 August 2010
left join globalCodes as gc1 on gc1.GlobalCodeId = csn.ServiceModality
where isnull(dv.RecordDeleted, 'N')<>'Y'
--and d.DocumentId = @DocumentId
and dv.DocumentVersionId = @DocumentVersionId  --join on dv.DOcumentVersionId to allow viewing the version of the document--Modified by Anuj Dated 03-May-2010

end
