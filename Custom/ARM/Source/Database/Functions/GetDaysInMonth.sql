/****** Object:  UserDefinedFunction [dbo].[GetDaysInMonth]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDaysInMonth]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetDaysInMonth]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDaysInMonth]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'




CREATE FUNCTION [dbo].[GetDaysInMonth] (@currentmonth int,@currentyear int)  
RETURNS int  AS  
BEGIN 
	declare @fulldate varchar(20)
	declare @TotalDays int
	set @fulldate = cast(@currentmonth as varchar) + ''/'' + ''1'' + ''/'' + cast(@currentyear as varchar)  
	set   @TotalDays = datediff(DAY,@fulldate,dateadd(MONTH,1,@fulldate))
	return @TotalDays

END





' 
END
GO
