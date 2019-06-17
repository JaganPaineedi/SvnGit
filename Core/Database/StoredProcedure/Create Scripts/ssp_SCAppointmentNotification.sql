/****** Object:  StoredProcedure [dbo].[ssp_SCAppointmentNotification]    Script Date: 05/01/2015 17:37:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCAppointmentNotification]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCAppointmentNotification]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCAppointmentNotification]    Script Date: 05/01/2015 17:37:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCAppointmentNotification] ( @appointmentId INT           = 0
,                                                   @statusId INT            = 0
,                                                   @cancelReason INT        = 0
,                                                   @CurrentUser VARCHAR(30)
,                                                   @StaffId AS INT         
,                                                   @ClientId AS INT        
)
AS
/********************************************************************************
-- Stored Procedure: ssp_SCAppointmentNotification 886016,8037,-1,'Admin',1,102174
--
-- Copyright: Streamline Healthcare Solutions
--
-- Purpose: Harbor - Support - Task#1750 - Primary Care Appointments Show Notifications - Procedure to update status of a Appointment
--
-- Author:  Kaushal Pandey
-- Date:    Dec 10 2018
-- 

*********************************************************************************/
BEGIN TRY
BEGIN	

	DECLARE @Message VARCHAR(1000)
	DECLARE @Resources VARCHAR(1000)

	SELECT @Message = Value
	FROM dbo.SystemConfigurationKeys sck
	WHERE [Key] = 'AppointmentMessage'

	IF (@Message IS NULL)
	BEGIN
		SET @Message = (
		SELECT case when  ISNULL(ClientType,'I')='I' then LastName + ', ' + FirstName + ' is here' else OrganizationName end  AS NAME
		FROM Clients
		WHERE clientid = @ClientId
		)
	END

	SET @Message = REPLACE(@Message, '[ClientName]', (
	SELECT case when  ISNULL(ClientType,'I')='I' then LastName + ', ' + FirstName else OrganizationName end
	FROM dbo.Clients
	WHERE ClientId = @ClientId
	))
	
	SET @Message = (SELECT REPLACE(REPLACE(@Message, '[TimeOfService]', dbo.GetTimePart(A.StartTime)),'[Clinician]', s.LastName + ', ' + s.FirstName)
	FROM  dbo.Appointments A
	JOIN Staff s ON A.StaffId = s.StaffId and s.Staffid = @StaffId
	WHERE A.AppointmentId = @AppointmentId
	)
	
	IF @statusId = 8037 -- If status is changed to Checked In 
	BEGIN
		 DECLARE StaffNotifications CURSOR LOCAL FAST_FORWARD FOR  
          SELECT  
         NotificationStaffId  
        FROM StaffNotificationPreferenceAdditionalStaff Where StaffId = @StaffId  
     
         OPEN StaffNotifications  
         WHILE 1 = 1  
         BEGIN  
       FETCH StaffNotifications INTO @StaffId  
          IF @@fetch_status <> 0 BREAK  
    INSERT INTO instantmessages (    
    StaffId    
    ,[Message]    
    )    
   VALUES (    
    @StaffId    
    ,@Message    
    );     
   END  
   CLOSE StaffNotifications  
   DEALLOCATE StaffNotifications 
			
		DECLARE @NotifyMeOfMyServices CHAR(1)
		--SET @NotifyMeOfMyServices = 'Y'
		SELECT @NotifyMeOfMyServices = NotifyMeOfMyServices FROM StaffPreferences Where StaffId = @StaffId AND ISNULL(RecordDeleted,'N')='N'
		IF @statusId = 8037 
		BEGIN
			IF (@NotifyMeOfMyServices = 'Y')
			BEGIN
				INSERT INTO InstantMessages(StaffId, [Message])
				VALUES (@StaffId, @Message)
			END
		END	
		
	END
	
	
	END
	SELECT @Message
END TRY

BEGIN CATCH  
    DECLARE @ErrorMessage nvarchar(4000);  
    DECLARE @ErrorSeverity int;  
    DECLARE @ErrorState int;  
  
    SELECT  
      @ErrorMessage = ERROR_MESSAGE(),  
      @ErrorSeverity = ERROR_SEVERITY(),  
      @ErrorState = ERROR_STATE();  
  
     
    RAISERROR (@ErrorMessage,-- Message text.         
    @ErrorSeverity,-- Severity.         
    @ErrorState -- State.         
    ); 
   
END CATCH
GO


