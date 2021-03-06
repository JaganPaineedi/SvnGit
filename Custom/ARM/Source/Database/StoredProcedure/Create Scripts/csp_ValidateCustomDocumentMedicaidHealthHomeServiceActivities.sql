/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomDocumentMedicaidHealthHomeServiceActivities]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentMedicaidHealthHomeServiceActivities]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomDocumentMedicaidHealthHomeServiceActivities]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentMedicaidHealthHomeServiceActivities]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_ValidateCustomDocumentMedicaidHealthHomeServiceActivities]
	@DocumentVersionId int
as


insert into #ValidationReturnTable (
	TableName,  
	ColumnName,  
	ErrorMessage,  
	TabOrder,  
	ValidationOrder  
)
SELECT ''CustomDocumentMedicaidHealthHomeServiceActivities'', ''DeletedBy'', ''Note - at least one activity selection is required.'',1 ,1
from dbo.CustomDocumentMedicaidHealthHomeServiceActivities
where DocumentVersionId = @DocumentVersionId
and isnull(IdentificationOfEligibility, ''N'') <> ''Y''
and isnull(InitiatedOutreache, ''N'') <> ''Y''
and isnull(ProvidedServiceOrientation, ''N'') <> ''Y''
and isnull(ReviewedPatientHealthProfiles, ''N'') <> ''Y''
and isnull(AssistanceObtainingHealthcare, ''N'') <> ''Y''
and isnull(ProvisionOfHealthEducation, ''N'') <> ''Y''
and isnull(CoordinationWithProviders, ''N'') <> ''Y''
and isnull(SupportRelationshipProviders, ''N'') <> ''Y''
and isnull(ReferralCommunitySupports, ''N'') <> ''Y''

' 
END
GO
