/****** Object:  UserDefinedFunction [dbo].[ReturnRecurrenceInfo]    Script Date: 06/19/2013 18:03:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReturnRecurrenceInfo]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ReturnRecurrenceInfo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReturnRecurrenceInfo]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'create FUNCTION [dbo].[ReturnRecurrenceInfo]
(@AppointmentId BIGINT
)
RETURNS VARCHAR(1000)
AS
BEGIN
DECLARE @ReccurenceString VARCHAR(1000)
DECLARE @StartTime	DATETIME
DECLARE @EndTime	DATETIME
DECLARE @RecurrenceType	CHAR
DECLARE @EveryXDays	INT
DECLARE @EveryWeekday	BIT
DECLARE @EveryXWeeks	INT
DECLARE @WeeklyOnSundays	INT
DECLARE @WeeklyOnMondays	INT
DECLARE @WeeklyOnTuesdays	INT
DECLARE @WeeklyOnWednesdays	INT
DECLARE @WeeklyOnThursdays	INT
DECLARE @WeeklyOnFridays	INT
DECLARE @WeeklyOnSaturdays	INT
DECLARE @MonthlyEveryXMonths	INT
DECLARE @MonthlyOnXDayOfMonth	INT
DECLARE @YearlyEveryXMonth	INT
DECLARE @YearlyEveryXDayOfMonth	INT
DECLARE @OnXthDay	INT
DECLARE @OnDayType	VARCHAR(30)
DECLARE @RecurrenceStartDate	DATETIME
DECLARE @NoEndDate	INT
DECLARE @NumberOfOccurences	INT
DECLARE @EndDate	DATETIME
DECLARE @RowIdentifier	type_guid
DECLARE @Range INT
Declare @Periodicity varchar(10)
Declare @Month varchar(20)
Declare @WeekOfMonth varchar(20)
Declare @WeekDays varchar(20)
Declare @XEndDate datetime
set @Periodicity =''1''
set @Range=0

SELECT 
@StartTime=StartTime ,
@EndTime=EndTime ,
@RecurrenceType=CASE WHEN  RecurrenceType=''D'' THEN 0 WHEN RecurrenceType=''W'' THEN 1 WHEN  RecurrenceType=''M'' THEN 2 WHEN  RecurrenceType=''Y'' THEN 3   ELSE 0 END ,
@EveryXDays =EveryXDays,
@EveryWeekday =CASE WHEN EveryWeekday=''y'' THEN 1 ELSE 0 END ,
@EveryXWeeks=EveryXWeeks,
@WeeklyOnSundays=CASE WHEN WeeklyOnSundays=''y'' THEN 1 ELSE 0 END ,
@WeeklyOnMondays=CASE WHEN WeeklyOnMondays=''y'' THEN 2 ELSE 0 END ,
@WeeklyOnTuesdays=CASE WHEN WeeklyOnTuesdays =''y'' THEN 4 ELSE 0 END ,
@WeeklyOnWednesdays=CASE WHEN WeeklyOnWednesdays =''y'' THEN 8 ELSE 0 END ,
@WeeklyOnThursdays=CASE WHEN WeeklyOnThursdays =''y'' THEN 16 ELSE 0 END,
@WeeklyOnFridays=CASE WHEN WeeklyOnFridays =''y'' THEN 32 ELSE 0 END ,
@WeeklyOnSaturdays=CASE WHEN WeeklyOnSaturdays =''y'' THEN 64 ELSE 0 END,
@MonthlyEveryXMonths=MonthlyEveryXMonths ,
@MonthlyOnXDayOfMonth=isnull(MonthlyOnXDayOfMonth,day(@StartTime)) ,
@YearlyEveryXMonth=YearlyEveryXMonth ,
@YearlyEveryXDayOfMonth=YearlyEveryXDayOfMonth,
@OnXthDay=OnXthDay,
@OnDayType=OnDayType ,
@RecurrenceStartDate=RecurrenceStartDate,
@NoEndDate=CASE WHEN NoEndDate=''y'' THEN 10 ELSE 0 END ,
@numberofoccurences=numberofoccurences,
@RowIdentifier=RowIdentifier,
@EndDate=EndDate 
FROM RecurringAppointments WHERE recurringappointmentid=@AppointmentId 

set @XEndDate=@EndTime
declare @rcount int
SELECT @rcount= COUNT(*) FROM Appointments WHERE RecurringAppointmentId =@AppointmentId
if @numberofoccurences is not null
begin
set @rcount=@numberofoccurences
end

if @rcount=0
begin
set @rcount=10
end

select top 1 @EndTime=Endtime from appointments where recurringappointmentid=@AppointmentId order by 1 desc
IF @RecurrenceType=0
BEGIN
	IF(@NoEndDate<>0)
	BEGIN
	SET @Range=0
    END
	if(@numberofoccurences is not null)
	BEGIN
	SET @Range=1
	END
	if(@EndDate is not null)
	begin
	set @EndTime=@EndDate
	set @Range=2
	set @rcount=10;
	end
	
	IF(@EveryWeekday=1)
	BEGIN
	
	set @Periodicity=cast( @EveryXDays as varchar(10))
	END
	ELSE
	BEGIN
	
	set @Periodicity=cast(@EveryXDays as varchar(10))
	END
	SET @ReccurenceString=''<RecurrenceInfo Start="''+CAST(CONVERT(VARCHAR(19),@StartTime,120) as varchar(50))+''" End="''+CAST(CONVERT(VARCHAR(19),@EndTime,120) as varchar(50))+''" Id="^" OccurrenceCount="''+ cast(@rcount as varchar(5))+''" Periodicity="''+cast(@Periodicity as varchar(10))+''" Range="''+cast(@Range as varchar(10))+''" />''
     if(@EveryWeekday=1)
     begin
     SET @ReccurenceString=''<RecurrenceInfo Start="''+CAST(CONVERT(VARCHAR(19),@StartTime,120) as varchar(50))+''" End="''+CAST(CONVERT(VARCHAR(19),@EndTime,120) as varchar(50))+''" Id="^" OccurrenceCount="''+ cast(@rcount as varchar(5))+''"  WeekDays="62" Range="''+cast(@Range as varchar(10))+''" />''
     end
END
-- we don''t need to store Range for weekly reccurence.
IF @RecurrenceType=1
begin
IF(@NoEndDate<>0)
	BEGIN
	SET @Range=0
    END
	if(@numberofoccurences is not null)
	BEGIN
	SET @Range=1
	END
	if(@EndDate is not null)
	begin
	set @EndTime=@EndDate
	set @Range=2
	
	end
	
set @Periodicity=cast( @EveryXWeeks as varchar(10))
SET @ReccurenceString=''<RecurrenceInfo Start="''+CAST(CONVERT(VARCHAR(19),@StartTime,120) as varchar(50))+''" End="''+CAST(CONVERT(VARCHAR(19),@EndTime,120) as varchar(50))+''" Id="^" OccurrenceCount="''+cast(@rcount as varchar(5))+''" WeekDays="''+cast((@WeeklyOnSundays+@WeeklyOnMondays+@WeeklyOnTuesdays+@WeeklyOnWednesdays+@WeeklyOnThursdays+@WeeklyOnFridays+@WeeklyOnSaturdays) as varchar(20))+''" Periodicity="''+cast(@Periodicity as varchar(10))+''" Type="1" Range="''+cast(@Range as varchar(10))+''" />''
end
--add weekdays to monthly and yearly recurrence.
declare @WeekDaysToYearlyMonthly varchar(50)
set @WeekDaysToYearlyMonthly=''0''
select @WeekDaysToYearlyMonthly=case ltrim(rtrim(@OnDayType))
when ''DAY'' then ''127''
when ''WEEKDAY'' then ''62''
when ''WEEKENDDAY'' then''65''
WHEN ''SUNDAY'' THEN ''1''
WHEN ''MONDAY'' THEN ''2''
WHEN ''TUESDAY'' THEN ''4''
WHEN ''WEDNESDAY'' THEN ''8''
WHEN ''THURSDAY'' THEN ''16''
WHEN ''FRIDAY'' THEN ''32''
WHEN ''SATURDAY'' THEN ''64''
else
cast((@WeeklyOnSundays+@WeeklyOnMondays+@WeeklyOnTuesdays+@WeeklyOnWednesdays+@WeeklyOnThursdays+@WeeklyOnFridays+@WeeklyOnSaturdays) as varchar(20))
end
 
--end
IF @RecurrenceType=2
BEGIN
if(@numberofoccurences is null)
begin
set @numberofoccurences=11
end
else
begin
set @numberofoccurences=@rcount
end
set @WeekOfMonth=isnull(@OnXthDay,0)
set @Periodicity=cast( @MonthlyEveryXMonths as varchar(10))
	IF(@NoEndDate<>0)
	BEGIN
		SET @Range=0
    END
    ELSE
	BEGIN
		if(@numberofoccurences is not null)
		BEGIN
			SET @Range=1
		END
		if(@EndDate is not null)
		begin
			set @EndTime=@EndDate
			set @Range=2
		end
	END
			if(@WeekOfMonth=0)begin
			SET @ReccurenceString=''<RecurrenceInfo Start="''+CAST(CONVERT(VARCHAR(19),@StartTime,120) as varchar(50))+''" End="''+CAST(CONVERT(VARCHAR(19),@XEndDate,120) as varchar(50))+''" Id="^" WeekDays="''+cast((@WeeklyOnSundays+@WeeklyOnMondays+@WeeklyOnTuesdays+@WeeklyOnWednesdays+@WeeklyOnThursdays+@WeeklyOnFridays+@WeeklyOnSaturdays) as varchar(20))+''" Type="2" OccurrenceCount="''+Cast(@numberofoccurences as varchar(10))+''" WeekOfMonth="''+Cast(@WeekOfMonth as varchar(10))+''" Range="''+cast(@Range as varchar(20))+''" DayNumber="''+cast(@MonthlyOnXDayOfMonth as varchar(10))+''" Periodicity="''+cast(@Periodicity as varchar(10))+''" />''
			end
			else
			begin
			SET @ReccurenceString=''<RecurrenceInfo Start="''+CAST(CONVERT(VARCHAR(19),@StartTime,120) as varchar(50))+''" End="''+CAST(CONVERT(VARCHAR(19),@XEndDate,120) as varchar(50))+''" Id="^" WeekDays="''+@WeekDaysToYearlyMonthly+''" Type="2" OccurrenceCount="''+Cast(@numberofoccurences as varchar(10))+''" WeekOfMonth="''+Cast(@WeekOfMonth as varchar(10))+''" Range="''+cast(@Range as varchar(20))+''" Periodicity="''+cast(@Periodicity as varchar(10))+''" />''
			end
	

END

IF @RecurrenceType=3
begin
set @WeekOfMonth=isnull(@OnXthDay,0)
IF(@NoEndDate<>0)
	BEGIN
	SET @Range=0
    END
	if(@numberofoccurences is not null)
	BEGIN
	SET @Range=1
	END
	if(@EndDate is not null)
	begin
	set @EndTime=@EndDate
	set @Range=2
	end
		if(@WeekOfMonth=0)
		begin
		SET @ReccurenceString=''<RecurrenceInfo Start="''+CAST(CONVERT(VARCHAR(19),@StartTime,120) as varchar(50))+''" End="''+CAST(CONVERT(VARCHAR(19),@XEndDate,120) as varchar(50))+''" Id="''+cast(@RowIdentifier as varchar(100))+''" Range="''+cast(@Range as varchar(20))+''" OccurrenceCount="''+Cast(@rcount as varchar(10))+''" Type="3" DayNumber="''+cast(@YearlyEveryXDayOfMonth as varchar(10))+''" Month="''+Cast(@YearlyEveryXMonth as varchar(10))+''" WeekOfMonth="0" WeekDays="''+cast((@WeeklyOnSundays+@WeeklyOnMondays+@WeeklyOnTuesdays+@WeeklyOnWednesdays+@WeeklyOnThursdays+@WeeklyOnFridays+@WeeklyOnSaturdays) as varchar(20))+''" />''
		end
		else
		begin
		SET @ReccurenceString=''<RecurrenceInfo Start="''+CAST(CONVERT(VARCHAR(19),@StartTime,120) as varchar(50))+''" End="''+CAST(CONVERT(VARCHAR(19),@XEndDate,120) as varchar(50))+''" Id="''+cast(@RowIdentifier as varchar(100))+''" WeekDays="''+@WeekDaysToYearlyMonthly+''" Range="''+cast(@Range as varchar(20))+''" OccurrenceCount="''+Cast(@rcount as varchar(10))+''" Type="3" Month="''+Cast(@YearlyEveryXMonth as varchar(10))+''" WeekOfMonth="''+cast(@WeekOfMonth as varchar(10))+''" />''
		end

end
--SET @ReccurenceString=''<RecurrenceInfo Start="''+CAST(CONVERT(VARCHAR(19),@StartTime,120) as varchar(50))+''" End="''+CAST(CONVERT(VARCHAR(19),@EndTime,120) as varchar(50))+''" Id="''+cast(@RowIdentifier as varchar(100))+''" WeekDays="''+cast((@WeeklyOnSundays+@WeeklyOnMondays+@WeeklyOnTuesdays+@WeeklyOnWednesdays+@WeeklyOnThursdays+@WeeklyOnFridays+@WeeklyOnSaturdays) as varchar(20))+''" Type="''+cast(@RecurrenceType as varchar(5))+''" OccurrenceCount="''+cast(@NumberOfOccurences as varchar(4))+''" Periodicity="''+cast(@Periodicity as varchar(10))+''" />''
if len(rtrim(ltrim(@ReccurenceString)))=0
begin
set @ReccurenceString=null
end
return @ReccurenceString
END
' 
END
GO
