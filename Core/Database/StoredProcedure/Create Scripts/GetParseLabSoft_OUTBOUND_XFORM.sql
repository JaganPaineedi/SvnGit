/****** Object:  UserDefinedFunction [dbo].[GetParseLabSoft_OUTBOUND_XFORM]    Script Date: 09/20/2013 12:12:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetParseLabSoft_OUTBOUND_XFORM]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetParseLabSoft_OUTBOUND_XFORM]
GO

/****** Object:  UserDefinedFunction [dbo].[GetParseLabSoft_OUTBOUND_XFORM]    Script Date: 09/20/2013 12:12:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[GetParseLabSoft_OUTBOUND_XFORM](@inputString NVARCHAR(MAX), @EncodingChars nVarchar(5))
RETURNS NVARCHAR(MAX)
BEGIN
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
     
 SELECT @inputString= REPLACE(REPLACE(@inputString,@EscChar,@EscChar+'E' + @EscChar),@FieldChar,@EscChar + 'F' + @EscChar)    
  SELECT @inputString= REPLACE(REPLACE(REPLACE(@inputString,CHAR(13) + CHAR(10),' '), CHAR(10),' '),CHAR(13),' ')  
 RETURN @inputString    
END 
go