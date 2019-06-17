/****** Object:  UserDefinedFunction [dbo].[GetShortDateFormatForHL7]    Script Date: 16-01-2018 17:27:23 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[GetShortDateFormatForHL7]')
			AND type IN (
				N'FN'
				,N'IF'
				,N'TF'
				,N'FS'
				,N'FT'
				)
		)
	DROP FUNCTION [dbo].[GetShortDateFormatForHL7]
GO

/****** Object:  UserDefinedFunction [dbo].[GetShortDateFormatForHL7]    Script Date: 16-01-2018 17:27:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[GetShortDateFormatForHL7]')
			AND type IN (
				N'FN'
				,N'IF'
				,N'TF'
				,N'FS'
				,N'FT'
				)
		)
BEGIN
	EXECUTE dbo.sp_executesql @statement = N'
CREATE FUNCTION [dbo].[GetShortDateFormatForHL7] (
	@Date DATETIME
	,@HL7EncodingChars NVARCHAR(5)
	)
RETURNS VARCHAR(26)

BEGIN
	DECLARE @CurrentDate VARCHAR(26)

	SELECT @CurrentDate = dbo.HL7_OUTBOUND_XFORM(REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(10), @Date, 121), ''-'', ''''), '':'', ''''), '' '', ''''), @HL7EncodingChars)

	RETURN ISNULL(@CurrentDate, '''')
END
'
END
GO

/****** Object:  UserDefinedFunction [dbo].[GetShortDateFormatForHL7]    Script Date: 08/17/2017 11:57:11 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[GetShortDateFormatForHL7]')
			AND type IN (
				N'FN'
				,N'IF'
				,N'TF'
				,N'FS'
				,N'FT'
				)
		)
	DROP FUNCTION [dbo].[GetShortDateFormatForHL7]
GO

/****** Object:  UserDefinedFunction [dbo].[GetShortDateFormatForHL7]    Script Date: 08/17/2017 11:57:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[GetShortDateFormatForHL7] (
	@Date DATETIME
	,@HL7EncodingChars NVARCHAR(5)
	)
RETURNS VARCHAR(26)

BEGIN
	DECLARE @CurrentDate VARCHAR(26)

	SELECT @CurrentDate = dbo.HL7_OUTBOUND_XFORM(REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(10), @Date, 121), '-', ''), ':', ''), ' ', ''), @HL7EncodingChars)

	RETURN ISNULL(@CurrentDate, '')
END
GO


