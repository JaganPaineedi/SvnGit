/****** Object:  UserDefinedFunction [dbo].[ssf_GetAllDatesforAppointmentSearch]    Script Date: 02/13/2014 12:05:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssf_GetAllDatesforAppointmentSearch]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ssf_GetAllDatesforAppointmentSearch]
GO


/****** Object:  UserDefinedFunction [dbo].[ssf_GetAllDatesforAppointmentSearch]    Script Date: 01/24/2014 19:06:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:  <Revathi>  
-- Create date: <24/Jan/2014>  
-- Description: <To get all available dates for appointment search>
-- 13-FEB-2014 Akwinass Included Drop Script  
-- =============================================
CREATE FUNCTION [dbo].[ssf_GetAllDatesforAppointmentSearch]
(	
		-- Add the parameters for the function here
	@ClientId int,
	@ProgramId int,
	@startdate date,
	@enddate  date,
	@Monday char(1),
	@Tueday char(1),
	@Wednesday char(1),
	@Thursday char(1),
	@Friday char(1),
	@Saturday char(1),
	@sunday char(1),
	@Reschedule CHAR(1)='N',
	@RescheduleDate	DATE
)
RETURNS  @TempScheduleDates table(ClientId int,ProgramId int, ScheduledDate date,weekdays varchar(max),FrequencyEndDate date)
AS
begin 
;with DateTemp AS    
    (select   MyCounter = 0    
     UNION ALL    
     SELECT   MyCounter + 1    
     FROM     DateTemp    
     where    MyCounter < DATEDIFF(d,@startdate,@enddate))    
    
    
Insert into @TempScheduleDates(ClientId,ProgramId,ScheduledDate,weekdays,FrequencyEndDate)     
SELECT @ClientId  
 ,@ProgramId  
 ,(  
  CASE   
   WHEN @Reschedule = 'Y'  
    AND DATEADD(d, MyCounter, @startdate) <= @RescheduleDate  
    AND @RescheduleDate < @enddate  
    THEN DATEADD(d, MyCounter,  cast(GETDATE() as DATE))  
   ELSE DATEADD(d, MyCounter, @startdate)  
   END  
  )  
 ,(  
  CASE   
   WHEN @Reschedule = 'Y'  
    AND DATEADD(d, MyCounter, @startdate) <= @RescheduleDate  
    AND @RescheduleDate < @enddate  
    THEN DATENAME(dw, DATEADD(d, MyCounter,  cast(GETDATE() as DATE)))  
   ELSE DATENAME(dw, DATEADD(d, MyCounter, @startdate))  
   END  
  )  
 ,(  
  CASE   
   WHEN @Reschedule = 'Y'  
    AND DATEADD(d, MyCounter, @startdate) <= @RescheduleDate  
    AND @RescheduleDate < @enddate  
    THEN CASE   
      WHEN (datepart(dw, DATEADD(d, MyCounter, @RescheduleDate))) = 1  
       THEN DATEADD(d, MyCounter, @RescheduleDate)  
      ELSE DATEADD(dd, 8 - (DATEPART(dw, DATEADD(d, MyCounter,  cast(GETDATE() as DATE)))), DATEADD(d, MyCounter,  cast(GETDATE() as DATE)))  
      END  
   ELSE CASE   
     WHEN (datepart(dw, DATEADD(d, MyCounter, @startdate))) = 1  
      THEN DATEADD(d, MyCounter, @startdate)  
     ELSE DATEADD(dd, 8 - (DATEPART(dw, DATEADD(d, MyCounter, @startdate))), DATEADD(d, MyCounter, @startdate))  
     END  
   END  
  )  
FROM DateTemp     
option (maxrecursion 0)    
return     
end

 