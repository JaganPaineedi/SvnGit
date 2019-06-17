IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_GetGlobalCodeExternalCode1ById]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[csf_GetGlobalCodeExternalCode1ById]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[csf_GetGlobalCodeExternalCode1ById] (@GlobalCodeId int) returns varchar(250)
/****************************************************************************************/
/* Simple function to get a global code external code from a global code id.  Handy for use in	*/
/* reports.  Eliminates the need for several LEFT JOINs to the global codes table.		*/
/*																						*/
/* Warning: may have some performance problems when using with large number of rows		*/
/* because this proc will be called for each row.										*/
/*																						*/
/* Author: Joe Neylon																*/
/* Date: 3/4/2013																	*/
/****************************************************************************************/
as
begin

declare @retval varchar(250)

select @retval = ExternalCode1
from dbo.GlobalCodes
where GlobalCodeId = @GlobalCodeId

return @retval

end


GO


