/****** Object:  StoredProcedure [dbo].[csp_validateCustomMSTAssessments]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomMSTAssessments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomMSTAssessments]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomMSTAssessments]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_validateCustomMSTAssessments]    
@DocumentVersionId Int         
as  

Return

/*
       
--This is a temporary  Procedure.  Modify the ValidationLogic in DocumentValidations for DocumentCodeId (292) as needed        
/******************************************************************************                                
**  File: csp_validateCustomMSTAssessments                            
**  Name: csp_validateCustomMSTAssessments        
**  Desc: For Validation  on Custom Date Tracking document  
**  Return values: Resultset having validation messages                                
**  Called by:                                 
**  Parameters:            
**  Auth:  Devinder Pal Singh  
**  Date:  Aug 24 2009                            
*******************************************************************************                                
**  Change History                                
*******************************************************************************                                
**  Date:       Author:    Description:                                
** 17/09/2009   Ankesh Bharti  Modify according to Data Model 3.0  
**  --------    --------        ----------------------------------------------------                                
*******************************************************************************/   
   
    
DECLARE @DocumentCodeId INT
SET @DocumentCodeId = (Select DocumentCodeId From Documents Where CurrentDocumentVersionId = @DocumentVersionId)

    
CREATE TABLE [#CustomMSTAssessments] (    
DocumentVersionId Int,    
Participant1 varchar(100),
Participant2 varchar(100),
Participant3 varchar(100)
)    
    
INSERT INTO [#CustomMSTAssessments](    
DocumentVersionId,   
Participant1,    
Participant2,    
Participant3  
)    
select     
DocumentVersionId,  
Participant1,    
Participant2,    
Participant3  
from CustomMSTAssessments WHERE DocumentVersionId = @DocumentVersionId and isnull(RecordDeleted,''N'') <> ''Y''  
  


--
-- DECLARE VARIABLES
--
declare @Variables varchar(max)
declare @DocumentType varchar(20)

--
-- DECLARE TABLE SELECT VARIABLES
--
set @Variables = ''Declare @DocumentVersionId int
					Set @DocumentVersionId = '' + convert(varchar(20), @DocumentVersionId)

set @DocumentType = NULL

--
-- Exec csp_validateDocumentsTableSelect to determine validation list
--
Exec csp_validateDocumentsTableSelect @DocumentVersionId, @DocumentCodeId, @DocumentType, @Variables



/*  
Insert into #validationReturnTable (  TableName, ColumnName, ErrorMessage )         

SELECT ''CustomMSTAssessments'', ''Participant1'', ''Note - Participant1 must be specified'' FROM #CustomMSTAssessments WHERE isnull(Participant1,'''')=''''          
UNION        
SELECT ''CustomMSTAssessments'', ''Participant2'', ''Note - Participant2 must be specified'' FROM #CustomMSTAssessments WHERE isnull(Participant2,'''')=''''        
UNION          
SELECT ''CustomMSTAssessments'', ''Participant3'', ''Note - Participant3 must be specified'' FROM #CustomMSTAssessments WHERE isnull(Participant3,'''')=''''        
   
*/         
          
  if @@error <> 0 goto error  

	return  

error: raiserror 50000 ''csp_validateCustomMSTAssessments failed.  Please contact your system administrator. We apologize for the inconvenience.'' 


*/
' 
END
GO
