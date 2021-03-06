/****** Object:  UserDefinedFunction [dbo].[GetUserInsurerPrimaryColumn]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetUserInsurerPrimaryColumn]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetUserInsurerPrimaryColumn]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetUserInsurerPrimaryColumn]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'









/*********************************************************************/              
/*Function: dbo.GetUserInsurerPrimaryColumn           */              
/* Copyright: 2005 Provider Claim Management System             */              
/* Creation Date:  12/9/2005                                    */              
/*                                                                   */              
/* Purpose: it will get User Insurer PrimaryColumn            */             
/*                                                                   */            
/* Output Parameters:        PrimaryColumn                        */              
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
CREATE FUNCTION [dbo].[GetUserInsurerPrimaryColumn](@UserId int,@InsurerId int)  
RETURNS varchar(15) AS  
BEGIN 
Declare @PrimaryColumn as varchar(50)
set @PrimaryColumn=(SELECT     TOP 1 ''Y'' AS PrimaryColumn
FROM         Users INNER JOIN
                      UserInsurers ON Users.UserId = UserInsurers.UserId
WHERE     (Users.UserId = @UserId) AND (Users.PrimaryInsurerId = @InsurerId) AND (ISNULL(Users.RecordDeleted, ''N'') <> ''Y'') AND (ISNULL(UserInsurers.RecordDeleted, ''N'') 
                      <> ''Y''))
if(isnull(@PrimaryColumn,''N'')<>''Y'')
begin
set @PrimaryColumn=''N''
end
else
begin
set @PrimaryColumn=''Y''
end
return @PrimaryColumn

END



































































' 
END
GO
