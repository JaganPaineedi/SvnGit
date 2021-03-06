/****** Object:  StoredProcedure [dbo].[csp_RDWExtractHabWaiverEnrollments]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDWExtractHabWaiverEnrollments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDWExtractHabWaiverEnrollments]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDWExtractHabWaiverEnrollments]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_RDWExtractHabWaiverEnrollments]
@AffiliateId int
as

set nocount on
set ansi_warnings off

delete from CustomRDWExtractHabWaiverEnrollments

if @@error <> 0 goto error

insert into CustomRDWExtractHabWaiverEnrollments (
       AffiliateId,
       ClientId,
       EpisodeNumber,
       EnrolledDate,
       DischargedDate)
select @AffiliateId,
       c.ClientId,
       c.EpisodeNumber,
       cp.EnrolledDate,
       cp.DischargedDate
  from CustomRDWExtractClients c
       join CustomRDWExtractClientEpisodes ce on ce.ClientId = c.ClientId and
                                                 ce.EpisodeNumber = c.EpisodeNumber
       join ClientPrograms cp on cp.ClientId = c.ClientId and
                                 cp.EnrolledDate < ce.CloseDate and
                                 (cp.DischargedDate >= ce.OpenDate or cp.DischargedDate is null)
       join Programs p on p.ProgramId = cp.ProgramId
 where p.ProgramCode = ''Hab Waiver''
   and cp.Status in (4, 5) -- Enrolled, Discharged
   and isnull(cp.RecordDeleted, ''N'') = ''N''

if @@error <> 0 goto error

return

error:

exec csp_RDWExtractError @AffiliateId = @AffiliateId, @ErrorText = ''Failed to execute csp_RDWExtractHabWaiverEnrollments''
' 
END
GO
