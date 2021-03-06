IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateClientInformation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateClientInformation]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_ValidateClientInformation]          
@CurrentUserId Int,          
@ScreenKeyId Int       
      
AS          
/******************************************************************************                                          
**  File: [csp_ValidateClientInformation]                                      
**  Name: [csp_ValidateClientInformation]                  
**  Desc: For Validation  on ClientInformation Page      
**  Return values: Resultset having validation messages                                          
**  Called by:                                           
**  Parameters:                      
**  Auth:  SuryaBalan    
**  Date:  Feb 05 2015
--23-March-2015 SuryaBalan Copied from valley to New Directions Customization Task 4                                     
*******************************************************************************                                          
*******************************************************************************/                                        
          
Begin                                                        
                  
  Begin try               
--*TABLE CREATE*--                       
--DECLARE  @ClientDisclosure TABLE(     

DECLARE  @clients TABLE(     
		Sex char(1) NULL

)              
              
--*INSERT LIST*--                
INSERT INTO @clients(    
		Sex
)
             
--*Select LIST*--                  
SELECT  Sex
  
from dbo.clients C               
where  C.ClientId=@ScreenKeyId  and isnull(RecordDeleted,'N')<>'Y'                   
              
              
DECLARE @validationReturnTable TABLE        
(          
TableName varchar(200),              
ColumnName varchar(200),      
ErrorMessage varchar(1000)          
)           
Insert into @validationReturnTable        
(          
TableName,              
ColumnName,              
ErrorMessage              
)              
--This validation returns three fields              
--Field1 = TableName              
--Field2 = ColumnName              
--Field3 = ErrorMessage              
              
              
Select 'Clients', 'Sex', 'Demographics - Gender is required for generating Title XX No'           
FROM @Clients         
WHERE Sex is NULL         
        

Select TableName, ColumnName, ErrorMessage           
from @validationReturnTable        
        
IF Exists (Select * From @validationReturnTable)        
Begin         
 select 1  as ValidationStatus        
End        
Else        
Begin        
 Select 0 as ValidationStatus        
End        
          
              
end try                                                            
                                                                                            
BEGIN CATCH                
              
DECLARE @Error varchar(8000)                                                             
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                           
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[csp_ValidateClientInformation]')                                                                                           
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                            
    + '*****' + Convert(varchar,ERROR_STATE())                                  RAISERROR                                                                                           
 (                                                             
  @Error, -- Message text.                                                                                          
  16, -- Severity.                                                                                          
  1 -- State.                                                                                          
 );                                                                                       
END CATCH                                      
END                 
              
              
              
        
              
              