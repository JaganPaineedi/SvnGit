/****** Object:  StoredProcedure [dbo].[csp_ReportHarborTreatmentPlanFromDA]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportHarborTreatmentPlanFromDA]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportHarborTreatmentPlanFromDA]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportHarborTreatmentPlanFromDA]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_ReportHarborTreatmentPlanFromDA]
-- Provides view format for Harbor legacy document
	@DocumentVersionId int
as

select
a.DocumentVersionId,
REPLICATE(''0'', 8 - LEN(CAST(d.ClientId as varchar))) + CAST(d.ClientId as varchar) as PatientId,
a.ClientName,
a.DOB,
a.AssessmentDate,
a.AssessmentTime,
a.ProcedureDuration,
a.StaffName,
a.PrimaryProblem,
a.Goal,
a.Objective,
a.IndivGroup,
a.CSPIndivGroup,
a.FrequencyOfServices,
a.ClientISPPart,
a.ClientISPPartComment 
from CustomDocumentTreatmentPlansFromDA as a
join dbo.DocumentVersions as dv on dv.DocumentVersionId = a.DocumentVersionId
join dbo.Documents as d on d.DocumentId = dv.DocumentId
where a.DocumentVersionId = @DocumentVersionId

' 
END
GO
