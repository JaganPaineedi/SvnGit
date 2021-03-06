/****** Object:  UserDefinedFunction [dbo].[fn_NextStartDateForAppointmentSearch]    Script Date: 06/19/2013 18:03:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_NextStartDateForAppointmentSearch]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fn_NextStartDateForAppointmentSearch]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_NextStartDateForAppointmentSearch]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'Create FUNCTION [dbo].[fn_NextStartDateForAppointmentSearch] (
@StartDate    DATETIME, 
@Monday        CHAR(1),  
@Tuesday       CHAR(1),  
@Wednesday       CHAR(1),  
@Thursday       CHAR(1),  
@Friday        CHAR(1),  
@Saturday       CHAR(1),  
@Sunday        CHAR(1)) RETURNS DATETIME
AS
BEGIN

DECLARE @NextStartDate DATETIME
DECLARE @CurDay VARCHAR(10)
DECLARE @setNextDay VARCHAR(10)

SET @CurDay = datename (dw, @StartDate) 
------------------MONDAY------------------------------
IF (@CurDay = ''Monday'' and @Tuesday = ''Y'')
		SET @setNextDay = ''Tuesday''
ELSE IF (@CurDay = ''Monday'' and @Wednesday = ''Y'')
		SET @setNextDay = ''Wednesday''
ELSE IF (@CurDay = ''Monday'' and @Thursday = ''Y'')
		SET @setNextDay = ''Thursday''
ELSE IF (@CurDay = ''Monday'' and @Friday = ''Y'')
		SET @setNextDay = ''Friday''
ELSE IF (@CurDay = ''Monday'' and @Saturday = ''Y'')
		SET @setNextDay = ''Saturday''
ELSE IF (@CurDay = ''Monday'' and @Sunday = ''Y'')
		SET @setNextDay = ''Sunday''
ELSE IF (@CurDay = ''Monday'' and @Monday = ''Y'')
		SET @setNextDay = ''Monday''  --NextMonday
------------------TUESDAY------------------------------
IF (@CurDay = ''Tuesday'' and @Wednesday = ''Y'')
		SET @setNextDay = ''Wednesday''
ELSE IF (@CurDay = ''Tuesday'' and @Thursday = ''Y'')
		SET @setNextDay = ''Thursday''
ELSE IF (@CurDay = ''Tuesday'' and @Friday = ''Y'')
		SET @setNextDay = ''Friday''
ELSE IF (@CurDay = ''Tuesday'' and @Saturday = ''Y'')
		SET @setNextDay = ''Saturday''
ELSE IF (@CurDay = ''Tuesday'' and @Sunday = ''Y'')
		SET @setNextDay = ''Sunday''
ELSE IF (@CurDay = ''Tuesday'' and @Monday = ''Y'')
		SET @setNextDay = ''Monday'' 
ELSE IF (@CurDay = ''Tuesday'' and @Tuesday = ''Y'')
		SET @setNextDay = ''Tuesday''	  --Next Tuesday	
------------------WEDNESDAY------------------------------

IF (@CurDay = ''Wednesday'' and @Thursday = ''Y'')
		SET @setNextDay = ''Thursday''
ELSE IF (@CurDay = ''Wednesday'' and @Friday = ''Y'')
		SET @setNextDay = ''Friday''
ELSE IF (@CurDay = ''Wednesday'' and @Saturday = ''Y'')
		SET @setNextDay = ''Saturday''
ELSE IF (@CurDay = ''Wednesday'' and @Sunday = ''Y'')
		SET @setNextDay = ''Sunday''
ELSE IF (@CurDay = ''Wednesday'' and @Monday = ''Y'')
		SET @setNextDay = ''Monday'' 
ELSE IF (@CurDay = ''Wednesday'' and @Tuesday = ''Y'')
		SET @setNextDay = ''Tuesday''	
ELSE IF (@CurDay = ''Wednesday'' and @Wednesday = ''Y'')
		SET @setNextDay = ''Wednesday''  --Next Wednesday	
------------------THURSDAY------------------------------		

IF (@CurDay = ''Thursday'' and @Friday = ''Y'')
		SET @setNextDay = ''Friday''
ELSE IF (@CurDay = ''Thursday'' and @Saturday = ''Y'')
		SET @setNextDay = ''Saturday''
ELSE IF (@CurDay = ''Thursday'' and @Sunday = ''Y'')
		SET @setNextDay = ''Sunday''
ELSE IF (@CurDay = ''Thursday'' and @Monday = ''Y'')
		SET @setNextDay = ''Monday'' 
ELSE IF (@CurDay = ''Thursday'' and @Tuesday = ''Y'')
		SET @setNextDay = ''Tuesday''	 
ELSE IF (@CurDay = ''Thursday'' and @Wednesday = ''Y'')
		SET @setNextDay = ''Wednesday'' 		
ELSE IF (@CurDay = ''Thursday'' and @Thursday = ''Y'')
		SET @setNextDay = ''Thursday''--Next Tuesday	
------------------FRIDAY------------------------------		
IF (@CurDay = ''Friday'' and @Saturday = ''Y'')
		SET @setNextDay = ''Saturday''
ELSE IF (@CurDay = ''Friday'' and @Sunday = ''Y'')
		SET @setNextDay = ''Sunday''
ELSE IF (@CurDay = ''Friday'' and @Monday = ''Y'')
		SET @setNextDay = ''Monday'' 
ELSE IF (@CurDay = ''Friday'' and @Tuesday = ''Y'')
		SET @setNextDay = ''Tuesday''	 
ELSE IF (@CurDay = ''Friday'' and @Wednesday = ''Y'')
		SET @setNextDay = ''Wednesday''
ELSE IF (@CurDay = ''Friday'' and @Thursday = ''Y'')
		SET @setNextDay = ''Thursday''
ELSE IF (@CurDay = ''Friday'' and @Friday = ''Y'')
		SET @setNextDay = ''Friday'' --Next Tuesday	
------------------SATURDAY------------------------------		

IF (@CurDay = ''Saturday'' and @Sunday = ''Y'')
		SET @setNextDay = ''Sunday''
ELSE IF (@CurDay = ''Saturday'' and @Monday = ''Y'')
		SET @setNextDay = ''Monday'' 
ELSE IF (@CurDay = ''Saturday'' and @Tuesday = ''Y'')
		SET @setNextDay = ''Tuesday''	  
ELSE IF (@CurDay = ''Saturday'' and @Wednesday = ''Y'')
		SET @setNextDay = ''Wednesday''
ELSE IF (@CurDay = ''Saturday'' and @Thursday = ''Y'')
		SET @setNextDay = ''Thursday''
ELSE IF (@CurDay = ''Saturday'' and @Friday = ''Y'')
		SET @setNextDay = ''Friday''
ELSE IF (@CurDay = ''Saturday'' and @Saturday = ''Y'')
		SET @setNextDay = ''Saturday''--Next Tuesday	
------------------SUNDAY------------------------------		

 IF (@CurDay = ''Sunday'' and @Monday = ''Y'')
		SET @setNextDay = ''Monday'' 
ELSE IF (@CurDay = ''Sunday'' and @Tuesday = ''Y'')
		SET @setNextDay = ''Tuesday''	  --Next Tuesday	
ELSE	IF (@CurDay = ''Sunday'' and @Wednesday = ''Y'')
		SET @setNextDay = ''Wednesday''
ELSE IF (@CurDay = ''Sunday'' and @Thursday = ''Y'')
		SET @setNextDay = ''Thursday''
ELSE IF (@CurDay = ''Sunday'' and @Friday = ''Y'')
		SET @setNextDay = ''Friday''
ELSE IF (@CurDay = ''Sunday'' and @Saturday = ''Y'')
		SET @setNextDay = ''Saturday''
ELSE IF (@CurDay = ''Sunday'' and @Sunday = ''Y'')
		SET @setNextDay = ''Sunday''	
		
		
		
	SELECT 
	@NextStartDate =
	CASE  WHEN @setNextDay = ''Monday''
	THEN 
		 case 
		when datename(dw,dateadd(day,1,@StartDate))=''Monday'' then dateadd(day,1,@StartDate)
		when datename(dw,dateadd(day,2,@StartDate))=''Monday'' then dateadd(day,2,@StartDate)
		when datename(dw,dateadd(day,3,@StartDate))=''Monday'' then dateadd(day,3,@StartDate)
		when datename(dw,dateadd(day,4,@StartDate))=''Monday'' then dateadd(day,4,@StartDate)
		when datename(dw,dateadd(day,5,@StartDate))=''Monday'' then dateadd(day,5,@StartDate)
		when datename(dw,dateadd(day,6,@StartDate))=''Monday'' then dateadd(day,6,@StartDate)
		when datename(dw,dateadd(day,7,@StartDate))=''Monday'' then dateadd(day,7,@StartDate)
	end
	WHEN @setNextDay = ''Tuesday'' THEN
		case when datename(dw,dateadd(day,1,@StartDate))=''Tuesday'' then dateadd(day,1,@StartDate)
		when datename(dw,dateadd(day,2,@StartDate))=''Tuesday'' then dateadd(day,2,@StartDate)
		when datename(dw,dateadd(day,3,@StartDate))=''Tuesday'' then dateadd(day,3,@StartDate)
		when datename(dw,dateadd(day,4,@StartDate))=''Tuesday'' then dateadd(day,4,@StartDate)
		when datename(dw,dateadd(day,5,@StartDate))=''Tuesday'' then dateadd(day,5,@StartDate)
		when datename(dw,dateadd(day,6,@StartDate))=''Tuesday'' then dateadd(day,6,@StartDate)
		when datename(dw,dateadd(day,7,@StartDate))=''Tuesday'' then dateadd(day,7,@StartDate)
	END
	WHEN @setNextDay = ''Wednesday''  THEN
		case when datename(dw,dateadd(day,1,@StartDate))=''Wednesday'' then dateadd(day,1,@StartDate)
		when datename(dw,dateadd(day,2,@StartDate))=''Wednesday'' then dateadd(day,2,@StartDate)
		when datename(dw,dateadd(day,3,@StartDate))=''Wednesday'' then dateadd(day,3,@StartDate)
		when datename(dw,dateadd(day,4,@StartDate))=''Wednesday'' then dateadd(day,4,@StartDate)
		when datename(dw,dateadd(day,5,@StartDate))=''Wednesday'' then dateadd(day,5,@StartDate)
		when datename(dw,dateadd(day,6,@StartDate))=''Wednesday'' then dateadd(day,6,@StartDate)
		when datename(dw,dateadd(day,7,@StartDate))=''Wednesday'' then dateadd(day,7,@StartDate)
	END
	WHEN @setNextDay = ''Thursday''  THEN
		case when datename(dw,dateadd(day,1,@StartDate))=''Thursday'' then dateadd(day,1,@StartDate)
		when datename(dw,dateadd(day,2,@StartDate))=''Thursday'' then dateadd(day,2,@StartDate)
		when datename(dw,dateadd(day,3,@StartDate))=''Thursday'' then dateadd(day,3,@StartDate)
		when datename(dw,dateadd(day,4,@StartDate))=''Thursday'' then dateadd(day,4,@StartDate)
		when datename(dw,dateadd(day,5,@StartDate))=''Thursday'' then dateadd(day,5,@StartDate)
		when datename(dw,dateadd(day,6,@StartDate))=''Thursday'' then dateadd(day,6,@StartDate)
		when datename(dw,dateadd(day,7,@StartDate))=''Thursday'' then dateadd(day,7,@StartDate)
	END
	WHEN @setNextDay = ''Friday''  THEN
		case when datename(dw,dateadd(day,1,@StartDate))=''Friday'' then dateadd(day,1,@StartDate)
		when datename(dw,dateadd(day,2,@StartDate))=''Friday'' then dateadd(day,2,@StartDate)
		when datename(dw,dateadd(day,3,@StartDate))=''Friday'' then dateadd(day,3,@StartDate)
		when datename(dw,dateadd(day,4,@StartDate))=''Friday'' then dateadd(day,4,@StartDate)
		when datename(dw,dateadd(day,5,@StartDate))=''Friday'' then dateadd(day,5,@StartDate)
		when datename(dw,dateadd(day,6,@StartDate))=''Friday'' then dateadd(day,6,@StartDate)
		when datename(dw,dateadd(day,7,@StartDate))=''Friday'' then dateadd(day,7,@StartDate)
	END
	WHEN @setNextDay = ''Saturday'' THEN
		case when datename(dw,dateadd(day,1,@StartDate))=''Saturday'' then dateadd(day,1,@StartDate)
		when datename(dw,dateadd(day,2,@StartDate))=''Saturday'' then dateadd(day,2,@StartDate)
		when datename(dw,dateadd(day,3,@StartDate))=''Saturday'' then dateadd(day,3,@StartDate)
		when datename(dw,dateadd(day,4,@StartDate))=''Saturday'' then dateadd(day,4,@StartDate)
		when datename(dw,dateadd(day,5,@StartDate))=''Saturday'' then dateadd(day,5,@StartDate)
		when datename(dw,dateadd(day,6,@StartDate))=''Saturday'' then dateadd(day,6,@StartDate)
		when datename(dw,dateadd(day,7,@StartDate))=''Saturday'' then dateadd(day,7,@StartDate)
	END
	WHEN @setNextDay = ''Sunday'' THEN
		case when datename(dw,dateadd(day,1,@StartDate))=''Sunday'' then dateadd(day,1,@StartDate)
		when datename(dw,dateadd(day,2,@StartDate))=''Sunday'' then dateadd(day,2,@StartDate)
		when datename(dw,dateadd(day,3,@StartDate))=''Sunday'' then dateadd(day,3,@StartDate)
		when datename(dw,dateadd(day,4,@StartDate))=''Sunday'' then dateadd(day,4,@StartDate)
		when datename(dw,dateadd(day,5,@StartDate))=''Sunday'' then dateadd(day,5,@StartDate)
		when datename(dw,dateadd(day,6,@StartDate))=''Sunday'' then dateadd(day,6,@StartDate)
		when datename(dw,dateadd(day,7,@StartDate))=''Sunday'' then dateadd(day,7,@StartDate)
	END
	ELSE
	dateadd(day,1,@StartDate)
END
RETURN @NextStartDate
--SELECT CONVERT(datetime, @NextStartDate, 101) 
END
' 
END
GO
