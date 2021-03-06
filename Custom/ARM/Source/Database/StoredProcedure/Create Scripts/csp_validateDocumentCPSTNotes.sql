/****** Object:  StoredProcedure [dbo].[csp_validateDocumentCPSTNotes]    Script Date: 06/19/2013 17:49:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateDocumentCPSTNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateDocumentCPSTNotes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateDocumentCPSTNotes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE   PROCEDURE [dbo].[csp_validateDocumentCPSTNotes]      
@DocumentVersionId Int      
AS
      
BEGIN

BEGIN TRY 

DECLARE @StoredProcedure varchar(300)

SET @StoredProcedure = object_name(@@procid)

--select @StoredProcedure

    
CREATE TABLE [#CustomDocumentCPSTNotes] (      
            DocumentVersionId int NULL,
            SignificantchangesId int NULL,
            SignificantchangesOther  varchar(max) null,
            OngoingAssessmentNeeds char(1) null,
            CoordinationISP char(1) null,                  
            SymptomMonitoring  char(1) null,                    
            EducationSpecificAssessedNeeds char(1) null,
            AdvocacyOutreach char(1) null,
            FacilitateDevelopmentDailyLivingSkills char(1) NULL,
            AssistAchievingIndependence  char(1) NULL,
            AssistAccessingNaturalSupports char(1) null,
            LinkageCommunitySupportSystems char(1) NULL,
            CoordinationCrisisManagement char(1) NULL,
            ActivitiesIncreaseImpactEnvironment char(1) NULL,
            MHInterventionBarriersEducationEmployment char(1) NULL,
            NarrativeDescription varchar(max) NULL, 
            RatingOfProgressTowardGoal  char(1) NULL, 
            DescriptionOfProgress  varchar(max) null,
            RecommendedChangesToISP char(1) NULL,
            DateOfNextVisit varchar(100)  NULL    
)      
      
INSERT INTO [#CustomDocumentCPSTNotes](      
            DocumentVersionId,
            SignificantchangesId,
            SignificantchangesOther,
            OngoingAssessmentNeeds,
            CoordinationISP,                  
            SymptomMonitoring,                    
            EducationSpecificAssessedNeeds,
            AdvocacyOutreach,
            FacilitateDevelopmentDailyLivingSkills,
            AssistAchievingIndependence,
            AssistAccessingNaturalSupports,
            LinkageCommunitySupportSystems,
            CoordinationCrisisManagement,
            ActivitiesIncreaseImpactEnvironment,
            MHInterventionBarriersEducationEmployment,
            NarrativeDescription,
            RatingOfProgressTowardGoal, 
            DescriptionOfProgress,
            RecommendedChangesToISP,
            DateOfNextVisit
)      
select      
            a.DocumentVersionId,
            a.SignificantchangesId,
            a.SignificantchangesOther,
            a.OngoingAssessmentNeeds,
            a.CoordinationISP,                  
            a.SymptomMonitoring,                    
            a.EducationSpecificAssessedNeeds,
            a.AdvocacyOutreach,
            a.FacilitateDevelopmentDailyLivingSkills,
            a.AssistAchievingIndependence,
            a.AssistAccessingNaturalSupports,
            a.LinkageCommunitySupportSystems,
            a.CoordinationCrisisManagement,
            a.ActivitiesIncreaseImpactEnvironment,
            a.MHInterventionBarriersEducationEmployment,
            a.NarrativeDescription,
            a.RatingOfProgressTowardGoal, 
            a.DescriptionOfProgress,
            a.RecommendedChangesToISP,
            a.DateOfNextVisit
from CustomDocumentCPSTNotes a       
where a.DocumentVersionId = @DocumentVersionId and isnull(a.RecordDeleted,''N'')=''N''     
    


declare @Sex char(1), @Age int, @EffectiveDate datetime, @ClientId int, @DocumentCodeId int, @ServiceId int

select @Sex = isnull(c.Sex,''U''), @Age = dbo.GetAge(c.DOB,d.EffectiveDate), @EffectiveDate = d.EffectiveDate, @ClientId = d.ClientId, 
	@DocumentCodeId = d.DocumentCodeId, @ServiceId = d.ServiceId
from DocumentVersions dv
join Documents d on d.DocumentId = dv.DocumentId 
join Clients c on c.ClientId = d.ClientId
where dv.DocumentVersionId = @DocumentVersionId

insert into #ValidationReturnTable (
	TableName,  
	ColumnName,  
	ErrorMessage,  
	TabOrder,  
	ValidationOrder  
) 
--SELECT ''CustomDocumentCPSTNotes'', ''DeletedBy'', ''General  - SignificantChangesId section is required'',1 ,1
--FROM #CustomDocumentCPSTNotes
--WHERE LEN(LTRIM(RTRIM(ISNULL(SignificantChangesId, '''')))) = 0

--UNION
--SELECT ''CustomDocumentCPSTNotes'', ''DeletedBy'', ''General  - SignificantChangesOther section is required'',1 ,1
--FROM #CustomDocumentCPSTNotes
--WHERE LEN(LTRIM(RTRIM(ISNULL(SignificantChangesOther, '''')))) = 0

--UNION
SELECT ''CustomDocumentCPSTNotes'', ''DeletedBy'', ''General  - Therapeutic Intervention Provided section is required'',1 ,1
FROM #CustomDocumentCPSTNotes
WHERE ISNULL(OngoingAssessmentNeeds, ''N'')  = ''N''
and ISNULL(CoordinationISP, ''N'')  = ''N''
and ISNULL(SymptomMonitoring, ''N'')  = ''N''
and ISNULL(EducationSpecificAssessedNeeds, ''N'')  = ''N''
and ISNULL(AdvocacyOutreach, ''N'')  = ''N''
and ISNULL(FacilitateDevelopmentDailyLivingSkills, ''N'')  = ''N''
and ISNULL(AssistAchievingIndependence, ''N'')  = ''N''
and ISNULL(AssistAccessingNaturalSupports, ''N'')  = ''N''
and ISNULL(LinkageCommunitySupportSystems, ''N'')  = ''N''
and ISNULL(CoordinationCrisisManagement, ''N'')  = ''N''
and ISNULL(ActivitiesIncreaseImpactEnvironment, ''N'')  = ''N''
and ISNULL(MHInterventionBarriersEducationEmployment, ''N'')  = ''N''

--UNION
--SELECT ''CustomDocumentCPSTNotes'', ''DeletedBy'', ''General  - Therapeutic Intervention Provided Narrative section is required'',1 ,1
--FROM #CustomDocumentCPSTNotes
--WHERE LEN(LTRIM(RTRIM(ISNULL(NarrativeDescription, '''')))) = 0

UNION
SELECT ''CustomDocumentCPSTNotes'', ''DeletedBy'', ''General  - Rating of Progress toward goal selection is required'',1 ,1
FROM #CustomDocumentCPSTNotes
WHERE LEN(LTRIM(RTRIM(ISNULL(RatingOfProgressTowardGoal, '''')))) = 0

UNION
SELECT ''CustomDocumentCPSTNotes'', ''DeletedBy'', ''General  - Description of progress section is required'',1 ,1
FROM #CustomDocumentCPSTNotes
WHERE ISNULL(RatingOfProgressTowardGoal, '''') in ( ''S'',''M'',''A'')
and LEN(LTRIM(RTRIM(ISNULL(DescriptionOfProgress, '''')))) = 0

UNION
SELECT ''CustomDocumentCPSTNotes'', ''DeletedBy'', ''General  - Recommended changes to ISP selection is required'',1 ,1
FROM #CustomDocumentCPSTNotes
WHERE LEN(LTRIM(RTRIM(ISNULL(RecommendedChangesToISP, '''')))) = 0

--UNION
--SELECT ''CustomDocumentCPSTNotes'', ''DeletedBy'', ''General  - Date of next visit section is required'',1 ,1
--FROM #CustomDocumentCPSTNotes
--WHERE LEN(LTRIM(RTRIM(ISNULL(DateOfNextVisit, '''')))) = 0

--UNION
--SELECT ''Services'', ''DeletedBy'',''Service  - Other person must be present if client is not present for this service'' ,0,1
--FROM #CustomDocumentCPSTNotes c
--join DocumentVersions dv on dv.DocumentVersionId = c.DocumentVersionId
--join Documents d on d.DocumentId = dv.DocumentId
--join Services s on s.ServiceId = d.ServiceId
--where isnull(s.ClientWasPresent,''N'')<>''Y''
--and LEN(LTRIM(RTRIM(isnull(s.OtherPersonsPresent,'''')))) = 0

--UNION
--SELECT ''Services'', ''DeletedBy'',''Service  - Billable must be selected for this service'' ,0,1
--FROM #CustomDocumentPreventionServicesNotes c 
--join DocumentVersions dv on dv.DocumentVersionId = c.DocumentVersionId
--join Documents d on d.DocumentId = dv.DocumentId
--join Services s on s.ServiceId = d.ServiceId
--where isnull(s.Billable,''N'')<>''Y''

exec dbo.csp_ValidateServiceGoal @ServiceId 

exec dbo.csp_ValidateServiceObjective @ServiceId

END TRY

BEGIN CATCH

DECLARE @Error varchar(8000)                                                   
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                 
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),@StoredProcedure)                                                                                 
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                                  
    + ''*****'' + Convert(varchar,ERROR_STATE())                              
 RAISERROR                                                                                 
 (                                                   
  @Error, -- Message text.                                                                                
  16, -- Severity.                                                                                
  1 -- State.                                                                                
 );           
 
END CATCH

return
END
' 
END
GO
