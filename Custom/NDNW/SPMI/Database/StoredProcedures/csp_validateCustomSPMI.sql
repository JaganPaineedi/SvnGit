IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomSPMI]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomSPMI]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_validateCustomSPMI]          
@DocumentVersionId INT

AS          
/******************************************************************************                                          
**  File: [csp_validateCustomSPMI]                                      
**  Name: [csp_validateCustomSPMI]                  
**  Desc: For Validation  on SPMI
**  Return values: Resultset having validation messages                                          
**  Called by:                                           
**  Parameters:                      
**  Auth:  Anto                        
**  Date:  APRIL 28 2015                                     
*******************************************************************************/                                        
          
Begin                                                        
                  
  Begin try               
--*TABLE CREATE*--                       
--DECLARE  @CustomDocumentSPMIs TABLE(     

DECLARE  @CustomDocumentSPMIs TABLE(     

		DocumentVersionId				int						NOT NULL,	
		RecordDeleted					type_YOrN				NULL,
		DeletedBy						type_UserId				NULL,
		DeletedDate						datetime				NULL,		
		Schizophrenia					type_YOrN				NULL,
		MajorDepression					type_YOrN				NULL,
		Anxiety							type_YOrN				NULL,
		Personality						type_YOrN				NULL,
		Individual						type_YOrN				NULL			


)              
              
--*INSERT LIST*--                
INSERT INTO @CustomDocumentSPMIs(    
			DocumentVersionId,		
			RecordDeleted,	
			DeletedBy,	
			DeletedDate,
			Schizophrenia,
			MajorDepression,
			Anxiety,
			Personality,
			Individual
)
             
--*Select LIST*--                  
SELECT  
			DocumentVersionId,		
			RecordDeleted,	
			DeletedBy,	
			DeletedDate,		
			Schizophrenia,
			MajorDepression,
			Anxiety,
			Personality,
			Individual
		  

from dbo.CustomDocumentSPMIs C               
where  C.DocumentVersionId=@DocumentVersionId   and isnull(C.RecordDeleted,'N')<>'Y'    



                
DECLARE @validationReturnTable TABLE        
(          
	TableName varchar(200),              
	ColumnName varchar(200),      
	ErrorMessage varchar(1000),
	PageIndex       int,        
	TabOrder int,        
	ValidationOrder int          
)           
 
Insert into @validationReturnTable        
(          
	TableName,              
	ColumnName,              
	ErrorMessage,
	ValidationOrder             
)              
--This validation returns three fields              
--Field1 = TableName              
--Field2 = ColumnName              
--Field3 = ErrorMessage                         
              
Select 'CustomDocumentSPMIs', 'Schizophrenia', 'At least one checkbox must be checked' , 1        
FROM @CustomDocumentSPMIs 
WHERE IsNULL (Schizophrenia,'N') = 'N' AND IsNULL (MajorDepression,'N') = 'N'  AND IsNULL (Anxiety,'N') = 'N'  AND IsNULL (Personality,'N') = 'N'  AND IsNULL (Individual,'N') = 'N'




Select TableName, ColumnName, ErrorMessage ,PageIndex,TabOrder,ValidationOrder               
from @validationReturnTable  order by  ValidationOrder asc     
        
          
              
end try                                                            
                                                                                            
BEGIN CATCH                
              
DECLARE @Error varchar(8000)                                                             
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                           
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[csp_validateCustomSPMI]')                                                                                           
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                            
    + '*****' + Convert(varchar,ERROR_STATE())                                  RAISERROR                                                                                           
 (                                                             
  @Error, -- Message text.                                                                                          
  16, -- Severity.                                                                                          
  1 -- State.                                                                                          
 );                                                                                       
END CATCH                                      
END             
              
              
        
              
              