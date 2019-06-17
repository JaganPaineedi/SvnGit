/****** Object:  UserDefinedFunction [dbo].[ssf_SCGetAttendanceNextMedDueDetails]    Script Date: 05/12/2015 12:21:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssf_SCGetAttendanceNextMedDueDetails]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ssf_SCGetAttendanceNextMedDueDetails]
GO

/****** Object:  UserDefinedFunction [dbo].[ssf_SCGetAttendanceNextMedDueDetails]    Script Date: 05/12/2015 12:21:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[ssf_SCGetAttendanceNextMedDueDetails] (@ClientId INT,@ClientName VARCHAR(250),@Date DATETIME)
/********************************************************************************    
-- Stored Procedure: dbo.ssf_SCGetAttendanceBannerDetails      
--    
-- Copyright: Streamline Healthcate Solutions 
--    
-- Updates:                                                           
-- Date			 Author			Purpose    
-- 11-May-2015	 Akwinass		What:Used in ssp_SCListPageAttendance.          
--								Why:task  #915 Valley - Customizations
*********************************************************************************/ 
RETURNS VARCHAR(max)
AS
BEGIN
	DECLARE @Return NVARCHAR(max)
	
	IF ISNULL(@ClientId,0) > 0
	BEGIN
		SELECT TOP 1 @Return = CAST(LEFT(CONVERT(VARCHAR, MAR.ScheduledDate, 120), 10) + ' ' + LEFT(CONVERT(VARCHAR, MAR.ScheduledTime, 120), 10) AS DATETIME)
		FROM MedAdminRecords MAR
		JOIN ClientOrders CO ON MAR.ClientOrderId = CO.ClientOrderId
			AND isnull(MAR.RecordDeleted, 'N') = 'N'
			AND isnull(CO.RecordDeleted, 'N') = 'N'
			AND ISNULL(CO.IsPRN,'N') = 'N'
		WHERE CO.ClientId = @ClientId
			AND CAST(LEFT(CONVERT(VARCHAR, MAR.ScheduledDate, 120), 10) + ' ' + LEFT(CONVERT(VARCHAR, MAR.ScheduledTime, 120), 10) AS DATETIME) >= CAST(@Date AS DATETIME)
		ORDER BY ScheduledTime ASC
	END

	RETURN @Return
END

GO


