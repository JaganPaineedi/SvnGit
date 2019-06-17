/****** Object:  StoredProcedure [dbo].[SSP_SCInsertNotificationQueueLog]    Script Date: 10/29/2014 15:03:31 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCInsertNotificationQueueLog]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_SCInsertNotificationQueueLog]
GO

/****** Object:  StoredProcedure [dbo].[SSP_SCInsertNotificationQueueLog]    Script Date: 12/14/2018 15:03:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_SCInsertNotificationQueueLog] @StaffId INT
	,@NotificationId INT = NULL
	,@NotificationType INT = NULL
	,@NotificationStatus CHAR(1) = NULL
	,@NotificationMethod INT = NULL
	,@UserCode VARCHAR(100) = NULL
AS
-- =============================================      
-- Author:  Pradeep      
-- Create date: 12/14/2018
-- Description: Insert into NotificationQueues
/*      
 Author			Modified Date			Reason      
   
      
*/
-- =============================================      
BEGIN
	BEGIN TRY
		INSERT INTO NotificationQueues (
			ToStaffId
			,NotificationId
			,NotificationType
			,NotificationStatus
			,NotificationMethod
			)
		VALUES (
			@StaffId
			,@NotificationId
			,@NotificationType
			,@NotificationStatus
			,@NotificationMethod
			)
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'SSP_SCInsertNotificationQueueLog') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


