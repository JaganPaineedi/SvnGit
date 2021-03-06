/****** Object:  UserDefinedFunction [dbo].[csf_QODateFormat]    Script Date: 06/19/2013 18:03:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_QODateFormat]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[csf_QODateFormat]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_QODateFormat]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'create function [dbo].[csf_QODateFormat] (@d datetime) returns varchar(10) as
begin

	return case when month(@d) < 10 then ''0'' else '''' end + cast(month(@d) as varchar) + ''/''
		+ case when day(@d) < 10 then ''0'' else '''' end + cast(day(@d) as varchar) + ''/''
		+ cast(year(@d) as varchar)

end
' 
END
GO
