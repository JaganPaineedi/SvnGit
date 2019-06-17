/****** Object:  UserDefinedFunction [dbo].[ReturnRecurrenceEndDate]    Script Date: 06/19/2013 18:03:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReturnRecurrenceEndDate]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ReturnRecurrenceEndDate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReturnRecurrenceEndDate]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'--select dbo.ReturnRecurrenceEndDate(1174)
CREATE FUNCTION [dbo].[ReturnRecurrenceEndDate] 
(
@AppointmentId BIGINT
)
RETURNS datetime
AS
BEGIN
	Declare @EndDate datetime
	
	select @EndDate=Endtime from recurringappointments where recurringappointmentid=@AppointmentId
return @EndDate
END
' 
END
GO
