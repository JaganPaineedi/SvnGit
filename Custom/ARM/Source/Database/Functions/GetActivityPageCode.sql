/****** Object:  UserDefinedFunction [dbo].[GetActivityPageCode]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetActivityPageCode]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetActivityPageCode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetActivityPageCode]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'










CREATE FUNCTION [dbo].[GetActivityPageCode](@DocumentID int) 
returns int
as
BEGIN
Declare @ActivityPage as int

Select @ActivityPage=
	case DocumentCodeID
		when 2 then 	 236
		when 3 then 	 228
		when 5 then 	 224
		when 6 then 	 227
		when 101 then 	 236
		when 102 then 	 235
	end 
from Documents where DocumentID = @DocumentID
Return(@ActivityPage)
end


























' 
END
GO
