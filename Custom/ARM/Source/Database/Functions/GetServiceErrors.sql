/****** Object:  UserDefinedFunction [dbo].[GetServiceErrors]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetServiceErrors]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetServiceErrors]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetServiceErrors]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'Create function [dbo].[GetServiceErrors]
(@ServiceId				int)
returns varchar(max)
As
Begin
declare @ServiceErrors table
(ErrorPK				int identity,
ServiceErrorId			int,
ErrorMessage			varchar(max))

Declare @currentErrorId		int,
		@MaxErrorId			int,
		@ErrorMessage		varchar(max),
		@SQL				varchar(max)

select @ErrorMessage = ''''

insert into @ServiceErrors
(ServiceErrorId,
ErrorMessage)
select top (3) ServiceErrorId, case when len(ErrorMessage) > 300 then substring(ErrorMessage,1,297)+''...'' else ErrorMessage end
from serviceErrors where serviceId = @ServiceId order by serviceErrorId desc


Select @currentErrorId = min(ErrorPK),
		@maxErrorId	= max(ErrorPK)
from @ServiceErrors

while @currentErrorId <= @maxErrorId
begin
	select @ErrorMessage = @ErrorMessage + ErrorMessage
	from @ServiceErrors where ErrorPK = @CurrentErrorId

	select @currentErrorId = @CurrentErrorId + 1
end

return (@ErrorMessage )

End


' 
END
GO
