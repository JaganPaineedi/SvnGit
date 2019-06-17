 
 /****** Object:  StoredProcedure [dbo].[ssp_UpdateProviderAuthorizationDefault]    Script Date: 08/09/2015 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_UpdateProviderAuthorizationDefault]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_UpdateProviderAuthorizationDefault]
GO

/****** Object:  StoredProcedure [dbo].[ssp_UpdateProviderAuthorizationDefault]    Script Date: 08/09/2015 
-- Created:           
-- Date			Author				Purpose 
  
  14-Sept-2015   SuryaBalan			Created this ssp to override before saving Authorization Defaults
									Network 180 - Customizations #602 
									*********************************************************************************/  
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
 
CREATE  procedure [dbo].[ssp_UpdateProviderAuthorizationDefault]  
(  
 @ProviderAuthorizationDefaultId int,
 @UserCode VARCHAR(MAX)  

)  
as  
       
Begin  

  
--Checking For Errors  
If (@@error!=0)  Begin RAISERROR  20006   'ssp_UpdateProviderAuthorizationDefault  : An Error Occured'    Return  End              
  
 
update ProviderAuthorizationDefaultProviderSites set RecordDeleted='Y',DeletedBy=@UserCode,DeletedDate=GetDate() where ProviderAuthorizationDefaultId=@ProviderAuthorizationDefaultId  

update ProviderAuthorizationDefaultAuthorizationCodes set RecordDeleted='Y',DeletedBy=@UserCode,DeletedDate=GetDate() where ProviderAuthorizationDefaultId=@ProviderAuthorizationDefaultId  

update ProviderAuthorizationDefaultBillingCodes set RecordDeleted='Y',DeletedBy=@UserCode,DeletedDate=GetDate() where ProviderAuthorizationDefaultId=@ProviderAuthorizationDefaultId  
  


End  
  