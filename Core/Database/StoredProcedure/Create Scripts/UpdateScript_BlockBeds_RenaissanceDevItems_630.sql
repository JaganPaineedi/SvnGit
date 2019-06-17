DECLARE @DropdownOptions VARCHAR(MAX) = ''
DECLARE @IsExists INT = 1

--Bedboard
SELECT TOP 1 @DropdownOptions = DropdownOptions
FROM BedBoardStatusChangeDropdowns
WHERE BedAssignmentStatus IS NULL
	AND PreviousAssignmentOccupied IS NULL
	AND PreviousAssignmentOnLeave IS NULL
	AND PreviousAssignmentScheduledOnLeave IS NULL
	AND DispositionIsNull IS NULL
	AND NextAssignmentIsNull IS NULL
	AND DropdownOptions IS NOT NULL

IF ISNULL(@DropdownOptions,'') <> ''
BEGIN
	SET @IsExists = CHARINDEX('block bed', @DropdownOptions)

	IF @IsExists = 0
	BEGIN
		UPDATE BedBoardStatusChangeDropdowns
		SET DropdownOptions = @DropdownOptions + ',Block Bed'
		WHERE BedAssignmentStatus IS NULL
			AND PreviousAssignmentOccupied IS NULL
			AND PreviousAssignmentOnLeave IS NULL
			AND PreviousAssignmentScheduledOnLeave IS NULL
			AND DispositionIsNull IS NULL
			AND NextAssignmentIsNull IS NULL
			AND DropdownOptions IS NOT NULL
	END
END

--Bed Census
SET @DropdownOptions = ''
SET @IsExists = 1

SELECT TOP 1 @DropdownOptions = DropdownOptions
FROM BedCensusStatusChangeDropdowns
WHERE BedAssignmentStatus IS NULL
	AND PreviousAssignmentOccupied IS NULL
	AND PreviousAssignmentOnLeave IS NULL
	AND PreviousAssignmentScheduledOnLeave IS NULL
	AND DispositionIsNull IS NULL
	AND NextAssignmentIsNull IS NULL
	AND DropdownOptions IS NOT NULL

IF ISNULL(@DropdownOptions,'') <> ''
BEGIN
	SET @IsExists = CHARINDEX('block bed', @DropdownOptions)

	IF @IsExists = 0
	BEGIN
		UPDATE BedCensusStatusChangeDropdowns
		SET DropdownOptions = @DropdownOptions + ',Block Bed'
		WHERE BedAssignmentStatus IS NULL
			AND PreviousAssignmentOccupied IS NULL
			AND PreviousAssignmentOnLeave IS NULL
			AND PreviousAssignmentScheduledOnLeave IS NULL
			AND DispositionIsNull IS NULL
			AND NextAssignmentIsNull IS NULL
			AND DropdownOptions IS NOT NULL
	END
END

IF NOT EXISTS (
		SELECT 1
		FROM BedBoardStatusChangeDropdowns
		WHERE BedAssignmentStatus = 5009
			AND DropdownOptions = 'Unblock Bed'
		)
BEGIN
	INSERT INTO BedBoardStatusChangeDropdowns (BedAssignmentStatus,DropdownOptions)
	VALUES (5009,'Unblock Bed')
END

IF NOT EXISTS (
		SELECT 1
		FROM BedCensusStatusChangeDropdowns
		WHERE BedAssignmentStatus = 5009
			AND DropdownOptions = 'Unblock Bed'
		)
BEGIN
	INSERT INTO BedCensusStatusChangeDropdowns (BedAssignmentStatus,DropdownOptions)
	VALUES (5009,'Unblock Bed')
END


---------------------------Block Beds Pop-Up Page---------------------------------------
IF NOT EXISTS (
		SELECT *
		FROM screens
		WHERE ScreenId = 1201
		)
BEGIN
	SET IDENTITY_INSERT dbo.Screens ON

	INSERT INTO screens (
		ScreenId
		,ScreenName
		,ScreenType
		,ScreenURL
		,ScreenToolbarURL
		,TabId
		,InitializationStoredProcedure
		,ValidationStoredProcedureUpdate
		,ValidationStoredProcedureComplete
		,WarningStoredProcedureComplete
		,PostUpdateStoredProcedure
		,RefreshPermissionsAfterUpdate
		,DocumentCodeId
		,CustomFieldFormId
		,HelpURL
		,MessageReferenceType
		,PrimaryKeyName
		,WarningStoreProcedureUpdate
		)
	VALUES (
		1201
		,'Block Beds Pop-Up'
		,5761
		,'/BedBoard/Office/Detail/BlockBeds.ascx'
		,NULL
		,1
		,'ssp_InitBlockBedDetails'
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,'../Help/overview.htm'
		,NULL
		,NULL
		,NULL
		)

	SET IDENTITY_INSERT dbo.Screens OFF
END
ELSE
BEGIN
	UPDATE screens
	SET ScreenName = 'Block Beds Pop-Up'
		,ScreenType = 5761
		,ScreenURL = '/BedBoard/Office/Detail/BlockBeds.ascx'
		,ScreenToolbarURL = NULL
		,TabId = 1
		,InitializationStoredProcedure = 'ssp_InitBlockBedDetails'
		,ValidationStoredProcedureUpdate = NULL
		,ValidationStoredProcedureComplete = NULL
		,WarningStoredProcedureComplete = NULL
		,PostUpdateStoredProcedure = NULL
		,RefreshPermissionsAfterUpdate = NULL
		,DocumentCodeId = NULL
		,CustomFieldFormId = NULL
		,HelpURL = '../Help/overview.htm'
		,MessageReferenceType = NULL
		,PrimaryKeyName = NULL
		,WarningStoreProcedureUpdate = NULL
	WHERE ScreenId = 1201
END
GO
---------------------------End----------------------------------------------------------------------

IF NOT EXISTS (
		SELECT *
		FROM GlobalCodes
		WHERE GlobalCodeId = 5009
		)
BEGIN
	SET IDENTITY_INSERT dbo.GlobalCodes ON

	INSERT INTO GlobalCodes (
		GlobalCodeId
		,Category
		,CodeName
		,Code
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		5009
		,'BEDASSIGNMENTSTATUS'
		,'Blocked'
		,'BLOCKED'
		,'Y'
		,'Y'
		,1
		)

	SET IDENTITY_INSERT dbo.GlobalCodes OFF
END

IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'BLOCKEDBEDREASON' AND Category = 'BLOCKEDBEDREASON')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('BLOCKEDBEDREASON','BLOCKEDBEDREASON','Y','Y','Y','Y','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'BLOCKEDBEDREASON' ,CategoryName = 'BLOCKEDBEDREASON',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'BLOCKEDBEDREASON' AND Category = 'BLOCKEDBEDREASON'
END
