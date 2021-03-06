/****** Object:  StoredProcedure [dbo].[csp_JobUpdateVocationalNotesWithMissingAuthNum]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_JobUpdateVocationalNotesWithMissingAuthNum]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_JobUpdateVocationalNotesWithMissingAuthNum]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_JobUpdateVocationalNotesWithMissingAuthNum]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_JobUpdateVocationalNotesWithMissingAuthNum]

AS 

/*
08.28.2012	avoss	created	
*/

UPDATE a 
	SET AuthNum=at.AuthorizationNumber 
FROM CustomDocumentJobDeveloperCoachNote a 
JOIN dbo.Documents d ON d.CurrentDocumentVersionId = a.DocumentVersionId
JOIN dbo.Services s ON s.ServiceId = d.ServiceId
JOIN dbo.ServiceAuthorizations sa ON sa.ServiceId=s.ServiceId
JOIN dbo.Authorizations at ON at.AuthorizationId = sa.AuthorizationId
WHERE d.Status = 22
AND ISNULL(a.AuthNum,'''')= ''''' 
END
GO
