IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetImageRecordScreenDropDowns]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetImageRecordScreenDropDowns]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetImageRecordScreenDropDowns] @LoggedInStaffId INT
	,@ScreenType INT
	,-- 5761 - Detail page or 5762 - List Page            
	@AssociatedWithTypeId INT = NULL
	/********************************************************************************                                  
-- Stored Procedure: ssp_GetImageRecordDropDowns                               
--                                  
-- Copyright: Streamline Healthcate Solutions                                  
--                                  
-- Purpose: gets records for dropdowns used in Image Record list and detail pages             
--                                  
-- Updates:                                                                                         
-- Date        Author      Purpose              
-- 08.30.2010  SFarber     Created.            
-- 09.07.2010  SFarber     Renamed AssociatedWithId to AssociatedWithTypeId and AssociatedWithName to AssociatedWithTypeName.            
-- 09.14.2010  SFarber     Added @AssociatedWithTypeId argument.        
-- 05.06.2011  Rakesh      Added Associated ID with for ClientCovergePlan(5820) use same Cateogory "StaffScanType"        
-- 05.09.2011  Karan Garg      Added Associated ID with for ClientCovergePlan(5820) use Cateogory "COVERAGEPLANIMAGETYP"           
-- 03.01.2012  Saurav Pande Added Associated Id with for Crisis Plan use category "ImageAssociatedWith"
-- 06.14.2012  Saurav Pande Reverted changes made on -- 03.01.2012 for Crisis Plan DocumentType 11 for Image 
-- 10.09.2013  John Sudhakar Eliminate “Redacted Disclosure”(GlobalCodeId 5819) for AssociatedWith dropdown.
-- 12.13.2013  Manju P     Modified to get DisplayAs as StaffName from staff table. What/Why: Task: Core Bugs #1315 Staff Detail Changes
-- 23.12.2013  Md Hussain  Added Associated ID with for Appeals(5817) use GlobalCodes Cateogory "APPEALSCANTYPE"  
-- 07/05/2015  NJain	   Added Record Deleted and Active checks on all GlobalCodes references
-- 05 Apr 2018 Rajeshwari  Added Associated ID with for Client order(5828) use globalcodeid in table globalsubcodes #98 Renaissance - Environment Issues Tracking
-- 09/27/2018  Shankha	   Added logic for Portal users to only get DocumentCodes with AllowClientPortalUserAsAuthor = ''
*********************************************************************************/
AS
DECLARE @AssociatedWith TABLE (
	AssociatedWithTypeId INT
	,AssociatedWithTypeName VARCHAR(250)
	)
DECLARE @AssociatedId TABLE (
	AssociatedWithTypeId INT
	,AssociatedId INT
	,AssociateIdName VARCHAR(250)
	)
DECLARE @Staff TABLE (
	StaffId INT
	,StaffName VARCHAR(100)
	)

IF @AssociatedWithTypeId IS NOT NULL
	INSERT INTO @AssociatedWith (
		AssociatedWithTypeId
		,AssociatedWithTypeName
		)
	SELECT gc.GlobalCodeId
		,gc.CodeName
	FROM GlobalCodes gc
	WHERE gc.GlobalCodeId = @AssociatedWithTypeId
		AND ISNULL(gc.RecordDeleted, 'N') = 'N'
		AND gc.Active = 'Y'
ELSE
	INSERT INTO @AssociatedWith (
		AssociatedWithTypeId
		,AssociatedWithTypeName
		)
	SELECT vsp.PermissionItemId
		,gc.CodeName
	FROM ViewStaffPermissions vsp
	JOIN GlobalCodes gc ON gc.GlobalCodeId = vsp.PermissionItemId
	WHERE vsp.StaffId = @LoggedInStaffId
		AND vsp.PermissionTemplateType = 5908
		AND ISNULL(gc.RecordDeleted, 'N') = 'N'
		AND gc.Active = 'Y'

IF EXISTS (
		SELECT 1
		FROM Staff
		WHERE StaffId = @LoggedInStaffId
			AND TempClientId IS NOT NULL
		)
BEGIN
	INSERT INTO @AssociatedId (
		AssociatedWithTypeId
		,AssociatedId
		,AssociateIdName
		)
	SELECT aw.AssociatedWithTypeId
		,dc.DocumentCodeId
		,dc.DocumentName
	FROM DocumentCodes dc
	JOIN @AssociatedWith aw ON aw.AssociatedWithTypeId = 5811 --Client (Medical Records)       
	WHERE dc.Active = 'Y'
		AND dc.DocumentType = 17
		AND isnull(DC.AllowClientPortalUserAsAuthor, 'N') = 'Y'
		AND ISNULL(dc.RecordDeleted, 'N') = 'N'
END
ELSE
BEGIN
	INSERT INTO @AssociatedId (
		AssociatedWithTypeId
		,AssociatedId
		,AssociateIdName
		)
	SELECT aw.AssociatedWithTypeId
		,dc.DocumentCodeId
		,dc.DocumentName
	FROM DocumentCodes dc
	JOIN @AssociatedWith aw ON aw.AssociatedWithTypeId = 5811 --Client (Medical Records)       
	WHERE dc.Active = 'Y'
		AND dc.DocumentType = 17
		AND ISNULL(dc.RecordDeleted, 'N') = 'N'
END

--ADDITIONAL ITEMS
INSERT INTO @AssociatedId (
	AssociatedWithTypeId
	,AssociatedId
	,AssociateIdName
	)
SELECT aw.AssociatedWithTypeId
	,et.EventTypeId
	,et.EventName
FROM EventTypes AS et
JOIN DocumentCodes AS dc ON dc.DocumentCodeId = et.AssociatedDocumentCodeId
JOIN @AssociatedWith aw ON aw.AssociatedWithTypeId = 5812
WHERE dc.Active = 'Y'
	AND dc.DocumentType = 17
	AND ISNULL(dc.RecordDeleted, 'N') = 'N'
	AND ISNULL(et.RecordDeleted, 'N') = 'N'

UNION

SELECT aw.AssociatedWithTypeId
	,gc.GlobalCodeId
	,gc.CodeName
FROM GlobalCodes gc
JOIN @AssociatedWith aw ON aw.AssociatedWithTypeId IN (
		5813
		,5814
		,5815
		,5816
		,5817
		,5820
		,5829
		)
WHERE gc.Category = CASE aw.AssociatedWithTypeId
		WHEN 5813
			THEN 'CLIENTSCANTYPE'
		WHEN 5814
			THEN 'STAFFSCANTYPE'
		WHEN 5815
			THEN 'PROVIDERSCANTYPE'
		WHEN 5816
			THEN 'GENERALSCANTYPE'
		WHEN 5817
			THEN 'APPEALSCANTYPE'
		WHEN 5820
			THEN 'COVERAGEPLANIMAGETYP'
		WHEN 5829
			THEN 'PROVIDERSCANTYPE'
		END
	AND gc.Active = 'Y'
	AND ISNULL(gc.RecordDeleted, 'N') = 'N'

UNION -- 05.04.2018  Rajeshwari

SELECT aw.AssociatedWithTypeId
	,gc.GlobalSubCodeId
	,gc.SubCodeName
FROM globalsubcodes gc
JOIN @AssociatedWith aw ON aw.AssociatedWithTypeId = 5828
WHERE gc.GlobalCodeId = 5828
	AND gc.Active = 'Y'
	AND ISNULL(gc.RecordDeleted, 'N') = 'N'

IF @ScreenType = 5761 -- Detail page            
BEGIN
	INSERT INTO @AssociatedId (
		AssociatedWithTypeId
		,AssociatedId
		,AssociateIdName
		)
	SELECT aw.AssociatedWithTypeId
		,NULL
		,''
	FROM @AssociatedWith aw

	INSERT INTO @AssociatedWith (
		AssociatedWithTypeId
		,AssociatedWithTypeName
		)
	SELECT NULL
		,''
END
ELSE IF @ScreenType = 5762 -- List page            
BEGIN
	--delete from @AssociatedWith where AssociatedWithTypeId in (5817, 5818) -- Exclude Appeals & Tasks from list page            
	DELETE
	FROM @AssociatedWith
	WHERE AssociatedWithTypeId = 5818 -- Exclude Tasks from list page 

	IF @AssociatedWithTypeId IS NULL
		INSERT INTO @AssociatedWith (
			AssociatedWithTypeId
			,AssociatedWithTypeName
			)
		SELECT 0
			,'All Associations'
		
		UNION
		
		SELECT - 1
			,'Not Associated Yet'

	INSERT INTO @AssociatedId (
		AssociatedWithTypeId
		,AssociatedId
		,AssociateIdName
		)
	SELECT aw.AssociatedWithTypeId
		,0
		,'All Record Types'
	FROM @AssociatedWith aw
END

-- Associated With dropdown            
SELECT AssociatedWithTypeId
	,AssociatedWithTypeName
FROM @AssociatedWith
ORDER BY CASE ISNULL(AssociatedWithTypeId, 0)
		WHEN 0
			THEN 1
		WHEN - 1
			THEN 2
		ELSE 3
		END
	,AssociatedWithTypeId

-- Record Type dropdown            
SELECT AssociatedWithTypeId
	,AssociatedId
	,AssociateIdName
FROM @AssociatedId
ORDER BY AssociatedWithTypeId
	,CASE ISNULL(AssociatedId, 0)
		WHEN 0
			THEN 1
		ELSE 2
		END
	,AssociateIdName

-- Staff dropdown            
IF @ScreenType = 5762
BEGIN
	-- All staff members who have access to the Scanning banner            
	INSERT INTO @Staff (
		StaffId
		,StaffName
		)
	SELECT 0
		,'All Scanning Staff'
	
	UNION
	
	SELECT s.StaffId
		,s.DisplayAs --s.LastName + ', ' + s.FirstName            
	FROM Staff s
	JOIN ViewStaffPermissions vsp ON vsp.StaffId = s.StaffId
		AND vsp.PermissionTemplateType = 5703
		AND vsp.PermissionItemId = 123

	SELECT StaffId
		,StaffName
	FROM @Staff
	ORDER BY CASE 
			WHEN StaffId = 0
				THEN 1
			ELSE 2
			END
		,StaffName
END
GO


