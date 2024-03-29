/****** Object:  StoredProcedure [dbo].[csp_CheckPeriodicReviewForTxPlanChanges]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CheckPeriodicReviewForTxPlanChanges]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CheckPeriodicReviewForTxPlanChanges]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CheckPeriodicReviewForTxPlanChanges]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_CheckPeriodicReviewForTxPlanChanges]
/******************************************************************************      
**  File:       
**  Name: csp_CheckPeriodicReviewForTxPlanChanges      
**  Desc: Compares the goals/objectives in a periodic review to a treatment plan 
**  and determines whether a new treatment plan addendum should be created.  If
**  changes are found, this proc calls csp_CreateTxPlanAddendumFromReview, which
**  actually creates the addendum.
**      
**       
**  Called by: [scsp_SCDocumentPostSignatureUpdates]
**                    
**  Parameters:      
**  Input
**  @DocumentId -- Id of periodic review to be compared to treatement plan
**  @Version    -- version of periodic review to be compared
**
**  Author:  Tom Remisoski
**  Date:  08/14/2008
*******************************************************************************      
**  Change History      
*******************************************************************************      
**  Date:  Author:    Description:      
**  --------  --------    ----------------------------------------------------      
 
*******************************************************************************/    

	@DocumentVersionId int
as

declare @reasonForAddendum varchar(max)
set @reasonForAddendum = ''''
--
-- things that can change on a periodic review and trigger an addendum:
-- TPNeeds
--		GoalTargetDate
--		GoalActive
--		GoalMonitoredBy
--		GoalStrengths
--		GoalBarriers
--		StageOfTreatment
--
-- TPObjectives
--		ObjectiveStatus
--		TargetDate
--
-- New TPNeeds where no match in PeriodicReviewNeeds
-- 
-- PeriodicReviewNeeds.TreatmentPlanAddendumRequired
--

-- check for goal changes
declare @reasonText varchar(8000)

declare cGoals cursor for
select ''Goal '' + cast(newTx.NeedNumber as varchar) + '': ''
	+ case when (oldTx.GoalTargetDate is not null and oldTx.GoalTargetDate <> newTx.GoalTargetDate) --or (oldTx.GoalTargetDate is null and newTx.GoalTargetDate is not null) 
		or (oldTx.GoalTargetDate is not null and newTx.GoalTargetDate is null)
		then ''Target date changed.  '' else '''' end
	+ case when (oldTx.GoalActive <> newTx.GoalActive) or (oldTx.GoalActive is null and newTx.GoalActive is not null) or (oldTx.GoalActive is not null and newTx.GoalActive is null)
		then ''Goal active status changed. '' else '''' end
--	+ case when (oldTx.GoalMonitoredBy <> newTx.GoalMonitoredBy) or (oldTx.GoalMonitoredBy is null and newTx.GoalMonitoredBy is not null) or (oldTx.GoalMonitoredBy is not null and newTx.GoalMonitoredBy is null)
--		then ''Goal montitored by changed. '' else '''' end
--	+ case when (oldTx.GoalStrengths <> newTx.GoalStrengths) or (oldTx.GoalStrengths is null and newTx.GoalStrengths is not null) or (oldTx.GoalStrengths is not null and newTx.GoalStrengths is null)
--		then ''Goal strengths changed. '' else '''' end
--	+ case when (oldTx.GoalBarriers <> newTx.GoalBarriers) or (oldTx.GoalBarriers is null and newTx.GoalBarriers is not null) or (oldTx.GoalBarriers is not null and newTx.GoalBarriers is null)
--		then ''Goal barriers changed. '' else '''' end
--	+ case when (oldTx.StageOfTreatment <> newTx.StageOfTreatment) or (oldTx.StageOfTreatment is null and newTx.StageOfTreatment is not null) or (oldTx.StageOfTreatment is not null and newTx.StageOfTreatment is null)
--		then ''Goal stage of treatment changed. '' else '''' end
from TPNeeds as oldTx
join TPNeeds as newTx on newTx.SourceNeedId = oldTx.NeedId
where newTx.DocumentVersionId = @DocumentVersionId
and isnull(oldTx.RecordDeleted, ''N'') <> ''Y''
and isnull(newTx.RecordDeleted, ''N'') <> ''Y''
and(
   ((oldTx.GoalTargetDate is not null and oldTx.GoalTargetDate <> newTx.GoalTargetDate) --or (oldTx.GoalTargetDate is null and newTx.GoalTargetDate is not null)
	 or (oldTx.GoalTargetDate is not null and newTx.GoalTargetDate is null))
or ((oldTx.GoalActive <> newTx.GoalActive) or (oldTx.GoalActive is null and newTx.GoalActive is not null) or (oldTx.GoalActive is not null and newTx.GoalActive is null))
--or ((oldTx.GoalMonitoredBy <> newTx.GoalMonitoredBy) or (oldTx.GoalMonitoredBy is null and newTx.GoalMonitoredBy is not null) or (oldTx.GoalMonitoredBy is not null and newTx.GoalMonitoredBy is null))
--or ((oldTx.GoalStrengths <> newTx.GoalStrengths) or (oldTx.GoalStrengths is null and newTx.GoalStrengths is not null) or (oldTx.GoalStrengths is not null and newTx.GoalStrengths is null))
--or ((oldTx.GoalBarriers <> newTx.GoalBarriers) or (oldTx.GoalBarriers is null and newTx.GoalBarriers is not null) or (oldTx.GoalBarriers is not null and newTx.GoalBarriers is null))
--or ((oldTx.StageOfTreatment <> newTx.StageOfTreatment) or (oldTx.StageOfTreatment is null and newTx.StageOfTreatment is not null) or (oldTx.StageOfTreatment is not null and newTx.StageOfTreatment is null))
)

open cGoals

fetch cGoals into @reasonText

while @@fetch_status = 0
begin

	set @reasonForAddendum = @reasonForAddendum + @reasonText + char(13) + char(10)

	fetch cGoals into @reasonText

end

close cGoals

deallocate cGoals


-- check for objective changes
declare cObjectives cursor for
select ''Objective '' + cast(newObj.ObjectiveNumber as varchar) + '': ''
	+ case when (oldObj.TargetDate <> newObj.TargetDate) or (oldObj.TargetDate is null and newObj.TargetDate is not null) or (oldObj.TargetDate is not null and newObj.TargetDate is null)
		then ''Target date changed.  '' else '''' end
	+ case when (oldObj.ObjectiveStatus <> newObj.ObjectiveStatus) or (oldObj.ObjectiveStatus is null and newObj.ObjectiveStatus is not null) or (oldObj.ObjectiveStatus is not null and newObj.ObjectiveStatus is null)
		then ''Objective status changed. '' else '''' end
--,cast(oldObj.ObjectiveNumber - cast(cast(oldObj.ObjectiveNumber as int) as decimal) as decimal(9,2)),
--cast((newObj.ObjectiveNumber - cast(cast(newObj.ObjectiveNumber as int) as decimal)) * 10.0  as decimal(9,2))
--, round(oldObj.ObjectiveNumber, 0)
-- ,round(newObj.ObjectiveNumber, 0)
--,oldDoc.DocumentCodeId
from TPNeeds as oldTx
join TPNeeds as newTx on newTx.SourceNeedId = oldTx.NeedId
JOIN DocumentVersions dv on (dv.DocumentVersionId = oldTx.DocumentVersionId)
join Documents as oldDoc on oldDoc.DocumentId = dv.DocumentId
join TPObjectives as oldObj on oldObj.DocumentVersionId = oldTx.DocumentVersionId and oldObj.NeedId = oldTx.NeedId
join TPObjectives as newObj on newObj.DocumentVersionId = newTx.DocumentVersionId and newObj.NeedId = newTx.NeedId
where newTx.DocumentVersionId = @DocumentVersionId
and isnull(oldTx.RecordDeleted, ''N'') <> ''Y''
and isnull(newTx.RecordDeleted, ''N'') <> ''Y''
and isnull(oldObj.RecordDeleted, ''N'') <> ''Y''
and isnull(newObj.RecordDeleted, ''N'') <> ''Y''
and ((oldDoc.DocumentCodeId not in (2,3) and oldObj.ObjectiveNumber = newObj.ObjectiveNumber)
	or (oldDoc.DocumentCodeId in (2,3) and round(oldObj.ObjectiveNumber, 0) = round(newObj.ObjectiveNumber, 0) 
		and (cast(oldObj.ObjectiveNumber - cast(cast(oldObj.ObjectiveNumber as int) as decimal) as decimal(9,2)) =
			cast((newObj.ObjectiveNumber - cast(cast(newObj.ObjectiveNumber as int) as decimal)) * 10.0  as decimal(9,2))))
)
and (
((oldObj.TargetDate <> newObj.TargetDate) or (oldObj.TargetDate is null and newObj.TargetDate is not null) or (oldObj.TargetDate is not null and newObj.TargetDate is null))
or ((oldObj.ObjectiveStatus <> newObj.ObjectiveStatus) or (oldObj.ObjectiveStatus is null and newObj.ObjectiveStatus is not null) or (oldObj.ObjectiveStatus is not null and newObj.ObjectiveStatus is null))
)

open cObjectives

fetch cObjectives into @reasonText

while @@fetch_status = 0
begin

	set @reasonForAddendum = @reasonForAddendum + @reasonText + char(13) + char(10)

	fetch cObjectives into @reasonText

end

close cObjectives

deallocate cObjectives




--
-- check for new goals added to the periodic review
--
if exists (
	select 1 
	from TPNeeds as tpn 
	where tpn.DocumentVersionId = @DocumentVersionId
	and tpn.SourceNeedId is null
	and isnull(tpn.RecordDeleted, ''N'') <> ''Y''
	and tpn.GoalTargetDate is not null
)
begin
	set @reasonForAddendum = @reasonForAddendum + ''New goal(s) added.'' + char(13) + char(10)
end

-- clinician asked for a new addendum
if exists (
	select 1
	from PeriodicReviews as pr
	where pr.DocumentVersionId = @DocumentVersionId
	and isnull(pr.RecordDeleted, ''N'') <> ''Y''
	and pr.TreatmentPlanAddendumRequired = ''Y''
)
begin
	set @reasonForAddendum = @reasonForAddendum + ''Need for new addendum identified during periodic review.'' + char(13) + char(10)
end

--print @reasonForAddendum
-- If we found changes, call the proc to create a new treatment plan addendum
if len(@reasonForAddendum) > 0 exec csp_CreateTxPlanAddendumFromReview @DocumentVersionId, @reasonForAddendum
' 
END
GO
