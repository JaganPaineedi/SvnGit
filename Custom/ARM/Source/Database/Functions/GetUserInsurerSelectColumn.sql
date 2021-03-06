/****** Object:  UserDefinedFunction [dbo].[GetUserInsurerSelectColumn]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetUserInsurerSelectColumn]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetUserInsurerSelectColumn]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetUserInsurerSelectColumn]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'









/*********************************************************************/              
/*Function: dbo.GetUserInsurerSelectColumn           */              
/* Copyright: 2005 Provider Claim Management System             */              
/* Creation Date:  12/9/2005                                    */              
/*                                                                   */              
/* Purpose: it will get User Selected Column            */             
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
CREATE FUNCTION [dbo].[GetUserInsurerSelectColumn](@UserId int,@InsurerId int)  
RETURNS varchar(15) AS  
BEGIN 
Declare @SelectColumn as varchar(50)
set @SelectColumn=(SELECT     TOP 1 ''Y'' AS SelectColumn
FROM         UserInsurers
WHERE     (UserId = @UserId) AND (InsurerId = @InsurerId) AND (ISNULL(RecordDeleted, ''N'') <> ''Y''))
if(isnull(@SelectColumn,''N'')<>''Y'')
begin
set @SelectColumn=''N''
end
else
begin
set @SelectColumn=''Y''
end
return @SelectColumn

END



































































' 
END
GO
