/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomDCH3803]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDCH3803]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomDCH3803]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDCH3803]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE   PROCEDURE [dbo].[csp_ValidateCustomDCH3803]       
@DocumentVersionId Int, @DocumentCodeId Int       
as       
     
/******************************************************************************                              
**  File: csp_ValidateCustomDCH3803                          
**  Name: csp_ValidateCustomDCH3803      
**  Desc: For Validation  on Custom DD assessment document(For Prototype purpose, Need modification)      
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
FROM CustomDCH3803 WHERE DocumentVersionId = @DocumentVersionId and isnull(RecordDeleted,''N'')<>''Y''        
       
       
Insert into #validationReturnTable (  TableName, ColumnName, ErrorMessage )        
SELECT ''CustomDCH3803'', ''InitialOrReview'', ''Note - Initial Or Review one must be specified'' FROM #CustomDCH3803 WHERE isnull(InitialOrReview,'''')=''''        
UNION      
SELECT ''CustomDCH3803'', ''FIACaseNumber'', ''Note - FIA Case Number must be specified'' FROM #CustomDCH3803 WHERE isnull(FIACaseNumber,'''')=''''      
UNION        
SELECT ''CustomDCH3803'', ''MoveInDate'', ''Note - Move In Date must be specified'' FROM #CustomDCH3803 WHERE isnull(MoveInDate,'''')=''''      
          
        
  if @@error <> 0 goto error  return  error: raiserror 50000 ''csp_ValidateCustomDCH3803 failed.  Please contact your system administrator. We apologize for the inconvenience.'' 

*/
' 
END
GO
