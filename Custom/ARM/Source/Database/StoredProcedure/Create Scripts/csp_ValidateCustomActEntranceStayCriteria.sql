/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomActEntranceStayCriteria]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomActEntranceStayCriteria]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomActEntranceStayCriteria]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomActEntranceStayCriteria]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE   PROCEDURE [dbo].[csp_ValidateCustomActEntranceStayCriteria]       
@DocumentVersionId Int, @DocumentCodeId Int       
as       
--This is a temporary  Procedure we will modify this as needed      
/******************************************************************************                              
**  File: csp_ValidateCustomActEntranceStayCriteria                          
**  Name: csp_ValidateCustomActEntranceStayCriteria      
**  Desc: For Validation  on Custom Act Entrance Stay Criteria document
**  Return values: Resultset having validation messages                              
**  Called by:                               
**  Parameters:          
**  Auth:  Devinder Pal Singh             
**  Date:  Aug 24 2009                          
*******************************************************************************                              
**  Change History                              
*******************************************************************************                              
**  Date:       Author:       Description:                              
**  17/09/2009   Ankesh Bharti  Modify According to Data Model 3.0
**  --------    --------        ----------------------------------------------------                              
*******************************************************************************/                            
  
 
 Return
 
 
 /*
 
     
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
SELECT ''CustomActEntranceStayCriteria'', ''CurrentAddress'', ''Note - Current Address must be specified'' FROM #CustomActEntranceStayCriteria WHERE isnull(CurrentAddress,'''')=''''          
        
  if @@error <> 0 goto error  return  error: raiserror 50000 ''csp_validateCustomActEntranceStayCriteria failed.  Please contact your system administrator. We apologize for the inconvenience.'' 
  
  
  
 */
' 
END
GO
