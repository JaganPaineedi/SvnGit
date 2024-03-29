/****** Object:  StoredProcedure [dbo].[csp_RDWExtractHospitalizations]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDWExtractHospitalizations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDWExtractHospitalizations]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDWExtractHospitalizations]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE  procedure [dbo].[csp_RDWExtractHospitalizations]
@AffiliateId int
as

set nocount on
set ansi_warnings off

delete from CustomRDWExtractHospitalizations

if @@error <> 0 goto error

insert into CustomRDWExtractHospitalizations (
       AffiliateId,
       HospitalizationId,
       ClientId,
       EpisodeNumber,
       PreScreenDate,
       Provider,
       ThreeHourDisposition,
       Hospitalized,
       Hospital,
       AdmitDate,
       DischargedDate,
       SevenDayFollowUp,
       SevenDayFollowUpException,
       SevenDayFollowUpExceptionReason,
       DxCriteriaMet,
       CancellationOrNoShow,
       ClientRefusedService,
       Comment)
select @AffiliateId,
       h.HospitalizationId,
       h.ClientId,
       isnull(c.CurrentEpisodeNumber, 1),
       h.PreScreenDate,
       h.PerformedBy,
       h.ThreeHourDisposition,
       h.Hospitalized,
       p.ProviderName,
       h.AdmitDate,
       h.DischargeDate,
       h.SevenDayFollowUp,
       h.FollowUpException,
       h.FollowUpExceptionReason,
       h.DxCriteriaMet,
       h.CancellationOrNoShow,
       h.ClientRefusedService,
       h.Comment
  from Clients c
       join ClientHospitalizations h on h.ClientId = c.ClientId
       left join Sites s on s.SiteId = h.Hospital
       left join Providers p on p.ProviderId = s.ProviderId
 where isnull(h.RecordDeleted, ''N'') = ''N''
   and exists(select * 
                 from CustomRDWExtractClients ec
                   where ec.ClientId = c.ClientId)



if @@error <> 0 goto error

-- Set episode number
update h
   set EpisodeNumber = c.EpisodeNumber
  from CustomRDWExtractHospitalizations h
       join CustomRDWExtractClients c on c.ClientId = h.ClientId and
                                         c.EpisodeOpenDate <= isnull(h.AdmitDate, h.PreScreenDate)
 where not exists(select *
                    from CustomRDWExtractClients c2
                   where c2.ClientId = h.ClientId
                     and c2.EpisodeOpenDate <= isnull(h.AdmitDate, h.PreScreenDate)
                     and c2.EpisodeNumber > c.EpisodeNumber)

if @@error <> 0 goto error
   
return

error:

exec csp_RDWExtractError @AffiliateId = @AffiliateId, @ErrorText = ''Failed to execute csp_RDWExtractHospitalizations''
' 
END
GO
