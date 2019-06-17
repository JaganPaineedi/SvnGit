/****** Object:  UserDefinedFunction [dbo].[getFeeArrangement]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[getFeeArrangement]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[getFeeArrangement]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[getFeeArrangement]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'



























CREATE function [dbo].[getFeeArrangement](@varClientId int) returns varchar(1000)
As
Begin
	declare @str varchar(1000)
	set @str=(select FeeArrangement from ClientFinancialSummaryReports where clientid=@varClientId )
	return @str;
End






































' 
END
GO
