/****** Object:  StoredProcedure [dbo].[csp_validateCustomDCH3803Web]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomDCH3803Web]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomDCH3803Web]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomDCH3803Web]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_validateCustomDCH3803Web]           
@DocumentVersionId Int           
as           
         
/******************************************************************************                                  
**  File: csp_validateCustomDCH3803Web                              
**  Name: csp_validateCustomDCH3803Web          
**  Desc: For Validation  on Custom DCH3803 document          
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
   
Return

/* 
Begin                                                  
        
 Begin try    
--*TABLE CREATE*--           
CREATE TABLE #CustomDCH3803 (            
DocumentVersionId Int,          
InitialOrReview char(1),    
MoveInDate  datetime,    
FIACaseNumber varchar(64)    
)             
--*INSERT LIST*--           
INSERT INTO #CustomDCH3803 (            
DocumentVersionId,             
InitialOrReview,             
MoveInDate,             
FIACaseNumber           
)             
--*Select LIST*--           
Select DocumentVersionId,             
InitialOrReview,             
MoveInDate,             
FIACaseNumber              
FROM CustomDCH3803 WHERE DocumentVersionId = @DocumentVersionId  and isnull(RecordDeleted,''N'')<>''Y''       
    

Insert into #validationReturnTable ( TableName, ColumnName, ErrorMessage )            
SELECT ''CustomDCH3803'', ''InitialOrReview'', ''Note - Initial Or Review one must be specified'' FROM #CustomDCH3803 WHERE isnull(InitialOrReview,'''')=''''            
UNION          
SELECT ''CustomDCH3803'', ''FIACaseNumber'', ''Note - FIA Case Number must be specified'' FROM #CustomDCH3803 WHERE isnull(FIACaseNumber,'''')=''''          
UNION            
SELECT ''CustomDCH3803'', ''MoveInDate'', ''Note - Move In Date must be specified'' FROM #CustomDCH3803 WHERE isnull(MoveInDate,'''')=''''          
    
end try                                                                                     
BEGIN CATCH      
DECLARE @Error varchar(8000)                                                   
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                 
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_validateCustomDCH3803Web'')                                                                                 
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
