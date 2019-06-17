
if OBJECT_ID('csp_ValidateCustomTransferServices', 'P') is not null
	drop procedure csp_ValidateCustomTransferServices
go

CREATE procedure [dbo].[csp_ValidateCustomTransferServices]
	@DocumentVersionId int
as

declare @AutoApproveTransferAuthorizationCodes table (
	AuthorizationCodeId int
)
insert into @AutoApproveTransferAuthorizationCodes
        (AuthorizationCodeId)	-- from AuthorizationCodes table
values 
	(10),	--	Developmental Pediatric Consultation
	(11),	--	Integrated Primary Care
	(13),	--	Pharmacologic Management
	(14),	--	Psychiatric Evaluation
	(15)	--	Psychological Testing

declare @ClientId int
declare @mostRecentTxPlan int

select @ClientId = clientid 
from dbo.Documents as d
join dbo.DocumentVersions as dv on dv.DocumentId = d.DocumentId
where dv.DocumentVersionId = @DocumentVersionId

select @mostRecentTxPlan = d.CurrentDocumentVersionId
from dbo.Documents as d
where d.ClientId = @ClientId
and d.Status = 22
and d.DocumentCodeId in (1483, 1484, 1485)
and ISNULL(d.RecordDeleted, 'N') <> 'Y'
and not exists (
	select d2.DocumentId
,d2.CreatedBy
,d2.CreatedDate
,d2.ModifiedBy
,d2.ModifiedDate
,d2.RecordDeleted
,d2.DeletedDate
,d2.DeletedBy
,d2.ClientId
,d2.ServiceId
,d2.GroupServiceId
,d2.EventId
,d2.ProviderId
,d2.DocumentCodeId
,d2.EffectiveDate
,d2.DueDate
,d2.Status
,d2.AuthorId
,d2.CurrentDocumentVersionId
,d2.DocumentShared
,d2.SignedByAuthor
,d2.SignedByAll
,d2.ToSign
,d2.ProxyId
,d2.UnderReview
,d2.UnderReviewBy
,d2.RequiresAuthorAttention
,d2.InitializedXML
,d2.BedAssignmentId
,d2.ReviewerId
,d2.InProgressDocumentVersionId
,d2.CurrentVersionStatus
,d2.ClientLifeEventId
,d2.AppointmentId
	from dbo.Documents as d2
	where d2.ClientId = d.ClientId
	and d2.Status = 22
	and d2.DocumentCodeId in (1483, 1484, 1485)
	and ((d2.EffectiveDate > d.EffectiveDate)
			or (d2.EffectiveDate = d.EffectiveDate and d2.DocumentId > d.DocumentId))
	and ISNULL(d2.RecordDeleted, 'N') <> 'Y'
)

-- if treatment plan does not yet exist, return
if @mostRecentTxPlan is null return

Insert into #validationReturnTable (
	TableName,  
	ColumnName,  
	ErrorMessage,  
	TabOrder,  
	ValidationOrder  
)
select 'CustomDocumentTransfers', 'DeletedBy', LEFT('Service not not on tx plan: ' + ac.AuthorizationCodeName, 100), '', ''
from dbo.CustomTransferServices as rs
join dbo.AuthorizationCodes as ac on ac.AuthorizationCodeId = rs.AuthorizationCodeId
where rs.DocumentVersionId = @DocumentVersionId
and ISNULL(rs.RecordDeleted, 'N') <> 'Y'
and not exists (
	select *
	from @AutoApproveTransferAuthorizationCodes as aa
	where aa.AuthorizationCodeId = rs.AuthorizationCodeId
)
and not exists (
	select tps.TPServiceId
,tps.CreatedBy
,tps.CreatedDate
,tps.ModifiedBy
,tps.ModifiedDate
,tps.RecordDeleted
,tps.DeletedDate
,tps.DeletedBy
,tps.TPGoalId
,tps.ServiceNumber
,tps.AuthorizationCodeId
,tps.Units
,tps.FrequencyType
,tps.Status
,tps.DeletionNotAllowed
	from dbo.CustomTPServices as tps
	join dbo.CustomTPGoals as tpg on tpg.TPGoalId = tps.TPGoalId
	where tpg.DocumentVersionId = @mostRecentTxPlan
	and ISNULL(tpg.RecordDeleted, 'N') <> 'Y'
	and ((tps.AuthorizationCodeId = rs.AuthorizationCodeId)
		or exists (
			select acrs.AuthorizationCodeProcedureCodeId
,acrs.AuthorizationCodeId
,acrs.ProcedureCodeId
,acrs.RowIdentifier
,acrs.CreatedBy
,acrs.CreatedDate
,acrs.ModifiedBy
,acrs.ModifiedDate
,acrs.RecordDeleted
,acrs.DeletedDate
,acrs.DeletedBy
			from dbo.AuthorizationCodeProcedureCodes as acrs
			join dbo.AuthorizationCodeProcedureCodes as actp on actp.ProcedureCodeId = acrs.ProcedureCodeId
			where actp.AuthorizationCodeId = tps.AuthorizationCodeId
			and acrs.AuthorizationCodeId = rs.AuthorizationCodeId
			and ISNULL(acrs.RecordDeleted, 'N') <> 'Y'
			and ISNULL(actp.RecordDeleted, 'N') <> 'Y'
		)
	)
)

go

