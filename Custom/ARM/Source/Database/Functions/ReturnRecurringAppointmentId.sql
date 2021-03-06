/****** Object:  UserDefinedFunction [dbo].[ReturnRecurringAppointmentId]    Script Date: 06/19/2013 18:03:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReturnRecurringAppointmentId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ReturnRecurringAppointmentId]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReturnRecurringAppointmentId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
create FUNCTION [dbo].[ReturnRecurringAppointmentId] 
(
	@Recurringappointmentid bigint
)
RETURNS bigint
AS
BEGIN
Declare @AppointmentId bigint
Select  @AppointmentId=Appointmentid from RecurringAppointments where RecurringAppointmentId=@Recurringappointmentid	
return @AppointmentId
END
' 
END
GO
