/****** Object:  UserDefinedFunction [dbo].[ReturnRecurrenceStartDate]    Script Date: 06/19/2013 18:03:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReturnRecurrenceStartDate]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ReturnRecurrenceStartDate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReturnRecurrenceStartDate]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

CREATE FUNCTION [dbo].[ReturnRecurrenceStartDate] 
(
@AppointmentId BIGINT
)
RETURNS datetime
AS
BEGIN
	Declare @StartDate datetime
	
	select @StartDate=starttime from recurringappointments where recurringappointmentid=@AppointmentId
return @StartDate
END
' 
END
GO
