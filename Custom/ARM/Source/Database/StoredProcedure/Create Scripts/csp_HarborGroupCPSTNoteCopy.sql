  
  
ALTER procedure [dbo].[csp_HarborGroupCPSTNoteCopy]  
-- =============================================  
-- Author:  Tom Remisoski  
-- Create date: Jan 25, 2012  
-- Description: Copy client docs from clinician doc  
-- =============================================  
      @GroupServiceId INT ,  
      @StaffId INT     
as   
begin try  
begin tran  
  
update n set  
 OngoingAssessmentNeeds = grp.OngoingAssessmentNeeds,  
 CoordinationISP = grp.CoordinationISP,  
 SymptomMonitoring = grp.SymptomMonitoring,  
 EducationSpecificAssessedNeeds = grp.EducationSpecificAssessedNeeds,  
 AdvocacyOutreach = grp.AdvocacyOutreach,  
 FacilitateDevelopmentDailyLivingSkills = grp.FacilitateDevelopmentDailyLivingSkills,  
 AssistAchievingIndependence = grp.AssistAchievingIndependence,  
 AssistAccessingNaturalSupports = grp.AssistAccessingNaturalSupports,  
 LinkageCommunitySupportSystems = grp.LinkageCommunitySupportSystems,  
 CoordinationCrisisManagement = grp.CoordinationCrisisManagement,  
 ActivitiesIncreaseImpactEnvironment = grp.ActivitiesIncreaseImpactEnvironment,  
 MHInterventionBarriersEducationEmployment = grp.MHInterventionBarriersEducationEmployment,  
 NarrativeDescription = grp.NarrativeDescription  
FROM    Documents D  
JOIN Services S on s.GroupServiceId = @GroupServiceId and D.ServiceId = S.ServiceId
JOIN dbo.CustomDocumentCPSTNotes n on n.DocumentVersionId = D.CurrentDocumentVersionId  
join (  
 select  
  d.GroupServiceId,  
  c.OngoingAssessmentNeeds,  
  c.CoordinationISP,  
  c.SymptomMonitoring,  
  c.EducationSpecificAssessedNeeds,  
  c.AdvocacyOutreach,  
  c.FacilitateDevelopmentDailyLivingSkills,  
  c.AssistAchievingIndependence,  
  c.AssistAccessingNaturalSupports,  
  c.LinkageCommunitySupportSystems,  
  c.CoordinationCrisisManagement,  
  c.ActivitiesIncreaseImpactEnvironment,  
  c.MHInterventionBarriersEducationEmployment,  
  c.NarrativeDescription  
 from Documents D  
 join CustomDocumentCPSTNotes c ON c.DocumentVersionId = D.CurrentDocumentVersionId  
 where d.GroupServiceId = @GroupServiceId  
 AND d.ClientId IS NULL  
) as grp on grp.GroupServiceId = S.GroupServiceId  
where D.ClientId is not null  
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
  