/****** Object:  UserDefinedFunction [dbo].[csf_FASStripSpecialChars]    Script Date: 06/19/2013 18:03:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_FASStripSpecialChars]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[csf_FASStripSpecialChars]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_FASStripSpecialChars]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'create function [dbo].[csf_FASStripSpecialChars](@inputString varchar(max)) returns varchar(max) as
begin
   return replace(@inputString, ''"'', '''')
end
' 
END
GO
