/****** Object:  UserDefinedFunction [dbo].[ssf_SureScriptsPackageDescriptionFromPharmacyText]    Script Date: 06/19/2013 18:03:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssf_SureScriptsPackageDescriptionFromPharmacyText]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ssf_SureScriptsPackageDescriptionFromPharmacyText]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssf_SureScriptsPackageDescriptionFromPharmacyText]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'


create function [dbo].[ssf_SureScriptsPackageDescriptionFromPharmacyText] (
	@PharmText varchar(100)
)
returns varchar(100)
as
begin

declare @retval varchar(100)
declare @PharmParsed varchar(100)

set @PharmParsed = ltrim(rtrim(@PharmText))

while (len(@PharmParsed) > 0) and (patindex(''%[^0123456789.]%'', @PharmParsed) = 1)
begin
	set @PharmParsed = substring(@PharmParsed, 2, len(@PharmParsed) -1)
end


if patindex(''%[^0123456789.]%'', @PharmParsed) > 1
begin
	set @PharmParsed = substring(@PharmParsed, patindex(''%[^0123456789.]%'', @PharmParsed), 100)

   while (len(@PharmParsed) > 0) and (patindex(''%[ ]%'', @PharmParsed) between 1 and len(@PharmParsed) - 1)
      set @PharmParsed = substring(@PharmParsed, patindex(''%[ ]%'', @PharmParsed) + 1, 100)

   return @PharmParsed
end

return ''''

end


' 
END
GO
