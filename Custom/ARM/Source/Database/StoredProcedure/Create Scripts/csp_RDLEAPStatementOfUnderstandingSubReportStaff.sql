/****** Object:  StoredProcedure [dbo].[csp_RDLEAPStatementOfUnderstandingSubReportStaff]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLEAPStatementOfUnderstandingSubReportStaff]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLEAPStatementOfUnderstandingSubReportStaff]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLEAPStatementOfUnderstandingSubReportStaff]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_RDLEAPStatementOfUnderstandingSubReportStaff]
	@DocumentVersionId int
as

--
-- get the second staff signature (Intake person is 1st, EAP provider is 2nd)
--
select ds.PhysicalSignature, ds.SignatureDate, ds.SignerName
from dbo.DocumentSignatures as ds
join dbo.Documents as d on d.DocumentId = ds.DocumentId
join dbo.DocumentVersions as dv on dv.DocumentId = d.DocumentId
where dv.DocumentVersionId = @DocumentVersionId
and ISNULL(ds.RecordDeleted, ''N'') <> ''Y''
and ds.StaffId is not null
and ds.SignatureDate is not null
and ds.SignatureOrder <> 1
order by SignatureOrder

' 
END
GO
