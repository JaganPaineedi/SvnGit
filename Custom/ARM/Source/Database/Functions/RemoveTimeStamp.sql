/****** Object:  UserDefinedFunction [dbo].[RemoveTimeStamp]    Script Date: 06/19/2013 18:03:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RemoveTimeStamp]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[RemoveTimeStamp]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RemoveTimeStamp]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE function [dbo].[RemoveTimeStamp]
( @InputDate datetime )

Returns datetime

As
Begin
declare @TrimmedDate	datetime

select @TrimmedDate = convert(datetime,
convert(varchar(2),datepart(mm,@inputDate) ) + ''/'' +
convert(varchar(2),datepart(dd,@inputDate) ) + ''/'' +
convert(char(4),datepart(yyyy,@inputDate) ) )

return @TrimmedDate

End
' 
END
GO
