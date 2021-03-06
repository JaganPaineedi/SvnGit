/****** Object:  StoredProcedure [dbo].[csp_RDWExtractClientCoverageHistory]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDWExtractClientCoverageHistory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDWExtractClientCoverageHistory]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDWExtractClientCoverageHistory]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_RDWExtractClientCoverageHistory]
@AffiliateId int
as

set nocount on
set ansi_warnings off

declare @StartDate datetime

select @StartDate = RDWStartDate
  from CustomRDWExtractSummary 
 where AffiliateId = @AffiliateId

-- Clean up
delete from dbo.CustomRDWExtractClientCoverageHistory

if @@error <> 0 goto error

insert into dbo.CustomRDWExtractClientCoverageHistory (
       AffiliateId,
       ClientId,
       EpisodeNumber,
       CoveragePlanId,
       CoveragePlanName,
       StartDate,
       EndDate,
       COBOrder,
       InsuredId,
       StartMonth,
       StartDay,
       IsCrossover,
       IsMedicaid)
select @AffiliateId,
       c.ClientId,
       c.EpisodeNUmber,
       cp.DisplayAs,
       cp.CoveragePlanName,
       cch.StartDate,
       cch.EndDate,
       cch.COBOrder,
       ccp.InsuredId,
       month(cch.StartDate),
       day(cch.StartDate),
       ''N'',
       isnull(cp.MedicaidPlan, ''N'')
  from CustomRDWExtractClients c
       join CustomRDWExtractClientEpisodes ce on ce.ClientId = c.ClientId and
                                                 ce.EpisodeNumber = c.EpisodeNumber
       join ClientCoveragePlans ccp on ccp.ClientId = c.ClientId
       join ClientCoverageHistory cch on cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId and
                                         cch.StartDate < ce.CloseDate and
                                         (cch.EndDate >= ce.OpenDate or cch.EndDate is null)

       join CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId
 where IsNull(cch.EndDate, @StartDate) >= @StartDate 
   and isnull(ccp.RecordDeleted, ''N'') = ''N''
   and isnull(cch.RecordDeleted, ''N'') = ''N''
   and not exists(select *
                    from ClientCoverageHistory cch2
                         join ClientCoveragePlans ccp2 on ccp2.ClientCoveragePlanId = cch2.ClientCoveragePlanId
                   where ccp2.ClientId = c.ClientId 
                     and cch2.StartDate = cch.StartDate
                     and cch2.COBOrder = cch.COBOrder
                     and IsNull(cch2.EndDate, @StartDate) >= @StartDate
                     and isnull(cch2.RecordDeleted, ''N'') = ''N''
                     and isnull(ccp2.RecordDeleted, ''N'') = ''N''
                     and cch2.ClientCoverageHistoryId > cch.ClientCoverageHistoryId) 

return

error:

exec csp_RDWExtractError @AffiliateId = @AffiliateId, @ErrorText = ''Failed to execute csp_RDWExtractClientCoverageHistory''
' 
END
GO
