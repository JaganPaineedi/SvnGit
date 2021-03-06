/****** Object:  UserDefinedFunction [dbo].[GetUserRoleAllowColumn]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetUserRoleAllowColumn]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetUserRoleAllowColumn]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetUserRoleAllowColumn]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'









/*********************************************************************/              
/*Function: dbo.GetUserRoleAllowColumn           */              
/* Copyright: 2005 Provider Claim Management System             */              
/* Creation Date:  12/9/2005                                    */              
/*                                                                   */              
/* Purpose: it will get User Selected Column            */             
/*                                                                   */            
/* Output Parameters:        AllowColumn                        */              
/*                                                                   */              
/* Called By:                                                        */              
/*                                                                   */              
/* Calls:                                                            */              
/*                                                                   */              
/* Data Modifications:                                               */              
/*                                                                   */              
/* Updates:                                                          */              
/*  Date        	 Author      Purpose                                    */              
/* 12/9/2005   Tarunjeet Singh      Created                                    */              
CREATE FUNCTION [dbo].[GetUserRoleAllowColumn](@UserId int,@RoleId int)  
RETURNS varchar(15) AS  
BEGIN 
Declare @AllowColumn as varchar(15)
set @AllowColumn=(SELECT     TOP 1 ''Y'' AS Expr1
FROM         UserRoles
WHERE     (UserId = @UserId) AND (ISNULL(RecordDeleted, ''N'') <> ''Y'') AND (Role = @RoleId))
if(isnull(@AllowColumn,''N'')<>''Y'')
begin
set @AllowColumn=''N''
end
else
begin
set @AllowColumn=''Y''
end

return @AllowColumn

END



































































' 
END
GO
