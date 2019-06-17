/****** Object:  UserDefinedFunction [dbo].[ssf_SCGetAttendanceNextAppointmentDetails]    Script Date: 05/12/2015 12:21:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssf_SCGetAttendanceNextAppointmentDetails]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ssf_SCGetAttendanceNextAppointmentDetails]
GO

/****** Object:  UserDefinedFunction [dbo].[ssf_SCGetAttendanceNextAppointmentDetails]    Script Date: 05/12/2015 12:21:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE FUNCTION [dbo].[ssf_SCGetAttendanceNextAppointmentDetails] (@CurrentServiceId INT,@ClientId INT,@ClientName VARCHAR(250),@Date DATETIME,@PageNumber INT)
/********************************************************************************    
-- Stored Procedure: dbo.ssf_SCGetAttendanceBannerDetails      
--    
-- Copyright: Streamline Healthcate Solutions 
--    
-- Updates:                                                           
-- Date			 Author			Purpose    
-- 11-May-2015	 Akwinass		What:Used in ssp_SCListPageAttendance.          
--								Why:task  #915 Valley - Customizations
-- 23-Feb-2016	 Akwinass	    What:Included @CurrentServiceId to avoid returning current service as Next Appointment.
--							    Why:task #829.04 Woods - Customizations
--02/10/2017      jcarlson       Keystone Customizations 69 - increased @ProcedureCode length to 500 to handle procedure code display as increasing to 75 
*********************************************************************************/ 
RETURNS VARCHAR(max)
AS
BEGIN
	DECLARE @Return NVARCHAR(max)
	DECLARE @ActivityDate VARCHAR(50)
	DECLARE @ClientActivityId INT
	DECLARE @DateOfService VARCHAR(50)
	DECLARE @ServiceId INT
	DECLARE @ActivityType VARCHAR(250) = ''
	DECLARE @ActivitySummary VARCHAR(MAX) = ''
	DECLARE @ProcedureCode VARCHAR(500)
	DECLARE @LocationCode VARCHAR(250)
	DECLARE @ClinicianName VARCHAR(250)
	
	
	IF ISNULL(@ClientId,0) > 0
	BEGIN
		SELECT TOP 1 @ServiceId = Services.ServiceId, @DateOfService = 	CONVERT(VARCHAR(10), Services.DateOfService, 101) + ' ' + ISNULL(SUBSTRING(CONVERT(VARCHAR, Services.DateOfService, 100), 13, 2) + ':' + SUBSTRING(CONVERT(VARCHAR, Services.DateOfService, 100), 16, 2) + ' ' + SUBSTRING(CONVERT(VARCHAR, Services.DateOfService, 100), 18, 2), ''),@ProcedureCode = ProcedureCodes.DisplayAs ,@LocationCode = L.LocationCode,@ClinicianName = C.LastName + ', ' + C.FirstName
		FROM ProcedureCodes
		RIGHT JOIN Services ON ProcedureCodes.ProcedureCodeId = Services.ProcedureCodeId
		LEFT JOIN GlobalCodes GC ON Services.UnitType = GC.GlobalCodeId
		LEFT JOIN GlobalCodes GCcancelReason ON GCcancelReason.GlobalCodeID = Services.CancelReason AND GCcancelReason.Category = 'CancelReason'
		LEFT JOIN Locations L ON Services.LocationId = L.LocationId AND ISNULL(L.RecordDeleted, 'N') = 'N'
		LEFT JOIN Clients C ON Services.ClientId = C.ClientId AND ISNULL(C.RecordDeleted, 'N') = 'N'	
		WHERE Services.ClientId = @ClientId
			AND ISNULL(Services.RecordDeleted,'N') = 'N'
			AND ISNULL(ProcedureCodes.RecordDeleted,'N') = 'N'
			AND Services.DateOfService > DATEADD(MINUTE, 10, @Date) 
			AND Services.[Status] = 70
			AND Services.ServiceId <> @CurrentServiceId
		ORDER BY Services.DateOfService ASC

		SELECT TOP 1 @ClientActivityId = ClientActivityId,@ActivityDate = CONVERT(VARCHAR(10), CA.ActivityDate, 101) + ' ' + ISNULL(SUBSTRING(CONVERT(VARCHAR, CA.ActivityStartTime, 100), 13, 2) + ':' + SUBSTRING(CONVERT(VARCHAR, CA.ActivityStartTime, 100), 16, 2) + ' ' + SUBSTRING(CONVERT(VARCHAR, CA.ActivityStartTime, 100), 18, 2), ''),@ActivityType = GC.CodeName,@ActivitySummary = ActivitySummary	
		FROM ClientActivities AS CA
		LEFT JOIN Clients AS C ON C.ClientId = CA.ClientId
		LEFT JOIN GlobalCodes AS GC ON CA.ActivityType = GC.GlobalCodeId
		WHERE ISNULL(CA.RecordDeleted, 'N') = 'N'
			AND ISNULL(C.RecordDeleted, 'N') = 'N'
			AND CAST(CONVERT(VARCHAR(10), CA.ActivityDate, 101) + ' ' + ISNULL(SUBSTRING(CONVERT(VARCHAR, CA.ActivityStartTime, 100), 13, 2) + ':' + SUBSTRING(CONVERT(VARCHAR, CA.ActivityStartTime, 100), 16, 2) + ' ' + SUBSTRING(CONVERT(VARCHAR, CA.ActivityStartTime, 100), 18, 2), '') AS DATETIME) > DATEADD(MINUTE, 10, @Date) 
			AND CA.ClientId = @ClientId
		ORDER BY CA.ActivityDate, CA.ActivityStartTime ASC
	END
	
    IF ISNULL(@ActivityDate,'') <> '' AND ISNULL(@DateOfService,'') = ''
    BEGIN
		IF @PageNumber = -1
		BEGIN
			SET @Return = @ActivityDate
		END
		ELSE
		BEGIN
			SET @Return = '5761,434,"ClientId='+CAST(@ClientId AS VARCHAR(50))+'^ClientName='+@ClientName+'^ClientActivityId='+CAST(@ClientActivityId AS VARCHAR(50))+'^TabId=2"' + '|'+@ActivityDate+ '|'+ISNULL(@ActivityType,'')+ '|'+ISNULL(@ActivitySummary,'')
		END
    END    
    ELSE IF ISNULL(@DateOfService,'') <> '' AND ISNULL(@ActivityDate,'') = ''
    BEGIN
		IF @PageNumber = -1
		BEGIN
			SET @Return = @DateOfService
		END
		ELSE
		BEGIN
			SET @Return = '5761,207,"ClientId='+CAST(@ClientId AS VARCHAR(50))+'^ClientName='+@ClientName+'^ServiceId='+CAST(@ServiceId AS VARCHAR(50))+'^TabId=2"' + '|'+@DateOfService+ '|'+ISNULL(@ProcedureCode,'')+'|' +ISNULL(@LocationCode,'')+'|'+@ClinicianName
		END		
    END    
    ELSE IF ISNULL(@DateOfService,'') <> '' AND ISNULL(@ActivityDate,'') <> ''
    BEGIN
		IF CAST(@DateOfService AS DATETIME) <= CAST(@ActivityDate AS DATETIME)
		BEGIN
			IF @PageNumber = -1
			BEGIN
				SET @Return = @DateOfService
			END
			ELSE
			BEGIN
				SET @Return = '5761,207,"ClientId='+CAST(@ClientId AS VARCHAR(50))+'^ClientName='+@ClientName+'^ServiceId='+CAST(@ServiceId AS VARCHAR(50))+'^TabId=2"' + '|'+@DateOfService+ '|'+ISNULL(@ProcedureCode,'')+'|'+ISNULL(@LocationCode,'')+'|'+@ClinicianName
			END			
		END
		ELSE
		BEGIN
			IF @PageNumber = -1
			BEGIN
				SET @Return = @ActivityDate
			END
			ELSE
			BEGIN
				SET @Return = '5761,434,"ClientId='+CAST(@ClientId AS VARCHAR(50))+'^ClientName='+@ClientName+'^ClientActivityId='+CAST(@ClientActivityId AS VARCHAR(50))+'^TabId=2"' + '|'+@ActivityDate+ '|'+ISNULL(@ActivityType,'')+ '|'+ISNULL(@ActivitySummary,'')
			END			
		END
    END

	RETURN @Return
END

GO


