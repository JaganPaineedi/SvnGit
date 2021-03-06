/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomDocumentPsychologicalNotes]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDocumentPsychologicalNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomDocumentPsychologicalNotes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDocumentPsychologicalNotes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'    
CREATE PROCEDURE  [dbo].[csp_SCGetCustomDocumentPsychologicalNotes] 
@DocumentVersionId INT      
AS        

BEGIN   

BEGIN TRY   
          
SELECT      [DocumentVersionId],
            [CreatedBy],
            [CreatedDate],
            [ModifiedBy],
            [ModifiedDate],
            [RecordDeleted],
            [DeletedBy],
            [DeletedDate],
            [SignificantchangesId],
            [SignificantchangesOther],
            [PsychologicalTestsAdministered],
            [PsychologicalTestsAdministeredComment],
            [ClinicalInterviewWith],
            [ClinicalInterviewWithComment],
            [ProvidedFeedbackRegardingAssessment],
            [OtherIntervention],
            [OtherInterventionComment],
            [NarrativeDescription],
            [RatingOfProgressTowardGoal],
            [DescriptionOfProgress],
            [RecommendedChangesToISP],
            [DateOfNextVisit]               
 FROM       [dbo].[CustomDocumentPsychologicalNotes]    
 WHERE     (ISNULL(RecordDeleted, ''N'') = ''N'') AND ([DocumentVersionId] = @DocumentVersionId)   
      
 END TRY 
 
 BEGIN CATCH
 
  DECLARE @Error varchar(8000)                                                   
    SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                 
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_SCGetCustomDocumentPsychologicalNotes'')                                                                                 
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                                  
    + ''*****'' + Convert(varchar,ERROR_STATE())                              
    RAISERROR                                                                                 
   (                                                   
    @Error, -- Message text.                                                                                
    16, -- Severity.                                                                                
    1 -- State.                                                                                
   );     
             
 END CATCH    
        
END 
' 
END
GO
