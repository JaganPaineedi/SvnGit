/****** Object:  UserDefinedFunction [dbo].[GetlstCltPayment]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetlstCltPayment]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetlstCltPayment]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetlstCltPayment]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'







CREATE FUNCTION [dbo].[GetlstCltPayment](

	@PAYMENTID  INT
	
)

RETURNS varchar (200)

 AS  

BEGIN 

DECLARE @LSTCLTPAYMENT  VARCHAR(200)

SELECT @LSTCLTPAYMENT = ''$''+ convert(varchar,Payments.amount)+ ''  '' + Convert(varchar,Payments.DateReceived,101) 
FROM PAYMENTS WHERE PAYMENTID = @PAYMENTID


RETURN ISNULL(@LSTCLTPAYMENT,'' '')



END










' 
END
GO
