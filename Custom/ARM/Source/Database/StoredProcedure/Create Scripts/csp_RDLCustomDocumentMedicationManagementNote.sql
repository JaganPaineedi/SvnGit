/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDocumentMedicationManagementNote]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentMedicationManagementNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocumentMedicationManagementNote]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentMedicationManagementNote]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

create procedure [dbo].[csp_RDLCustomDocumentMedicationManagementNote]
	@DocumentVersionId int
as

select LTRIM(RTRIM(c.FirstName)) + '' '' + LTRIM(RTRIM(c.LastName)) as ClientName,
c.ClientId,
d.EffectiveDate,
s.FirstName + '' '' + s.LastName as Author,
m.ClientIdentification,
m.ClinicalStatus,
m.ChangesResponse,
m.MentalStatusExam,
m.MedicationEducation,
m.TreatmentRecommendations,
m.Allergies,
m.GAFScore,
m.Comments,
sv.DateOfService as StartTime,
sv.Unit as Duration
from dbo.DocumentVersions as dv
join dbo.Documents as d on d.DocumentId = dv.DocumentId
join dbo.Clients as c on c.ClientId = d.ClientId
join dbo.CustomDocumentMedicationManagementNotes as m on m.DocumentVersionId = dv.DocumentVersionId
join dbo.Staff as s on s.StaffId = d.AuthorId
LEFT join dbo.Services as sv on sv.ClientId = d.ClientId and sv.ClinicianId = d.AuthorId and DATEDIFF(DAY, sv.DateOfService, d.EffectiveDate) = 0
	and not exists (
		select *
		from dbo.Services as sv2
		where sv2.ClientId = d.ClientId
		and sv2.ClinicianId = d.AuthorId
		and DATEDIFF(DAY, sv2.DateOfService, d.EffectiveDate) = 0
		and sv2.ServiceId > sv.ServiceId
	)
where dv.DocumentVersionId = @DocumentVersionId


' 
END
GO
