/****** Object:  UserDefinedFunction [dbo].[nextScheduledDate]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[nextScheduledDate]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[nextScheduledDate]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[nextScheduledDate]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'



























-- it will return next schedule date of service

CREATE function [dbo].[nextScheduledDate](@varClientId int,@varDate datetime) returns DateTime
As
Begin
	declare @serviceDate datetime
	set @serviceDate=(select top 1 DateOfService from services where status=70 and clientid=@varClientId and DateOfService>@varDate order by DateOfService )
	return @serviceDate 
End








































' 
END
GO
