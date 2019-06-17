/****** Object:  UserDefinedFunction [dbo].[GetFinancialActId]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFinancialActId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetFinancialActId]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFinancialActId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'







CREATE FUNCTION  [dbo].[GetFinancialActId](

	@PAYMENTID INT
	
)

RETURNS INT
 AS  

BEGIN 
DECLARE @FINANCIALACTID INT

--DECLARE @CURDATE DATETIME

--DECLARE @myDateTime DATETIME

 --SELECT @myDateTime = Date FROM CurrentDate



select @FINANCIALACTID=  FinancialActivityId from payments
where PaymentId = @PAYMENTID


RETURN @FINANCIALACTID


END








' 
END
GO
