/****** Object:  UserDefinedFunction [dbo].[GetOrderStatus]    Script Date: 02/10/2014 16:22:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetOrderStatus]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetOrderStatus]
GO

/****** Object:  UserDefinedFunction [dbo].[GetOrderStatus]    Script Date: 02/10/2014 16:22:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[GetOrderStatus](@OrderStatus Char(10))
RETURNS INT
BEGIN
	Declare @OrderStatusValue Int
	SELECT @OrderStatusValue= CASE @OrderStatus
								WHEN 'CM' THEN 6508
								WHEN 'NW' THEN 6509
								WHEN 'DC' THEN 6510
							  END
	RETURN 	@OrderStatusValue						  
END
GO


