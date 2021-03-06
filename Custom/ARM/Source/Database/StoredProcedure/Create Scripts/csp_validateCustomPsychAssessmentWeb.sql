/****** Object:  StoredProcedure [dbo].[csp_validateCustomPsychAssessmentWeb]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomPsychAssessmentWeb]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomPsychAssessmentWeb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomPsychAssessmentWeb]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create PROCEDURE [dbo].[csp_validateCustomPsychAssessmentWeb]      
@DocumentVersionId Int               
as               
             
/******************************************************************************                                      
**  File: csp_validateCustomPsychAssessmentWeb                                  
**  Name: csp_validateCustomPsychAssessmentWeb              
**  Desc: For Validation  on Custom Psych Assessment document             
**  Return values: Resultset having validation messages                                      
**  Called by:                                       
**  Parameters:                  
**  Auth:  Ankesh Bharti                     
**  Date:  Nov 23 2009                                  
*******************************************************************************                                      
**  Change History                                      
*******************************************************************************                                      
**  Date:       Author:       Description:                                      
*******************************************************************************/                                    
        
Begin                                                
      
 Begin try     
--*TABLE CREATE*--               
CREATE TABLE #CustomPsychAssessment (                
DocumentVersionId Int,              
[Type] varchar(2),        
PrimaryClinician varchar(100),        
CurrentDiagnosis text        
)                 
--*INSERT LIST*--               
INSERT INTO #CustomPsychAssessment (                
DocumentVersionId,                 
[Type],                 
PrimaryClinician,                 
CurrentDiagnosis               
)                 
--*Select LIST*--               
Select DocumentVersionId,                 
[Type],                 
PrimaryClinician,                 
CurrentDiagnosis                  
FROM CustomPsychAssessment WHERE DocumentVersionId = @DocumentVersionId and isnull(RecordDeleted,''N'')<>''Y''                 
               
               
Insert into #validationReturnTable (  TableName, ColumnName, ErrorMessage )                
SELECT ''CustomPsychAssessment'', ''Type'', ''Note - Type must be specified'' 
	FROM #CustomPsychAssessment WHERE isnull([Type],'''')=''''                
UNION                
SELECT ''CustomPsychAssessment'', ''PrimaryClinician'', ''Note - Primary Clinician must be specified'' 
	FROM #CustomPsychAssessment WHERE isnull(PrimaryClinician,'''')=''''  
end try    
                                                                                 
BEGIN CATCH    
DECLARE @Error varchar(8000)                                                 
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                               
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_validateCustomPsychAssessmentWeb'')                                                                               
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
