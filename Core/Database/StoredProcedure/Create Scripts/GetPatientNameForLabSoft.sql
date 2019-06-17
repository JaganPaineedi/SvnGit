/****** Object:  UserDefinedFunction [dbo].[GetPatientNameForLabSoft]    Script Date: 09/10/2015 13:09:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPatientNameForLabSoft]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetPatientNameForLabSoft]
GO

/****** Object:  UserDefinedFunction [dbo].[GetPatientNameForLabSoft]    Script Date: 09/10/2015 13:09:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[GetPatientNameForLabSoft](@ClientId Int,@EncodingChars nVarchar(5))
RETURNS nVarchar(250)
BEGIN
DECLARE @PatientName nvarchar(250)

 	DECLARE @FieldChar char 
	DECLARE @CompChar char
	DECLARE @RepeatChar char
	DECLARE @EscChar char
	DECLARE @SubCompChar char
	
	SET @FieldChar  = SUBSTRING(@EncodingChars,1,1)
	SET @CompChar  = SUBSTRING(@EncodingChars,2,1)
	SET @RepeatChar  = SUBSTRING(@EncodingChars,3,1)
	SET @EscChar  = SUBSTRING(@EncodingChars,4,1)
	SET @SubCompChar = SUBSTRING(@EncodingChars,5,1)
	
	SELECT @PatientName= dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(CL.LastName,''),@EncodingChars)+@FieldChar+dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(CL.FirstName,''),@EncodingChars) from 
	Clients CL Where CL.ClientId=@ClientId
	RETURN ISNULL(@PatientName,'')
END

GO


