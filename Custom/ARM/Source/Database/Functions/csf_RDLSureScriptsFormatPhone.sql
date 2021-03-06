/****** Object:  UserDefinedFunction [dbo].[csf_RDLSureScriptsFormatPhone]    Script Date: 06/19/2013 18:03:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_RDLSureScriptsFormatPhone]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[csf_RDLSureScriptsFormatPhone]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_RDLSureScriptsFormatPhone]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'


create function [dbo].[csf_RDLSureScriptsFormatPhone] (
/*****************************************************************************************************/
/*
Scalar Function: dbo.csf_RDLSureScriptsFormatPhone

Copyright: 2011 Streamline Healthcare Solutions, LLC

Creation Date:  2011.03.04

Purpose:
	Format a phone number from SmartCareRx into something Surescripts will accept

Input Parameters:
   @inPhone varchar(100)	-- SmartCareRx phone number

Output Parameters: 

Return:
	Return value as varchar(35)

Calls:

Called by:
	SmartCareRx Surescripts messaging stored procedures.

Log:
	2011.03.04 - Created.
*/
/*****************************************************************************************************/
	@inPhone varchar(100)
)
returns varchar(35)
as
begin

declare @retval varchar(35)

if len(@inPhone) > 7
   set @retval = substring(@inPhone, 1, 3) + ''-'' + substring(@inPhone, 4, 3) + ''-'' + substring(@inPhone, 7, 100)
else if len(@inPhone) = 7
   set @retval = substring(@inPhone, 1, 3) + ''-'' + substring(@inPhone, 4, 4)
else
   set @retval = @inPhone


return @retval

end


' 
END
GO
