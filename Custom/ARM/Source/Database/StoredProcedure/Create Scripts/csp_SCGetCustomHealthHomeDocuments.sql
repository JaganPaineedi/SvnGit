/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomHealthHomeDocuments]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomHealthHomeDocuments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomHealthHomeDocuments]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomHealthHomeDocuments]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_SCGetCustomHealthHomeDocuments]
@DocumentVersionId INT
AS
BEGIN

 BEGIN TRY

SELECT     DocumentVersionId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedBy, DeletedDate, HealthHomeTeamMember1, HealthHomeTeamRole1, 
                      HealthHomeTeamMember2, HealthHomeTeamRole2, HealthHomeTeamMember3, HealthHomeTeamRole3, HealthHomeTeamMember4, HealthHomeTeamRole4, HealthHomeTeamMember5, HealthHomeTeamRole5, HealthHomeTeamMember6, 
                      HealthHomeTeamRole6, HealthHomeTeamMember7, HealthHomeTeamRole7, PrimaryCarePhysicianName, PrimaryCarePhysicianPhone, 
                      PrimaryCarePhysicianFax,DentistName, DentistPhone, DentistFax, LongTermCareFacility, LongTermCareFacilityNA, AODRehabFacility, 
                      AODRehabFacilityNA, PreferredHospital, PreferredPsychHospital, PreferredPsychHospitalNA, PreferredCMHProvider, SpecialCommentsRegardingProvider, 
                      MedicaidManagedCarePlan, MedicaidManagedCarePlanNA, LegalGuardian, ClientGuardianParticipatedInPlan
FROM         CustomDocumentHealthHomeCommPlans
WHERE     (ISNULL(RecordDeleted, ''N'') = ''N'') AND ([DocumentVersionId] = @DocumentVersionId)

SELECT     HealthHomeCommPlanProviderId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedBy, DeletedDate, DocumentVersionId, 
                      ProviderName,ProviderSpecialty, ProviderPhone, ProviderFax, ProviderSpecialty
FROM         CustomDocumentHealthHomeCommPlanProviders
WHERE     (ISNULL(RecordDeleted, ''N'') = ''N'') AND ([DocumentVersionId] = @DocumentVersionId)

SELECT     HealthHomeCommPlanFamilyMemberId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedBy, DeletedDate, 
                      DocumentVersionId, FamilyMemberName, FamilyMemberPhone
FROM         CustomDocumentHealthHomeCommPlanFamilyMembers
WHERE     (ISNULL(RecordDeleted, ''N'') = ''N'') AND ([DocumentVersionId] = @DocumentVersionId)

SELECT     HealthHomeCommPlanSocialSupportId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedBy, DeletedDate, 
                      DocumentVersionId, SupportName, PurposeOfCollaboration
FROM         CustomDocumentHealthHomeCommPlanSocialSupports
WHERE     (ISNULL(RecordDeleted, ''N'') = ''N'') AND ([DocumentVersionId] = @DocumentVersionId)

END TRY

BEGIN CATCH
 DECLARE @Error VARCHAR(8000)
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + ''*****'' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())
			+ ''*****'' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),''csp_SCGetCustomHealthHomeDocuments'')
			+ ''*****'' + CONVERT(VARCHAR,ERROR_LINE()) + ''*****'' + CONVERT(VARCHAR,ERROR_SEVERITY())
			+ ''*****'' + CONVERT(VARCHAR,ERROR_STATE())
		RAISERROR
		(
			@Error, -- Message text.
			16,		-- Severity.
			1		-- State.
		);
END CATCH
END

' 
END
GO
