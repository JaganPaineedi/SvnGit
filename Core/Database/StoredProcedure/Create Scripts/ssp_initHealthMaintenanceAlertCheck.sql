GO

/****** Object:  StoredProcedure [dbo].[ssp_initHealthMaintenanceAlertCheck]    Script Date: 09/18/2014 19:21:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_initHealthMaintenanceAlertCheck]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_initHealthMaintenanceAlertCheck]
GO

GO

/********************************************************************************************/                                                                    
/* Stored Procedure: ssp_initHealthMaintenanceAlertCheck          */                                                           
/* Copyright: 2012 Streamline Healthcare Solutions           */                                                                    
/* Creation Date:  22 Sep 2014 by Prasan               */                                                                    
/* Purpose: Gets Data from PrimaryCate Health Maintenance Alert Check (On update of specific screens) */                                                                                                                                            
/* Output Parameters:                  */                                                                    
/* Return:                     */  
/* Data Modifications:                  */
/* 22 Sep 2014    Prasan   Created   */    
/* 11 Nov  2014	  Ponnin	Added a screenid -778  (Client Order Details)  Why :  For task #4 of Certification 2014 */ 
/* 11 Nov  2014	  Ponnin	Added a screenid -978  (Diagnosis New)  Why :  For task #4 of Certification 2014 */ 
/* 21 Dec 2015	   Ponnin	Added Screenid 29 (Service Note) for alert check. For task #14 of Diagnosis Changes (ICD10) */ 
-- 12/21/2017    jcarlson	Core Bugs 2491 : Fixed issue where sometimes screenname would contain " and these were not being escaped                                                                 
/********************************************************************************************/ 


/****** Object:  StoredProcedure [dbo].[ssp_initHealthMaintenanceAlertCheck]    Script Date: 09/18/2014 19:21:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[ssp_initHealthMaintenanceAlertCheck]  --ssp_initHealthMaintenanceAlertCheck 1
(
@staffID INT
)
AS
BEGIN
-----------------------------********************************************-------------------------------------------------------------
DECLARE @performHealthMaintenaceAlert CHAR(1) = 'N'
		,@performHealthMaintenaceAlertForStaff CHAR(1) = 'N'
		,@RoleId INT = 0
		,@returnValue VARCHAR(30) = 'false';

	----- (1) check Health Maintenace to be performed--------------------------------------
	SELECT @performHealthMaintenaceAlert = ISNULL(sck.Value, 'N')
	FROM SystemConfigurationKeys sck
	WHERE sck.[Key] = 'validateHealthMaintenaceForClient'
		AND ISNULL(sck.RecordDeleted, 'N') = 'N'

	----- (1) ENDS-------------------------------------------------------------------------	
	--(2) check Health Maintenace  to be performed for staff ------------------------------ 
	SELECT @RoleId = GlobalCodeId
	FROM globalcodes gc
	WHERE gc.category = 'STAFFROLE'
		AND gc.Code = 'HEALTHMAINTENANCEALERT'
		AND ISNULL(gc.RecordDeleted, 'N') = 'N'
		AND gc.Active = 'Y'

	SELECT @performHealthMaintenaceAlertForStaff = CASE 
			WHEN COUNT(*) > 0
				THEN 'Y'
			ELSE 'N'
			END
	FROM StaffRoles sr
	WHERE sr.StaffId = @staffId
		AND sr.RoleId = @RoleId
		AND ISNULL(sr.RecordDeleted, 'N') = 'N'

	----- (2) ENDS--------------------------------------------------------------------------
	IF (
			@performHealthMaintenaceAlert = 'Y'
			AND @performHealthMaintenaceAlertForStaff = 'Y'
			)
	BEGIN
		SET @returnValue = 'true'
	END

 
	
-----------------------------********************************************-------------------------------------------------------------	
DECLARE @jsonStr VARCHAR(max) = NULL;

SELECT @jsonStr = coalesce(@jsonStr + ',' + '"' + cast(t.ScreenId AS VARCHAR) + '":' + '"' + t.ScreenName + '"', 
						   '"' + cast(t.ScreenId AS VARCHAR) + '":' + '"' + t.ScreenName + '"')
FROM (
	SELECT ScreenId
		,REPLACE(ScreenName,'"','\"') AS ScreenName
	FROM DocumentCodes DC
	INNER JOIN Screens S ON DC.DocumentCodeId = S.DocumentCodeId
		AND DC.DiagnosisDocument = 'Y'
		AND ISNULL(DC.RecordDeleted, 'N') = 'N'
		AND DC.Active = 'Y'
	
	UNION
	
	SELECT ScreenId
		,REPLACE(ScreenName,'"','\"') AS ScreenName
	FROM Screens S
	WHERE s.ScreenId IN (
			3
			,370
			,720
			,772
			,716
			,1027
			,778 -- Client Order Details
			,978 -- Diagnosis New
			,29 -- Service Note
			)
	) t

	
-----------------------------********************************************-------------------------------------------------------------                        
 -- output table 1
SELECT @returnValue  +'|;' + '{' + @jsonStr + '}'

END
GO


