/****** Object:  UserDefinedFunction [dbo].[NumberToText]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NumberToText]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[NumberToText]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NumberToText]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

create function [dbo].[NumberToText] (@Number bigint)
returns varchar(1000) as 
begin 

  declare @i bigint
  declare @s varchar(1000)
  declare @n bigint
  declare @left bigint
  declare @right bigint
  declare @c tinyint

  if @Number < 0 
    set @i = -@Number
  else 
    set @i = @Number

  
  if @i >= 1000000000000000
    return ''Cannot convert to text: number is too big''

  -- Find biggest value in table less than 
  -- or equal to the number to translate 
  -- into text: 

  if @i >= 1000000000000
    select @s = ''Trillion'',  @n = 1000000000000, @c = 1
  else if @i >=  1000000000
    select @s = ''Billion'',   @n = 1000000000, @c = 1
  else if @i >= 1000000
    select @s = ''Million'',   @n = 1000000, @c = 1
  else if @i >= 1000
    select @s = ''Thousand'',  @n = 1000, @c = 1
  else if @i >= 100
    select @s = ''Hundred'',   @n = 100, @c = 1
  else if @i >= 90
    select @s = ''Ninety'',    @n = 90, @c = 0
  else if @i >= 80
    select @s = ''Eighty'',    @n = 80, @c = 0
  else if @i >= 70
    select @s = ''Seventy'',   @n = 70, @c = 0
  else if @i >= 60
    select @s = ''Sixty'',     @n = 60, @c = 0
  else if @i >= 50
    select @s = ''Fifty'',     @n = 50, @c = 0
  else if @i >= 40
    select @s = ''Forty'',     @n = 40, @c = 0
  else if @i >= 30
    select @s = ''Thirty'',    @n = 30, @c = 0
  else if @i >= 20
    select @s = ''Twenty'',    @n = 20, @c = 0
  else if @i >= 19 
    select @s = ''Nineteen'',  @n = 19, @c = 0
  else if @i >= 18 
    select @s = ''Eighteen'',  @n = 18, @c = 0
  else if @i >= 17 
    select @s = ''Seventeen'', @n = 17, @c = 0
  else if @i >= 16 
    select @s = ''Sixteen'',   @n = 16, @c = 0
  else if @i >= 15 
    select @s = ''Fifteen'',   @n = 15, @c = 0
  else if @i >= 14 
    select @s = ''Fourteen'',  @n = 14, @c = 0
  else if @i >= 13 
    select @s = ''Thirteen'',  @n = 13, @c = 0
  else if @i >= 12 
    select @s = ''Twelve'',    @n = 12, @c = 0
  else if @i >= 11 
    select @s = ''Eleven'',    @n = 11, @c = 0
  else if @i >= 10 
    select @s = ''Ten'',       @n = 10, @c = 0
  else if @i >= 9 
    select @s = ''Nine'',      @n = 9, @c = 0
  else if @i >= 8 
    select @s = ''Eight'',     @n = 8, @c = 0
  else if @i >= 7 
    select @s = ''Seven'',     @n = 7, @c = 0
  else if @i >= 6 
    select @s = ''Six'',       @n = 6, @c = 0
  else if @i >= 5 
    select @s = ''Five'',      @n = 5, @c = 0
  else if @i >= 4 
    select @s = ''Four'',      @n = 4, @c = 0
  else if @i >= 3 
    select @s = ''Three'',     @n = 3, @c = 0
  else if @i >= 2 
    select @s = ''Two'',       @n = 2, @c = 0
  else if @i >= 1 
    select @s = ''One'',       @n = 1, @c = 0
  else 
    select @s = ''Zero'',      @n = 0, @c = 0


  if @n = 0 
    return @s


  set @left = @i/@n  -- "how many" 
  set @right = @i%@n -- "what''s left" 

  if @left > 1 or @c = 1 
    set @s = ltrim(rtrim(dbo.NumberToText (@left))) + space(1) + @s 

  if @right > 0 
    set @s = @s + space(1) + ltrim(rtrim(dbo.NumberToText (@right))) 

  if @Number < 0 
    set @s = ''negative '' + @s
 
  return @s 

end 


' 
END
GO
