

/****** Object:  UserDefinedFunction [dbo].[ssf_GetGlobalCodeCODEById]    Script Date: 8/20/2018 3:53:49 AM ******/
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'ssf_GetGlobalCodeCODEById')
	BEGIN
		DROP FUNCTION [dbo].[ssf_GetGlobalCodeCODEById]
	END
GO

/****** Object:  UserDefinedFunction [dbo].[ssf_GetGlobalCodeCODEById]    Script Date: 8/20/2018 3:53:49 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



create FUNCTION [dbo].[ssf_GetGlobalCodeCODEById] (@GlobalCodeId int) returns varchar(250)
/****************************************************************************************/
/* Simple function to get a global code name from a global code id.  Handy for use in	*/
/* reports.  Eliminates the need for several LEFT JOINs to the global codes table.		*/
/*																						*/
/* Warning: may have some performance problems when using with large number of rows		*/
/* because this proc will be called for each row.										*/
/*																						*/
/* Author: Chethan N																*/
/* Date: 08/20/2018																		*/
/****************************************************************************************/
as
begin

declare @retval varchar(250)

select @retval = Code
from dbo.GlobalCodes
where GlobalCodeId = @GlobalCodeId

return @retval

end


GO


