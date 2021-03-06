/****** Object:  StoredProcedure [dbo].[csp_PostSignaturePsychEvalCreateMedTreatmentPlanGoals]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PostSignaturePsychEvalCreateMedTreatmentPlanGoals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PostSignaturePsychEvalCreateMedTreatmentPlanGoals]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PostSignaturePsychEvalCreateMedTreatmentPlanGoals]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE procedure [dbo].[csp_PostSignaturePsychEvalCreateMedTreatmentPlanGoals]
/****************************************************************/
-- PROCEDURE: [csp_PostSignaturePsychEvalCreateMedTreatmentPlanGoals]
-- PURPOSE: Post psych eval signature events.
-- CALLED BY: SmartCare on post-update (signature)
-- REVISION HISTORY:
--		2011.10.02 - T. Remisoski - Created.
--		2012.03.26 - T. Remisoski - Added pharmacalogical management services to goal.
--		2012.06.02 - T. Remisoski - Add handling for nurse eval
/****************************************************************/

    @PsychEvalDocumentVersionId int
as 
begin try
    begin tran

    declare @tDocuments table (DocumentId int)

    declare @tDocumentVersions table (
         DocumentVersionId int
        )
	
    declare @constDocumentCodeTreatmentPlanInitial int = 1483,
        @constDocumentCodeTreatmentPlanUpdate int = 1484,
        @constDocumentCodePsychEval int = 1489,
        @constDocumentCodeNurseEval int = 20815,
        @constDocumentSigned int = 22,
        @constDocumentInProgress int = 21,
        @constObjectiveStatusActive int = 1,
        @constAuthCodePharmacologicManagement int = 13,
        @constPharmacologicManagementFrequency int = 166,
        @constAuthCodeCPST int = 2,
        @constCPSTFrequency int = 160
        
    declare @ClientId int
    declare @AuthorId int
    declare @prevTxPlanDocumentVersionId int
    declare @DocumentStatus int
    declare @SourceDocumentCodeId int, @SourceDocumentId int, @SourceDocumentEffectiveDate datetime
    
    --
    -- Business Rule: if the document that is signed is a nurse eval and a previously signed psych eval exists, do not create a treatment plan
    -- also, vice versa.
    --
    select @ClientId = d.ClientId, @SourceDocumentCodeId = d.DocumentCodeId, @SourceDocumentId = d.DocumentId, @SourceDocumentEffectiveDate = d.EffectiveDate
    from dbo.Documents as d
    join dbo.DocumentVersions as dv on dv.DocumentId = d.DocumentId
    where dv.DocumentVersionId = @PsychEvalDocumentVersionId

	if not (
		exists (
			select *
			from dbo.Documents as d
			where d.ClientId = @ClientId
			and d.DocumentCodeId in (@constDocumentCodePsychEval, @constDocumentCodeNurseEval)
			and d.DocumentId <> @SourceDocumentId
			and DATEDIFF(DAY, d.EffectiveDate, @SourceDocumentEffectiveDate) <= 365
			and d.Status = 22
			and ISNULL(d.RecordDeleted, ''N'') <> ''Y''
		)
		and exists (	-- and a treatment plan exists
			select *
			from dbo.Documents as d
			where d.ClientId = @ClientId
			and d.DocumentCodeId in (@constDocumentCodeTreatmentPlanInitial, @constDocumentCodeTreatmentPlanUpdate)
			and d.DocumentId <> @SourceDocumentId
			and DATEDIFF(DAY, d.EffectiveDate, @SourceDocumentEffectiveDate) <= 365
			and d.Status = 22
			and ISNULL(d.RecordDeleted, ''N'') <> ''Y''
		)
	)
	begin
	
		if @SourceDocumentCodeId = @constDocumentCodePsychEval
		begin
			select  @ClientId = d.ClientId,
					@AuthorId = d.AuthorId,
					@DocumentStatus = CASE when pe.AddGoalsToTxPlan = ''Y''
										   then @constDocumentInProgress
										   else @constDocumentSigned
									  end
			from    dbo.Documents as d
			join    dbo.DocumentVersions as dv on dv.DocumentVersionId = d.CurrentDocumentVersionId
			join    dbo.CustomDocumentPsychiatricEvaluations as pe on pe.DocumentVersionId = dv.DocumentVersionId
			where   dv.DocumentVersionId = @PsychEvalDocumentVersionId
		end
		else if @SourceDocumentCodeId = @constDocumentCodeNurseEval
		begin
			select  @ClientId = d.ClientId,
					@AuthorId = d.AuthorId,
					@DocumentStatus = CASE when pe.AdditionalGoalsRequired = ''Y''
										   then @constDocumentInProgress
										   else @constDocumentSigned
									  end
			from    dbo.Documents as d
			join    dbo.DocumentVersions as dv on dv.DocumentVersionId = d.CurrentDocumentVersionId
			join    dbo.CustomDocumentHarborNurseEvaluations as pe on pe.DocumentVersionId = dv.DocumentVersionId
			where   dv.DocumentVersionId = @PsychEvalDocumentVersionId
		end

		select  @prevTxPlanDocumentVersionId = tx.DocumentVersionId
		from    dbo.CustomTreatmentPlans as tx
		join    dbo.Documents as d on d.CurrentDocumentVersionId = tx.DocumentVersionId
		where   d.ClientId = @ClientID
				and ISNULL(d.RecordDeleted, ''N'') <> ''Y''
				and d.Status = 22
				and not exists ( select *
								 from   CustomTreatmentPlans as tx2
								 join   Documents as d2 on d2.CurrentDocumentVersionId = tx2.DocumentVersionId
								 where  ISNULL(d2.RecordDeleted, ''N'') <> ''Y''
										and d2.ClientId = d.ClientId
										and d2.Status = 22
										and (
											 (d2.EffectiveDate > d.EffectiveDate)
											 or (
												 d2.EffectiveDate = d.EffectiveDate
												 and d2.CurrentDocumentVersionId > d.CurrentDocumentVersionId
												)
											) )

		
		-- create the new treatment plan
		-- Documents
		insert  into dbo.Documents
				(
				 ClientId,
				 DocumentCodeId,
				 EffectiveDate,
				 Status,
				 AuthorId,
				 DocumentShared,
				 SignedByAuthor,
				 SignedByAll
		        
				)
		output  inserted.DocumentId
				into @tDocuments (DocumentId)
				select  d.ClientId,
						CASE when @prevTxPlanDocumentVersionId is not null
							 then @constDocumentCodeTreatmentPlanUpdate
							 else @constDocumentCodeTreatmentPlanInitial
						end,
						d.EffectiveDate,
						@DocumentStatus,
						@AuthorId,
						''Y'',
						CASE when @DocumentStatus = @constDocumentInProgress
							 then ''N''
							 else ''Y''
						end,
						CASE when @DocumentStatus = @constDocumentInProgress
							 then ''N''
							 else ''Y''
						end
				from    dbo.Documents as d
				where   d.CurrentDocumentVersionId = @PsychEvalDocumentVersionId
			
		-- DocumentVersions
		insert  into dbo.DocumentVersions
				(
				 DocumentId,
				 Version,
				 AuthorId,
				 EffectiveDate,
				 RevisionNumber
		        
				)
		output  inserted.DocumentVersionId
				into @tDocumentVersions (DocumentVersionId)
				select  td.DocumentId,
						1,
						@AuthorId,
						d.EffectiveDate,
						1
				from    @tDocuments as td
				join    dbo.Documents as d on d.DocumentId = td.DocumentId
			
		-- Link the new documentversionid back to the document
		update  d
		set     CurrentDocumentVersionId = tdv.DocumentVersionId,
				InProgressDocumentVersionId = tdv.DocumentVersionId,
				CurrentVersionStatus = @DocumentStatus
		from    Documents as d
		join    @tDocuments as td on td.DocumentId = d.DocumentId
		cross join @tDocumentVersions as tdv
			
		-- DocumentSignatures
		if @DocumentStatus = @constDocumentInProgress
		begin
			insert  into dbo.DocumentSignatures
					(
					 DocumentId,
					 StaffId,
					 SignatureOrder,
					 SignedDocumentVersionId,
					 SignerName
					)
					select  td.DocumentId,
							d.AuthorId,
							1,
							tdv.DocumentVersionid,
							s.FirstName + '' '' + s.LastName + ISNULL('', ''
																	+ gcDegree.CodeName,
																	'''')
					from    @tDocuments as td
					join    dbo.Documents as d on d.DocumentId = td.DocumentId
					join    dbo.Staff as s on s.StaffId = d.AuthorId
					left join dbo.GlobalCodes as gcDegree on gcDegree.GlobalCodeId = s.Degree
					cross join @tDocumentVersions as tdv
		end
		else
		begin
			-- DocumentSignatures
			insert  into dbo.DocumentSignatures
					(
					 DocumentId,
					 StaffId,
					 SignatureOrder,
					 SignedDocumentVersionId,
					 SignerName,
					 SignatureDate
			        
					)
					select  td.DocumentId,
							ds.StaffId,
							ds.signatureOrder,
							tdv.DocumentVersionid,
							ds.SignerName,
							GETDATE()
					from    @tDocuments as td
					join    dbo.Documents as d on d.DocumentId = td.DocumentId
					cross join @tDocumentVersions as tdv
					cross join dbo.DocumentVersions as dv
					join dbo.DocumentSignatures as ds on ds.SignedDocumentVersionId = dv.DocumentVersionId
					where dv.DocumentVersionId = @PsychEvalDocumentVersionId

		end

		-- Create the actual custom Document
		insert  into dbo.CustomTreatmentPlans
				(
				 DocumentVersionId,
				 ClientParticipatedAndIsInAgreement,
				 ReasonForUpdate
				)
				select  dv.DocumentVersionId,
						''Y'',
						CASE when @prevTxPlanDocumentVersionId is not null
							 then ''Psychiatric evaluation resulted in additional treatment plan goals.''
							 else null
						end
				from    @tDocumentVersions as dv

		update a set
			ClientStrengths = prev.ClientStrengths,
			DischargeTransitionCriteria = prev.DischargeTransitionCriteria
		from dbo.CustomTreatmentPlans as a
		join @tDocumentVersions as dv on dv.DocumentVersionId = a.DocumentVersionId
		cross join dbo.CustomTreatmentPlans as prev
		where prev.DocumentVersionId = @prevTxPlanDocumentVersionId
			            
		-- use default strengths and transition criteria when prev data does not exist
		update a set
			ClientStrengths = ISNULL(ClientStrengths, ''Client recognizes the need for behavioral health treatment and is taking steps toward recovery by seeking this treatment.''),
			DischargeTransitionCriteria = ISNULL(DischargeTransitionCriteria, ''Client will report symptom reduction and improvement toward ISP goals to the extent that the client is able to function successfully in the community without behavioral health treatment.'')
		from dbo.CustomTreatmentPlans as a
		join @tDocumentVersions as dv on dv.DocumentVersionId = a.DocumentVersionId



		declare @tCustomTPGoalMap table (
			OldGoalId int,
			NewGoalId int
		)
		declare @OldGoalId int
		
		declare @cGoals cursor
		set @cGoals = cursor for
		select TPGoalId
		from dbo.CustomTPGoals
		where DocumentVersionId = @prevTxPlanDocumentVersionId
		and ISNULL(RecordDeleted, ''N'') <> ''Y''
		
		open @cGoals
		
		fetch @cGoals into @OldGoalId
		
		while @@fetch_status = 0
		begin
			-- create the new tp goals and save a map back to the old ones
			insert into dbo.CustomTPGoals
					(
					 DocumentVersionId,
					 GoalNumber,
					 GoalText,
					 TargeDate,
					 Active,
					 ProgressTowardsGoal,
					 DeletionNotAllowed
					)
			output @OldGoalId, inserted.TPGoalId into @tCustomTPgoalMap (OldGoalId, NewGoalId)
			select dv.DocumentVersionId,
			g.GoalNumber,
			g.GoalText,
			g.TargeDate,
			ISNULL(g.Active, ''Y''),
			g.ProgressTowardsGoal,
			g.DeletionNotAllowed
			from @tDocumentVersions as dv
			cross join dbo.CustomTPGoals as g
			where g.TPGoalId = @OldGoalId
		
			fetch @cGoals into @OldGoalId
		end
		
		close @cGoals
		
		deallocate @cGoals
		
		-- Create goal needs
		insert into dbo.CustomTPGoalNeeds
				(
				 TPGoalId,
				 NeedId,
				 DateNeedAddedToPlan
				)
		select n.NewGoalId,
		o.NeedId,
		o.DateNeedAddedToPlan
		from @tCustomTPGoalMap as n
		join dbo.CustomTPGoalNeeds as o on o.TPGoalId = n.OldGoalId
		where ISNULL(o.RecordDeleted, ''N'') <> ''Y''
		
		-- create objectives
		insert into dbo.CustomTPObjectives
				(
				 TPGoalId,
				 ObjectiveNumber,
				 ObjectiveText,
				 TargetDate,
				 Status,
				 DeletionNotAllowed
				)
		select n.NewGoalId,
		o.ObjectiveNumber,
		o.ObjectiveText,
		o.TargetDate,
		o.Status,
		o.DeletionNotAllowed
		from @tCustomTPGoalMap as n
		join CustomTPObjectives as o on o.TPGoalId = n.OldGoalId
		where ISNULL(o.RecordDeleted, ''N'') <> ''Y''

		insert into dbo.CustomTPServices 
				(
				 TPGoalId,
				 ServiceNumber,
				 AuthorizationCodeId,
				 Units,
				 FrequencyType,
				 Status,
				 DeletionNotAllowed
				)
		select n.NewGoalId,
		o.ServiceNumber,
		o.AuthorizationCodeId,
		o.Units,
		o.FrequencyType,
		o.Status,
		o.DeletionNotAllowed
		from @tCustomTPGoalMap as n
		join dbo.CustomTPServices as o on o.TPGoalId = n.OldGoalId
		where ISNULL(o.RecordDeleted,''N'') <> ''Y''

		-- add the med goal to the new plan

		declare @nextGoalNumber int
		declare @tMedGoals table (
			TPGoalId int
		)
		
		select @nextGoalNumber = MAX(GoalNumber)
		from dbo.CustomTPGoals as g
		join @tDocumentVersions as dv on dv.DocumentVersionId = g.DocumentVersionId

		set @nextGoalNumber = ISNULL(@nextGoalNumber, 0) + 1

		insert into dbo.CustomTPGoals
				(
				 DocumentVersionId,
				 GoalNumber,
				 GoalText,
				 TargeDate,
				 Active,
				 ProgressTowardsGoal,
				 DeletionNotAllowed
				)
		output inserted.TPGoalId into @tMedGoals(TPGoalId)
		select 	dv.DocumentVersionId,
		@nextGoalNumber,
		''Decrease targeted symptoms as evidenced by client''''s (parent''''s/ guardian’s) report.'',
		DATEADD(YEAR, 1, d.EffectiveDate),
		''Y'',
		null,
		''N''
		from @tDocumentVersions as dv
		join Documents as d on d.CurrentDocumentVersionId = dv.DocumentVersionId

		-- create the objectives
		insert into dbo.CustomTPObjectives
				(
				 TPGoalId,
				 ObjectiveNumber,
				 ObjectiveText,
				 TargetDate,
				 Status,
				 DeletionNotAllowed
				)
		select n.TPGoalId,
		CAST(@NextGoalNumber as decimal) + 0.01,
		''Complete or ensure completion of ordered lab work.'',
		g.TargeDate,
		@constObjectiveStatusActive,
		''N''
		from @tMedGoals as n
		join dbo.CustomTPGoals as g on g.TPGoalId = n.TPGoalId
		
		insert into dbo.CustomTPObjectives
				(
				 TPGoalId,
				 ObjectiveNumber,
				 ObjectiveText,
				 TargetDate,
				 Status,
				 DeletionNotAllowed
				)
		select n.TPGoalId,
		CAST(@NextGoalNumber as decimal) + 0.02,
		''Report side effects or problems with taking prescribed medication(s).'',
		g.TargeDate,
		@constObjectiveStatusActive,
		''N''
		from @tMedGoals as n
		join dbo.CustomTPGoals as g on g.TPGoalId = n.TPGoalId

		insert into dbo.CustomTPObjectives
				(
				 TPGoalId,
				 ObjectiveNumber,
				 ObjectiveText,
				 TargetDate,
				 Status,
				 DeletionNotAllowed
				)
		select n.TPGoalId,
		CAST(@NextGoalNumber as decimal) + 0.03,
		''Take medication as prescribed (evidenced by report).'',
		g.TargeDate,
		@constObjectiveStatusActive,
		''N''
		from @tMedGoals as n
		join dbo.CustomTPGoals as g on g.TPGoalId = n.TPGoalId

		-- create the pharm management service
		insert into dbo.CustomTPServices
				(
				 TPGoalId,
				 ServiceNumber,
				 AuthorizationCodeId,
				 Units,
				 FrequencyType
				)
		select n.TPGoalId,
			CAST(@NextGoalNumber as decimal) + 0.01,
			@constAuthCodePharmacologicManagement,
			1,
			@constPharmacologicManagementFrequency
		from @tMedGoals as n
		join dbo.CustomTPGoals as g on g.TPGoalId = n.TPGoalId

		-- create the CPST service
		insert into dbo.CustomTPServices
				(
				 TPGoalId,
				 ServiceNumber,
				 AuthorizationCodeId,
				 Units,
				 FrequencyType
				)
		select n.TPGoalId,
			CAST(@NextGoalNumber as decimal) + 0.02,
			@constAuthCodeCPST,
			2,
			@constCPSTFrequency
		from @tMedGoals as n
		join dbo.CustomTPGoals as g on g.TPGoalId = n.TPGoalId

		-- Create the need and associate it to the goal
		
		declare @NeedId int
		select @NeedId = NeedId
		from dbo.CustomTPNeeds
		where ClientId = @ClientId
		and NeedText like ''Client requires pharmacologic management services.%''

		if @NeedId is null
		begin
			insert into dbo.CustomTPNeeds
					(
					 ClientId,
					 NeedText
					)
			values  (
					 @ClientId, -- ClientId - int
					 ''Client requires pharmacologic management services.''  -- NeedText - type_Comment2
					)
			        
			 set @NeedId = SCOPE_IDENTITY()
		end

		if @NeedId is not null
		begin

			insert into dbo.CustomTPGoalNeeds
					(
					 TPGoalId,
					 NeedId,
					 DateNeedAddedToPlan
					)
			select n.TPGoalId,
				@NeedId,
				GETDATE()
			from @tMedGoals as n
			join dbo.CustomTPGoals as g on g.TPGoalId = n.TPGoalId

		end

		if @DocumentStatus = @constDocumentSigned
		begin
			-- send a notification to the treatment team
			declare @NotificationReference int, @DocumentCodeId int
			
			select @NotificationReference = t.DocumentId, @DocumentCodeId = d.DocumentCodeId
			from @tDocuments as t
			join dbo.Documents as d on d.DocumentId = t.DocumentId
			
			if @DocumentCodeId = @constDocumentCodeTreatmentPlanInitial
			begin
				exec [dbo].[csp_PostUpdateTreatmentPlanInitial]
					@ScreenKeyId = @NotificationReference, -- int
					@StaffId = @AuthorId, -- int
					@CurrentUser = '''', -- varchar(30)
					@CustomParameters = null -- xml
			end
				
			if @DocumentCodeId = @constDocumentCodeTreatmentPlanUpdate
			begin
				exec [dbo].[csp_PostUpdateTreatmentPlanUpdate]
					@ScreenKeyId = @NotificationReference, -- int
					@StaffId = @AuthorId, -- int
					@CurrentUser = '''', -- varchar(30)
					@CustomParameters = null -- xml
			end
		end

	end
	
    commit tran
end try
begin catch
    if @@trancount > 0 
        rollback tran
    declare @errMessage nvarchar(4000)
    set @errMessage = ERROR_MESSAGE()

    raiserror(@errMessage, 16, 1)

end catch



' 
END
GO
