/****** Object:  UserDefinedFunction [dbo].[csf_PhoneNumberStripped]    Script Date: 06/19/2013 18:03:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_PhoneNumberStripped]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[csf_PhoneNumberStripped]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_PhoneNumberStripped]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'create function [dbo].[csf_PhoneNumberStripped](@PrettyPhoneNumber varchar(128)) returns varchar(128) as
/*
	This function was created for the InfoChannel member extract but can be used elsewhere.
	Strips spaces, parens, and dashes from the input text and returns the result.
Creator: Tom Remisoski
Date: 2/15/2007
*/
begin

return replace(replace(replace(replace(@PrettyPhoneNumber, ''('', ''''), '')'', ''''), '' '', ''''), ''-'', '''')

end
' 
END
GO
