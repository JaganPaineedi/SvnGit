/****** Object:  StoredProcedure [dbo].[csp_JobDeleteUnsavedChangesClientReleases]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_JobDeleteUnsavedChangesClientReleases]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_JobDeleteUnsavedChangesClientReleases]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_JobDeleteUnsavedChangesClientReleases]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_JobDeleteUnsavedChangesClientReleases]
as

--
--Delete Unsaved Changes records for Client Release Info that was created in PM (ScreenId = 38)
--

BEGIN TRAN

	DELETE u 
	FROM UnsavedChanges u
	WHERE ScreenId in (38)

COMMIT
' 
END
GO
