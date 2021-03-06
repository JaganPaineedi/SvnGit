/****** Object:  StoredProcedure [dbo].[csp_validateCustomDocumentPsychologicalNotes]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomDocumentPsychologicalNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomDocumentPsychologicalNotes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomDocumentPsychologicalNotes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE   PROCEDURE [dbo].[csp_validateCustomDocumentPsychologicalNotes]      
@DocumentVersionId Int      
As 
     
BEGIN

BEGIN TRY      
      
CREATE TABLE [#CustomDocumentPsychologicalNotes] (      
            DocumentVersionId int NULL,
            SignificantchangesId varchar(max) NULL,
            SignificantchangesOther varchar(max) NULL,
            PsychologicalTestsAdministered char(1) NULL,
            PsychologicalTestsAdministeredComment varchar(200) NULL,
            ClinicalInterviewWith char(1) NULL,
            ClinicalInterviewWithComment  varchar(200) NULL,
            ProvidedFeedbackRegardingAssessment char(1) NULL,
            OtherIntervention char(1) NULL,
            OtherInterventionComment varchar(max) NULL,
            NarrativeDescription  varchar(max) NULL,
            RatingOfProgressTowardGoal char(1) NULL,
            DescriptionOfProgress  varchar(max) NULL,
            RecommendedChangesToISP char(1) NULL,
            DateOfNextVisit varchar(100) NULL 
)      
      
INSERT INTO [#CustomDocumentPsychologicalNotes](      
            DocumentVersionId,
            SignificantchangesId, 
            SignificantchangesOther,  
            PsychologicalTestsAdministered, 
            PsychologicalTestsAdministeredComment, 
            ClinicalInterviewWith, 
            ClinicalInterviewWithComment, 
            ProvidedFeedbackRegardingAssessment, 
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
            a.PsychologicalTestsAdministered, 
            a.PsychologicalTestsAdministeredComment, 
            a.ClinicalInterviewWith, 
            a.ClinicalInterviewWithComment, 
            a.ProvidedFeedbackRegardingAssessment, 
            a.OtherIntervention, 
            a.OtherInterventionComment, 
            a.NarrativeDescription,  
            a.RatingOfProgressTowardGoal, 
            a.DescriptionOfProgress,
            a.RecommendedChangesToISP,
            a.DateOfNextVisit
from CustomDocumentPsychologicalNotes a       
where a.DocumentVersionId = @DocumentVersionId and isnull(a.RecordDeleted,''N'')=''N''   
    
    
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

SELECT ''CustomDocumentPsychologicalNotes'', ''DeletedBy'', ''Note  - Significant changes section is required'',@TabId ,1
FROM #CustomDocumentPsychologicalNotes
WHERE SignificantChangesId is null
and LEN(LTRIM(RTRIM(ISNULL(SignificantChangesOther, '''')))) = 0


UNION
SELECT ''CustomDocumentPsychologicalNotes'', ''DeletedBy'', ''Note  - Therapeutic Intervention Provided selection is required'',@TabId ,2
FROM #CustomDocumentPsychologicalNotes
WHERE LEN(LTRIM(RTRIM(ISNULL(PsychologicalTestsAdministered, '''')))) = 0
and LEN(LTRIM(RTRIM(ISNULL(ClinicalInterviewWith, '''')))) = 0
and LEN(LTRIM(RTRIM(ISNULL(ProvidedFeedbackRegardingAssessment, '''')))) = 0
and LEN(LTRIM(RTRIM(ISNULL(OtherIntervention, '''')))) = 0

UNION
SELECT ''CustomDocumentPsychologicalNotes'', ''DeletedBy'', ''Note  - Psychological TestsAdministered Comment section is required'',@TabId ,3
FROM #CustomDocumentPsychologicalNotes
WHERE PsychologicalTestsAdministered = ''Y''
and LEN(LTRIM(RTRIM(ISNULL(PsychologicalTestsAdministeredComment, '''')))) = 0

UNION
SELECT ''CustomDocumentPsychologicalNotes'', ''DeletedBy'', ''Note  - ClinicalI nterview With Comment section is required'',@TabId ,4
FROM #CustomDocumentPsychologicalNotes
WHERE ClinicalInterviewWith = ''Y''
and LEN(LTRIM(RTRIM(ISNULL(ClinicalInterviewWithComment, '''')))) = 0


UNION
SELECT ''CustomDocumentPsychologicalNotes'', ''DeletedBy'', ''Note  - Other Intervention Comment section is required'',@TabId ,5
FROM #CustomDocumentPsychologicalNotes
WHERE OtherIntervention = ''Y''
and LEN(LTRIM(RTRIM(ISNULL(OtherInterventionComment, '''')))) = 0

UNION
SELECT ''CustomDocumentPsychologicalNotes'', ''DeletedBy'', ''Note - Rating of Progress toward goal selection is required'',@TabId, 6
FROM #CustomDocumentPsychologicalNotes
WHERE LEN(LTRIM(RTRIM(ISNULL(RatingOfProgressTowardGoal, '''')))) = 0

UNION
SELECT ''CustomDocumentPsychologicalNotes'', ''DeletedBy'', ''General  - Description of progress section is required'', @TabId, 7
FROM #CustomDocumentPsychologicalNotes
WHERE ISNULL(RatingOfProgressTowardGoal, '''') in ( ''S'',''M'',''A'')
and LEN(LTRIM(RTRIM(ISNULL(DescriptionOfProgress, '''')))) = 0

UNION
SELECT ''CustomDocumentPsychologicalNotes'', ''DeletedBy'', ''Note  - RecommendedChangesToISP selection is required'',@TabId ,8
FROM #CustomDocumentPsychologicalNotes
WHERE LEN(LTRIM(RTRIM(ISNULL(RecommendedChangesToISP, '''')))) = 0

--UNION
--SELECT ''CustomDocumentPsychologicalNotes'', ''DeletedBy'', ''Note  - DateOfNextVisit section is required'',@TabId ,1
--FROM #CustomDocumentPsychologicalNotes
--WHERE LEN(LTRIM(RTRIM(ISNULL(DateOfNextVisit, '''')))) = 0

 
END TRY

BEGIN CATCH

DECLARE @Error varchar(8000)                                                   
    SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                 
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_validateDocumentPsychologicalNote'')                                                                                 
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
