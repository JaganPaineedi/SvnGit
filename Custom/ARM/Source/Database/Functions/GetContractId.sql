/****** Object:  UserDefinedFunction [dbo].[GetContractId]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetContractId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetContractId]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetContractId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'







CREATE function [dbo].[GetContractId]
(
@ClientId int
)
returns varchar(500)
Begin
declare @strQry varchar(500)
set @strQry=''''
declare @cursorColumn varchar(500)
Declare Cur Cursor
For
SELECT     dbo.Contracts.ContractId
FROM         dbo.Insurers INNER JOIN
                      dbo.Contracts ON dbo.Insurers.InsurerId = dbo.Contracts.InsurerId INNER JOIN
                      dbo.InsurerPlans ON dbo.Insurers.InsurerId = dbo.InsurerPlans.InsurerId INNER JOIN
                      dbo.Clients INNER JOIN
                      dbo.ClientPlans ON dbo.Clients.ClientId = dbo.ClientPlans.ClientId ON dbo.InsurerPlans.InsurerPlanId = dbo.ClientPlans.InsurerPlanId
WHERE     dbo.Clients.ClientId =@ClientId
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
