/****** Object:  StoredProcedure [dbo].[csp_InitializeCustomDocumentHealthHomeCarePlans]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitializeCustomDocumentHealthHomeCarePlans]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitializeCustomDocumentHealthHomeCarePlans]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitializeCustomDocumentHealthHomeCarePlans]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

--select * from dbo.GlobalCodes where Category like ''%diag%''
--select * from dbo.GlobalCodeCategories where Category like ''%diag%''

CREATE procedure [dbo].[csp_InitializeCustomDocumentHealthHomeCarePlans]
    @ClientID int,
    @StaffID int,
    @CustomParameters xml
as 
declare @PRIMARYCARERELATIONSHIPCODEID int = 1009494
declare @DIAGNOSISDIAGNOSED int
declare @MostRecentDiagnosisVersionId int
declare @MostRecentTreatmentPlanVersionId int
declare @MostRecentCarePlanVersionId int


declare @tabBHGoals table (
     GoalId int,
     GoalNumber int,
     NeedIdentifiedDate datetime,
     NeedDescription varchar(max),
     GoalDescription varchar(max),
     GoalTargetDate datetime,
     GoalObjectives varchar(max),
     GoalServices varchar(max),
     SourceDocumentVersionId int
    )
	

select  @DIAGNOSISDIAGNOSED = GlobalCodeId
from    dbo.GlobalCodes
where   Category = ''XDIAGNOSISSOURCE''
        and CodeName = ''Diagnosed''
        and ISNULL(RecordDeleted, ''N'') <> ''Y''

select top 1
        @MostRecentDiagnosisVersionId = d.CurrentDocumentVersionId
from    dbo.Documents as d
where   d.ClientId = @ClientID
        and d.DocumentCodeId = 5
        and d.Status = 22
        and ISNULL(d.RecordDeleted, ''N'') <> ''Y''
order by d.EffectiveDate desc,
        d.DocumentId desc

select top 1
        @MostRecentTreatmentPlanVersionId = d.CurrentDocumentVersionId
from    dbo.Documents as d
where   d.ClientId = @ClientID
        and d.DocumentCodeId in (1483, 1484, 1485)
        and d.Status = 22
        and ISNULL(d.RecordDeleted, ''N'') <> ''Y''
order by d.EffectiveDate desc,
        d.DocumentId desc

select top 1 @MostRecentCarePlanVersionId = hcp.DocumentVersionId
from dbo.CustomDocumentHealthHomeCarePlans as hcp
join dbo.Documents as d on d.CurrentDocumentVersionId = hcp.DocumentVersionId
where d.ClientId = @ClientID
and d.Status = 22
and ISNULL(d.RecordDeleted, ''N'') <> ''Y''

if @MostRecentCarePlanVersionId is null set @MostRecentCarePlanVersionId = -1

--print @MostRecentCarePlanVersionId

select  PlaceHolder.TableName,
        -1 as DocumentVersionId,
        hhp.DocumentVersionId,
        hhp.CreatedBy,
        hhp.CreatedDate,
        hhp.ModifiedBy,
        hhp.ModifiedDate,
        hhp.RecordDeleted,
        hhp.DeletedBy,
        hhp.DeletedDate,
        ISNULL(hhp.PrimaryCareProviderFirstName, pcp.FirstName) as PrimaryCareProviderFirstName,
        ISNULL(hhp.PrimaryCareProviderLastName, pcp.LastName) as PrimaryCareProviderLastName,
        ISNULL(hhp.PrimaryCareProviderOrganization, pcp.Organization) as PrimaryCareProviderOrganization,
        hhp.ProblemList,
        hhp.ClientHasLivingWillOrDurablePOA,
        hhp.LongTermCareNotNeeded,
        hhp.LongTermCareNeeded,
        hhp.AdmitToFacilityType,
        hhp.AdmitToFacility,
        hhp.AdmitToFacilityNotApplicable,
        hhp.AdmissionComments,
        hhp.PrimaryTreatingProviderInCare,
        hhp.AchievingOutcomeAssistanceObtainingHealthcare,
        hhp.AchievingOutcomeMedicationManagement,
        hhp.AchievingOutcomeTrackTestsReferrals,
        hhp.AchievingOutcomeCoordinateCollaborate,
        hhp.AchievingOutcomeCoordinateReferrals,
        hhp.AchievingOutcomeProvideHealthEducation,
        hhp.AchievingOutcomeProvideReferralsToSelfHelpSupport,
        hhp.AchievingOutcomeAppointmentReminders,
        hhp.AchievingOutcomeFacilitateTransitionDischarge,
        hhp.AchievingOutcomeAdvocacyAnalysisApplications,
        hhp.AchievingOutcomeReviewRecords,
        hhp.AchievingOutcomeSupportRelationships,
        hhp.AchievingOutcomeOther,
        hhp.AchievingOutcomeOtherComment,
        hhp.ClientGuardianParticipatedInPlan,
        hhp.ClientCardianReasonForNonParticipation
from    (
         select ''CustomDocumentHealthHomeCarePlans'' as TableName,
                @MostRecentCarePlanVersionId as DocumentVersionId
        ) as PlaceHolder
left join dbo.CustomDocumentHealthHomeCarePlans as hhp on hhp.DocumentVersionId = PlaceHolder.DocumentVersionId
left join (
           select top 1
                    cc.ClientId,
                    cc.LastName,
                    cc.FirstName,
                    cc.Organization
           from     dbo.ClientContacts as cc
           where    cc.Relationship = @PRIMARYCARERELATIONSHIPCODEID
                    and cc.ClientId = @ClientID
                    and ISNULL(cc.RecordDeleted, ''N'') <> ''Y''
           order by cc.CreatedDate desc
          ) as pcp on pcp.ClientId = @ClientID


select  PlaceHolder.TableName,
        (CAST(ROW_NUMBER() over (order by hhpo.OutcomeSequence) as int) * -1) CustomDocumentHealthHomeCarePlanOutcomeId,
        hhpo.CreatedBy,
        hhpo.CreatedDate,
        hhpo.ModifiedBy,
        hhpo.ModifiedDate,
        hhpo.RecordDeleted,
        hhpo.DeletedBy,
        hhpo.DeletedDate,
        -1 as DocumentVersionId,
        hhpo.OutcomeSequence,
        hhpo.OutcomeDescription,
        hhpo.OutcomeCriteria,
        DATEADD(DAY, 90, CAST(CAST(GETDATE() as date) as datetime)) as TargetDate
from    (
         select ''CustomDocumentHealthHomeCarePlanOutcomes'' as TableName,
                @MostRecentCarePlanVersionId as DocumentVersionId
        ) as PlaceHolder
join    dbo.CustomDocumentHealthHomeCarePlanOutcomes as hhpo on hhpo.DocumentVersionId = PlaceHolder.DocumentVersionId


if @MostRecentTreatmentPlanVersionId is not null
    begin

        insert  into @tabBHGoals
                (
                 GoalId,
                 GoalNumber,
                 GoalDescription,
                 GoalTargetDate,
                 SourceDocumentVersionId,
                 NeedDescription,
                 GoalObjectives,
                 GoalServices
	            )
                select  g.TPGoalId,
                        g.GoalNumber,
                        g.GoalText,
                        g.TargeDate,
                        g.DocumentVersionId,
                        '''',
                        '''',
                        ''''
                from    dbo.CustomTPGoals as g
                where   g.DocumentVersionId = @MostRecentTreatmentPlanVersionId
                        and ISNULL(g.RecordDeleted, ''N'') <> ''Y''

        update  g
        set     NeedIdentifiedDate = CAST(CAST(n.NeedIdentied as date) as datetime)	-- remove time portion
        from    @tabBHGoals as g
        join    (
                 select tpgn.TPGoalId,
                        MIN(tpn.CreatedDate) as NeedIdentied
                 from   dbo.CustomTPNeeds as tpn
                 join   dbo.CustomTPGoalNeeds as tpgn on tpgn.NeedId = tpn.NeedId
                 join   @tabBHGoals as g on g.GoalId = tpgn.TPGoalId
                 where  ISNULL(tpgn.RecordDeleted, ''N'') <> ''Y''
                        and ISNULL(tpn.RecordDeleted, ''N'') <> ''Y''
                 group by tpgn.TPGoalId
                ) as n on n.TPGoalId = g.GoalId


        declare @cGoals cursor,
            @GoalId int
        declare @NeedsText varchar(max),
            @ObjectivesText varchar(max),
            @ServicesText varchar(max)

        set @cGoals = cursor for
	select GoalId
	from @tabBHGoals
	for update of NeedDescription, GoalObjectives, GoalServices
	
        open @cGoals
	
        fetch @cGoals into @GoalId
	
        while @@FETCH_STATUS = 0 
            begin
                set @NeedsText = ''''
                set @ObjectivesText = ''''
                set @ServicesText = ''''

                select  @NeedsText = @NeedsText + ISNULL(tpn.NeedText, '''')
                        + CHAR(13) + CHAR(10)
                from    dbo.CustomTPNeeds as tpn
                join    dbo.CustomTPGoalNeeds as tpgn on tpgn.NeedId = tpn.NeedId
                where   tpgn.TPGoalId = @GoalId
                        and ISNULL(tpgn.RecordDeleted, ''N'') <> ''Y''
		
		
                select  @ServicesText = @ServicesText
                        + ISNULL(ac.AuthorizationCodeName, '''') + '' - ''
                        + ISNULL(CAST(CAST(tps.Units as decimal(10, 2)) as varchar),
                                 '''') + '' '' + gcUnitType.CodeName + '' - ''
                        + ISNULL(gcFreq.CodeName, '''') + CHAR(13) + CHAR(10)
                from    dbo.CustomTPServices as tps
                join    dbo.AuthorizationCodes as ac on ac.AuthorizationCodeId = tps.AuthorizationCodeId
                join    dbo.GlobalCodes as gcUnitType on gcUnitType.GlobalCodeId = ac.UnitType
                left join dbo.GlobalCodes as gcFreq on gcFreq.GlobalCodeId = tps.FrequencyType
                where   tps.TPGoalId = @GoalId
                order by tps.ServiceNumber

                select  @ObjectivesText = @ObjectivesText
                        + CAST(tpo.ObjectiveNumber as varchar) + '' ''
                        + ISNULL(tpo.ObjectiveText, '''') + CHAR(13) + CHAR(10)
                from    dbo.CustomTPObjectives as tpo
                where   tpo.TPGoalId = @GoalId
	
                update  @tabBHGoals
                set     NeedDescription = @NeedsText,
                        GoalObjectives = @ObjectivesText,
                        GoalServices = @ServicesText
                where current of @cGoals
		
                fetch @cGoals into @GoalId
            end
	
        close @cGoals
	
        deallocate @cGoals

    end

declare @MaxGoalNum int
select @MaxGoalNum = MAX(GoalNumber) from @tabBHGoals
if @MaxGoalNum is null set @MaxGoalNum = 0

select  PlaceHolder.TableName,
        (CAST(ROW_NUMBER() over (order by tpg.GoalNumber) as int) * -1) as CustomDocumentHealthHomeCarePlanBHGoalId,
        tpg.CreatedBy,
        tpg.CreatedDate,
        tpg.ModifiedBy,
        tpg.ModifiedDate,
        tpg.RecordDeleted,
        tpg.DeletedBy,
        tpg.DeletedDate,
        CAST(-1 as int) as DocumentVersionId,
        bhg.GoalNumber,
        ''Harbor'' as GoalProvider,
        bhg.NeedIdentifiedDate as NeedIdentifiedDate,
        bhg.NeedDescription as NeedDescription,
        bhg.GoalDescription as GoalDescription,
        bhg.GoalTargetDate as GoalTargetDate,
        bhg.GoalObjectives as GoalObjectives,
        bhg.GoalServices as GoalServices,
        bhg.SourceDocumentVersionId as SourceDocumentVersionId
from    (
         select ''CustomDocumentHealthHomeCarePlanBHGoals'' as TableName,
                @MostRecentCarePlanVersionId as DocumentVersionId
        ) as PlaceHolder
cross join @tabBHGoals as bhg
join    dbo.CustomTPGoals as tpg on tpg.TPGoalId = bhg.GoalId
union all
select  PlaceHolder.TableName,
        ((CAST(ROW_NUMBER() over (order by hhpg.GoalNumber) as int) + @MaxGoalNum) * -1) as CustomDocumentHealthHomeCarePlanBHGoalId,
                hhpg.CreatedBy,
                hhpg.CreatedDate,
                hhpg.ModifiedBy,
                hhpg.ModifiedDate,
                hhpg.RecordDeleted,
                hhpg.DeletedBy,
                hhpg.DeletedDate,
                CAST(-1 as int) as DocumentVersionId,
                (CAST(ROW_NUMBER() over (order by hhpg.GoalNumber) as int) + @MaxGoalNum) as GoalNumber,
                hhpg.GoalProvider,
                hhpg.NeedIdentifiedDate,
                hhpg.NeedDescription,
                hhpg.GoalDescription,
                DATEADD(DAY, 90, CAST(CAST(GETDATE() as date) as datetime)) as GoalTargetDate,
                hhpg.GoalObjectives,
                hhpg.GoalServices,
                hhpg.SourceDocumentVersionId
from    (
         select ''CustomDocumentHealthHomeCarePlanBHGoals'' as TableName,
                @MostRecentCarePlanVersionId as DocumentVersionId
        ) as PlaceHolder
join    dbo.CustomDocumentHealthHomeCarePlanBHGoals as hhpg on hhpg.DocumentVersionId = PlaceHolder.DocumentVersionId
where hhpg.SourceDocumentVersionId is null
and ISNULL(hhpg.RecordDeleted, ''N'') <> ''Y''



select  PlaceHolder.TableName,
        (CAST(ROW_NUMBER() over (order by hhpn.PsychosocialSupportNeedSequence) as int) * -1) as CustomDocumentHealthHomeCarePlanPESNeedId,
        hhpn.CreatedBy,
        hhpn.CreatedDate,
        hhpn.ModifiedBy,
        hhpn.ModifiedDate,
        hhpn.RecordDeleted,
        hhpn.DeletedBy,
        hhpn.DeletedDate,
        CAST(-1 as int) as DocumentVersionId,
        hhpn.PsychosocialSupportNeedSequence,
        hhpn.PsychosocialSupportNeedType,
        hhpn.PsychosocialSupportNeedPlan
from    (
         select ''CustomDocumentHealthHomeCarePlanPESNeeds'' as TableName,
                @MostRecentCarePlanVersionId as DocumentVersionId
        ) as PlaceHolder
join    dbo.CustomDocumentHealthHomeCarePlanPESNeeds as hhpn on hhpn.DocumentVersionId = PlaceHolder.DocumentVersionId

-- only copy from DX3 if no recent plan
if @MostRecentCarePlanVersionId < 0
begin
	select  PlaceHolder.TableName,
			(CAST(ROW_NUMBER() over (order by icd.ICDDescription) as int) * -1) as CustomDocumentHealthHomeCarePlanDiagnosisId,
			dx3.CreatedBy,
			dx3.CreatedDate,
			dx3.ModifiedBy,
			dx3.ModifiedDate,
			dx3.RecordDeleted,
			dx3.DeletedBy,
			dx3.DeletedDate,
			CAST(-1 as int) as DocumentVersionId,
			(CAST(ROW_NUMBER() over (order by icd.ICDDescription) as int)) as SequenceNumber,
			LEFT(icd.ICDDescription, 200) as ReportedDiagnosis,
			@DIAGNOSISDIAGNOSED as DiagnosisSource,
			''Harbor'' as TreatmentProvider
	from    (
			 select ''CustomDocumentHealthHomeCarePlanDiagnoses'' as TableName,
					@MostRecentCarePlanVersionId as DocumentVersionId
			) as PlaceHolder --join    dbo.CustomDocumentHealthHomeCarePlanDiagnoses as hhpd on 1 = 1	--hhpd.DocumentVersionId = PlaceHolder.DocumentVersionId
	cross join dbo.DiagnosesIIICodes as dx3
	join    dbo.DiagnosisICDCodes as icd on icd.ICDCode = dx3.ICDCode
	where   dx3.DocumentVersionId = @MostRecentDiagnosisVersionId
			and ISNULL(dx3.RecordDeleted, ''N'') <> ''Y''
end
else
begin
	select  PlaceHolder.TableName,
			(CAST(ROW_NUMBER() over (order by hhpd.SequenceNumber) as int) * -1) as CustomDocumentHealthHomeCarePlanDiagnosisId,
			        hhpd.CreatedBy,
			        hhpd.CreatedDate,
			        hhpd.ModifiedBy,
			        hhpd.ModifiedDate,
			        hhpd.RecordDeleted,
			        hhpd.DeletedBy,
			        hhpd.DeletedDate,
			        CAST(-1 as int) as DocumentVersionId,
			        hhpd.SequenceNumber,
			        hhpd.ReportedDiagnosis,
			        hhpd.DiagnosisSource,
			        hhpd.TreatmentProvider
	from    (
			 select ''CustomDocumentHealthHomeCarePlanDiagnoses'' as TableName,
					@MostRecentCarePlanVersionId as DocumentVersionId
			) as PlaceHolder
			join    dbo.CustomDocumentHealthHomeCarePlanDiagnoses as hhpd on hhpd.DocumentVersionId = PlaceHolder.DocumentVersionId
end


select  PlaceHolder.TableName,
        (CAST(ROW_NUMBER() over (order by hhpo.OutcomeSequence) as int) * -1) as CustomDocumentHealthHomeCarePlanLongTermCareOutcomeId,
        hhpo.CreatedBy,
        hhpo.CreatedDate,
        hhpo.ModifiedBy,
        hhpo.ModifiedDate,
        hhpo.RecordDeleted,
        hhpo.DeletedBy,
        hhpo.DeletedDate,
        CAST(-1 as int) as DocumentVersionId,
        hhpo.OutcomeSequence,
        hhpo.OutcomeDescription,
        DATEADD(DAY, 90, CAST(CAST(GETDATE() as date) as datetime)) as TargetDate
from    (
         select ''CustomDocumentHealthHomeCarePlanLongTermCareOutcomes'' as TableName,
                @MostRecentCarePlanVersionId as DocumentVersionId
        ) as PlaceHolder
join    dbo.CustomDocumentHealthHomeCarePlanLongTermCareOutcomes as hhpo on hhpo.DocumentVersionId = PlaceHolder.DocumentVersionId



' 
END
GO
