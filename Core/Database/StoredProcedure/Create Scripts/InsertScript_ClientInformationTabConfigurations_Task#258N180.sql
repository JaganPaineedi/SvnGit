IF NOT EXISTS (SELECT * FROM ClientInformationTabConfigurations WHERE [TabName] = 'Timeliness' AND ScreenId=969)
BEGIN
	INSERT INTO ClientInformationTabConfigurations(ScreenId,TabName,TabURL,TabType,TabOrder)
	VALUES(969,'Timeliness','/Modules/ClientInformation/Client/Detail/ClientInformationTimelines.ascx','ASPX',17)
END
ELSE
BEGIN
	UPDATE ClientInformationTabConfigurations SET TabURL='/Modules/ClientInformation/Client/Detail/ClientInformationTimelines.ascx',TabType='ASPX' WHERE [TabName] = 'Timeliness' AND ScreenId=969 
END