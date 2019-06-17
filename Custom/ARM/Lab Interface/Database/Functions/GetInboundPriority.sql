/****** Object:  UserDefinedFunction [dbo].[GetInboundPriority]    Script Date: 02/10/2014 16:54:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInboundPriority]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetInboundPriority]
GO

/****** Object:  UserDefinedFunction [dbo].[GetInboundPriority]    Script Date: 02/10/2014 16:54:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[GetInboundPriority](@Priority Char(1))
RETURNS INT
BEGIN
	DECLARE @PriorityValue INT
	SELECT @PriorityValue = CASE @Priority
								WHEN 'R' THEN 8510
								WHEN 'A' THEN 8511
							END
	RETURN @PriorityValue							
END
GO


