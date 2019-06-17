/****** Object:  StoredProcedure [dbo].[csp_ReportInitialIntakeSummary]    Script Date: 04/18/2013 10:24:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportInitialIntakeSummary]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportInitialIntakeSummary]
GO

/****** Object:  StoredProcedure [dbo].[csp_ReportInitialIntakeSummary]    Script Date: 04/18/2013 10:24:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE   PROCEDURE [dbo].[csp_ReportInitialIntakeSummary]
@ClientId	int

AS

SELECT 	ce.ReferralComment, ce.ClientId, ce.EpisodeNumber, c.LastName + ', ' + c.FirstName AS ClientName
FROM ClientEpisodes ce
JOIN Clients c ON ce.ClientId = c.ClientId
WHERE ce.ClientId = @ClientId 

AND NOT EXISTS (SELECT * FROM ClientEpisodes ce2 
		WHERE ce.ClientId = ce2.ClientId 
		AND ce.EpisodeNumber < ce2.EpisodeNumber)






GO

