/****** Object:  UserDefinedFunction [dbo].[ssf_GetExchangeSettingsXML]    Script Date: 05/21/2012 11:59:31 ******/
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssf_GetExchangeSettingsXML]')
                    AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
    DROP FUNCTION [dbo].[ssf_GetExchangeSettingsXML]
GO

/****** Object:  UserDefinedFunction [dbo].[ssf_GetExchangeSettingsXML]    Script Date: 05/21/2012 11:59:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Wasif Butt
-- Create date: 5/21/2012
-- Description:	Returns the Exchange settings xml for outlook integration
-- =============================================
CREATE FUNCTION [dbo].[ssf_GetExchangeSettingsXML] ( )
RETURNS XML
AS 
    BEGIN
	-- Declare the return variable here
        DECLARE @ExchangeSettingsXML XML

-- Select XML:

SET @ExchangeSettingsXML = (SELECT top 1 convert(xml, '<?xml version="1.0" ?> 
<ExchangeSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <Username>' + isnull(dbo.ssf_GetSystemConfigurationKeyValue('ExchangeUserName'), '') + '</Username> 
  <Password>' + isnull(dbo.ssf_GetSystemConfigurationKeyValue('ExchangePassword'), '') + '</Password> 
  <Domain>' + isnull(dbo.ssf_GetSystemConfigurationKeyValue('ExchangeDomain'), '') + '</Domain> 
  <ExchangeURL>' + isnull(dbo.ssf_GetSystemConfigurationKeyValue('ExchangeURL'), '') + '</ExchangeURL> 
  <VerifyCertificate>' + isnull(dbo.ssf_GetSystemConfigurationKeyValue('ExchangeVerifyCertificate'), '') + '</VerifyCertificate> 
  </ExchangeSettings>'))

	-- Return the result of the function
        RETURN @ExchangeSettingsXML
    END
GO


