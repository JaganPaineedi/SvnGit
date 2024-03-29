/****** Object:  StoredProcedure [dbo].[csp_validateCustomBasis32Web]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomBasis32Web]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomBasis32Web]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomBasis32Web]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_validateCustomBasis32Web]    
@DocumentVersionId Int           
as             
/******************************************************************************                                    
**  File: csp_validateCustomBasis32Web                                
**  Name: csp_validateCustomBasis32Web            
**  Desc: For Validation  on Custom Basis 32 document      
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
  
Return

/*  
  
Begin                                                  
        
 Begin try     
--*TABLE CREATE*--             
CREATE TABLE #CustomBasis32 (              
DocumentVersionId Int,            
Basis32Interval int,              
RelationToSelfOthers decimal(18,2),              
DepressionAnxiety decimal(18,2)             
)               
--*INSERT LIST*--             
INSERT INTO #CustomBasis32 (              
DocumentVersionId,               
Basis32Interval,               
RelationToSelfOthers,               
DepressionAnxiety             
)               
--*Select LIST*--             
Select DocumentVersionId,               
Basis32Interval,               
RelationToSelfOthers,               
DepressionAnxiety                
FROM CustomBasis32 WHERE DocumentVersionId = @DocumentVersionId and isnull(RecordDeleted,''N'')<>''Y''               
             
    
Insert into #validationReturnTable (  TableName, ColumnName, ErrorMessage )              
SELECT ''CustomBasis32'', ''Basis32Interval'', ''Note - Basis32Interval must be specified'' FROM #CustomBasis32 WHERE Basis32Interval is null    
UNION            
SELECT ''CustomBasis32'', ''DepressionAnxiety'', ''Note - Depression Anxiety must be specified'' FROM #CustomBasis32 WHERE DepressionAnxiety is null    
UNION              
SELECT ''CustomBasis32'', ''RelationToSelfOthers'', ''Note - Relation To Self Others must be specified'' FROM #CustomBasis32 WHERE RelationToSelfOthers is null    
                
DROP TABLE #CustomBasis32           
end try                                                                                     
BEGIN CATCH      
DECLARE @Error varchar(8000)                                                   
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                 
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_validateCustomBasis32Web'')                                                                                 
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
