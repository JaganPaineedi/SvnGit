/****** Object:  UserDefinedFunction [dbo].[GetLOCId]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetLOCId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetLOCId]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetLOCId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'



CREATE function [dbo].[GetLOCId] (
@LOCCategoryId int,
@Score int) returns int
begin

declare @LOCId int

begin
  select @LOCId =LOCID
		FROM dbo.CustomLOCs
		WHERE LOCCategoryId = @LOCCategoryId
		AND @Score > = MinDeterminatorScore
		AND @Score <= MaxDeterminatorScore
end

return @LOCId

end



' 
END
GO
