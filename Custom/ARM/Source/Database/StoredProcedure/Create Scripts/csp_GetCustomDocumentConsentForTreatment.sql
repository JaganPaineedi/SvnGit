/****** Object:  StoredProcedure [dbo].[csp_GetCustomDocumentConsentForTreatment]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetCustomDocumentConsentForTreatment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetCustomDocumentConsentForTreatment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetCustomDocumentConsentForTreatment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_GetCustomDocumentConsentForTreatment]
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
ConsentType,
ClientName,
SignerName
from CustomDocumentConsentForTreatment
where DocumentVersionId = @DocumentVersionId

' 
END
GO
