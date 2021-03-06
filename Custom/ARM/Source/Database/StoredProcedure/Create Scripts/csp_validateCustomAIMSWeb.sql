/****** Object:  StoredProcedure [dbo].[csp_validateCustomAIMSWeb]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomAIMSWeb]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomAIMSWeb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomAIMSWeb]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_validateCustomAIMSWeb]               
@DocumentVersionId Int               
as               
        
/******************************************************************************                                      
**  File: csp_validateCustomAIMSWeb                                  
**  Name: csp_validateCustomAIMSWeb              
**  Desc: For Validation  on Custom AIMS document        
**  Return values: Resultset having validation messages                                      
**  Called by:                                       
**  Parameters:                  
**  Auth:  Ankesh Bharti                    
**  Date:  Nov 23 2009                                  
*******************************************************************************                                      
**  Change History                                      
*******************************************************************************                                      
**  Date:       Author:       Description:                                      
**  Nov 26 2009  Ankesh Bharti  Modify the validation    
** --------     --------     ----------------------------------------------------                                      
*******************************************************************************/                                    
             
Begin                                                  
        
 Begin try      
--*TABLE CREATE*--               
CREATE TABLE #CustomAIMS (                
DocumentVersionId Int,              
TotalScore        int,        
DentalStatusWearDentures char(1),        
DentalStatusCurrentProblems char(1),        
GlobalJudgementAwareness int,        
GlobalJudgementIncapacitation int,        
GlobalJudgementSeverity int,        
FacialOralMovementsMuscles int,        
FacialOralMovementsLips int,        
FacialOralMovementsJaw int,        
FacialOralMovementsTongue int,        
ExtremityMovementsUpper int,        
ExtremityMovementsLower int,        
ExtremityMovementsTrunk int,        
ClientInformed CHAR(1),    
Method int        
)                 
--*INSERT LIST*--               
INSERT INTO #CustomAIMS (                
DocumentVersionId,                 
TotalScore,                 
DentalStatusWearDentures,                 
DentalStatusCurrentProblems,        
GlobalJudgementAwareness ,        
GlobalJudgementIncapacitation ,        
GlobalJudgementSeverity ,        
FacialOralMovementsMuscles ,        
FacialOralMovementsLips ,        
FacialOralMovementsJaw ,        
FacialOralMovementsTongue ,        
ExtremityMovementsUpper ,        
ExtremityMovementsLower ,        
ExtremityMovementsTrunk ,        
ClientInformed ,    
Method         
)                 
--*Select LIST*--               
Select DocumentVersionId,                 
TotalScore,                 
DentalStatusWearDentures,                 
DentalStatusCurrentProblems,        
GlobalJudgementAwareness ,        
GlobalJudgementIncapacitation ,        
GlobalJudgementSeverity ,        
FacialOralMovementsMuscles ,        
FacialOralMovementsLips ,        
FacialOralMovementsJaw ,        
FacialOralMovementsTongue ,        
ExtremityMovementsUpper ,        
ExtremityMovementsLower ,        
ExtremityMovementsTrunk ,        
ClientInformed,    
Method                  
FROM CustomAIMS WHERE DocumentVersionId = @DocumentVersionId and isnull(RecordDeleted,''N'')<>''Y''      
               
Insert into #validationReturnTable (  TableName, ColumnName, ErrorMessage )     
SELECT ''CustomAIMS'', ''Method'', ''Note -Method must be specified'' 
	FROM #CustomAIMS WHERE isnull(Method,'''')=''''    
end try                                                                                     
BEGIN CATCH      
    
DECLARE @Error varchar(8000)                                                   
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                 
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_validateCustomAIMSWeb'')                                                                                 
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
