/****** Object:  StoredProcedure [dbo].[csp_SubReportVisitTicketAuthorizations]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SubReportVisitTicketAuthorizations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SubReportVisitTicketAuthorizations]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SubReportVisitTicketAuthorizations]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[csp_SubReportVisitTicketAuthorizations](
	@ServiceId int
)
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED ;

	SELECT
		a.AuthorizationNumber
	   ,a.StartDate
	   ,a.EndDate
	   ,a.UnitsScheduled
	   ,a.UnitsRequested
	   ,a.UnitsUsed
	FROM
		Services s
		LEFT JOIN ServiceAuthorizations sa ON sa.ServiceId = s.ServiceId
		LEFT JOIN Authorizations a ON a.AuthorizationId = sa.AuthorizationId
	WHERE
		s.ServiceId = @ServiceId
		AND ISNULL(sa.RecordDeleted, ''N'') = ''N''
		AND ISNULL(a.RecordDeleted, ''N'') = ''N''

END' 
END
GO
