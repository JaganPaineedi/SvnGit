/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDocumentMedicationManagementNoteSubReportMeds]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentMedicationManagementNoteSubReportMeds]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocumentMedicationManagementNoteSubReportMeds]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentMedicationManagementNoteSubReportMeds]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_RDLCustomDocumentMedicationManagementNoteSubReportMeds]
	@DocumentVersionId int
as

select Medication, SIG, Quantity, Refills, DaysSupply, PrescriptionDate, 
case when RefillExpirationDate < PrescriptionDate then null else RefillExpirationDate end as RefillExpirationDate
from dbo.CustomDocumentMedicationManagementNotePrescriptions
where DocumentVersionId = @DocumentVersionId
and ISNULL(RecordDeleted, ''N'') <> ''Y''
order by Medication

' 
END
GO
