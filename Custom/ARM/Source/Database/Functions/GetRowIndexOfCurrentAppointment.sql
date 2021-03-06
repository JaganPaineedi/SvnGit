/****** Object:  UserDefinedFunction [dbo].[GetRowIndexOfCurrentAppointment]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetRowIndexOfCurrentAppointment]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetRowIndexOfCurrentAppointment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetRowIndexOfCurrentAppointment]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date, ,>  
-- Description: <Description, ,>  
-- =============================================  
CREATE FUNCTION [dbo].[GetRowIndexOfCurrentAppointment]  
(  
 @RecurringAppointmentId int,  
 @AppointmentId int  
)  
RETURNS int  
AS  
BEGIN  
  
Declare @RecurringAppointmentStartTime as datetime  
Declare @AppointmentStartTime as datetime  
Declare @RecurrenceType as char(1)  
declare @returnVal int  
declare @everyWeekDay char(1)  
declare @everyXdays int  
Declare @weeklySelectedDays int  
  
Select @weeklySelectedDays = Case WeeklyOnMondays when ''Y'' then 1 else 0 end+  
Case WeeklyOnTuesdays  when ''Y'' then 1 else 0 end+  
Case WeeklyOnWednesdays  when ''Y'' then 1 else 0 end+  
Case WeeklyOnThursdays  when ''Y'' then 1 else 0 end+  
Case WeeklyOnFridays  when ''Y'' then 1 else 0 end+  
Case WeeklyOnSaturdays  when ''Y'' then 1 else 0 end+  
Case WeeklyOnSundays  when ''Y'' then 1 else 0 end,   
@RecurringAppointmentStartTime = StartTime,@RecurrenceType=RecurrenceType,  
@everyWeekDay=everyWeekday,  
@everyXdays=everyxdays  
 from RecurringAppointments where RecurringAppointmentId = @RecurringAppointmentId  
  
Select @AppointmentStartTime = StartTime from Appointments where AppointmentId = @AppointmentId  
  
if (@RecurrenceType=''W'')  
begin  
 set @returnVal=(datediff(d,@RecurringAppointmentStartTime,@AppointmentStartTime)/7)*@weeklySelectedDays  
end  
else if (@RecurrenceType=''D'')  
Begin   
 if(@everyWeekDay=''Y'')  
 begin  
  set @returnVal= datediff(d,@RecurringAppointmentStartTime,@AppointmentStartTime) -(DATEDIFF(WEEK,@RecurringAppointmentStartTime,@AppointmentStartTime)*2)  
 end  
 else  
 begin  
  set @returnVal=datediff(d,@RecurringAppointmentStartTime,@AppointmentStartTime)/@everyxdays  
 end  
End  
else if (@RecurrenceType=''Y'')  
Begin   
 set @returnVal=datediff(y,@RecurringAppointmentStartTime,@AppointmentStartTime)  
END  
else if (@RecurrenceType=''M'')  
Begin   
 set @returnVal=datediff(m,@RecurringAppointmentStartTime,@AppointmentStartTime)  
END  
  
if(@returnVal<0)  
begin  
 set @returnVal=0  
end  
  
return @returnVal  
END  ' 
END
GO
