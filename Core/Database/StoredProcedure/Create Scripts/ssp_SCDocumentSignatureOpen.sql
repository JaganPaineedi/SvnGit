
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCDocumentSignatureOpen]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCDocumentSignatureOpen]
GO

CREATE proc [dbo].[ssp_SCDocumentSignatureOpen]      
      
(      
@staffId int,      
@documentCodeId int,      
@effectiveDate datetime      
)        
/******************************************************************************                                                                                                                                              
**File: Document.cs                                                                                                                                              
**Name:                                                                                                                         
**Desc:Used to get the opening signature popup info                                                                                                                             
**Return values:                                                                                                                                              
**                                                                                                                                                           
**  Parameters:                                                                                                                                              
**  Input       Output                                                                                                                                              
**                                                                                                                                 
**                                                                                                                                        
**                                                                                                                                          
**                                                                                                                                        
**  Auth:  Karan                                                                                                                                 
**  Date:  23 Jan 2012        
*******************************************************************************                                                                                                                                              
**  Change History                                                                                                                                              
*******************************************************************************                                                                                                                                              
**  Date:         Author:                Description:                                                                                                       
**  23 Jan 2012   Karan                  Used to get the opening signature popup info 
**  12/18/2012    Jeff Riley             Modified to exclude StaffLicenseDegrees where RecordDeleted='Y'
**  8th feb 2013  sunil                  Get the password (task 2706 threshold bugs/ features)
**	7/15/2015	  Wasif Butt			 Update UserPassword length to 100 characters so it matches the Staff.UserPassword length       
                                                                                                   
                                                                            
*******************************************************************************/                                                     
AS                                                             
 BEGIN                                                                                               
                                                                                              
  BEGIN TRY          
    
  declare @NoPassword char(1)  
  declare @MultipleCredentials char(1)  
  declare @CredentialMatches int  
  declare @StaffCredential int  
  declare @OpenPasswordDialog char(1)  
  declare @DisableSignatureTextBox char(1)  
  declare @ShowCredentials char(1)  
    
  -- Check if password is required for signature  
  select @NoPassword = ISNULL(DocumentSignaturesNoPassword,'N')  
  from SystemConfigurations  
    
  -- Check if document has multiple credentials  
  select @MultipleCredentials = ISNULL(MultipleCredentials,'N')  
  from DocumentCodes  
  where DocumentCodeId = @DocumentCodeId  
    
  -- If document signature requires credentials, check how many match.  
    set @CredentialMatches = 0 
  if @MultipleCredentials = 'Y'  
  begin  
 select @CredentialMatches = COUNT(*)  
 from DocumentCodeLicensedSignatures dcls  
 JOIN StaffLicenseDegrees sld ON (dcls.Degree = sld.LicenseTypeDegree)  
 where dcls.DocumentCodeId = @documentCodeId  
 and sld.StaffId = @staffId  
 and sld.StartDate <= @effectiveDate   
 and ISNULL(sld.EndDate, @effectiveDate) >= @effectiveDate
 and ISNULL(sld.RecordDeleted,'N') = 'N'     -- Added by Jeff Riley    
   
-- If there is exactly 1 match for credential and credentials are required, get the matched credential  
-- This needs to be updated in DocumentSignatureCredentails table.   
  if @CredentialMatches = 1  
 begin  
  select @StaffCredential = dcls.Degree  
  from DocumentCodeLicensedSignatures dcls  
  JOIN StaffLicenseDegrees sld ON (dcls.Degree = sld.LicenseTypeDegree)  
  where dcls.DocumentCodeId = @documentCodeId  
  and sld.StaffId = @staffId  
  and sld.StartDate <= @effectiveDate   
  and ISNULL(sld.EndDate, @effectiveDate) >= @effectiveDate  
 end  
  end  
    
  set @OpenPasswordDialog = 'Y'  
  -- Do not open password dialog if agency does not need password and 1 or 0 credential match.  
  if @NoPassword = 'Y' and @CredentialMatches < 2   
 set @OpenPasswordDialog = 'N'  
  
  set @ShowCredentials = 'N'  
  if @CredentialMatches > 1   
 set @ShowCredentials = 'Y'   
    
  -- If no password is required and password dialog is opened, the signature text box must be disabled  
  if @NoPassword = 'Y'  
 set @DisableSignatureTextBox = 'Y' 
 
 Declare @UserPassword varchar(100)
  
 select  @UserPassword=UserPassword from Staff where StaffId=@staffId --added by sunil
    
 SELECT @OpenPasswordDialog as OpenPasswordDialog, @DisableSignatureTextBox as DisableSignatureTextBox,   
 @ShowCredentials as ShowCredentials, @StaffCredential as StaffCredential, @UserPassword as UserPassword  --added by sunil       
           
  END TRY                                                                                                                  
  BEGIN CATCH                                                                             
 DECLARE @Error varchar(8000)                                    
         SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                                             
         + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCDocumentSignatureOpen')                                                                                                                                             
         + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                                                             
         + '*****' + Convert(varchar,ERROR_STATE())                                                                                                                           
        RAISERROR                                                                                    
   (                                                                                      
     @Error, -- Message text.                                                                                                          
     16, -- Severity.                               
     1 -- State.                                                                      
    );                                                                                                                                            
  END CATCH                                 
 END 
GO


