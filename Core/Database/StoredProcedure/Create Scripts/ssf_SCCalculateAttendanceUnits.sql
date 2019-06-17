/****** Object:  UserDefinedFunction [dbo].[ssf_SCCalculateAttendanceUnits]    Script Date: 05/12/2015 12:21:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssf_SCCalculateAttendanceUnits]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ssf_SCCalculateAttendanceUnits]
GO

/****** Object:  UserDefinedFunction [dbo].[ssf_SCCalculateAttendanceUnits]    Script Date: 05/12/2015 12:21:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
  
CREATE FUNCTION [dbo].[ssf_SCCalculateAttendanceUnits] (@StartDateTime DATETIME,@EndDateTime DATETIME,@Unit DECIMAL(18,2),@UnitType INT)
/********************************************************************************    
-- Stored Procedure: dbo.ssf_SCCalculateAttendanceUnits      
--    
-- Copyright: Streamline Healthcate Solutions 
--    
-- Updates:                                                           
-- Date			 Author			Purpose    
-- 15-AUG-2015	 Akwinass		What:Used to Calculate Units in Attendance Module.          
--								Why:task  #266 Valley Client Acceptance Testing Issues.
*********************************************************************************/ 
RETURNS VARCHAR(max)
AS
BEGIN
	DECLARE @Return DECIMAL(18,2)
	
	IF @UnitType = 110 --Minutes
	BEGIN
		SET @Return =CAST(SUM(DATEDIFF(MINUTE,@StartDateTime,@EndDateTime)) AS DECIMAL(18,2))
	END
	ELSE IF @UnitType = 111 --Hours
	BEGIN
		SET @Return = CAST(CAST((@EndDateTime - @StartDateTime) AS FLOAT) * 24.0 AS DECIMAL(18,2))
	END
	ELSE IF @UnitType = 112 --Days
	BEGIN
		DECLARE @StartDate DATE = CAST(@StartDateTime AS DATE)
		DECLARE @EndDate DATE = CAST(@EndDateTime AS DATE)		
		SET @Return = CAST(SUM(DATEDIFF(DAY,@StartDate,@EndDate)) + 1 AS DECIMAL(18,2))
	END
	ELSE
	BEGIN
		SET @Return = @Unit
	END
	

	RETURN @Return
END

GO


