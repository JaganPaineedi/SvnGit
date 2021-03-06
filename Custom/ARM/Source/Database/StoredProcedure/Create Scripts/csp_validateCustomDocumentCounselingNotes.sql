/****** Object:  StoredProcedure [dbo].[csp_validateCustomDocumentCounselingNotes]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomDocumentCounselingNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomDocumentCounselingNotes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomDocumentCounselingNotes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[csp_validateCustomDocumentCounselingNotes]        
@DocumentVersionId Int        
As        
  
BEGIN  
  
BEGIN TRY      
DECLARE @StoredProcedure varchar(300)

SET @StoredProcedure = object_name(@@procid)

--select @StoredProcedure        

CREATE TABLE [#CustomDocumentCounselingNotes] (        
            DocumentVersionId int null,  
            SignificantchangesId int null,  
            SignificantchangesOther varchar(max) null,  
            TherapeuticInterventionType char(1) null,  
            PersonCenteredTherapy char(1) null,  
            BehavioralCognitiveTherapy char(1) null,  
            RationalEmotiveTherapy char(1) null,  
            TraumaFocusedCBT char(1) null,  
            InterpersonalSystemsTherapy char(1) null,  
            PsychodynamicTherapy char(1) null,  
            MultimodalIntegrativePsychoTherapy char(1) null,  
            SolutionFocusedTherapy char(1) null,  
            ExpressiveTherapy char(1) null,  
            RealityTherapy char(1) null,  
            Psychoeducation char(1) null,  
            ParentChildTherapy char(1) null,  
            HypnoTherapy char(1) null,  
            FunctionalBehavioralAnalysis char(1) null,  
            NarrativeTherapy char(1) null,  
            OtherIntervention char(1) null,  
            OtherInterventionComment varchar(max) null,  
            NarrativeDescription varchar(max) null,  
            RatingOfProgressTowardGoal char(1) null,  
            DescriptionOfProgress varchar(max) null,  
            RecommendedChangesToISP char(1) null,  
            DateOfNextVisit varchar(100) null 
)        
        
INSERT INTO [#CustomDocumentCounselingNotes](  
		    DocumentVersionId,  
            SignificantchangesId,  
            SignificantchangesOther,  
            TherapeuticInterventionType,  
            PersonCenteredTherapy,  
            BehavioralCognitiveTherapy,  
            RationalEmotiveTherapy,  
            TraumaFocusedCBT,  
            InterpersonalSystemsTherapy,  
            PsychodynamicTherapy,  
            MultimodalIntegrativePsychoTherapy,  
            SolutionFocusedTherapy,  
            ExpressiveTherapy,  
            RealityTherapy,  
            Psychoeducation,  
            ParentChildTherapy,  
            HypnoTherapy,  
            FunctionalBehavioralAnalysis,  
            NarrativeTherapy,  
            OtherIntervention,  
            OtherInterventionComment,  
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
  a.TherapeuticInterventionType,  
  a.PersonCenteredTherapy,  
  a.BehavioralCognitiveTherapy,             
  a.RationalEmotiveTherapy,      
  a.TraumaFocusedCBT,     
  a.InterpersonalSystemsTherapy,      
  a.PsychodynamicTherapy,     
  a.MultimodalIntegrativePsychoTherapy,  
  a.SolutionFocusedTherapy,  
  a.ExpressiveTherapy,  
  a.RealityTherapy,   
  a.Psychoeducation,   
  a.ParentChildTherapy,   
  a.HypnoTherapy,  
  a.FunctionalBehavioralAnalysis,  
  a.NarrativeTherapy,  
  a.OtherIntervention,  
  a.OtherInterventionComment,  
  a.NarrativeDescription,  
  a.RatingOfProgressTowardGoal,   
  a.DescriptionOfProgress,  
  a.RecommendedChangesToISP,    
  a.DateOfNextVisit     
from CustomDocumentCounselingNotes a         
where a.DocumentVersionId = @DocumentVersionId and isnull(a.RecordDeleted,''N'')<>''Y''        
      

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


SELECT ''CustomDocumentCounselingNotes'', ''DeletedBy'', ''General  - Significant changes section is required'',1 ,1
FROM #CustomDocumentCounselingNotes
WHERE ISNULL(SignificantChangesId, 0) = 0
and LEN(LTRIM(RTRIM(ISNULL(SignificantChangesOther, '''')))) = 0

UNION
SELECT ''CustomDocumentCounselingNotes'', ''DeletedBy'', ''General  - Please select type of therapy'',1 ,2
FROM #CustomDocumentCounselingNotes
WHERE len(rtrim(ltrim(ISNULL(TherapeuticInterventionType, '''')))) = 0

UNION
SELECT ''CustomDocumentCounselingNotes'', ''DeletedBy'', ''General  - Please select type of therapy'',1 ,3
FROM #CustomDocumentCounselingNotes
WHERE ISNULL(HypnoTherapy,''N'') = ''N''
and ISNULL(FunctionalBehavioralAnalysis, ''N'') = ''N''
and ISNULL(ParentChildTherapy, ''N'') = ''N''
and ISNULL(Psychoeducation, ''N'') = ''N''
and ISNULL(SolutionFocusedTherapy, ''N'') = ''N''
and ISNULL(RealityTherapy, ''N'') = ''N''
and ISNULL(ExpressiveTherapy, ''N'') = ''N''
and ISNULL(MultimodalIntegrativePsychoTherapy, ''N'') = ''N''
and ISNULL(PsychodynamicTherapy, ''N'') = ''N''
and ISNULL(InterpersonalSystemsTherapy, ''N'') = ''N''
and ISNULL(TraumaFocusedCBT, ''N'') = ''N''
and ISNULL(RationalEmotiveTherapy, ''N'') = ''N''
and ISNULL(BehavioralCognitiveTherapy, ''N'') = ''N''
and isnull(PersonCenteredTherapy,''N'') = ''N''
AND ISNULL(OtherIntervention, ''N'') = ''N''


UNION
SELECT ''CustomDocumentCounselingNotes'', ''DeletedBy'', ''General  - Other Intervention Comment section is required'',1 ,4
FROM #CustomDocumentCounselingNotes
WHERE LEN(LTRIM(RTRIM(ISNULL(OtherInterventionComment, '''')))) = 0 and OtherIntervention = ''Y''

UNION
SELECT ''CustomDocumentCounselingNotes'', ''DeletedBy'', ''General  - Rating of progress toward goal selection is required'',1 ,5
FROM #CustomDocumentCounselingNotes
WHERE LEN(LTRIM(RTRIM(ISNULL(RatingOfProgressTowardGoal, '''')))) = 0

UNION
SELECT ''CustomDocumentCounselingNotes'', ''DeletedBy'', ''General  - Description Of Progress section is required'',1 ,6
FROM #CustomDocumentCounselingNotes
WHERE LEN(LTRIM(RTRIM(ISNULL(DescriptionOfProgress, '''')))) = 0
and ISNULL(RatingOfProgressTowardGoal, '''') in ( ''S'',''M'',''A'')

UNION
SELECT ''CustomDocumentCounselingNotes'', ''DeletedBy'', ''General  - Recommended ChangesToISP selection is required'',1 ,7
FROM #CustomDocumentCounselingNotes
WHERE LEN(LTRIM(RTRIM(ISNULL(RecommendedChangesToISP, '''')))) = 0



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
  
RETURN   
END

' 
END
GO
