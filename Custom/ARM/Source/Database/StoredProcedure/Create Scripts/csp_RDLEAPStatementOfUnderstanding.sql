/****** Object:  StoredProcedure [dbo].[csp_RDLEAPStatementOfUnderstanding]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLEAPStatementOfUnderstanding]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLEAPStatementOfUnderstanding]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLEAPStatementOfUnderstanding]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_RDLEAPStatementOfUnderstanding]
	@DocumentVersionId int
as

select ct.ClientName, ct.SignerName, ct.EmployerRequiredAppt, ISNULL(c.FirstName, '''') + '' '' + ISNULL(c.LastName, '''') + '' '' + ''#'' + CAST(c.ClientId as varchar) as ClientHeader
from CustomDocumentEAPStatementOfUnderstanding as ct
join dbo.DocumentVersions as dv on dv.DocumentVersionId = ct.DocumentVersionId
join dbo.Documents as d on d.DocumentId = dv.DocumentId
join dbo.Clients as c on c.ClientId = d.ClientId
where ct.DocumentVersionId = @DocumentVersionId

' 
END
GO
