/****** Object:  StoredProcedure [dbo].[csp_PostSignatureCAFASNeedFix]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PostSignatureCAFASNeedFix]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PostSignatureCAFASNeedFix]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PostSignatureCAFASNeedFix]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_PostSignatureCAFASNeedFix]

( @DocumentVersionId int )

as 

/*
Temp Need Creation Fix
*/

declare @DocumentVersionIds Table 
( 
 DocumentVersionId int 
,SchoolPerformance	int
,SchoolPerformanceComment	type_Comment2
,HomePerformance	int
,HomePerfomanceComment	type_Comment2
,CommunityPerformance	int
,CommunityPerformanceComment	type_Comment2
,BehaviorTowardsOther	int
,BehaviorTowardsOtherComment	type_Comment2
,MoodsEmotion	int
,MoodsEmotionComment	type_Comment2
,SelfHarmfulBehavior	int
,SelfHarmfulBehaviorComment	type_Comment2
,SubstanceUse	int
,SubstanceUseComment	type_Comment2
,Thinkng	int
,ThinkngComment	type_Comment2
,YouthTotalScore	int
,PrimaryFamilyMaterialNeeds	int
,PrimaryFamilyMaterialNeedsComment	type_Comment2
,PrimaryFamilySocialSupport	int
,PrimaryFamilySocialSupportComment	type_Comment2
,NonCustodialMaterialNeeds	int
,NonCustodialMaterialNeedsComment	type_Comment2
,NonCustodialSocialSupport	int
,NonCustodialSocialSupportComment	type_Comment2
,SurrogateMaterialNeeds	int
,SurrogateMaterialNeedsComment	type_Comment2
,SurrogateSocialSupport	int
,SurrogateSocialSupportComment	type_Comment2
,CreatedBy varchar(30)
,CreatedDate datetime
 )

insert into @DocumentVersionIds
select 
	distinct 
	c2.DocumentVersionId
	,SchoolPerformance
	,SchoolPerformanceComment
	,HomePerformance
	,HomePerfomanceComment
	,CommunityPerformance
	,CommunityPerformanceComment
	,BehaviorTowardsOther
	,BehaviorTowardsOtherComment
	,MoodsEmotion
	,MoodsEmotionComment
	,SelfHarmfulBehavior
	,SelfHarmfulBehaviorComment
	,SubstanceUse
	,SubstanceUseComment
	,Thinkng
	,ThinkngComment
	,YouthTotalScore
	,PrimaryFamilyMaterialNeeds
	,PrimaryFamilyMaterialNeedsComment
	,PrimaryFamilySocialSupport
	,PrimaryFamilySocialSupportComment
	,NonCustodialMaterialNeeds
	,NonCustodialMaterialNeedsComment
	,NonCustodialSocialSupport
	,NonCustodialSocialSupportComment
	,SurrogateMaterialNeeds
	,SurrogateMaterialNeedsComment
	,SurrogateSocialSupport
	,SurrogateSocialSupportComment
	,c2.CreatedBy
	,c2.CreatedDate
from CustomCAFAS2 c2
join DocumentVersions dv on dv.DocumentVersionId = c2.DocumentVersionId and ISNULL(dv.RecordDeleted,''N'')<>''Y''
join Documents d on d.DocumentId= dv.DocumentId and ISNULL(d.RecordDeleted,''N'')<>''Y''
where ISNULL(c2.RecordDeleted,''N'')<>''Y''
and dv.DocumentVersionId = @DocumentVersionId
and d.Status = 22
and d.DocumentCodeId = 1469
and ( 
	 isnull(SchoolPerformance,0) > 10 or 
	 isnull(HomePerformance,0) > 10 or
	 isnull(CommunityPerformance,0) > 10 or
	 isnull(BehaviorTowardsOther,0) > 10 or
	 isnull(MoodsEmotion,0) > 10 or
	 isnull(SelfHarmfulBehavior,0) > 10 or
	 isnull(SubstanceUse,0) > 10 or
	 isnull(Thinkng,0) > 10 or
	 isnull(PrimaryFamilyMaterialNeeds,0) > 10 or
	 isnull(PrimaryFamilySocialSupport,0) > 10 or
	 isnull(SurrogateMaterialNeeds,0) > 10 or
	 isnull(NonCustodialSocialSupport,0) > 10 or
	 isnull(NonCustodialMaterialNeeds,0) > 10 or
	 isnull(SurrogateSocialSupport,0) > 10 
	 --isnull(YouthTotalScore	,0) > 10
	)
and not exists ( select * from CustomHRMAssessmentNeeds cn 
	where cn.DocumentVersionId = c2.DocumentVersionId 
	and cn.HRMNeedId > 1 and cn.HRMNeedId < 17 )

if @DocumentVersionId is not null and exists ( select * from @DocumentVersionIds )
begin

create Table #TempNeeds
( DocumentVersionId int, HRMNeedId int, NeedName varchar(50), NeedStatus int, NeedDate datetime, NeedDescription varchar(max), 
	ClientNeedId int, CreatedBy varchar(30), CreatedDate datetime, ModifiedBy varchar(30), ModifiedDate datetime ) 
--select * from GlobalCodes where Category like ''%status%''
insert into #TempNeeds
Select
	dv.DocumentVersionID, cn.HRMNeedId,
	REPLACE(cn.NeedName,'' - Child'',''''), 5234, getdate(), 
	SchoolPerformanceComment, null, 
	dv.CreatedBy, dv.CreatedDate, dv.CreatedBy, dv.CreatedDate
from @DocumentVersionIds dv 
cross join CustomHRMNeeds cn
where dv.SchoolPerformance >= 20
and cn.HRMNeedId = 2
union
Select
	dv.DocumentVersionID, cn.HRMNeedId,
	REPLACE(cn.NeedName,'' - Child'',''''),  5234, getdate(), HomePerfomanceComment, null, 
	dv.CreatedBy, dv.CreatedDate, dv.CreatedBy, dv.CreatedDate
from @DocumentVersionIds dv 
cross join CustomHRMNeeds cn
where dv.HomePerformance >= 20
and cn.HRMNeedId = 3
union
Select
	dv.DocumentVersionID, cn.HRMNeedId,
	REPLACE(cn.NeedName,'' - Child'',''''), 5234, getdate(),  CommunityPerformanceComment, null, 
	dv.CreatedBy, dv.CreatedDate, dv.CreatedBy, dv.CreatedDate
from @DocumentVersionIds dv 
cross join CustomHRMNeeds cn
where dv.CommunityPerformance >= 20
and cn.HRMNeedId = 4
union
Select
		dv.DocumentVersionID, cn.HRMNeedId, 
	REPLACE(cn.NeedName,'' - Child'',''''), 5234, getdate(), BehaviorTowardsOtherComment, null, 
	dv.CreatedBy, dv.CreatedDate, dv.CreatedBy, dv.CreatedDate
from @DocumentVersionIds dv 
cross join CustomHRMNeeds cn
where dv.BehaviorTowardsOther >= 20
and cn.HRMNeedId = 5
union
Select
		dv.DocumentVersionID, cn.HRMNeedId,
	REPLACE(cn.NeedName,'' - Child'',''''), 5234, getdate(),  MoodsEmotionComment, null, 
	dv.CreatedBy, dv.CreatedDate, dv.CreatedBy, dv.CreatedDate
from @DocumentVersionIds dv 
cross join CustomHRMNeeds cn
where dv.MoodsEmotion >= 20
and cn.HRMNeedId = 6
union
Select
		dv.DocumentVersionID, cn.HRMNeedId,
	REPLACE(cn.NeedName,'' - Child'',''''), 5234, getdate(),  SelfHarmfulBehaviorComment, null, 
	dv.CreatedBy, dv.CreatedDate, dv.CreatedBy, dv.CreatedDate
from @DocumentVersionIds dv 
cross join CustomHRMNeeds cn
where dv.SelfHarmfulBehavior >= 20
and cn.HRMNeedId = 7
union
Select
		dv.DocumentVersionID, cn.HRMNeedId, 
	REPLACE(cn.NeedName,'' - Child'',''''), 5234, getdate(), SubstanceUseComment, null, 
	dv.CreatedBy, dv.CreatedDate, dv.CreatedBy, dv.CreatedDate
from @DocumentVersionIds dv 
cross join CustomHRMNeeds cn
where dv.SubstanceUse >= 20
and cn.HRMNeedId = 8
union
Select
		dv.DocumentVersionID, cn.HRMNeedId,
	REPLACE(cn.NeedName,'' - Child'',''''), 5234, getdate(),  ThinkngComment, null, 
	dv.CreatedBy, dv.CreatedDate, dv.CreatedBy, dv.CreatedDate
from @DocumentVersionIds dv 
cross join CustomHRMNeeds cn
where dv.Thinkng >= 20
and cn.HRMNeedId = 9

union
Select
		dv.DocumentVersionID, cn.HRMNeedId, 
	REPLACE(cn.NeedName,'' - Child'',''''), 5234, getdate(), PrimaryFamilyMaterialNeedsComment, null, 
	dv.CreatedBy, dv.CreatedDate, dv.CreatedBy, dv.CreatedDate
from @DocumentVersionIds dv 
cross join CustomHRMNeeds cn
where dv.PrimaryFamilyMaterialNeeds >= 20
and cn.HRMNeedId = 10
union
Select
		dv.DocumentVersionID, cn.HRMNeedId,
	REPLACE(cn.NeedName,'' - Child'',''''), 5234, getdate(),  PrimaryFamilySocialSupportComment, null, 
	dv.CreatedBy, dv.CreatedDate, dv.CreatedBy, dv.CreatedDate
from @DocumentVersionIds dv 
cross join CustomHRMNeeds cn
where dv.PrimaryFamilySocialSupport >= 20
and cn.HRMNeedId = 11
union
Select
		dv.DocumentVersionID, cn.HRMNeedId,
	REPLACE(cn.NeedName,'' - Child'',''''), 5234, getdate(),  dv.SurrogateMaterialNeedsComment, null, 
	dv.CreatedBy, dv.CreatedDate, dv.CreatedBy, dv.CreatedDate
from @DocumentVersionIds dv 
cross join CustomHRMNeeds cn
where dv.SurrogateMaterialNeeds >= 20
and cn.HRMNeedId = 12
union
Select
		dv.DocumentVersionID, cn.HRMNeedId,
	REPLACE(cn.NeedName,'' - Child'',''''), 5234, getdate(),  dv.NonCustodialMaterialNeedsComment, null, 
	dv.CreatedBy, dv.CreatedDate, dv.CreatedBy, dv.CreatedDate
from @DocumentVersionIds dv 
cross join CustomHRMNeeds cn
where dv.NonCustodialMaterialNeeds >= 20
and cn.HRMNeedId = 14
union
Select
	dv.DocumentVersionID, cn.HRMNeedId, 
	REPLACE(cn.NeedName,'' - Child'',''''), 5234, getdate(), dv.NonCustodialSocialSupportComment, null, 
	dv.CreatedBy, dv.CreatedDate, dv.CreatedBy, dv.CreatedDate
from @DocumentVersionIds dv 
cross join CustomHRMNeeds cn
where dv.NonCustodialSocialSupport >= 20
and cn.HRMNeedId = 15
union
Select
		dv.DocumentVersionID, cn.HRMNeedId, 
	REPLACE(cn.NeedName,'' - Child'',''''), 5234, getdate(), dv.SurrogateSocialSupportComment, null, 
	dv.CreatedBy, dv.CreatedDate, dv.CreatedBy, dv.CreatedDate
from @DocumentVersionIds dv 
cross join CustomHRMNeeds cn
where dv.SurrogateSocialSupport >= 20
and cn.HRMNeedId = 16
order by DocumentVersionId, 2


--select * 
--from #TempNeeds

	begin 
		
		insert into CustomHRMAssessmentNeeds
		( DocumentVersionId, HRMNeedId, NeedName, NeedStatus, NeedDate, NeedDescription, ClientNeedId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate ) 
		select * 
		from #TempNeeds
	end


	begin
		--select  * from CustomClientNeeds order by CreatedDate desc
		INsert into CustomClientNeeds
		( ClientEpisodeId,NeedName,NeedDescription,NeedStatus,AssociatedHRMNeedId,SourceDocumentVersionId,AssessmentUpdateType, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate  )

		select MAX(ce.ClientEpisodeId), t.NeedName, isnull(t.NeedDescription,''''), t.NeedStatus, t.HRMNeedId, t.DocumentVersionId, 
			case ca.AssessmentType when ''I'' then null when ''S'' then null else ca.AssessmentType end,
			t.CreatedBy, t.CreatedDate, t.CreatedBy, t.CreatedDate
		from #TempNeeds t 
		join DocumentVersions dv on dv.DocumentVersionId = t.DocumentVersionId
		join Documents d on d.DocumentId = dv.DocumentId and ISNULL(d.RecordDeleted,''N'')<>''Y''
		join ClientEpisodes ce on ce.ClientId = d.ClientId and ISNULL(ce.RecordDeleted,''N'')<>''Y''
		join CustomHRMAssessments ca on ca.DocumentVersionId= t.DocumentVersionId
		group by t.DocumentVersionId, case ca.AssessmentType when ''I'' then null when ''S'' then null else ca.AssessmentType end,
		 t.NeedName,isnull(t.NeedDescription,''''), t.NeedStatus, t.HRMNeedId, t.CreatedBy, t.CreatedDate, t.CreatedBy, t.CreatedDate
	end


	begin
		--UpdateClientNeedId
		update c 
		set ClientNeedId = ccn.ClientNeedId
		from CustomHRMAssessmentNeeds c
		join #TempNeeds t on t.DocumentVersionId = c.DocumentVersionId
			and c.HRMNeedId = t.HRMNeedId
		join CustomClientNeeds ccn on ccn.SourceDocumentVersionId = t.DocumentVersionId
			and ccn.AssociatedHRMNeedId = t.HRMNeedId
	end

--select * from #TempNeeds
drop table #TempNeeds

end
' 
END
GO
