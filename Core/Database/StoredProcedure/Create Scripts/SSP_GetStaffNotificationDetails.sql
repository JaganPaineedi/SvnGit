IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE OBJECT_ID = OBJECT_ID(N'[SSP_GetStaffNotificationDetails]')
			AND OBJECTPROPERTY(OBJECT_ID, N'IsProcedure') = 1
		)
	DROP PROCEDURE [dbo].[SSP_GetStaffNotificationDetails]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE SSP_GetStaffNotificationDetails(@StaffId INT)
AS
/******************************************************************************************************************************/
/* Stored Procedure : SSP_GetStaffNotificationDetails                                                                         */
/* Copyright        : Streamline Healthcate Solutions                                                                         */ 
/* Purpose          : Procedure for getting the value of RegisteredForMobileNotifications                                     */
/*                    from StaffPreferences Table                                                                             */
/* Author           : Vishnu Narayanan                                                                                        */
/* Date             : 17 Aug 2018                                                                                             */
/* Oct 11 2018		Pradeep A        What :Added SubscribedForPushNotifications,RegisteredForEmailNotifications,
									 RegisteredForSMSNotifications column based on the entry in the MobileDevices table Why : Mobile #6 */ 
/******************************************************************************************************************************/                                                 
     BEGIN
         SELECT ISNULL(SP.RegisteredForMobileNotifications, 'N') AS RegisteredForMobileNotifications,
		 ISNULL(SP.RegisteredForEmailNotifications, 'N') AS RegisteredForEmailNotifications,
		 ISNULL(SP.RegisteredForSMSNotifications, 'N') AS RegisteredForSMSNotifications,
		 ISNULL((SELECT TOP 1 'Y' FROM MobileDevices WHERE StaffId = @StaffId AND SubscribedForPushNotifications = 'Y' AND ISNULL(RecordDeleted,'N') = 'N'),'N') AS SubscribedForPushNotifications
         FROM StaffPreferences SP
              JOIN Staff S ON S.StaffId = SP.StaffId
         WHERE SP.StaffId = @StaffId
               AND S.Active = 'Y'
               AND ISNULL(SP.REcordDeleted, 'N') = 'N'
               AND ISNULL(S.RecordDeleted, 'N') = 'N';
     END;