/****** Object:  StoredProcedure [dbo].[csp_GetCustomDocumentClientServicesAgreement]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetCustomDocumentClientServicesAgreement]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetCustomDocumentClientServicesAgreement]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetCustomDocumentClientServicesAgreement]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_GetCustomDocumentClientServicesAgreement]
	@DocumentVersionId int
as

select DocumentVersionId,
CreatedBy,
CreatedDate,
ModifiedBy,
ModifiedDate,
RecordDeleted,
DeletedBy,
DeletedDate,
ClientName,
SignerName,
SignerSSN
from CustomDocumentClientServicesAgreement
where DocumentVersionId = @DocumentVersionId

' 
END
GO
