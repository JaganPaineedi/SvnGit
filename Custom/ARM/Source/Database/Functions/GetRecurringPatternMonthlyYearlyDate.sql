/****** Object:  UserDefinedFunction [dbo].[GetRecurringPatternMonthlyYearlyDate]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetRecurringPatternMonthlyYearlyDate]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetRecurringPatternMonthlyYearlyDate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetRecurringPatternMonthlyYearlyDate]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
create function [dbo].[GetRecurringPatternMonthlyYearlyDate] (
@MonthStartDate       datetime,
@OnXDayOfMonth int,
@OnXthDay             int,
@OnDayType            varchar(10))
returns datetime
/********************************************************************************
-- Function: dbo.GetRecurringPatternMonthlyYearlyDate  
--
-- Copyright: 2007 Streamline Healthcate Solutions
--
-- Creation Date:    10.20.2007                                          	
--                                                                   		
-- Purpose: Calculates appointment date for monthly/yearly recurring pattern
--
-- Updates:                     		                                
-- Date        Author      Purpose
-- 10.20.2007  SFarber     Created.  
--
*********************************************************************************/
begin

declare @AppointmentDate datetime
declare @DaysInMonth int
declare @MonthEndDate datetime
declare @WeekDay int
declare @MonthStartWeekDay int
declare @MonthEndWeekDay int

set @MonthEndDate = dateadd(dd, -1, dateadd(mm, 1, @MonthStartDate))

-- Pattern 1: on X day of month

if @OnXDayOfMonth > 0
begin
  set @DaysInMonth = datepart(day, @MonthEndDate)

  if @OnXDayOfMonth > @DaysInMonth
    set @AppointmentDate = dateadd(dd, @DaysInMonth - 1, @MonthStartDate)
  else
   set @AppointmentDate = dateadd(dd, @OnXDayOfMonth - 1, @MonthStartDate)

  goto final
end

-- Pattern 2: on Xth day of Y day type of month

set @MonthStartWeekDay = datepart(weekday, @MonthStartDate)
set @MonthEndWeekDay = datepart(weekday, @MonthEndDate)

if @OnDayType = ''DAY''
begin
  set @AppointmentDate = case when @OnXthDay in (1, 2, 3, 4) 
                              then dateadd(dd, @OnXthDay - 1, @MonthStartDate)
                              else @MonthEndDate
                         end 

end

if @OnDayType = ''WEEKDAY''
begin
  if @OnXthDay in (1, 2, 3, 4)
  begin
    set @AppointmentDate = dateadd(dd, case @MonthStartWeekDay when 1 then 1 when 7 then 2 else 0 end, @MonthStartDate)

    if @OnXthDay > 1
      set @AppointmentDate = dateadd(dd, @OnXthDay - 1 + case when (6 - datepart(weekday, @AppointmentDate)) < (@OnXthDay - 1) then 2 else 0 end, @AppointmentDate) 
  end  
  else -- last
    set @AppointmentDate = dateadd(dd, case @MonthEndWeekDay when 1 then -2 when 7 then -1 else 0 end, @MonthEndDate)
end

if @OnDayType = ''WEEKENDDAY''
begin
  if @OnXthDay in (1, 2, 3, 4)
  begin
    set @AppointmentDate = dateadd(dd, case when @MonthStartWeekDay in (1, 7) then 0 else 7 - @MonthStartWeekDay end, @MonthStartDate)

    if @OnXthDay > 1
      set @AppointmentDate = dateadd(dd, case @MonthStartWeekDay
                                              when 7 -- First weekend day is Saturday
                                              then case @OnXthDay when 2 then 1 when 3 then 7 else 8 end
                                              else case @OnXthDay when 2 then 6 when 3 then 7 else 13 end  -- First weekend day is Sunday
                                         end, @AppointmentDate)
  end  
  else -- last
    set @AppointmentDate = dateadd(dd, case when @MonthEndWeekDay in (1, 7) then 0 else -(@MonthEndWeekDay - 1) end, @MonthEndDate)


end


if @OnDayType in (''SUNDAY'', ''MONDAY'', ''TUESDAY'', ''WEDNESDAY'', ''THURSDAY'', ''FRIDAY'', ''SATURDAY'')
begin
  set @WeekDay = case @OnDayType
                      when ''SUNDAY''    then 1
                      when ''MONDAY''    then 2
                      when ''TUESDAY''   then 3
                      when ''WEDNESDAY'' then 4
                      when ''THURSDAY''  then 5
                      when ''FRIDAY''    then 6
                      else 7 -- ''SATURDAY''
                 end

  if @OnXthDay in (1, 2, 3, 4)
  begin
    set @AppointmentDate = dateadd(dd, case when @MonthStartWeekDay > @WeekDay 
                                            then 7 - (@MonthStartWeekDay - @WeekDay)
                                            when @MonthStartWeekDay < @WeekDay
                                            then @WeekDay - @MonthStartWeekDay
                                            else 0
                                       end, @MonthStartDate)


    if @OnXthDay > 1
      set @AppointmentDate = dateadd(dd, (@OnXthDay - 1) * 7, @AppointmentDate) 
  end  
  else -- last
    set @AppointmentDate = dateadd(dd, case when @MonthEndWeekDay > @WeekDay 
                                            then -(@MonthEndWeekDay - @WeekDay)
                                            when @MonthEndWeekDay < @WeekDay
                                            then -(7 - (@WeekDay - @MonthEndWeekDay))
                                            else 0
                                       end, @MonthEndDate)
end


final:


return @AppointmentDate

end

' 
END
GO
