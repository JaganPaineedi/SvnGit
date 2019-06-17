/****** Object:  StoredProcedure [dbo].[ssp_MMGetStaffDetails]    Script Date: 4/15/2014 8:20:49 AM ******/
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.ROUTINES
		WHERE SPECIFIC_SCHEMA = 'dbo'
			AND SPECIFIC_NAME = 'ssp_MMGetStaffDetails'
		)
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
-- Date        Author      Purpose  
-- Jul 9 2010  Ryan Noble  Fetch staff details for SmartCareRx.  
-- 09-Aug-2016		Vithobha		Added NADEANumber in Staff table, EPCS #4  
/* 22-Nov-2016		Pavani 		What: Added MobileSmartKey,AllowMobileAccess,MobileSmartKeyExpiresNextLogin Columnsin Staff table
                                Why :Mobile #2  */ 
-- Nov-28-2016 Lakshmi Kanth         Added coloumn 'AllowAccessToAllScannedDocuments' to staff table, Ionia - Support #370 

*********************************************************************************/
AS
SELECT s.Staffid
	,RTRIM(LTRIM(s.LastName)) + ', ' + RTRIM(s.FirstName) AS StaffName
	,s.Active
	,ISNULL(s.AdminStaff, 'N') AS AdminStaff
	,s.SSN
	,s.Sex
	,s.Degree
	,ISNULL(s.Prescriber, 'N') AS Prescriber
	,s.UserCode
	,s.SigningSuffix
	,RTRIM(LTRIM(s.LastName)) + ', ' + RTRIM(s.FirstName) + ' ' + ISNULL(gcd.CodeName, '') AS StaffNameWithDegree
	,LastPrescriptionReviewTime
	,EnableRxPopUpAcknowledgement
	,NADEANumber
	--22-Nov-2016		Pavani
	,MobileSmartKey
	,AllowMobileAccess
	,MobileSmartKeyExpiresNextLogin
	,AllowAccessToAllScannedDocuments
--End
FROM Staff s
LEFT JOIN GlobalCodes gcd ON s.Degree = gcd.GlobalCodeId
WHERE ISNULL(s.RecordDeleted, 'N') <> 'Y'
	AND ISNULL(gcd.RecordDeleted, 'N') <> 'Y'
ORDER BY s.LastName
	,s.FirstName
	,s.StaffId
GO


