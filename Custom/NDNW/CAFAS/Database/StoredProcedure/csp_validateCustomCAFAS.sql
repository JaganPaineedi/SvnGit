/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomCAFAS]   ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomCAFAS]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomCAFAS]
GO


/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomCAFAS]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_ValidateCustomCAFAS]         
@DocumentVersionId Int         
as         
--This is a temporary  Procedure we will modify this as needed        
/******************************************************************************                                
**  File: csp_ValidateCustomCAFAS                            
**  Name: csp_ValidateCustomCAFAS        
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
**  17/09/2009  Ankesh Bharti  Modify according to Data Model 3.0  
**  --------    --------        ----------------------------------------------------                                
*******************************************************************************/                              
        
--*TABLE CREATE*--         
CREATE TABLE #CustomCAFAS (          
DocumentVersionId Int,        
CAFASDate datetime,  
RaterClinician  int,  
CAFASInterval int  
)           
--*INSERT LIST*--         
INSERT INTO #CustomCAFAS (          
DocumentVersionId,           
CAFASDate,           
RaterClinician,           
CAFASInterval         
)           
--*Select LIST*--         
Select DocumentVersionId,           
CAFASDate,           
RaterClinician,           
CAFASInterval            
FROM CustomCAFAS WHERE DocumentVersionId = @DocumentVersionId and isnull(RecordDeleted,'N')<>'Y'          
         
         
Insert into #validationReturnTable (  TableName, ColumnName, ErrorMessage )          
SELECT 'CustomCAFAS', 'CAFASDate', 'Note - CAFAS Date must be specified' FROM #CustomCAFAS WHERE isnull(CAFASDate,'')=''          
UNION        
SELECT 'CustomCAFAS', 'CAFASInterval', 'Note - CAFAS Interval must be specified' FROM #CustomCAFAS WHERE CAFASInterval IS NULL
UNION          
SELECT 'CustomCAFAS', 'RaterClinician', 'Note - Rater Clinician must be specified' FROM #CustomCAFAS WHERE RaterClinician IS NULL
            
          
  if @@error <> 0 goto error  return  error: raiserror 50000 'csp_ValidateCustomCAFAS failed.  Please contact your system administrator. We apologize for the inconvenience.'

GO


