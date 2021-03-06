/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomDocumentDiagnosticAssessmentTransferServices]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentDiagnosticAssessmentTransferServices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomDocumentDiagnosticAssessmentTransferServices]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentDiagnosticAssessmentTransferServices]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_ValidateCustomDocumentDiagnosticAssessmentTransferServices]
	@DocumentVersionId int
/******************************************************************************                                      
**  File: csp_ValidateCustomDocumentDiagnosticAssessmentTransferServices                                  
**  Name: csp_ValidateCustomDocumentDiagnosticAssessmentTransferServices              
**  Desc: For Validation  on Referrals from diagnosistic assessment document
**  Return values: Resultset having validation messages                                      
**  Called by: csp_ValidateCustomDocumentDiagnosticAssessments                                      
**  Parameters:                  
**  Auth:  T. Remisoski                    
**  Date:  February 9, 2011                                  
*******************************************************************************                                      
**  Change History                                      
*******************************************************************************                                      
**  Date:       Author:       Description:                                      
**  --------    --------        ----------------------------------------------------                                      
** 2012.02.09	TER				Revised based on Harbor''s rules
*******************************************************************************/                                    
as
select * from dbo.CustomDocumentDiagnosticAssessments
Insert into #validationReturnTable (
	TableName,  
	ColumnName,  
	ErrorMessage,  
	TabOrder,  
	ValidationOrder  
)
select ''CustomDocumentAssessmentTransferServices'', ''DeletedBy'', ''Transfer Service: Client participation required'', 1, 1
from dbo.CustomDocumentDiagnosticAssessments as d
where d.DocumentVersionId = @DocumentVersionId
and ISNULL([TransferClientParticipated], ''N'') <> ''Y''
and exists (
	select *
	from dbo.CustomDocumentAssessmentTransferServices as ar
	where ar.DocumentVersionId = @DocumentVersionId
	and ISNULL(ar.RecordDeleted, ''N'') <> ''Y''
)
union
select ''CustomDocumentAssessmentTransferServices'', ''DeletedBy'', ''Transfer Service: Receiving staff required'', 1, 1
from dbo.CustomDocumentDiagnosticAssessments as d
where d.DocumentVersionId = @DocumentVersionId
and [TransferReceivingStaff] is null
and exists (
	select *
	from dbo.CustomDocumentAssessmentTransferServices as ar
	where ar.DocumentVersionId = @DocumentVersionId
	and ISNULL(ar.RecordDeleted, ''N'') <> ''Y''
)
union
select ''CustomDocumentAssessmentTransferServices'', ''DeletedBy'', ''Transfer Service: Assessed need for transfer required'', 1, 1
from dbo.CustomDocumentDiagnosticAssessments as d
where d.DocumentVersionId = @DocumentVersionId
and LEN(LTRIM(RTRIM(ISNULL([TransferAssessedNeed], '''')))) = 0
and exists (
	select *
	from dbo.CustomDocumentAssessmentTransferServices as ar
	where ar.DocumentVersionId = @DocumentVersionId
	and ISNULL(ar.RecordDeleted, ''N'') <> ''Y''
)
union
select ''CustomDocumentAssessmentTransferServices'', ''DeletedBy'', ''Primary clinician assignment (yes/no) must be selected when transferring.'', 1, 1
from dbo.CustomDocumentDiagnosticAssessments as d
where d.DocumentVersionId = @DocumentVersionId
and ISNULL(d.[PrimaryClinicianTransfer], ''N'') <> ''Y''
and exists (
	select *
	from dbo.CustomDocumentAssessmentTransferServices as ar
	where ar.DocumentVersionId = @DocumentVersionId
	and ISNULL(ar.RecordDeleted, ''N'') <> ''Y''
)

' 
END
GO
