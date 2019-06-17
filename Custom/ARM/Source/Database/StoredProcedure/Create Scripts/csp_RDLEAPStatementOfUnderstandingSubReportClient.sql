/****** Object:  StoredProcedure [dbo].[csp_RDLEAPStatementOfUnderstandingSubReportClient]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLEAPStatementOfUnderstandingSubReportClient]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLEAPStatementOfUnderstandingSubReportClient]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLEAPStatementOfUnderstandingSubReportClient]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_RDLEAPStatementOfUnderstandingSubReportClient]
	@DocumentVersionId int,
	@ClientName varchar(100),
	@SignerName varchar(100)
as

--
-- get the first non-staff signature
--
select top 1 a.*, ds.PhysicalSignature, ds.SignatureDate
from (
	select @ClientName as ClientName, @SignerName as SignerName
) as a
cross join dbo.DocumentSignatures as ds
join dbo.Documents as d on d.DocumentId = ds.DocumentId
join dbo.DocumentVersions as dv on dv.DocumentId = d.DocumentId
where dv.DocumentVersionId = @DocumentVersionId
and ISNULL(ds.RecordDeleted, ''N'') <> ''Y''
and ds.StaffId is null
and ds.SignatureDate is not null
order by SignatureOrder

' 
END
GO
