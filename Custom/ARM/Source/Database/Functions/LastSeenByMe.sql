/****** Object:  UserDefinedFunction [dbo].[LastSeenByMe]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LastSeenByMe]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[LastSeenByMe]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LastSeenByMe]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'




























create function [dbo].[LastSeenByMe](@ClinicianID int)
returns datetime
as
BEGIN
DECLARE @LastDate datetime 
select @LastDate=max(DateOfService) from Services where ClinicianID=@ClinicianID and Status=71 OR Status=75
return @LastDate
end 





























' 
END
GO
