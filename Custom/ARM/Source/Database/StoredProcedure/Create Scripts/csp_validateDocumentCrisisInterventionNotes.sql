/****** Object:  StoredProcedure [dbo].[csp_validateDocumentCrisisInterventionNotes]    Script Date: 06/19/2013 17:49:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateDocumentCrisisInterventionNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateDocumentCrisisInterventionNotes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateDocumentCrisisInterventionNotes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE   PROCEDURE [dbo].[csp_validateDocumentCrisisInterventionNotes]      
@DocumentVersionId Int    
  
as      



BEGIN

BEGIN TRY      
      
CREATE TABLE [#CustomDocumentCrisisInterventionNotes] (      
            DocumentVersionId int null,
            CrisisPlanTreatmentRecommended varchar(max) null,     
            WishesPreferencesOfIndividual varchar(max) null,      
            ReferredVoluntaryHospitalization char(1) null,      
            ReferredInvoluntaryHospitalization char(1) null,      
            ReferralHarborServicesType int null,      
            ReferralHarborServicesComment varchar(max) null,
            ReferralExternalServicesType  int null,
            ReferralExternalServicesComment varchar(max) null,
            FollowUpInstructions varchar(max) null,
            CrisisWasResolved char(1) null,
            PlanToAvoidCrisisRecurrence varchar(max) null,
            PresentingCrisisImmediateNeeds varchar(max) null,
            UseOfAlcholDrugsImpactingCrisis varchar(max) null,
            CrisisInThePast char(1) null,
            CrisisInThePastHowPreviouslyStabilized varchar(max) null,
            CrisisInThePastIssuesSinceStabilization varchar(max) null,
            PastAttemptsHarmNone char(1) null,
            PastAttemptsHarmSelf char(1) null,
            PastAttemptsHarmOthers char(1) null,
            PastAttemptsHarmComment varchar(max) null,
            CurrentRiskHarmSelf char(1) null,                    
            CurrentRiskHarmSelfComment varchar(max) null,
            CurrenRiskHarmOthers char(1) null,
            CurrentRiskHarmOthersComment varchar(max) null,
            MedicalConditionsImpactingCrisis varchar(max) null,
            ClientCurrentlyPrescribedMedications varchar(max) null,
            ClientComplyingWithMedications varchar(max) null,
            CurrentLivingSituationAndSupportSystems varchar(max) null,
            ClientStrengthsDealingWithCrisis varchar(max) null,
            CrisisDeEscalationInterventionsProvided varchar(max) null
            
)      
      
INSERT INTO [#CustomDocumentCrisisInterventionNotes](      
            DocumentVersionId,
            CrisisPlanTreatmentRecommended,    
            WishesPreferencesOfIndividual,      
            ReferredVoluntaryHospitalization,      
            ReferredInvoluntaryHospitalization,      
            ReferralHarborServicesType,      
            ReferralHarborServicesComment,
            ReferralExternalServicesType,
            ReferralExternalServicesComment, 
            FollowUpInstructions,
            CrisisWasResolved,
            PlanToAvoidCrisisRecurrence,
            PresentingCrisisImmediateNeeds,            
            UseOfAlcholDrugsImpactingCrisis,
            CrisisInThePast,
            CrisisInThePastHowPreviouslyStabilized,
            CrisisInThePastIssuesSinceStabilization,
            PastAttemptsHarmNone,
            PastAttemptsHarmSelf,
            PastAttemptsHarmOthers,
            PastAttemptsHarmComment,
            CurrentRiskHarmSelf,
            CurrentRiskHarmSelfComment,                
            CurrenRiskHarmOthers,                       
            CurrentRiskHarmOthersComment,
            MedicalConditionsImpactingCrisis,
            ClientCurrentlyPrescribedMedications,
            ClientComplyingWithMedications,
            CurrentLivingSituationAndSupportSystems,
            ClientStrengthsDealingWithCrisis,
            CrisisDeEscalationInterventionsProvided            
)      
select      
            a.DocumentVersionId,
            a.CrisisPlanTreatmentRecommended,    
            a.WishesPreferencesOfIndividual,      
            a.ReferredVoluntaryHospitalization,      
            a.ReferredInvoluntaryHospitalization,      
            a.ReferralHarborServicesType,      
            a.ReferralHarborServicesComment,
            a.ReferralExternalServicesType,
            a.ReferralExternalServicesComment, 
            a.FollowUpInstructions,
            a.CrisisWasResolved,
            a.PlanToAvoidCrisisRecurrence,
            a.PresentingCrisisImmediateNeeds,            
            a.UseOfAlcholDrugsImpactingCrisis,
            a.CrisisInThePast,
            a.CrisisInThePastHowPreviouslyStabilized,
            a.CrisisInThePastIssuesSinceStabilization,
            a.PastAttemptsHarmNone,
            a.PastAttemptsHarmSelf,
            a.PastAttemptsHarmOthers,
            a.PastAttemptsHarmComment,
            a.CurrentRiskHarmSelf,
            a.CurrentRiskHarmSelfComment,
            a.CurrenRiskHarmOthers,
            a.CurrentRiskHarmOthersComment,
            a.MedicalConditionsImpactingCrisis,
            a.ClientCurrentlyPrescribedMedications,
            a.ClientComplyingWithMedications,
            a.CurrentLivingSituationAndSupportSystems,
            a.ClientStrengthsDealingWithCrisis,
            a.CrisisDeEscalationInterventionsProvided                 
from CustomDocumentCrisisInterventionNotes a       
where a.DocumentVersionId = @DocumentVersionId and isnull(a.RecordDeleted,''N'')<>''Y''      


declare @Sex char(1), @Age int, @EffectiveDate datetime, @ClientId int, @DocumentCodeId int, @ServiceId int

select @Sex = isnull(c.Sex,''U''), @Age = dbo.GetAge(c.DOB,d.EffectiveDate), @EffectiveDate = d.EffectiveDate, @ClientId = d.ClientId, 
	@DocumentCodeId = d.DocumentCodeId, @ServiceId = d.ServiceId
from DocumentVersions dv
join Documents d on d.DocumentId = dv.DocumentId 
join Clients c on c.ClientId = d.ClientId
where dv.DocumentVersionId = @DocumentVersionId

declare @TabId int 
set @TabId = 1 

insert into #ValidationReturnTable (
	TableName,  
	ColumnName,  
	ErrorMessage,  
	TabOrder,  
	ValidationOrder  
)      


SELECT ''CustomDocumentCrisisInterventionNotes'', ''DeletedBy'', ''Crisis Assessment  - Presenting crisis immediate needs section is required'',@TabId ,1
FROM #CustomDocumentCrisisInterventionNotes
WHERE LEN(LTRIM(RTRIM(ISNULL(PresentingCrisisImmediateNeeds, '''')))) = 0

UNION
SELECT ''CustomDocumentCrisisInterventionNotes'', ''DeletedBy'', ''Crisis Assessment  - Use of alchol or drugs impacting crisis section is required'',@TabId ,1
FROM #CustomDocumentCrisisInterventionNotes
WHERE LEN(LTRIM(RTRIM(ISNULL(UseOfAlcholDrugsImpactingCrisis, '''')))) = 0

UNION
SELECT ''CustomDocumentCrisisInterventionNotes'', ''DeletedBy'', ''Crisis Assessment  - Crisis in the past selection is required'',@TabId ,2
FROM #CustomDocumentCrisisInterventionNotes
WHERE LEN(LTRIM(RTRIM(ISNULL(CrisisInThePast, '''')))) = 0

UNION
SELECT ''CustomDocumentCrisisInterventionNotes'', ''DeletedBy'', ''Crisis Assessment  - How was crisis in the past previously stabilized?'',@TabId ,3
FROM #CustomDocumentCrisisInterventionNotes
WHERE LEN(LTRIM(RTRIM(ISNULL(CrisisInThePastHowPreviouslyStabilized, '''')))) = 0
and isnull(CrisisInThePast, ''N'') = ''Y''

UNION
SELECT ''CustomDocumentCrisisInterventionNotes'', ''DeletedBy'', ''Crisis Assessment  - What issues occurred since the last stabilization, contributing to the cisis?'',@TabId ,4
FROM #CustomDocumentCrisisInterventionNotes
WHERE LEN(LTRIM(RTRIM(ISNULL(CrisisInThePastIssuesSinceStabilization, '''')))) = 0
and isnull(CrisisInThePast, ''N'') = ''Y''

UNION
SELECT ''CustomDocumentCrisisInterventionNotes'', ''DeletedBy'', ''Crisis Assessment  - Risk of Harm to Self/ Others past attempts selection is required'',@TabId ,5
FROM #CustomDocumentCrisisInterventionNotes
WHERE ISNULL(PastAttemptsHarmNone,''N'')=''N''
and ISNULL(PastAttemptsHarmSelf, ''N'')=''N''
and ISNULL(PastAttemptsHarmOthers,''N'')=''N''

UNION
SELECT ''CustomDocumentCrisisInterventionNotes'', ''DeletedBy'', ''Crisis Assessment  - Risk of Harm to Self/ Others past attempts comment is required'',@TabId ,6
FROM #CustomDocumentCrisisInterventionNotes
WHERE LEN(LTRIM(RTRIM(ISNULL(PastAttemptsHarmComment, '''')))) = 0
and ( ISNULL(PastAttemptsHarmSelf, ''N'')=''Y''
or ISNULL(PastAttemptsHarmOthers,''N'')=''T'' )

UNION
SELECT ''CustomDocumentCrisisInterventionNotes'', ''DeletedBy'', ''Crisis Assessment  - Risk of Harm to Self/ Others current risk to self selection is required'',@TabId ,7
FROM #CustomDocumentCrisisInterventionNotes
WHERE LEN(LTRIM(RTRIM(ISNULL(CurrentRiskHarmSelf, '''')))) = 0

UNION
SELECT ''CustomDocumentCrisisInterventionNotes'', ''DeletedBy'', ''Crisis Assessment  - Risk of Harm to Self/ Others current risk to self comment section is required'',@TabId ,8
FROM #CustomDocumentCrisisInterventionNotes
WHERE LEN(LTRIM(RTRIM(ISNULL(CurrentRiskHarmSelfComment, '''')))) = 0
and isnull(CurrentRiskHarmSelf,''N'')=''Y''

UNION
SELECT ''CustomDocumentCrisisInterventionNotes'', ''DeletedBy'', ''Crisis Assessment  - Risk of Harm to Self/ Others current risk to others selection is required'',@TabId ,9
FROM #CustomDocumentCrisisInterventionNotes
WHERE LEN(LTRIM(RTRIM(ISNULL(CurrenRiskHarmOthers, '''')))) = 0

UNION
SELECT ''CustomDocumentCrisisInterventionNotes'', ''DeletedBy'', ''Crisis Assessment  - Risk of Harm to Self/ Others current risk to others comment section is required'',@TabId ,10
FROM #CustomDocumentCrisisInterventionNotes
WHERE LEN(LTRIM(RTRIM(ISNULL(CurrentRiskHarmOthersComment, '''')))) = 0
and isnull(CurrenRiskHarmOthers,''N'')=''Y''


UNION
SELECT ''CustomDocumentCrisisInterventionNotes'', ''DeletedBy'', ''Crisis Assessment  - Medical conditions impacting crisis section is required'',@TabId ,11
FROM #CustomDocumentCrisisInterventionNotes
WHERE LEN(LTRIM(RTRIM(ISNULL(MedicalConditionsImpactingCrisis, '''')))) = 0

UNION
SELECT ''CustomDocumentCrisisInterventionNotes'', ''DeletedBy'', ''Crisis Assessment  - Is the client currently prescribed any medications?'',@TabId ,12
FROM #CustomDocumentCrisisInterventionNotes
WHERE LEN(LTRIM(RTRIM(ISNULL(ClientCurrentlyPrescribedMedications, '''')))) = 0

UNION
SELECT ''CustomDocumentCrisisInterventionNotes'', ''DeletedBy'', ''Crisis Assessment  - Is the client complying with medications?'',@TabId ,13
FROM #CustomDocumentCrisisInterventionNotes
WHERE LEN(LTRIM(RTRIM(ISNULL(ClientComplyingWithMedications, '''')))) = 0

UNION
SELECT ''CustomDocumentCrisisInterventionNotes'', ''DeletedBy'', ''Crisis Assessment  - Describe client''''s current living situation and natural support systems '',@TabId ,14
FROM #CustomDocumentCrisisInterventionNotes
WHERE LEN(LTRIM(RTRIM(ISNULL(CurrentLivingSituationAndSupportSystems, '''')))) = 0

UNION
SELECT ''CustomDocumentCrisisInterventionNotes'', ''DeletedBy'', ''Crisis Assessment  - What strengths will aid the client in dealing with the crisis? '',@TabId ,15
FROM #CustomDocumentCrisisInterventionNotes
WHERE LEN(LTRIM(RTRIM(ISNULL(ClientStrengthsDealingWithCrisis, '''')))) = 0

UNION
SELECT ''CustomDocumentCrisisInterventionNotes'', ''DeletedBy'', ''Crisis Assessment  - Description of crisis de-escalation interventions provided us required'',@TabId ,16
FROM #CustomDocumentCrisisInterventionNotes
WHERE LEN(LTRIM(RTRIM(ISNULL(CrisisDeEscalationInterventionsProvided, '''')))) = 0
/*
UNION
SELECT ''CustomDocumentCrisisInterventionNotes'', ''DeletedBy'', ''Crisis Assessment  - CrisisPlanTreatmentRecommended section is required'',@TabId ,17
FROM #CustomDocumentCrisisInterventionNotes
WHERE LEN(LTRIM(RTRIM(ISNULL(CrisisPlanTreatmentRecommended, '''')))) = 0

UNION
SELECT ''CustomDocumentCrisisInterventionNotes'', ''DeletedBy'', ''Crisis Assessment  - WishesPreferencesOfIndividual section is required'',@TabId ,18
FROM #CustomDocumentCrisisInterventionNotes
WHERE LEN(LTRIM(RTRIM(ISNULL(WishesPreferencesOfIndividual, '''')))) = 0

UNION
SELECT ''CustomDocumentCrisisInterventionNotes'', ''DeletedBy'', ''Crisis Assessment  - ReferredVoluntaryHospitalization selection is required'',@TabId ,19
FROM #CustomDocumentCrisisInterventionNotes
WHERE LEN(LTRIM(RTRIM(ISNULL(ReferredVoluntaryHospitalization, '''')))) = 0

UNION
SELECT ''CustomDocumentCrisisInterventionNotes'', ''DeletedBy'', ''Crisis Assessment  - ReferredInvoluntaryHospitalization selection is required'',@TabId ,20
FROM #CustomDocumentCrisisInterventionNotes
WHERE LEN(LTRIM(RTRIM(ISNULL(ReferredInvoluntaryHospitalization, '''')))) = 0

UNION
SELECT ''CustomDocumentCrisisInterventionNotes'', ''DeletedBy'', ''Crisis Assessment  - ReferralHarborServicesType section is required'',@TabId ,21
FROM #CustomDocumentCrisisInterventionNotes
WHERE LEN(LTRIM(RTRIM(ISNULL(ReferralHarborServicesType, '''')))) = 0

UNION
SELECT ''CustomDocumentCrisisInterventionNotes'', ''DeletedBy'', ''Crisis Assessment  - ReferralHarborServicesComment section is required'',@TabId ,22
FROM #CustomDocumentCrisisInterventionNotes
WHERE LEN(LTRIM(RTRIM(ISNULL(ReferralHarborServicesComment, '''')))) = 0

UNION
SELECT ''CustomDocumentCrisisInterventionNotes'', ''DeletedBy'', ''Crisis Assessment  - ReferralExternalServicesType section is required'',@TabId ,23
FROM #CustomDocumentCrisisInterventionNotes
WHERE LEN(LTRIM(RTRIM(ISNULL(ReferralExternalServicesType, '''')))) = 0

UNION
SELECT ''CustomDocumentCrisisInterventionNotes'', ''DeletedBy'', ''Crisis Assessment  - ReferralExternalServicesComment section is required'',@TabId ,24
FROM #CustomDocumentCrisisInterventionNotes
WHERE LEN(LTRIM(RTRIM(ISNULL(ReferralExternalServicesComment, '''')))) = 0

UNION
SELECT ''CustomDocumentCrisisInterventionNotes'', ''DeletedBy'', ''Crisis Assessment  - FollowUpInstructions section is required'',@TabId ,25
FROM #CustomDocumentCrisisInterventionNotes
WHERE LEN(LTRIM(RTRIM(ISNULL(FollowUpInstructions, '''')))) = 0

UNION
SELECT ''CustomDocumentCrisisInterventionNotes'', ''DeletedBy'', ''Crisis Assessment  - CrisisWasResolved selection is required'',@TabId ,26
FROM #CustomDocumentCrisisInterventionNotes
WHERE LEN(LTRIM(RTRIM(ISNULL(CrisisWasResolved, '''')))) = 0

UNION
SELECT ''CustomDocumentCrisisInterventionNotes'', ''DeletedBy'', ''Crisis Assessment  - PlanToAvoidCrisisRecurrence section is required'',@TabId ,27
FROM #CustomDocumentCrisisInterventionNotes
WHERE LEN(LTRIM(RTRIM(ISNULL(PlanToAvoidCrisisRecurrence, '''')))) = 0
*/

exec dbo.csp_ValidateCustomDocumentMentalStatuses @DocumentVersionId, 10

--exec dbo.csp_ValidateServiceGoal @ServiceId
--exec dbo.csp_ValidateServiceObjective @ServiceId
     



 
        
 END TRY
 BEGIN CATCH     

DECLARE @Error VARCHAR(8000)       
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + ''*****'' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                            
			+ ''*****'' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),''csp_validateDocumentCrisisInterventionNotes'')                                                                                             
			+ ''*****'' + CONVERT(VARCHAR,ERROR_LINE()) + ''*****'' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                              
			+ ''*****'' + CONVERT(VARCHAR,ERROR_STATE())
		RAISERROR
		(
			@Error, -- Message text.
			16,		-- Severity.
			1		-- State.
		);

 END CATCH
 
 return    
END
' 
END
GO
