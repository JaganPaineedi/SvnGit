;
with  CTE_Adjudication
        as (select  clh.ClaimLineId,
                    clh.AdjudicationId,
                    clh.ActivityDate,
                    row_number() over (partition by clh.ClaimLineId order by clh.ActivityDate desc, clh.AdjudicationId desc) as Ranking
            from    ClaimLineHistory clh
            where   clh.AdjudicationId is not null
                    and isnull(clh.RecordDeleted, 'N') = 'N')
  update  cl
  set     LastAdjudicationId = a.AdjudicationId,
          LastAdjudicationDate = a.ActivityDate
  from    ClaimLines cl
          join CTE_Adjudication a on a.ClaimLineId = cl.ClaimLineId
                                     and a.Ranking = 1
  where   isnull(cl.LastAdjudicationId, -1) <> a.AdjudicationId