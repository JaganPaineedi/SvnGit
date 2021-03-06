/****** Object:  StoredProcedure [dbo].[csp_validateCustomMSTAssessmentsWeb]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomMSTAssessmentsWeb]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomMSTAssessmentsWeb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomMSTAssessmentsWeb]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_validateCustomMSTAssessmentsWeb]  
@DocumentVersionId Int  
as  
/******************************************************************************                                        
**  File: csp_validateCustomMSTAssessmentsWeb                                    
**  Name: csp_validateCustomMSTAssessmentsWeb                
**  Desc: For Validation  on Custom MSTAssessments document          
**  Return values: Resultset having validation messLegals                                        
**  Called by:                                         
**  Parameters:                    
**  Auth:  Ankesh Bharti                       
**  Date:  Nov 23 2009                                    
*******************************************************************************                                        
**  Change History                                        
*******************************************************************************                                        
**  Date:       Author:       Description:                                        
**  --------    --------        ----------------------------------------------------                                        
*******************************************************************************/                                      
 

Return

/* 
  
Begin                                                
      
 Begin try                
--*TABLE CREATE*--      
CREATE TABLE [#CustomMSTAssessments] (      
DocumentVersionId Int,      
Participant1 varchar(100),  
Participant2 varchar(100),  
Participant3 varchar(100)  
)      
--*INSERT LIST*--   
INSERT INTO [#CustomMSTAssessments](      
DocumentVersionId,     
Participant1,      
Participant2,      
Participant3    
)     
--*Select LIST*--    
select       
DocumentVersionId,    
Participant1,      
Participant2,      
Participant3    
from CustomMSTAssessments WHERE DocumentVersionId = @DocumentVersionId   
      
Insert into #validationReturnTable (  TableName, ColumnName, ErrorMessage )            
SELECT ''CustomMSTAssessments'', ''Participant1'', ''Note - Participant1 must be specified'' FROM #CustomMSTAssessments WHERE isnull(Participant1,'''')=''''            
UNION          
SELECT ''CustomMSTAssessments'', ''Participant2'', ''Note - Participant2 must be specified'' FROM #CustomMSTAssessments WHERE isnull(Participant2,'''')=''''          
UNION            
SELECT ''CustomMSTAssessments'', ''Participant3'', ''Note - Participant3 must be specified'' FROM #CustomMSTAssessments WHERE isnull(Participant3,'''')=''''   
  
end try                                                
                                                                                         
BEGIN CATCH    
  
DECLARE @Error varchar(8000)                                                 
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                               
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_validateCustomMSTAssessmentsWeb'')                                                                               
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
 
 
 */
' 
END
GO
