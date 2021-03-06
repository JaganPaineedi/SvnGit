/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomDocumentDischarges]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentDischarges]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomDocumentDischarges]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentDischarges]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
Create procedure [dbo].[csp_ValidateCustomDocumentDischarges]
	@DocumentVersionId int

as

create Table #CustomDocumentDischarges ( 
	[DocumentVersionId] [int] ,
	[CreatedBy] varchar(30) ,
	[CreatedDate] datetime ,
	[ModifiedBy] varchar(30) ,
	[ModifiedDate] datetime ,
	[RecordDeleted] char(1) ,
	[DeletedBy] varchar(30) ,
	[DeletedDate] [datetime] ,
	[ClientAddress] [varchar](max) ,
	[HomePhone] varchar(100) ,
	[ParentGuardianName] [varchar](250) ,
	[AdmissionDate] [datetime] ,
	[LastServiceDate] [datetime] ,
	[DischargeDate] [datetime] ,
	[DischargeTransitionCriteria] varchar(max) ,
	[ServicesParticpated] varchar(max) ,
	[MedicationsPrescribed] varchar(max) ,
	[PresentingProblem] varchar(max) ,
	[ReasonForDischarge] varchar(max) ,
	[ReasonForDischargeCode] int ,
	[ClientParticpation] int ,
	[ClientStatusLastContact] int ,
	[ClientStatusComment] varchar(max) ,
	[ReferralPreference1] int ,
	[ReferralPreference2] int ,
	[ReferralPreference3] int ,
	[ReferralPreferenceOther] char(1) ,
	[ReferralPreferenceComment] varchar(max) ,
	[InvoluntaryTermination] char(1) ,
	[ClientInformedRightAppeal] char(1) ,
	[StaffMemberContact72Hours] char(1),
	[DASTScore] int ,
	[MASTScore] int ,
	[InitialLevelofCare] int ,
	[DischargeLevelofCare] int  
)

--***INSERT LIST***--
insert into #CustomDocumentDischarges
(
DocumentVersionId
,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate
,RecordDeleted
,DeletedBy
,DeletedDate
,ClientAddress
,HomePhone
,ParentGuardianName
,AdmissionDate
,LastServiceDate
,DischargeDate
,DischargeTransitionCriteria
,ServicesParticpated
,MedicationsPrescribed
,PresentingProblem
,ReasonForDischarge
,ReasonForDischargeCode
,ClientParticpation
,ClientStatusLastContact
,ClientStatusComment
,ReferralPreference1
,ReferralPreference2
,ReferralPreference3
,ReferralPreferenceOther
,ReferralPreferenceComment
,InvoluntaryTermination
,ClientInformedRightAppeal
,StaffMemberContact72Hours
,DASTScore
,MASTScore 
,InitialLevelofCare
,DischargeLevelofCare  
)
select 
DocumentVersionId
,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate
,RecordDeleted
,DeletedBy
,DeletedDate
,ClientAddress
,HomePhone
,ParentGuardianName
,AdmissionDate
,LastServiceDate
,DischargeDate
,DischargeTransitionCriteria
,ServicesParticpated
,MedicationsPrescribed
,PresentingProblem
,ReasonForDischarge
,ReasonForDischargeCode
,ClientParticpation
,ClientStatusLastContact
,ClientStatusComment
,ReferralPreference1
,ReferralPreference2
,ReferralPreference3
,ReferralPreferenceOther
,ReferralPreferenceComment
,InvoluntaryTermination
,ClientInformedRightAppeal
,StaffMemberContact72Hours
,DASTScore
,MASTScore 
,InitialLevelofCare
,DischargeLevelofCare  

from CustomDocumentDischarges
where DocumentVersionId = @DocumentVersionId


insert into #ValidationReturnTable (
	TableName,  
	ColumnName,  
	ErrorMessage,  
	TabOrder,  
	ValidationOrder  
)
select ''CustomDocumentDischarges'', ''DeletedBy'', ''Discharge - Date of admission required'', 1, 1
from #CustomDocumentDischarges
where AdmissionDate is null
union
select ''CustomDocumentDischarges'', ''DeletedBy'', ''Discharge - Last date of service required'', 1, 2
from #CustomDocumentDischarges
where LastServiceDate is null
union
select ''CustomDocumentDischarges'', ''DeletedBy'', ''Discharge - Date of discharge required'', 1, 3
from #CustomDocumentDischarges
where DischargeDate is null
union
select ''CustomDocumentDischarges'', ''DeletedBy'', ''Discharge - Discharge/transition criteria required'', 1, 3
from #CustomDocumentDischarges
where len(ltrim(rtrim(isnull(DischargeTransitionCriteria, '''')))) = 0
union
select ''CustomDocumentDischarges'', ''DeletedBy'', ''Discharge - "Services client has participated in..." required'', 1, 3
from #CustomDocumentDischarges
where len(ltrim(rtrim(isnull(ServicesParticpated, '''')))) = 0
union
select ''CustomDocumentDischarges'', ''DeletedBy'', ''Discharge - "Medications currently prescribed..." required'', 1, 3
from #CustomDocumentDischarges
where len(ltrim(rtrim(isnull(MedicationsPrescribed, '''')))) = 0
union
select ''CustomDocumentDischarges'', ''DeletedBy'', ''Discharge - Presenting problem required'', 1, 3
from #CustomDocumentDischarges
where len(ltrim(rtrim(isnull(PresentingProblem, '''')))) = 0
union
select ''CustomDocumentDischarges'', ''DeletedBy'', ''Discharge - Reason for discharge required'', 1, 3
from #CustomDocumentDischarges
where len(ltrim(rtrim(isnull(ReasonForDischarge, '''')))) = 0
and ReasonForDischargeCode is null
union
select ''CustomDocumentDischarges'', ''DeletedBy'', ''Discharge - Client participation selection required'', 1, 3
from #CustomDocumentDischarges
where ClientParticpation is null
union
select ''CustomDocumentDischarges'', ''DeletedBy'', ''Discharge - Client status at last contact selection required'', 1, 3
from #CustomDocumentDischarges
where ClientStatusLastContact is null
union
select ''CustomDocumentDischarges'', ''DeletedBy'', ''Discharge - Client status at last contact comment required'', 1, 3
from #CustomDocumentDischarges
where ClientStatusLastContact = 2
and len(ltrim(rtrim(isnull(ClientStatusComment, '''')))) = 0
union
select ''CustomDocumentDischarges'', ''DeletedBy'', ''Discharge - Referral comment required'', 1, 3
from #CustomDocumentDischarges
where len(ltrim(rtrim(isnull([ReferralPreferenceComment], '''')))) = 0
and isnull([ReferralPreferenceOther], ''N'') = ''Y''
union
select ''CustomDocumentDischarges'', ''DeletedBy'', ''Discharge date cannot occurr before admission date'', 1, 3
from #CustomDocumentDischarges
where datediff(DAY, AdmissionDate, DischargeDate) < 0
union
select ''CustomDocumentDischargeGoals'', ''DeletedBy'', ''Progress toward Goal # '' + cast(GoalNumber as varchar) + '' - rating of progress required'', 1, 3
from CustomDocumentDischargeGoals
where DocumentVersionId = @DocumentVersionId
and isnull(RecordDeleted, ''N'') <> ''Y''
and GoalRatingProgress is null
union
select ''CustomDocumentDischarges'', ''DeletedBy'', ''Cannot complete discharge because future, mental health service appointments exist.'', 1, 4
where exists (
	select *
	from dbo.DocumentVersions as dv
	join dbo.Documents as d on d.DocumentId = dv.DocumentId
	join dbo.Services as s on s.ClientId = d.ClientId
	join dbo.Programs as pg on pg.ProgramId = s.ProgramId
	where dv.DocumentVersionId = @DocumentVersionId
	and s.Status = 70
	and pg.ServiceAreaId = 3	-- Mental Health
	and DATEDIFF(DAY, s.DateOfService, GETDATE()) <= 0
	and ISNULL(d.RecordDeleted, ''N'') = ''N''
	and ISNULL(s.RecordDeleted, ''N'') = ''N''
)

UNION 
      SELECT ''CustomDocumentDischarges''  ,''InitialLevelofCare'' ,''Should Select Initial Level of Care'', 1,5
      FROM   #CustomDocumentDischarges
      WHERE   InitialLevelofCare is  null
                    
 UNION 
      SELECT ''CustomDocumentDischarges''  ,''DischargeLevelofCare'' ,''Should Select Discharge Level of Care'', 1,6
      FROM   #CustomDocumentDischarges
      WHERE   DischargeLevelofCare is  null
' 
END
GO
