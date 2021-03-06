/****** Object:  StoredProcedure [dbo].[csp_RDLHarborMissingDocumentVersionView]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLHarborMissingDocumentVersionView]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLHarborMissingDocumentVersionView]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLHarborMissingDocumentVersionView]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_RDLHarborMissingDocumentVersionView]
	@DocumentVersionId int
as
	select dc.DocumentName, gcStatus.CodeName as DocumentStatus, s.LastName + '', '' + s.FirstName as AuthorName, d.EffectiveDate, c.LastName + '', '' + c.FirstName as ClientName
	from dbo.DocumentVersions as dv
	join dbo.Documents as d on d.DocumentId = dv.DocumentId
	join dbo.DocumentCodes as dc on dc.DocumentCodeId = d.DocumentCodeId
	join dbo.Staff as s on s.StaffId = d.AuthorId
	join dbo.Clients as c on c.ClientId = d.ClientId
	LEFT join dbo.GlobalCodes as gcStatus on gcStatus.GlobalCodeId = d.Status
	where dv.DocumentVersionId = @DocumentVersionid


' 
END
GO
