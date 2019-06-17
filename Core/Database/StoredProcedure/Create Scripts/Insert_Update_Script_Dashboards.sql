IF NOT EXISTS (
		SELECT 1
		FROM [MobileDashboards]
		WHERE [RedirectUrl] = '#/caseloads'
			AND Active = 'Y'
		)
BEGIN
	INSERT INTO [MobileDashboards] (
		[DashboardName]
		,[DashboardImage]
		,[RedirectUrl]
		,[ShowInMyPreference]
		,[Active]
		)
	VALUES (
		'My Caseload'
		,'images/caseload.png'
		,'#/caseloads'
		,'Y'
		,'Y'
		)
END
ELSE
BEGIN
	UPDATE [MobileDashboards]
	SET [DashboardName] = 'My Caseload'
		,[DashboardImage] = 'images/caseload.png'
		,[ShowInMyPreference] = 'Y'
		,[Active] = 'Y'
	WHERE [RedirectUrl] = '#/caseloads'
END

IF NOT EXISTS (
		SELECT 1
		FROM [MobileDashboards]
		WHERE [RedirectUrl] = '#/mycalendar'
			AND Active = 'Y'
		)
BEGIN
	INSERT INTO [MobileDashboards] (
		[DashboardName]
		,[DashboardImage]
		,[RedirectUrl]
		,[ShowInMyPreference]
		,[Active]
		)
	VALUES (
		'My Calendar'
		,'images/calendar.png'
		,'#/mycalendar'
		,'Y'
		,'Y'
		)
END
ELSE
BEGIN
	UPDATE [MobileDashboards]
	SET [DashboardName] = 'My Calendar'
		,[DashboardImage] = 'images/calendar.png'
		,[ShowInMyPreference] = 'Y'
		,[Active] = 'Y'
	WHERE [RedirectUrl] = '#/mycalendar'
END

IF NOT EXISTS (
		SELECT 1
		FROM [MobileDashboards]
		WHERE [RedirectUrl] = '#/teamcalendar'
			AND Active = 'Y'
		)
BEGIN
	INSERT INTO [MobileDashboards] (
		[DashboardName]
		,[DashboardImage]
		,[RedirectUrl]
		,[ShowInMyPreference]
		,[Active]
		)
	VALUES (
		'Team Calendar'
		,'images/calendar_group.png'
		,'#/teamcalendar'
		,'Y'
		,'Y'
		)
END
ELSE
BEGIN
	UPDATE [MobileDashboards]
	SET [DashboardName] = 'Team Calendar'
		,[DashboardImage] = 'images/calendar_group.png'
		,[ShowInMyPreference] = 'Y'
		,[Active] = 'Y'
	WHERE [RedirectUrl] = '#/teamcalendar'
END

IF NOT EXISTS (
		SELECT 1
		FROM [MobileDashboards]
		WHERE [RedirectUrl] = '#/createservice'
			AND Active = 'Y'
		)
BEGIN
	INSERT INTO [MobileDashboards] (
		[DashboardName]
		,[DashboardImage]
		,[RedirectUrl]
		,[ShowInMyPreference]
		,[Active]
		)
	VALUES (
		'Create Service'
		,'images/create_service.png'
		,'#/createservice'
		,'Y'
		,'Y'
		)
END
ELSE
BEGIN
	UPDATE [MobileDashboards]
	SET [DashboardName] = 'Create Service'
		,[DashboardImage] = 'images/create_service.png'
		,[ShowInMyPreference] = 'Y'
		,[Active] = 'Y'
	WHERE [RedirectUrl] = '#/createservice'
END

IF NOT EXISTS (
		SELECT *
		FROM [MobileOrigins]
		WHERE [Name] = 'SmartCare'
			AND Active = 'Y'
		)
BEGIN
	INSERT INTO [MobileOrigins] (
		[OriginSecret]
		,[Name]
		,[ApplicationType]
		,[Active]
		,[RefreshTokenLifeTime]
		,[AllowedOrigin]
		)
	VALUES (
		'TEST'
		,'SmartCare'
		,0
		,'Y'
		,30
		,''
		)
END
ELSE
BEGIN
	UPDATE [MobileOrigins]
	SET [OriginSecret] = 'TEST'
		,[ApplicationType] = 0
		,[Active] = 'Y'
		,[RefreshTokenLifeTime] = 30
		,[AllowedOrigin] = ''
	WHERE [Name] = 'SmartCare'
END