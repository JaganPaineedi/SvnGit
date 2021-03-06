/****** Object:  UserDefinedFunction [dbo].[csf_GetGlobalCodeNameById]    Script Date: 06/19/2013 18:03:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_GetGlobalCodeNameById]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[csf_GetGlobalCodeNameById]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_GetGlobalCodeNameById]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[csf_GetGlobalCodeNameById] (@GlobalCodeId int) returns varchar(250)
/****************************************************************************************/
/* Simple function to get a global code name from a global code id.  Handy for use in	*/
/* reports.  Eliminates the need for several LEFT JOINs to the global codes table.		*/
/*																						*/
/* Warning: may have some performance problems when using with large number of rows		*/
/* because this proc will be called for each row.										*/
/*																						*/
/* Author: Tom Remisoski																*/
/* Date: 7/30/2008																		*/
/****************************************************************************************/
as
begin

declare @retval varchar(250)

select @retval = CodeName
from dbo.GlobalCodes
where GlobalCodeId = @GlobalCodeId

return @retval

end
' 
END
GO
