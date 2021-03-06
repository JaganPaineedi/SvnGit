/****** Object:  UserDefinedFunction [dbo].[GetBillingCodeButtonStatus]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetBillingCodeButtonStatus]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetBillingCodeButtonStatus]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetBillingCodeButtonStatus]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [dbo].[GetBillingCodeButtonStatus]   
(  
 -- Add the parameters for the function here  
 @AuthorizationCodeId int,
 @SiteId	int  
)  
RETURNS char(1)  
AS  
BEGIN  
 /*********************************************************************                                
-- Stored Procedure: dbo.ssp_SCWebGetClienUMNotes                      
-- Copyright: Streamline Healthcare Solutions                      
--                                                                       
-- Purpose: Get Client UM Notes based on Client Id            
-- Description: Restuns Status                                                                                                       
-- Modified Date    Modified By       Purpose                      
-- 12/1/2011        Rakesh           Created                    
                               
****************************************************************************/                 
 Declare @status as char(1)    
     
     
 set @status=''N''    
 if (@SiteId is not null)
 BEGIN   
 if exists (select AuthorizationCodeBillingCodeId from AuthorizationCodeBillingCodes where AuthorizationCodeId=    
 @AuthorizationCodeId and ISNULL(RecordDeleted,''N'')<>''Y'')    
 Begin    
 set @status=''Y''    
 End    
 else if exists(select authorizationcodeid from AuthorizationCodes where AuthorizationCodeId=    
 @AuthorizationCodeId and Isnull(AuthorizationCodes.ClinicianMustSpecifyBillingCode,''N'')=''Y'' and ISNULL(RecordDeleted,''N'')<>''Y'')    
 Begin    
set @status=''Y''    
 End    
 else    
 set @status=''N''    
 
 END    
  
              
                              
    
 RETURN @status  
END  
' 
END
GO
