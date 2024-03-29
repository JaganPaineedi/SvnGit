/****** Object:  StoredProcedure [dbo].[csp_ReportJobDeveloperCoachNoteImported]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportJobDeveloperCoachNoteImported]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportJobDeveloperCoachNoteImported]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportJobDeveloperCoachNoteImported]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_ReportJobDeveloperCoachNoteImported]
	@DocumentVersionId int
as

select PatientName as ClientName,
StaffName as ClinicianName,
NoteDate as DateOfService,
ProcedureDescription as ProcedureName,
AuthorizationNumber as AuthNum,
HoursAuthorized,
HoursBilled,
ReferralSource,
ActivityNote,
Doc.ClientId
from CustomDocumentJobDeveloperCoachNotes as d
join dbo.DocumentVersions as dv on dv.DocumentVersionId = d.DocumentVersionId
join dbo.Documents as doc on doc.DocumentId = dv.DocumentId
where d.DocumentVersionId = @DocumentVersionid

' 
END
GO
