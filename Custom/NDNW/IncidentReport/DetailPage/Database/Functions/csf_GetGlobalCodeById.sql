IF EXISTS (
    SELECT * FROM sysobjects WHERE id = object_id(N'csf_GetGlobalCodeById') 
    AND xtype IN (N'FN', N'IF', N'TF')
)
    DROP FUNCTION csf_GetGlobalCodeById
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[csf_GetGlobalCodeById] (@GlobalCodeId int) returns varchar(250)
/****************************************************************************************/
/* Simple function to get a global code  from a global code id.  Handy for use in	*/
/* reports.  Eliminates the need for several LEFT JOINs to the global codes table.		*/
/*																						*/
/* Warning: may have some performance problems when using with large number of rows		*/
/* because this proc will be called for each row.										*/
/*																						*/
/* Author: Veena S Mani															*/
/* Date: 02/03/2015																		*/
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


