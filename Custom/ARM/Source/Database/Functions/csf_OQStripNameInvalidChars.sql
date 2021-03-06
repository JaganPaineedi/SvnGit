/****** Object:  UserDefinedFunction [dbo].[csf_OQStripNameInvalidChars]    Script Date: 06/19/2013 18:03:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_OQStripNameInvalidChars]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[csf_OQStripNameInvalidChars]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_OQStripNameInvalidChars]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'create function [dbo].[csf_OQStripNameInvalidChars](@n varchar(200)) returns varchar(200) as
begin

	declare @i int
	declare @exprValidCharacters varchar(200)
	set @exprValidCharacters = ''%[^a-zA-Z- ]%''	-- these are the only characters allowed in a client name

	while patindex(@exprValidCharacters, @n) > 0
	begin
		set @i = patindex(@exprValidCharacters, @n)

		if @i = len(@n) and len(@n) = 1
			set @n = ''''
		else if @i = len(@n)
			set @n = substring(@n, 1, @i - 1)
		else
			set @n = substring(@n, 1, @i - 1) + '' '' + substring(@n, @i + 1, 200) 

	end

	return @n

end
' 
END
GO
