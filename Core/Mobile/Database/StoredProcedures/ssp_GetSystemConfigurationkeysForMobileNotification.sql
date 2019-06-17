
IF EXISTS
(
    SELECT *
    FROM sys.objects
    WHERE OBJECT_ID = OBJECT_ID(N'[ssp_GetSystemConfigurationkeysForMobileNotification]')
          AND OBJECTPROPERTY(OBJECT_ID, N'IsProcedure') = 1
)
    DROP PROCEDURE [dbo].[ssp_GetSystemConfigurationkeysForMobileNotification];
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE PROCEDURE [dbo].[ssp_GetSystemConfigurationkeysForMobileNotification]
AS

/***********************************************************************************************************/

/* Stored Procedure : ssp_GetSystemConfigurationkeysForMobileNotification                                  */

/* Copyright        : Streamline Healthcate Solutions                                                      */

/* Purpose          : Returning SystemConfigurationKeys value for MobileNotifications Console Applications */

/* Author           : Vishnu Narayanan                                                                     */

/* Date             : 07 September 2018                                                                    */

/* Updates                                                                                                 */

/* Dates        Author            Purpose                                                                  */

/* 03-Dec-2018  Vishnu Narayanan  Returning Notification Methods                                           */

/* 14-Dec-2018  Vishnu Narayanan  Renamed 'NOTIFICATIONMETHODS' Code to 'MOBNOTIFICATIONMTD' since         */
/*                                'NOTIFICATIONMETHOD' already exist.                                      */
/***********************************************************************************************************/

    BEGIN TRY
        DECLARE @ServiceUrl VARCHAR(MAX);
        DECLARE @AuthorityUrl VARCHAR(MAX);
        DECLARE @ResourseOwnerSecret VARCHAR(MAX);
        DECLARE @CustomerIdentifier VARCHAR(MAX);
        DECLARE @InstanceIdentifier VARCHAR(MAX);
        DECLARE @PushNotificationMethod INT;
        DECLARE @SMSNotificationMethod INT;
        DECLARE @EmailNotificationMethod INT;
        SELECT @ServiceUrl = [Value]
        FROM SystemConfigurationKeys
        WHERE [Key] = 'MobileCentralServiceUrl'
              AND ISNULL(RecordDeleted, 'N') = 'N';
        SELECT @AuthorityUrl = [Value]
        FROM SystemConfigurationKeys
        WHERE [Key] = 'MobileCentralAuthorityUrl'
              AND ISNULL(RecordDeleted, 'N') = 'N';
        SELECT @ResourseOwnerSecret = [Value]
        FROM SystemConfigurationKeys
        WHERE [Key] = 'ResourceOwnerGrantSecret'
              AND ISNULL(RecordDeleted, 'N') = 'N';
        SELECT @CustomerIdentifier = [Value]
        FROM SystemConfigurationKeys
        WHERE [Key] = 'CustomerIdentifier'
              AND ISNULL(RecordDeleted, 'N') = 'N';
        SELECT @InstanceIdentifier = [Value]
        FROM SystemConfigurationKeys
        WHERE [Key] = 'SmartCareInstanceIdentifier'
              AND ISNULL(RecordDeleted, 'N') = 'N';
        SELECT @PushNotificationMethod = GlobalCodeId
        FROM GlobalCodes
        WHERE Category = 'MOBNOTIFICATIONMTD'
              AND Code = 'PUSHNOTIFICATION'
              AND ISNULL(RecordDeleted, 'N') = 'N';
        SELECT @SMSNotificationMethod = GlobalCodeId
        FROM GlobalCodes
        WHERE Category = 'MOBNOTIFICATIONMTD'
              AND Code = 'SMSNOTIFICATION'
              AND ISNULL(RecordDeleted, 'N') = 'N';
        SELECT @EmailNotificationMethod = GlobalCodeId
        FROM GlobalCodes
        WHERE Category = 'MOBNOTIFICATIONMTD'
              AND Code = 'EMAILNOTIFICATION'
              AND ISNULL(RecordDeleted, 'N') = 'N';
        SELECT ISNULL(@ServiceUrl, '') AS ServiceUrl,
               ISNULL(@AuthorityUrl, '') AS AuthorityUrl,
               ISNULL(@ResourseOwnerSecret, '') AS resourceOwnerGrantSecret,
               ISNULL(@CustomerIdentifier, '') AS customerIdentifier,
               ISNULL(@InstanceIdentifier, '') AS smartCareInstanceIdentifier,
               @PushNotificationMethod AS PushNotificationMethod,
               @SMSNotificationMethod AS SMSNotificationMethod,
               @EmailNotificationMethod AS EmailNotificationMethod;
    END TRY
    BEGIN CATCH
        DECLARE @Error VARCHAR(8000);
        SET @Error = CONVERT(VARCHAR, ERROR_NUMBER())+'*****'+CONVERT(VARCHAR(4000), ERROR_MESSAGE())+'*****'+isnull(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetNotificationQueues')+'*****'+CONVERT(VARCHAR, ERROR_LINE())+'*****'+CONVERT(VARCHAR, ERROR_SEVERITY())+'*****'+CONVERT(VARCHAR, ERROR_STATE());
        RAISERROR(@Error, 16, 1);
    END CATCH;