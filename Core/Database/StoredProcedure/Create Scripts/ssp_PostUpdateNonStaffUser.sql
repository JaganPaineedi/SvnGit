
GO

/****** Object:  StoredProcedure [dbo].[ssp_PostUpdateNonStaffUser]    Script Date: 06/17/2015 05:57:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PostUpdateNonStaffUser]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PostUpdateNonStaffUser]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_PostUpdateNonStaffUser]    Script Date: 06/17/2015 05:57:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


Create proc [dbo].[ssp_PostUpdateNonStaffUser]     
	@ScreenKeyId int,                  
	@StaffId int,                  
	@CurrentUser varchar(30),                  
	@CustomParameters xml                   
as                                                
/*********************************************************************/                                                
/* Stored Procedure: dbo.ssp_PostUpdateNonStaffUser                         */                                                
/* Creation Date:    24/09/2010                                         */                                                
/*                                                                   */                                                
/* Purpose:           */                                                
/*                                                                   */                                                 
/* Input Parameters:           */                                                
/*                                                                   */                                                
/* Output Parameters:                                                */                                                
/*                                                                   */                                                
/* Return Status:                                                    */                                                
/*                                                                   */                                                
/* Called By:       */                                                
/*                                                                   */                                                
/* Calls:                                                            */                                                
/*                                                                   */                                                
/* Data Modifications:                                               */                                                
/*                                                                   */                                                
/* Updates:                                                          */                                                
/*   Date						Author        Purpose                                    */                                                 
/*   May 15 2014                Pradeep.A     Created for NonStaff User Screen To Update StaffId In Clients Table.                                    */                                                
--   16 Jun 2014				Pradeep A		What : Changed StaffId to UserStaffId for releasing PPA. 
--   6 Nov 2014				    Varun		What : Logic for updating UserStaffId in Clients table.                                                                              
/*********************************************************************/                                             
  
BEGIN  
   
 Begin TRY  
  Declare @NonStaffClientId Int
  Declare @NonStaffContactId Int
  set @NonStaffClientId = @CustomParameters.value('(/Root/Parameters/@ClientId)[1]', 'Int')    
  set @NonStaffContactId = @CustomParameters.value('(/Root/Parameters/@ClientContactId)[1]', 'Int')
  BEGIN
  IF(@NonStaffContactId is null OR @NonStaffContactId = '')
  BEGIN
   Update C 
   set C.UserStaffId=@ScreenKeyId,  
   C.ModifiedBy=@CurrentUser,  
   C.ModifiedDate=GETDATE()  
   From Clients C
   Where C.Clientid = @NonStaffClientId 
   END 
   ELSE
   BEGIN
	Update C 
   set C.UserStaffId=NULL,  
   C.ModifiedBy=@CurrentUser,  
   C.ModifiedDate=GETDATE()  
   From Clients C
   Where C.Clientid = @NonStaffClientId 
   END
  END  
 END TRY  
 BEGIN CATCH  
    
  DECLARE @Error varchar(8000)                                
  SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())   
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_PostUpdateNonStaffUser')   + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())    
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

