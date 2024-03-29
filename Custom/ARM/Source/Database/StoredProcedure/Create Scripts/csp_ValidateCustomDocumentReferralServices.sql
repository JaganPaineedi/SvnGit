/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomDocumentReferralServices]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentReferralServices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomDocumentReferralServices]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentReferralServices]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure [dbo].[csp_ValidateCustomDocumentReferralServices]
	@DocumentVersionId int
as

declare @AutoApproveReferralAuthorizationCodes table (
	AuthorizationCodeId int
)
insert into @AutoApproveReferralAuthorizationCodes
        (AuthorizationCodeId)	-- from AuthorizationCodes table
values 
	(10),	--	Developmental Pediatric Consultation
	(11),	--	Integrated Primary Care
	(13),	--	Pharmacologic Management
	(14),	--	Psychiatric Evaluation
	(15)	--	Psychological Testing

declare @referralTransferServices table (
	AuthorizationCodeId int
)
insert into @referralTransferServices values
(1),
(2),
(3),
(4),
(5),
(6),
(7),
(8),
(9),
(10),
(11),
(12),
(13),
(14),
(15),
(16),
(17),
(18)

declare @txPlanReferralTransferServices table (
	AuthorizationCodeId int
)
insert into @txPlanReferralTransferServices 
        (AuthorizationCodeId)
values
(1),
(2),
(9),
(12),
(13)

declare @referralTxCodes table (
	ReferralCodeId int,
	TxPlanId int
)

insert into @referralTxCodes
        (ReferralCodeId, TxPlanId)
values  
(1,1),
(2,2),
(3,1),
(4,1),
(5,2),
(6,2),
(7,2),
(8,2),
(9,9),
(12,12),
(13,13)

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
and ISNULL(d.RecordDeleted, ''N'') <> ''Y''
and not exists (
	select *
	from dbo.Documents as d2
	where d2.ClientId = d.ClientId
	and d2.Status = 22
	and d2.DocumentCodeId in (1483, 1484, 1485)
	and ((d2.EffectiveDate > d.EffectiveDate)
			or (d2.EffectiveDate = d.EffectiveDate and d2.DocumentId > d.DocumentId))
	and ISNULL(d2.RecordDeleted, ''N'') <> ''Y''
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
select ''CustomDocumentReferralServices'' as TableName, ''DeletedBy'' as ColumnName, LEFT(''Service not not on tx plan: '' + ac.DisplayAs, 100), 1, 2
from dbo.CustomDocumentReferralServices as rs
join dbo.AuthorizationCodes as ac on ac.AuthorizationCodeId = rs.AuthorizationCodeId
where rs.DocumentVersionId = @DocumentVersionId
and ISNULL(rs.RecordDeleted, ''N'') <> ''Y''
and not exists (
	select *
	from dbo.CustomTPServices as tps
	join dbo.CustomTPGoals as tpg on tpg.TPGoalId = tps.TPGoalId
	join @referralTxCodes as r on r.TxPlanId = tps.AuthorizationCodeId
	where tpg.DocumentVersionId = @mostRecentTxPlan
	and ISNULL(tps.RecordDeleted, ''N'') <> ''Y''
	and ISNULL(tpg.RecordDeleted, ''N'') <> ''Y''
	and r.ReferralCodeId = rs.AuthorizationCodeId
)
-- and it needs to be validated
and exists (
	select *
	from @referralTxCodes as r
	where r.ReferralCodeId = rs.AuthorizationCodeId
)


' 
END
GO
