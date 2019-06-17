--Created By Vamsi     8/5/2016     Included "Bed Attendences page" screenId to fix the Paging issue.
IF EXISTS (
		SELECT 1
		FROM StaffScreenFilters
		WHERE ScreenId = 601
		)
BEGIN
	DELETE
	FROM StaffScreenFilters
	WHERE ScreenId = 601
END

IF EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [key] = 'ScreenFilterDisabledListPages'
		)
BEGIN
	UPDATE SystemConfigurationKeys
	SET Value = '368,323,601'
	WHERE [key] = 'ScreenFilterDisabledListPages'
END
