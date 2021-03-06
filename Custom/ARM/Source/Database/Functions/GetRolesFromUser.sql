/****** Object:  UserDefinedFunction [dbo].[GetRolesFromUser]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetRolesFromUser]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetRolesFromUser]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetRolesFromUser]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'









CREATE function [dbo].[GetRolesFromUser] 
(
@UserID int
)
returns varchar(200)

/*********************************************************************/              
/*Function: dbo.ssp_GetRolesFromUser           */              
/* Copyright: 2005 Provider Claim Management System             */              
/* Creation Date:  14/12/2005                                    */              
/*                                                                   */              
/* Purpose: returns different Roles of User in a string       */             
/*                                                                   */            
/* Output Parameters:     strRoles                    */              
/*                                                                   */              
/* Called By:                                                        */              
/*                                                                   */              
/* Calls:                                                            */              
/*                                                                   */              
/* Data Modifications:                                               */              
/*                                                                   */              
/* Updates:                                                          */              
/*  Date        	 Author                   Purpose                        */              
/* 14/12/2005   Bhupinder Bajwa      Created                       */              

Begin
declare @strRoles varchar(200)
set @strRoles=''''
declare @cursorColumn varchar(200)
Declare Cur Cursor
For Select distinct UserRoles.Role as UserRole From UserRoles where isnull(UserRoles.RecordDeleted,''N'')=''N'' and UserRoles.UserId=@UserID

OPEN Cur

FETCH from Cur INTO @cursorColumn
WHILE (@@FETCH_STATUS = 0) 
BEGIN 

Set @strRoles = @strRoles + @cursorColumn+'',''


FETCH from Cur INTO @cursorColumn
END
Set @strRoles='','' + @strRoles


 CLOSE Cur
 DEALLOCATE Cur
Return @strRoles
End










' 
END
GO
