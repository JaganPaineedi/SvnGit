/****** Object:  StoredProcedure [dbo].[csp_RDWExtractRAPScores]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDWExtractRAPScores]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDWExtractRAPScores]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDWExtractRAPScores]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_RDWExtractRAPScores]
@AffiliateId int
/*********************************************************************
-- Stored Procedure: dbo.csp_RDWExtractRAPScores
-- Creation Date:    11/20/2009
--
-- Purpose: populates CustomRDWExtractRAPScores table
--
-- Updates:
--   Date         Author      Purpose
--   11.20.2009   SFarber     Created.
--   09.29.2010   DHarvey     Modified to use DocumentVersionId.
*********************************************************************/
as

delete from CustomRDWExtractRAPScores

if @@error <> 0 goto error

insert into CustomRDWExtractRAPScores (
       AffiliateId,
       DocumentId,
       ClientId,
       EpisodeNumber,
       EffectiveDate,
       CommunityInclusionManageLivingArrangements,
       CommunityInclusionManageJobCareer,
       CommunityInclusionPayRentUtilities,
       CommunityInclusionShop,
       CommunityInclusionAttendSocialGatherings,
       CommunityInclusionUseTransportation,
       CommunityInclusionParticipateInCommunity,
       CommunityInclusionKeepMyselfSafe,
       CommunityInclusionRoutinelyWork,
       CommunityInclusionGetAssistance,
       CommunityInclusionManageSchedule,
       CommunityInclusionManageFinancialAffairs,
       CommunityInclusionAdocateForMyself,
       CommunityInclusionManagePersonalLegalAffairs,
       ChallengingBehaviorsManageRelationships,
       ChallengingBehaviorsKeepMyselfSafe,
       ChallengingBehaviorsKeepMyPropertySafe,
       ChallengingBehaviorsParticipateInCommunity,
       CurrentAbilitiesEatDrink,
       CurrentAbilitiesDressMyself,
       CurrentAbilitiesManagePersonalHygiene,
       CurrentAbilitiesPrepareMeals,
       CurrentAbilitiesManageRestingSituations,
       CurrentAbilitiesMoveAroundHouse,
       CurrentAbilitiesManageEmergencies,
       CurrentAbilitiesManageRelationships,
       CurrentAbilitiesDoHouseholdChores,
       CurrentAbilitiesManageTransportation,
       HealthTakeMedications,
       HealthManageTreatments,
       HealthAvoidInjury,
       HealthManageMedicalSituation,
       HealthPlanMeals,
       HealthUseMedicalEquipment,
       HealthArrangeTherapies,
       HealthMonitorHealth,
       HealthMaintainPhysicalActivites,
       HealthManageMentalHealth,
       HealthNeedSpecializedEquipment)
select c.AffiliateId,
       d.DocumentId,
       c.ClientId,
       max(case when ce.OpenDate <= d.EffectiveDate and d.EffectiveDate < dateadd(dd, 1, ce.CloseDate) then c.EpisodeNumber else 1 end) as EpisodeNumber,
       max(d.EffectiveDate) as EffectiveDate,
       max(case when ac.HRMRAPQuestionId = 1  then ac.RAPAssessedValue else null end),
       max(case when ac.HRMRAPQuestionId = 2  then ac.RAPAssessedValue else null end),
       max(case when ac.HRMRAPQuestionId = 3  then ac.RAPAssessedValue else null end),
       max(case when ac.HRMRAPQuestionId = 4  then ac.RAPAssessedValue else null end),
       max(case when ac.HRMRAPQuestionId = 5  then ac.RAPAssessedValue else null end),
       max(case when ac.HRMRAPQuestionId = 6  then ac.RAPAssessedValue else null end),
       max(case when ac.HRMRAPQuestionId = 7  then ac.RAPAssessedValue else null end),
       max(case when ac.HRMRAPQuestionId = 8  then ac.RAPAssessedValue else null end),
       max(case when ac.HRMRAPQuestionId = 9  then ac.RAPAssessedValue else null end),
       max(case when ac.HRMRAPQuestionId = 10 then ac.RAPAssessedValue else null end),
       max(case when ac.HRMRAPQuestionId = 11 then ac.RAPAssessedValue else null end),
       max(case when ac.HRMRAPQuestionId = 12 then ac.RAPAssessedValue else null end),
       max(case when ac.HRMRAPQuestionId = 13 then ac.RAPAssessedValue else null end),
       max(case when ac.HRMRAPQuestionId = 14 then ac.RAPAssessedValue else null end),
       max(case when ac.HRMRAPQuestionId = 15 then ac.RAPAssessedValue else null end),
       max(case when ac.HRMRAPQuestionId = 16 then ac.RAPAssessedValue else null end),
       max(case when ac.HRMRAPQuestionId = 17 then ac.RAPAssessedValue else null end),
       max(case when ac.HRMRAPQuestionId = 18 then ac.RAPAssessedValue else null end),
       max(case when ac.HRMRAPQuestionId = 19 then ac.RAPAssessedValue else null end),
       max(case when ac.HRMRAPQuestionId = 20 then ac.RAPAssessedValue else null end),
       max(case when ac.HRMRAPQuestionId = 21 then ac.RAPAssessedValue else null end),
       max(case when ac.HRMRAPQuestionId = 22 then ac.RAPAssessedValue else null end),
       max(case when ac.HRMRAPQuestionId = 23 then ac.RAPAssessedValue else null end),
       max(case when ac.HRMRAPQuestionId = 24 then ac.RAPAssessedValue else null end),
       max(case when ac.HRMRAPQuestionId = 25 then ac.RAPAssessedValue else null end),
       max(case when ac.HRMRAPQuestionId = 26 then ac.RAPAssessedValue else null end),
       max(case when ac.HRMRAPQuestionId = 27 then ac.RAPAssessedValue else null end),
       max(case when ac.HRMRAPQuestionId = 28 then ac.RAPAssessedValue else null end),
       max(case when ac.HRMRAPQuestionId = 29 then ac.RAPAssessedValue else null end),
       max(case when ac.HRMRAPQuestionId = 30 then ac.RAPAssessedValue else null end),
       max(case when ac.HRMRAPQuestionId = 31 then ac.RAPAssessedValue else null end),
       max(case when ac.HRMRAPQuestionId = 32 then ac.RAPAssessedValue else null end),
       max(case when ac.HRMRAPQuestionId = 33 then ac.RAPAssessedValue else null end),
       max(case when ac.HRMRAPQuestionId = 34 then ac.RAPAssessedValue else null end),
       max(case when ac.HRMRAPQuestionId = 35 then ac.RAPAssessedValue else null end),
       max(case when ac.HRMRAPQuestionId = 36 then ac.RAPAssessedValue else null end),
       max(case when ac.HRMRAPQuestionId = 37 then ac.RAPAssessedValue else null end),
       max(case when ac.HRMRAPQuestionId = 38 then ac.RAPAssessedValue else null end),
       max(case when ac.HRMRAPQuestionId = 39 then ac.RAPAssessedValue else null end)
  from Documents d
       join CustomHRMAssessments a on a.DocumentVersionId = d.CurrentDocumentVersionId
       join CustomHRMAssessmentRAPScores ac on ac.DocumentVersionId = a.DocumentVersionId
       join CustomRDWExtractClients c on c.ClientId = d.ClientId
       join CustomRDWExtractClientEpisodes ce on ce.ClientId = c.ClientId and ce.EpisodeNumber = c.EpisodeNumber
 where d.Status = 22
   and d.EffectiveDate < dateadd(dd, 1, convert(char(10), getdate(), 101))
   and isnull(d.RecordDeleted, ''N'') = ''N''
   and isnull(a.RecordDeleted, ''N'') = ''N''
   and isnull(ac.RecordDeleted, ''N'') = ''N''
 group by c.AffiliateId,
          c.ClientId,
          d.DocumentId

if @@error <> 0 goto error

return

error:

exec csp_RDWExtractError @AffiliateId = @AffiliateId, @ErrorText = ''Failed to execute csp_RDWExtractRAPScores''
' 
END
GO
