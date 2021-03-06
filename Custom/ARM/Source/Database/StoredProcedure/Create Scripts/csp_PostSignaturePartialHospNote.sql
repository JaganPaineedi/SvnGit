/****** Object:  StoredProcedure [dbo].[csp_PostSignaturePartialHospNote]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PostSignaturePartialHospNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PostSignaturePartialHospNote]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PostSignaturePartialHospNote]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE procedure [dbo].[csp_PostSignaturePartialHospNote]
		@ScreenKeyId int,
		@StaffId int,
		@CurrentUser varchar(30),
		@CustomParameters xml
/******************************************************************************
**  File: csp_PostSignaturePartialHospNote
**  Name: csp_PostSignaturePartialHospNote
**  Desc: For Validation  on CustomDocumentMentalStatuses document(For Prototype purpose, Need modification)
**  Return values: Resultset having validation messages
**  Called by:
**  Parameters:
**  Auth:  Jagdeep Hundal
**  Date:  July 29 2011
*******************************************************************************
**  Change History
*******************************************************************************
**  Date:       Author:       Description:
**  --------    --------        ----------------------------------------------------
** 2012.02.08	TER				Revised based on Harbor''s rules
** 2012.02.22	TER				Revised to only begin tran if a tx plan will be created.
*******************************************************************************/
as 
begin try

	declare @DocumentVersionId int
	
    declare @tDocuments table (DocumentId int)

    declare @tDocumentVersions table (
         DocumentVersionId int
        )
	
    declare @constDocumentCodeTreatmentPlanInitial int = 1483,
        @constDocumentCodeTreatmentPlanUpdate int = 1484,
        @constDocumentSigned int = 22,
        @constDocumentInProgress int = 21,
        @constObjectiveStatusActive int = 1
	
    declare @ClientId int
    declare @AuthorId int
    declare @prevTxPlanDocumentVersionId int
    declare @DocumentStatus int
    declare @recommendedChangesISP char(1)

    select  @ClientId = d.ClientId,
            @AuthorId = d.AuthorId,
            @DocumentStatus = @constDocumentInProgress,
            @DocumentVersionId = dv.DocumentVersionId,
            @recommendedChangesISP = c.RecommendedChangesToISP
    from    dbo.Documents as d
    join    dbo.DocumentVersions as dv on dv.DocumentVersionId = d.CurrentDocumentVersionId
    join    dbo.CustomDocumentCounselingNotes as c on c.DocumentVersionId = dv.DocumentVersionId
    where   d.DocumentId = @ScreenKeyId

	-- just return if no recommended changes to the isp
	if ISNULL(@recommendedChangesISP, ''N'') <> ''Y''
		return

    begin tran
		
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
            where   d.CurrentDocumentVersionId = @DocumentVersionId
		
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
				where dv.DocumentVersionId = @DocumentVersionId

	end

	-- Create the actual custom Document
    insert  into dbo.CustomTreatmentPlans
            (
             DocumentVersionId,
             ClientParticipatedAndIsInAgreement,
             ReasonForUpdate,
             ClientStrengths,
             DischargeTransitionCriteria
            )
            select  dv.DocumentVersionId,
                    ''Y'',
                    CASE when @prevTxPlanDocumentVersionId is not null
                         then ''Need for updated treatement plan identified during service delivery.''
                         else null
                    end,
                    tp.ClientStrengths,
                    tp.DischargeTransitionCriteria
            from    @tDocumentVersions as dv
            LEFT outer join dbo.CustomTreatmentPlans as tp on tp.DocumentVersionId = @prevTxPlanDocumentVersionId

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

	-- only add an empty goal if there are no goals in the previous plan.
	
	if @nextGoalNumber = 1
	begin

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
		null,
		DATEADD(YEAR, 1, d.EffectiveDate),
		''Y'',
		null,
		''N''
		from @tDocumentVersions as dv
		join Documents as d on d.CurrentDocumentVersionId = dv.DocumentVersionId


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
