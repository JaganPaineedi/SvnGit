/****** Object:  StoredProcedure [dbo].[ssp_GetMobileDeviceName]    Script Date: 05/10/2018 3:41:44 PM ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetMobileDeviceName]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetMobileDeviceName]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetMobileDeviceName]    Script Date: 05/10/2018 3:41:44 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ssp_GetMobileDeviceName] @StaffId int      
AS      
/***************************************************************************************************/        
/* Stored Procedure : ssp_GetMobileDeviceName                                                      */        
/* Copyright        : Streamline Healthcate Solutions                                              */        
/* Purpose          : Returning name of Mobile device                                              */         
/* Author           : Vishnu Narayanan                                                             */        
/* Date             : 05 October 2018                                                              */        
/***************************************************************************************************/        
BEGIN      
SELECT MobileDeviceId,MobileDeviceName,
CASE 
WHEN SubscribedForPushNotifications='Y' THEN 'Yes'
WHEN ISNULL(SubscribedForPushNotifications,'N')='N' THEN 'No'
END
AS 'SubscribedForPushNotifications' 
FROM MobileDevices WHERE StaffId = @StaffId AND ISNULL(RecordDeleted,'N')='N'     
END