/****** Object:  StoredProcedure [dbo].[csp_CreateMedsOnlyTreatmentPlan]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CreateMedsOnlyTreatmentPlan]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CreateMedsOnlyTreatmentPlan]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CreateMedsOnlyTreatmentPlan]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


create procedure [dbo].[csp_CreateMedsOnlyTreatmentPlan]
/****************************************************************/
-- PROCEDURE: [csp_CreateMedsOnlyTreatmentPlan]
-- PURPOSE: Post psych eval signature events.
-- CALLED BY: SmartCare on post-update (signature)
-- REVISION HISTORY:
--		2012.08.26 - T. Remisoski - Created.
/****************************************************************/
	@ClientId int,
	@AuthorId int,
	@EffectiveDate datetime,
	@DocumentStatus int = 21,	-- default to in-progress
	@AnnualReview char(1) = null
as 
begin try
    begin tran

    declare @tDocuments table (DocumentId int)

    declare @tDocumentVersions table (
         DocumentVersionId int
        )
	
    declare @constDocumentCodeTreatmentPlanInitial int = 1483,
        @constDocumentCodeTreatmentPlanAnnual int = 1485,
        @constDocumentSigned int = 22,
        @constDocumentInProgress int = 21,
        @constObjectiveStatusActive int = 1,
        @constAuthCodePharmacologicManagement int = 13,
        @constPharmacologicManagementFrequency int = 166,
        @constAuthCodeCPST int = 2,
        @constCPSTFrequency int = 160
        
    declare @prevTxPlanDocumentVersionId int
    
	
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
			select  @ClientId,
					CASE when (@prevTxPlanDocumentVersionId is not null) or (ISNULL(@AnnualReview, ''N'') = ''Y'')
						 then @constDocumentCodeTreatmentPlanAnnual
						 else @constDocumentCodeTreatmentPlanInitial
					end,
					@EffectiveDate,
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



	commit tran

	-- return info back to the caller
	select @ClientId, DocumentId from @tDocuments

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
