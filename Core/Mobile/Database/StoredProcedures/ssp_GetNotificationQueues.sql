
IF EXISTS
(
    SELECT *
    FROM sys.objects
    WHERE OBJECT_ID = OBJECT_ID(N'[ssp_GetNotificationQueues]')
          AND OBJECTPROPERTY(OBJECT_ID, N'IsProcedure') = 1
)
    DROP PROCEDURE [dbo].[ssp_GetNotificationQueues];
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE PROCEDURE [dbo].[ssp_GetNotificationQueues]
AS

/***************************************************************************************************/

/* Stored Procedure : ssp_GetNotificationQueues                                                    */

/* Copyright        : Streamline Healthcate Solutions                                              */

/* Purpose          : Inserting records from Messages and Alerts table to NotificationQueues Table */

/*                    and returning data for MobileNotifications Console Applications              */

/* Author           : Vishnu Narayanan                                                             */

/* Date             : 07 September 2018                                                            */

/* Updates          :                                                                              */

/* Date			 Author			    Purpose                                                        */

/* 07-Sep-2018   Vishnu Narayanan   Created for Mobile#6                                           */

/* 30-Oct-2018   Vishnu Narayanan   Adding Flag type notification from ClientNotes table           */

/* 03-Dec-2018   Vishnu Narayanan   using view ViewStaffPermissions for checking the permission    */
/*                                  and adding a temporary table for getting Notification method   */   
/* 14-Dec-2018   Vishnu Narayanan   Renamed 'NOTIFICATIONMETHODS' Code to 'MOBNOTIFICATIONMTD'     */
/*                                  since 'NOTIFICATIONMETHOD' already exist.                      */
/*                                                                                                 */
/* 17-Dec-2018   Vishnu Narayanan   Replacing NotificationRetryCount with 0 if the value is NULL.  */
/*                                  Why : Mobile-#6                                                */

/* 27-Dec-2018   Vishnu Narayanan   If NotificationMethod is 0, then not returning that record For Mobile-#6    */

/* 26-Mar-2019   Vishnu Narayanan   Hard coding the email subject and checking the configuration keys created for message/alert/flag notification content is null,
                                    if it is null returning the actual message/alert/flag content else returning the Key value for Mobile-#6.2  */
/***************************************************************************************************/

    BEGIN TRY
        DECLARE @messageNotificationType INT;
        DECLARE @alertNotificationType INT;
        DECLARE @flagNotificationType INT;
        DECLARE @NotificationForFlags VARCHAR(MAX);
        DECLARE @NumOfDaysForFlagNotification INT;
        DECLARE @PushNotification VARCHAR(MAX);
        DECLARE @SMSNotification VARCHAR(MAX);
        DECLARE @EmailNotification VARCHAR(MAX);
        DECLARE @PermissionTemplateType INT;
        DECLARE @EnablePushNotification VARCHAR(MAX);
        DECLARE @EnableSMSNotification VARCHAR(MAX);
        DECLARE @EnableEmailNotification VARCHAR(MAX);
        DECLARE @MessageNotificationContent VARCHAR(MAX);
        DECLARE @AlertNotificationContent VARCHAR(MAX);
        DECLARE @FlagNotificationContent VARCHAR(MAX);
        DECLARE @NotificationFrom VARCHAR(MAX);
        SELECT @messageNotificationType = GlobalCodeId
        FROM GlobalCodes
        WHERE Category = 'NOTIFICATIONTYPE'
              AND Code = 'NOTIFICATIONTYPEMESSAGES'
              AND ISNULL(RecordDeleted, 'N') = 'N';
        SELECT @alertNotificationType = GlobalCodeId
        FROM GlobalCodes
        WHERE Category = 'NOTIFICATIONTYPE'
              AND Code = 'NOTIFICATIONTYPEALERTS'
              AND ISNULL(RecordDeleted, 'N') = 'N';
        SELECT @flagNotificationType = GlobalCodeId
        FROM GlobalCodes
        WHERE Category = 'NOTIFICATIONTYPE'
              AND Code = 'NOTIFICATIONTYPEFLAGS'
              AND ISNULL(RecordDeleted, 'N') = 'N';
        SELECT @NotificationForFlags = [Value]
        FROM SystemConfigurationKeys
        WHERE [Key] = 'SendAdvanceMobileNotificationForFlags'
              AND ISNULL(RecordDeleted, 'N') = 'N';
        SELECT @NumOfDaysForFlagNotification = [Value]
        FROM SystemConfigurationKeys
        WHERE [Key] = 'SendAdvanceMobileNotificationForFlagsNumDays'
              AND ISNULL(RecordDeleted, 'N') = 'N';
        SELECT @PushNotification = GlobalCodeId
        FROM GlobalCodes
        WHERE Category = 'MOBNOTIFICATIONMTD'
              AND Code = 'PUSHNOTIFICATION'
              AND ISNULL(RecordDeleted, 'N') = 'N';
        SELECT @SMSNotification = GlobalCodeId
        FROM GlobalCodes
        WHERE Category = 'MOBNOTIFICATIONMTD'
              AND Code = 'SMSNOTIFICATION'
              AND ISNULL(RecordDeleted, 'N') = 'N';
        SELECT @EmailNotification = GlobalCodeId
        FROM GlobalCodes
        WHERE Category = 'MOBNOTIFICATIONMTD'
              AND Code = 'EMAILNOTIFICATION'
              AND ISNULL(RecordDeleted, 'N') = 'N';
        SELECT @PermissionTemplateType = GlobalCodeId
        FROM GlobalCodes
        WHERE Category = 'PERMISSIONTEMPLATETP'
              AND Code = 'NOTIFICATIONS'
              AND ISNULL(RecordDeleted, 'N') = 'N';
        SELECT @EnablePushNotification = [Value]
        FROM SystemConfigurationKeys
        WHERE [Key] = 'EnablePushNotifications'
              AND ISNULL(RecordDeleted, 'N') = 'N';
        SELECT @EnableSMSNotification = [Value]
        FROM SystemConfigurationKeys
        WHERE [Key] = 'EnableSMSNotifications'
              AND ISNULL(RecordDeleted, 'N') = 'N';
        SELECT @EnableEmailNotification = [Value]
        FROM SystemConfigurationKeys
        WHERE [Key] = 'EnableEmailNotifications'
              AND ISNULL(RecordDeleted, 'N') = 'N';
        SELECT @MessageNotificationContent = [Value]
        FROM SystemConfigurationKeys
        WHERE [Key] = 'SetGenericMobileNotificationMessageText'
              AND ISNULL(RecordDeleted, 'N') = 'N';
        SELECT @AlertNotificationContent = [Value]
        FROM SystemConfigurationKeys
        WHERE [Key] = 'SetGenericMobileNotificationMessageTextForAlerts'
              AND ISNULL(RecordDeleted, 'N') = 'N';
        SELECT @FlagNotificationContent = [Value]
        FROM SystemConfigurationKeys
        WHERE [Key] = 'SetGenericMobileNotificationMessageTextForFlags'
              AND ISNULL(RecordDeleted, 'N') = 'N';
        SELECT @NotificationFrom = [Value]
        FROM SystemConfigurationKeys
        WHERE [Key] = 'SetFromValueForMobileNotificationMessage'
              AND ISNULL(RecordDeleted, 'N') = 'N';
        DECLARE @TempPermissionMethods TABLE
(StaffId            INT,
 NotificationMethod INT
);
        INSERT INTO @TempPermissionMethods
               SELECT SP.StaffId,
                      CASE
                          WHEN(@EnablePushNotification = 'Yes'
                               AND SP.RegisteredForMobileNotifications = 'Y'
                               AND EXISTS
(
    SELECT 1
    FROM MobileDevices MD
    WHERE SP.StaffId = MD.StaffId
          AND MD.SubscribedForPushNotifications = 'Y'
          AND ISNULL(MD.RecordDeleted, 'N') = 'N'
))
                          THEN @PushNotification
                          WHEN(@EnableSMSNotification = 'Yes'
                               AND SP.RegisteredForSMSNotifications = 'Y'
                               AND S.PhoneNumber IS NOT NULL)
                          THEN @SMSNotification
                          WHEN(@EnableEmailNotification = 'Yes'
                               AND SP.RegisteredForEmailNotifications = 'Y'
                               AND S.Email IS NOT NULL)
                          THEN @EmailNotification
                          ELSE NULL
                      END
               FROM StaffPreferences SP
                    JOIN Staff S ON SP.StaffId = S.StaffId
               WHERE ISNULL(SP.RecordDeleted, 'N') = 'N'
                     AND ISNULL(S.RecordDeleted, 'N') = 'N'
                     AND S.Active = 'Y';
				DELETE FROM @TempPermissionMethods WHERE NotificationMethod IS NULL;
        INSERT INTO NotificationQueues
(ToStaffId,
 NotificationId,
 NotificationType,
 NotificationMethod
)
-- Adding unread Alerts             
               SELECT A.ToStaffId,
                      A.AlertId,
                      @alertNotificationType,
                      TPM.NotificationMethod
               FROM Alerts AS A
                    JOIN @TempPermissionMethods TPM ON A.ToStaffId = TPM.StaffId
               WHERE A.Unread = 'Y'
                     AND IsNull(A.RecordDeleted, 'N') = 'N'
                     AND A.ToStaffId IS NOT NULL
                     AND NOT EXISTS
(
    SELECT 1
    FROM NotificationQueues NQ
    WHERE NQ.ToStaffId = A.ToStaffId
          AND NQ.NotificationId = A.AlertId
          AND NQ.NotificationType = @alertNotificationType
          AND IsNull(NQ.RecordDeleted, 'N') = 'N'
)
                     AND EXISTS
(
    SELECT 1
    FROM ViewStaffPermissions VSP
    WHERE VSP.StaffId = A.ToStaffId
          AND VSP.PermissionTemplateType = @PermissionTemplateType
          AND VSP.PermissionItemId = @alertNotificationType
)
   -- Adding unread messages             
               UNION
               SELECT M.ToStaffId,
                      M.MessageId,
                      @messageNotificationType,
                      TPM.NotificationMethod
               FROM Messages M
					JOIN @TempPermissionMethods TPM ON M.ToStaffId = TPM.StaffId
               WHERE M.Unread = 'Y'
                     AND IsNull(M.RecordDeleted, 'N') = 'N'                    
                     AND M.ToStaffId IS NOT NULL
                     AND NOT EXISTS
(
    SELECT 1
    FROM NotificationQueues NQ
    WHERE NQ.ToStaffId = M.ToStaffId
          AND NQ.NotificationId = M.MessageId
          AND NQ.NotificationType = @messageNotificationType
          AND IsNull(NQ.RecordDeleted, 'N') = 'N'
)
                     AND EXISTS
(
    SELECT 1
    FROM ViewStaffPermissions VSP
    WHERE VSP.StaffId = M.ToStaffId
          AND VSP.PermissionTemplateType = @PermissionTemplateType
          AND VSP.PermissionItemId = @messageNotificationType
)
-- Adding  Flags from ClientNotes which are created related to Client Tracking
      
               UNION
               SELECT CNA.StaffId,
                      CN.ClientNoteId,
                      @flagNotificationType,
                      TPM.NotificationMethod
               FROM ClientNotes CN
                    JOIN ClientNoteAssignedUsers CNA ON CN.ClientNoteId = CNA.ClientNoteId
                    JOIN TrackingProtocols TP ON CN.TrackingProtocolId = TP.TrackingProtocolId
					JOIN @TempPermissionMethods TPM ON CNA.StaffId = TPM.StaffId
               WHERE CN.Active = 'Y'
                     AND ISNULL(CN.RecordDeleted, 'N') = 'N'
                     AND ISNULL(CNA.RecordDeleted, 'N') = 'N'
                     AND ISNULL(TP.RecordDeleted, 'N') = 'N'
                     AND CNA.StaffId IS NOT NULL
                     AND (CAST(CN.StartDate AS DATE) = CAST(GETDATE() AS DATE)
                          OR (CN.EndDate IS NOT NULL
                              AND CAST(CN.EndDate AS DATE) = CAST(GETDATE() AS DATE)))
                     AND CN.TrackingProtocolId IS NOT NULL
                     
                     AND NOT EXISTS
(
    SELECT 1
    FROM NotificationQueues NQ
    WHERE NQ.ToStaffId = CNA.StaffId
          AND NQ.NotificationId = CN.ClientNoteId
          AND NQ.NotificationType = @flagNotificationType
          AND ISNULL(NQ.RecordDeleted, 'N') = 'N'
          AND CAST(NQ.CreatedDate AS DATE) = CAST(GETDATE() AS DATE)
)
                     AND EXISTS
(
    SELECT 1
    FROM ViewStaffPermissions VSP
    WHERE VSP.StaffId = CNA.StaffId
          AND VSP.PermissionTemplateType = @PermissionTemplateType
          AND VSP.PermissionItemId = @flagNotificationType
)

-- checking the value of SendAdvanceMobileNotificationForFlags key, then checking the Start and End Date is equal to sum of current date and the number of days with start and end date which configured in SendAdvanceMobileNotificationForFlagsNumDays key
               UNION
               SELECT CNA.StaffId,
                      CN.ClientNoteId,
                      @flagNotificationType,
                     TPM.NotificationMethod
               FROM ClientNotes CN
                    JOIN ClientNoteAssignedUsers CNA ON CN.ClientNoteId = CNA.ClientNoteId
                    JOIN TrackingProtocols TP ON CN.TrackingProtocolId = TP.TrackingProtocolId
					JOIN @TempPermissionMethods TPM ON CNA.StaffId = TPM.StaffId
               WHERE CN.Active = 'Y'
                     AND ISNULL(CN.RecordDeleted, 'N') = 'N'
                     AND ISNULL(CNA.RecordDeleted, 'N') = 'N'
                     AND ISNULL(TP.RecordDeleted, 'N') = 'N'
                     AND CNA.StaffId IS NOT NULL
                     AND (CAST(CN.StartDate AS DATE) = DATEADD(Day, CAST(@NumOfDaysForFlagNotification AS INT), CAST(GETDATE() AS DATE))
                          OR CAST(CN.EndDate AS DATE) = DATEADD(Day, CAST(@NumOfDaysForFlagNotification AS INT), CAST(GETDATE() AS DATE)))
                     AND CN.TrackingProtocolId IS NOT NULL
                     AND @NotificationForFlags = 'Yes'
                   
                     AND NOT EXISTS
(
    SELECT 1
    FROM NotificationQueues NQ
    WHERE NQ.ToStaffId = CNA.StaffId
          AND NQ.NotificationId = CN.ClientNoteId
          AND NQ.NotificationType = @flagNotificationType
          AND ISNULL(NQ.RecordDeleted, 'N') = 'N'
          AND CAST(NQ.CreatedDate AS DATE) = CAST(GETDATE() AS DATE)
)
                     AND EXISTS
(
    SELECT 1
    FROM ViewStaffPermissions VSP
    WHERE VSP.StaffId = CNA.StaffId
          AND VSP.PermissionTemplateType = @PermissionTemplateType
          AND VSP.PermissionItemId = @flagNotificationType
);
        SELECT NQ.NotificationQueueId,
               NQ.NotificationId,
               S.UserCode,
               GC.Code AS NotificationTypeCode,
               CASE
                   WHEN ISNULL(@MessageNotificationContent, '') = ''
                   THEN M.Message
                   ELSE ISNULL(@NotificationFrom,'SmartCare')+': '+@MessageNotificationContent
               END AS MessageText,
               CASE
                   WHEN ISNULL(@AlertNotificationContent, '') = ''
                   THEN A.Message
                   ELSE ISNULL(@NotificationFrom,'SmartCare')+': '+@AlertNotificationContent
               END AS AlertMessage,
               CASE
                   WHEN ISNULL(@FlagNotificationContent, '') = ''
                   THEN CN.Note
                   ELSE ISNULL(@NotificationFrom,'SmartCare')+': '+@FlagNotificationContent
               END AS FlagNote,
               NQ.NotificationMethod,
               CASE
                   WHEN NQ.NotificationMethod = @PushNotification
                   THEN NULL
                   WHEN NQ.NotificationMethod = @SMSNotification
                   THEN S.PhoneNumber
                   WHEN NQ.NotificationMethod = @EmailNotification
                   THEN S.Email
                   ELSE NULL
               END AS ToPhoneOrEmilAddress,
               CASE
                   WHEN NQ.NotificationType = @alertNotificationType
                   THEN 'Alert'
                   WHEN NQ.NotificationType = @messageNotificationType
                   THEN 'Message'
                   WHEN NQ.NotificationType = @flagNotificationType
                   THEN 'Flag/Note'
                   ELSE NULL
               END AS EmailSubject,
               NQ.NotificationRetryCount
        FROM NotificationQueues NQ
             LEFT JOIN staff S ON NQ.ToStaffId = S.StaffId
                                  AND S.Active = 'Y'
                                  AND ISNULL(S.RecordDeleted, 'N') = 'N'
             LEFT JOIN GlobalCodes GC ON NQ.NotificationType = GC.GlobalCodeId
                                         AND GC.Active = 'Y'
                                         AND ISNULL(GC.RecordDeleted, 'N') = 'N'
             LEFT JOIN Messages M ON NQ.NotificationId = M.MessageId
                                     AND NQ.NotificationType = @messageNotificationType
                                     AND ISNULL(M.RecordDeleted, 'N') = 'N'
             LEFT JOIN Alerts A ON NQ.NotificationId = A.AlertId
                                   AND NQ.NotificationType = @alertNotificationType
                                   AND ISNULL(A.RecordDeleted, 'N') = 'N'
             LEFT JOIN ClientNotes CN ON NQ.NotificationId = CN.ClientNoteId
                                         AND NQ.NotificationType = @flagNotificationType
                                         AND ISNULL(CN.RecordDeleted, 'N') = 'N'
        WHERE ISNULL(NQ.NotificationStatus, 'N') = 'N'
              AND ISNULL(NQ.NotificationRetryCount, 0) < 5
              AND ISNULL(NQ.RecordDeleted, 'N') = 'N'
              AND NQ.NotificationMethod != 0;
    END TRY
    BEGIN CATCH
        DECLARE @Error VARCHAR(8000);
        SET @Error = CONVERT(VARCHAR, ERROR_NUMBER())+'*****'+CONVERT(VARCHAR(4000), ERROR_MESSAGE())+'*****'+isnull(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetNotificationQueues')+'*****'+CONVERT(VARCHAR, ERROR_LINE())+'*****'+CONVERT(VARCHAR, ERROR_SEVERITY())+'*****'+CONVERT(VARCHAR, ERROR_STATE());
        RAISERROR(@Error, 16, 1);
    END CATCH;      
      
    