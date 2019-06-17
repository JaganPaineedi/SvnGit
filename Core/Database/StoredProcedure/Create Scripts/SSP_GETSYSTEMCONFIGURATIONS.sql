 IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_GETSYSTEMCONFIGURATIONS]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE SSP_GETSYSTEMCONFIGURATIONS
GO
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
 
Create PROCEDURE [DBO].[SSP_GETSYSTEMCONFIGURATIONS]

As
        
Begin        
/*========================================================================================================
-Stored Procedure: SSP_GETSYSTEMCONFIGURATIONS
-Creation Date:  01/15/2018
-Created By: Pranay Bodhu
-Purpose:
	Called by Fax-Server to Get the SystemConfiguratios.
-Input Parameters:None
-Output Parameters:None
-Return:
   Returns All the Config values.
-Called by:
	FaxSerivce Client Windows Service
Log:
-Date                           Name                                      Purpose
	
========================================================================================================*/     
      

SELECT  ImageDatabaseConfigurationName ,
        ReportURL ,
        ReportFolderName ,
        ReportServerDomain ,
        ReportServerUserName ,
        ReportServerPassword ,
        ReportServerConnection,
		si.ImageServerURL,
		sbs.ConnectionString
FROM    SystemConfigurations
        CROSS JOIN ImageServers si
		CROSS JOIN SystemDatabases sbs
		--SELECT *FROM dbo.ImageServers

--Checking For Errors
If (@@error!=0)
Begin
	RAISERROR  ('SSP_GETSYSTEMCONFIGURATIONS: An Error Occured',16,1) 
	Return
End         
        

End





GO

