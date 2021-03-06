/****** Object:  StoredProcedure [dbo].[csp_InitCustomDocumentDischarges]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDocumentDischarges]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomDocumentDischarges]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDocumentDischarges]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

	
CREATE procedure [dbo].[csp_InitCustomDocumentDischarges]
--
-- PROCEDURE: csp_InitCustomDocumentDischarges
--
-- PURPOSE: Initialize the Harbor CustomDocumentDischarges document.
--
-- CREATED BY: T. Remisoski
--
-- CHANGE LOG:
--		06/23/2011 - T. Remisoski - Created.
--		02/14/2012 - T. Remisoski - Updated for Harbor''s business rules
--		07/23/2012 - Pralyankar - Modified for placeholder implementation.
--		07/23/2012 - T. Remisoski - Modified for new parameter of csp_GetCustomHarborMedicationList
--		09/05/2012 - T. Remisoski - Modified for new parameter of csp_GetCustomHarborMedicationList

 @ClientID int,    
 @StaffID int,  
 @CustomParameters xml
as


declare @MedicationsPrescribed table (
	meds varchar(MAX)
)
insert into @MedicationsPrescribed 
        (meds)
exec [dbo].[csp_GetCustomHarborMedicationList] @ClientID	--, ''N''

if not exists (select * from @MedicationsPrescribed)
	insert into @MedicationsPrescribed (meds) values ('''')

declare @RegistrationDate datetime, @DischargeDate datetime, @LastServiceDate datetime
declare @ParentGuardian varchar(1000)
declare @TransitionDischargeCriteria varchar(max), @ServicesParticipated varchar(max)
declare @PresentingProblem varchar(max)
declare @TxDocumentVersionId int
declare @ProcedureCodeName varchar(250)

set @ServicesParticipated = ''''

select @RegistrationDate = RegistrationDate, @DischargeDate = GETDATE()
from dbo.ClientEpisodes as ce
where ce.ClientId = @ClientID
and ISNULL(ce.RecordDeleted, ''N'') <> ''Y''
and not exists (
	select *
	from dbo.ClientEpisodes as ce2
	where ce2.ClientId = ce.ClientId
	and ISNULL(ce2.RecordDeleted, ''N'') <> ''Y''
	and ce2.EpisodeNumber > ce.EpisodeNumber
)

select @LastServiceDate = MAX(s.DateOfService)
from dbo.Services as s
where s.ClientId = @ClientID
and s.Status in (71,75)
and ISNULL(s.RecordDeleted, ''N'') <> ''Y''

select @ParentGuardian = cc.LastName + '', '' + cc.FirstName
from dbo.Clients as c
join dbo.ClientContacts as cc on cc.ClientId = c.ClientId
where c.ClientId = @ClientID
and cc.Guardian = ''Y''
and ISNULL(cc.RecordDeleted, ''N'') <> ''Y''

select @TransitionDischargeCriteria = tp.DischargeTransitionCriteria, @TxDocumentVersionId = tp.DocumentVersionId
from dbo.CustomTreatmentPlans as tp
join dbo.DocumentVersions as dv on dv.DocumentVersionId = tp.DocumentVersionId
join dbo.Documents as d on d.DocumentId = dv.DocumentId
where d.ClientId = @ClientID
and d.EffectiveDate >= ISNULL(@RegistrationDate, ''1/1/1900'')
and d.Status = 22
and ISNULL(d.RecordDeleted, ''N'') <> ''Y''
and ISNULL(dv.RecordDeleted, ''N'') <> ''Y''
and ISNULL(tp.RecordDeleted, ''N'') <> ''Y''
and not exists (
	select *
	from dbo.CustomTreatmentPlans as tp2
	join dbo.DocumentVersions as dv2 on dv2.DocumentVersionId = tp2.DocumentVersionId
	join dbo.Documents as d2 on d2.DocumentId = dv2.DocumentId
	where d2.ClientId = d.ClientId
	and d2.Status = 22
	and (
		(d2.EffectiveDate > d.EffectiveDate)
		or (
			d2.EffectiveDate = d.EffectiveDate
			and d2.DocumentId > d.DocumentId
		)
	)
	and ISNULL(d2.RecordDeleted, ''N'') <> ''Y''
	and ISNULL(dv2.RecordDeleted, ''N'') <> ''Y''
	and ISNULL(tp2.RecordDeleted, ''N'') <> ''Y''
)
and not exists (
	select *
	from dbo.DocumentVersions as dv2
	where dv2.DocumentVersionId = dv.DocumentVersionId
	and dv2.Version > dv.Version
	and ISNULL(dv2.RecordDeleted, ''N'') <> ''Y''
)

select @PresentingProblem = da.PresentingProblem
from dbo.CustomDocumentDiagnosticAssessments as da
join dbo.DocumentVersions as dv on dv.DocumentVersionId = da.DocumentVersionId
join dbo.Documents as d on d.DocumentId = dv.DocumentId
where d.ClientId = @ClientID
and d.EffectiveDate >= ISNULL(@RegistrationDate, ''1/1/1900'')
and d.Status = 22
and ISNULL(d.RecordDeleted, ''N'') <> ''Y''
and ISNULL(dv.RecordDeleted, ''N'') <> ''Y''
and ISNULL(da.RecordDeleted, ''N'') <> ''Y''
and not exists (
	select *
	from dbo.CustomDocumentDiagnosticAssessments as da2
	join dbo.DocumentVersions as dv2 on dv2.DocumentVersionId = da2.DocumentVersionId
	join dbo.Documents as d2 on d2.DocumentId = dv2.DocumentId
	where d2.ClientId = d.ClientId
	and d2.Status = 22
	and (
		(d2.EffectiveDate > d.EffectiveDate)
		or (
			d2.EffectiveDate = d.EffectiveDate
			and d2.DocumentId > d.DocumentId
		)
	)
	and ISNULL(d2.RecordDeleted, ''N'') <> ''Y''
	and ISNULL(dv2.RecordDeleted, ''N'') <> ''Y''
	and ISNULL(da2.RecordDeleted, ''N'') <> ''Y''
)
and not exists (
	select *
	from dbo.DocumentVersions as dv2
	where dv2.DocumentVersionId = dv.DocumentVersionId
	and dv2.Version > dv.Version
	and ISNULL(dv2.RecordDeleted, ''N'') <> ''Y''
)


declare cServ insensitive cursor for
select distinct pc.ProcedureCodeName
from dbo.ProcedureCodes as pc
join dbo.Services as s on s.ProcedureCodeId = pc.ProcedureCodeId
where s.ClientId = @ClientID
and DATEDIFF(DAY, @RegistrationDate, s.DateOfService) >= 0
and s.Billable = ''Y''
and s.Status in (71,75)
and ISNULL(pc.RecordDeleted, ''N'') <> ''Y''
order by pc.ProcedureCodeName

open cServ

fetch cServ into @ProcedureCodeName

while @@FETCH_STATUS = 0
begin

	if LEN(@ServicesParticipated) > 0
		set @ServicesParticipated = @ServicesParticipated + '', ''
		
	set @ServicesParticipated = @ServicesParticipated + @ProcedureCodeName
	
	fetch cServ into @ProcedureCodeName
end

close cServ

deallocate cServ


select top 1
Placeholder.TableName, --''CustomDocumentDischarges'' as TableName,
-1 as DocumentVersionId,
'''' AS CreatedBy, 
GETDATE() AS CreatedDate,
'''' AS ModifiedBy,
GETDATE() AS ModifiedDate,
cast(null as char(1)) as RecordDeleted,
cast(null as varchar(30)) as DeletedBy,
cast(null as datetime) as DeletedDate,
ca.Display as ClientAddress,
cp.PhoneNumber as HomePhone,
@ParentGuardian as ParentGuardianName,
@RegistrationDate as AdmissionDate,
@LastServiceDate as LastServiceDate,
@DischargeDate as DischargeDate,
@TransitionDischargeCriteria as DischargeTransitionCriteria,
@ServicesParticipated as ServicesParticpated,
case when ISNULL(m.meds, '''') = '''' then ''None Prescribed.'' else m.meds end as MedicationsPrescribed,
@PresentingProblem as PresentingProblem,
'''' as ReasonForDischarge,
CAST(null as int) as ReasonForDischargeCode,
cast(null as int) as ClientParticpation,
cast(null as int) as ClientStatusLastContact,
'''' as ClientStatusComment,
cast(null as int) as ReferralPreference1,
cast(null as int) as ReferralPreference2,
cast(null as int) as ReferralPreference3,
''N'' as ReferralPreferenceOther,
'''' as ReferralPreferenceComment,
''N'' as InvoluntaryTermination,
''N'' as ClientInformedRightAppeal,
''N'' as StaffMemberContact72Hours
from 
-- This LIne of code written By Pralyankar on July 23, 2012 
(Select ''CustomDocumentDischarges'' as TableName ) as Placeholder
Left Join Clients as c On c.ClientId = @ClientID
----------------------------------------------------------------------
cross join @MedicationsPrescribed as m
left outer join ClientPhones as cp on cp.ClientId = c.ClientId and cp.PhoneType = 30 and isnull(cp.RecordDeleted, ''N'') <> ''Y''
LEFT outer join dbo.ClientAddresses as ca on ca.ClientId = c.ClientId and ca.AddressType = 90 and ISNULL(ca.RecordDeleted, ''N'') <> ''Y''
-- where c.ClientId = @ClientID

select
''CustomDocumentDischargeGoals'' as TableName,
-1 as CustomDocumentDischargeGoalId,
'''' AS CreatedBy, 
GETDATE() AS CreatedDate,
'''' AS ModifiedBy,
GETDATE() AS ModifiedDate,
cast(null as char(1)) as RecordDeleted,
cast(null as varchar(30)) as DeletedBy,
cast(null as datetime) as DeletedDate,
-1 as DocumentVersionId,
GoalNumber,
GoalText,
cast(null as char(1)) as GoalRatingProgress
from dbo.CustomTPGoals
where DocumentVersionId = @TxDocumentVersionId
and Active = ''Y''
and ISNULL(RecordDeleted, ''N'') <> ''Y''
order by GoalNumber



' 
END
GO
