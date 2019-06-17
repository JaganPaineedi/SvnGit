 
 
 /****** Object:  StoredProcedure [dbo].[csp_SCGetVitalsHPA]    Script Date: 06/30/2014 18:06:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetExternalReferralProviders]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetExternalReferralProviders] 
GO

/****** Object:  StoredProcedure [dbo].[csp_GetExternalReferralProviders]    Script Date: 06/30/2014 18:06:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 
 
CREATE Procedure [dbo].[csp_GetExternalReferralProviders]     
@ExternalReferralProviderId INT     
AS    
/*********************************************************************/                              
/* Stored Procedure: dbo.ssp_GetExternalReferralProviders             */                              
/* Creation Date:  01 August, 2012                                    */                              
/*                                                                   */                              
/* Purpose: get the data from ExternalProviders table .             */                             
/*                                                                   */                            
/* Input Parameters:                                    */                            
/*                                                                   */                              
/* Output Parameters:                                */                              
/*                                                                   */                              
/*                                                                   */                              
/* Called By:  CleintInformation.cs                                                      */                              
/*                                                                   */                              
/* Calls:                                                            */                              
/* -- Updates:                                                                                            
--   Date   Author     Purpose                                                                                            
--  8 August 2012 Rahul Aneja      To get the data for all the external provider  */    
/*  13 Dec 2012   Raghum           Fetched Column name from States table to dispaly all the Information, under task#211 In Primary Care Bugs/Features*/    
/*  08 May 2015   Venkatesh MR     Added new column LastName, FirstName, Address2, Suffix   for task VCAT 171*/    
/*********************************************************************/     
    
BEGIN    
    
 BEGIN TRY    
Select     
ERP.ExternalReferralProviderId,     
ERP.CreatedBy,     
ERP.CreatedDate,    
ERP.ModifiedBy,     
ERP.ModifiedDate,     
ERP.RecordDeleted,     
ERP.DeletedDate,     
ERP.DeletedBy,     
ERP.Type ,     
ERP.ExternalReferralProviderId as 'ExternalProviderId' ,     
ERP.Address,     
ERP.City,     
ERP.State,     
ERP.ZipCode,     
ERP.PhoneNumber,     
ERP.Fax,     
ERP.Email,     
ERP.Website,     
ERP.Active,     
ERP.DataEntryComplete,    
S.StateAbbreviation AS StateName      
,ERP.OrganizationName    
/*  08 May 2015   Venkatesh MR */    
,ERP.LastName    
,ERP.FirstName    
,ERP.Address2    
,ERP.Suffix    
,ISNULL(ERP.LastName,'') + ISNULL(ERP.FirstName, ERP.Name) as PhysicianName    
,ERP.Name as ExternalProviderIdText  
,GC.CodeName as TypeText  
FROM ExternalReferralProviders  ERP    
LEFT JOIN states S ON S.stateFIPS=  ERP.state   
INNER JOIN GlobalCodes GC ON GC.GlobalCodeId= ERP.Type     
WHERE (ERP.ExternalReferralProviderId = @ExternalReferralProviderId OR @ExternalReferralProviderId =0) AND ISNULL(ERP.RecordDeleted,'N')='N' ORDER by NAME ASC    
END TRY    
 BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)           
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                                
   + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'csp_GetExternalReferralProviders')                                                                                                 
   + '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                                  
   + '*****' + CONVERT(VARCHAR,ERROR_STATE())    
  RAISERROR    
  (    
   @Error, -- Message text.    
   16,  -- Severity.    
   1  -- State.    
  );    
 END CATCH     
 RETURN    
END    