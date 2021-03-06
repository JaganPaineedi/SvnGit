/****** Object:  StoredProcedure [dbo].[csp_InitCustomDocumentMedicaidHealthHomeServiceActivities]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDocumentMedicaidHealthHomeServiceActivities]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomDocumentMedicaidHealthHomeServiceActivities]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDocumentMedicaidHealthHomeServiceActivities]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_InitCustomDocumentMedicaidHealthHomeServiceActivities]
	@ClientID int,          
	@StaffID int,        
	@CustomParameters xml
as

-- Minimum columns needed for a custom document

select
PlaceHolder.TableName,
PlaceHolder.DocumentVersionId, 
d.CreatedBy,
d.CreatedDate,
d.ModifiedBy,
d.ModifiedDate,
d.RecordDeleted,
d.DeletedBy,
d.DeletedDate,
d.IdentificationOfEligibility,
d.InitiatedOutreache,
d.ProvidedServiceOrientation,
d.ReviewedPatientHealthProfiles,
d.AssistanceObtainingHealthcare,
d.ProvisionOfHealthEducation,
d.CoordinationWithProviders,
d.SupportRelationshipProviders,
d.ReferralCommunitySupports,
d.Narrative
from (
	select ''CustomDocumentMedicaidHealthHomeServiceActivities'' as TableName,
	-1 as DocumentVersionId
) as PlaceHolder
LEFT outer join CustomDocumentMedicaidHealthHomeServiceActivities as d on d.DocumentVersionId = PlaceHolder.DocumentVersionId


' 
END
GO
