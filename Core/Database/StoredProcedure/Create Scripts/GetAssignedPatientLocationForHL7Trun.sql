/****** Object:  UserDefinedFunction [dbo].[GetAssignedPatientLocationForHL7Trun]    Script Date: 09/06/2015 17:48:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetAssignedPatientLocationForHL7Trun]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetAssignedPatientLocationForHL7Trun]
GO

/****** Object:  UserDefinedFunction [dbo].[GetAssignedPatientLocationForHL7Trun]    Script Date: 09/06/2015 17:48:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[GetAssignedPatientLocationForHL7Trun](@ClientId INT,@HL7EncodingChars nVarchar(5))
RETURNS NVarchar(250)
BEGIN
	DECLARE @AssignedPatientLocation VARCHAR(250)
	
	-- pull hl7 esc chars 
	DECLARE @FieldChar char 
	DECLARE @CompChar char
	DECLARE @RepeatChar char
	DECLARE @EscChar char
	DECLARE @SubCompChar char
	
	SET @FieldChar  = SUBSTRING(@HL7EncodingChars,1,1)
	SET @CompChar  = SUBSTRING(@HL7EncodingChars,2,1)
	SET @RepeatChar  = SUBSTRING(@HL7EncodingChars,3,1)
	SET @EscChar  = SUBSTRING(@HL7EncodingChars,4,1)
	SET @SubCompChar = SUBSTRING(@HL7EncodingChars,5,1)
	
	SELECT @AssignedPatientLocation= dbo.HL7_OUTBOUND_XFORM(ISNULL(U.UnitName,''),@HL7EncodingChars)+@CompChar+dbo.HL7_OUTBOUND_XFORM(ISNULL(R.RoomName,''),@HL7EncodingChars)+@CompChar+dbo.HL7_OUTBOUND_XFORM(ISNULL(B.BedName,''),@HL7EncodingChars)
		FROM ClientInpatientVisits CIV
		JOIN BedAssignments BA ON BA.ClientInpatientVisitId=CIV.ClientInpatientVisitId
		JOIN Beds B ON B.BedId = BA.BedId
		JOIN Rooms R ON R.RoomId=B.RoomId
		JOIN Units U ON U.UnitId =R.UnitId
		WHERE CIV.ClientId=@ClientId
	RETURN ISNULL(@AssignedPatientLocation,'')
END

GO

