/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomBasis32]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomBasis32]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomBasis32]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomBasis32]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE   PROCEDURE [dbo].[csp_ValidateCustomBasis32]
@DocumentVersionId Int       
as         
--This is a temporary  Procedure we will modify this as needed        
/******************************************************************************                                
**  File: csp_ValidateCustomBasis32                            
**  Name: csp_ValidateCustomBasis32        
**  Desc: For Validation  on Custom Basis 32 document  
**  Return values: Resultset having validation messages                                
**  Called by:                                 
**  Parameters:            
**  Auth:  Devinder Pal Singh               
**  Date:  Aug 24 2009                            
*******************************************************************************                                
**  Change History                                
*******************************************************************************                                
**  Date:       Author:       Description:                                
**  17/09/2009   Ankesh Bharti  Modify according to Data Model 3.0  
**  --------    --------        ----------------------------------------------------                                
*******************************************************************************/                              


Return

/*

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
  if @@error <> 0 goto error  return  error: raiserror 50000 ''csp_validateCustomBasis32 failed.  Please contact your system administrator. We apologize for the inconvenience.'' 
  
  
  */
' 
END
GO
