/****** Object:  StoredProcedure [dbo].[csp_GetCustomDocumentMedicaidHealthHomeServiceActivities]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetCustomDocumentMedicaidHealthHomeServiceActivities]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetCustomDocumentMedicaidHealthHomeServiceActivities]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetCustomDocumentMedicaidHealthHomeServiceActivities]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_GetCustomDocumentMedicaidHealthHomeServiceActivities]
	@DocumentVersionId int
as

select
	DocumentVersionId,
	CreatedBy,
	CreatedDate,
	ModifiedBy,
	ModifiedDate,
	RecordDeleted,
	DeletedBy,
	DeletedDate,
	IdentificationOfEligibility,
	InitiatedOutreache,
	ProvidedServiceOrientation,
	ReviewedPatientHealthProfiles,
	AssistanceObtainingHealthcare,
	ProvisionOfHealthEducation,
	CoordinationWithProviders,
	SupportRelationshipProviders,
	ReferralCommunitySupports,
	Narrative
from dbo.CustomDocumentMedicaidHealthHomeServiceActivities
where DocumentVersionId = @DocumentVersionId

' 
END
GO
