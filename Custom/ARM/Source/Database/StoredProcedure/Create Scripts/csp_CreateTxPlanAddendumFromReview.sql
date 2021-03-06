/****** Object:  StoredProcedure [dbo].[csp_CreateTxPlanAddendumFromReview]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CreateTxPlanAddendumFromReview]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CreateTxPlanAddendumFromReview]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CreateTxPlanAddendumFromReview]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_CreateTxPlanAddendumFromReview]
/******************************************************************************      
**  File:       
**  Name: csp_CreateTxPlanAddendumFromReview      
**  Desc: Creates a treatment plan addendum based on a periodic review.  Copies
**  all goals, associated needs, objectives and interventions from the review.
**  Copies appropriate values from the treatment plan addendum.
**      
**       
**  Called by: csp_CheckPeriodicReviewForTxPlanChanges
**                    
**  Parameters:      
**  Input
**  @PRDocumentId -- Id of periodic review to copy to the new addendum
**  @PRVersion    -- version of periodic review copy to the new addendum
**  @ReasonForAddendum -- reason the addendum was created by the system
**
**  Author:  Tom Remisoski
**  Date:  08/14/2008
*******************************************************************************      
**  Change History      
*******************************************************************************      
**  Date:  Author:    Description:      
**  --------  --------    ----------------------------------------------------      
	09/16/2008 avoss	  Changed logic find most recent tp
    11/4/2008  sferenz	  Changed logic for finding most recent tp
    31/08/2011  shifali	  removed column GoalMonitoredBy from tpneeds table as per DM Change
*******************************************************************************/    
	@PRDocumentVersionId int,
	@ReasonForAddendum varchar(max)
as

declare @NeedMap table(oldNeedId int, newNeedId int)
declare @ObjMap table(oldObjId int, newObjId int)
declare @IntMap table(oldIntId int, newIntId int)


declare @OldTxDocumentId int
declare @NewDocumentId int, @NewDocumentVersionId int

declare @AddendumDocumentCodeId int
set @AddendumDocumentCodeId = 503

declare @ClientId int


begin try
	begin tran

	/*
	
	-- identify the old treatment plan.  easiest way to do this is through the source need id of one of the
	-- tpneeds on the periodic review
	select top 1 @OldTxDocumentId = oldTPN.DocumentId
	from TPNeeds as newTPN
	join TPNeeds as oldTPN on oldTPN.NeedId = newTPN.SourceNeedId
	where newTPN.DocumentId = @PRDocumentId
	and newTPN.Version = @PRVersion
	and isnull(newTPN.RecordDeleted, ''N'') <> ''Y''
	and isnull(oldTPN.RecordDeleted, ''N'') <> ''Y''
	*/
	--Get the ClientId to find most recent treatment plan
	select @ClientId = d.ClientId 
	from Documents d 
	JOIN DocumentVersions dv ON d.DocumentId = dv.DocumentId
	where dv.DocumentVersionId = @PRDocumentVersionId
	-- Get the Most Recent treatment plan.

	select top 1  @OldTxDocumentId = d.DocumentId from Documents d
	where d.ClientId = @ClientId
	and not exists (select * from documents d2 
					where  d2.EffectiveDate > d.EffectiveDate
					and d2.Status = 22
					and d2.ClientId = d.ClientId
					and d2.documentcodeid in (2, 350,503)
					and isnull(d2.RecordDeleted, ''N'') <> ''Y'' )
	and d.documentcodeid in (2, 350,503)
	and d.Status = 22
	and isnull(d.RecordDeleted, ''N'') <> ''Y''
	order by d.documentid desc
	
	
	-- Create the documents record
	insert into Documents(ClientId, DocumentCodeId, EffectiveDate, DueDate, Status, AuthorId, DocumentShared, 
		SignedByAuthor, SignedByAll, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select d.ClientId, @AddendumDocumentCodeId, getdate(), null, 21, d.AuthorId,  ''N'',
		''N'', ''N'', ''sa'', getdate(), ''sa'', getdate()
	from Documents d 
	JOIN DocumentVersions dv ON d.DocumentId = dv.DocumentId
	where dv.DocumentVersionId = @PRDocumentVersionId

	set @NewDocumentId = @@identity

	-- Create the DocumentVersion record
	insert into DocumentVersions(DocumentId, Version, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	values(@NewDocumentId, 1, ''sa'', getdate(), ''sa'', getdate())

	set @NewDocumentVersionId = @@identity

	update d
	set CurrentDocumentVersionId = @NewDocumentVersionId
	from Documents d
	where DocumentId = @NewDocumentID

	-- DocumentSignatures record for Author
	insert into DocumentSignatures(DocumentId, SignedDocumentVersionId, StaffId, ClientId, IsClient, SignatureOrder, 
		CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select @NewDocumentId, @NewDocumentVersionId, ds.StaffId, ds.ClientId, ds.IsClient, 1,
		''sa'', getdate(), ''sa'', getdate()
	from DocumentVersions dv
	JOIN DocumentVersions dv1 ON dv.DocumentId = dv1.DocumentId and dv1.Version = 1
	JOIN DocumentSignatures as ds ON dv1.DocumentId = ds.DocumentId and ds.SignedDocumentVersionId = dv1.DocumentVersionId
	where dv.DocumentVersionId = @PRDocumentVersionId
	and ds.SignatureOrder = 1
	and isnull(ds.RecordDeleted, ''N'') <> ''Y''

	-- Treatment plan records
	insert into TPGeneral(DocumentVersionId, PlanOrAddendum,
		MeetingDate,
		Participants,
		HopesAndDreams,
		Barriers,
		PurposeOfAddendum,
		StrengthsAndPreferences,
		AreasOfNeed, 
		Diagnosis,
		AuthorizedServices,
		DeferredTreatmentIssues,
		PersonsNotPresent,
		DischargeCriteria, 
		PeriodicReviewDueDate,
		PlanDeliveryMethod,
		ClientAcceptedPlan,
		CrisisPlanNotNecessary,
		CrisisPlan,
		OtherComment,
		PlanDeliveredDate, 
		PeriodicReviewFrequencyNumber,
		StaffId1,
		PeriodicReviewFrequencyUnitType, 
		Assigned,
		CreatedBy,
		CreatedDate,
		ModifiedBy,
		ModifiedDate
	)
	select @NewDocumentVersionId, ''A'', 
		tp.MeetingDate,
		tp.Participants,
		tp.HopesAndDreams,
		tp.Barriers,
		@ReasonForAddendum,
		tp.StrengthsAndPreferences,
		tp.AreasOfNeed, 
		tp.Diagnosis,
		tp.AuthorizedServices,
		tp.DeferredTreatmentIssues,
		tp.PersonsNotPresent,
		tp.DischargeCriteria, 
		tp.PeriodicReviewDueDate,
		tp.PlanDeliveryMethod,
		tp.ClientAcceptedPlan,
		tp.CrisisPlanNotNecessary,
		tp.CrisisPlan,
		tp.OtherComment,
		tp.PlanDeliveredDate, 
		tp.PeriodicReviewFrequencyNumber,
		tp.StaffId1,
		tp.PeriodicReviewFrequencyUnitType, 
		tp.Assigned,
		tp.CreatedBy,
		getdate(),
		tp.ModifiedBy,
		getdate()
	from TPGeneral as tp
	join Documents as d on d.CurrentDocumentVersionId = tp.DocumentVersionId
	where d.DocumentId = @OldTxDocumentId
	and isnull(tp.RecordDeleted, ''N'') <> ''Y''

	-- tpneeds
	delete @NeedMap
	declare @OldNeedId int, @NewNeedId int

	declare c2 insensitive cursor for
	select tpn.NeedId
	from TPNeeds as tpn
	where tpn.DocumentVersionId = @PRDocumentVersionId
	and isnull(tpn.RecordDeleted, ''N'') <> ''Y''
	and tpn.GoalTargetDate is not null
	
	open c2

	fetch c2 into @OldNeedId

	while @@fetch_status = 0
	begin
		insert into TPNeeds(DocumentVersionId, 
			NeedNumber,
			NeedText,
			NeedTextRTF,
			NeedCreatedDate,
			NeedModifiedDate,
			GoalText,
			GoalTextRTF,
			GoalActive,
			GoalNaturalSupports,
			GoalLivingArrangement,
			GoalEmployment,
			GoalHealthSafety,
			GoalStrengths,
			GoalBarriers,
			--GoalMonitoredBy,
			GoalTargetDate,
			StageOfTreatment,
			CreatedBy,
			CreatedDate,
			ModifiedBy,
			ModifiedDate
		)
		select @NewDocumentVersionId, 
			tpn.NeedNumber,
			tpn.NeedText,
			tpn.NeedTextRTF,
			tpn.NeedCreatedDate,
			tpn.NeedModifiedDate,
			tpn.GoalText,
			tpn.GoalTextRTF,
			tpn.GoalActive,
			tpn.GoalNaturalSupports,
			tpn.GoalLivingArrangement,
			tpn.GoalEmployment,
			tpn.GoalHealthSafety,
			tpn.GoalStrengths,
			tpn.GoalBarriers,
			--tpn.GoalMonitoredBy,
			tpn.GoalTargetDate,
			tpn.StageOfTreatment,
			tpn.CreatedBy,
			getdate(),
			tpn.ModifiedBy,
			getdate()
		from TPNeeds as tpn
		where tpn.NeedId = @OldNeedId

		set @NewNeedId = @@identity

		insert into @NeedMap values(@OldNeedId, @NewNeedId)

		fetch c2 into @OldNeedId
	end

	close c2

	deallocate c2

	-- TPNeedsClientNeeds	
	insert into CustomTPNeedsClientNeeds (NeedId, ClientNeedId, NeedDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select map.NewNeedId, tpncn.ClientNeedId, tpncn.NeedDescription, tpncn.CreatedBy, getdate(), tpncn.ModifiedBy, getdate()
	from @NeedMap as map
	join CustomTPNeedsClientNeeds as tpncn on tpncn.NeedId = map.OldNeedId
	where isnull(tpncn.RecordDeleted, ''N'') <> ''Y''

	-- objectives

	declare @OldObjectiveId int, @NewObjectiveId int

	declare c3 cursor for
	select tpo.ObjectiveId
	from TPobjectives as tpo
	join @NeedMap as map on map.OldNeedId = tpo.NeedId
	where tpo.DocumentVersionId = @PRDocumentVersionId
	and isnull(tpo.RecordDeleted, ''N'') <> ''Y''


	open c3

	fetch c3 into @OldObjectiveId

	while @@fetch_status = 0
	begin

		insert into TPObjectives(DocumentVersionId, NeedId, 
			ObjectiveNumber,
			ObjectiveText,
			ObjectiveTextRTF,
			ObjectiveStatus,
			TargetDate,
			CreatedBy,
			CreatedDate,
			ModifiedBy,
			ModifiedDate
		)
		select @NewDocumentVersionId, map.newNeedId, 
			tpo.ObjectiveNumber,
			tpo.ObjectiveText,
			tpo.ObjectiveTextRTF,
			tpo.ObjectiveStatus,
			tpo.TargetDate,
			tpo.CreatedBy,
			getdate(),
			tpo.ModifiedBy,
			getdate()
		from TPobjectives as tpo
		join @NeedMap as map on map.OldNeedId = tpo.NeedId
		where tpo.ObjectiveId = @OldObjectiveId

		set @NewObjectiveId = @@identity

		insert into @ObjMap values(@OldObjectiveId, @NewObjectiveId)

		fetch c3 into @OldObjectiveId
	
	end

	close c3

	deallocate c3

	-- TPinterventionprocedures
	declare @oldInterventionProcedureId int, @newInterventionProcedureId int

	declare c4 cursor for
	select tpip.TPInterventionProcedureId
	from TPInterventionProcedures as tpip
	join @NeedMap as map on map.OldNeedId = tpip.NeedId
	where isnull(tpip.RecordDeleted, ''N'') <> ''Y''

	open c4

	fetch c4 into @oldInterventionProcedureId

	while @@fetch_status = 0
	begin

		insert into TPInterventionProcedures(NeedId,
			InterventionNumber,
			InterventionText,
			AuthorizationCodeId,
			Units,
			frequencyType,
			ProviderId,
			SiteId,
			StartDate,
			EndDate,
			TotalUnits,
			TPProcedureId,
			CreatedBy,
			CreatedDate,
			ModifiedBy,
			ModifiedDate
		) select map.NewNeedId,
			tpip.InterventionNumber,
			tpip.InterventionText,
			tpip.AuthorizationCodeId,
			tpip.Units,
			tpip.frequencyType,
			tpip.ProviderId,
			tpip.SiteId,
			tpip.StartDate,
			tpip.EndDate,
			tpip.TotalUnits,
			tpip.TPProcedureId,
			tpip.CreatedBy,
			getdate(),
			tpip.ModifiedBy,
			getdate()
		from TPInterventionProcedures as tpip
		join @NeedMap as map on map.OldNeedId = tpip.NeedId
		where tpip.TPInterventionProcedureId = @oldInterventionProcedureId

		set @newInterventionProcedureId = @@identity
		
		insert into @IntMap values(@oldInterventionProcedureId, @newInterventionProcedureId)
		
		fetch c4 into @oldInterventionProcedureId

	end

	close c4

	deallocate c4

	-- TPInterventionProcedureObjectives
	insert into TPInterventionProcedureObjectives(TPInterventionProcedureId, ObjectiveId, 
		CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select imap.NewIntId, omap.NewObjId, tpipo.CreatedBy, getdate(), tpipo.ModifiedBy, getdate()
	from TPInterventionProcedureObjectives as tpipo
	join @IntMap as imap on imap.OldIntId = tpipo.TPInterventionProcedureId
	join @ObjMap as omap on omap.OldObjId = tpipo.ObjectiveId
	where isnull(tpipo.RecordDeleted, ''N'') <> ''Y''

			-- testing SQL
			--	select * from documents where documentid = @NewDocumentId
			--	select * from tpgeneral where documentid = @NewDocumentId
			--
			--	select * from tpneeds where documentid = @newdocumentid
			--
			--	select tpncn.*
			--	from tpneedsclientneeds as tpncn
			--	join tpneeds as tpn on tpn.needid = tpncn.needid
			--	where tpn.documentid = @newdocumentid
			--
			--
			--	select tpo.*
			--	from tpobjectives as tpo where tpo.documentid = @newdocumentid
			--
			--	select tpip.*
			--	from tpinterventionprocedures as tpip
			--	join tpneeds as tpn on tpn.needid = tpip.needid
			--	where tpn.documentid = @newdocumentid
			--
			--	select tpipo.*
			--	from tpinterventionprocedures as tpip
			--	join tpneeds as tpn on tpn.needid = tpip.needid
			--	join TPInterventionProcedureObjectives as tpipo on tpipo.tpinterventionprocedureid = tpip.tpinterventionprocedureid
			--	where tpn.documentid = @newdocumentid

	commit tran
end try
begin catch
	DECLARE @Error varchar(8000)    
	SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())     
		+ ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_CreateTxPlanAddendumFromReview'')     
		+ ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())      
		+ ''*****'' + Convert(varchar,ERROR_STATE())    
      
	rollback tran

	RAISERROR     
	(    
	 @Error, -- Message text.    
	 16, -- Severity.    
	 1 -- State.    
	);    

end catch
' 
END
GO
