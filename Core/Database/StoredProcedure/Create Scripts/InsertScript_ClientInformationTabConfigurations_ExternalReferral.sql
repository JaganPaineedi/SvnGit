IF NOT EXISTS (
		SELECT *
		FROM ClientInformationTabConfigurations
		WHERE TabName = 'External Referral'
		)
BEGIN
	INSERT INTO ClientInformationTabConfigurations (
		ScreenId
		,TabName
		,TabURL
		,TabType
		,TabOrder
		)
	VALUES (
		969
		,'External Referral'
		,'/Modules/ClientInformation/Client/Detail/ExternalReferral.ascx'
		,'ASPX'
		,15
		)
END