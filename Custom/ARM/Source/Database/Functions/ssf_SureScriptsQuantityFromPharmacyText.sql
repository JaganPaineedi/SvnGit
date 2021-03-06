/****** Object:  UserDefinedFunction [dbo].[ssf_SureScriptsQuantityFromPharmacyText]    Script Date: 06/19/2013 18:03:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssf_SureScriptsQuantityFromPharmacyText]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ssf_SureScriptsQuantityFromPharmacyText]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssf_SureScriptsQuantityFromPharmacyText]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'


create function [dbo].[ssf_SureScriptsQuantityFromPharmacyText] (
	@PharmText varchar(100)
)
returns decimal(29,14)
as
begin

declare @retval decimal(29,14)
declare @PharmParsed varchar(100)

set @PharmParsed = ltrim(rtrim(@PharmText))

while (len(@PharmParsed) > 0) and (patindex(''%[^0123456789.]%'', @PharmParsed) = 1)
begin
	set @PharmParsed = substring(@PharmParsed, 2, len(@PharmParsed) -1)
end


if patindex(''%[^0123456789.]%'', @PharmParsed) > 1
begin
	set @PharmParsed = substring(@PharmParsed, 1, patindex(''%[^0123456789.]%'', @PharmParsed) -1)
end

if isnumeric(@PharmParsed) = 1 set @retval = cast(@PharmParsed as decimal(29,14))

return @retval

end


' 
END
GO
