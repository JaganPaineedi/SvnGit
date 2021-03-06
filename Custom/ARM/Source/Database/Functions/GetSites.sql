/****** Object:  UserDefinedFunction [dbo].[GetSites]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetSites]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetSites]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetSites]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'







CREATE function [dbo].[GetSites]
(
@AuthorizationId int
)
returns varchar(500)
Begin
declare @strQry varchar(500)
set @strQry=''''
declare @cursorColumn varchar(500)
Declare Cur Cursor
For
SELECT      dbo.Sites.SiteId
FROM         dbo.ProviderAuthorizations INNER JOIN
                      dbo.Providers ON dbo.ProviderAuthorizations.ProviderId = dbo.Providers.ProviderId INNER JOIN
                      dbo.Sites ON dbo.Providers.ProviderId = dbo.Sites.ProviderId
WHERE    dbo.ProviderAuthorizations.ProviderAuthorizationId = @AuthorizationId
OPEN Cur

FETCH from Cur INTO @cursorColumn
WHILE (@@FETCH_STATUS = 0) 
BEGIN 

set @strQry = @strQry + @cursorColumn+'',''


FETCH from Cur INTO @cursorColumn
END
set @strQry='','' + @strQry
--set @strQry=left(@StrQry,len(@StrQry)-1)

 CLOSE Cur
 DEALLOCATE Cur
return @strQry
End




















' 
END
GO
