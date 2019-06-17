/****** Object:  UserDefinedFunction [dbo].[GetContactAddress]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetContactAddress]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetContactAddress]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetContactAddress]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'






CREATE FUNCTION [dbo].[GetContactAddress](

	@ClientContactId int 
	
)

RETURNS VARCHAR(200)
 AS  

BEGIN 

DECLARE @Address  varchar (200)
select  top 1 @Address =  address
from ClientContactAddresses where ClientContactId = @ClientContactId order by ContactAddressId


return @Address

END






' 
END
GO
