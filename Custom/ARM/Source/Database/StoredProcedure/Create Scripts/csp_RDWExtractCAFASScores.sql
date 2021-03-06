/****** Object:  StoredProcedure [dbo].[csp_RDWExtractCAFASScores]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDWExtractCAFASScores]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDWExtractCAFASScores]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDWExtractCAFASScores]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_RDWExtractCAFASScores]
@AffiliateId int
/*********************************************************************
-- Stored Procedure: dbo.csp_RDWExtractCAFASScores
-- Creation Date:    11/20/2009
--
-- Purpose: populates CustomRDWExtractCAFASScores table
--
-- Updates:
--   Date         Author      Purpose
--   11.20.2009   SFarber     Created.
--   09.29.2010   DHarvey     Modified to use DocumentVersionId
*********************************************************************/
as

delete from CustomRDWExtractCAFASScores

if @@error <> 0 goto error

insert into CustomRDWExtractCAFASScores (
       AffiliateId,
       DocumentId,
       ClientId,
       EpisodeNumber,
       EffectiveDate,
       CAFASIntervalCode,
       CAFASInterval,
       SchoolPerformance,
       HomePerformance,
       CommunityPerformance,
       BehaviorTowardsOther,
       MoodsEmotion,
       SelfHarmfulBehavior,
       SubstanceUse,
       Thinkng,
       PrimaryFamilyMaterialNeeds,
       PrimaryFamilySocialSupport,
       NonCustodialMaterialNeeds,
       NonCustodialSocialSupport,
       SurrogateMaterialNeeds,
       SurrogateSocialSupport)
select c.AffiliateId
      ,d.DocumentId
      ,c.ClientId
      ,max(case when ce.OpenDate <= d.EffectiveDate and d.EffectiveDate < dateadd(dd, 1, ce.CloseDate) then c.EpisodeNumber else 1 end) as EpisodeNumber
      ,max(d.EffectiveDate)
      ,max(gci.ExternalCode1)
      ,case max(gci.ExternalCode1)
            when ''1'' then ''Initial''
            when ''2'' then ''Annual''
            when ''3'' then ''Termination''
            when ''4'' then ''Not Appropriate''
            when ''5'' then ''Not Assessed''
            when ''6'' then ''Other'' 
            else null
       end
      ,max(s.SchoolPerformance)
      ,max(s.HomePerformance)
      ,max(s.CommunityPerformance)
      ,max(s.BehaviourTowardsOther)
      ,max(s.MoodsEmotion)
      ,max(s.SelfHarmfulBehavoiur)
      ,max(s.SubstanceUse)
      ,max(s.Thinkng)
      ,max(s.PrimaryFamilyMaterialNeeds)
      ,max(s.PrimaryFamilySocialSupport)
      ,max(s.NonCustodialMaterialNeeds)
      ,max(s.NonCustodialSocialSupport)
      ,max(s.SurrogateMaterialNeeds)
      ,max(s.SurrogateSocialSupport)
  from Documents d
       join CustomCAFAS s on s.DocumentVersionId = d.CurrentDocumentVersionId
       join CustomRDWExtractClients c on c.ClientId = d.ClientId
       join CustomRDWExtractClientEpisodes ce on ce.ClientId = c.ClientId and ce.EpisodeNumber = c.EpisodeNumber
       left join GlobalCodes gci on gci.Category = ''XCAFASINTERVAL'' and gci.GlobalCodeId = s.CAFASInterval
 where d.Status = 22
   and d.EffectiveDate < dateadd(dd, 1, convert(char(10), getdate(), 101))
   and isnull(d.RecordDeleted, ''N'') = ''N''
   and isnull(s.RecordDeleted, ''N'') = ''N''
 group by c.AffiliateId,
          c.ClientId,
          d.DocumentId

if @@error <> 0 goto error

insert into CustomRDWExtractCAFASScores (
       AffiliateId,
       DocumentId,
       ClientId,
       EpisodeNumber,
       EffectiveDate,
       CAFASIntervalCode,
       CAFASInterval,
       SchoolPerformance,
       HomePerformance,
       CommunityPerformance,
       BehaviorTowardsOther,
       MoodsEmotion,
       SelfHarmfulBehavior,
       SubstanceUse,
       Thinkng,
       PrimaryFamilyMaterialNeeds,
       PrimaryFamilySocialSupport,
       NonCustodialMaterialNeeds,
       NonCustodialSocialSupport,
       SurrogateMaterialNeeds,
       SurrogateSocialSupport)
select c.AffiliateId
      ,d.DocumentId
      ,c.ClientId
      ,max(case when ce.OpenDate <= d.EffectiveDate and d.EffectiveDate < dateadd(dd, 1, ce.CloseDate) then c.EpisodeNumber else 1 end) as EpisodeNumber
      ,max(d.EffectiveDate)
      ,max(gci.ExternalCode1)
      ,case max(gci.ExternalCode1)
            when ''1'' then ''Initial''
            when ''2'' then ''Annual''
            when ''3'' then ''Termination''
            when ''4'' then ''Not Appropriate''
            when ''5'' then ''Not Assessed''
            when ''6'' then ''Other'' 
            else null
       end
      ,max(s.SchoolPerformance)
      ,max(s.HomePerformance)
      ,max(s.CommunityPerformance)
      ,max(s.BehaviorTowardsOther)
      ,max(s.MoodsEmotion)
      ,max(s.SelfHarmfulBehavior)
      ,max(s.SubstanceUse)
      ,max(s.Thinkng)
      ,max(s.PrimaryFamilyMaterialNeeds)
      ,max(s.PrimaryFamilySocialSupport)
      ,max(s.NonCustodialMaterialNeeds)
      ,max(s.NonCustodialSocialSupport)
      ,max(s.SurrogateMaterialNeeds)
      ,max(s.SurrogateSocialSupport)
  from Documents d
       join CustomHRMAssessments s on s.DocumentVersionId = d.CurrentDocumentVersionId
       join CustomRDWExtractClients c on c.ClientId = d.ClientId
       join CustomRDWExtractClientEpisodes ce on ce.ClientId = c.ClientId and ce.EpisodeNumber = c.EpisodeNumber
       left join GlobalCodes gci on gci.Category = ''XCAFASINTERVAL'' and gci.GlobalCodeId = s.CAFASInterval
 where d.Status = 22
   and d.EffectiveDate < dateadd(dd, 1, convert(char(10), getdate(), 101))
   and isnull(d.RecordDeleted, ''N'') = ''N''
   and isnull(s.RecordDeleted, ''N'') = ''N''
   and (isnull(s.CAFASInterval, 0) <> 0 or
        isnull(s.SchoolPerformance, 0) <> 0 or
        isnull(s.HomePerformance, 0) <> 0 or
        isnull(s.CommunityPerformance, 0) <> 0 or
        isnull(s.BehaviorTowardsOther, 0) <> 0 or
        isnull(s.MoodsEmotion, 0) <> 0 or
        isnull(s.SelfHarmfulBehavior, 0) <> 0 or
        isnull(s.SubstanceUse, 0) <> 0 or
        isnull(s.Thinkng, 0) <> 0 or
        isnull(s.PrimaryFamilyMaterialNeeds, 0) <> 0 or
        isnull(s.PrimaryFamilySocialSupport, 0) <> 0 or
        isnull(s.NonCustodialMaterialNeeds, 0) <> 0 or
        isnull(s.NonCustodialSocialSupport, 0) <> 0 or
        isnull(s.SurrogateMaterialNeeds, 0) <> 0 or
        isnull(s.SurrogateSocialSupport, 0) <> 0)
    and not exists(select 1
                     from CustomRDWExtractCAFASScores s2
                    where s2.ClientId = c.ClientId
                      and s2.EffectiveDate = d.EffectiveDate
                      and isnull(s2.CAFASIntervalCode, '''') = isnull(gci.ExternalCode1, '''')
                      and isnull(s2.SchoolPerformance, 0) = isnull(s.SchoolPerformance, 0)
                      and isnull(s2.HomePerformance, 0) = isnull(s.HomePerformance, 0)
                      and isnull(s2.CommunityPerformance, 0) = isnull(s.CommunityPerformance, 0)
                      and isnull(s2.BehaviorTowardsOther, 0) = isnull(s.BehaviorTowardsOther, 0)
                      and isnull(s2.MoodsEmotion, 0) = isnull(s.MoodsEmotion, 0)
                      and isnull(s2.SelfHarmfulBehavior, 0) = isnull(s.SelfHarmfulBehavior, 0)
                      and isnull(s2.SubstanceUse, 0) = isnull(s.SubstanceUse, 0)
                      and isnull(s2.Thinkng, 0) = isnull(s.Thinkng, 0)
                      and isnull(s2.PrimaryFamilyMaterialNeeds, 0) = isnull(s.PrimaryFamilyMaterialNeeds, 0)
                      and isnull(s2.PrimaryFamilySocialSupport, 0) = isnull(s.PrimaryFamilySocialSupport, 0)
                      and isnull(s2.NonCustodialMaterialNeeds, 0) = isnull(s.NonCustodialMaterialNeeds, 0)
                      and isnull(s2.NonCustodialSocialSupport, 0) = isnull(s.NonCustodialSocialSupport, 0)
                      and isnull(s2.SurrogateMaterialNeeds, 0) = isnull(s.SurrogateMaterialNeeds, 0)
                      and isnull(s2.SurrogateSocialSupport, 0) = isnull(s.SurrogateSocialSupport, 0))
 group by c.AffiliateId,
          c.ClientId,
          d.DocumentId

if @@error <> 0 goto error

return

error:

exec csp_RDWExtractError @AffiliateId = @AffiliateId, @ErrorText = ''Failed to execute csp_RDWExtractCAFASScores''
' 
END
GO
