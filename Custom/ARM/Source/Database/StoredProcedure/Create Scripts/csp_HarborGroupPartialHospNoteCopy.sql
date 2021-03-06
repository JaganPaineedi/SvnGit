/****** Object:  StoredProcedure [dbo].[csp_HarborGroupPartialHospNoteCopy]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_HarborGroupPartialHospNoteCopy]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_HarborGroupPartialHospNoteCopy]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_HarborGroupPartialHospNoteCopy]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

create procedure [dbo].[csp_HarborGroupPartialHospNoteCopy]
-- =============================================
-- Author:		Tom Remisoski
-- Create date: Jan 25, 2012
-- Description:	Copy client docs from clinician doc
-- =============================================
      @GroupServiceId INT ,
      @StaffId INT   
as 
begin try
begin tran

update n set
	DeterminationOfNeededInterventions = grp.DeterminationOfNeededInterventions,
	SkillsDevelopment = grp.SkillsDevelopment,
	DevelopmentCopingMechanisms = grp.DevelopmentCopingMechanisms,
	ManagingSymptomsEnhanceOpportunities = grp.ManagingSymptomsEnhanceOpportunities,
	ProblemSolvingConflictResolutionManagement = grp.ProblemSolvingConflictResolutionManagement,
	DevelopmentInterpersonalSocialCompetency = grp.DevelopmentInterpersonalSocialCompetency,
	PsychoeducationTrainingAssessedNeeds = grp.PsychoeducationTrainingAssessedNeeds,
	OtherIntervention = grp.OtherIntervention,
	OtherInterventionComment = grp.OtherInterventionComment,
	NarrativeDescription = grp.NarrativeDescription
FROM    Documents D
JOIN dbo.CustomDocumentPartialHospitalNotes n on n.DocumentVersionId = D.CurrentDocumentVersionId
join (
	select
		d.GroupServiceId,
		c.DeterminationOfNeededInterventions,
		c.SkillsDevelopment,
		c.DevelopmentCopingMechanisms,
		c.ManagingSymptomsEnhanceOpportunities,
		c.ProblemSolvingConflictResolutionManagement,
		c.DevelopmentInterpersonalSocialCompetency,
		c.PsychoeducationTrainingAssessedNeeds,
		c.OtherIntervention,
		c.OtherInterventionComment,
		c.NarrativeDescription
	from Documents D
	join CustomDocumentPartialHospitalNotes c ON c.DocumentVersionId = D.CurrentDocumentVersionId
	where d.GroupServiceId = @GroupServiceId
	AND d.ClientId IS NULL
) as grp on grp.GroupServiceId = D.GroupServiceId
where D.GroupServiceId = @GroupServiceId
and D.ClientId is not null
and d.AuthorId = @StaffId
and d.Status <> 22

commit tran

end try
begin catch
if @@TRANCOUNT > 0 rollback tran
declare @error_message nvarchar(4000)
set @error_message = ERROR_MESSAGE()
raiserror (@error_message, 16, 1)
end catch

' 
END
GO
