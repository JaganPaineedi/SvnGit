/****** Object:  StoredProcedure [dbo].[csp_DWPMCheckLoginStaff]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_DWPMCheckLoginStaff]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_DWPMCheckLoginStaff]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_DWPMCheckLoginStaff]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_DWPMCheckLoginStaff]                       
(                
 @UserCode varchar(30),                
 @UserPassword varchar(50)                             
)                
                
As  
/*********************************************************************/                          
/* Stored Procedure: dbo.csp_DWPMCheckLoginStaff                */                 
                
/* Copyright: 2007 Provider Access Application-DataWizard:Access Center  */                          
                
/* Creation Date:  12/09/2007                                   */                          
/*                                                                   */                          
/* Purpose: Gets UserId, UserCode, FirstName,RowIdentifier, Administrator,  
AllProviders, PrimaryProviderId, PrimaryRole, ProviderName, NumberOfRecordsDisplayed  from Users Table  */                         
/*                                                                   */                        
/* Input Parameters: @UserCode, @UserPassword */                        
/*                                                                   */                           
/* Output Parameters:                                */                          
/*                                                                   */                          
/* Return:   */                          
/*                                                                   */                          
/* Called By: AuthenticateUser(string userCode, string userPassword) Method in Login Class Of DataService  in "StreamLine Provider Access Application"  */                
/*      */                
                
/*                                                                   */                          
/* Calls:                                                            */                          
/*                                                                   */                          
/* Data Modifications:                                               */                          
/*                                                                   */                          
/*   Updates:                                                          */                          
                
/*       Date              Author                  Purpose                                    */                          
/*********************************************************************/                           
  
Begin Try  
 Declare @varOutput int               
    set @varOutput=0                    
  
-- if(select PasswordExpiresNextLogin from Users where UserCode=@UserCode and   
-- UserPassword= @UserPassword and isNull(RecordDeleted,''N'')=''N'')=''Y''                
-- begin                       
--  --set @varOutPut=1 means password expires next login             
--  set @varOutput=1              
-- end    
--             
-- --check for expiration date                
-- if(select datediff(dd,getdate(),PasswordExpirationDate) from Users where UserCode=@UserCode   
-- and UserPassword= @UserPassword and PasswordExpiresNextLogin <>''Y'' and isNull(RecordDeleted,''N'')=''N'')< 0                
-- begin                
--  -- " 2 means password is expired"                
--  set @varOutput=2              
-- end                
--     
-- --check for all providers and any providers  
-- if(select isNull(AllProviders,''N'') from Users where UserCode=@UserCode and UserPassword= @UserPassword and isNull(RecordDeleted,''N'')=''N'')=''N''  
-- begin  
--  if not exists(select ups.UserProviderId, ups.ProviderId from UserProviders ups inner join Users us  
--  on ups.UserId = us.UserId inner join Providers p on ups.ProviderId = p.ProviderId  
--  where us.UserCode=@UserCode and us.UserPassword= @UserPassword and p.Active = ''Y'' and isnull(p.RecordDeleted,''N'')=''N''  
--  and isNull(us.RecordDeleted,''N'')=''N'' and isNull(ups.RecordDeleted,''N'')=''N'')  
--  begin  
--   -- " 3 means user is not associated with all provider and any providers  
--  set @varOutput=3  
--  end   
-- end  
--   
-- --check whether user is allowed to login provider access or not  
-- if(select isNull(ProviderAccessLogin, ''N'') from Users where UserCode=@UserCode and   
--  UserPassword= @UserPassword and isNull(RecordDeleted,''N'')=''N'') = ''N''  
-- begin  
--  -- "4 means user is not associated with provider access  
--  set @varOutput=4  
-- end  
    
  
-- if @varOutput = 0 --Added by Ashish Kumar Jauhari on 04-07-2007  
-- begin  
--  update Users set LastVisit = getdate() where UserCode=@UserCode and   
--  UserPassword =@UserPassword and isNull(RecordDeleted,''N'')=''N''  
-- end  
          
 select StaffId, UserCode, FirstName, LastName from Staff   
 where UserCode=@UserCode and UserPassword =@UserPassword   
 and isNull(RecordDeleted,''N'')=''N'' and Active=''Y''  
                
End Try  
Begin Catch    
 declare @Error varchar(8000)  
 set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())   
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_DWPMCheckLoginStaff'')   
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())    
    + ''*****'' + Convert(varchar,ERROR_STATE())  
     
 RAISERROR   
 (  
  @Error, -- Message text.  
  16, -- Severity.  
  1 -- State.  
 );  
                                           
End Catch
' 
END
GO
