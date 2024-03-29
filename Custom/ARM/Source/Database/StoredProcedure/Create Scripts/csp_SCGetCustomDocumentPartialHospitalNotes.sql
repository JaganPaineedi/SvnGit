/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomDocumentPartialHospitalNotes]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDocumentPartialHospitalNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomDocumentPartialHospitalNotes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDocumentPartialHospitalNotes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'    
CREATE PROCEDURE  [dbo].[csp_SCGetCustomDocumentPartialHospitalNotes] 
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
            [Classroom],                             
            [Score],                                 
            [Level],                                
            [StartTime1],                             
            [EndTime1],                               
            [StartTime2],                             
            [EndTime2],                               
            [StartTime3],                             
            [EndTime3],                             
            [StartTime4],                             
            [EndTime4],                               
            [DeterminationOfNeededInterventions],     
            [SkillsDevelopment],                      
            [DevelopmentCopingMechanisms],            
            [ManagingSymptomsEnhanceOpportunities],   
            [ProblemSolvingConflictResolutionManagement],   
            [DevelopmentInterpersonalSocialCompetency],     
            [PsychoeducationTrainingAssessedNeeds],         
            [OtherIntervention],                            
            [OtherInterventionComment],                     
            [NarrativeDescription],                         
            [RatingOfProgressTowardGoal],                   
            [DescriptionOfProgress],                        
            [RecommendedChangesToISP],                      
            [DateOfNextVisit]                                         
 FROM       [dbo].[CustomDocumentPartialHospitalNotes]    
 WHERE     (ISNULL(RecordDeleted, ''N'') = ''N'') AND ([DocumentVersionId] = @DocumentVersionId)   
      
 END TRY  
   
  BEGIN CATCH      
  
    DECLARE @Error varchar(8000)                                                   
    SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                 
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_SCGetCustomDocumentPartialHospitalNotes'')                                                                                 
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
