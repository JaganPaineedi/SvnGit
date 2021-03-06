/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomPsychAssessment]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomPsychAssessment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomPsychAssessment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomPsychAssessment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_ValidateCustomPsychAssessment]    
@DocumentVersionId Int             
as             
           
/******************************************************************************                                    
**  File: csp_ValidateCustomPsychAssessment                                
**  Name: csp_ValidateCustomPsychAssessment            
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
   
DECLARE @DocumentCodeId INT
SET @DocumentCodeId = (Select DocumentCodeId From Documents Where CurrentDocumentVersionId = @DocumentVersionId)
           
--*TABLE CREATE*--             
CREATE TABLE #CustomPsychAssessment (              
DocumentVersionId Int,            
[Type] varchar(2),      
PrimaryClinician varchar(100),      
CurrentDiagnosis text      
)               
--*INSERT LIST*--             
INSERT INTO #CustomPsychAssessment (              
DocumentVersionId,               
[Type],               
PrimaryClinician,               
CurrentDiagnosis             
)               
--*Select LIST*--             
Select DocumentVersionId,               
[Type],               
PrimaryClinician,               
CurrentDiagnosis                
FROM CustomPsychAssessment WHERE DocumentVersionId = @DocumentVersionId and isnull(RecordDeleted,''N'')<>''Y''   


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
SELECT ''CustomPsychAssessment'', ''Type'', ''Note - Type must be specified'' FROM #CustomPsychAssessment WHERE isnull([Type],'''')=''''              
UNION            
SELECT ''CustomPsychAssessment'', ''CurrentDiagnosis'', ''Note - Current Diagnosis must be specified'' FROM #CustomPsychAssessment WHERE CAST(isnull(CurrentDiagnosis,'''') AS VARCHAR) = ''''            
UNION              
SELECT ''CustomPsychAssessment'', ''PrimaryClinician'', ''Note - Primary Clinician must be specified'' FROM #CustomPsychAssessment WHERE isnull(PrimaryClinician,'''')=''''            
*/               
              
  if @@error <> 0 goto error  

return  

error: raiserror 50000 ''csp_ValidateCustomPsychAssessment failed.  Please contact your system administrator. We apologize for the inconvenience.''
' 
END
GO
