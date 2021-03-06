IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMGetHomePageScreenStaff]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_PMGetHomePageScreenStaff]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_PMGetHomePageScreenStaff] @LoggedInUserId INT
	,@StaffId INT = NULL
AS

/*********************************************************************/
/* Stored Procedure: dbo.ssp_PMGetHomePageScreenStaff     */
/* Creation Date:  17 Nov  2011           */
/*                                                                   */
/* Purpose: retuns HomePageScreenId for the LoggedInStaff    */
/*                                                                   */
/* Input Parameters:             */
/*                                                                   */
/* Output Parameters:             */
/*                                                                   */
/*                                                                   */
/* Called By:                                                        */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/* Author: Mary Suma                                                 */
/* 21-Nov-2011 MSUma  Included Column name for HomePageScreenId*/
/* 16-Jan-2012 Pradeepa Included Column name for ClientPagePreferenceScreenId  */
/* 09-Aug-2014 Venkatesh If the user have the permission to see the home page screen and he didn't set the ClientPagePreference  
				SP was returning ClientPagePreferenceScreenId as NULL. So if it is null set the @ClientPagePreferenceScreenId=19 - Ref Core Bugs-133*/
/* 30-Dec-2015  Chethan N    What : Default to Summary Page as Client Preference Screen and Home Page for Non Staff User if not set.
							Why : Engineering Improvement Initiatives- NBL(I) Task# 279        
   12-Dec-2018  aaron.udelhoven what: Added code to include “Documents (View) Access to documents also with 5702 and Banner Active check.
                                Code added by Journey Staff .Why :  Journey-Support Go Live > Tasks#387*/
/*********************************************************************/
--HomePageScreenId     
SET @StaffId = isnull(@StaffId, @LoggedInUserId)

DECLARE @HomePageScreenId INT
DECLARE @ClientPagePreferenceScreenId INT
DECLARE @NonStaffUser CHAR

SELECT @NonStaffUser = NonStaffUser
FROM Staff
WHERE StaffId = @LoggedInUserId

SELECT @HomePageScreenId = HomePageScreenId
	,@ClientPagePreferenceScreenId = ClientPagePreferenceScreenId
FROM Staff
WHERE StaffId = @LoggedInUserId

--Added by Venkatesh for task #133 in Core Bugs
IF @ClientPagePreferenceScreenId IS NULL
BEGIN
	SET @ClientPagePreferenceScreenId = CASE 
			WHEN @NonStaffUser = 'Y'
				THEN 977
			ELSE 19
			END -- If Non Staff User Default set deafult screen to Summary Page
END

DECLARE @ScreenIds TABLE (
	ScreenId INT
	,ScreenName VARCHAR(100)
	)

INSERT INTO @ScreenIds (
	ScreenId
	,ScreenName
	)
SELECT DISTINCT s.ScreenId
	,s.ScreenName
FROM Screens s
WHERE isnull(s.RecordDeleted, 'N') = 'N'

EXCEPT

(
	SELECT s.ScreenId
		,s.ScreenName
	FROM Screens s
	JOIN DocumentCodes dc ON dc.DocumentCodeId = s.DocumentCodeId
	WHERE isnull(dc.RecordDeleted, 'N') = 'N'
		AND isnull(s.RecordDeleted, 'N') = 'N'
		AND NOT EXISTS (
			SELECT *
			FROM ViewStaffPermissions p
			WHERE p.StaffId = @StaffId
				AND p.PermissionItemId = dc.DocumentCodeId
				AND p.PermissionTemplateType IN (
					5702
					,5924
					)
			) --Altered Code to add 5924 aaron.udelhoven
	
	UNION
	
	SELECT s.ScreenId
		,s.ScreenName
	FROM Screens s
	JOIN Banners b ON b.ScreenId = s.ScreenId
		AND b.active = 'Y' --Added Code aaron.udelhoven
	WHERE isnull(b.RecordDeleted, 'N') = 'N'
		AND isnull(s.RecordDeleted, 'N') = 'N'
		AND (
			(
				@LoggedInUserId = @StaffId
				AND NOT EXISTS (
					SELECT *
					FROM ViewStaffPermissions p
					WHERE p.StaffId = @LoggedInUserId
						AND p.PermissionItemId = b.BannerId
						AND p.PermissionTemplateType = 5703
					)
				)
			OR (
				@LoggedInUserId <> @StaffId
				AND -- Supervisor view      
				NOT EXISTS (
					SELECT *
					FROM ViewStaffRoleSupervisorPermissions p
					WHERE p.StaffId = @LoggedInUserId
						AND p.PermissionItemId = b.BannerId
						AND p.PermissionTemplateType = 5703
					)
				)
			)
	)

--List of Screens the Staff has Access to.    
IF EXISTS (
		SELECT S.ScreenId
		FROM @ScreenIds S
		INNER JOIN Banners B ON S.ScreenId = B.ScreenId
		INNER JOIN Tabs T ON B.TabId = T.TabId
		WHERE ISNULL(B.RecordDeleted, 'N') = 'N'
			AND ISNULL(T.RecordDeleted, 'N') = 'N'
			AND B.Active = 'Y'
			AND s.ScreenId = @HomePageScreenId
		)
BEGIN
	SELECT @HomePageScreenId AS HomePageScreenId
		,@ClientPagePreferenceScreenId AS ClientPagePreferenceScreenId
END
ELSE
BEGIN
	SET @HomePageScreenId = CASE 
			WHEN @NonStaffUser = 'Y'
				THEN 977
			ELSE 17
			END -- When the Staff does not have permission for the Homepage redirect to MyPreferences OR Patient Portal Summary Page.    

	SELECT @HomePageScreenId AS HomePageScreenId
		,@ClientPagePreferenceScreenId AS ClientPagePreferenceScreenId
END

IF (@@error != 0)
BEGIN
	RAISERROR (
			'ssp_PMGetHomePageScreenStaff : An error  occured'
			,16
			,1
			)

	RETURN
END
