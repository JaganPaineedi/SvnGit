/****** Object:  UserDefinedFunction [dbo].[GetOrderStartDate]    Script Date: 02/10/2014 16:46:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetOrderStartDate]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetOrderStartDate]
GO

/****** Object:  UserDefinedFunction [dbo].[GetOrderStartDate]    Script Date: 02/10/2014 16:46:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[GetOrderStartDate] (@datestring varchar(100))
RETURNS DATETIME
BEGIN
	DECLARE @FormattedDate DATETIME	
	SELECT @FormattedDate=CONVERT(DATETIME,STUFF(STUFF(STUFF(@datestring, 9, 0, ' '), 12, 0, ':'), 15, 0, ':'))
	RETURN @FormattedDate
END
GO


