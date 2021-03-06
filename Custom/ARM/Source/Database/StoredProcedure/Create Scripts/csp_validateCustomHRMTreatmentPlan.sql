/****** Object:  StoredProcedure [dbo].[csp_validateCustomHRMTreatmentPlan]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomHRMTreatmentPlan]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomHRMTreatmentPlan]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomHRMTreatmentPlan]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE        PROCEDURE [dbo].[csp_validateCustomHRMTreatmentPlan]
@DocumentVersionId	Int
as

--Riverwood / NorthStar Validation
--Load the document data into a temporary table to prevent multiple seeks on the document table
CREATE TABLE #TPGeneral
(
DocumentVersionId int,
PlanOrAddendum char(1),
Participants varchar(max),
HopesAndDreams varchar(max),
Barriers varchar(max), 
PurposeOfAddendum varchar(max),
StrengthsAndPreferences varchar(max),
AreasOfNeed varchar(max),
DeferredTreatmentIssues varchar(max), 
PersonsNotPresent varchar(max),
DischargeCriteria varchar(max),
PeriodicReviewDueDate datetime,
PlanDeliveryMethod int,
ClientAcceptedPlan char(1),
CrisisPlan varchar(max),
PlanDeliveredDate datetime,
StaffId1 int,
StaffId2 int,
StaffId3 int,
StaffId4 int,
NotificationMessage varchar(max),
MeetingDate datetime,
CrisisPlanNotNecessary char(1),
PeriodicReviewFrequencyNumber int,
PeriodicReviewFrequencyUnitType varchar(20)
)
insert into #TPGeneral
(
DocumentVersionId,
PlanOrAddendum,
Participants,
HopesAndDreams,
Barriers, 
PurposeOfAddendum,
StrengthsAndPreferences,
AreasOfNeed,
DeferredTreatmentIssues, 
PersonsNotPresent,
DischargeCriteria,
PeriodicReviewDueDate,
PlanDeliveryMethod,
ClientAcceptedPlan,
CrisisPlan,
PlanDeliveredDate,
StaffId1,
StaffId2,
StaffId3,
StaffId4,
NotificationMessage,
MeetingDate,
CrisisPlanNotNecessary ,
PeriodicReviewFrequencyNumber,
PeriodicReviewFrequencyUnitType 
)

select
a.DocumentVersionId,
a.PlanOrAddendum,
a.Participants,
a.HopesAndDreams,
a.Barriers, 
a.PurposeOfAddendum,
a.StrengthsAndPreferences,
a.AreasOfNeed,
a.DeferredTreatmentIssues, 
a.PersonsNotPresent,
a.DischargeCriteria,
a.PeriodicReviewDueDate,
a.PlanDeliveryMethod,
a.ClientAcceptedPlan,
a.CrisisPlan,
a.PlanDeliveredDate,
a.StaffId1,
a.StaffId2,
a.StaffId3,
a.StaffId4,
a.NotificationMessage,
a.MeetingDate,
a.CrisisPlanNotNecessary ,
a.PeriodicReviewFrequencyNumber,
a.PeriodicReviewFrequencyUnitType 
from TPGeneral a
where a.DocumentVersionId = @DocumentVersionId

-- Determine Last Assessment Date
	DECLARE @AssessmentDate datetime,
		@ObraDel datetime,
		@Datediff int,
		@ClientId int,
		@ProgramId int,	
		@AuthorId int,
		@ClientPrimaryProgramId int,
		@MedsOnlyProgramId int,
		@PRDate datetime

	set @MedsOnlyProgramId = 11

	SELECT @ProgramId = s.PrimaryProgramId
--		, @ClientPrimaryProgramId = c.PrimaryProgramId
		, @AuthorId = d.AuthorId 
		, @ClientId = d.ClientId
	FROM Documents d
	Join Staff s on s.Staffid = d.AuthorId
--	join clients c on c.ClientId = d.ClientId
	WHERE d.CurrentDocumentVersionId = @DocumentVersionId
	AND isnull(d.RecordDeleted, ''N'') = ''N''
	AND isnull(s.RecordDeleted, ''N'') = ''N''
	
	--SELECT @ClientId = d.ClientId
	--FROM Documents d 
	--WHERE d.documentId = @DocumentId
	--AND isnull(d.RecordDeleted, ''N'') = ''N''
	
	SELECT @AssessmentDate = D.EffectiveDate
	FROM Documents d
	WHERE d.ClientId = @ClientId
		AND d.DocumentCodeId in (101, 349, 1469)
		AND d.Status = 22
		AND isnull(d.RecordDeleted, ''N'') = ''N''
		AND NOT EXISTS (Select 1 FROM Documents d2
				WHERE d2.ClientId = d.ClientID
				AND d2.DocumentCodeId in (101, 349, 1469)
				AND d2.Status = 22
				and ( d2.EffectiveDate > d.EffectiveDate
					or ( d2.EffectiveDate = d.EffectiveDate and d2.DocumentId > d.DocumentId )
					)
				AND isnull(d2.RecordDeleted, ''N'') = ''N''
				)
				
	--get the client''s active primary program
	select @ClientPrimaryProgramId = isnull(cp.ProgramId, 0)
	from clients c 
	join clientPrograms cp on cp.ClientId = c.ClientId
		and cp.Status <> 5
	where c.ClientId = @ClientId
	and cp.PrimaryAssignment=''Y''

	select @PRDate = D.EffectiveDate
	from Documents d
	where d.ClientId = @ClientId
	and d.DocumentCodeId in (3,352)
	and d.Status = 22
	and isnull(d.RecordDeleted, ''N'') = ''N''
	and not exists (
		Select * from Documents d2
		where d2.ClientId = d.ClientID
		and d2.DocumentCodeId in (3, 352)
		and d2.Status = 22
		and ( d2.EffectiveDate > d.EffectiveDate
				or ( d2.EffectiveDate = d.EffectiveDate and d2.DocumentId > d.DocumentId )
			)
		and isnull(d2.RecordDeleted, ''N'') = ''N''
		)
/*	
	SELECT @ObraDel	= convert(datetime, isnull(s.DateOfService, ''1/01/1900''), 101) 
	FROM Services s
	WHERE s.ProcedureCodeId = 392 --OBRA Delivery
	AND s.Status in (71, 75) --(show, Complete)
	AND s.ClientId = @ClientId
	AND isnull(s.RecordDeleted, ''N'') = ''N''
 	AND NOT EXISTS (SELECT ServiceId FROM Services s2
			WHERE s2.ProcedureCodeId = 392 --OBRA Delivery
			AND s2.Status in (71, 75) --(show, Complete)
			AND s2.ClientId = s.ClientId
			AND s2.DateOfService > s.DateOfService
			AND isnull(s2.RecordDeleted, ''N'') = ''N''
			)
*/

Insert into #validationReturnTable
(TableName,
ColumnName,
ErrorMessage
)
--This validation returns three fields
--Field1 = TableName
--Field2 = ColumnName
--Field3 = ErrorMessage

SELECT ''TPGeneral'', ''PlanOrAddendum'', ''General - Plan Or Addendum must be specified.''
	FROM #TPGeneral
	WHERE isnull(PlanOrAddendum,'''') not in (''A'',''T'')

--
--    Effective and Meeting Date Validations -- Approved by SAIP (standard for all affiliates)
--
-- *******************************************************************************************
	UNION
	SELECT ''TPGeneral'', ''DeletedBy'', ''General - Meeting date must be prior to effective date.''
	FROM #TPGeneral a
	join documents b on a.DocumentVersionId = b.CurrentDocumentVersionId
	WHERE dbo.Removetimestamp(a.MeetingDate) > dbo.Removetimestamp(b.EffectiveDate)

	UNION
	select ''TPGeneral'', ''DeletedBy'', ''Document - Effective date cannot be more than 31 days in the future.''
	from #TPGeneral t
	join Documents as d on d.CurrentDocumentVersionId = t.DocumentVersionId
	where datediff(day, getdate(), d.EffectiveDate) > 31

	UNION 
	SELECT ''TPGeneral'', ''DeletedBy'', ''General - Meeting date cannot be in the future.''
	FROM #TPGeneral a
	WHERE dbo.Removetimestamp(a.MeetingDate) > dbo.Removetimestamp(getdate())  
-- *******************************************************************************************

UNION
SELECT ''TPGeneral'', ''Participants'', ''General - Participants must be specified.''
	FROM #TPGeneral
	WHERE isnull(Participants,'''')=''''
	and @ProgramId <> @MedsOnlyProgramId
UNION
SELECT ''TPGeneral'', ''HopesAndDreams'', ''General - Desired Outcomes (Hopes And Dreams) must be specified.''
	FROM #TPGeneral
	WHERE isnull(HopesAndDreams,'''')=''''
	and @ProgramId <> @MedsOnlyProgramId
UNION
SELECT ''TPGeneral'', ''PurposeOfAddendum'', ''General - Purpose Of Addendum must be specified.''
	FROM #TPGeneral
	WHERE PlanOrAddendum = ''A''
	and isnull(PurposeOfAddendum,'''')=''''
UNION
SELECT ''TPGeneral'', ''StrengthsAndPreferences'', ''General - Strengths And Preferences must be specified.''
	FROM #TPGeneral
	WHERE isnull(StrengthsAndPreferences,'''')=''''
	and @ProgramId <> @MedsOnlyProgramId
UNION
SELECT ''TPGeneral'', ''AreasOfNeed'', ''General - Areas Of Need must be specified.''
	FROM #TPGeneral
	WHERE isnull(AreasOfNeed,'''')=''''
UNION
SELECT ''TPGeneral'', ''DeferredTreatmentIssues'', ''Summary - Deferred Treatment Issues must be specified.''
	FROM #TPGeneral
	WHERE isnull(DeferredTreatmentIssues,'''')=''''
	and @ProgramId <> @MedsOnlyProgramId
UNION
--SELECT ''TPGeneral'', ''PersonsNotPresent'', ''PersonsNotPresent must be specified.''
--UNION
SELECT ''TPGeneral'', ''DischargeCriteria'', ''Summary - Discharge / Transition Criteria must be specified.''
	FROM #TPGeneral
	WHERE isnull(DischargeCriteria,'''')=''''
	
UNION
SELECT ''TPGeneral'', ''DeletedBy'', ''Summary - Periodic Review Frequency must be specified.''
From #TPGeneral
where isnull(PeriodicReviewFrequencyNumber, '''')= ''''or isnull(PeriodicReviewFrequencyUnitType, '''')= ''''
and ( @ProgramId <> @MedsOnlyProgramId 
	 or ( @ClientPrimaryProgramId <> @MedsOnlyProgramId and PlanOrAddendum = ''A'' )
	)
UNION
SELECT ''TPGeneral'', ''DeletedBy'', ''Summary - Periodic Review Frequency must be between 1 & 50 '' +isnull(PeriodicReviewFrequencyUnitType,''Units'')+ ''.''
From #TPGeneral
where PeriodicReviewFrequencyNumber is not null
and ( isnull(PeriodicReviewFrequencyNumber, 0) < 1 
	or isnull(PeriodicReviewFrequencyNumber, 0) > 50 )
and ( @ProgramId <> @MedsOnlyProgramId  
	 or ( @ClientPrimaryProgramId <> @MedsOnlyProgramId and PlanOrAddendum = ''A'' )
	)

UNION
SELECT ''TPGeneral'', ''ClientAcceptedPlan'', ''Summary - Client Accepted Plan must be specified.''
	FROM #TPGeneral
	WHERE isnull(ClientAcceptedPlan,'''')=''''
UNION
SELECT ''TPGeneral'', ''CrisisPlan'', ''Summary - Crisis Plan must be specified.''
from #TPGeneral
where isnull(CrisisPlanNotNecessary, ''N'') = ''N''
	and isnull(CrisisPlan,'''')=''''
UNION
SELECT ''TPGeneral'', ''NotificationMessage'', ''Notification - Notification Messgage must be specified.''
	FROM #TPGeneral
	WHERE (isnull(StaffId1, 0) <> 0 or isnull(StaffId2, 0) <> 0 or isnull(StaffId3, 0) <> 0 or isnull(StaffId4, 0) <> 0)
	AND isnull(convert(varchar(8000), NotificationMessage), '''') = ''''



-- Validate Need Exists
UNION
SELECT ''TPGeneral'', ''DeletedBy'', ''Tx Plan Main - Please specify at least 1 active Goal/Objective/Intervention.''
	FROM #TPGeneral t
	WHERE NOT Exists (Select 1 from TPNeeds TPN 
			  where TPN.DocumentVersionId = t.DocumentVersionId
			  and isnull(tpn.GoalActive, ''N'')= ''Y''
			  AND isnull(TPN.RecordDeleted, ''N'') = ''N'')

-- Validate Goal Exists for Need
UNION
SELECT ''TPGeneral'', ''DeletedBy'', ''Tx Plan Main - Please specify goal for goal '' + convert(varchar(10), isnull(tpn.NeedNumber, ''''))
	FROM #TPGeneral t
	Join TPNeeds TPN on tpn.DocumentVersionId = t.DocumentVersionId
			  where NeedNumber is not null
			  AND isnull(convert(varchar(8000), GoalText), '''') = ''''
			  AND isnull(TPN.RecordDeleted, ''N'') = ''N''

-- Validate target date exists for goal
UNION
SELECT ''TPGeneral'', ''DeletedBy'', ''Tx Plan Main - Please specify target date for goal '' + convert(varchar(10), isnull(tpn.NeedNumber, ''''))
	FROM #TPGeneral t
	Join TPNeeds TPN on tpn.DocumentVersionId = t.DocumentVersionId
			  where NeedNumber is not null
			  AND GoalTargetDate is null
			  AND isnull(TPN.RecordDeleted, ''N'') = ''N''
			and isnull(tpn.GoalActive, ''N'')= ''Y''



-- Validate strengths pertinent to goal
UNION
SELECT ''TPGeneral'', ''DeletedBy'', ''Tx Plan Main - Please specify strengths pertinent to goal '' + convert(varchar(10), isnull(tpn.NeedNumber, ''''))
	FROM #TPGeneral t
	Join TPNeeds TPN on tpn.DocumentVersionId = t.DocumentVersionId
			  where NeedNumber is not null
			  AND isnull(GoalStrengths, '''') = ''''
			  AND isnull(TPN.RecordDeleted, ''N'') = ''N''
			and isnull(tpn.GoalActive, ''N'')= ''Y''
			and @ProgramId <> @MedsOnlyProgramId

/*
-- Validate stage of treatement
UNION
SELECT ''TPGeneral'', ''DeletedBy'', ''Tx Plan Main - Please specify stage of treatment for goal '' + convert(varchar(10), isnull(tpn.NeedNumber, ''''))
	FROM #TPGeneral t
	Join TPNeeds TPN on tpn.DocumentVersionId = t.DocumentVersionId
			  where NeedNumber is not null
			  AND StageOfTreatment is null
			  AND isnull(TPN.RecordDeleted, ''N'') = ''N''
				and isnull(tpn.GoalActive, ''N'')= ''Y''
*/
-- Validate monitored by
UNION
SELECT ''TPGeneral'', ''DeletedBy'', ''Tx Plan Main - Please specify monitored by for goal '' + convert(varchar(10), isnull(tpn.NeedNumber, ''''))
	FROM #TPGeneral t
	Join TPNeeds TPN on tpn.DocumentVersionId = t.DocumentVersionId
			  where NeedNumber is not null
			  AND isnull(GoalMonitoredBy, '''') = ''''
			  AND isnull(TPN.RecordDeleted, ''N'') = ''N''
			and isnull(tpn.GoalActive, ''N'')= ''Y''
			and @ProgramId <> @MedsOnlyProgramId

-- Validate Need Exists
UNION
SELECT ''TPGeneral'', ''DeletedBy'', ''Tx Plan Main - Please associate at least 1 need for goal '' + convert(varchar(10), isnull(tp.NeedNumber, ''''))
	FROM #TPGeneral t
	join Documents d on d.CurrentDocumentVersionId = t.DocumentVersionId
	Join TPNeeds TP on tp.DocumentVersionId = t.DocumentVersionId
	WHERE NOT Exists (Select 1 from TPNeeds TPN
			  join	CustomTPNeedsClientNeeds TPNC on TPNC.NeedId = TPN.NeedID
			  where TPN.DocumentVersionId = t.DocumentVersionId
				AND TPN.NeedId = TP.NeedId
			  AND isnull(TPN.RecordDeleted, ''N'') = ''N''
			  AND isnull(TPNC.Recorddeleted, ''N'')= ''N'')
		and exists (select 1 from Documents d2
					Where d2.ClientId = d.ClientId
					and d2.DocumentCodeId in (349,1469) --HRM Assessment
					and d2.EffectiveDate <= d.EffectiveDate
					and d2.status in (21, 22)
					and isnull(d2.RecordDeleted, ''N'')= ''N'')
and isnull(tp.RecordDeleted,''N'')= ''N''
and isnull(tp.GoalActive, ''N'')= ''Y''


-- Validate Objective Exists for Need
UNION
SELECT ''TPGeneral'', ''DeletedBy'', ''Tx Plan Main - Please specify objective text for '' + case when  isnull(convert(varchar(10), tpo.ObjectiveNumber), '''') <> '''' then ''objective '' + convert(varchar(10), isnull(convert(varchar(10), tpo.ObjectiveNumber), '''')) else ''goal '' + convert(varchar(10), isnull(tpn.NeedNumber, '''')) end
	FROM #TPGeneral t
	Join TPNeeds TPN on tpn.DocumentVersionId = t.DocumentVersionId
	LEFT JOIN TPObjectives TPO on tpo.DocumentVersionId = t.DocumentVersionId
			  AND isnull(TPN.NeedId, 0) = isnull(TPO.NeedId, 0)
			  AND isnull(TPO.RecordDeleted, ''N'') = ''N''
	WHERE isnull(convert(varchar(8000), ObjectiveText), '''') = ''''
	AND isnull(TPN.RecordDeleted, ''N'') = ''N''
and isnull(tpn.GoalActive, ''N'')= ''Y''

UNION
SELECT ''TPGeneral'', ''DeletedBy'', ''Tx Plan Main - Please specify target date for objective '' + convert(varchar(10), isnull(convert(varchar(10), tpo.ObjectiveNumber), ''''))
	FROM #TPGeneral t
	Join TPNeeds TPN on tpn.DocumentVersionId = t.DocumentVersionId
	JOIN TPObjectives TPO on tpo.DocumentVersionId = t.DocumentVersionId
			  AND isnull(TPN.NeedId, 0) = isnull(TPO.NeedId, 0)
			  AND isnull(TPO.RecordDeleted, ''N'') = ''N''
			  AND isnull(TPO.ObjectiveStatus, 0) = 191  --Active
	WHERE tpo.targetdate is null
	AND isnull(TPN.RecordDeleted, ''N'') = ''N''
	and isnull(tpn.GoalActive, ''N'')= ''Y''



-- Validate Intervention Exists for Need
UNION
SELECT ''TPGeneral'', ''DeletedBy'', ''Tx Plan Main - Please specify text for intervention '' + isnull(convert(varchar(10), tpi.InterventionNumber), '''')
	FROM #TPGeneral t
	Join TPNeeds TPN on tpn.DocumentVersionId = t.DocumentVersionId
	LEFT JOIN TPInterventionProcedures TPI on isnull(TPn.NeedId, 0) = isnull(TPi.NeedId, 0)
        	  	  AND isnull(TPi.RecordDeleted, ''N'') = ''N''
	WHERE isnull(convert(varchar(8000), InterventionText), '''') = ''''
	AND isnull(TPN.RecordDeleted, ''N'') = ''N''
	and isnull(tpn.GoalActive, ''N'')= ''Y''

UNION
SELECT ''TPGeneral'', ''DeletedBy'', ''Tx Plan Main - Please specify provider/procedure for intervention '' + isnull(convert(varchar(10), tpi.InterventionNumber), '''')
	FROM #TPGeneral t
	Join TPNeeds TPN on tpn.DocumentVersionId = t.DocumentVersionId
	LEFT JOIN TPInterventionProcedures TPI on  isnull(TPn.NeedId, 0) = isnull(TPi.NeedId, 0)
        	  	  AND isnull(TPi.RecordDeleted, ''N'') = ''N''
	WHERE tpi.authorizationcodeid is null
	AND isnull(tpi.SiteId, -1) not in (-2)
	--AND isnull(tpi.SiteId, 0) not in (-1)
	AND isnull(TPN.RecordDeleted, ''N'') = ''N''
	and isnull(tpn.GoalActive, ''N'')= ''Y''

UNION
SELECT ''TPGeneral'', ''DeletedBy'', ''Procedure - Intervention '' + isnull(convert(varchar(10), tpi2.InterventionNumber), '''') + '' has not been requested on the Procedure pop up.'' 
	FROM #TPGeneral t
	Join TPNeeds TPN on tpn.DocumentVersionId = t.DocumentVersionId
	LEFT JOIN TPInterventionProcedures TPI2 on  isnull(TPn.NeedId, 0) = isnull(TPi2.NeedId, 0)
        	  	  AND isnull(TPi2.RecordDeleted, ''N'') = ''N''
				  AND isnull(tpi2.SiteId, -1) not in (-2)
	WHERE exists (select 1 from TPInterventionProcedures TPI 
				where isnull(TPn.NeedId, 0) = isnull(TPi.NeedId, 0)
        	  	AND isnull(TPi.RecordDeleted, ''N'') = ''N''
				AND StartDate is null
				AND tpi.TPInterventionProcedureId = tpi2.TPInterventionProcedureId
				and isnull(tpi.SiteId, -1) not in (-2) --Community/Natural Supports
				--and isnull(tpi.SiteId, 0) not in (-1) --Community/Natural Supports
				 )
	AND isnull(TPN.RecordDeleted, ''N'') = ''N''
	and isnull(tpn.GoalActive, ''N'')= ''Y''
   


/*
UNION
SELECT ''TPGeneral'', ''DeletedBy'', ''Last Assessment document was created more than 30 days ago.  Please create a new Assessment before signing Treatment Plan.''
	FROM #TPGeneral t
	JOIN Documents d on t.documentId = D.DocumentId AND t.version = d.CurrentVersion
	WHERE @AuthorId <> 131 --Lynda Moss Perrin
	and DATEDIFF(day, isnull(@AssessmentDate, ''01/01/1900''), d.EffectiveDate) > 30
	AND @ProgramId in (1, 2, 3, 15, 17) --ACT, CSM, SBH, Bridges
	AND planoraddendum = ''T''
	AND d.documentid not in (520393, 538185, 556241, 605497, 622333, 636178, 652599)
	AND isnull(d.RecordDeleted, ''N'') = ''N''
*/

/*
-- Validate Author is Primary Clinician
UNION
SELECT ''TPGeneral'', ''DeletedBy'', ''Must be primary clinician to sign this document.''
	FROM #TPGeneral t
	Join Documents d on d.DocumentId = t.DocumentId and d.CurrentVersion = t.Version
	Join Clients c on c.ClientId = d.ClientId
	Left Join Staff s on s.StaffId = c.PrimaryClinicianId and isnull(s.RecordDeleted, ''N'') = ''N''
	Where d.DocumentId = @DocumentId 
	and ((isnull(s.PrimaryProgramId, 0) not in (1, 38) and  d.AuthorId <> isnull(s.StaffId, 0) )
			OR
		(isnull(s.PrimaryProgramId, 0) = 1 and  d.AuthorId not in (Select s2.staffid from staff s2 where s2.PrimaryProgramId = 1 and isnull(s2.Recorddeleted, ''N'') = ''N''))
			OR
		 (isnull(s.PrimaryProgramId, 0) = 38 and  d.AuthorId not in (Select s3.staffid from staff s3 where s3.PrimaryProgramId = 38 and isnull(s3.Recorddeleted, ''N'') = ''N''))
			)
	and planoraddendum = ''T''
	and isnull(d.RecordDeleted, ''N'') = ''N''
	and isnull(c.RecordDeleted, ''N'') = ''N''

*/
--UNION
--SELECT ''TPGeneral'', ''DeletedBy'', ''Signatures - Physician cosignature is required.''
--From #TPGeneral t
--where not exists (select * from DocumentSignatures ds
--				  join staff s on s.staffid = ds.staffid
--					where s.degree in (10104, 10134) --DR
--				  and ds.documentid = t.documentId
--					and isnull(ds.RecordDeleted, ''N'')= ''N'')

--UNION
--SELECT ''TPGeneral'', ''DeletedBy'', ''Signatures - Supervisor cosignature is required.''
--From #TPGeneral t
--where not exists (select * from DocumentSignatures ds
--				  join staff s on s.staffid = ds.staffid
--					where ds.documentid = t.documentid
--				  and s.Supervisor = ''Y''
--					and isnull(ds.RecordDeleted, ''N'')= ''N'')


--select * from staff
--select * from tpprocedures
--select * from tpinterventionprocedures



if @@error <> 0 goto error

return

error:
raiserror 50000 ''csp_validateCustomHRMTreatmentPlan failed.  Contact your system administrator.''
' 
END
GO
