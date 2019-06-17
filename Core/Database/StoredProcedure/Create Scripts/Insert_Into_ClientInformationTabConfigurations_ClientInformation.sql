IF NOT EXISTS (
		SELECT *
		FROM clientinformationtabconfigurations
		WHERE taburl = '/Modules/ClientInformation/Client/Detail/ClientInformation.ascx'
		)
	INSERT INTO clientinformationtabconfigurations (
		createdby
		,createddate
		,modifiedby
		,modifieddate
		,screenid
		,tabname
		,taburl
		,tabtype
		,formid
		,taborder
		)
	VALUES (
		'SHS-Core'
		,Getdate()
		,'SHS-Core'
		,Getdate()
		,969
		,'General'
		,'/Modules/ClientInformation/Client/Detail/ClientInformation.ascx'
		,'ASPX'
		,NULL
		,1
		)
ELSE
	UPDATE clientinformationtabconfigurations
	SET tabname = 'General'
	WHERE taburl = '/Modules/ClientInformation/Client/Detail/ClientInformation.ascx'

IF NOT EXISTS (
		SELECT *
		FROM clientinformationtabconfigurations
		WHERE taburl = '/Modules/ClientInformation/Client/Detail/Alias.ascx'
		)
	INSERT INTO clientinformationtabconfigurations (
		createdby
		,createddate
		,modifiedby
		,modifieddate
		,screenid
		,tabname
		,taburl
		,tabtype
		,formid
		,taborder
		)
	VALUES (
		'SHS-Core'
		,Getdate()
		,'SHS-Core'
		,Getdate()
		,969
		,'Aliases'
		,'/Modules/ClientInformation/Client/Detail/Alias.ascx'
		,'ASPX'
		,NULL
		,2
		)
ELSE
	UPDATE clientinformationtabconfigurations
	SET tabname = 'Aliases'
	WHERE taburl = '/Modules/ClientInformation/Client/Detail/Alias.ascx'

IF NOT EXISTS (
		SELECT *
		FROM clientinformationtabconfigurations
		WHERE taburl = '/Modules/ClientInformation/Client/Detail/ClientGeneralDemographic.ascx'
		)
	INSERT INTO clientinformationtabconfigurations (
		createdby
		,createddate
		,modifiedby
		,modifieddate
		,screenid
		,tabname
		,taburl
		,tabtype
		,formid
		,taborder
		)
	VALUES (
		'SHS-Core'
		,Getdate()
		,'SHS-Core'
		,Getdate()
		,969
		,'Demographics'
		,'/Modules/ClientInformation/Client/Detail/ClientGeneralDemographic.ascx'
		,'ASPX'
		,NULL
		,3
		)
ELSE
	UPDATE clientinformationtabconfigurations
	SET tabname = 'Demographics'
	WHERE taburl = '/Modules/ClientInformation/Client/Detail/ClientGeneralDemographic.ascx'

IF NOT EXISTS (
		SELECT *
		FROM clientinformationtabconfigurations
		WHERE taburl = '/Modules/ClientInformation/Client/Detail/Hospitalization.ascx'
		)
	INSERT INTO clientinformationtabconfigurations (
		createdby
		,createddate
		,modifiedby
		,modifieddate
		,screenid
		,tabname
		,taburl
		,tabtype
		,formid
		,taborder
		)
	VALUES (
		'SHS-Core'
		,Getdate()
		,'SHS-Core'
		,Getdate()
		,969
		,'Hospitalization'
		,'/Modules/ClientInformation/Client/Detail/Hospitalization.ascx'
		,'ASPX'
		,NULL
		,4
		)
ELSE
	UPDATE clientinformationtabconfigurations
	SET tabname = 'Hospitalization'
	WHERE taburl = '/Modules/ClientInformation/Client/Detail/Hospitalization.ascx'

IF NOT EXISTS (
		SELECT *
		FROM clientinformationtabconfigurations
		WHERE taburl = '/Modules/ClientInformation/Client/Detail/PrimaryCareReferral.ascx'
		)
	INSERT INTO ClientInformationTabConfigurations (
		CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,ScreenId
		,TabName
		,TabURL
		,TabType
		,FormId
		,TabOrder
		)
	VALUES (
		'SHS-Core'
		,GetDate()
		,'SHS-Core'
		,GetDate()
		,969
		,'Primary care referral'
		,'/Modules/ClientInformation/Client/Detail/PrimaryCareReferral.ascx'
		,'ASPX'
		,NULL
		,5
		)
ELSE
	UPDATE clientinformationtabconfigurations
	SET tabname = 'Primary care referral'
	WHERE taburl = '/Modules/ClientInformation/Client/Detail/PrimaryCareReferral.ascx'

IF NOT EXISTS (
		SELECT *
		FROM clientinformationtabconfigurations
		WHERE taburl = '/Modules/ClientInformation/Client/Detail/Financial.ascx'
		)
	INSERT INTO ClientInformationTabConfigurations (
		CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,ScreenId
		,TabName
		,TabURL
		,TabType
		,FormId
		,TabOrder
		)
	VALUES (
		'SHS-Core'
		,GetDate()
		,'SHS-Core'
		,GetDate()
		,969
		,'Financial'
		,'/Modules/ClientInformation/Client/Detail/Financial.ascx'
		,'ASPX'
		,NULL
		,6
		)
ELSE
UPDATE clientinformationtabconfigurations
SET tabname = 'Financial'
WHERE taburl = '/Modules/ClientInformation/Client/Detail/Financial.ascx'

IF NOT EXISTS (
		SELECT *
		FROM clientinformationtabconfigurations
		WHERE taburl = '/Modules/ClientInformation/Client/Detail/RelaseofInformationLog.ascx'
		)
	INSERT INTO ClientInformationTabConfigurations (
		CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,ScreenId
		,TabName
		,TabURL
		,TabType
		,FormId
		,TabOrder
		)
	VALUES (
		'SHS-Core'
		,GetDate()
		,'SHS-Core'
		,GetDate()
		,969
		,'Release of Information Log'
		,'/Modules/ClientInformation/Client/Detail/RelaseofInformationLog.ascx'
		,'ASPX'
		,NULL
		,7
		)
ELSE
UPDATE clientinformationtabconfigurations
SET tabname = 'Release of Information Log'
WHERE taburl = '/Modules/ClientInformation/Client/Detail/RelaseofInformationLog.ascx'

IF NOT EXISTS (
		SELECT *
		FROM clientinformationtabconfigurations
		WHERE taburl = '/Modules/ClientInformation/Client/Detail/Contacts.ascx'
		)
	INSERT INTO ClientInformationTabConfigurations (
		CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,ScreenId
		,TabName
		,TabURL
		,TabType
		,FormId
		,TabOrder
		)
	VALUES (
		'SHS-Core'
		,GetDate()
		,'SHS-Core'
		,GetDate()
		,969
		,'Contacts'
		,'/Modules/ClientInformation/Client/Detail/Contacts.ascx'
		,'ASPX'
		,NULL
		,8
		)

ELSE
UPDATE clientinformationtabconfigurations
SET tabname = 'Contacts'
WHERE taburl = '/Modules/ClientInformation/Client/Detail/Contacts.ascx'


IF NOT EXISTS (
		SELECT *
		FROM clientinformationtabconfigurations
		WHERE taburl = '/Modules/ClientInformation/Client/Detail/SADemographics.ascx'
		)
	INSERT INTO clientinformationtabconfigurations (
		createdby
		,createddate
		,modifiedby
		,modifieddate
		,screenid
		,tabname
		,taburl
		,tabtype
		,formid
		,taborder
		)
	VALUES (
		'SHS-Core'
		,Getdate()
		,'SHS-Core'
		,Getdate()
		,969
		,'SA Demographics'
		,'/Modules/ClientInformation/Client/Detail/SADemographics.ascx'
		,'ASPX'
		,NULL
		,10
		)
ELSE
	UPDATE clientinformationtabconfigurations
	SET tabname = 'SA Demographics'
	WHERE taburl = '/Modules/ClientInformation/Client/Detail/SADemographics.ascx'

