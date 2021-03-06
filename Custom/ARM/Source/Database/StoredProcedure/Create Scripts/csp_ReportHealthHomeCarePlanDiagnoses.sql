/****** Object:  StoredProcedure [dbo].[csp_ReportHealthHomeCarePlanDiagnoses]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportHealthHomeCarePlanDiagnoses]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportHealthHomeCarePlanDiagnoses]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportHealthHomeCarePlanDiagnoses]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

create procedure [dbo].[csp_ReportHealthHomeCarePlanDiagnoses]
	@DocumentVersionId int
as

select  oc.SequenceNumber,
        oc.ReportedDiagnosis,
        gc.CodeName as DiagnosisSource,
        oc.TreatmentProvider
from dbo.CustomDocumentHealthHomeCarePlanDiagnoses as oc
LEFT join dbo.GlobalCodes as gc on gc.GlobalCodeId = oc.DiagnosisSource
where oc.DocumentVersionId = @DocumentVersionId
and ISNULL(oc.RecordDeleted, ''N'') <> ''Y''
order by oc.SequenceNumber


' 
END
GO
