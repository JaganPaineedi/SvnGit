/****** Object:  StoredProcedure [dbo].[csp_ReportClientEpisodes]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportClientEpisodes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportClientEpisodes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportClientEpisodes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_ReportClientEpisodes]
	@ClientId int
as

select  c.LastName + '', '' + c.FirstName as ClientName,
		ce.AssessmentDate,
        ce.ClientId,
        ce.EpisodeNumber,
        ce.RegistrationDate,
        ce.DischargeDate,
        ce.InitialRequestDate,
        gcStatus.CodeName as EpisodeStatus,
        gcRefSubType.GlobalCodeId as ReferralSubtype,
        gcRefType.CodeName as ReferralType,
        gcRefSource.GlobalCodeId as ReferralSource,
        ce.RegistrationComment,
        ce.TxStartDate
from dbo.ClientEpisodes as ce
join dbo.Clients as c on c.ClientId = ce.ClientId
LEFT join dbo.GlobalCodes as gcStatus on gcStatus.GlobalCodeId = ce.Status
LEFT join dbo.GlobalCodes as gcRefType on gcRefType.GlobalCodeId = ce.ReferralType
LEFT join dbo.GlobalCodes as gcRefSubType on gcRefSubType.GlobalCodeId = ce.ReferralSubtype
LEFT join dbo.GlobalCodes as gcRefSource on gcRefSource.GlobalCodeId = ce.ReferralSource
where ce.ClientId = @ClientId
and ISNULL(ce.RecordDeleted, ''N'') <> ''Y''

' 
END
GO
