/****** Object:  StoredProcedure [dbo].[csp_ValidateDDAssessment]    Script Date: 06/19/2013 17:49:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateDDAssessment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateDDAssessment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateDDAssessment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE   PROCEDURE [dbo].[csp_ValidateDDAssessment]     
@DocumentVersionId Int, @DocumentCodeId Int     
as     
--This is a temporary  Procedure we will modify this as needed    
/******************************************************************************                            
**  File: csp_ValidateDDAssessment                        
**  Name: csp_ValidateDDAssessment    
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
**  --------    --------        ----------------------------------------------------                            
*******************************************************************************/                          
  
Return

/*    
--*TABLE CREATE*--     
CREATE TABLE #CustomDDAssessment (      
DocumentVersionId Int,    
CommunicationStyle int,      
SupportNature int,      
SupportStatus int     
)       
--*INSERT LIST*--     
INSERT INTO #CustomDDAssessment (      
DocumentVersionId,       
CommunicationStyle,       
SupportNature,       
SupportStatus     
)       
--*Select LIST*--     
Select DocumentVersionId,       
CommunicationStyle,       
SupportNature,       
SupportStatus        
FROM CustomDDAssessment WHERE DocumentVersionId = @DocumentVersionId and isnull(RecordDeleted,''N'')<>''Y''      
     
     
Insert into #validationReturnTable (  TableName, ColumnName, ErrorMessage )      
SELECT ''CustomDDAssessment'', ''CommunicationStyle'', ''Note - Predominant Communication Style must be specified'' FROM #CustomDDAssessment WHERE isnull(CommunicationStyle,'''')=''''      
UNION    
SELECT ''CustomDDAssessment'', ''SupportStatus'', ''Note - Status of existing support system must be specified'' FROM #CustomDDAssessment WHERE isnull(SupportStatus,'''')=''''    
UNION      
SELECT ''CustomDDAssessment'', ''SupportNature'', ''Note - Family and/or friends must be specified'' FROM #CustomDDAssessment WHERE isnull(SupportNature,'''')=''''    
        
      
  if @@error <> 0 goto error  return  error: raiserror 50000 ''csp_validateDDAssessment failed.  Please contact your system administrator. We apologize for the inconvenience.'' 
  
 */
' 
END
GO
