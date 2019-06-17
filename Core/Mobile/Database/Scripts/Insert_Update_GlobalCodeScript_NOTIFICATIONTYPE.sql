IF NOT EXISTS (
		SELECT Category
		FROM GlobalCodeCategories
		WHERE Category = 'NOTIFICATIONTYPE'
		)
BEGIN
	INSERT INTO GlobalCodeCategories (
		Category
		,CategoryName
		,Active
		,AllowAddDelete
		,AllowCodeNameEdit
		,AllowSortOrderEdit
		,Description
		,UserDefinedCategory
		,HasSubcodes
		,UsedInPracticeManagement
		)
	VALUES (
		'NOTIFICATIONTYPE'
		,'Notification Type'
		,'Y'
		,'N'
		,'N'
		,'N'
		,NULL
		,'N'
		,'N'
		,'Y'
		)
END

IF NOT EXISTS (
		SELECT GlobalCodeId
		FROM GlobalCodes
		WHERE Category = 'NOTIFICATIONTYPE'
			AND CodeName = 'Reception'
			AND Code = 'NOTIFIACTIONTYPERECEPTION'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		)
	VALUES (
		'NOTIFICATIONTYPE'
		,'Reception'
		,'NOTIFIACTIONTYPERECEPTION'
		,'To Notify the Staff when the service Status change to Show Status'
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
GO

IF NOT EXISTS (
		SELECT GlobalCodeId
		FROM GlobalCodes
		WHERE Category = 'NOTIFICATIONTYPE'
			AND Code = 'NOTIFIACTIONTYPEALERT'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		)
	VALUES (
		'NOTIFICATIONTYPE'
		,'Alert'
		,'NOTIFIACTIONTYPEALERT'
		,'Alert Notifications'
		,'Y'
		,'Y'
		,2
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
GO

IF NOT EXISTS (
		SELECT GlobalCodeId
		FROM GlobalCodes
		WHERE Category = 'NOTIFICATIONTYPE'
			AND CodeName = 'Message'
			AND Code = 'NOTIFIACTIONTYPMESSAGE'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		)
	VALUES (
		'NOTIFICATIONTYPE'
		,'Message'
		,'NOTIFIACTIONTYPMESSAGE'
		,'Message Notifications'
		,'Y'
		,'Y'
		,3
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
GO