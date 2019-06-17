/****** Object:  UserDefinedFunction [dbo].[GetShortDateFormatForHL7]    Script Date: 02/21/2014 11:41:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetShortDateFormatForHL7]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetShortDateFormatForHL7]
GO

/****** Object:  UserDefinedFunction [dbo].[GetShortDateFormatForHL7]    Script Date: 02/21/2014 11:41:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[GetShortDateFormatForHL7](@Date DATETIME, @HL7EncodingChars nVarchar(5))  
RETURNS VARCHAR(26)  
BEGIN  
 DECLARE @CurrentDate VARCHAR(26)  
 SELECT @CurrentDate = dbo.HL7_OUTBOUND_XFORM(REPLACE(REPLACE(REPLACE(CONVERT(varchar(10), @Date, 121), '-', ''), ':', ''), ' ', ''), @HL7EncodingChars)  
 RETURN ISNULL(@CurrentDate,'')  
END  
GO


