/****** Object:  UserDefinedFunction [dbo].[ssf_SureScriptsFormatDate]    Script Date: 06/19/2013 18:03:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssf_SureScriptsFormatDate]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ssf_SureScriptsFormatDate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssf_SureScriptsFormatDate]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
create function [dbo].[ssf_SureScriptsFormatDate] (
	@inDateTime datetime
)
returns varchar(8)
as
begin

return cast(datepart(year, @inDateTime) as varchar)
	+ case when datepart(month, @inDateTime) < 10 then ''0'' else '''' end + cast(datepart(month, @inDateTime) as varchar)
	+ case when datepart(day, @inDateTime) < 10 then ''0'' else '''' end + cast(datepart(day, @inDateTime) as varchar)

end

' 
END
GO
