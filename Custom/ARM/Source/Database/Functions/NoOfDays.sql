/****** Object:  UserDefinedFunction [dbo].[NoOfDays]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NoOfDays]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[NoOfDays]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NoOfDays]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'





CREATE FUNCTION [dbo].[NoOfDays] (@FromDate datetime,@ToDate datetime)  
RETURNS int 
AS  
BEGIN
Declare @NoOfDays int
set @NoOfDays = 0

If (@FromDate = @ToDate)
   set @NoOfDays =1
else
      begin
	set @NoOfDays =1
	while(@FromDate<>@ToDate)
	Begin 
		set @FromDate =  Dateadd(day,1,@FromDate)
		Set @NoOfDays = @NoOfDays + 1
	End

     end
 return @NoOfDays
END






' 
END
GO
