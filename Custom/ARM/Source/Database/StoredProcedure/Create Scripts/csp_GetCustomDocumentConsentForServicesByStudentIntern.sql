/****** Object:  StoredProcedure [dbo].[csp_GetCustomDocumentConsentForServicesByStudentIntern]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetCustomDocumentConsentForServicesByStudentIntern]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetCustomDocumentConsentForServicesByStudentIntern]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetCustomDocumentConsentForServicesByStudentIntern]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_GetCustomDocumentConsentForServicesByStudentIntern]
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
SignerName,
StudentName,
SupervisorName
from CustomDocumentConsentForServicesByStudentIntern
where DocumentVersionId = @DocumentVersionId

' 
END
GO
