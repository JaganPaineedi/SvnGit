/****** Object:  StoredProcedure [dbo].[csp_RDLAdmissionRecord]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLAdmissionRecord]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLAdmissionRecord]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLAdmissionRecord]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--csp_RDLAdmissionRecord 112896
create procedure [dbo].[csp_RDLAdmissionRecord]
	@DocumentVersionId int
as

declare @ClientId int

select @ClientId = d.ClientId
from dbo.Documents as d
join dbo.DocumentVersions as dv on dv.DocumentId = d.DocumentId
where dv.DocumentVersionId = @DocumentVersionId

select doc.AssessmentDate, c.ClientId, ce.EpisodeNumber,
c.LastName, c.FirstName, SUBSTRING(c.MiddleName, 1, 1) as MiddleInit,
c.SSN, c.DOB, 
al.AliasName,
c.Sex, ca.HomeAddress, cph.HomePhone, cpw.WorkPhone,
cpo.OtherPhone, cnt.CountyName, cc.MACUCI,
rc.ClientRace,
c.EmploymentInformation,
ce.ReferralSource, ce.ReferralSubType,
ce.InitialRequestDate, ce.AssessmentFirstOffered, ce.IntakeStaff,
doc.PriorTreatmentCounseling, doc.PriorTreatmentCounselingComment, doc.PriorTreatmentCounselingDates,
doc.PriorTreatmentCaseManagement, doc.PriorTreatmentCaseManagementComment, doc.PriorTreatmentCaseManagementDates,
doc.PriorTreatmentMedication, doc.PriorTreatmentMedicationComment, doc.PriorTreatmentMedicationDates,
doc.PriorTreatmentOther, doc.PriorTreatmentOtherComment, doc.PriorTreatmentOtherDates,
covp.PrimaryName,
covp.PrimaryContactPhone,
covp.PrimarySubscriberName,
covp.PrimaryDOB, 
covp.PrimaryInsuredId,
covp.PrimaryGroupNumber,
covp.PrimaryStartDate,
covp.PrimaryEndDate,
covs.SecondaryName,
covs.SecondaryContactPhone,
covs.SecondarySubscriberName,
covs.SecondaryDOB, 
covs.SecondaryInsuredId,
covs.SecondaryGroupNumber,
covs.SecondaryStartDate,
covs.SecondaryEndDate,
ce.ChiefComplaint,
gcMil.CodeName as MilitaryStatus,
c.NumberOfDependents,
gcLang.CodeName as PrimaryLanguage,
c.AnnualHouseholdIncome,
gcLiv.CodeName as LivingArrangement,
gcMari.CodeName as MaritalStatus,
gcOcc.CodeName as EmploymentStatus,
gcEdu.CodeName as EducationalStatus,
fr.FRRelation,
fr.FRName,
fr.FRSSN,
fr.FRDOB, 
fr.FRPhone,
fr.FRWorkPhone, 
fr.FRAddress,
ec.ECRelation,
ec.ECName,
ec.ECSSN,
ec.ECDOB, 
ec.ECPhone,
ec.ECWorkPhone, 
ec.ECAddress,
g.GRelation,
g.GName,
g.GSSN,
g.GDOB, 
g.GPhone,
g.GWorkPhone, 
g.GAddress

from Clients as c
-- Home address
LEFT join (
	select top 1 cad.ClientId, 
		ISNULL(cad.Address, '''') 
			+ case when cad.Address is not null then '', '' else '''' end
			+ ISNULL(cad.City, '''')
			+ case when cad.city is not null then '', '' else '''' end
			+ ISNULL(cad.State, '''') + '' '' + ISNULL(cad.Zip, '''') as HomeAddress
	from dbo.ClientAddresses as cad
	where ClientId = @ClientId
	and (
		cad.AddressType = 90
		--or cad.Billing = ''Y''
	)
	and ISNULL(RecordDeleted, ''N'') <> ''Y''
	order by case when Billing = ''Y'' then 0 else 1 end
) as ca on ca.ClientId = c.ClientId
-- home phone
LEFT join (
	select top 1 cad.ClientId, cad.PhoneNumber as HomePhone
	from dbo.ClientPhones as cad
	where cad.ClientId = @ClientId
	and (
		cad.PhoneType in (30, 32)
		--or cad.Billing = ''Y''
	)
	and ISNULL(cad.DoNotContact, ''N'') <> ''Y''
	and ISNULL(RecordDeleted, ''N'') <> ''Y''
	order by case when ISNULL(cad.IsPrimary, ''N'') = ''Y'' then 0 else 1 end, cad.PhoneType
) as cph on cph.ClientId = c.ClientId
-- work phone
LEFT join (
	select top 1 ClientId, cad.PhoneNumber as WorkPhone
	from dbo.ClientPhones as cad
	where cad.ClientId = @ClientId
	and (
		cad.PhoneType in (31, 33)
		--or cad.Billing = ''Y''
	)
	and ISNULL(cad.DoNotContact, ''N'') <> ''Y''
	and ISNULL(RecordDeleted, ''N'') <> ''Y''
	order by case when ISNULL(cad.IsPrimary, ''N'') = ''Y'' then 0 else 1 end, cad.PhoneType
) as cpw on cpw.ClientId = c.ClientId
-- other phone
LEFT join (
	select top 1 cad.ClientId, cad.PhoneNumber as OtherPhone
	from dbo.ClientPhones as cad
	where cad.ClientId = @ClientId
	and (
		cad.PhoneType not in (30, 31, 32, 33)
		--or cad.Billing = ''Y''
	)
	and ISNULL(cad.DoNotContact, ''N'') <> ''Y''
	and ISNULL(RecordDeleted, ''N'') <> ''Y''
	order by case when ISNULL(cad.IsPrimary, ''N'') = ''Y'' then 0 else 1 end, cad.PhoneType
) as cpo on cpo.ClientId = c.ClientId
LEFT join dbo.CustomClients as cc on cc.ClientId = c.ClientId
-- episode and referral source info
LEFT join (
	select top 1 ce.ClientId, gc.CodeName as ReferralSource, 
		gs.SubCodeName as ReferralSubType,
		ce.InitialRequestDate, ce.AssessmentFirstOffered,
		s.LastName + '', '' + s.FirstName as IntakeStaff,
		ce.ReferralComment as ChiefComplaint, ce.EpisodeNumber
	from dbo.ClientEpisodes as ce
	LEFT join dbo.GlobalCodes as gc on gc.GlobalCodeId = ce.ReferralType
	LEFT join dbo.GlobalSubCodes as gs on gs.GlobalSubCodeId = ce.ReferralSubtype
	LEFT join dbo.Staff as s on s.StaffId = ce.IntakeStaff
	where ce.ClientId = @ClientId
	and ISNULL(ce.RecordDeleted, ''N'') <> ''Y''
	and not exists (
		select *
		from dbo.ClientEpisodes as ce2
		where ce2.ClientId = ce.ClientId
		and ce2.EpisodeNumber > ce.EpisodeNumber
		and ISNULL(ce2.RecordDeleted, ''N'') <> ''Y''
	)
) as ce on ce.ClientId = c.ClientId
-- primary coverage
LEFT join (
	select top 1 ccp.ClientId, cp.DisplayAs as PrimaryName, cp.ContactPhone as PrimaryContactPhone,
		case when ISNULL(ccp.ClientIsSubscriber, ''N'') = ''Y'' then ''(self)'' else cc.LastName + '','' + cc.FirstName end as PrimarySubscriberName,
		case when ISNULL(ccp.ClientIsSubscriber, ''N'') = ''Y'' then cl.DOB else cc.DOB end as PrimaryDOB,
		ccp.InsuredId as PrimaryInsuredId,
		ccp.GroupNumber as PrimaryGroupNumber,
		cch.StartDate as PrimaryStartDate,
		cch.EndDate as PrimaryEndDate
	from dbo.ClientCoveragePlans as ccp
	join Clients as cl on cl.ClientId = ccp.ClientId
	join dbo.CoveragePlans as cp on cp.CoveragePlanId = ccp.CoveragePlanId
	join dbo.ClientCoverageHistory as cch on cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
	LEFT join dbo.ClientContacts as cc on cc.ClientContactId = ccp.SubscriberContactId
	where ccp.ClientId = @ClientId
	and cch.COBOrder = 1
	and ISNULL(ccp.RecordDeleted, ''N'') <> ''Y''
	and ISNULL(cch.RecordDeleted, ''N'') <> ''Y''
	and DATEDIFF(DAY, cch.StartDate, GETDATE()) >= 0
	and (
		DATEDIFF(DAY, cch.EndDate, GETDATE()) <= 0
		or (cch.EndDate is null)
	)
) as covp on covp.ClientId = c.ClientId
-- Secondary coverage
LEFT join (
	select top 1 ccp.ClientId, cp.DisplayAs as SecondaryName, cp.ContactPhone as SecondaryContactPhone,
		case when ISNULL(ccp.ClientIsSubscriber, ''N'') = ''Y'' then ''(self)'' else cc.LastName + '','' + cc.FirstName end as SecondarySubscriberName,
		case when ISNULL(ccp.ClientIsSubscriber, ''N'') = ''Y'' then cl.DOB else cc.DOB end as SecondaryDOB,
		ccp.InsuredId as SecondaryInsuredId,
		ccp.GroupNumber as SecondaryGroupNumber,
		cch.StartDate as SecondaryStartDate,
		cch.EndDate as SecondaryEndDate
	from dbo.ClientCoveragePlans as ccp
	join Clients as cl on cl.ClientId = ccp.ClientId
	join dbo.CoveragePlans as cp on cp.CoveragePlanId = ccp.CoveragePlanId
	join dbo.ClientCoverageHistory as cch on cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
	LEFT join dbo.ClientContacts as cc on cc.ClientContactId = ccp.SubscriberContactId
	where ccp.ClientId = @ClientId
	and cch.COBOrder = 2
	and ISNULL(ccp.RecordDeleted, ''N'') <> ''Y''
	and ISNULL(cch.RecordDeleted, ''N'') <> ''Y''
	and DATEDIFF(DAY, cch.StartDate, GETDATE()) >= 0
	and (
		DATEDIFF(DAY, cch.EndDate, GETDATE()) <= 0
		or (cch.EndDate is null)
	)
) as covs on covs.ClientId = c.ClientId
-- Financially Responsible
LEFT join (
	select top 1 cc.ClientId, cc.LastName + '', '' + cc.FirstName as FRName,
		cc.SSN as FRSSN, cc.DOB as FRDOB, cap.PhoneNumber as FRPhone,
		caw.PhoneNumber as FRWorkPhone, 
		ISNULL(cad.Address, '''') 
			+ case when cad.Address is not null then '', '' else '''' end
			+ ISNULL(cad.City, '''')
			+ case when cad.city is not null then '', '' else '''' end
			+ ISNULL(cad.State, '''') + '' '' + ISNULL(cad.Zip, '''') as FRAddress,
		gcRel.CodeName as FRRelation
	from dbo.ClientContacts as cc
	LEFT join dbo.GlobalCodes as gcRel on gcRel.GlobalCodeId = cc.Relationship
	left join dbo.ClientContactAddresses as cad on cad.ClientContactId = cc.ClientContactId
		and (
				cad.AddressType = 90
		)
		and ISNULL(cad.RecordDeleted, ''N'') <> ''Y''
	left join dbo.ClientContactPhones as cap on cap.ClientContactId = cc.ClientContactId
		and (
				cap.PhoneType in (30, 32)
		)
		and ISNULL(cap.RecordDeleted, ''N'') <> ''Y''
	left join dbo.ClientContactPhones as caw on caw.ClientContactId = cc.ClientContactId
		and (
				caw.PhoneType in (31, 33)
		)
		and ISNULL(caw.RecordDeleted, ''N'') <> ''Y''
	where cc.ClientId = @ClientId
	and cc.FinanciallyResponsible = ''Y''
	and ISNULL(cc.RecordDeleted, ''N'') <> ''Y''
) as fr on fr.ClientId = c.ClientId
-- Emergency Contact
LEFT join (
	select top 1 cc.ClientId, cc.LastName + '', '' + cc.FirstName as ECName,
		cc.SSN as ECSSN, cc.DOB as ECDOB, cap.PhoneNumber as ECPhone,
		caw.PhoneNumber as ECWorkPhone, 
		ISNULL(cad.Address, '''') 
			+ case when cad.Address is not null then '', '' else '''' end
			+ ISNULL(cad.City, '''')
			+ case when cad.city is not null then '', '' else '''' end
			+ ISNULL(cad.State, '''') + '' '' + ISNULL(cad.Zip, '''') as ECAddress,
		gcRel.CodeName as ECRelation
	from dbo.ClientContacts as cc
	LEFT join dbo.GlobalCodes as gcRel on gcRel.GlobalCodeId = cc.Relationship
	left join dbo.ClientContactAddresses as cad on cad.ClientContactId = cc.ClientContactId
		and (
				cad.AddressType = 90
		)
		and ISNULL(cad.RecordDeleted, ''N'') <> ''Y''
	left join dbo.ClientContactPhones as cap on cap.ClientContactId = cc.ClientContactId
		and (
				cap.PhoneType in (30, 32)
		)
		and ISNULL(cap.RecordDeleted, ''N'') <> ''Y''
	left join dbo.ClientContactPhones as caw on caw.ClientContactId = cc.ClientContactId
		and (
				caw.PhoneType in (31, 33)
		)
		and ISNULL(caw.RecordDeleted, ''N'') <> ''Y''
	where cc.ClientId = @ClientId
	and cc.EmergencyContact = ''Y''
	and ISNULL(cc.RecordDeleted, ''N'') <> ''Y''
) as ec on ec.ClientId = c.ClientId
-- Guardian
LEFT join (
	select top 1 cc.ClientId, cc.LastName + '', '' + cc.FirstName as GName,
		cc.SSN as GSSN, cc.DOB as GDOB, cap.PhoneNumber as GPhone,
		caw.PhoneNumber as GWorkPhone, 
		ISNULL(cad.Address, '''') 
			+ case when cad.Address is not null then '', '' else '''' end
			+ ISNULL(cad.City, '''')
			+ case when cad.city is not null then '', '' else '''' end
			+ ISNULL(cad.State, '''') + '' '' + ISNULL(cad.Zip, '''') as GAddress,
		gcRel.CodeName as GRelation
	from dbo.ClientContacts as cc
	LEFT join dbo.GlobalCodes as gcRel on gcRel.GlobalCodeId = cc.Relationship
	left join dbo.ClientContactAddresses as cad on cad.ClientContactId = cc.ClientContactId
		and (
				cad.AddressType = 90
		)
		and ISNULL(cad.RecordDeleted, ''N'') <> ''Y''
	left join dbo.ClientContactPhones as cap on cap.ClientContactId = cc.ClientContactId
		and (
				cap.PhoneType in (30, 32)
		)
		and ISNULL(cap.RecordDeleted, ''N'') <> ''Y''
	left join dbo.ClientContactPhones as caw on caw.ClientContactId = cc.ClientContactId
		and (
				caw.PhoneType in (31, 33)
		)
		and ISNULL(caw.RecordDeleted, ''N'') <> ''Y''
	where cc.ClientId = @ClientId
	and cc.Guardian = ''Y''
	and ISNULL(cc.RecordDeleted, ''N'') <> ''Y''
) as g on g.ClientId = c.ClientId
LEFT join (
	select top 1 d.ClientId, d.EffectiveDate as AssessmentDate, da.PriorTreatmentCounseling, da.PriorTreatmentCounselingComment, da.PriorTreatmentCounselingDates,
	da.PriorTreatmentCaseManagement, da.PriorTreatmentCaseManagementComment, da.PriorTreatmentCaseManagementDates,
	da.PriorTreatmentMedication, da.PriorTreatmentMedicationComment, da.PriorTreatmentMedicationDates,
	da.PriorTreatmentOther, da.PriorTreatmentOtherComment, da.PriorTreatmentOtherDates
	from dbo.Documents as d
	join dbo.CustomDocumentDiagnosticAssessments as da on da.DocumentVersionId = d.CurrentDocumentVersionId
	where d.ClientId = @ClientId
	and d.Status = 22
	and ISNULL(d.RecordDeleted, ''N'') <> ''Y''
	order by EffectiveDate desc
) as doc on doc.ClientId = c.ClientId
LEFT join GlobalCodes as gcMil on gcMil.GlobalCodeId = c.MilitaryStatus
LEFT join GlobalCodes as gcLang on gcLang.GlobalCodeId = c.PrimaryLanguage
LEFT join GlobalCodes as gcLiv on gcLiv.GlobalCodeId = c.LivingArrangement
LEFT join GlobalCodes as gcMari on gcMari.GlobalCodeId = c.MaritalStatus
LEFT join GlobalCodes as gcOcc on gcOcc.GlobalCodeId = c.EmploymentStatus
LEFT join GlobalCodes as gcEdu on gcEdu.GlobalCodeId = c.EducationalStatus
LEFT join (
	select top 1 cr.ClientId, gcr.CodeName as ClientRace
	from dbo.ClientRaces as cr
	join dbo.GlobalCodes as gcr on gcr.GlobalCodeId = cr.ClientRaceId
	where cr.ClientId = @ClientId
	and ISNULL(cr.RecordDeleted, ''N'') <> ''Y''
) as rc on rc.ClientId = c.ClientId
LEFT join counties as cnt on cnt.CountyFIPS = c.CountyOfResidence
LEFT join (
	select top 1 ca.ClientId, ca.FirstName + '' '' + ca.LastName as AliasName
	from dbo.ClientAliases as ca
	where ca.ClientId = @ClientId
	and ca.AliasType <> 4221
	and ISNULL(ca.RecordDeleted, ''N'') <> ''Y''
) as al on al.ClientId = c.ClientId
where c.ClientId = @ClientId

' 
END
GO
