/****** Object:  StoredProcedure [dbo].[csp_validateCustomActEntranceStayCriteriaWeb]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomActEntranceStayCriteriaWeb]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomActEntranceStayCriteriaWeb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomActEntranceStayCriteriaWeb]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_validateCustomActEntranceStayCriteriaWeb]           
@DocumentVersionId Int         
as           
--This is a temporary  Procedure we will modify this as needed          
/******************************************************************************                                  
**  File: csp_validateCustomActEntranceStayCriteriaWeb                              
**  Name: csp_validateCustomActEntranceStayCriteriaWeb          
**  Desc: For Validation  on Custom Act Entrance Stay Criteria document    
**  Return values: Resultset having validation messages                                  
**  Called by:                                   
**  Parameters:              
**  Auth:   Ankesh Bharti                 
**  Date:  Nov 23 2009                              
*******************************************************************************                                  
**  Change History                                  
*******************************************************************************                                  
**  Date:       Author:       Description:                                  
*******************************************************************************/                                
         
Begin                                                  
        
 Begin try           
--*TABLE CREATE*--           
CREATE TABLE #CustomActEntranceStayCriteria (            
DocumentVersionId Int,          
CurrentAddress varchar(150)    
)             
--*INSERT LIST*--           
INSERT INTO #CustomActEntranceStayCriteria (            
DocumentVersionId,             
CurrentAddress    
)             
--*Select LIST*--           
Select DocumentVersionId,             
CurrentAddress    
FROM CustomActEntranceStayCriteria WHERE DocumentVersionId = @DocumentVersionId and isnull(RecordDeleted,''N'')<>''Y''              
           
           
Insert into #validationReturnTable (  TableName, ColumnName, ErrorMessage )            
SELECT ''CustomActEntranceStayCriteria'', ''CurrentAddress'', ''Note - Current Address must be specified'' 
	FROM #CustomActEntranceStayCriteria WHERE isnull(CurrentAddress,'''')=''''              
    
end try                                                  
                                                                                           
BEGIN CATCH      
    
DECLARE @Error varchar(8000)                                                   
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                 
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_validateCustomActEntranceStayCriteriaWeb'')                                                                                 
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
