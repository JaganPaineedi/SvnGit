/****** Object:  StoredProcedure [dbo].[csp_validateCustomCAFASWeb]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomCAFASWeb]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomCAFASWeb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomCAFASWeb]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_validateCustomCAFASWeb]             
@DocumentVersionId Int             
as             
/******************************************************************************                                    
**  File: csp_validateCustomCAFASWeb                                
**  Name: csp_validateCustomCAFASWeb            
**  Desc: For Validation  on Custom DD assessment document(For Prototype purpose, Need modification)            
**  Return values: Resultset having validation messages                                    
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
    
Begin                                                  
        
 Begin try     
 --*TABLE CREATE*--             
CREATE TABLE #CustomCAFAS (              
DocumentVersionId Int,            
CAFASDate datetime,      
RaterClinician  int,      
CAFASInterval int      
)               
--*INSERT LIST*--             
INSERT INTO #CustomCAFAS (              
DocumentVersionId,               
CAFASDate,               
RaterClinician,               
CAFASInterval             
)               
--*Select LIST*--             
Select DocumentVersionId,               
CAFASDate,               
RaterClinician,               
CAFASInterval                
FROM CustomCAFAS WHERE DocumentVersionId = @DocumentVersionId              
             
             
Insert into #validationReturnTable (  TableName, ColumnName, ErrorMessage )              
SELECT ''CustomCAFAS'', ''CAFASDate'', ''Note - CAFAS Date must be specified'' FROM #CustomCAFAS WHERE isnull(CAFASDate,'''')=''''              
UNION            
SELECT ''CustomCAFAS'', ''CAFASInterval'', ''Note - CAFAS Interval must be specified'' FROM #CustomCAFAS WHERE CAFASInterval IS NULL    
UNION              
SELECT ''CustomCAFAS'', ''RaterClinician'', ''Note - Rater Clinician must be specified'' FROM #CustomCAFAS WHERE RaterClinician IS NULL    
    
end try                                                                                     
BEGIN CATCH      
DECLARE @Error varchar(8000)                                                   
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                 
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_validateCustomCAFASWeb'')                                                                                 
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
