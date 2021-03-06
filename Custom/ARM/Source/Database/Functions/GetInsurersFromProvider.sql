/****** Object:  UserDefinedFunction [dbo].[GetInsurersFromProvider]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInsurersFromProvider]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetInsurersFromProvider]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInsurersFromProvider]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'







CREATE function [dbo].[GetInsurersFromProvider]
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
select distinct insurers.insurerid as insurerid from 
ProviderAuthorizations inner join ProviderInsurers on ProviderAuthorizations.ProviderId=ProviderInsurers.ProviderId inner join insurers 
on ProviderInsurers.insurerid=insurers.insurerid where isnull(ProviderAuthorizations.RecordDeleted,''N'')=''N'' and ProviderAuthorizations.ProviderAuthorizationId=@AuthorizationId
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
