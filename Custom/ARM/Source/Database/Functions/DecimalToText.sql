/****** Object:  UserDefinedFunction [dbo].[DecimalToText]    Script Date: 06/19/2013 18:03:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DecimalToText]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[DecimalToText]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DecimalToText]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'create function [dbo].[DecimalToText] (@Amount decimal(12,4) )
returns varchar(1000) as 
begin 
  declare @AmountStr varchar(30)
  declare @DecimalPlace int
  declare @Number bigint
  declare @Cents char(6)

  set @AmountStr = convert(varchar(30), @Amount)
  set @DecimalPlace = CharIndex(''.'', @AmountStr)

  if @DecimalPlace > 0
  begin
    set @Number = convert(bigint, left(@AmountStr, @DecimalPlace - 1))
    set @Cents = left(substring(@AmountStr, @DecimalPlace + 1, len(@AmountStr) - @DecimalPlace) + ''00'', 2) + ''/100''
  end
  else
  begin 
    set @Number = convert(bigint, @AmountStr)
    set @Cents = ''00/100''
  end
  
  return dbo.NumberToText(@Number) + case when @Cents <> ''00/100'' then '' and '' + @Cents else '''' end--+ '' Dollar'' + case when @Amount = 1 then '''' else ''s'' end
  
end
' 
END
GO
