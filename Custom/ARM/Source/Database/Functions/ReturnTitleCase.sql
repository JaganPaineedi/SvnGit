/****** Object:  UserDefinedFunction [dbo].[ReturnTitleCase]    Script Date: 06/19/2013 18:03:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReturnTitleCase]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ReturnTitleCase]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReturnTitleCase]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE function [dbo].[ReturnTitleCase]  (@Field varchar(max))
returns varchar(max)
as
begin
	Declare @Value varchar(max)
	, @CharacterCount int
	, @CurrentCharacter int
	Select @Value = @Field
	, @CharacterCount = LEN(@Value)
	, @CurrentCharacter = 1


	WHILE @CurrentCharacter <= @CharacterCount
		BEGIN
		
		IF (ASCII(Substring(@Value,@CurrentCharacter,1))) between 65 and 90
			BEGIN
				Select @Value = Case When @CurrentCharacter=1 Then '''' ELSE LEFT(@Value,@CurrentCharacter-1)+'' '' End
								+SUBSTRING(@Value,@CurrentCharacter,1)
								+SUBSTRING(@Value,@CurrentCharacter+1,@CharacterCount)
				SET @CharacterCount = @CharacterCount + 1
				SET @CurrentCharacter = @CurrentCharacter + 2
			END
			
		ELSE
			BEGIN
				Select @Value = @Value
				SET @CurrentCharacter = @CurrentCharacter + 1
			END

		END

   return(@Value)
end


' 
END
GO
