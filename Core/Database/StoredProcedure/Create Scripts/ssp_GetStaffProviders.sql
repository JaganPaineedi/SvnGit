 IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetStaffProviders]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetStaffProviders]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
 
  
CREATE PROCEDURE [dbo].[ssp_GetStaffProviders]    
AS

/******************************************************************************    
**  File: ssp_GetStaffProviders.sql    
**  Name: ssp_GetStaffProviders    
**  Desc: Provides Staff list who is having permission to MeaningfulUseBehavioralHealth and MeaningfulUsePrimaryCare    
**    
**  Return values: <Return Values>    
**    
**  Called by: <Code file that calls>    
**    
**  Parameters:    
**  Input   Output    
**  ServiceId      -----------    
**    
**  Created By: Veena S Mani    
**  Date:  May 06 2014    
*******************************************************************************    
**  Change History    
*******************************************************************************    
**  Date:  Author:    Description:    
**  --------  --------    -------------------------------------------    
--  27th May 2014 Kirtee Duplicate record was displaying due to the role.     
    
*******************************************************************************/   
    
BEGIN    
 BEGIN TRY    
  SELECT DISTINCT sf.StaffId    
   ,sf.LastName + ', ' + sf.FirstName AS StaffName    
  FROM Staff AS sf    
  INNER JOIN ViewStaffPermissions AS vsp ON sf.StaffId = vsp.StaffId    
  WHERE PermissionTemplateType = 5704    
   AND PermissionItemId IN (    
    5732    
    ,5733    
    )    
    --and sf.StaffId in (13321,13322)  
  ORDER BY StaffName    
 END TRY    
    
 BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)    
    
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) +   
  '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetStaffProviders') + '*****' +   
  CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())    
    
  RAISERROR (    
    @Error    
    ,-- Message text.    
    16    
    ,-- Severity.    
    1 -- State.    
    );    
 END CATCH    
    
 RETURN    
END 