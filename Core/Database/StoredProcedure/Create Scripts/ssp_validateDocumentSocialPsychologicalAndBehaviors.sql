
GO
/****** Object:  StoredProcedure [dbo].[[ssp_validateDocumentSocialPsychologicalAndBehaviors]]    Script Date: 07/17/2017 17:22:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_validateDocumentSocialPsychologicalAndBehaviors]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_validateDocumentSocialPsychologicalAndBehaviors]
GO

GO
/****** Object:  StoredProcedure [dbo].[[ssp_validateDocumentSocialPsychologicalAndBehaviors]]    Script Date: 07/17/2017 17:22:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_validateDocumentSocialPsychologicalAndBehaviors] --3368546
@DocumentVersionId int   
    
as        
/******************************************************************************                                        
**  File: [[ssp_validateDocumentSocialPsychologicalAndBehaviors]]                                    
**  Name: [[ssp_validateDocumentSocialPsychologicalAndBehaviors]]                
**  Desc: Why:task #42 Meaningful Use - Stage 3  
**  Return values: Resultset having validation messages                                        
**  Called by:                                         
**  Parameters:                    
**  Auth:  Vijay                      
**  Date:  17 July 2017                                   
*******************************************************************************                                        
**  Change History                                        
*******************************************************************************                                        
**  Date:       Author:       Description:                                        
*******************************************************************************/                                      
        
Begin                                                      
            
 Begin try         
--*TABLE CREATE*--                 
DECLARE  @DocumentSocialPsychologicalAndBehaviors TABLE(  
	   [DocumentVersionId] int     
      ,[PhysicalActivityExerciseMinutes] int    
      ,[PhysicalActivityDeclineToSpecify]  char(1)     
       
)        
        
--*INSERT LIST*--          
INSERT INTO @DocumentSocialPsychologicalAndBehaviors(        
       [DocumentVersionId]  
      ,[PhysicalActivityExerciseMinutes]
      ,[PhysicalActivityDeclineToSpecify] 
)        
--*Select LIST*--            
SELECT [DocumentVersionId]  
      ,[PhysicalActivityExerciseMinutes]
      ,[PhysicalActivityDeclineToSpecify]
from DocumentSocialPsychologicalAndBehaviors C         
where DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,'N') = 'N'

Select 'DocumentSocialPsychologicalAndBehaviors','PhysicalActivityExerciseMinutes', 'Physical Activity: Either minutes are entered or decline to specify is required', 1    
FROM @DocumentSocialPsychologicalAndBehaviors   
where ISNULL(PhysicalActivityExerciseMinutes,'') = '' AND (ISNULL(PhysicalActivityDeclineToSpecify,'') = '' OR PhysicalActivityDeclineToSpecify = 'N') 

end try                                                      
                                                                                      
BEGIN CATCH          
        
DECLARE @Error varchar(8000)                                                       
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                     
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[[ssp_validateDocumentSocialPsychologicalAndBehaviors]]')                                                                                     
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                      
    + '*****' + Convert(varchar,ERROR_STATE())                                  RAISERROR                                                                                     
 (                                                       
  @Error, -- Message text.                                                                                    
  16, -- Severity.                                                                                    
  1 -- State.                                                                                    
 );                                                                                 
END CATCH                                
END

GO

