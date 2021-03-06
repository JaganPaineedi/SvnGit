/****** Object:  StoredProcedure [dbo].[csp_UpdateDischargedClientsInformationNotComplete]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_UpdateDischargedClientsInformationNotComplete]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_UpdateDischargedClientsInformationNotComplete]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_UpdateDischargedClientsInformationNotComplete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_UpdateDischargedClientsInformationNotComplete]

AS

/*
Modified Date	Modified By		Reason
06.06.2012		avoss			Make sure dishcharged clients Financial Information is set to incomplete so when they are reopened services do not complete until coverage is verified

*/


UPDATE c 
	SET InformationComplete = ''N''
FROM Clients c 
JOIN dbo.ClientEpisodes ce ON ce.ClientId = c.ClientId AND ISNULL(ce.RecordDeleted,''N'') <> ''Y''
	AND ce.EpisodeNumber = c.CurrentEpisodeNumber 
	AND ce.Status = 102
WHERE ISNULL(c.RecordDeleted,''N'') <> ''Y''
AND ISNULL(c.InformationComplete,''N'') <> ''Y''



' 
END
GO
