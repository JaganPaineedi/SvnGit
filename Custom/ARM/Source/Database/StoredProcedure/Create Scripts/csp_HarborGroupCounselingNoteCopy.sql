  
Create procedure [dbo].[csp_HarborGroupCounselingNoteCopy]  
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
 TherapeuticInterventionType = grp.TherapeuticInterventionType,  
 PersonCenteredTherapy = grp.PersonCenteredTherapy,  
 BehavioralCognitiveTherapy = grp.BehavioralCognitiveTherapy,  
 RationalEmotiveTherapy = grp.RationalEmotiveTherapy,  
 TraumaFocusedCBT = grp.TraumaFocusedCBT,  
 InterpersonalSystemsTherapy = grp.InterpersonalSystemsTherapy,  
 PsychodynamicTherapy = grp.PsychodynamicTherapy,  
 MultimodalIntegrativePsychoTherapy = grp.MultimodalIntegrativePsychoTherapy,  
 SolutionFocusedTherapy = grp.SolutionFocusedTherapy,  
 ExpressiveTherapy = grp.ExpressiveTherapy,  
 RealityTherapy = grp.RealityTherapy,  
 Psychoeducation = grp.Psychoeducation,  
 ParentChildTherapy = grp.ParentChildTherapy,  
 HypnoTherapy = grp.HypnoTherapy,  
 FunctionalBehavioralAnalysis = grp.FunctionalBehavioralAnalysis,  
 NarrativeTherapy = grp.NarrativeTherapy,  
 OtherIntervention = grp.OtherIntervention,  
 OtherInterventionComment = grp.OtherInterventionComment,  
 NarrativeDescription = grp.NarrativeDescription  
FROM    Documents D  
JOIN Services S on s.GroupServiceId = @GroupServiceId and D.ServiceId = S.ServiceId
JOIN CustomDocumentCounselingNotes n on n.DocumentVersionId = D.CurrentDocumentVersionId  
join (  
 select  
  d.GroupServiceId,  
  c.TherapeuticInterventionType,  
  c.PersonCenteredTherapy,  
  c.BehavioralCognitiveTherapy,  
  c.RationalEmotiveTherapy,  
  c.TraumaFocusedCBT,  
  c.InterpersonalSystemsTherapy,  
  c.PsychodynamicTherapy,  
  c.MultimodalIntegrativePsychoTherapy,  
  c.SolutionFocusedTherapy,  
  c.ExpressiveTherapy,  
  c.RealityTherapy,  
  c.Psychoeducation,  
  c.ParentChildTherapy,  
  c.HypnoTherapy,  
  c.FunctionalBehavioralAnalysis,  
  c.NarrativeTherapy,  
  c.OtherIntervention,  
  c.OtherInterventionComment,  
  c.NarrativeDescription  
 from Documents D  
 join CustomDocumentCounselingNotes c ON c.DocumentVersionId = D.CurrentDocumentVersionId  
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
  