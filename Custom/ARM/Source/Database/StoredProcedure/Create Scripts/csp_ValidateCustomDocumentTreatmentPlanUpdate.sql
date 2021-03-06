/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomDocumentTreatmentPlanUpdate]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentTreatmentPlanUpdate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomDocumentTreatmentPlanUpdate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentTreatmentPlanUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_ValidateCustomDocumentTreatmentPlanUpdate]
/******************************************************************************
**  File: csp_ValidateCustomDocumentTreatmentPlanUpdate
**  Name: csp_ValidateCustomDocumentTreatmentPlanUpdate
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
*******************************************************************************/
	@DocumentVersionId int,
	@TabOrder int = 1
as


Insert into #validationReturnTable (
	TableName,
	ColumnName,
	ErrorMessage,
	TabOrder,
	ValidationOrder
)
select ''CustomTreatmentPlans'', ''DeletedBy'', ''Treatment Plan: Reason for update required'', @TabOrder, 1
from dbo.CustomTreatmentPlans as tp
where tp.DocumentVersionId = @DocumentVersionId
and LEN(LTRIM(RTRIM(ISNULL(tp.ReasonForUpdate, '''')))) = 0
and ISNULL(tp.RecordDeleted, ''N'') <> ''Y''
union
select ''CustomTreatmentPlans'', ''DeletedBy'', ''Treatment Plan: Client strengths required'', @TabOrder, 2
from dbo.CustomTreatmentPlans as tp
where tp.DocumentVersionId = @DocumentVersionId
and LEN(LTRIM(RTRIM(ISNULL(tp.ClientStrengths, '''')))) = 0
and ISNULL(tp.RecordDeleted, ''N'') <> ''Y''
union
select ''CustomTreatmentPlans'', ''DeletedBy'', ''Treatment Plan: Discharge/transition criteria required'', @TabOrder, 3
from dbo.CustomTreatmentPlans as tp
where tp.DocumentVersionId = @DocumentVersionId
and LEN(LTRIM(RTRIM(ISNULL(tp.DischargeTransitionCriteria, '''')))) = 0
and ISNULL(tp.RecordDeleted, ''N'') <> ''Y''
union
select ''CustomTPGoals'', ''DeletedBy'', ''Treatment Plan Goal #'' + CAST(ISNULL(tpg.GoalNumber, 0) as varchar) + '': text cannot be empty'', @TabOrder, 4
from dbo.CustomTPGoals as tpg
where tpg.DocumentVersionId = @DocumentVersionId
and LEN(LTRIM(RTRIM(ISNULL(tpg.GoalText, '''')))) = 0
and ISNULL(tpg.RecordDeleted, ''N'') <> ''Y''
union
select ''CustomTPGoals'', ''DeletedBy'', ''Treatment Plan Goal #'' + CAST(ISNULL(tpg.GoalNumber, 0) as varchar) + '': target date required'', @TabOrder, 5
from dbo.CustomTPGoals as tpg
where tpg.DocumentVersionId = @DocumentVersionId
and tpg.TargeDate is null
and ISNULL(tpg.Active, ''Y'') = ''Y''
and ISNULL(tpg.RecordDeleted, ''N'') <> ''Y''
union
select ''CustomTPGoals'', ''DeletedBy'', ''Treatment Plan Goal #'' + CAST(ISNULL(tpg.GoalNumber, 0) as varchar) + '': at least one need is required'', @TabOrder, 6
from dbo.CustomTPGoals as tpg
where tpg.DocumentVersionId = @DocumentVersionId
and ISNULL(tpg.Active, ''Y'') = ''Y''
and ISNULL(tpg.RecordDeleted, ''N'') <> ''Y''
and not exists (
	select *
	from dbo.CustomTPGoalNeeds as tpgn
	where tpgn.TPGoalId = tpg.TPGoalId
	and ISNULL(tpgn.RecordDeleted, ''N'') <> ''Y''
)
union
select ''CustomTPGoals'', ''DeletedBy'', ''Treatment Plan Goal #'' + CAST(ISNULL(tpg.GoalNumber, 0) as varchar) + '': at least one objective is required'', @TabOrder, 7
from dbo.CustomTPGoals as tpg
where tpg.DocumentVersionId = @DocumentVersionId
and ISNULL(tpg.Active, ''Y'') = ''Y''
and ISNULL(tpg.RecordDeleted, ''N'') <> ''Y''
and not exists (
	select *
	from dbo.CustomTPObjectives as tpo
	where tpo.TPGoalId = tpg.TPGoalId
	and ISNULL(tpo.RecordDeleted, ''N'') <> ''Y''
)
union
select ''CustomTPGoals'', ''DeletedBy'', ''Treatment Plan Goal #'' + CAST(ISNULL(tpg.GoalNumber, 0) as varchar) + '': at least one service is required'', @TabOrder, 8
from dbo.CustomTPGoals as tpg
where tpg.DocumentVersionId = @DocumentVersionId
and ISNULL(tpg.Active, ''Y'') = ''Y''
and ISNULL(tpg.RecordDeleted, ''N'') <> ''Y''
and not exists (
	select *
	from dbo.CustomTPServices as tps
	where tps.TPGoalId = tpg.TPGoalId
	and ISNULL(tps.RecordDeleted, ''N'') <> ''Y''
)
union
select ''CustomTPObjectives'', ''DeletedBy'', ''Treatment Plan Objective #'' + CAST(ISNULL(tpo.ObjectiveNumber, 0.0) as varchar) + '': objective text is required'', @TabOrder, 9
from dbo.CustomTPGoals as tpg
join dbo.CustomTPObjectives as tpo on tpg.TPGoalId = tpo.TPGoalId
where tpg.DocumentVersionId = @DocumentVersionId
and ISNULL(tpg.RecordDeleted, ''N'') <> ''Y''
and ISNULL(tpo.RecordDeleted, ''N'') <> ''Y''
and LEN(LTRIM(RTRIM(ISNULL(tpo.ObjectiveText, '''')))) = 0
union
select ''CustomTPServices'', ''DeletedBy'', ''Treatment Plan Goal #'' + CAST(ISNULL(tpg.GoalNumber, 0.0) as varchar) + '': service units is required'', @TabOrder, 10
from dbo.CustomTPGoals as tpg
join dbo.CustomTPServices as tps on tps.TPGoalId = tpg.TPGoalId
where tpg.DocumentVersionId = @DocumentVersionId
and ISNULL(tps.Units, 0.0) <= 0.0
and ISNULL(tpg.RecordDeleted, ''N'') <> ''Y''
and ISNULL(tps.RecordDeleted, ''N'') <> ''Y''
union
select ''CustomTPServices'', ''DeletedBy'', ''Treatment Plan Goal #'' + CAST(ISNULL(tpg.GoalNumber, 0.0) as varchar) + '': service frequency is required'', @TabOrder, 11
from dbo.CustomTPGoals as tpg
join dbo.CustomTPServices as tps on tps.TPGoalId = tpg.TPGoalId
where tpg.DocumentVersionId = @DocumentVersionId
and tps.FrequencyType is null
and ISNULL(tpg.RecordDeleted, ''N'') <> ''Y''
and ISNULL(tps.RecordDeleted, ''N'') <> ''Y''
union
select ''CustomTPServices'', ''DeletedBy'', ''Treatment Plan Goal #'' + CAST(ISNULL(tpg.GoalNumber, 0.0) as varchar) + '': service type selection is required'', @TabOrder, 12
from dbo.CustomTPGoals as tpg
join dbo.CustomTPServices as tps on tps.TPGoalId = tpg.TPGoalId
where tpg.DocumentVersionId = @DocumentVersionId
and tps.AuthorizationCodeId is null
and ISNULL(tpg.RecordDeleted, ''N'') <> ''Y''
and ISNULL(tps.RecordDeleted, ''N'') <> ''Y''
union
select ''CustomTPServices'', ''DeletedBy'', ''Treatment Plan Goal #'' + CAST(ISNULL(tpg.GoalNumber, 0.0) as varchar) + '': goal progress selection is required for inactive goal'', @TabOrder, 12
from dbo.CustomTPGoals as tpg
where tpg.DocumentVersionId = @DocumentVersionId
and ISNULL(tpg.Active, ''Y'') = ''N''
and tpg.ProgressTowardsGoal is null
and ISNULL(tpg.RecordDeleted, ''N'') <> ''Y''
union
select ''CustomTreatmentPlans'', ''DeletedBy'', ''Treatment Plan: Client participation selection required'', @TabOrder, 13
from dbo.CustomTreatmentPlans as tp
where tp.DocumentVersionId = @DocumentVersionId
and isnull(tp.ClientDidNotParticipate, ''N'') <> ''Y''
and isnull(tp.ClientParticipatedAndIsInAgreement, ''N'') <> ''Y''
and isnull(tp.ClientParticpatedPreviousDocumentation, ''N'') <> ''Y''
and ISNULL(tp.RecordDeleted, ''N'') <> ''Y''
union
select ''CustomTreatmentPlans'', ''DeletedBy'', ''Treatment Plan: Client participation comment required'', @TabOrder, 14
from dbo.CustomTreatmentPlans as tp
where tp.DocumentVersionId = @DocumentVersionId
and tp.ClientDidNotParticipate = ''Y''
and LEN(LTRIM(RTRIM(ISNULL(tp.ClientDidNotParticpateComment, '''')))) = 0

' 
END
GO
