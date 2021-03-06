/****** Object:  UserDefinedFunction [dbo].[csf_DateTimeToString]    Script Date: 06/19/2013 18:03:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_DateTimeToString]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[csf_DateTimeToString]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_DateTimeToString]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
create function [dbo].[csf_DateTimeToString](@inDate datetime) returns varchar(24) as
/********************************************************************************
-- Function: dbo.csf_DateTimeToString
--
-- Copyright: Streamline Healthcate Solutions
--
-- Purpose: Converts a datetime into a user-friendly string format
--
-- Called by: Harbor note initialization stored procedures.
--
-- Updates:
-- Date              Author      Purpose
-- 04.18.2012		T. Remisoski	Created
*********************************************************************************/

begin

declare @retval varchar(24)

if @inDate is not null
	set @retval = case when DATEPART(MONTH, @inDate) < 10 then ''0'' else '''' end + CAST(DATEPART(MONTH, @inDate) as varchar)
		+ ''/'' + case when DATEPART(DAY, @inDate) < 10 then ''0'' else '''' end + CAST(DATEPART(DAY, @inDate) as varchar)
		+ ''/'' + CAST(DATEPART(year, @inDate) as varchar)
		+ '' '' + case when DATEPART(hour, @inDate) not in (0, 10, 11, 12, 22, 23) then ''0'' else '''' end + case when DATEPART(hour, @inDate) = 0 then ''12'' when DATEPART(hour, @inDate) > 12 then CAST(DATEPART(hour, @inDate) - 12 as varchar) else CAST(DATEPART(hour, @inDate) as varchar) end
		+ '':'' + case when DATEPART(minute, @inDate) < 10 then ''0'' else '''' end + CAST(DATEPART(minute, @inDate) as varchar)
		+ '' '' + case when DATEPART(hour, @inDate) < 12 then ''a.m.'' else ''p.m.'' end
		
return @retval

end
' 
END
GO
