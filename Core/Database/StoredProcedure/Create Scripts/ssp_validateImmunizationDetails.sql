
GO

/****** Object:  StoredProcedure [dbo].[ssp_validateImmunizationDetails]    Script Date: 06/13/2015 17:22:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_validateImmunizationDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_validateImmunizationDetails]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_validateImmunizationDetails]    Script Date: 06/13/2015 17:22:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_validateImmunizationDetails]  
@CurrentUserId Int,        
@ScreenKeyId Int     
    
as        
/******************************************************************************                                        
**  File: [ssp_validateImmunizationDetails]                                    
**  Name: [ssp_validateImmunizationDetails]                
**  Desc: For Validation  on Immunization Detail Page    
**  Return values: Resultset having validation messages                                        
**  Called by:                                         
**  Parameters:                    
**  Auth:  Chethan N                      
**  Date:  Feb 17 2014                                   
*******************************************************************************                                        
**  Change History                                        
*******************************************************************************                                        
**  Date:       Author:       Description:                                        
**  06/06/2016  Veena         Commented the validation for Manufactor,date time and comments   **	
*******************************************************************************/                                      
        
Begin                                                      
            
 Begin try         
--*TABLE CREATE*--                 
DECLARE  @ClientImmunization TABLE(        
       [ClientImmunizationId] int    
      ,[ClientId] int  
      ,[VaccineNameId] int 
      ,[ManufacturerId] int    
      ,[AdministeredDateTime] DateTime 
      ,[VaccineStatus] int  
      ,[Comment]  varchar(max)     
       
)        
        
--*INSERT LIST*--          
INSERT INTO @ClientImmunization(        
    [ClientImmunizationId]  
      ,[ClientId]
      ,[VaccineNameId]  
      ,[ManufacturerId]  
      ,[AdministeredDateTime]
      ,[VaccineStatus]
      ,[Comment]
        
)        
--*Select LIST*--            
SELECT [ClientImmunizationId]  
      ,[ClientId]
      ,[VaccineNameId]  
      ,[ManufacturerId]  
      ,[AdministeredDateTime]
      ,[VaccineStatus] int  
      ,[Comment]
        
from ClientImmunizations C         
where  C.ClientImmunizationId=@ScreenKeyId  and isnull(RecordDeleted,'N')<>'Y'             
        
        
DECLARE @validationReturnTable TABLE  
(    
TableName varchar(200),        
ColumnName varchar(200),        
ErrorMessage varchar(1000),
SortOrder    int     
)     
Insert into @validationReturnTable  
(    
TableName,        
ColumnName,        
ErrorMessage,
SortOrder        
)        
--This validation returns three fields        
--Field1 = TableName        
--Field2 = ColumnName        
--Field3 = ErrorMessage        
        
        --
Select 'ClientImmunizations', 'VaccineNameId', (Select dbo.Ssf_GetMesageByMessageCode(177,'ImmunVaccineName','')) as ErrorMessage, 1    
FROM @ClientImmunization   
WHERE VaccineNameId is NULL   
  
--Union    
--Select 'ClientImmunizations', 'AdministeredDateTime', (Select dbo.Ssf_GetMesageByMessageCode(177,'ImmunAdministeredDateTime','')) as ErrorMessage , 2       
--FROM @ClientImmunization   
--WHERE AdministeredDateTime is NULL  

--Union        
--Select 'ClientImmunizations', 'Comment', (Select dbo.Ssf_GetMesageByMessageCode(177,'ImmunComment','')) as ErrorMessage  , 3   
--FROM @ClientImmunization   
--WHERE  VaccineStatus=8630 and  (Comment is NULL or Comment ='') 

--Union        
--Select 'ClientImmunizations', 'ManufacturerId', (Select dbo.Ssf_GetMesageByMessageCode(177,'ImmunManufacturerId','')) as ErrorMessage , 4    
--FROM @ClientImmunization   
--WHERE ManufacturerId is NULL 


  
Select TableName, ColumnName, ErrorMessage     
from @validationReturnTable  order by SortOrder
  
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
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[ssp_validateImmunizationDetails]')                                                                                     
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                      
    + '*****' + Convert(varchar,ERROR_STATE())                                  RAISERROR                                                                                     
 (                                                       
  @Error, -- Message text.                                                                                    
  16, -- Severity.                                                                                    
  1 -- State.                                                                                    
 );                                                                                 
END CATCH                                
END

GO

