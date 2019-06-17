/****** Object:  UserDefinedFunction [dbo].[Lastdateofservice]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Lastdateofservice]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Lastdateofservice]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Lastdateofservice]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'





























CREATE  function [dbo].[Lastdateofservice](@ClientID int)
returns datetime
as
BEGIN
DECLARE @LastDate datetime 
select @LastDate=max(DateOfService) from Services where ClientID=@ClientID and Status=71 OR Status=75
return @LastDate
end






























' 
END
GO
