/****** Object:  StoredProcedure [dbo].[csp_UpdateReportHistory]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_UpdateReportHistory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_UpdateReportHistory]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_UpdateReportHistory]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--	SCRIPT CREATED BY JESS 9/21/11
--	PURPOSE: To track the history of the running of custom reports.  This sp should be called by every custom report we write.

--/*
CREATE	PROCEDURE [dbo].[csp_UpdateReportHistory]
	@ReportId	int
AS
--*/

BEGIN TRAN

IF	(SELECT ReportId FROM ReportHistory WHERE ReportId = @ReportId) IS NOT NULL
BEGIN
	UPDATE	ReportHistory
	SET		LastRunBy10 = LastRunBy09,
			LastRunDate10 = LastRunDate09,
			LastRunBy09 = LastRunBy08,
			LastRunDate09 = LastRunDate08,
			LastRunBy08 = LastRunBy07,
			LastRunDate08 = LastRunDate07,
			LastRunBy07 = LastRunBy06,
			LastRunDate07 = LastRunDate06,
			LastRunBy06 = LastRunBy05,
			LastRunDate06 = LastRunDate05,
			LastRunBy05 = LastRunBy04,
			LastRunDate05 = LastRunDate04,
			LastRunBy04 = LastRunBy03,
			LastRunDate04 = LastRunDate03,
			LastRunBy03 = LastRunBy02,
			LastRunDate03 = LastRunDate02,
			LastRunBy02 = LastRunBy01,
			LastRunDate02 = LastRunDate01
	WHERE	ReportId = @ReportId
END

ELSE
BEGIN
	INSERT	INTO	ReportHistory (ReportId)
	SELECT	@ReportId
END

COMMIT TRAN
' 
END
GO
