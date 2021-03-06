/****** Object:  StoredProcedure [dbo].[csp_RDWExtractDailyLivingActivityScores]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDWExtractDailyLivingActivityScores]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDWExtractDailyLivingActivityScores]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDWExtractDailyLivingActivityScores]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_RDWExtractDailyLivingActivityScores]
@AffiliateId int
/*********************************************************************
-- Stored Procedure: dbo.csp_RDWExtractDailyLivingActivityScores
-- Creation Date:    11/20/2009
--
-- Purpose: populates CustomRDWExtractDailyLivingActivityScores table
--
-- Updates:
--   Date         Author      Purpose
--   11.20.2009   SFarber     Created.
--   01.15.2011   SFarber     Synced to new data model.  
*********************************************************************/
as

delete from CustomRDWExtractDailyLivingActivityScores

if @@error <> 0 goto error

insert into CustomRDWExtractDailyLivingActivityScores (
       AffiliateId,
       DocumentId,
       ClientId,
       EpisodeNumber,
       EffectiveDate,
       HealthPractices,
       HousingStability,
       Communication,
       Safety,
       ManagingTime,
       ManagingMoney,
       Nutrition,
       ProblemSolving,
       FamilyRelationships,
       AlcoholDrugUse,
       Leisure,
       CommunityResources,
       SocialNetwork,
       Sexuality,
       Productivity,
       CopingSkills,
       BehaviorNorms,
       PersonalHygiene,
       Grooming,
       Dress)
select c.AffiliateId,
       d.DocumentId,
       c.ClientId,
       max(case when ce.OpenDate <= d.EffectiveDate and d.EffectiveDate < dateadd(dd, 1, ce.CloseDate) then c.EpisodeNumber else 1 end) as EpisodeNumber,
       max(d.EffectiveDate) as EffectiveDate,
       max(case when ac.HRMActivityId = 1  then ac.ActivityScore else null end),
       max(case when ac.HRMActivityId = 2  then ac.ActivityScore else null end),
       max(case when ac.HRMActivityId = 3  then ac.ActivityScore else null end),
       max(case when ac.HRMActivityId = 4  then ac.ActivityScore else null end),
       max(case when ac.HRMActivityId = 5  then ac.ActivityScore else null end),
       max(case when ac.HRMActivityId = 6  then ac.ActivityScore else null end),
       max(case when ac.HRMActivityId = 7  then ac.ActivityScore else null end),
       max(case when ac.HRMActivityId = 8  then ac.ActivityScore else null end),
       max(case when ac.HRMActivityId = 9  then ac.ActivityScore else null end),
       max(case when ac.HRMActivityId = 10 then ac.ActivityScore else null end),
       max(case when ac.HRMActivityId = 11 then ac.ActivityScore else null end),
       max(case when ac.HRMActivityId = 12 then ac.ActivityScore else null end),
       max(case when ac.HRMActivityId = 13 then ac.ActivityScore else null end),
       max(case when ac.HRMActivityId = 14 then ac.ActivityScore else null end),
       max(case when ac.HRMActivityId = 15 then ac.ActivityScore else null end),
       max(case when ac.HRMActivityId = 16 then ac.ActivityScore else null end),
       max(case when ac.HRMActivityId = 17 then ac.ActivityScore else null end),
       max(case when ac.HRMActivityId = 18 then ac.ActivityScore else null end),
       max(case when ac.HRMActivityId = 19 then ac.ActivityScore else null end),
       max(case when ac.HRMActivityId = 20 then ac.ActivityScore else null end)
  from Documents d
       join CustomHRMAssessments a on a.DocumentVersionId = d.CurrentDocumentVersionId 
       join CustomDailyLivingActivityScores as ac on ac.DocumentVersionId = d.CurrentDocumentVersionId  
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

exec csp_RDWExtractError @AffiliateId = @AffiliateId, @ErrorText = ''Failed to execute csp_RDWExtractDailyLivingActivityScores''
' 
END
GO
