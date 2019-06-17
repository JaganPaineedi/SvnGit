/****** Object:  StoredProcedure [dbo].[ssp_SCGetEndUserMonitoringConfigurations]    Script Date: 12/8/2016 1:52:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ssp_SCGetEndUserMonitoringConfigurations 2
create procedure [dbo].[ssp_SCGetEndUserMonitoringConfigurations] @StaffId INT
AS
/*********************************************************************/
/* Stored Procedure: [ssp_SCGetEndUserMonitoringConfigurations]   */
/*       Date              Author                  Purpose                   */
/*      08-03-2016     Dhanil Manuel               To Get the end user monitoring configuartions settings task #394 Engineering Improvement Initiatives*/
/*********************************************************************/
BEGIN
	BEGIN TRY
		
		DECLARE @AllowEndUserMonitoring char(1) = 'N';
		Declare @AllowedForStaff char(1) = 'N';
		Declare @AllowedTime char(1) = 'N';

				
		IF EXISTS(SELECT * FROM EndUserMonitoringStaff WHERE Staffid = @StaffId AND ISNULL(RecordDeleted,'N') <> 'Y')
		begin
		   set @AllowedForStaff = 'Y';
		END
		ELSE  IF EXISTS(SELECT * FROM EndUserMonitoringStaff WHERE  ISNULL(RecordDeleted,'N') <> 'Y')
		         AND NOT EXISTS (SELECT * FROM EndUserMonitoringStaff WHERE Staffid = @StaffId AND ISNULL(RecordDeleted,'N') <> 'Y')
		begin
		   set @AllowedForStaff = 'N';
		END
		ELSE IF NOT EXISTS(SELECT * FROM EndUserMonitoringStaff WHERE  ISNULL(RecordDeleted,'N') <> 'Y')
		BEGIN
		   SET @AllowedForStaff = 'Y';
		END

		 IF NOT EXISTS(SELECT * FROM  EndUserMonitoringTimeFrames WHERE ISNULL(RecordDeleted,'N') <> 'Y'  AND StartDate IS NOT NULL AND  EndDate IS NOT NULL)
		BEGIN
		  SET @AllowedTime = 'Y'
		END
	    ELSE IF 
		EXISTS(SELECT * FROM  EndUserMonitoringTimeFrames WHERE ISNULL(RecordDeleted,'N') <> 'Y'  AND StartDate IS NOT NULL AND  EndDate IS NOT NULL) 
		AND EXISTS(SELECT * FROM  EndUserMonitoringTimeFrames WHERE StartDate <= GETDATE() AND  EndDate >= GETDATE()  AND ISNULL(RecordDeleted,'N') <> 'Y')
		BEGIN
		  SET @AllowedTime = 'Y'
		END
		ELSE IF EXISTS(SELECT * FROM  EndUserMonitoringTimeFrames WHERE ISNULL(RecordDeleted,'N') <> 'Y'  AND StartDate IS NOT NULL AND  EndDate IS NOT NULL) 
		AND NOT EXISTS(SELECT * FROM  EndUserMonitoringTimeFrames WHERE StartDate <= GETDATE() AND  EndDate >= GETDATE()  AND ISNULL(RecordDeleted,'N') <> 'Y')
		BEGIN
		  SET @AllowedTime = 'N'
		END
		
		IF(@AllowedForStaff ='Y' AND @AllowedTime = 'Y')
		  SET @AllowEndUserMonitoring = 'Y'
        IF(@AllowedForStaff ='N' OR @AllowedTime = 'N')
		  SET @AllowEndUserMonitoring = 'N'

		        
       SELECT @AllowEndUserMonitoring AS AllowEndUserMonitoring

      
	
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetEndUserMonitoringConfigurations') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
	END CATCH
END


GO
