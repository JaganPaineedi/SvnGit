/****** Object:  StoredProcedure [dbo].[csp_validateCustomDocumentPartialHospitalNotes]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomDocumentPartialHospitalNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomDocumentPartialHospitalNotes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomDocumentPartialHospitalNotes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE   PROCEDURE [dbo].[csp_validateCustomDocumentPartialHospitalNotes]      
@DocumentVersionId Int      
As   

BEGIN

BEGIN TRY   
      
      
CREATE TABLE [#CustomDocumentPartialHospitalNotes] (      
            DocumentVersionId int NULL,
            SignificantchangesId varchar(max) NULL,
            SignificantchangesOther varchar(max) NULL,               
            Classroom varchar(max) NULL,                             
            Score int NULL,                                 
            [Level] varchar(max) NULL,                                
            StartTime1 datetime NULL,                             
            EndTime1 datetime NULL,                               
            StartTime2 datetime NULL,                             
            EndTime2 datetime NULL,                               
            StartTime3 datetime NULL,                             
            EndTime3 datetime NULL,                             
            StartTime4 datetime NULL,                             
            EndTime4 datetime NULL,                               
            DeterminationOfNeededInterventions char(1) NULL,     
            SkillsDevelopment char(1) NULL,                      
            DevelopmentCopingMechanisms char(1) NULL,            
            ManagingSymptomsEnhanceOpportunities char(1) NULL,   
            ProblemSolvingConflictResolutionManagement char(1) NULL,   
            DevelopmentInterpersonalSocialCompetency char(1) NULL,     
            PsychoeducationTrainingAssessedNeeds char(1) NULL,         
            OtherIntervention char(1) NULL,                            
            OtherInterventionComment varchar(max) NULL,                     
            NarrativeDescription varchar(max) NULL,                         
            RatingOfProgressTowardGoal char(1) NULL,                   
            DescriptionOfProgress varchar(max) NULL,                        
            RecommendedChangesToISP char(1) NULL,                      
            DateOfNextVisit varchar(100)  NULL       
)      
      
INSERT INTO [#CustomDocumentPartialHospitalNotes](      
            DocumentVersionId,
            SignificantchangesId, 
            SignificantchangesOther,              
            Classroom,                            
            Score,                                 
            [Level],                              
            StartTime1,                             
            EndTime1,                                
            StartTime2,                              
            EndTime2,                             
            StartTime3,                             
            EndTime3,                             
            StartTime4,                           
            EndTime4,                               
            DeterminationOfNeededInterventions,     
            SkillsDevelopment,                      
            DevelopmentCopingMechanisms,             
            ManagingSymptomsEnhanceOpportunities, 
            ProblemSolvingConflictResolutionManagement,   
            DevelopmentInterpersonalSocialCompetency,    
            PsychoeducationTrainingAssessedNeeds,        
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
            a.Classroom,                            
            a.Score,                                 
            a.[Level],                              
            a.StartTime1,                             
            a.EndTime1,                                
            a.StartTime2,                              
            a.EndTime2,                             
            a.StartTime3,                             
            a.EndTime3,                             
            a.StartTime4,                           
            a.EndTime4,                               
            a.DeterminationOfNeededInterventions,     
            a.SkillsDevelopment,                      
            a.DevelopmentCopingMechanisms,             
            a.ManagingSymptomsEnhanceOpportunities, 
            a.ProblemSolvingConflictResolutionManagement,   
            a.DevelopmentInterpersonalSocialCompetency,    
            a.PsychoeducationTrainingAssessedNeeds,        
            a.OtherIntervention,                            
            a.OtherInterventionComment,                    
            a.NarrativeDescription,                      
            a.RatingOfProgressTowardGoal,                
            a.DescriptionOfProgress,                      
            a.RecommendedChangesToISP,                 
            a.DateOfNextVisit
from CustomDocumentPartialHospitalNotes a       
where a.DocumentVersionId = @DocumentVersionId and isnull(a.RecordDeleted,''N'')=''N''    
    
    
--    
-- DECLARE VARIABLES    
--    
declare @Variables varchar(max)    
declare @DocumentType varchar(20)    
Declare @DocumentCodeId int    
    
    
--    
-- DECLARE TABLE SELECT VARIABLES    
--    
set @Variables = ''Declare @DocumentVersionId int    
     Set @DocumentVersionId = '' + convert(varchar(20), @DocumentVersionId)        
    
    
Set @DocumentCodeId = (Select DocumentCodeId From Documents Where CurrentDocumentVersionId = @DocumentVersionId)    
set @DocumentType = NULL    
    
--    
-- Exec csp_validateDocumentsTableSelect to determine validation list    
--    
Exec csp_validateDocumentsTableSelect @DocumentVersionId, @DocumentCodeId, @DocumentType, @Variables  

END TRY

BEGIN CATCH

DECLARE @Error varchar(8000)                                                   
    SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                 
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_validateDocumentPartialHospNote'')                                                                                 
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
