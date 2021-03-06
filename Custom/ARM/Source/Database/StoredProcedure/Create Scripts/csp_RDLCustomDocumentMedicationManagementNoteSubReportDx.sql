/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDocumentMedicationManagementNoteSubReportDx]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentMedicationManagementNoteSubReportDx]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocumentMedicationManagementNoteSubReportDx]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentMedicationManagementNoteSubReportDx]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_RDLCustomDocumentMedicationManagementNoteSubReportDx]
	@DocumentVersionId int
as

declare @results table (
	GAF  int,
	EffectiveDate datetime,
	Axis int,
	DSMCode varchar(10),
	DSMDescription varchar(2000),
	RuleOut char(1),
	DiagnosisOrder int
)

declare @DiagnosisDocumentVersionId int
select @DiagnosisDocumentVersionId = DiagnosisDocumentVersionId
from CustomDocumentMedicationManagementNotes
where DocumentVersionId = @DocumentVersionId

insert into @results
        (
         EffectiveDate,
         Axis,
         DSMCode,
         DSMDescription,
         RuleOut,
         DiagnosisOrder
        )
select d.EffectiveDate, dx.Axis, dx.DSMCode, dsm.DSMDescription, dx.RuleOut, dx.DiagnosisOrder
from dbo.DiagnosesIAndII as dx
join dbo.DocumentVersions as dv on dv.DocumentVersionId = dx.DocumentVersionId
join dbo.Documents as d on d.DocumentId = dv.DocumentId
join dbo.DiagnosisDSMDescriptions as dsm on dsm.DSMCode = dx.DSMCode and dsm.DSMNumber = dx.DSMNumber
where dx.DocumentVersionId = @DiagnosisDocumentVersionId
and ISNULL(dx.RecordDeleted, ''N'') <> ''Y''

update r set
	GAF = dx.AxisV
from @results as r
cross join dbo.DiagnosesV as dx
where dx.DocumentVersionId = @DiagnosisDocumentVersionId
and ISNULL(dx.RecordDeleted, ''N'') <> ''Y''

select
         EffectiveDate,
         Axis,
         DSMCode,
         DSMDescription,
         RuleOut,
         DiagnosisOrder
from @results
order by DiagnosisOrder, DSMCode

' 
END
GO
