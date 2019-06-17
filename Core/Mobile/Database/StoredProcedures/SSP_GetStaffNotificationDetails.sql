/****** Object:  StoredProcedure [dbo].[SSP_GetStaffNotificationDetails]    Script Date: 08-21-2018 15:34:06 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_GetStaffNotificationDetails]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_GetStaffNotificationDetails]
GO

/****** Object:  StoredProcedure [dbo].[SSP_GetStaffNotificationDetails]    Script Date: 08-21-2018 15:34:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_GetStaffNotificationDetails] (@StaffId INT)
AS
/******************************************************************************************************************************/
/* Stored Procedure : SSP_GetStaffNotificationDetails                                                                         */
/* Copyright        : Streamline Healthcate Solutions                                                                         */
/* Purpose          : Procedure for getting the value of RegisteredForMobileNotifications and  SubscribedForPushNotifications */
/*                    from StaffPreferences Table                                                                             */
/* Author           : Vishnu Narayanan                                                                                        */
/* Date             : 17 Aug 2018                                                                                             */
/* Sept 14 2018 	Pradeep A  		Added More columns related to Mobile Notifications                                        */
/******************************************************************************************************************************/
BEGIN
	BEGIN TRY
		SELECT ISNULL(SP.RegisteredForMobileNotifications, 'N') AS RegisteredForMobileNotifications
			,ISNULL(SP.SubscribedForPushNotifications, 'N') AS SubscribedForPushNotifications
			,ISNULL(SP.SubscribedForSMSNotifications, 'N') AS SubscribedForSMSNotifications
			,ISNULL(SP.SubscribedForEmailNotifications, 'N') AS SubscribedForEmailNotifications
			,SP.LastTFATimeStamp
			,SP.MobileDeviceRegistrationId
			,SP.RegisteredForMobileNotificationsTimeStamp
		FROM StaffPreferences SP
		INNER JOIN Staff S ON S.StaffId = SP.StaffId
		WHERE SP.StaffId = @StaffId
			AND S.Active = 'Y'
			AND ISNULL(SP.REcordDeleted, 'N') = 'N'
			AND ISNULL(S.RecordDeleted, 'N') = 'N';
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000);

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'SSP_GetStaffNotificationDetails') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());

		RAISERROR (
				@Error
				,-- Message text.                                                                     
				16
				,-- Severity.                                                            
				1 -- State.                                                         
				);
	END CATCH
END;
GO


