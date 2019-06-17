/****** Object:  UserDefinedFunction [dbo].[GetStaffLabSoftFormat]    Script Date: 09/14/2015 13:10:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetStaffLabSoftFormat]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetStaffLabSoftFormat]
GO

/****** Object:  UserDefinedFunction [dbo].[GetStaffLabSoftFormat]    Script Date: 09/14/2015 13:10:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[GetStaffLabSoftFormat](@StaffId INT,@EncodingChars nVarchar(5))  
RETURNS VARCHAR(MAX)  
BEGIN  
	 DECLARE @FirstName VARCHAR(20)  
	 DECLARE @LastName VARCHAR(20)  
	 DECLARE @MiddleName VARCHAR(20)  
	
	-- pull hl7 esc chars 
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
   
	 SELECT 
		 @LastName=dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(S.LastName,''), @EncodingChars),
		 @FirstName=dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(S.FirstName,''), @EncodingChars),
		 @MiddleName=dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(S.MiddleName,''), @EncodingChars)
	 FROM Staff S  
	 WHERE S.StaffId=@StaffId  
   
	 RETURN @LastName+@FieldChar+@FirstName+@FieldChar+@MiddleName
END  
GO


