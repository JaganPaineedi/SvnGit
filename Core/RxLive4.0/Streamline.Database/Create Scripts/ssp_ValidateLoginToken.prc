Create PROCEDURE  [dbo].[ssp_ValidateLoginToken]          
(                      
 @UserGuid char(36)                      
)                      
As                      
                    
BEGIN TRY                     
                           
/*********************************************************************/                        
/* Stored Procedure: dbo.ssp_ValidateLoginToken                        */                        
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                        
/* Creation Date:  10 nov 2007                                        */                        
/*                                                                   */                        
/* Purpose: Validate a token request                              */                       
/*                                                                   */                      
/* Input Parameters: @UserGuid                    */                      
/*                                                                   */                        
/* Return: staff row from staff Table  */                        
/*                                                                   */                        
/* Called By:                                                        */                        
/*                                                                   */                        
/* Calls:                                                            */                        
/*                                                                   */                        
/* Data Modifications:                                               */                        
/*                                                                   */                        
/* Updates:                                                          */                        
/*  Date        Author         Purpose                          */                        
/* 11/10/2007    Jatinder Singh       Created               */                     
/* 05/12/2008    Rohit Verma. [DefaultPrescribingLocation as StaffPrescribingLocationId] field added */    
/*********************************************************************/                         
                     
                    
 declare @staffid  as int                    
                    
 select @staffid=staffid from ValidateLogins where UserGUID=@UserGuid                    
                    
 if @staffId >0                     
 Begin                    
  SELECT [StaffId],[UserCode],[LastName],[FirstName],[MiddleName],                    
  [Degree],[EHRUser],isnull([MedicationDaysDefault],0) as MedicationDaysDefault,DefaultPrescribingLocation as StaffPrescribingLocationId,[RowIdentifier] from staff where staffid=@staffid                    
                    
  --Delete from ValidateLogins where UserGUID=@UserGuid                    
 End                    
                    
                    
END TRY                    
BEGIN CATCH                    
 declare @Error varchar(8000)                    
 set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                     
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_ValidateLoginToken')                     
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                      
    + '*****' + Convert(varchar,ERROR_STATE())                    
                      
 RAISERROR                     
 (                    
  @Error, -- Message text.                    
  16, -- Severity.                    
  1 -- State.                    
 );                    
                    
END CATCH 
