/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomMSTWeeklyNote]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomMSTWeeklyNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomMSTWeeklyNote]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomMSTWeeklyNote]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_ValidateCustomMSTWeeklyNote]         
@DocumentVersionId Int, @DocumentCodeId Int         
as         
/******************************************************************************                                
**  File: csp_ValidateCustomMSTWeeklyNote                            
**  Name: csp_ValidateCustomMSTWeeklyNote        
**  Desc: For Validation  on Custom MST Weekly Note  document  
**  Return values: Resultset having validation messages                                
**  Called by:                                 
**  Parameters:            
**  Auth:  Devinder Pal Singh               
**  Date:  Aug 24 2009                            
*******************************************************************************                                
**  Change History                                
*******************************************************************************                                
**  Date:       Author:       Description:                     
**  17/09/2009  Ankesh Bharti  Modify According to Data Model 3.0             
**  --------    --------        ----------------------------------------------------                                
*******************************************************************************/                              
 
Return

/* 
        
--*TABLE CREATE*--         
CREATE TABLE #CustomMSTWeeklyNote (          
DocumentVersionId Int,        
ChildsAge varchar(25),  
IntakeDate datetime,  
FaceToFaceContacts int  
)           
--*INSERT LIST*--         
INSERT INTO #CustomMSTWeeklyNote (          
DocumentVersionId,           
ChildsAge,           
IntakeDate,           
FaceToFaceContacts         
)           
--*Select LIST*--         
Select DocumentVersionId,           
ChildsAge,           
IntakeDate,           
FaceToFaceContacts            
FROM CustomMSTWeeklyNote WHERE DocumentVersionId = @DocumentVersionId and isnull(RecordDeleted,''N'')<>''Y''          
         
         
Insert into #validationReturnTable (  TableName, ColumnName, ErrorMessage )          
SELECT ''CustomMSTWeeklyNote'', ''ChildsAge'', ''Note - Child Age must be specified'' FROM #CustomMSTWeeklyNote WHERE isnull(ChildsAge,'''')=''''          
UNION        
SELECT ''CustomMSTWeeklyNote'', ''FaceToFaceContacts'', ''Note - Face To Face Contacts must be specified'' FROM #CustomMSTWeeklyNote WHERE FaceToFaceContacts is null
UNION          
SELECT ''CustomMSTWeeklyNote'', ''IntakeDate'', ''Note - Intake Date must be specified'' FROM #CustomMSTWeeklyNote WHERE isnull(IntakeDate,'''')=''''        
            
          
  if @@error <> 0 goto error  return  error: raiserror 50000 ''csp_ValidateCustomMSTWeeklyNote failed.  Please contact your system administrator. We apologize for the inconvenience.'' 
  
  
  
  */
' 
END
GO
