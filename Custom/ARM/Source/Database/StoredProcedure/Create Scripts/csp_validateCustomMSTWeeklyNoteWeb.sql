/****** Object:  StoredProcedure [dbo].[csp_validateCustomMSTWeeklyNoteWeb]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomMSTWeeklyNoteWeb]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomMSTWeeklyNoteWeb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomMSTWeeklyNoteWeb]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_validateCustomMSTWeeklyNoteWeb]             
@DocumentVersionId Int            
as             
/******************************************************************************                                    
**  File: csp_validateCustomMSTWeeklyNoteWeb                                
**  Name: csp_validateCustomMSTWeeklyNoteWeb            
**  Desc: For Validation  on Custom MST Weekly Note  document      
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


      
Begin                                                  
        
 Begin try            
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
SELECT ''CustomMSTWeeklyNote'', ''ChildsAge'', ''Note - Child Age must be specified'' 
	FROM #CustomMSTWeeklyNote WHERE isnull(ChildsAge,'''')=''''              
UNION            
SELECT ''CustomMSTWeeklyNote'', ''FaceToFaceContacts'', ''Note - Face To Face Contacts must be specified'' 
	FROM #CustomMSTWeeklyNote WHERE FaceToFaceContacts is null    
UNION              
SELECT ''CustomMSTWeeklyNote'', ''IntakeDate'', ''Note - Intake Date must be specified'' 
	FROM #CustomMSTWeeklyNote WHERE isnull(IntakeDate,'''')=''''            
                
end try                                                                                     
BEGIN CATCH      
DECLARE @Error varchar(8000)                                                   
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                 
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_validateCustomMSTWeeklyNoteWeb'')                                                                                 
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
