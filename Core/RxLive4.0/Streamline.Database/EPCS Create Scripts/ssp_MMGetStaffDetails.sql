/****** Object:  StoredProcedure [dbo].[ssp_MMGetStaffDetails]    Script Date: 4/15/2014 8:20:49 AM ******/
IF EXISTS ( SELECT	1
			FROM	INFORMATION_SCHEMA.ROUTINES
			WHERE	SPECIFIC_SCHEMA = 'dbo'
					AND SPECIFIC_NAME = 'ssp_MMGetStaffDetails' ) 
	DROP PROCEDURE [dbo].[ssp_MMGetStaffDetails]
GO

/****** Object:  StoredProcedure [dbo].[ssp_MMGetStaffDetails]    Script Date: 4/15/2014 8:20:49 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_MMGetStaffDetails]  
/********************************************************************************  
-- Stored Procedure: dbo.ssp_MMGetStaffDetails    
--  
-- Copyright: Streamline Healthcate Solutions  
--  
-- Purpose: gets staff details from Staff table for SmartCareRx  
--  
-- Updates:                                                         
-- Date        Author			Purpose  
-- Jul 9 2010  Ryan Noble		Fetch staff details for SmartCareRx.  
-- Aug 6 2016	Malathi Shiva	EPCS Task# 4 : Added NADEANumber in the select query
-- Oct 28 2016	Pavani      Added MobileSmartKey,AllowMobileAccess,MobileSmartKeyExpiresNextLogin columns Mobile#2
-- 20-Nov-2016 Lakshmi Kanth              Implemented Scanning Access logic to the loggedIn Staff, Ionia - Support #370   
*********************************************************************************/
AS 
	SELECT	s.Staffid,
			RTRIM(LTRIM(s.LastName)) + ', ' + RTRIM(s.FirstName) AS StaffName,
			s.Active,
			ISNULL(s.AdminStaff, 'N') AS AdminStaff,
			s.SSN,
			s.Sex,
			s.Degree,
			ISNULL(s.Prescriber, 'N') AS Prescriber,
			s.UserCode,
			s.SigningSuffix,
			RTRIM(LTRIM(s.LastName)) + ', ' + RTRIM(s.FirstName) + ' '
			+ ISNULL(gcd.CodeName, '') AS StaffNameWithDegree,
			LastPrescriptionReviewTime
			,EnableRxPopUpAcknowledgement
			,s.NADEANumber
			-- Oct 28 2016	Pavani
			,MobileSmartKey
            ,AllowMobileAccess
            ,MobileSmartKeyExpiresNextLogin
            ,AllowAccessToAllScannedDocuments
	FROM	Staff s
			LEFT JOIN GlobalCodes gcd ON s.Degree = gcd.GlobalCodeId
	WHERE	ISNULL(s.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(gcd.RecordDeleted, 'N') <> 'Y'
	ORDER BY s.LastName,
			s.FirstName,
			s.StaffId

GO


