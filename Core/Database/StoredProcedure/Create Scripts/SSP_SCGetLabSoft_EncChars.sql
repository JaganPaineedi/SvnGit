/****** Object:  StoredProcedure [dbo].[SSP_SCGetLabSoft_EncChars]    Script Date: 01/06/2015 12:28:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCGetLabSoft_EncChars]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_SCGetLabSoft_EncChars]
GO

/****** Object:  StoredProcedure [dbo].[SSP_SCGetLabSoft_EncChars]    Script Date: 01/06/2014 12:28:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_SCGetLabSoft_EncChars]
	@HL7EncodingChars nvarchar(5),
	@FieldChar varchar(1) output,
	@CompChar varchar(1) output,
	@RepeatChar varchar(1) output,
	@EscChar varchar(1) output,
	@SubCompChar varchar(1) output
AS
--=======================================
/* 
-- Created By : Gautam  
-- Get character from encoding chars
Declare @MessageRaw nVarchar(Max)
EXEC SSP_SCGetLabSoft_EncChars '!^~\&', @FieldChar output, @CompChar output, @RepeatChar output, @EscChar output, @SubCompChar output
Select @MessageRaw
*/
--=======================================
BEGIN
	SET @FieldChar  = SUBSTRING(@HL7EncodingChars,1,1)
	SET @CompChar  = SUBSTRING(@HL7EncodingChars,2,1)
	SET @RepeatChar  = SUBSTRING(@HL7EncodingChars,3,1)
	SET @EscChar  = SUBSTRING(@HL7EncodingChars,4,1)
	SET @SubCompChar = SUBSTRING(@HL7EncodingChars,5,1)
END


GO


