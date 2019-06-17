/****** Object:  UserDefinedFunction [dbo].[UserHasAnyAlert]    Script Date: 06/19/2013 18:03:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserHasAnyAlert]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[UserHasAnyAlert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserHasAnyAlert]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'




























CREATE FUNCTION [dbo].[UserHasAnyAlert](@ClientID int)
returns char(3)
as
BEGIN
DECLARE @YesNo char(3)
IF EXISTS(select AlertID from Alerts where ClientID=@ClientID)
	SET @YesNo=''Yes''
else
	SET @YesNo=''No''
return @YesNo
END






























' 
END
GO
