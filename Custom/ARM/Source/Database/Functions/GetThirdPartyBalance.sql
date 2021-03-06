/****** Object:  UserDefinedFunction [dbo].[GetThirdPartyBalance]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetThirdPartyBalance]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetThirdPartyBalance]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetThirdPartyBalance]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'







CREATE FUNCTION  [dbo].[GetThirdPartyBalance](

	@CLIENTID  INT
	
)

RETURNS INT
 AS  

BEGIN 
DECLARE @ThirdPartyBalance int

select @ThirdPartyBalance = sum(ArLedger.Amount) 
	from clients,ArLedger 
	where ChargeId 
	in(select chargeId from Charges where serviceId 
	in (select ServiceId from Services where Services.ClientId
	in (select distinct C1.ClientId from clients C1)) and priority >0 )
	AND arledger.clientId = Clients.ClientId
	AND Clients.ClientId = @CLIENTID
	group by Clients.clientId




RETURN @ThirdPartyBalance


END








' 
END
GO
