/****** Object:  StoredProcedure [dbo].[ssp_UpdateMobileDevice]    Script Date: 10/10/2018 3:41:44 PM ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_UpdateMobileDevice]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_UpdateMobileDevice]
GO

/****** Object:  StoredProcedure [dbo].[ssp_UpdateMobileDevice]    Script Date: 10/10/2018 3:41:44 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ssp_UpdateMobileDevice] @MobileDeviceId int ,   
@deletedBy varchar(50)    
AS      
/***************************************************************************************************/        
/* Stored Procedure : ssp_UpdateMobileDevice                                                       */        
/* Copyright        : Streamline Healthcate Solutions                                              */        
/* Purpose          : Deleting Mobile device from MobileDevices                                    */         
/* Author           : Vishnu Narayanan                                                             */        
/* Date             : 10 October 2018                                                              */
/* 22 Oct 2018 Vishnu Narayanan Added code for returning MobileDeviceIdentifier                    */        
/***************************************************************************************************/        
BEGIN         
UPDATE MobileDevices SET RecordDeleted = 'Y',DeletedBy=@deletedBy,DeletedDate= GETDATE() WHERE MobileDeviceId = @MobileDeviceId AND ISNULL(RecordDeleted,'N')='N'    
SELECT ISNULL(MobileDeviceIdentifier, '') AS Result FROM MobileDevices WHERE MobileDeviceId = @MobileDeviceId  
END